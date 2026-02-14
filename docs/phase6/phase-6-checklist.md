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
- [x] Define official streak policy and document business rules.
- [x] Implement daily activity ledger updates (`user_daily_activity`).
- [x] Implement streak update service:
  - [x] Increment on >=1 completed session/day.
  - [x] Reset when day is missed (unless freeze applies).
  - [x] Continue streak when user completes session on consecutive day.
- [x] Implement timezone handling strategy (user-local date derivation).
- [x] Implement `GET /me/streak` API.
- [x] Surface streak status in Home and Profile.
- [x] Implement milestone logic (3/7/14/30 days).
- [ ] Implement reminder scheduling (push notification).
- [ ] Add optional freeze system (1 freeze per 14 days, configurable).

## Data/Integrity Checklist
- [x] Enforce one row per user per activity_date in daily ledger.
- [x] Ensure streak recomputation idempotency.
- [x] Ensure late duplicate submissions do not over-count activity.
- [ ] Store streak audit trail for debugging (optional but recommended).

## Reliability Checklist
- [x] Build scheduled job to evaluate missed-day resets.
- [ ] Handle delayed notification delivery safely.
- [ ] Add retry strategy for push provider failures.
- [ ] Add metrics: streak update success/failure, notification delivery rates.

## Security Checklist
- [x] Streak updates triggered server-side only.
- [x] Prevent client-forged streak increments.
- [x] Validate ownership for streak retrieval endpoints.

## Exit Criteria
- [x] Streak behavior is correct across timezone and day-boundary tests.
- [ ] Notification reminders trigger reliably in staging.
- [x] Abuse vectors are covered with validation and tests.
