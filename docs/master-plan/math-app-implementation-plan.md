# Math App Implementation Plan (Flutter, Indonesia)

## Product Scope (MVP)
- Platform: Flutter (Android + iOS)
- Auth + profile: user account, age, current grade
- Grade flow: default grade from age, user can switch grade manually
- Session rules: 15 minutes, 10 questions, Indonesian only
- Dynamic questions: minimize repeats with history + randomized variants
- Streak: daily streak if user completes >=1 session/day
- Results: score, topic breakdown, progress by grade

## UI/UX Direction
Based on the reference image:
- Rounded cards, soft gradient background, playful visuals, clear spacing
- Colors:
  - Primary `#3D4BEB`
  - Secondary `#6A7BFF`
  - Success `#39D98A`
  - Warning `#FFB020`
  - Error `#FF5A5F`
  - Surface `#F5F7FF`
- Bottom nav: Home, Practice, Progress, Profile
- Quiz screen: timer at top, one question per page, sticky action buttons

## Tech Stack
- FE: Flutter + Riverpod/Bloc + GoRouter
- BE: Firebase Auth + Firestore + Cloud Functions/Cloud Run
- Analytics: Firebase Analytics + Crashlytics
- Push reminders: Firebase Cloud Messaging

## 1) Draft Database Schema (PostgreSQL)

```sql
CREATE TABLE users (
  id UUID PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  full_name TEXT,
  birth_date DATE NOT NULL,
  age INT NOT NULL,
  current_grade SMALLINT NOT NULL CHECK (current_grade BETWEEN 1 AND 12),
  streak_count INT NOT NULL DEFAULT 0,
  last_session_completed_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE user_grades (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  grade SMALLINT NOT NULL CHECK (grade BETWEEN 1 AND 12),
  is_active BOOLEAN NOT NULL DEFAULT false,
  unlocked_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, grade)
);

CREATE TABLE topics (
  id UUID PRIMARY KEY,
  grade SMALLINT NOT NULL CHECK (grade BETWEEN 1 AND 12),
  code TEXT NOT NULL,
  name_id TEXT NOT NULL,
  sort_order INT NOT NULL DEFAULT 0,
  UNIQUE (grade, code)
);

CREATE TABLE questions (
  id UUID PRIMARY KEY,
  grade SMALLINT NOT NULL CHECK (grade BETWEEN 1 AND 12),
  topic_id UUID NOT NULL REFERENCES topics(id),
  difficulty SMALLINT NOT NULL CHECK (difficulty BETWEEN 1 AND 5),
  language_code TEXT NOT NULL DEFAULT 'id',
  source_type TEXT NOT NULL CHECK (source_type IN ('curated','template','ai_generated')),
  stem_id TEXT NOT NULL,
  choices JSONB NOT NULL,
  answer_key TEXT NOT NULL,
  explanation_id TEXT,
  has_image BOOLEAN NOT NULL DEFAULT false,
  image_url TEXT,
  is_active BOOLEAN NOT NULL DEFAULT true,
  quality_status TEXT NOT NULL DEFAULT 'approved' CHECK (quality_status IN ('draft','review','approved','rejected')),
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE question_templates (
  id UUID PRIMARY KEY,
  grade SMALLINT NOT NULL CHECK (grade BETWEEN 1 AND 12),
  topic_id UUID NOT NULL REFERENCES topics(id),
  code TEXT UNIQUE NOT NULL,
  stem_template_id TEXT NOT NULL,
  generator_config JSONB NOT NULL,
  validator_config JSONB NOT NULL,
  difficulty SMALLINT NOT NULL CHECK (difficulty BETWEEN 1 AND 5),
  is_active BOOLEAN NOT NULL DEFAULT true,
  created_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE TABLE question_variants (
  id UUID PRIMARY KEY,
  template_id UUID NOT NULL REFERENCES question_templates(id),
  seed BIGINT NOT NULL,
  rendered_stem_id TEXT NOT NULL,
  rendered_choices JSONB NOT NULL,
  rendered_answer_key TEXT NOT NULL,
  explanation_id TEXT,
  grade SMALLINT NOT NULL CHECK (grade BETWEEN 1 AND 12),
  topic_id UUID NOT NULL REFERENCES topics(id),
  difficulty SMALLINT NOT NULL CHECK (difficulty BETWEEN 1 AND 5),
  language_code TEXT NOT NULL DEFAULT 'id',
  created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  UNIQUE (template_id, seed)
);

CREATE TABLE sessions (
  id UUID PRIMARY KEY,
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  grade SMALLINT NOT NULL CHECK (grade BETWEEN 1 AND 12),
  status TEXT NOT NULL CHECK (status IN ('in_progress','completed','expired','abandoned')),
  total_questions SMALLINT NOT NULL DEFAULT 10,
  duration_seconds INT NOT NULL DEFAULT 900,
  started_at TIMESTAMPTZ NOT NULL,
  expires_at TIMESTAMPTZ NOT NULL,
  completed_at TIMESTAMPTZ
);

CREATE TABLE session_questions (
  id UUID PRIMARY KEY,
  session_id UUID NOT NULL REFERENCES sessions(id) ON DELETE CASCADE,
  question_ref_type TEXT NOT NULL CHECK (question_ref_type IN ('bank','variant')),
  question_id UUID,
  variant_id UUID,
  ordinal SMALLINT NOT NULL CHECK (ordinal BETWEEN 1 AND 10),
  UNIQUE (session_id, ordinal)
);

CREATE TABLE session_answers (
  id UUID PRIMARY KEY,
  session_question_id UUID NOT NULL REFERENCES session_questions(id) ON DELETE CASCADE,
  selected_key TEXT,
  is_correct BOOLEAN,
  response_time_sec INT,
  answered_at TIMESTAMPTZ
);

CREATE TABLE user_question_history (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  question_ref_type TEXT NOT NULL CHECK (question_ref_type IN ('bank','variant','template_seed')),
  ref_id TEXT NOT NULL,
  seen_at TIMESTAMPTZ NOT NULL DEFAULT now(),
  PRIMARY KEY (user_id, question_ref_type, ref_id)
);

CREATE TABLE user_daily_activity (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  activity_date DATE NOT NULL,
  completed_sessions INT NOT NULL DEFAULT 0,
  PRIMARY KEY (user_id, activity_date)
);

CREATE TABLE user_topic_mastery (
  user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  grade SMALLINT NOT NULL,
  topic_id UUID NOT NULL REFERENCES topics(id),
  mastery_score NUMERIC(5,2) NOT NULL DEFAULT 0,
  last_practiced_at TIMESTAMPTZ,
  PRIMARY KEY (user_id, grade, topic_id)
);
```

