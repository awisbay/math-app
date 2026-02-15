import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../common/prisma.service';
import { UserActivityRepository } from '../../repositories/user-activity.repository';

export interface StreakUpdateResult {
  previousStreak: number;
  currentStreak: number;
  longestStreak: number;
  milestone?: number;
  isStreakContinued: boolean;
  isNewStreak: boolean;
}

export interface StreakInfo {
  current: number;
  longest: number;
  lastCompletedAt: Date | null;
  nextMilestone: number;
  daysUntilMilestone: number;
}

// Indonesian timezone offset: UTC+7 (WIB)
const WIB_OFFSET_MS = 7 * 60 * 60 * 1000;

@Injectable()
export class StreakService {
  private readonly logger = new Logger(StreakService.name);
  private readonly MILESTONES = [3, 7, 14, 30, 60, 100];

  constructor(
    private prisma: PrismaService,
    private userActivityRepo: UserActivityRepository,
  ) {}

  async updateStreakAfterSession(
    userId: string,
    completedAt: Date,
  ): Promise<StreakUpdateResult> {
    const today = this.getWibDate(completedAt);

    const existingActivity = await this.userActivityRepo.getDailyActivity(
      userId,
      today,
    );

    if (existingActivity && existingActivity.completedSessions > 0) {
      this.logger.log(
        `[Streak] User ${userId} already has activity for ${today.toISOString()}`,
      );

      const streak = await this.getCurrentStreak(userId);
      return {
        previousStreak: streak.current,
        currentStreak: streak.current,
        longestStreak: streak.longest,
        isStreakContinued: true,
        isNewStreak: false,
      };
    }

    let streakRecord = await this.prisma.streak.findUnique({
      where: { userId },
    });

    if (!streakRecord) {
      streakRecord = await this.prisma.streak.create({
        data: {
          userId,
          current: 0,
          longest: 0,
        },
      });
    }

    const previousStreak = streakRecord.current;
    let newStreak = previousStreak;
    let isStreakContinued = false;
    let isNewStreak = false;

    if (previousStreak === 0) {
      newStreak = 1;
      isNewStreak = true;
    } else if (streakRecord.lastCompletedAt) {
      const lastActiveDate = this.getWibDate(streakRecord.lastCompletedAt);
      const yesterday = new Date(today);
      yesterday.setDate(yesterday.getDate() - 1);

      if (this.isSameDay(lastActiveDate, yesterday)) {
        newStreak = previousStreak + 1;
        isStreakContinued = true;
      } else if (this.isSameDay(lastActiveDate, today)) {
        newStreak = previousStreak;
        isStreakContinued = true;
      } else {
        newStreak = 1;
        isNewStreak = true;
      }
    }

    const newLongest = Math.max(streakRecord.longest, newStreak);
    const milestone = this.checkMilestone(newStreak, previousStreak);

    await this.prisma.streak.update({
      where: { userId },
      data: {
        current: newStreak,
        longest: newLongest,
        lastCompletedAt: completedAt,
      },
    });

    this.logger.log(
      `[Streak] User ${userId}: ${previousStreak} -> ${newStreak}`,
    );

    return {
      previousStreak,
      currentStreak: newStreak,
      longestStreak: newLongest,
      milestone,
      isStreakContinued,
      isNewStreak,
    };
  }

  async getStreakInfo(userId: string): Promise<StreakInfo> {
    const streak = await this.prisma.streak.findUnique({
      where: { userId },
    });

    if (!streak) {
      return {
        current: 0,
        longest: 0,
        lastCompletedAt: null,
        nextMilestone: this.MILESTONES[0],
        daysUntilMilestone: this.MILESTONES[0],
      };
    }

    const nextMilestone = this.getNextMilestone(streak.current);
    const daysUntilMilestone = nextMilestone - streak.current;

    return {
      current: streak.current,
      longest: streak.longest,
      lastCompletedAt: streak.lastCompletedAt,
      nextMilestone,
      daysUntilMilestone,
    };
  }

  async checkAndResetMissedStreaks(): Promise<number> {
    // Use WIB timezone for determining "yesterday"
    const nowWib = this.getWibDate(new Date());
    const yesterday = new Date(nowWib);
    yesterday.setDate(yesterday.getDate() - 1);

    const streaksToReset = await this.prisma.streak.findMany({
      where: {
        current: { gt: 0 },
        lastCompletedAt: { lt: yesterday },
      },
    });

    let resetCount = 0;
    for (const streak of streaksToReset) {
      await this.prisma.streak.update({
        where: { id: streak.id },
        data: { current: 0 },
      });
      resetCount++;
      this.logger.log(`[Streak] Reset for user ${streak.userId}`);
    }

    return resetCount;
  }

  async getLeaderboard(limit: number = 10): Promise<Array<{
    userId: string;
    name: string;
    currentStreak: number;
    longestStreak: number;
  }>> {
    const streaks = await this.prisma.streak.findMany({
      where: { current: { gt: 0 } },
      orderBy: { current: 'desc' },
      take: limit,
      include: {
        user: { select: { id: true, name: true } },
      },
    });

    return streaks.map((s) => ({
      userId: s.user.id,
      name: s.user.name,
      currentStreak: s.current,
      longestStreak: s.longest,
    }));
  }

  async hasCompletedToday(userId: string): Promise<boolean> {
    const today = this.getWibDate(new Date());
    const activity = await this.userActivityRepo.getDailyActivity(userId, today);
    return activity !== null && activity.completedSessions > 0;
  }

  /**
   * Convert a UTC date to the start of day in WIB (Asia/Jakarta, UTC+7).
   * Returns a Date object representing midnight WIB as a UTC timestamp.
   */
  private getWibDate(date: Date): Date {
    // Shift to WIB, then truncate to midnight
    const wibTime = date.getTime() + WIB_OFFSET_MS;
    const wibDay = new Date(wibTime);
    wibDay.setUTCHours(0, 0, 0, 0);
    return wibDay;
  }

  private isSameDay(date1: Date, date2: Date): boolean {
    return (
      date1.getUTCFullYear() === date2.getUTCFullYear() &&
      date1.getUTCMonth() === date2.getUTCMonth() &&
      date1.getUTCDate() === date2.getUTCDate()
    );
  }

  private checkMilestone(newStreak: number, previousStreak: number): number | undefined {
    for (const milestone of this.MILESTONES) {
      if (previousStreak < milestone && newStreak >= milestone) {
        return milestone;
      }
    }
    return undefined;
  }

  private getNextMilestone(currentStreak: number): number {
    for (const milestone of this.MILESTONES) {
      if (milestone > currentStreak) {
        return milestone;
      }
    }
    return Math.ceil((currentStreak + 1) / 100) * 100;
  }

  private async getCurrentStreak(userId: string): Promise<{ current: number; longest: number }> {
    const streak = await this.prisma.streak.findUnique({ where: { userId } });
    return {
      current: streak?.current || 0,
      longest: streak?.longest || 0,
    };
  }
}
