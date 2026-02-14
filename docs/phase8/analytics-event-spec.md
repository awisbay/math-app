# Phase 8 Analytics Event Specification

## Principles
- Event names are stable, snake_case, and versioned when changed.
- Payload fields are explicit and typed.
- No sensitive personal data in analytics events.

## Core Product Events

### Authentication
- `auth_register_success`
- `auth_login_success`
- `auth_login_failed`

Fields:
- `user_id` (hashed/opaque id)
- `platform` (`android`/`ios`)
- `timestamp`

### Session Lifecycle
- `session_start`
- `session_question_view`
- `session_answer_submit`
- `session_submit`
- `session_complete`
- `session_expired`

Fields:
- `session_id`
- `grade`
- `topic_code` (where applicable)
- `question_ordinal`
- `is_correct` (for submit events)
- `response_time_ms`
- `duration_elapsed_sec`

### Streak/Retention
- `streak_updated`
- `streak_milestone_reached`
- `reminder_sent`
- `reminder_opened`

Fields:
- `streak_count`
- `milestone`
- `notification_type`

### Profile
- `grade_switched`
- `profile_updated`

Fields:
- `old_grade`
- `new_grade`

## Event Versioning
- Add `event_version` integer in payload.
- Breaking payload changes must increment event version.

## Validation Rules
- Reject events missing required fields.
- Track event drop rate and parse errors.
- Ensure timestamp source is consistent (client vs server).
