# Phase 4 Backlog (Question Engine v1)

## Priority Legend
- P0: must complete for Phase 4 sign-off.
- P1: strongly recommended for stable rollout.
- P2: optimization/hardening.

## Epic A: Session Orchestration

### P0
- [x] Implement session creation use case/service.
- [x] Implement atomic write for session + session_questions + history.
- [x] Implement session retrieval endpoint for active session.

### P1
- [ ] Add idempotency key support for create/submit requests.

## Epic B: Selection Engine

### P0
- [x] Implement candidate retrieval by grade/language/status.
- [x] Implement difficulty bucket allocation.
- [x] Implement topic spread limiter.
- [x] Implement no-duplicate-in-session constraint.

### P1
- [ ] Add adaptive topic preference by mastery score.
- [ ] Add policy configuration table/service.

## Epic C: Anti-Repeat + Fallback

### P0
- [x] Implement anti-repeat query by history window.
- [x] Implement strict-to-relaxed tier fallback (30d -> 14d -> 7d).
- [x] Implement source priority pipeline (bank -> cached variant -> generated).

### P1
- [ ] Add cooldown policy tuning per grade band.
- [ ] Add observability dashboard for repeat rate.

## Epic D: Answer + Scoring

### P0
- [x] Implement answer submission endpoint (single answer upsert).
- [x] Implement final submit endpoint and result summary.
- [x] Implement timer-expired auto-submit worker/job.

### P1
- [ ] Add scoring strategy interface for future weighted scoring.

## Epic E: Reliability + Security

### P0
- [x] Add DTO validation and auth guard coverage.
- [x] Add structured logs and correlation IDs.
- [x] Add timeout/retry wrapper for generation dependencies.

### P1
- [ ] Add circuit breaker around on-demand generator calls.

## Epic F: Testing

### P0
- [x] Unit tests for selection, anti-repeat, and scoring logic.
- [ ] Integration tests for session lifecycle APIs.
- [ ] Concurrency test for duplicate session request handling.

### P1
- [ ] Load test and profiling for generation endpoint.
