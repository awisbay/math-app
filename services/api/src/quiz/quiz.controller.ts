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
    @CurrentUser('uid') firebaseUid: string,
    @CurrentUser('userId') userId: string,
    @Body() dto: CreateSessionDto,
  ) {
    // TODO: Map firebaseUid to actual user and get userGrade
    const mockUserId = userId || 'mock-user-id';
    const mockUserGrade = 5;

    const session = await this.sessionService.createSession(
      mockUserId,
      mockUserGrade,
      dto,
    );

    // Fetch full session with questions
    const fullSession = await this.sessionService.getSession(
      session.id,
      mockUserId,
    );

    return {
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
    const mockUserId = userId || 'mock-user-id';
    const session = await this.sessionService.getSession(sessionId, mockUserId);

    return {
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
    const mockUserId = userId || 'mock-user-id';

    await this.sessionService.submitAnswer(sessionId, mockUserId, dto);

    return {
      success: true,
      message: 'Jawaban berhasil disimpan',
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
    const mockUserId = userId || 'mock-user-id';

    const result = await this.sessionService.completeSession(
      sessionId,
      mockUserId,
    );

    return {
      sessionId: result.sessionId,
      score: result.score,
      totalQuestions: result.totalQuestions,
      correctAnswers: result.correctAnswers,
      percentage: result.percentage,
      timeSpent: result.timeSpent,
      completedAt: result.completedAt.toISOString(),
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
    const mockUserId = userId || 'mock-user-id';

    await this.sessionService.abandonSession(sessionId, mockUserId);

    return {
      success: true,
      message: 'Sesi dibatalkan',
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
    const mockUserId = userId || 'mock-user-id';
    const session = await this.sessionService.getSession(sessionId, mockUserId);

    if (session.status !== 'COMPLETED') {
      return {
        sessionId: session.id,
        status: session.status,
        message: 'Sesi belum selesai',
      };
    }

    return {
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
    };
  }
}