Recommended indexes:
- `sessions(user_id, started_at DESC)`
- `questions(grade, topic_id, difficulty, is_active, quality_status)`
- `question_variants(grade, topic_id, difficulty, created_at DESC)`
- `user_question_history(user_id, seen_at DESC)`
- `user_daily_activity(user_id, activity_date DESC)`

## 2) Draft API Endpoints (v1)
Base path: `/api/v1`

### Auth/Profile
- `POST /auth/register`
- `POST /auth/login`
- `GET /me`
- `PATCH /me`
- `POST /me/grade-switch`

### Grades/Topics
- `GET /grades`
- `GET /grades/{grade}/topics`

### Sessions
- `POST /sessions`
- `GET /sessions/{sessionId}`
- `POST /sessions/{sessionId}/answers`
- `POST /sessions/{sessionId}/submit`
- `POST /sessions/{sessionId}/heartbeat` (optional)

### Progress/Streak
- `GET /me/streak`
- `GET /me/progress?grade=5`
- `GET /me/history?limit=20`
- `GET /me/recommendations`

### Admin content
- `POST /admin/questions`
- `PATCH /admin/questions/{id}`
- `POST /admin/templates`
- `POST /admin/templates/{id}/generate`
- `POST /admin/review/ai-question`

### Utility
- `GET /health`
- `GET /config/client`

Session generation rules (`POST /sessions`):
- Exactly 10 questions
- Duration 15 minutes
- Difficulty mix e.g. 4 easy, 4 medium, 2 hard (grade-adjusted)
- Exclude seen questions in last 30 days
- Fallback to unseen template seeds if pool is small

## 3) First 200-Question Blueprint (Grades 1-3)
Target:
- Grade 1: 70
- Grade 2: 70
- Grade 3: 60

### Grade 1 (70)
- Bilangan 1-20 (counting/comparison): 14
- Penjumlahan <=20 tanpa simpan: 14
- Pengurangan <=20: 14
- Pola sederhana: 8
- Bentuk 2D dasar: 8
- Ukuran dasar: 6
- Waktu sederhana: 6

### Grade 2 (70)
- Bilangan 1-100 + nilai tempat: 12
- Penjumlahan/pengurangan simpan-pinjam: 16
- Perkalian dasar (2,3,4,5,10): 14
- Pembagian sebagai pengelompokan: 8
- Uang (rupiah) + soal cerita: 8
- Pengukuran: 6
- Bangun datar + keliling sederhana: 6

### Grade 3 (60)
- Bilangan 1-1000 + nilai tempat: 10
- Perkalian/pembagian lanjutan: 12
- Pecahan dasar: 10
- Soal cerita multi-langkah: 10
- Keliling/luas dasar: 8
- Waktu, kalender, durasi: 5
- Data sederhana: 5

Difficulty distribution (200 total):
- Level 1: 40%
- Level 2: 35%
- Level 3: 20%
- Level 4: 5%
- Level 5: 0%

Source composition:
- 60% template-generated
- 30% curated fixed bank
- 10% AI-generated (review required)

Template starter pack:
- G1: 20 templates
- G2: 24 templates
- G3: 22 templates
- 20 seeds/template => 1,320 variants

Example template IDs:
- `G1_ADD_20_NO_CARRY_01`
- `G1_SUB_20_01`
- `G2_MUL_TABLE_5_01`
- `G2_MONEY_RUPIAH_01`
- `G3_FRACTION_COMPARE_01`
- `G3_WORD_PROBLEM_2STEP_01`

## Repo Strategy: Monorepo vs Separate Repos
Recommendation now: **Monorepo first**

Suggested structure:
- `apps/mobile_flutter`
- `services/api`
- `packages/shared_models`
- `docs`

Why now:
- Faster FE+BE iteration
- API/model changes in a single PR
- Simpler CI for early stage

Split later if:
- Team/release cadence becomes independent
- Backend grows significantly
- Security/compliance requires strict separation
