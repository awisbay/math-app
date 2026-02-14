import { Controller, Post, Get, Body, Param } from '@nestjs/common';
import { QuizService } from './quiz.service';
import { SubmitAnswersDto } from './dto';

@Controller('quiz')
export class QuizController {
  constructor(private readonly quizService: QuizService) {}

  @Post('session/start')
  async startSession() {
    return this.quizService.startSession();
  }

  @Post('session/:id/submit')
  async submitAnswers(
    @Param('id') sessionId: string,
    @Body() submitDto: SubmitAnswersDto,
  ) {
    return this.quizService.submitAnswers(sessionId, submitDto);
  }

  @Get('session/:id/result')
  async getResult(@Param('id') sessionId: string) {
    return this.quizService.getResult(sessionId);
  }
}
