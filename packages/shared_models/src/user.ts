export interface User {
  id: string;
  email: string;
  name: string;
  birthDate?: string;
  age?: number;
  currentGrade: number;
  createdAt: string;
  updatedAt?: string;
}

export interface Streak {
  current: number;
  longest: number;
  lastCompletedAt?: string;
}

export interface UserWithStreak extends User {
  streak: Streak;
}

export interface RegisterRequest {
  email: string;
  password: string;
  name: string;
  birthDate?: string;
  currentGrade: number;
}

export interface LoginRequest {
  email: string;
  password: string;
}

export interface AuthResponse {
  user: User;
  token: string;
}

export interface UpdateProfileRequest {
  name?: string;
  birthDate?: string;
  currentGrade?: number;
}

export interface SwitchGradeRequest {
  grade: number;
}

export interface SwitchGradeResponse {
  previousGrade: number;
  currentGrade: number;
  message: string;
}
