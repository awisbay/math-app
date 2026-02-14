# Phase 4 Backlog (Question Engine v1)

## Priority Legend
- P0: must complete for Phase 4 sign-off.
- P1: strongly recommended for stable rollout.
- P2: optimization/hardening.

## Epic A: Session Orchestration

### P0
- [ ] Implement session creation use case/service.
- [ ] Implement atomic write for session + session_questions + history.
- [ ] Implement session retrieval endpoint for active session.

### P1
- [ ] Add idempotency key support for create/submit requests.

## Epic B: Selection Engine

### P0
- [ ] Implement candidate retrieval by grade/language/status.
- [ ] Implement difficulty bucket allocation.
- [ ] Implement topic spread limiter.
- [ ] Implement no-duplicate-in-session constraint.

### P1
- [ ] Add adaptive topic preference by mastery score.
- [ ] Add policy configuration table/service.

## Epic C: Anti-Repeat + Fallback

### P0
- [ ] Implement anti-repeat query by history window.
- [ ] Implement strict-to-relaxed tier fallback.
- [ ] Implement source priority pipeline (bank -> cached variant -> generated).

### P1
- [ ] Add cooldown policy tuning per grade band.
- [ ] Add observability dashboard for repeat rate.

## Epic D: Answer + Scoring

### P0
- [ ] Implement answer submission endpoint (single answer upsert).
- [ ] Implement final submit endpoint and result summary.
- [ ] Implement timer-expired auto-submit worker/job.

### P1
- [ ] Add scoring strategy interface for future weighted scoring.

## Epic E: Reliability + Security

### P0
- [ ] Add DTO validation and auth guard coverage.
- [ ] Add structured logs and correlation IDs.
- [ ] Add timeout/retry wrapper for generation dependencies.

### P1
- [ ] Add circuit breaker around on-demand generator calls.

## Epic F: Testing

### P0
- [ ] Unit tests for selection, anti-repeat, and scoring logic.
- [ ] Integration tests for session lifecycle APIs.
- [ ] Concurrency test for duplicate session request handling.

### P1
- [ ] Load test and profiling for generation endpoint.
