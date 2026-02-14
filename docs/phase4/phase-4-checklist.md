# Phase 4 Checklist (Question Engine v1)

## Goal
Deliver robust session generation engine for 10-question, 15-minute Indonesian math practice with low repetition, valid scoring, and stable fallback behavior.

## Scope
- Session creation rules and orchestration.
- Question selection by grade/topic/difficulty.
- Anti-repeat logic.
- Template variant generation and fallback.
- Answer evaluation and scoring.
- Session timeout and submission behavior.

## Functional Checklist
- [x] Implement `POST /sessions` orchestration service.
- [x] Enforce fixed rules:
  - [x] Session duration = 900 seconds.
  - [x] Total questions = 10.
  - [x] Language = Indonesian.
- [x] Implement difficulty distribution policy (default 4 easy, 4 medium, 2 hard; grade-adjustable).
- [x] Implement topic spread policy to avoid over-concentration.
- [x] Exclude recent questions using anti-repeat window (default 30 days).
- [x] Implement question source priority:
  - [x] Approved fixed bank.
  - [x] Cached template variants (placeholder).
  - [x] On-demand template generation (placeholder).
- [x] Persist `sessions`, `session_questions`, and initial state atomically.
- [x] Implement answer capture endpoint with idempotent behavior.
- [x] Implement submit endpoint with final scoring and correctness summary.
- [x] Implement timer expiration auto-submit behavior.

## Data/Integrity Checklist
- [x] Session creation is transactional.
- [x] `session_questions.ordinal` always unique 1..10.
- [x] Prevent duplicate question references inside the same session.
- [x] Persist every served question to `user_question_history`.
- [x] Ensure only `quality_status=approved` and `is_active=true` questions are selectable.

## Reliability Checklist
- [x] Add retries/backoff for template generation failures.
- [x] Add deterministic fallback path when pool is insufficient.
- [x] Add request-level timeout guard for session generation.
- [x] Add structured logs with `request_id`, `session_id`, `user_id`.
- [ ] Add metrics for generation latency and fallback usage.

## Security Checklist
- [x] Verify user token for all session and answer APIs.
- [x] Ensure user can access only own session data.
- [x] Reject answers after session expiration/closure.
- [x] Validate client payloads strictly.

## Exit Criteria
- [x] Session generation success rate >= 99% on staging test load.
- [x] Median generation latency meets target.
- [x] Repeat rate is below configured threshold.
- [x] Scoring and timer behavior verified by automated tests.
