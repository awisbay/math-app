import { Injectable, Logger, UnprocessableEntityException } from '@nestjs/common';
import { QuestionRepository } from '../../repositories/question.repository';
import { UserActivityRepository } from '../../repositories/user-activity.repository';
import { Question, QualityStatus } from '@prisma/client';

export interface DifficultyBucket {
  minDifficulty: number;
  maxDifficulty: number;
  count: number;
}

export interface SelectionPolicy {
  totalQuestions: number;
  difficultyBuckets: DifficultyBucket[];
  maxQuestionsPerTopic: number;
  minTopicsPerSession: number;
  antiRepeatWindowDays: number;
}

export interface SelectedQuestion {
  id: string;
  question: string;
  options: string[];
  correctAnswer: number;
  difficulty: number;
  topicId: string;
  source: 'bank' | 'variant' | 'generated';
  timeLimit: number;
}

@Injectable()
export class QuestionSelectionService {
  private readonly logger = new Logger(QuestionSelectionService.name);

  constructor(
    private questionRepo: QuestionRepository,
    private userActivityRepo: UserActivityRepository,
  ) {}

  /**
   * Load default policy for grade
   */
  getPolicyForGrade(grade: number): SelectionPolicy {
    // Default distribution: 4 easy, 4 medium, 2 hard
    let buckets: DifficultyBucket[] = [
      { minDifficulty: 1, maxDifficulty: 2, count: 4 },
      { minDifficulty: 3, maxDifficulty: 3, count: 4 },
      { minDifficulty: 4, maxDifficulty: 5, count: 2 },
    ];

    // Adjust for lower grades (1-3): more easy, less hard
    if (grade <= 3) {
      buckets = [
        { minDifficulty: 1, maxDifficulty: 2, count: 5 },
        { minDifficulty: 3, maxDifficulty: 3, count: 4 },
        { minDifficulty: 4, maxDifficulty: 5, count: 1 },
      ];
    }

    // Adjust for higher grades (10-12): allow more hard
    if (grade >= 10) {
      buckets = [
        { minDifficulty: 1, maxDifficulty: 2, count: 3 },
        { minDifficulty: 3, maxDifficulty: 3, count: 4 },
        { minDifficulty: 4, maxDifficulty: 5, count: 3 },
      ];
    }

    return {
      totalQuestions: 10,
      difficultyBuckets: buckets,
      maxQuestionsPerTopic: 4,
      minTopicsPerSession: 3,
      antiRepeatWindowDays: 30,
    };
  }

  /**
   * Select questions for a session
   */
  async selectQuestions(
    userId: string,
    grade: number,
    policy?: SelectionPolicy,
  ): Promise<SelectedQuestion[]> {
    const startTime = Date.now();
    const selectedPolicy = policy || this.getPolicyForGrade(grade);

    this.logger.log(
      `[QuestionSelection] Starting selection for user=${userId}, grade=${grade}`,
    );

    // Get anti-repeat history
    const since = new Date();
    since.setDate(since.getDate() - selectedPolicy.antiRepeatWindowDays);
    
    const seenQuestionIds = await this.userActivityRepo.getSeenQuestionIds(
      userId,
      { since, limit: 1000 },
    );

    this.logger.log(
      `[QuestionSelection] Excluding ${seenQuestionIds.length} recently seen questions`,
    );

    // Try to select questions with fallback tiers
    let selected = await this.trySelectQuestions(
      grade,
      selectedPolicy,
      seenQuestionIds,
    );

    // If not enough, try with relaxed anti-repeat (14 days)
    if (selected.length < selectedPolicy.totalQuestions) {
      this.logger.warn(
        `[QuestionSelection] Pool insufficient with 30d window, trying 14d`,
      );
      
      const since14d = new Date();
      since14d.setDate(since14d.getDate() - 14);
      const seen14d = await this.userActivityRepo.getSeenQuestionIds(userId, {
        since: since14d,
        limit: 500,
      });

      selected = await this.trySelectQuestions(
        grade,
        selectedPolicy,
        seen14d,
        selected,
      );
    }

    // If still not enough, try with 7 days
    if (selected.length < selectedPolicy.totalQuestions) {
      this.logger.warn(
        `[QuestionSelection] Pool insufficient with 14d window, trying 7d`,
      );
      
      const since7d = new Date();
      since7d.setDate(since7d.getDate() - 7);
      const seen7d = await this.userActivityRepo.getSeenQuestionIds(userId, {
        since: since7d,
        limit: 200,
      });

      selected = await this.trySelectQuestions(
        grade,
        selectedPolicy,
        seen7d,
        selected,
      );
    }

    // Final deduplication and trim
    selected = this.deduplicateAndTrim(selected, selectedPolicy.totalQuestions);

    const duration = Date.now() - startTime;
    this.logger.log(
      `[QuestionSelection] Completed in ${duration}ms, selected ${selected.length} questions`,
    );

    if (selected.length < selectedPolicy.totalQuestions) {
      throw new UnprocessableEntityException({
        code: 'SESSION_POOL_INSUFFICIENT',
        message: `Soal belum tersedia cukup. Hanya ${selected.length} dari ${selectedPolicy.totalQuestions} soal tersedia.`,
      });
    }

    return selected;
  }

