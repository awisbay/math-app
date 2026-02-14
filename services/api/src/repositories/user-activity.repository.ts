import { Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import {
  UserQuestionHistory,
  UserDailyActivity,
  UserTopicMastery,
  QuestionRefType,
  Prisma,
} from '@prisma/client';

@Injectable()
export class UserActivityRepository {
  constructor(private prisma: PrismaService) {}

  // ============================================
  // Question History (Anti-repeat)
  // ============================================

  async getSeenQuestionIds(
    userId: string,
    options?: {
      since?: Date;
      limit?: number;
    },
  ): Promise<string[]> {
    const history = await this.prisma.userQuestionHistory.findMany({
      where: {
        userId,
        refType: QuestionRefType.QUESTION,
        ...(options?.since ? { seenAt: { gte: options.since } } : {}),
      },
      take: options?.limit,
      orderBy: { seenAt: 'desc' },
      select: { questionId: true },
    });

    return history.map((h) => h.questionId!).filter(Boolean);
  }

  async recordQuestionSeen(
    userId: string,
    data: {
      refType: QuestionRefType;
      questionId?: string;
      variantId?: string;
      sessionId?: string;
      wasCorrect?: boolean;
    },
  ): Promise<UserQuestionHistory> {
    return this.prisma.userQuestionHistory.create({
      data: {
        userId,
        refType: data.refType,
        questionId: data.questionId,
        variantId: data.variantId,
        sessionId: data.sessionId,
        wasCorrect: data.wasCorrect,
      },
    });
  }

  async recordQuestionsSeen(
    userId: string,
    items: Array<{
      refType: QuestionRefType;
      questionId?: string;
      variantId?: string;
      sessionId?: string;
    }>,
  ): Promise<void> {
    await this.prisma.userQuestionHistory.createMany({
      data: items.map((item) => ({
        userId,
        refType: item.refType,
        questionId: item.questionId,
        variantId: item.variantId,
        sessionId: item.sessionId,
      })),
    });
  }

  // ============================================
  // Daily Activity (Streak)
  // ============================================

  async getDailyActivity(
    userId: string,
    date: Date,
  ): Promise<UserDailyActivity | null> {
    const startOfDay = new Date(date);
    startOfDay.setHours(0, 0, 0, 0);

    return this.prisma.userDailyActivity.findUnique({
      where: {
        userId_activityDate: {
          userId,
          activityDate: startOfDay,
        },
      },
    });
  }

  async getRecentActivity(
    userId: string,
    days: number,
  ): Promise<UserDailyActivity[]> {
    const since = new Date();
    since.setDate(since.getDate() - days);
    since.setHours(0, 0, 0, 0);

    return this.prisma.userDailyActivity.findMany({
      where: {
        userId,
        activityDate: {
          gte: since,
        },
      },
      orderBy: { activityDate: 'desc' },
    });
  }

  async recordSessionCompletion(
    userId: string,
    date: Date,
    data: {
      questions: number;
      correctAnswers: number;
      timeSpent: number;
    },
  ): Promise<UserDailyActivity> {
    const activityDate = new Date(date);
    activityDate.setHours(0, 0, 0, 0);

    return this.prisma.userDailyActivity.upsert({
      where: {
        userId_activityDate: {
          userId,
          activityDate,
        },
      },
      update: {
        completedSessions: { increment: 1 },
        totalQuestions: { increment: data.questions },
        correctAnswers: { increment: data.correctAnswers },
        totalTimeSpent: { increment: data.timeSpent },
      },
      create: {
        userId,
        activityDate,
        completedSessions: 1,
        totalQuestions: data.questions,
        correctAnswers: data.correctAnswers,
        totalTimeSpent: data.timeSpent,
      },
    });
  }

  // ============================================
  // Topic Mastery
  // ============================================

  async getTopicMastery(
    userId: string,
    topicId: string,
  ): Promise<UserTopicMastery | null> {
    return this.prisma.userTopicMastery.findUnique({
      where: {
        userId_topicId: {
          userId,
          topicId,
        },
      },
      include: { topic: true },
    });
  }

  async getTopicMasteryByGrade(
    userId: string,
    grade: number,
  ): Promise<UserTopicMastery[]> {
    return this.prisma.userTopicMastery.findMany({
      where: {
        userId,
        grade,
      },
      include: { topic: true },
      orderBy: { masteryScore: 'desc' },
    });
  }

  async updateTopicMastery(
    userId: string,
    topicId: string,
    grade: number,
    isCorrect: boolean,
  ): Promise<UserTopicMastery> {
    const mastery = await this.prisma.userTopicMastery.findUnique({
      where: {
        userId_topicId: {
          userId,
          topicId,
        },
      },
    });

    if (mastery) {
      // Update existing
      const newAttempts = mastery.totalAttempts + 1;
      const newCorrect = mastery.correctAttempts + (isCorrect ? 1 : 0);
      const newMasteryScore = (newCorrect / newAttempts) * 100;

      return this.prisma.userTopicMastery.update({
        where: {
          userId_topicId: {
            userId,
            topicId,
          },
        },
        data: {
          totalAttempts: newAttempts,
          correctAttempts: newCorrect,
          masteryScore: newMasteryScore,
          lastPracticedAt: new Date(),
        },
      });
    } else {
      // Create new
      return this.prisma.userTopicMastery.create({
        data: {
          userId,
          topicId,
          grade,
          totalAttempts: 1,
          correctAttempts: isCorrect ? 1 : 0,
          masteryScore: isCorrect ? 100 : 0,
          lastPracticedAt: new Date(),
        },
      });
    }
  }
}
