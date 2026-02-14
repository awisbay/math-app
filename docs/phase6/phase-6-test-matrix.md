# Phase 6 Test Matrix

## A. Streak Core Logic
- [ ] First completion sets streak to 1.
- [ ] Consecutive daily completion increments streak.
- [ ] Multiple completions same day do not double-increment.
- [ ] Missed day resets streak (when no freeze).

## B. Timezone Cases
- [ ] Completion near local midnight counted on correct day.
- [ ] Different user timezones produce independent correct streaks.
- [ ] Timezone change applies prospectively.

## C. Freeze Policy (if enabled)
- [ ] Single missed day consumes freeze and preserves streak.
- [ ] No freeze left causes reset.
- [ ] Freeze cap enforcement works.

## D. Milestones
- [ ] Milestone emitted once on first hit.
- [ ] Re-hitting same count does not duplicate milestone.

## E. Notifications
- [ ] Reminder sent only when user inactive for the day.
- [ ] Reminder suppressed after daily completion.
- [ ] Opt-out users receive no reminders.
- [ ] Delivery retry executes on transient failures.

## F. Security and Abuse
- [ ] Client cannot directly mutate streak count.
- [ ] Duplicate completion events do not inflate streak.
- [ ] Invalid/forged session completion does not update streak.
