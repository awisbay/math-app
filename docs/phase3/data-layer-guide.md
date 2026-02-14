# Phase 3 Data Layer Guide

## Overview

This document describes the data layer implementation for the Math App, including schema design, repositories, and data access patterns.

## Database Schema

### Core Entities

| Entity | Purpose | Key Fields |
|--------|---------|------------|
| `users` | User accounts | id, email, name, current_grade, firebase_uid |
| `user_grades` | Grade unlocks per user | user_id, grade, is_active |
| `topics` | Topic taxonomy | id, grade, code, name_id, sort_order |
| `questions` | Question bank | id, grade, topic_id, difficulty, quality_status |
| `question_templates` | Template generators | id, code, generator_config |
| `question_variants` | Generated variants | id, template_id, seed, rendered_content |
| `sessions` | Quiz sessions | id, user_id, grade, status, expires_at |
| `session_questions` | Questions in session | id, session_id, ordinal, ref_type |
| `session_answers` | User answers | id, selected_option, is_correct, time_spent |
| `user_question_history` | Anti-repeat tracking | user_id, question_id, seen_at |
| `user_daily_activity` | Streak tracking | user_id, activity_date, completed_sessions |
| `user_topic_mastery` | Topic progress | user_id, topic_id, mastery_score |

## Topic Taxonomy

### Code Format
```
G{grade}_{DOMAIN}_{NN}
```

Examples:
- `G5_NUM_01` - Grade 5, Numbers, Topic 1
- `G8_ALG_02` - Grade 8, Algebra, Topic 2
- `G10_GEO_01` - Grade 10, Geometry, Topic 1

### Domains
| Code | Name | Grades |
|------|------|--------|
| NUM | Numbers | 1-12 |
| ALG | Algebra | 7-12 |
| GEO | Geometry | 1-12 |
| MEA | Measurement | 1-6 |
| DAT | Data/Statistics | 4-12 |
| PRO | Probability | 9-12 |
| FRC | Fractions | 5-6 |

## Running Migrations

```bash
# Create new migration
npx prisma migrate dev --name add_new_feature

# Deploy migrations
npx prisma migrate deploy

# Reset database (dev only)
npx prisma migrate reset
```

## Seeding Data

```bash
# Run all seed scripts
npx prisma db seed

# Or use the Makefile
make seed
```

## Repository Pattern

### Available Repositories

- `TopicRepository` - Topic CRUD and grade-based queries
- `QuestionRepository` - Question filtering, random selection
- `SessionRepository` - Session lifecycle management
- `UserActivityRepository` - History, streak, mastery tracking

### Usage Example

```typescript
@Injectable()
export class QuizService {
  constructor(
    private questionRepo: QuestionRepository,
    private sessionRepo: SessionRepository,
    private activityRepo: UserActivityRepository,
  ) {}

  async startSession(userId: string, grade: number) {
    // Get questions excluding recently seen
    const seenIds = await this.activityRepo.getSeenQuestionIds(userId, {
      since: new Date(Date.now() - 7 * 24 * 60 * 60 * 1000), // 7 days
    });

    const questions = await this.questionRepo.findRandom(
      { grade, qualityStatus: QualityStatus.APPROVED },
      10,
      seenIds,
    );

    // Create session
    const session = await this.sessionRepo.create({
      userId,
      grade,
      totalQuestions: 10,
      expiresAt: new Date(Date.now() + 15 * 60 * 1000), // 15 minutes
    });

    // Add questions to session
    await this.sessionRepo.addSessionQuestions(
      session.id,
      questions.map((q, i) => ({
        ordinal: i + 1,
        refType: 'QUESTION',
        questionId: q.id,
        questionSnapshot: {
          question: q.question,
          options: q.options,
        },
      })),
    );

    return session;
  }
}
```

## Query Optimization

### Indexes

Key indexes for performance:

```sql
-- Session queries
CREATE INDEX idx_sessions_user_started ON sessions(user_id, started_at DESC);
CREATE INDEX idx_sessions_expires ON sessions(expires_at);

-- Question selection
CREATE INDEX idx_questions_grade_topic ON questions(grade, topic_id, difficulty, quality_status);

-- Anti-repeat lookup
CREATE INDEX idx_history_user_seen ON user_question_history(user_id, seen_at DESC);

-- Streak queries
CREATE INDEX idx_activity_user_date ON user_daily_activity(user_id, activity_date DESC);
```

### Pagination

Standard pagination pattern:

```typescript
const { items, total } = await this.repository.findMany(filter, {
  skip: (page - 1) * limit,
  take: limit,
});

const totalPages = Math.ceil(total / limit);
```

## Data Integrity

### Constraints
- Grade must be 1-12
- Difficulty must be 1-5
- Topic codes unique per grade
- Session ordinal 1-10

### Soft Deletes
Use `is_active` flag for topics and questions instead of hard deletes.

### Audit Fields
All entities include:
- `created_at` - Creation timestamp
- `updated_at` - Last modification
- `created_by` - User who created (for content)
- `reviewed_by` - Content reviewer
- `reviewed_at` - Review timestamp
