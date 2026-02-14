import { Controller, Post, Body, HttpCode, HttpStatus, Headers } from '@nestjs/common';
import { AuthService } from './auth.service';
import { RegisterDto, LoginDto } from './dto';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(@Body() registerDto: RegisterDto) {
    return this.authService.register(registerDto);
  }

  @Post('login')
  @HttpCode(HttpStatus.OK)
  async login(@Body() loginDto: LoginDto) {
    return this.authService.login(loginDto);
  }

  @Post('verify-token')
  @HttpCode(HttpStatus.OK)
  async verifyToken(@Headers('authorization') authHeader: string) {
    if (!authHeader) {
      return {
        valid: false,
        message: 'Authorization header tidak ditemukan',
      };
    }

    const [type, token] = authHeader.split(' ');
    if (type !== 'Bearer' || !token) {
      return {
        valid: false,
        message: 'Format token tidak valid',
      };
    }

    const result = await this.authService.validateFirebaseToken(token);
    return {
      valid: true,
      ...result,
    };
  }

  @Post('logout')
  @HttpCode(HttpStatus.OK)
  async logout() {
    // Firebase handles token invalidation on client side
    // This endpoint is for any server-side cleanup if needed
    return {
      success: true,
      message: 'Logout berhasil',
    };
  }
}
