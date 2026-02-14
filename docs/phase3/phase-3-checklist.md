# Phase 3 Checklist (Data Layer + Content Schema)

## Goal
Establish production-ready data model and content taxonomy for grades 1-12, with migrations, indexing, and seed baseline.

## Scope
- Database schema implementation.
- Migration and versioning strategy.
- Topic taxonomy and grade mapping.
- Seed data pipeline.
- Data integrity and query performance baseline.

## Checklist
- [x] Implement core schema entities:
  - [x] users
  - [x] user_grades
  - [x] topics
  - [x] questions
  - [x] question_templates
  - [x] question_variants
  - [x] sessions
  - [x] session_questions
  - [x] session_answers
  - [x] user_question_history
  - [x] user_daily_activity
  - [x] user_topic_mastery
- [x] Create migration files and naming convention.
- [x] Add foreign keys and constraints for data integrity.
- [x] Add required indexes for session generation and history lookup.
- [x] Define grade/topic taxonomy codes for 1-12.
- [x] Implement seed scripts for:
  - [x] grade/topic master data (72 topics)
  - [x] initial question metadata placeholders
- [x] Add audit columns (`created_at`, `updated_at`, `source_type`, `quality_status`).
- [x] Add soft-delete or active flags where needed.
- [x] Create data access layer conventions (repository/service pattern).
- [x] Validate performance for key read paths with sample data.

## Exit Criteria
- [x] Schema migrations run cleanly in local and staging.
- [x] Seed scripts produce consistent data state.
- [x] Query performance acceptable for planned Phase 4 session generation.
- [x] Data model is documented and approved.
