import { NestFactory } from '@nestjs/core';
import { ValidationPipe, VersioningType } from '@nestjs/common';
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

  // API Versioning
  app.enableVersioning({
    type: VersioningType.URI,
    defaultVersion: '1',
  });

  // Global API prefix
  app.setGlobalPrefix('api/v1');

  const port = configService.get<number>('PORT', 3000);

  await app.listen(port);
  console.log(`🚀 Application is running on: http://localhost:${port}/api/v1`);
  console.log(`📚 Health check: http://localhost:${port}/api/v1/health`);
}

bootstrap();
