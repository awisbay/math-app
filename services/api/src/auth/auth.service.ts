import {
  Injectable,
  ConflictException,
  UnauthorizedException,
  BadRequestException,
} from '@nestjs/common';
import { PrismaService } from '../common/prisma.service';
import { FirebaseService } from '../common/firebase.service';
import { RegisterDto, LoginDto } from './dto';
import {
  calculateAge,
  getDefaultGradeFromBirthDate,
} from '../shared/utils/grade-calculator.util';

@Injectable()
export class AuthService {
  constructor(
    private prisma: PrismaService,
    private firebaseService: FirebaseService,
  ) {}

  async register(dto: RegisterDto) {
    // Check if user already exists
    const existingUser = await this.prisma.user.findUnique({
      where: { email: dto.email },
    });

    if (existingUser) {
      throw new ConflictException({
        code: 'EMAIL_EXISTS',
        message: 'Email sudah terdaftar',
      });
    }

    // Create Firebase user
    let firebaseUser;
    try {
      firebaseUser = await this.firebaseService.createUser(
        dto.email,
        dto.password,
        dto.name,
      );
    } catch (error) {
      throw new BadRequestException({
        code: 'REGISTRATION_FAILED',
        message: 'Gagal membuat akun: ' + error.message,
      });
    }

    // Calculate age and default grade if birthDate provided
    let birthDate: Date | null = null;
    let age: number | null = null;
    let currentGrade = dto.currentGrade;

    if (dto.birthDate) {
      birthDate = new Date(dto.birthDate);
      age = calculateAge(birthDate);
      // Use provided grade or calculate from birthDate
      if (!dto.currentGrade) {
        currentGrade = getDefaultGradeFromBirthDate(birthDate);
      }
    }

    // Create user in database
    const user = await this.prisma.user.create({
      data: {
        email: dto.email,
        name: dto.name,
        birthDate,
        currentGrade,
        firebaseUid: firebaseUser.uid,
      },
    });

    // Create initial streak and progress records
    await this.prisma.streak.create({
      data: {
        userId: user.id,
        current: 0,
        longest: 0,
      },
    });

    await this.prisma.progress.create({
      data: {
        userId: user.id,
      },
    });

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        birthDate: user.birthDate?.toISOString(),
        currentGrade: user.currentGrade,
        createdAt: user.createdAt.toISOString(),
      },
      message: 'Registrasi berhasil',
    };
  }

  async login(dto: LoginDto) {
    // Verify Firebase user exists
    const firebaseUser = await this.firebaseService.getUserByEmail(dto.email);

    if (!firebaseUser) {
      throw new UnauthorizedException({
        code: 'INVALID_CREDENTIALS',
        message: 'Email atau password salah',
      });
    }

    // Get or create user in database
    let user = await this.prisma.user.findUnique({
      where: { email: dto.email },
      include: {
        streak: true,
        progress: true,
      },
    });

    if (!user) {
      // Sync Firebase user to database if not exists
      user = await this.prisma.user.create({
        data: {
          email: dto.email,
          name: firebaseUser.displayName || dto.email.split('@')[0],
          currentGrade: 1, // Default grade
          firebaseUid: firebaseUser.uid,
        },
        include: {
          streak: true,
          progress: true,
        },
      });

      // Create initial streak and progress
      if (!user.streak) {
        await this.prisma.streak.create({
          data: {
            userId: user.id,
            current: 0,
            longest: 0,
          },
        });
      }

      if (!user.progress) {
        await this.prisma.progress.create({
          data: {
            userId: user.id,
          },
        });
      }
    }

    // Note: Password verification is handled by Firebase on the client side
    // The client sends a Firebase ID token after successful authentication
    // This login endpoint is mainly for syncing the user record

    return {
      user: {
        id: user.id,
        email: user.email,
        name: user.name,
        birthDate: user.birthDate?.toISOString(),
        currentGrade: user.currentGrade,
      },
      message: 'Login berhasil',
    };
  }

  async validateFirebaseToken(token: string) {
    try {
      const decodedToken = await this.firebaseService.verifyToken(token);
      
      // Find or create user in database
      let user = await this.prisma.user.findFirst({
        where: { firebaseUid: decodedToken.uid },
        include: {
          streak: true,
          progress: true,
        },
      });

      if (!user && decodedToken.email) {
        // Try to find by email
        user = await this.prisma.user.findUnique({
          where: { email: decodedToken.email },
          include: {
            streak: true,
            progress: true,
          },
        });

        if (user) {
          // Update firebaseUid
          user = await this.prisma.user.update({
            where: { id: user.id },
            data: { firebaseUid: decodedToken.uid },
            include: {
              streak: true,
              progress: true,
            },
          });
        } else {
          // Create new user
          user = await this.prisma.user.create({
            data: {
              email: decodedToken.email,
              name: decodedToken.displayName || decodedToken.email.split('@')[0],
              currentGrade: 1,
              firebaseUid: decodedToken.uid,
            },
            include: {
              streak: true,
              progress: true,
            },
          });

          await this.prisma.streak.create({
            data: {
              userId: user.id,
              current: 0,
              longest: 0,
            },
          });

          await this.prisma.progress.create({
            data: {
              userId: user.id,
            },
          });
        }
      }

      if (!user) {
        throw new UnauthorizedException({
          code: 'USER_NOT_FOUND',
          message: 'User tidak ditemukan',
        });
      }

      return {
        user: {
          id: user.id,
          email: user.email,
          name: user.name,
          birthDate: user.birthDate?.toISOString(),
          currentGrade: user.currentGrade,
        },
      };
    } catch (error) {
      throw new UnauthorizedException({
        code: 'INVALID_TOKEN',
        message: 'Token tidak valid',
      });
    }
  }
}
