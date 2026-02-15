import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { FirebaseService } from '../../common/firebase.service';
import { PrismaService } from '../../common/prisma.service';

@Injectable()
export class FirebaseAuthGuard implements CanActivate {
  constructor(
    private firebaseService: FirebaseService,
    private prisma: PrismaService,
  ) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest();
    const authHeader = request.headers.authorization;

    if (!authHeader) {
      throw new UnauthorizedException({
        code: 'MISSING_TOKEN',
        message: 'Token autentikasi tidak ditemukan',
      });
    }

    const [type, token] = authHeader.split(' ');

    if (type !== 'Bearer' || !token) {
      throw new UnauthorizedException({
        code: 'INVALID_TOKEN_FORMAT',
        message: 'Format token tidak valid. Gunakan: Bearer <token>',
      });
    }

    try {
      const decodedToken = await this.firebaseService.verifyToken(token);

      // Look up the database user by firebaseUid
      const dbUser = await this.prisma.user.findUnique({
        where: { firebaseUid: decodedToken.uid },
      });

      if (!dbUser) {
        throw new UnauthorizedException({
          code: 'USER_NOT_FOUND',
          message: 'Pengguna tidak ditemukan. Silakan daftar terlebih dahulu.',
        });
      }

      // Attach full user info to request
      request.user = {
        uid: decodedToken.uid,
        email: decodedToken.email,
        userId: dbUser.id,
        currentGrade: dbUser.currentGrade,
      };

      return true;
    } catch (error) {
      if (error instanceof UnauthorizedException) {
        throw error;
      }
      throw new UnauthorizedException({
        code: 'INVALID_TOKEN',
        message: 'Token tidak valid atau sudah expired',
      });
    }
  }
}
