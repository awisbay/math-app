import { Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';

interface HistoryQueryParams {
  page: number;
  limit: number;
  grade?: number;
}

@Injectable()
export class ProgressService {
  constructor(private prisma: PrismaService) {}

  async getProgress() {
    // Implementation in Phase 2
    return {
      success: true,
      data: {
        overall: {
          totalSessions: 45,
          totalQuestions: 450,
          correctAnswers: 380,
          accuracy: 84.4,
          totalTimeSpent: 16200,
        },
        byGrade: [],
        byTopic: [],
        streak: {
          current: 5,
          longest: 12,
          lastCompletedAt: new Date().toISOString(),
        },
      },
    };
  }

  async getHistory(params: HistoryQueryParams) {
    // Implementation in Phase 2
    return {
      success: true,
      data: {
        sessions: [],
        pagination: {
          page: params.page,
          limit: params.limit,
          total: 0,
          totalPages: 0,
        },
      },
    };
  }
}
