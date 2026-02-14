import {
  Injectable,
  CanActivate,
  ExecutionContext,
  UnauthorizedException,
} from '@nestjs/common';
import { FirebaseService } from '../../common/firebase.service';

@Injectable()
export class FirebaseAuthGuard implements CanActivate {
  constructor(private firebaseService: FirebaseService) {}

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
      
      // Attach user info to request
      request.user = {
        uid: decodedToken.uid,
        email: decodedToken.email,
      };

      return true;
    } catch (error) {
      throw new UnauthorizedException({
        code: 'INVALID_TOKEN',
        message: 'Token tidak valid atau sudah expired',
      });
    }
  }
}
