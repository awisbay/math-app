export interface OverallProgress {
  totalSessions: number;
  totalQuestions: number;
  correctAnswers: number;
  accuracy: number;
  totalTimeSpent: number;
}

export interface GradeProgress {
  grade: number;
  sessions: number;
  accuracy: number;
  avgScore: number;
}

export interface TopicProgress {
  topic: string;
  sessions: number;
  accuracy: number;
}

export interface Streak {
  current: number;
  longest: number;
  lastCompletedAt?: string;
}

export interface ProgressOverview {
  overall: OverallProgress;
  byGrade: GradeProgress[];
  byTopic: TopicProgress[];
  streak: Streak;
}

export interface SessionHistoryItem {
  sessionId: string;
  grade: number;
  score: number;
  totalQuestions: number;
  accuracy: number;
  completedAt: string;
}

export interface PaginationInfo {
  page: number;
  limit: number;
  total: number;
  totalPages: number;
}

export interface SessionHistoryResponse {
  sessions: SessionHistoryItem[];
  pagination: PaginationInfo;
}
