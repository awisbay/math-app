import { Global, Module } from '@nestjs/common';
import { TopicRepository } from './topic.repository';
import { QuestionRepository } from './question.repository';
import { SessionRepository } from './session.repository';
import { UserActivityRepository } from './user-activity.repository';

@Global()
@Module({
  providers: [
    TopicRepository,
    QuestionRepository,
    SessionRepository,
    UserActivityRepository,
  ],
  exports: [
    TopicRepository,
    QuestionRepository,
    SessionRepository,
    UserActivityRepository,
  ],
})
export class RepositoriesModule {}
