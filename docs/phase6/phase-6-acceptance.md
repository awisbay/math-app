# Phase 6 Acceptance Criteria

## Functional Acceptance
- [ ] Daily streak updates correctly for all core scenarios.
- [ ] `GET /me/streak` returns accurate count and metadata.
- [ ] Milestones are computed and exposed correctly.

## Retention Acceptance
- [ ] Reminder scheduling works with user preferences.
- [ ] Notifications are not over-sent and respect daily limits.
- [ ] Home screen reflects up-to-date streak state.

## Reliability Acceptance
- [ ] Scheduler and push workflows are stable in staging.
- [ ] Date-boundary logic validated with automated tests.
- [ ] Error handling and retries are in place.

## Security Acceptance
- [ ] Streak cannot be manipulated via client payload tampering.
- [ ] Ownership and token validation enforced on streak endpoints.

## Exit Decision
Phase 6 is complete when all P0 backlog items, key test matrix checks, and acceptance criteria are satisfied.
