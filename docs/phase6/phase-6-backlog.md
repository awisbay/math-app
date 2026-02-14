# Phase 6 Backlog (Streak + Retention)

## Priority Legend
- P0: must-have for Phase 6 completion.
- P1: strong quality improvements.
- P2: enhancements.

## Epic A: Streak Engine

### P0
- [ ] Implement daily activity upsert on session completion.
- [ ] Implement streak computation service (timezone-aware).
- [ ] Implement streak cache sync (`users.streak_count`).
- [ ] Implement `GET /me/streak` endpoint.

### P1
- [ ] Add streak recompute command for admin repair.
- [ ] Add streak audit events table.

## Epic B: Milestones and Rewards

### P0
- [ ] Implement milestone detection logic.
- [ ] Persist milestone achievements for UI.
- [ ] Expose milestone list in streak response.

### P1
- [ ] Add reward metadata and badge asset linkage.

## Epic C: Notifications

### P0
- [ ] Store user reminder preferences.
- [ ] Implement daily reminder scheduler/job.
- [ ] Implement send workflow via FCM.
- [ ] Skip reminders for users already active that day.

### P1
- [ ] Add A/B-ready message template variants.
- [ ] Add quiet-hours policy.

## Epic D: Anti-Abuse

### P0
- [ ] Enforce server-side streak updates only.
- [ ] Detect and ignore duplicate completion events.
- [ ] Validate session completion legitimacy before streak increment.

### P1
- [ ] Add anomaly detection for suspicious completion patterns.

## Epic E: Testing + Observability

### P0
- [ ] Unit tests for streak transitions and date boundary logic.
- [ ] Integration tests for session completion -> streak update pipeline.
- [ ] Metrics dashboard for streak and notification health.

### P1
- [ ] Load test scheduler and notification queue throughput.
