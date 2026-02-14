import { Injectable, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import { UpdateProfileDto, SwitchGradeDto } from './dto';

@Injectable()
export class ProfileService {
  constructor(private prisma: PrismaService) {}

  async getProfile() {
    // Implementation in Phase 2
    return {
      success: true,
      data: {
        id: 'placeholder',
        email: 'user@example.com',
        name: 'Budi Santoso',
        currentGrade: 5,
      },
    };
  }

  async updateProfile(dto: UpdateProfileDto) {
    // Implementation in Phase 2
    return {
      success: true,
      data: {
        id: 'placeholder',
        ...dto,
      },
    };
  }

  async switchGrade(dto: SwitchGradeDto) {
    if (dto.grade < 1 || dto.grade > 12) {
      throw new BadRequestException('Grade must be between 1 and 12');
    }
    
    return {
      success: true,
      data: {
        previousGrade: 5,
        currentGrade: dto.grade,
        message: 'Grade switched successfully',
      },
    };
  }
}
