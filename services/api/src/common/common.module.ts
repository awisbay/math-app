import { Global, Module } from '@nestjs/common';
import { PrismaService } from './prisma.service';
import { FirebaseService } from './firebase.service';

@Global()
@Module({
  providers: [PrismaService, FirebaseService],
  exports: [PrismaService, FirebaseService],
})
export class CommonModule {}
