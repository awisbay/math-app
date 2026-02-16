import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { FirebaseService } from './firebase.service';
import { FirebaseConfig } from '../config/firebase.config';

@Global()
@Module({
  providers: [PrismaService, FirebaseService, FirebaseConfig],
  exports: [PrismaService, FirebaseService, FirebaseConfig],
})
export class CommonModule {}
