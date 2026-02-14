import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { ThrottlerModule } from '@nestjs/throttler';
import { validateEnv } from './config/env.validation';
import { FirebaseConfig } from './config/firebase.config';
import { DatabaseConfig } from './config/database.config';
import { SharedModule } from './shared/shared.module';
import { CommonModule } from './common/common.module';
import { RepositoriesModule } from './repositories/repositories.module';
import { AuthModule } from './auth/auth.module';
import { ProfileModule } from './profile/profile.module';
import { QuizModule } from './quiz/quiz.module';
import { ProgressModule } from './progress/progress.module';
import { HealthModule } from './health/health.module';

@Module({
  imports: [
    ConfigModule.forRoot({
      isGlobal: true,
      envFilePath: ['.env', '../.env', '../../.env'],
      validate: validateEnv,
    }),
    ThrottlerModule.forRoot([
      {
        name: 'default',
        ttl: 60000, // 1 minute
        limit: 100,
      },
      {
        name: 'auth',
        ttl: 900000, // 15 minutes
        limit: 5,
      },
    ]),
    SharedModule,
    CommonModule,
    RepositoriesModule,
    HealthModule,
    AuthModule,
    ProfileModule,
    QuizModule,
    ProgressModule,
  ],
  providers: [FirebaseConfig, DatabaseConfig],
})
export class AppModule {}
