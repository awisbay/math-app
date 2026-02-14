# Phase 6 Checklist (Streak + Retention System)

## Goal
Implement reliable daily streak and retention mechanics with clear rules, reminders, rewards, and anti-abuse controls.

## Scope
- Daily streak computation.
- Timezone-safe activity tracking.
- Reminder notification flow.
- Milestone rewards.
- Freeze/grace policy (optional).
- Anti-abuse validation.

## Functional Checklist
- [ ] Define official streak policy and document business rules.
- [ ] Implement daily activity ledger updates (`user_daily_activity`).
- [ ] Implement streak update service:
  - [ ] Increment on >=1 completed session/day.
  - [ ] Reset when day is missed (unless freeze applies).
  - [ ] Continue streak when user completes session on consecutive day.
- [ ] Implement timezone handling strategy (user-local date derivation).
- [ ] Implement `GET /me/streak` API.
- [ ] Surface streak status in Home and Profile.
- [ ] Implement milestone logic (3/7/14/30 days).
- [ ] Implement reminder scheduling (push notification).
- [ ] Add optional freeze system (1 freeze per 14 days, configurable).

## Data/Integrity Checklist
- [ ] Enforce one row per user per activity_date in daily ledger.
- [ ] Ensure streak recomputation idempotency.
- [ ] Ensure late duplicate submissions do not over-count activity.
- [ ] Store streak audit trail for debugging (optional but recommended).

## Reliability Checklist
- [ ] Build scheduled job to evaluate missed-day resets.
- [ ] Handle delayed notification delivery safely.
- [ ] Add retry strategy for push provider failures.
- [ ] Add metrics: streak update success/failure, notification delivery rates.

## Security Checklist
- [ ] Streak updates triggered server-side only.
- [ ] Prevent client-forged streak increments.
- [ ] Validate ownership for streak retrieval endpoints.

## Exit Criteria
- [ ] Streak behavior is correct across timezone and day-boundary tests.
- [ ] Notification reminders trigger reliably in staging.
- [ ] Abuse vectors are covered with validation and tests.
