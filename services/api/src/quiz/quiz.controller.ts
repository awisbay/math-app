import {
  Controller,
  Post,
  Get,
  Body,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { SessionService } from './services/session.service';
import { CreateSessionDto, SubmitAnswerDto } from './dto';
import { FirebaseAuthGuard } from '../shared/guards/firebase-auth.guard';
import { CurrentUser } from '../shared/decorators/current-user.decorator';

@Controller('quiz')
@UseGuards(FirebaseAuthGuard)
export class QuizController {
  constructor(private readonly sessionService: SessionService) {}

  /**
   * Start a new quiz session
   */
  @Post('sessions')
  async createSession(
    @CurrentUser('userId') userId: string,
    @CurrentUser('currentGrade') userGrade: number,
    @Body() dto: CreateSessionDto,
  ) {
    const session = await this.sessionService.createSession(
      userId,
      userGrade,
      dto,
    );

    // Fetch full session with questions
    const fullSession = await this.sessionService.getSession(
      session.id,
      userId,
    );

    return {
      success: true,
      data: {
        sessionId: fullSession.id,
        grade: fullSession.grade,
        status: fullSession.status,
        durationSeconds: fullSession.durationSeconds,
        expiresAt: fullSession.expiresAt.toISOString(),
        questions: fullSession.sessionQuestions.map((sq) => ({
          id: sq.id,
          ordinal: sq.ordinal,
          ...(sq.questionSnapshot as any),
        })),
      },
    };
  }

  /**
   * Get session details
   */
  @Get('sessions/:id')
  async getSession(
    @Param('id') sessionId: string,
    @CurrentUser('userId') userId: string,
  ) {
    const session = await this.sessionService.getSession(sessionId, userId);

    return {
      success: true,
      data: {
        sessionId: session.id,
        grade: session.grade,
        status: session.status,
        durationSeconds: session.durationSeconds,
        expiresAt: session.expiresAt.toISOString(),
        score: session.score,
        correctAnswers: session.correctAnswers,
        questions: session.sessionQuestions.map((sq) => ({
          id: sq.id,
          ordinal: sq.ordinal,
          answered: !!sq.answer,
          ...(sq.questionSnapshot as any),
        })),
      },
    };
  }

  /**
   * Submit an answer
   */
  @Post('sessions/:id/answers')
  @HttpCode(HttpStatus.OK)
  async submitAnswer(
    @Param('id') sessionId: string,
    @CurrentUser('userId') userId: string,
    @Body() dto: SubmitAnswerDto,
  ) {
    await this.sessionService.submitAnswer(sessionId, userId, dto);

    return {
      success: true,
      data: {
        message: 'Jawaban berhasil disimpan',
      },
    };
  }

  /**
   * Complete/submit the entire session
   */
  @Post('sessions/:id/submit')
  async submitSession(
    @Param('id') sessionId: string,
    @CurrentUser('userId') userId: string,
  ) {
    const result = await this.sessionService.completeSession(
      sessionId,
      userId,
    );

    return {
      success: true,
      data: {
        sessionId: result.sessionId,
        score: result.score,
        totalQuestions: result.totalQuestions,
        correctAnswers: result.correctAnswers,
        percentage: result.percentage,
        timeSpent: result.timeSpent,
        completedAt: result.completedAt.toISOString(),
      },
    };
  }

  /**
   * Abandon a session
   */
  @Post('sessions/:id/abandon')
  @HttpCode(HttpStatus.OK)
  async abandonSession(
    @Param('id') sessionId: string,
    @CurrentUser('userId') userId: string,
  ) {
    await this.sessionService.abandonSession(sessionId, userId);

    return {
      success: true,
      data: {
        message: 'Sesi dibatalkan',
      },
    };
  }

  /**
   * Get session result
   */
  @Get('sessions/:id/result')
  async getResult(
    @Param('id') sessionId: string,
    @CurrentUser('userId') userId: string,
  ) {
    const session = await this.sessionService.getSession(sessionId, userId);

    if (session.status !== 'COMPLETED') {
      return {
        success: true,
        data: {
          sessionId: session.id,
          status: session.status,
          message: 'Sesi belum selesai',
        },
      };
    }

    return {
      success: true,
      data: {
        sessionId: session.id,
        grade: session.grade,
        status: session.status,
        score: session.score,
        totalQuestions: session.totalQuestions,
        correctAnswers: session.correctAnswers,
        percentage: Math.round(
          ((session.correctAnswers || 0) / session.totalQuestions) * 100,
        ),
        timeSpent: session.totalTimeSpent,
        questions: session.sessionQuestions.map((sq) => ({
          id: sq.id,
          ordinal: sq.ordinal,
          selectedOption: sq.answer?.selectedOption,
          isCorrect: sq.answer?.isCorrect,
          timeSpent: sq.answer?.timeSpentSeconds,
          ...(sq.questionSnapshot as any),
        })),
      },
    };
  }
}
