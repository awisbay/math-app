import { Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import { Topic, Prisma } from '@prisma/client';

@Injectable()
export class TopicRepository {
  constructor(private prisma: PrismaService) {}

  async findById(id: string): Promise<Topic | null> {
    return this.prisma.topic.findUnique({
      where: { id },
    });
  }

  async findByCode(grade: number, code: string): Promise<Topic | null> {
    return this.prisma.topic.findUnique({
      where: {
        grade_code: {
          grade,
          code,
        },
      },
    });
  }

  async findByGrade(grade: number, includeInactive = false): Promise<Topic[]> {
    return this.prisma.topic.findMany({
      where: {
        grade,
        ...(includeInactive ? {} : { isActive: true }),
      },
      orderBy: { sortOrder: 'asc' },
    });
  }

  async findAll(options?: {
    grade?: number;
    isActive?: boolean;
    skip?: number;
    take?: number;
  }): Promise<Topic[]> {
    const where: Prisma.TopicWhereInput = {};

    if (options?.grade !== undefined) {
      where.grade = options.grade;
    }
    if (options?.isActive !== undefined) {
      where.isActive = options.isActive;
    }

    return this.prisma.topic.findMany({
      where,
      skip: options?.skip,
      take: options?.take,
      orderBy: [
        { grade: 'asc' },
        { sortOrder: 'asc' },
      ],
    });
  }

  async count(options?: {
    grade?: number;
    isActive?: boolean;
  }): Promise<number> {
    const where: Prisma.TopicWhereInput = {};

    if (options?.grade !== undefined) {
      where.grade = options.grade;
    }
    if (options?.isActive !== undefined) {
      where.isActive = options.isActive;
    }

    return this.prisma.topic.count({ where });
  }

  async create(data: Prisma.TopicCreateInput): Promise<Topic> {
    return this.prisma.topic.create({ data });
  }

  async update(id: string, data: Prisma.TopicUpdateInput): Promise<Topic> {
    return this.prisma.topic.update({
      where: { id },
      data,
    });
  }

  async delete(id: string): Promise<Topic> {
    return this.prisma.topic.delete({
      where: { id },
    });
  }
}
