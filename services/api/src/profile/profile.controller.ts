import { Controller, Get, Patch, Body, Post } from '@nestjs/common';
import { ProfileService } from './profile.service';
import { UpdateProfileDto, SwitchGradeDto } from './dto';

@Controller('profile')
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Get()
  async getProfile() {
    return this.profileService.getProfile();
  }

  @Patch()
  async updateProfile(@Body() updateDto: UpdateProfileDto) {
    return this.profileService.updateProfile(updateDto);
  }

  @Post('switch-grade')
  async switchGrade(@Body() switchDto: SwitchGradeDto) {
    return this.profileService.switchGrade(switchDto);
  }
}
