import {
  Injectable,
  Logger,
  NotFoundException,
  BadRequestException,
  ForbiddenException,
} from '@nestjs/common';
import { PrismaService } from '../../common/prisma.service';
import { SessionRepository } from '../../repositories/session.repository';
import { UserActivityRepository } from '../../repositories/user-activity.repository';
import { QuestionSelectionService } from './question-selection.service';
import { Session, SessionStatus, QuestionRefType } from '@prisma/client';

export interface CreateSessionDto {
  grade?: number;
}

export interface SubmitAnswerDto {
  sessionQuestionId: string;
  selectedOption: number;
  timeSpentSeconds: number;
}

export interface SessionResult {
  sessionId: string;
  score: number;
  totalQuestions: number;
  correctAnswers: number;
  timeSpent: number;
  percentage: number;
  completedAt: Date;
}

@Injectable()
export class SessionService {
  private readonly logger = new Logger(SessionService.name);
  private readonly SESSION_DURATION = 900; // 15 minutes
  private readonly TOTAL_QUESTIONS = 10;

  constructor(
    private prisma: PrismaService,
    private sessionRepo: SessionRepository,
    private userActivityRepo: UserActivityRepository,
    private selectionService: QuestionSelectionService,
  ) {}

  /**
   * Create a new quiz session
   */
  async createSession(
    userId: string,
    userGrade: number,
    dto?: CreateSessionDto,
  ): Promise<Session> {
    const startTime = Date.now();
    const targetGrade = dto?.grade || userGrade;

    this.logger.log(
      `[Session] Creating session for user=${userId}, grade=${targetGrade}`,
    );

    // Check for existing active session
    const existingSession = await this.sessionRepo.findActiveByUser(userId);
    if (existingSession) {
      this.logger.warn(
        `[Session] User ${userId} already has active session ${existingSession.id}`,
      );
      throw new BadRequestException({
        code: 'ACTIVE_SESSION_EXISTS',
        message: 'Anda masih memiliki sesi aktif',
        details: { sessionId: existingSession.id },
      });
    }

    // Select questions
    const questions = await this.selectionService.selectQuestions(
      userId,
      targetGrade,
    );

    // Calculate expiration
    const expiresAt = new Date();
    expiresAt.setSeconds(expiresAt.getSeconds() + this.SESSION_DURATION);

    // Create session and questions atomically
    const session = await this.prisma.$transaction(async (tx) => {
      // Create session
      const newSession = await tx.session.create({
        data: {
          userId,
          grade: targetGrade,
          status: SessionStatus.ACTIVE,
          totalQuestions: this.TOTAL_QUESTIONS,
          durationSeconds: this.SESSION_DURATION,
          expiresAt,
        },
      });

      // Create session questions
      await tx.sessionQuestion.createMany({
        data: questions.map((q, index) => ({
          sessionId: newSession.id,
          ordinal: index + 1,
          refType: QuestionRefType.QUESTION,
          questionId: q.id,
          questionSnapshot: {
            question: q.question,
            options: q.options,
            correctAnswer: q.correctAnswer,
            difficulty: q.difficulty,
            timeLimit: q.timeLimit,
          },
        })),
      });

      // Record in history for anti-repeat
      await tx.userQuestionHistory.createMany({
        data: questions.map((q) => ({
          userId,
          refType: QuestionRefType.QUESTION,
          questionId: q.id,
          sessionId: newSession.id,
        })),
      });

      return newSession;
    });

    const duration = Date.now() - startTime;
    this.logger.log(
      `[Session] Created session ${session.id} in ${duration}ms`,
    );

    return session;
  }

  /**
   * Get session with questions
   */
  async getSession(sessionId: string, userId: string): Promise<Session> {
    const session = await this.sessionRepo.findById(sessionId);

    if (!session) {
      throw new NotFoundException({
        code: 'SESSION_NOT_FOUND',
        message: 'Sesi tidak ditemukan',
      });
    }

    if (session.userId !== userId) {
      throw new ForbiddenException({
        code: 'ACCESS_DENIED',
        message: 'Anda tidak memiliki akses ke sesi ini',
      });
    }

    // Check expiration
    if (
      session.status === SessionStatus.ACTIVE &&
      new Date() > session.expiresAt
    ) {
      await this.sessionRepo.expire(sessionId);
      session.status = SessionStatus.EXPIRED;
    }

    return session;
  }

