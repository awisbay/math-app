import { Module } from '@nestjs/common';
import { QuizController } from './quiz.controller';
import { SessionService } from './services/session.service';
import { QuestionSelectionService } from './services/question-selection.service';
import { TemplateGenerationService } from './services/template-generation.service';

@Module({
  controllers: [QuizController],
  providers: [
    SessionService,
    QuestionSelectionService,
    TemplateGenerationService,
  ],
  exports: [
    SessionService,
    QuestionSelectionService,
    TemplateGenerationService,
  ],
})
export class QuizModule {}
