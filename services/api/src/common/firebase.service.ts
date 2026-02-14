import { Injectable, Logger, OnModuleInit } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { FirebaseConfig } from '../config/firebase.config';

export interface FirebaseUser {
  uid: string;
  email?: string;
  emailVerified?: boolean;
  displayName?: string;
  photoURL?: string;
  disabled?: boolean;
}

@Injectable()
export class FirebaseService implements OnModuleInit {
  private readonly logger = new Logger(FirebaseService.name);

  constructor(private firebaseConfig: FirebaseConfig) {}

  onModuleInit() {
    this.initializeFirebase();
  }

  private initializeFirebase() {
    if (!this.firebaseConfig.isConfigured) {
      this.logger.warn(
        'Firebase configuration not complete. Auth features will not work properly.',
      );
      return;
    }

    if (admin.apps.length > 0) {
      this.logger.log('Firebase already initialized');
      return;
    }

    try {
      admin.initializeApp({
        credential: admin.credential.cert({
          projectId: this.firebaseConfig.projectId,
          privateKey: this.firebaseConfig.privateKey,
          clientEmail: this.firebaseConfig.clientEmail,
        }),
      });
      this.logger.log('Firebase Admin SDK initialized successfully');
    } catch (error) {
      this.logger.error('Failed to initialize Firebase Admin SDK', error);
      throw error;
    }
  }

  async verifyToken(token: string): Promise<FirebaseUser> {
    if (!this.firebaseConfig.isConfigured) {
      // Fallback for development without Firebase
      this.logger.warn('Firebase not configured, using mock verification');
      return this.mockVerifyToken(token);
    }

    try {
      const decodedToken = await admin.auth().verifyIdToken(token);
      return {
        uid: decodedToken.uid,
        email: decodedToken.email,
        emailVerified: decodedToken.email_verified,
        displayName: decodedToken.name,
        photoURL: decodedToken.picture,
      };
    } catch (error) {
      this.logger.error('Token verification failed', error);
      throw error;
    }
  }

  async createUser(email: string, password: string, displayName?: string): Promise<FirebaseUser> {
    if (!this.firebaseConfig.isConfigured) {
      throw new Error('Firebase not configured');
    }

    try {
      const userRecord = await admin.auth().createUser({
        email,
        password,
        displayName,
      });

      return {
        uid: userRecord.uid,
        email: userRecord.email,
        emailVerified: userRecord.emailVerified,
        displayName: userRecord.displayName,
        photoURL: userRecord.photoURL,
        disabled: userRecord.disabled,
      };
    } catch (error) {
      this.logger.error('Failed to create Firebase user', error);
      throw error;
    }
  }

  async getUserByEmail(email: string): Promise<FirebaseUser | null> {
    if (!this.firebaseConfig.isConfigured) {
      return null;
    }

    try {
      const userRecord = await admin.auth().getUserByEmail(email);
      return {
        uid: userRecord.uid,
        email: userRecord.email,
        emailVerified: userRecord.emailVerified,
        displayName: userRecord.displayName,
        photoURL: userRecord.photoURL,
        disabled: userRecord.disabled,
      };
    } catch (error) {
      return null;
    }
  }

  async deleteUser(uid: string): Promise<void> {
    if (!this.firebaseConfig.isConfigured) {
      return;
    }

    try {
      await admin.auth().deleteUser(uid);
    } catch (error) {
      this.logger.error(`Failed to delete user ${uid}`, error);
      throw error;
    }
  }

  private mockVerifyToken(token: string): FirebaseUser {
    // For development without Firebase
    if (token === 'mock-token' || token.startsWith('mock-')) {
      return {
        uid: 'mock-uid-123',
        email: 'mock@example.com',
        emailVerified: true,
        displayName: 'Mock User',
      };
    }
    throw new Error('Invalid token');
  }
}
