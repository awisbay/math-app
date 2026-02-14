import { Injectable } from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import { Question, Prisma, QualityStatus } from '@prisma/client';

export interface QuestionFilter {
  grade?: number;
  topicId?: string;
  difficulty?: number;
  qualityStatus?: QualityStatus;
  sourceType?: string;
  excludeIds?: string[];
}

export interface QuestionPagination {
  skip?: number;
  take?: number;
}

@Injectable()
export class QuestionRepository {
  constructor(private prisma: PrismaService) {}

  async findById(id: string): Promise<Question | null> {
    return this.prisma.question.findUnique({
      where: { id },
      include: { topic: true },
    });
  }

  async findMany(
    filter: QuestionFilter,
    pagination?: QuestionPagination,
  ): Promise<Question[]> {
    const where = this.buildWhereClause(filter);

    return this.prisma.question.findMany({
      where,
      skip: pagination?.skip,
      take: pagination?.take,
      include: { topic: true },
      orderBy: { createdAt: 'desc' },
    });
  }

  async count(filter: QuestionFilter): Promise<number> {
    const where = this.buildWhereClause(filter);
    return this.prisma.question.count({ where });
  }

  async findRandom(
    filter: QuestionFilter,
    limit: number,
    excludeIds: string[] = [],
  ): Promise<Question[]> {
    const where = this.buildWhereClause(filter);

    // Use raw query for random selection with better performance
    const result = await this.prisma.$queryRaw<Question[]>`
      SELECT * FROM questions
      WHERE ${this.buildRawWhereClause(filter, excludeIds)}
      ORDER BY RANDOM()
      LIMIT ${limit}
    `;

    return result;
  }

  async findByGradeAndTopic(
    grade: number,
    topicId: string,
    options?: {
      difficulty?: number;
      limit?: number;
      excludeIds?: string[];
    },
  ): Promise<Question[]> {
    return this.prisma.question.findMany({
      where: {
        grade,
        topicId,
        qualityStatus: QualityStatus.APPROVED,
        ...(options?.difficulty ? { difficulty: options.difficulty } : {}),
        ...(options?.excludeIds?.length
          ? { id: { notIn: options.excludeIds } }
          : {}),
      },
      take: options?.limit,
      include: { topic: true },
    });
  }

  async create(data: Prisma.QuestionCreateInput): Promise<Question> {
    return this.prisma.question.create({ data });
  }

  async update(id: string, data: Prisma.QuestionUpdateInput): Promise<Question> {
    return this.prisma.question.update({
      where: { id },
      data,
    });
  }

  async updateQualityStatus(
    id: string,
    status: QualityStatus,
    reviewedBy?: string,
  ): Promise<Question> {
    return this.prisma.question.update({
      where: { id },
      data: {
        qualityStatus: status,
        reviewedBy,
        reviewedAt: new Date(),
      },
    });
  }

  async delete(id: string): Promise<Question> {
    return this.prisma.question.delete({
      where: { id },
    });
  }

  private buildWhereClause(filter: QuestionFilter): Prisma.QuestionWhereInput {
    const where: Prisma.QuestionWhereInput = {};

    if (filter.grade !== undefined) {
      where.grade = filter.grade;
    }
    if (filter.topicId) {
      where.topicId = filter.topicId;
    }
    if (filter.difficulty !== undefined) {
      where.difficulty = filter.difficulty;
    }
    if (filter.qualityStatus) {
      where.qualityStatus = filter.qualityStatus;
    }
    if (filter.sourceType) {
      where.sourceType = filter.sourceType as any;
    }
    if (filter.excludeIds?.length) {
      where.id = { notIn: filter.excludeIds };
    }

    return where;
  }

  private buildRawWhereClause(
    filter: QuestionFilter,
    excludeIds: string[],
  ): string {
    const conditions: string[] = ['quality_status = \'approved\'', 'is_active = true'];

    if (filter.grade !== undefined) {
      conditions.push(`grade = ${filter.grade}`);
    }
    if (filter.topicId) {
      conditions.push(`topic_id = '${filter.topicId}'`);
    }
    if (filter.difficulty !== undefined) {
      conditions.push(`difficulty = ${filter.difficulty}`);
    }
    if (excludeIds.length > 0) {
      const ids = excludeIds.map((id) => `'${id}'`).join(',');
      conditions.push(`id NOT IN (${ids})`);
    }

    return conditions.join(' AND ');
  }
}
