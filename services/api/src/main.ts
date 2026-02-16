import { NestFactory } from '@nestjs/core';
import { ValidationPipe } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  const configService = app.get(ConfigService);

  // Enable validation
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,
      transform: true,
      forbidNonWhitelisted: true,
      exceptionFactory: (errors) => {
        const details: Record<string, string[]> = {};
        errors.forEach((error) => {
          details[error.property] = Object.values(error.constraints || {});
        });
        return {
          statusCode: 400,
          error: {
            code: 'VALIDATION_ERROR',
            message: 'Validasi input gagal',
            details,
          },
          requestId: 'validation',
          timestamp: new Date().toISOString(),
        } as any;
      },
    }),
  );

  // Enable CORS
  app.enableCors({
    origin: configService.get('CORS_ORIGIN')?.split(',') || '*',
    credentials: true,
  });

  // Global API prefix
  const apiPrefix = configService.get('API_PREFIX', 'api/v1');
  app.setGlobalPrefix(apiPrefix);

  const port = configService.get<number>('PORT', 3000);

  await app.listen(port);
  console.log(`Application is running on: http://localhost:${port}/${apiPrefix}`);
  console.log(`Health check: http://localhost:${port}/${apiPrefix}/health`);
}

bootstrap();
