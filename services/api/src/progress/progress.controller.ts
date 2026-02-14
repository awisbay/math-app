import { Controller, Get, Query } from '@nestjs/common';
import { ProgressService } from './progress.service';

@Controller('progress')
export class ProgressController {
  constructor(private readonly progressService: ProgressService) {}

  @Get()
  async getProgress() {
    return this.progressService.getProgress();
  }

  @Get('history')
  async getHistory(
    @Query('page') page: string = '1',
    @Query('limit') limit: string = '10',
    @Query('grade') grade?: string,
  ) {
    return this.progressService.getHistory({
      page: parseInt(page, 10),
      limit: parseInt(limit, 10),
      grade: grade ? parseInt(grade, 10) : undefined,
    });
  }
}
