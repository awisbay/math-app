import { Controller, Get } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';

@Controller('health')
export class HealthController {
  constructor(private prisma: PrismaService) {}

  @Get('')
  async health() {
    return {
      status: 'healthy',
      timestamp: new Date().toISOString(),
      version: process.env.npm_package_version || '0.0.1',
    };
  }

  @Get('ready')
  async ready() {
    const checks: Record<string, { status: string; error?: string }> = {};
    let allHealthy = true;

    // Check database
    try {
      await this.prisma.$queryRaw`SELECT 1`;
      checks.database = { status: 'healthy' };
    } catch (error) {
      checks.database = {
        status: 'unhealthy',
        error: error instanceof Error ? error.message : 'Unknown error',
      };
      allHealthy = false;
    }

    const status = allHealthy ? 200 : 503;
    const statusText = allHealthy ? 'ready' : 'not ready';

    return {
      status: statusText,
      checks,
      timestamp: new Date().toISOString(),
    };
  }
}
