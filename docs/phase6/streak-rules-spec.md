# Phase 6 Streak Rules Specification

## 1. Core Definitions
- Active day: a local calendar day where user completes >=1 valid session.
- Consecutive day: next local calendar day after previous active day.
- Streak count: number of consecutive active days ending at current/latest active day.

## 2. Primary Rule Set
- If user completes a session on day D and had activity on day D-1, streak += 1.
- If user completes first-ever session, streak = 1.
- If user misses one or more days, streak resets to 1 on next completion day.
- Multiple completions in same day do not increment streak more than once.

## 3. Timezone Handling
- Store canonical timestamps in UTC.
- Convert to user-local date using profile timezone setting.
- Day boundary follows user timezone, not server timezone.
- If timezone changes, apply change prospectively (from update time onward).

## 4. Freeze Policy (Optional v1.1)
- User receives 1 freeze every 14 active days (configurable).
- Freeze auto-consumes when exactly one day is missed.
- Freeze cannot stack beyond configured cap.
- Freeze usage is logged for audit.

## 5. Milestones
- Milestone days: 3, 7, 14, 30, 60, 100.
- Milestone event emitted on first hit only.
- Milestone grants badge/reward metadata for UI display.

## 6. Edge Cases
- Late submit just after midnight local time counts for new day.
- Session started before midnight and completed after midnight counts by completion timestamp.
- Backfilled historical events are disallowed in production paths.

## 7. Data Source of Truth
- `user_daily_activity` controls streak derivation.
- `users.streak_count` is denormalized cache and must match computed value.
