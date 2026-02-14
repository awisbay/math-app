import { Injectable, NotFoundException, BadRequestException } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import { UpdateProfileDto, SwitchGradeDto } from './dto';
import {
  calculateAge,
  getDefaultGradeFromBirthDate,
  isValidGrade,
} from '../shared/utils/grade-calculator.util';

@Injectable()
export class ProfileService {
  constructor(private prisma: PrismaService) {}

  async getProfile(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      include: {
        streak: true,
        progress: true,
      },
    });

    if (!user) {
      throw new NotFoundException({
        code: 'USER_NOT_FOUND',
        message: 'User tidak ditemukan',
      });
    }

    const age = user.birthDate ? calculateAge(user.birthDate) : null;

    return {
      id: user.id,
      email: user.email,
      name: user.name,
      birthDate: user.birthDate?.toISOString(),
      age,
      currentGrade: user.currentGrade,
      createdAt: user.createdAt.toISOString(),
      updatedAt: user.updatedAt.toISOString(),
      streak: user.streak
        ? {
            current: user.streak.current,
            longest: user.streak.longest,
            lastCompletedAt: user.streak.lastCompletedAt?.toISOString(),
          }
        : null,
      totalSessions: user.progress?.totalSessions || 0,
    };
  }

  async updateProfile(userId: string, dto: UpdateProfileDto) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException({
        code: 'USER_NOT_FOUND',
        message: 'User tidak ditemukan',
      });
    }

    const updateData: any = {};

    if (dto.name !== undefined) {
      updateData.name = dto.name;
    }

    if (dto.birthDate !== undefined) {
      updateData.birthDate = new Date(dto.birthDate);
    }

    if (dto.currentGrade !== undefined) {
      if (!isValidGrade(dto.currentGrade)) {
        throw new BadRequestException({
          code: 'INVALID_GRADE',
          message: 'Kelas harus antara 1 dan 12',
        });
      }
      updateData.currentGrade = dto.currentGrade;
    }

    const updatedUser = await this.prisma.user.update({
      where: { id: userId },
      data: updateData,
      include: {
        streak: true,
      },
    });

    const age = updatedUser.birthDate ? calculateAge(updatedUser.birthDate) : null;

    return {
      id: updatedUser.id,
      email: updatedUser.email,
      name: updatedUser.name,
      birthDate: updatedUser.birthDate?.toISOString(),
      age,
      currentGrade: updatedUser.currentGrade,
      updatedAt: updatedUser.updatedAt.toISOString(),
    };
  }

  async switchGrade(userId: string, dto: SwitchGradeDto) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
    });

    if (!user) {
      throw new NotFoundException({
        code: 'USER_NOT_FOUND',
        message: 'User tidak ditemukan',
      });
    }

    if (!isValidGrade(dto.grade)) {
      throw new BadRequestException({
        code: 'INVALID_GRADE',
        message: 'Kelas harus antara 1 dan 12',
      });
    }

    if (user.currentGrade === dto.grade) {
      throw new BadRequestException({
        code: 'SAME_GRADE',
        message: 'Kelas baru sama dengan kelas saat ini',
      });
    }

    const previousGrade = user.currentGrade;

    await this.prisma.user.update({
      where: { id: userId },
      data: {
        currentGrade: dto.grade,
      },
    });

    // TODO: Create grade switch audit log in Phase 2 P1

    return {
      previousGrade,
      currentGrade: dto.grade,
      message: 'Kelas berhasil diubah',
    };
  }

  async getDefaultGradeFromBirthDate(userId: string) {
    const user = await this.prisma.user.findUnique({
      where: { id: userId },
      select: { birthDate: true },
    });

    if (!user || !user.birthDate) {
      return { defaultGrade: 1 };
    }

    const defaultGrade = getDefaultGradeFromBirthDate(user.birthDate);

    return {
      birthDate: user.birthDate.toISOString(),
      age: calculateAge(user.birthDate),
      defaultGrade,
    };
  }
}