  /**
   * Submit an answer for a question
   */
  async submitAnswer(
    sessionId: string,
    userId: string,
    dto: SubmitAnswerDto,
  ): Promise<void> {
    const session = await this.getSession(sessionId, userId);

    if (session.status !== SessionStatus.ACTIVE) {
      throw new BadRequestException({
        code: 'SESSION_NOT_ACTIVE',
        message: 'Sesi sudah tidak aktif',
      });
    }

    // Find the session question
    const sessionQuestion = session.sessionQuestions.find(
      (sq) => sq.id === dto.sessionQuestionId,
    );

    if (!sessionQuestion) {
      throw new NotFoundException({
        code: 'QUESTION_NOT_FOUND',
        message: 'Pertanyaan tidak ditemukan dalam sesi',
      });
    }

    if (sessionQuestion.answer) {
      // Already answered - update it (idempotent)
      this.logger.warn(
        `[Session] Question ${dto.sessionQuestionId} already answered, updating`,
      );
    }

    // Check correctness from snapshot
    const snapshot = sessionQuestion.questionSnapshot as any;
    const isCorrect = dto.selectedOption === snapshot.correctAnswer;

    // Save answer
    await this.sessionRepo.saveAnswer({
      sessionQuestionId: dto.sessionQuestionId,
      userId,
      selectedOption: dto.selectedOption,
      isCorrect,
      timeSpentSeconds: dto.timeSpentSeconds,
    });

    // Update topic mastery
    if (sessionQuestion.questionId) {
      await this.userActivityRepo.updateTopicMastery(
        userId,
        sessionQuestion.question?.topicId || '',
        session.grade,
        isCorrect,
      );
    }

    this.logger.log(
      `[Session] Answer submitted for session=${sessionId}, question=${dto.sessionQuestionId}, correct=${isCorrect}`,
    );
  }

  /**
   * Complete/finalize a session
   */
  async completeSession(
    sessionId: string,
    userId: string,
  ): Promise<SessionResult> {
    const session = await this.getSession(sessionId, userId);

    if (session.status === SessionStatus.COMPLETED) {
      // Return cached result
      return this.buildResult(session);
    }

    if (session.status !== SessionStatus.ACTIVE) {
      throw new BadRequestException({
        code: 'SESSION_NOT_ACTIVE',
        message: 'Sesi tidak dapat diselesaikan',
      });
    }

    // Calculate results
    const answers = session.sessionQuestions
      .map((sq) => sq.answer)
      .filter(Boolean);

    const correctAnswers = answers.filter((a) => a?.isCorrect).length;
    const totalTimeSpent = answers.reduce(
      (sum, a) => sum + (a?.timeSpentSeconds || 0),
      0,
    );

    // Complete session
    const completedSession = await this.sessionRepo.complete(sessionId, {
      score: correctAnswers,
      correctAnswers,
      totalTimeSpent,
    });

    // Record daily activity for streak
    await this.userActivityRepo.recordSessionCompletion(userId, new Date(), {
      questions: this.TOTAL_QUESTIONS,
      correctAnswers,
      timeSpent: totalTimeSpent,
    });

    this.logger.log(
      `[Session] Completed session ${sessionId}, score=${correctAnswers}/${this.TOTAL_QUESTIONS}`,
    );

    return this.buildResult(completedSession);
  }

  /**
   * Auto-submit expired sessions
   */
  async autoSubmitExpiredSessions(): Promise<number> {
    const expiredSessions = await this.prisma.session.findMany({
      where: {
        status: SessionStatus.ACTIVE,
        expiresAt: {
          lt: new Date(),
        },
      },
    });

    let count = 0;
    for (const session of expiredSessions) {
      try {
        await this.completeSession(session.id, session.userId);
        count++;
      } catch (error) {
        this.logger.error(
          `[Session] Failed to auto-submit session ${session.id}`,
          error,
        );
      }
    }

    this.logger.log(`[Session] Auto-submitted ${count} expired sessions`);
    return count;
  }

  /**
   * Abandon a session
   */
  async abandonSession(
    sessionId: string,
    userId: string,
  ): Promise<void> {
    const session = await this.getSession(sessionId, userId);

    if (session.status !== SessionStatus.ACTIVE) {
      throw new BadRequestException({
        code: 'SESSION_NOT_ACTIVE',
        message: 'Sesi sudah tidak aktif',
      });
    }

    await this.sessionRepo.abandon(sessionId);

    this.logger.log(`[Session] Abandoned session ${sessionId}`);
  }

  private buildResult(session: Session): SessionResult {
    const totalQuestions = session.totalQuestions;
    const correctAnswers = session.correctAnswers || 0;

    return {
      sessionId: session.id,
      score: correctAnswers,
      totalQuestions,
      correctAnswers,
      timeSpent: session.totalTimeSpent || 0,
      percentage: Math.round((correctAnswers / totalQuestions) * 100),
      completedAt: session.completedAt!,
    };
  }
}
