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
import { CurrentUser, CurrentUserData } from '../shared/decorators/current-user.decorator';

@Controller('profile')
@UseGuards(FirebaseAuthGuard)
export class ProfileController {
  constructor(private readonly profileService: ProfileService) {}

  @Get()
  async getProfile(@CurrentUser('uid') firebaseUid: string) {
    // TODO: Map firebase UID to user ID properly
    // For now, this is a placeholder implementation
    const user = await this.getUserByFirebaseUid(firebaseUid);
    return this.profileService.getProfile(user.id);
  }

  @Patch()
  async updateProfile(
    @CurrentUser('uid') firebaseUid: string,
    @Body() updateDto: UpdateProfileDto,
  ) {
    const user = await this.getUserByFirebaseUid(firebaseUid);
    return this.profileService.updateProfile(user.id, updateDto);
  }

  @Post('switch-grade')
  async switchGrade(
    @CurrentUser('uid') firebaseUid: string,
    @Body() switchDto: SwitchGradeDto,
  ) {
    const user = await this.getUserByFirebaseUid(firebaseUid);
    return this.profileService.switchGrade(user.id, switchDto);
  }

  @Get('default-grade')
  async getDefaultGrade(@CurrentUser('uid') firebaseUid: string) {
    const user = await this.getUserByFirebaseUid(firebaseUid);
    return this.profileService.getDefaultGradeFromBirthDate(user.id);
  }

  private async getUserByFirebaseUid(firebaseUid: string) {
    // This should be replaced with actual user lookup
    // For now, return a mock user
    return { id: 'mock-user-id' };
  }
}
