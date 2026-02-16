import { Injectable, Logger } from '@nestjs/common';
import { PrismaService } from '../../common/prisma.service';

export interface TemplateConfig {
  type: string;
  format: string;
  variables: Record<string, any>;
}

export interface GeneratedQuestion {
  question: string;
  options: string[];
  correctAnswer: number;
  explanation: string;
}

/**
 * Service for generating question variants from templates
 * This is a placeholder implementation for Phase 4
 * Full implementation will be in Phase 7
 */
@Injectable()
export class TemplateGenerationService {
  private readonly logger = new Logger(TemplateGenerationService.name);

  constructor(private prisma: PrismaService) {}

  /**
   * Generate a variant from a template
   * This is a simplified implementation
   */
  async generateVariant(
    templateId: string,
    seed?: string,
  ): Promise<GeneratedQuestion | null> {
    const template = await this.prisma.questionTemplate.findUnique({
      where: { id: templateId },
    });

    if (!template) {
      return null;
    }

    // Use provided seed or generate random
    const variantSeed = seed || this.generateSeed();

    // Check if variant already exists
    const existing = await this.prisma.questionVariant.findUnique({
      where: {
        templateId_seed: {
          templateId,
          seed: variantSeed,
        },
      },
    });

    if (existing) {
      return {
        question: existing.question,
        options: existing.options,
        correctAnswer: existing.correctAnswer,
        explanation: existing.explanation || '',
      };
    }

    // Generate new variant (simplified)
    const generated = this.renderTemplate(
      template.generatorConfig as unknown as TemplateConfig,
      variantSeed,
    );

    if (!generated) {
      return null;
    }

    // Save variant
    await this.prisma.questionVariant.create({
      data: {
        templateId,
        seed: variantSeed,
        question: generated.question,
        options: generated.options,
        correctAnswer: generated.correctAnswer,
        explanation: generated.explanation,
        difficulty: template.difficulty,
      },
    });

    return generated;
  }

  /**
   * Render a template with variables
   * This is a simplified placeholder implementation
   */
  private renderTemplate(
    config: TemplateConfig,
    seed: string,
  ): GeneratedQuestion | null {
    // Simple pseudo-random generator based on seed
    const rng = this.createSeededRandom(seed);

    switch (config.type) {
      case 'addition':
        return this.generateAddition(config, rng);
      case 'multiplication':
        return this.generateMultiplication(config, rng);
      default:
        this.logger.warn(`Unknown template type: ${config.type}`);
        return null;
    }
  }

  private generateAddition(
    config: TemplateConfig,
    rng: () => number,
  ): GeneratedQuestion {
    const range = config.variables.range || [1, 100];
    const a = Math.floor(rng() * (range[1] - range[0] + 1)) + range[0];
    const b = Math.floor(rng() * (range[1] - range[0] + 1)) + range[0];
    const answer = a + b;

    const question = config.format
      .replace('{a}', a.toString())
      .replace('{b}', b.toString());

    // Generate distractors
    const options = this.generateDistractors(answer, rng);

    return {
      question,
      options,
      correctAnswer: options.indexOf(answer.toString()),
      explanation: `${a} + ${b} = ${answer}`,
    };
  }

  private generateMultiplication(
    config: TemplateConfig,
    rng: () => number,
  ): GeneratedQuestion {
    const tables = config.variables.tables || [2, 3, 4, 5];
    const a = tables[Math.floor(rng() * tables.length)];
    const b = Math.floor(rng() * 10) + 1;
    const answer = a * b;

    const question = config.format
      .replace('{a}', a.toString())
      .replace('{b}', b.toString());

    const options = this.generateDistractors(answer, rng);

    return {
      question,
      options,
      correctAnswer: options.indexOf(answer.toString()),
      explanation: `${a} × ${b} = ${answer}`,
    };
  }

  private generateDistractors(answer: number, rng: () => number): string[] {
    const distractors = new Set<number>();
    distractors.add(answer);

    while (distractors.size < 4) {
      const offset = Math.floor(rng() * 10) - 5;
      const value = answer + offset;
      if (value > 0 && value !== answer) {
        distractors.add(value);
      }
    }

    return Array.from(distractors)
      .sort(() => rng() - 0.5)
      .map((n) => n.toString());
  }

  private generateSeed(): string {
    return Math.random().toString(36).substring(2, 15);
  }

  private createSeededRandom(seed: string): () => number {
    let hash = 0;
    for (let i = 0; i < seed.length; i++) {
      const char = seed.charCodeAt(i);
      hash = (hash << 5) - hash + char;
      hash = hash & hash;
    }

    return () => {
      hash = (hash * 9301 + 49297) % 233280;
      return hash / 233280;
    };
  }
}
