import { Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import { Session, SessionStatus, Prisma } from '@prisma/client';

export interface SessionFilter {
  userId?: string;
  grade?: number;
  status?: SessionStatus;
}

export interface CreateSessionData {
  userId: string;
  grade: number;
  totalQuestions?: number;
  durationSeconds?: number;
  expiresAt: Date;
}

@Injectable()
export class SessionRepository {
  constructor(private prisma: PrismaService) {}

  async findById(id: string): Promise<Session | null> {
    return this.prisma.session.findUnique({
      where: { id },
      include: {
        sessionQuestions: {
          include: {
            answer: true,
            question: { select: { topicId: true } },
          },
          orderBy: { ordinal: 'asc' },
        },
      },
    });
  }

  async findActiveByUser(userId: string): Promise<Session | null> {
    return this.prisma.session.findFirst({
      where: {
        userId,
        status: SessionStatus.ACTIVE,
        expiresAt: {
          gt: new Date(),
        },
      },
      include: {
        sessionQuestions: {
          orderBy: { ordinal: 'asc' },
        },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findMany(
    filter: SessionFilter,
    options?: {
      skip?: number;
      take?: number;
      orderBy?: Prisma.SessionOrderByWithRelationInput;
    },
  ): Promise<Session[]> {
    const where = this.buildWhereClause(filter);

    return this.prisma.session.findMany({
      where,
      skip: options?.skip,
      take: options?.take,
      orderBy: options?.orderBy ?? { startedAt: 'desc' },
      include: {
        _count: {
          select: { sessionQuestions: true },
        },
      },
    });
  }

  async count(filter: SessionFilter): Promise<number> {
    return this.prisma.session.count({ where: this.buildWhereClause(filter) });
  }

  async create(data: CreateSessionData): Promise<Session> {
    return this.prisma.session.create({
      data: {
        userId: data.userId,
        grade: data.grade,
        totalQuestions: data.totalQuestions ?? 10,
        durationSeconds: data.durationSeconds ?? 900,
        expiresAt: data.expiresAt,
        status: SessionStatus.ACTIVE,
      },
    });
  }

  async complete(
    id: string,
    data: {
      score: number;
      correctAnswers: number;
      totalTimeSpent: number;
    },
  ): Promise<Session> {
    return this.prisma.session.update({
      where: { id },
      data: {
        status: SessionStatus.COMPLETED,
        score: data.score,
        correctAnswers: data.correctAnswers,
        totalTimeSpent: data.totalTimeSpent,
        completedAt: new Date(),
      },
    });
  }

  async expire(id: string): Promise<Session> {
    return this.prisma.session.update({
      where: { id },
      data: {
        status: SessionStatus.EXPIRED,
      },
    });
  }

  async abandon(id: string): Promise<Session> {
    return this.prisma.session.update({
      where: { id },
      data: {
        status: SessionStatus.ABANDONED,
      },
    });
  }

  async update(id: string, data: Prisma.SessionUpdateInput): Promise<Session> {
    return this.prisma.session.update({
      where: { id },
      data,
    });
  }

  async delete(id: string): Promise<Session> {
    return this.prisma.session.delete({
      where: { id },
    });
  }

  async addSessionQuestions(
    sessionId: string,
    questions: Array<{
      ordinal: number;
      refType: 'QUESTION' | 'VARIANT';
      questionId?: string;
      variantId?: string;
      questionSnapshot?: any;
    }>,
  ): Promise<void> {
    await this.prisma.sessionQuestion.createMany({
      data: questions.map((q) => ({
        sessionId,
        ordinal: q.ordinal,
        refType: q.refType,
        questionId: q.questionId,
        variantId: q.variantId,
        questionSnapshot: q.questionSnapshot,
      })),
    });
  }

  async saveAnswer(data: {
    sessionQuestionId: string;
    userId: string;
    selectedOption: number;
    isCorrect: boolean;
    timeSpentSeconds: number;
  }): Promise<void> {
    await this.prisma.sessionAnswer.upsert({
      where: { sessionQuestionId: data.sessionQuestionId },
      create: {
        sessionQuestionId: data.sessionQuestionId,
        userId: data.userId,
        selectedOption: data.selectedOption,
        isCorrect: data.isCorrect,
        timeSpentSeconds: data.timeSpentSeconds,
      },
      update: {
        selectedOption: data.selectedOption,
        isCorrect: data.isCorrect,
        timeSpentSeconds: data.timeSpentSeconds,
        answeredAt: new Date(),
      },
    });
  }

  async getUserStats(userId: string): Promise<{
    totalSessions: number;
    completedSessions: number;
    averageScore: number;
  }> {
    const [result, completedCount] = await Promise.all([
      this.prisma.session.aggregate({
        where: { userId },
        _count: { id: true },
        _avg: { score: true },
      }),
      this.prisma.session.count({
        where: {
          userId,
          status: SessionStatus.COMPLETED,
        },
      }),
    ]);

    return {
      totalSessions: result._count.id,
      completedSessions: completedCount,
      averageScore: result._avg.score ?? 0,
    };
  }

  private buildWhereClause(filter: SessionFilter): Prisma.SessionWhereInput {
    const where: Prisma.SessionWhereInput = {
      ...(filter.userId && { userId: filter.userId }),
      ...(filter.grade !== undefined && { grade: filter.grade }),
      ...(filter.status && { status: filter.status }),
    };

    return where;
  }
}
