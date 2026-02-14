export type QuestionType = 'multiple_choice' | 'fill_in_blank';

export interface Question {
  id: string;
  type: QuestionType;
  question: string;
  options: string[];
  correctAnswer: number;
  timeLimit: number;
  topic: string;
}

export interface QuizSession {
  sessionId: string;
  grade: number;
  questions: Question[];
  totalQuestions: number;
  sessionDuration: number;
  startedAt: string;
  expiresAt: string;
}

export interface Answer {
  questionId: string;
  selectedOption: number;
  timeSpent: number;
}

export interface SubmitAnswersRequest {
  answers: Answer[];
}

export interface SubmitAnswersResponse {
  sessionId: string;
  score: number;
  totalQuestions: number;
  correctAnswers: number;
  timeSpent: number;
  completedAt: string;
  streakUpdated: boolean;
  newStreak: number;
}

export interface QuestionResult {
  questionId: string;
  question: string;
  correct: boolean;
  correctAnswer: number;
  userAnswer: number;
  timeSpent: number;
}

export interface QuizResult {
  sessionId: string;
  score: number;
  totalQuestions: number;
  correctAnswers: number;
  percentage: number;
  timeSpent: number;
  grade: number;
  completedAt: string;
  breakdown: QuestionResult[];
}
