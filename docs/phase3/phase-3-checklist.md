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
- [ ] Implement core schema entities:
  - [ ] users
  - [ ] user_grades
  - [ ] topics
  - [ ] questions
  - [ ] question_templates
  - [ ] question_variants
  - [ ] sessions
  - [ ] session_questions
  - [ ] session_answers
  - [ ] user_question_history
  - [ ] user_daily_activity
  - [ ] user_topic_mastery
- [ ] Create migration files and naming convention.
- [ ] Add foreign keys and constraints for data integrity.
- [ ] Add required indexes for session generation and history lookup.
- [ ] Define grade/topic taxonomy codes for 1-12.
- [ ] Implement seed scripts for:
  - [ ] grade/topic master data
  - [ ] initial question metadata placeholders
- [ ] Add audit columns (`created_at`, `updated_at`, `source_type`, `quality_status`).
- [ ] Add soft-delete or active flags where needed.
- [ ] Create data access layer conventions (repository/service pattern).
- [ ] Validate performance for key read paths with sample data.

## Exit Criteria
- [ ] Schema migrations run cleanly in local and staging.
- [ ] Seed scripts produce consistent data state.
- [ ] Query performance acceptable for planned Phase 4 session generation.
- [ ] Data model is documented and approved.
