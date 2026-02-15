import {
  Controller,
  Get,
  Patch,
  Post,
  Body,
  UseGuards,
} from '@nestjs/common';
import { ProfileService } from './profile.service';
import { UpdateProfileDto, SwitchGradeDto } from './dto';
import { FirebaseAuthGuard } from '../shared/guards/firebase-auth.guard';
import { CurrentUser } from '../shared/decorators/current-user.decorator';

@Controller('profile')
@UseGuards(FirebaseAuthGuard)
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Get()
  async getProfile(@CurrentUser('userId') userId: string) {
    const profile = await this.profileService.getProfile(userId);
    return { success: true, data: profile };
  }

  @Patch()
  async updateProfile(
    @CurrentUser('userId') userId: string,
    @Body() updateDto: UpdateProfileDto,
  ) {
    const profile = await this.profileService.updateProfile(userId, updateDto);
    return { success: true, data: profile };
  }

  @Post('switch-grade')
  async switchGrade(
    @CurrentUser('userId') userId: string,
    @Body() switchDto: SwitchGradeDto,
  ) {
    const result = await this.profileService.switchGrade(userId, switchDto);
    return { success: true, data: result };
  }

  @Get('default-grade')
  async getDefaultGrade(@CurrentUser('userId') userId: string) {
    const result = await this.profileService.getDefaultGradeFromBirthDate(userId);
    return { success: true, data: result };
  }
}
