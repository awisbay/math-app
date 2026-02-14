# Phase 3 Data Schema Specification

## Architecture Decisions
- Database: PostgreSQL.
- Access: Prisma ORM.
- Migration strategy: forward-only, versioned SQL/Prisma migrations.
- Data ownership: backend service is source of truth.

## Entity Overview

### users
Purpose: account identity and profile baseline.
Key fields:
- `id`, `email`, `full_name`, `birth_date`, `age`, `current_grade`, `streak_count`

### user_grades
Purpose: track unlocked and active grade per user.
Key fields:
- `user_id`, `grade`, `is_active`

### topics
Purpose: grade-scoped topic catalog.
Key fields:
- `id`, `grade`, `code`, `name_id`, `sort_order`

### questions
Purpose: canonical bank questions.
Key fields:
- `grade`, `topic_id`, `difficulty`, `source_type`, `stem_id`, `choices`, `answer_key`, `quality_status`

### question_templates
Purpose: parameterized generators for dynamic variants.
Key fields:
- `code`, `generator_config`, `validator_config`, `difficulty`, `is_active`

### question_variants
Purpose: rendered template outputs per seed.
Key fields:
- `template_id`, `seed`, `rendered_stem_id`, `rendered_choices`, `rendered_answer_key`

### sessions
Purpose: quiz session header state.
Key fields:
- `user_id`, `grade`, `status`, `total_questions`, `duration_seconds`, `started_at`, `expires_at`

### session_questions
Purpose: ordered question assignments per session.
Key fields:
- `session_id`, `question_ref_type`, `question_id`, `variant_id`, `ordinal`

### session_answers
Purpose: answer capture and correctness.
Key fields:
- `session_question_id`, `selected_key`, `is_correct`, `response_time_sec`

### user_question_history
Purpose: anti-repeat tracking.
Key fields:
- `user_id`, `question_ref_type`, `ref_id`, `seen_at`

### user_daily_activity
Purpose: streak ledger.
Key fields:
- `user_id`, `activity_date`, `completed_sessions`

### user_topic_mastery
Purpose: progress signals by topic.
Key fields:
- `user_id`, `grade`, `topic_id`, `mastery_score`, `last_practiced_at`

## Data Integrity Rules
- `grade` must be 1-12.
- `difficulty` must be 1-5.
- Session question `ordinal` must be 1-10.
- Question refs must point to valid question/variant based on type.
- `quality_status` controls visibility in production selection logic.

## Index Strategy (minimum)
- `sessions(user_id, started_at desc)`
- `questions(grade, topic_id, difficulty, is_active, quality_status)`
- `question_variants(grade, topic_id, difficulty, created_at desc)`
- `user_question_history(user_id, seen_at desc)`
- `user_daily_activity(user_id, activity_date desc)`

## Partitioning/Scale Notes (future)
- Consider monthly partition for `session_answers` and `user_question_history` at high volume.
- Add archival policy for old raw answer events.
