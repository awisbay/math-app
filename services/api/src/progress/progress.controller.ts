import { Controller, Get, Query, UseGuards } from '@nestjs/common';
import { ProgressService } from './progress.service';
import { FirebaseAuthGuard } from '../shared/guards/firebase-auth.guard';
import { CurrentUser } from '../shared/decorators/current-user.decorator';

@Controller('progress')
@UseGuards(FirebaseAuthGuard)
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get()
  async getProgress(@CurrentUser('userId') userId: string) {
    const progress = await this.progressService.getProgress(userId);
    return { success: true, data: progress };
  }

  @Get('history')
  async getHistory(
    @CurrentUser('userId') userId: string,
    @Query('page') page: string = '1',
    @Query('limit') limit: string = '10',
    @Query('grade') grade?: string,
  ) {
    const history = await this.progressService.getHistory(userId, {
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
      grade: grade ? parseInt(grade, 10) : undefined,
    });
    return { success: true, data: history };
  }
}
