import { Test, TestingModule } from '@nestjs/testing';
import { QuestionSelectionService } from './question-selection.service';
import { QuestionRepository } from '../../repositories/question.repository';
import { UserActivityRepository } from '../../repositories/user-activity.repository';
import { QualityStatus } from '@prisma/client';

describe('QuestionSelectionService', () => {
  let service: QuestionSelectionService;
  let questionRepo: QuestionRepository;
  let userActivityRepo: UserActivityRepository;

  const mockQuestionRepo = {
    findMany: jest.fn(),
  };

  const mockUserActivityRepo = {
    getSeenQuestionIds: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        QuestionSelectionService,
        {
          provide: QuestionRepository,
          useValue: mockQuestionRepo,
        },
        {
          provide: UserActivityRepository,
          useValue: mockUserActivityRepo,
        },
      ],
    }).compile();

    service = module.get<QuestionSelectionService>(QuestionSelectionService);
    questionRepo = module.get<QuestionRepository>(QuestionRepository);
    userActivityRepo = module.get<UserActivityRepository>(UserActivityRepository);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('getPolicyForGrade', () => {
    it('should return default policy for middle grades', () => {
      const policy = service.getPolicyForGrade(5);
      
      expect(policy.totalQuestions).toBe(10);
      expect(policy.difficultyBuckets).toHaveLength(3);
      expect(policy.antiRepeatWindowDays).toBe(30);
    });

    it('should return adjusted policy for lower grades (1-3)', () => {
      const policy = service.getPolicyForGrade(2);
      
      const easyBucket = policy.difficultyBuckets.find(
        (b) => b.minDifficulty === 1 && b.maxDifficulty === 2,
      );
      expect(easyBucket?.count).toBe(5);
    });

    it('should return adjusted policy for higher grades (10-12)', () => {
      const policy = service.getPolicyForGrade(11);
      
      const hardBucket = policy.difficultyBuckets.find(
        (b) => b.minDifficulty === 4 && b.maxDifficulty === 5,
      );
      expect(hardBucket?.count).toBe(3);
    });
  });

  describe('selectQuestions', () => {
    it('should select 10 questions when pool is sufficient', async () => {
      const mockQuestions = Array.from({ length: 20 }, (_, i) => ({
        id: `q-${i}`,
        question: `Question ${i}`,
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 0,
        difficulty: (i % 5) + 1,
        topicId: `topic-${i % 5}`,
        grade: 5,
        sourceType: 'CURATED',
        qualityStatus: QualityStatus.APPROVED,
        timeLimit: 90,
        explanation: null,
        tags: [],
        createdAt: new Date(),
        updatedAt: new Date(),
        createdBy: null,
        reviewedBy: null,
        reviewedAt: null,
      }));

      mockUserActivityRepo.getSeenQuestionIds.mockResolvedValue([]);
      mockQuestionRepo.findMany.mockResolvedValue(mockQuestions);

      const result = await service.selectQuestions('user-1', 5);

      expect(result).toHaveLength(10);
      expect(new Set(result.map((q) => q.id)).size).toBe(10); // All unique
    });

    it('should exclude recently seen questions', async () => {
      const mockQuestions = Array.from({ length: 15 }, (_, i) => ({
        id: `q-${i}`,
        question: `Question ${i}`,
        options: ['A', 'B', 'C', 'D'],
        correctAnswer: 0,
        difficulty: (i % 5) + 1,
        topicId: `topic-${i % 5}`,
        grade: 5,
        sourceType: 'CURATED',
        qualityStatus: QualityStatus.APPROVED,
        timeLimit: 90,
        explanation: null,
        tags: [],
        createdAt: new Date(),
        updatedAt: new Date(),
        createdBy: null,
        reviewedBy: null,
        reviewedAt: null,
      }));

      mockUserActivityRepo.getSeenQuestionIds.mockResolvedValue(['q-0', 'q-1', 'q-2']);
      mockQuestionRepo.findMany.mockResolvedValue(mockQuestions.slice(3));

      const result = await service.selectQuestions('user-1', 5);

      const selectedIds = result.map((q) => q.id);
      expect(selectedIds).not.toContain('q-0');
      expect(selectedIds).not.toContain('q-1');
      expect(selectedIds).not.toContain('q-2');
    });

    it('should throw error when pool is insufficient', async () => {
      mockUserActivityRepo.getSeenQuestionIds.mockResolvedValue([]);
      mockQuestionRepo.findMany.mockResolvedValue([]);

      await expect(service.selectQuestions('user-1', 5)).rejects.toThrow(
        'INSUFFICIENT_POOL',
      );
    });
  });
});
