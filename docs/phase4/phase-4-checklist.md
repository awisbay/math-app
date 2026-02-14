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
- [ ] Implement `POST /sessions` orchestration service.
- [ ] Enforce fixed rules:
  - [ ] Session duration = 900 seconds.
  - [ ] Total questions = 10.
  - [ ] Language = Indonesian.
- [ ] Implement difficulty distribution policy (default 4 easy, 4 medium, 2 hard; grade-adjustable).
- [ ] Implement topic spread policy to avoid over-concentration.
- [ ] Exclude recent questions using anti-repeat window (default 30 days).
- [ ] Implement question source priority:
  - [ ] Approved fixed bank.
  - [ ] Cached template variants.
  - [ ] On-demand template generation.
- [ ] Persist `sessions`, `session_questions`, and initial state atomically.
- [ ] Implement answer capture endpoint with idempotent behavior.
- [ ] Implement submit endpoint with final scoring and correctness summary.
- [ ] Implement timer expiration auto-submit behavior.

## Data/Integrity Checklist
- [ ] Session creation is transactional.
- [ ] `session_questions.ordinal` always unique 1..10.
- [ ] Prevent duplicate question references inside the same session.
- [ ] Persist every served question to `user_question_history`.
- [ ] Ensure only `quality_status=approved` and `is_active=true` questions are selectable.

## Reliability Checklist
- [ ] Add retries/backoff for template generation failures.
- [ ] Add deterministic fallback path when pool is insufficient.
- [ ] Add request-level timeout guard for session generation.
- [ ] Add structured logs with `request_id`, `session_id`, `user_id`.
- [ ] Add metrics for generation latency and fallback usage.

## Security Checklist
- [ ] Verify user token for all session and answer APIs.
- [ ] Ensure user can access only own session data.
- [ ] Reject answers after session expiration/closure.
- [ ] Validate client payloads strictly.

## Exit Criteria
- [ ] Session generation success rate >= 99% on staging test load.
- [ ] Median generation latency meets target.
- [ ] Repeat rate is below configured threshold.
- [ ] Scoring and timer behavior verified by automated tests.