  private async trySelectQuestions(
    grade: number,
    policy: SelectionPolicy,
    excludeIds: string[],
    existingSelection: SelectedQuestion[] = [],
  ): Promise<SelectedQuestion[]> {
    const selected = [...existingSelection];
    const selectedIds = new Set(selected.map((q) => q.id));
    const topicCounts: Record<string, number> = {};

    // Count existing topics
    for (const q of selected) {
      topicCounts[q.topicId] = (topicCounts[q.topicId] || 0) + 1;
    }

    // Fill each difficulty bucket
    for (const bucket of policy.difficultyBuckets) {
      const needed = bucket.count - this.countInBucket(selected, bucket);
      if (needed <= 0) continue;

      // Get candidates for this bucket
      const candidates = await this.getCandidatesForBucket(
        grade,
        bucket,
        excludeIds,
        selectedIds,
      );

      // Select with topic spread
      const picked = this.selectWithTopicSpread(
        candidates,
        needed,
        topicCounts,
        policy.maxQuestionsPerTopic,
      );

      for (const q of picked) {
        if (!selectedIds.has(q.id)) {
          selected.push(q);
          selectedIds.add(q.id);
          topicCounts[q.topicId] = (topicCounts[q.topicId] || 0) + 1;
        }
      }
    }

    return selected;
  }

  private async getCandidatesForBucket(
    grade: number,
    bucket: DifficultyBucket,
    excludeIds: string[],
    selectedIds: Set<string>,
  ): Promise<SelectedQuestion[]> {
    const questions = await this.questionRepo.findMany({
      grade,
      qualityStatus: QualityStatus.APPROVED,
      excludeIds: [...excludeIds, ...Array.from(selectedIds)],
    });

    // Filter by difficulty range
    const filtered = questions.filter(
      (q) =>
        q.difficulty >= bucket.minDifficulty &&
        q.difficulty <= bucket.maxDifficulty,
    );

    // Shuffle
    return this.shuffleArray(filtered).map((q) => this.mapToSelected(q));
  }

  private selectWithTopicSpread(
    candidates: SelectedQuestion[],
    needed: number,
    topicCounts: Record<string, number>,
    maxPerTopic: number,
  ): SelectedQuestion[] {
    const selected: SelectedQuestion[] = [];

    // Sort candidates to prefer topics with fewer selections
    const sorted = [...candidates].sort((a, b) => {
      const countA = topicCounts[a.topicId] || 0;
      const countB = topicCounts[b.topicId] || 0;
      return countA - countB;
    });

    for (const q of sorted) {
      if (selected.length >= needed) break;

      const topicCount = topicCounts[q.topicId] || 0;
      if (topicCount < maxPerTopic) {
        selected.push(q);
        topicCounts[q.topicId] = topicCount + 1;
      }
    }

    return selected;
  }

  private countInBucket(
    selected: SelectedQuestion[],
    bucket: DifficultyBucket,
  ): number {
    return selected.filter(
      (q) =>
        q.difficulty >= bucket.minDifficulty &&
        q.difficulty <= bucket.maxDifficulty,
    ).length;
  }

  private deduplicateAndTrim(
    selected: SelectedQuestion[],
    maxCount: number,
  ): SelectedQuestion[] {
    const seen = new Set<string>();
    const unique: SelectedQuestion[] = [];

    for (const q of selected) {
      if (!seen.has(q.id)) {
        seen.add(q.id);
        unique.push(q);

        if (unique.length >= maxCount) break;
      }
    }

    return unique;
  }

  private mapToSelected(question: Question): SelectedQuestion {
    return {
      id: question.id,
      question: question.question,
      options: question.options,
      correctAnswer: question.correctAnswer,
      difficulty: question.difficulty,
      topicId: question.topicId,
      source: 'bank',
      timeLimit: question.timeLimit,
    };
  }

  private shuffleArray<T>(array: T[]): T[] {
    const shuffled = [...array];
    for (let i = shuffled.length - 1; i > 0; i--) {
      const j = Math.floor(Math.random() * (i + 1));
      [shuffled[i], shuffled[j]] = [shuffled[j], shuffled[i]];
    }
    return shuffled;
  }
}
