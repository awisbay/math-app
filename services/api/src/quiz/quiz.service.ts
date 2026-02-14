import { Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import { SubmitAnswersDto } from './dto';

@Injectable()
export class QuizService {
  private readonly SESSION_DURATION = 900; // 15 minutes in seconds
  private readonly QUESTION_COUNT = 10;

  constructor(private prisma: PrismaService) {}

  async startSession() {
    // Implementation in Phase 2
    const now = new Date();
    const expiresAt = new Date(now.getTime() + this.SESSION_DURATION * 1000);

    return {
      success: true,
      data: {
        sessionId: 'session_placeholder',
        grade: 5,
        questions: [],
        totalQuestions: this.QUESTION_COUNT,
        sessionDuration: this.SESSION_DURATION,
        startedAt: now.toISOString(),
        expiresAt: expiresAt.toISOString(),
      },
    };
  }

  async submitAnswers(sessionId: string, dto: SubmitAnswersDto) {
    // Implementation in Phase 2
    return {
      success: true,
      data: {
        sessionId,
        score: 8,
        totalQuestions: this.QUESTION_COUNT,
        correctAnswers: 8,
        timeSpent: 720,
        streakUpdated: true,
        newStreak: 6,
      },
    };
  }

  async getResult(sessionId: string) {
    // Implementation in Phase 2
    return {
      success: true,
      data: {
        sessionId,
        score: 8,
        totalQuestions: this.QUESTION_COUNT,
        correctAnswers: 8,
        percentage: 80,
        timeSpent: 720,
        grade: 5,
        breakdown: [],
      },
    };
  }
}
