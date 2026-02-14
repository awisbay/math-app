import { Test, TestingModule } from '@nestjs/testing';
import { TopicRepository } from './topic.repository';
import { PrismaService } from '../common/prisma.service';

describe('TopicRepository', () => {
  let repository: TopicRepository;
  let prismaService: PrismaService;

  const mockPrismaService = {
    topic: {
      findUnique: jest.fn(),
      findMany: jest.fn(),
      count: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      delete: jest.fn(),
    },
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        TopicRepository,
        {
          provide: PrismaService,
          useValue: mockPrismaService,
        },
      ],
    }).compile();

    repository = module.get<TopicRepository>(TopicRepository);
    prismaService = module.get<PrismaService>(PrismaService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('findByCode', () => {
    it('should find topic by grade and code', async () => {
      const mockTopic = {
        id: 'topic-1',
        grade: 5,
        code: 'G5_NUM_01',
        nameId: 'Bilangan Bulat',
      };

      mockPrismaService.topic.findUnique.mockResolvedValue(mockTopic);

      const result = await repository.findByCode(5, 'G5_NUM_01');

      expect(result).toEqual(mockTopic);
      expect(mockPrismaService.topic.findUnique).toHaveBeenCalledWith({
        where: {
          grade_code: {
            grade: 5,
            code: 'G5_NUM_01',
          },
        },
      });
    });
  });

  describe('findByGrade', () => {
    it('should find topics by grade with default active filter', async () => {
      const mockTopics = [
        { id: 'topic-1', grade: 5, isActive: true },
        { id: 'topic-2', grade: 5, isActive: true },
      ];

      mockPrismaService.topic.findMany.mockResolvedValue(mockTopics);

      const result = await repository.findByGrade(5);

      expect(result).toEqual(mockTopics);
      expect(mockPrismaService.topic.findMany).toHaveBeenCalledWith({
        where: {
          grade: 5,
          isActive: true,
        },
        orderBy: { sortOrder: 'asc' },
      });
    });

    it('should include inactive topics when specified', async () => {
      const mockTopics = [
        { id: 'topic-1', grade: 5, isActive: true },
        { id: 'topic-2', grade: 5, isActive: false },
      ];

      mockPrismaService.topic.findMany.mockResolvedValue(mockTopics);

      const result = await repository.findByGrade(5, true);

      expect(result).toHaveLength(2);
      expect(mockPrismaService.topic.findMany).toHaveBeenCalledWith({
        where: {
          grade: 5,
        },
        orderBy: { sortOrder: 'asc' },
      });
    });
  });

  describe('create', () => {
    it('should create a new topic', async () => {
      const createData = {
        grade: 5,
        code: 'G5_NUM_01',
        nameId: 'Bilangan Bulat',
        difficultyBaseline: 3,
      };

      const mockTopic = { id: 'new-topic', ...createData };
      mockPrismaService.topic.create.mockResolvedValue(mockTopic);

      const result = await repository.create(createData as any);

      expect(result).toEqual(mockTopic);
      expect(mockPrismaService.topic.create).toHaveBeenCalledWith({
        data: createData,
      });
    });
  });
});
