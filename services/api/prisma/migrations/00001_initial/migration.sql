-- CreateEnum
CREATE TYPE "question_source_type" AS ENUM ('curated', 'template', 'ai_generated');
CREATE TYPE "quality_status" AS ENUM ('draft', 'review', 'approved', 'rejected', 'archived');
CREATE TYPE "session_status" AS ENUM ('active', 'completed', 'expired', 'abandoned');
CREATE TYPE "question_ref_type" AS ENUM ('question', 'variant');

-- CreateTable
CREATE TABLE "users" (
    "id" TEXT NOT NULL,
    "email" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "birth_date" TIMESTAMP(3),
    "current_grade" INTEGER NOT NULL,
    "firebase_uid" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_grades" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "grade" INTEGER NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT false,
    "unlocked_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_grades_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "topics" (
    "id" TEXT NOT NULL,
    "grade" INTEGER NOT NULL,
    "code" TEXT NOT NULL,
    "name_id" TEXT NOT NULL,
    "name_en" TEXT,
    "description" TEXT,
    "sort_order" INTEGER NOT NULL DEFAULT 0,
    "difficulty_baseline" INTEGER NOT NULL DEFAULT 3,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "topics_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "questions" (
    "id" TEXT NOT NULL,
    "grade" INTEGER NOT NULL,
    "topic_id" TEXT NOT NULL,
    "type" TEXT NOT NULL DEFAULT 'multiple_choice',
    "difficulty" INTEGER NOT NULL DEFAULT 3,
    "source_type" "question_source_type" NOT NULL,
    "quality_status" "quality_status" NOT NULL DEFAULT 'draft',
    "question" TEXT NOT NULL,
    "options" TEXT[],
    "correct_answer" INTEGER NOT NULL,
    "explanation" TEXT,
    "time_limit" INTEGER NOT NULL DEFAULT 90,
    "tags" TEXT[],
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT,
    "reviewed_by" TEXT,
    "reviewed_at" TIMESTAMP(3),

    CONSTRAINT "questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "question_templates" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "topic_id" TEXT NOT NULL,
    "grade" INTEGER NOT NULL,
    "difficulty" INTEGER NOT NULL DEFAULT 3,
    "generator_config" JSONB NOT NULL,
    "validator_config" JSONB,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "quality_status" "quality_status" NOT NULL DEFAULT 'draft',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "question_templates_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "question_variants" (
    "id" TEXT NOT NULL,
    "template_id" TEXT NOT NULL,
    "seed" TEXT NOT NULL,
    "question" TEXT NOT NULL,
    "options" TEXT[],
    "correct_answer" INTEGER NOT NULL,
    "explanation" TEXT,
    "difficulty" INTEGER NOT NULL DEFAULT 3,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "question_variants_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "sessions" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "grade" INTEGER NOT NULL,
    "status" "session_status" NOT NULL DEFAULT 'active',
    "total_questions" INTEGER NOT NULL DEFAULT 10,
    "duration_seconds" INTEGER NOT NULL DEFAULT 900,
    "started_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "completed_at" TIMESTAMP(3),
    "score" INTEGER,
    "correct_answers" INTEGER,
    "total_time_spent" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "sessions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session_questions" (
    "id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "ordinal" INTEGER NOT NULL,
    "ref_type" "question_ref_type" NOT NULL,
    "question_id" TEXT,
    "variant_id" TEXT,
    "question_snapshot" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "session_questions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "session_answers" (
    "id" TEXT NOT NULL,
    "session_question_id" TEXT NOT NULL,
    "selected_option" INTEGER NOT NULL,
    "is_correct" BOOLEAN NOT NULL,
    "time_spent_seconds" INTEGER NOT NULL,
    "answered_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "user_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "session_answers_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_question_history" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "ref_type" "question_ref_type" NOT NULL,
    "question_id" TEXT,
    "variant_id" TEXT,
    "session_id" TEXT,
    "seen_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "was_correct" BOOLEAN,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "user_question_history_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_daily_activity" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "activity_date" TIMESTAMP(3) NOT NULL,
    "completed_sessions" INTEGER NOT NULL DEFAULT 0,
    "total_questions" INTEGER NOT NULL DEFAULT 0,
    "correct_answers" INTEGER NOT NULL DEFAULT 0,
    "total_time_spent" INTEGER NOT NULL DEFAULT 0,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_daily_activity_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_topic_mastery" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "grade" INTEGER NOT NULL,
    "topic_id" TEXT NOT NULL,
    "mastery_score" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "total_attempts" INTEGER NOT NULL DEFAULT 0,
    "correct_attempts" INTEGER NOT NULL DEFAULT 0,
    "last_practiced_at" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_topic_mastery_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_progress" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "total_sessions" INTEGER NOT NULL DEFAULT 0,
    "total_questions" INTEGER NOT NULL DEFAULT 0,
    "correct_answers" INTEGER NOT NULL DEFAULT 0,
    "total_time_spent" INTEGER NOT NULL DEFAULT 0,
    "accuracy" DOUBLE PRECISION NOT NULL DEFAULT 0,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_progress_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_streaks" (
    "id" TEXT NOT NULL,
    "user_id" TEXT NOT NULL,
    "current" INTEGER NOT NULL DEFAULT 0,
    "longest" INTEGER NOT NULL DEFAULT 0,
    "last_completed_at" TIMESTAMP(3),
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_streaks_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "users_email_key" ON "users"("email");
CREATE UNIQUE INDEX "users_firebase_uid_key" ON "users"("firebase_uid");
CREATE INDEX "users_firebase_uid_idx" ON "users"("firebase_uid");
CREATE INDEX "users_current_grade_idx" ON "users"("current_grade");

CREATE UNIQUE INDEX "user_grades_user_id_grade_key" ON "user_grades"("user_id", "grade");
CREATE INDEX "user_grades_user_id_is_active_idx" ON "user_grades"("user_id", "is_active");

CREATE UNIQUE INDEX "topics_grade_code_key" ON "topics"("grade", "code");
CREATE INDEX "topics_grade_is_active_idx" ON "topics"("grade", "is_active");
CREATE INDEX "topics_code_idx" ON "topics"("code");

CREATE INDEX "questions_grade_topic_id_difficulty_quality_status_idx" ON "questions"("grade", "topic_id", "difficulty", "quality_status");
CREATE INDEX "questions_source_type_quality_status_idx" ON "questions"("source_type", "quality_status");
CREATE INDEX "questions_created_at_idx" ON "questions"("created_at");

CREATE UNIQUE INDEX "question_templates_code_key" ON "question_templates"("code");
CREATE INDEX "question_templates_grade_topic_id_is_active_idx" ON "question_templates"("grade", "topic_id", "is_active");
CREATE INDEX "question_templates_quality_status_idx" ON "question_templates"("quality_status");

CREATE UNIQUE INDEX "question_variants_template_id_seed_key" ON "question_variants"("template_id", "seed");
CREATE INDEX "question_variants_template_id_idx" ON "question_variants"("template_id");

CREATE INDEX "sessions_user_id_status_idx" ON "sessions"("user_id", "status");
CREATE INDEX "sessions_user_id_started_at_idx" ON "sessions"("user_id", "started_at");
CREATE INDEX "sessions_expires_at_idx" ON "sessions"("expires_at");

CREATE UNIQUE INDEX "session_questions_session_id_ordinal_key" ON "session_questions"("session_id", "ordinal");
CREATE INDEX "session_questions_session_id_idx" ON "session_questions"("session_id");

CREATE UNIQUE INDEX "session_answers_session_question_id_key" ON "session_answers"("session_question_id");
CREATE INDEX "session_answers_user_id_created_at_idx" ON "session_answers"("user_id", "created_at");

CREATE INDEX "user_question_history_user_id_seen_at_idx" ON "user_question_history"("user_id", "seen_at");
CREATE INDEX "user_question_history_user_id_ref_type_question_id_idx" ON "user_question_history"("user_id", "ref_type", "question_id");

CREATE UNIQUE INDEX "user_daily_activity_user_id_activity_date_key" ON "user_daily_activity"("user_id", "activity_date");
CREATE INDEX "user_daily_activity_user_id_activity_date_idx" ON "user_daily_activity"("user_id", "activity_date");

CREATE UNIQUE INDEX "user_topic_mastery_user_id_topic_id_key" ON "user_topic_mastery"("user_id", "topic_id");
CREATE INDEX "user_topic_mastery_user_id_grade_idx" ON "user_topic_mastery"("user_id", "grade");
CREATE INDEX "user_topic_mastery_topic_id_mastery_score_idx" ON "user_topic_mastery"("topic_id", "mastery_score");

CREATE UNIQUE INDEX "user_progress_user_id_key" ON "user_progress"("user_id");

CREATE UNIQUE INDEX "user_streaks_user_id_key" ON "user_streaks"("user_id");

-- AddForeignKey
ALTER TABLE "user_grades" ADD CONSTRAINT "user_grades_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "questions" ADD CONSTRAINT "questions_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "topics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "question_templates" ADD CONSTRAINT "question_templates_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "topics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "question_variants" ADD CONSTRAINT "question_variants_template_id_fkey" FOREIGN KEY ("template_id") REFERENCES "question_templates"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "sessions" ADD CONSTRAINT "sessions_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "session_questions" ADD CONSTRAINT "session_questions_session_id_fkey" FOREIGN KEY ("session_id") REFERENCES "sessions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "session_questions" ADD CONSTRAINT "session_questions_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "questions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "session_answers" ADD CONSTRAINT "session_answers_session_question_id_fkey" FOREIGN KEY ("session_question_id") REFERENCES "session_questions"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "session_answers" ADD CONSTRAINT "session_answers_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "user_question_history" ADD CONSTRAINT "user_question_history_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "user_question_history" ADD CONSTRAINT "user_question_history_question_id_fkey" FOREIGN KEY ("question_id") REFERENCES "questions"("id") ON DELETE SET NULL ON UPDATE CASCADE;

ALTER TABLE "user_daily_activity" ADD CONSTRAINT "user_daily_activity_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_topic_mastery" ADD CONSTRAINT "user_topic_mastery_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "user_topic_mastery" ADD CONSTRAINT "user_topic_mastery_topic_id_fkey" FOREIGN KEY ("topic_id") REFERENCES "topics"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

ALTER TABLE "user_progress" ADD CONSTRAINT "user_progress_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;

ALTER TABLE "user_streaks" ADD CONSTRAINT "user_streaks_user_id_fkey" FOREIGN KEY ("user_id") REFERENCES "users"("id") ON DELETE CASCADE ON UPDATE CASCADE;
