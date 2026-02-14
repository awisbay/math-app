import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class FirebaseConfig {
  constructor(private configService: ConfigService) {}

  get projectId(): string {
    return this.configService.get<string>('FIREBASE_PROJECT_ID') || '';
  }

  get privateKey(): string {
    const key = this.configService.get<string>('FIREBASE_PRIVATE_KEY') || '';
    // Handle escaped newlines in environment variables
    return key.replace(/\\n/g, '\n');
  }

  get clientEmail(): string {
    return this.configService.get<string>('FIREBASE_CLIENT_EMAIL') || '';
  }

  get isConfigured(): boolean {
    return !!(this.projectId && this.privateKey && this.clientEmail);
  }
}
