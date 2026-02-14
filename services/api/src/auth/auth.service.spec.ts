import { Test, TestingModule } from '@nestjs/testing';
import { AuthService } from './auth.service';
import { PrismaService } from '../common/prisma.service';
import { FirebaseService } from '../common/firebase.service';
import { ConflictException, BadRequestException } from '@nestjs/common';

describe('AuthService', () => {
  let service: AuthService;
  let prismaService: PrismaService;
  let firebaseService: FirebaseService;

  const mockPrismaService = {
    user: {
      findUnique: jest.fn(),
      findFirst: jest.fn(),
      create: jest.fn(),
    },
    streak: {
      create: jest.fn(),
    },
    progress: {
      create: jest.fn(),
    },
  };

  const mockFirebaseService = {
    createUser: jest.fn(),
    getUserByEmail: jest.fn(),
    verifyToken: jest.fn(),
  };

  beforeEach(async () => {
    const module: TestingModule = await Test.createTestingModule({
      providers: [
        AuthService,
        {
          provide: PrismaService,
          useValue: mockPrismaService,
        },
        {
          provide: FirebaseService,
          useValue: mockFirebaseService,
        },
      ],
    }).compile();

    service = module.get<AuthService>(AuthService);
    prismaService = module.get<PrismaService>(PrismaService);
    firebaseService = module.get<FirebaseService>(FirebaseService);
  });

  afterEach(() => {
    jest.clearAllMocks();
  });

  describe('register', () => {
    const registerDto = {
      email: 'test@example.com',
      password: 'password123',
      name: 'Test User',
      currentGrade: 5,
    };

    it('should register a new user successfully', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockFirebaseService.createUser.mockResolvedValue({
        uid: 'firebase-uid-123',
        email: registerDto.email,
      });
      mockPrismaService.user.create.mockResolvedValue({
        id: 'user-id-123',
        email: registerDto.email,
        name: registerDto.name,
        currentGrade: registerDto.currentGrade,
        createdAt: new Date(),
      });

      const result = await service.register(registerDto);

      expect(result.user.email).toBe(registerDto.email);
      expect(result.user.name).toBe(registerDto.name);
      expect(mockPrismaService.streak.create).toHaveBeenCalled();
      expect(mockPrismaService.progress.create).toHaveBeenCalled();
    });

    it('should throw ConflictException if email exists', async () => {
      mockPrismaService.user.findUnique.mockResolvedValue({
        id: 'existing-user',
        email: registerDto.email,
      });

      await expect(service.register(registerDto)).rejects.toThrow(
        ConflictException,
      );
    });

    it('should calculate grade from birthDate if not provided', async () => {
      const dtoWithBirthDate = {
        ...registerDto,
        currentGrade: undefined,
        birthDate: '2010-05-15', // ~14 years old -> grade 9
      };

      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockFirebaseService.createUser.mockResolvedValue({
        uid: 'firebase-uid-123',
        email: dtoWithBirthDate.email,
      });
      mockPrismaService.user.create.mockImplementation((args) => ({
        id: 'user-id-123',
        ...args.data,
        createdAt: new Date(),
      }));

      const result = await service.register(dtoWithBirthDate);

      expect(result.user.currentGrade).toBe(9);
    });
  });

  describe('login', () => {
    const loginDto = {
      email: 'test@example.com',
      password: 'password123',
    };

    it('should login successfully', async () => {
      mockFirebaseService.getUserByEmail.mockResolvedValue({
        uid: 'firebase-uid-123',
        email: loginDto.email,
      });
      mockPrismaService.user.findUnique.mockResolvedValue({
        id: 'user-id-123',
        email: loginDto.email,
        name: 'Test User',
        currentGrade: 5,
        streak: { current: 5, longest: 10 },
        progress: { totalSessions: 20 },
      });

      const result = await service.login(loginDto);

      expect(result.user.email).toBe(loginDto.email);
    });

    it('should create user in database if not exists', async () => {
      mockFirebaseService.getUserByEmail.mockResolvedValue({
        uid: 'firebase-uid-123',
        email: loginDto.email,
        displayName: 'Test User',
      });
      mockPrismaService.user.findUnique.mockResolvedValue(null);
      mockPrismaService.user.create.mockResolvedValue({
        id: 'new-user-id',
        email: loginDto.email,
        name: 'Test User',
        currentGrade: 1,
        streak: null,
        progress: null,
      });

      const result = await service.login(loginDto);

      expect(result.user.email).toBe(loginDto.email);
      expect(mockPrismaService.user.create).toHaveBeenCalled();
    });
  });
});
