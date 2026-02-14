# Phase 6 Retention and Notification Specification

## Objectives
- Increase daily active learning behavior.
- Encourage streak continuity without aggressive spam.

## Notification Channels
- Primary: Firebase Cloud Messaging push notifications.
- Fallback: in-app reminder banners when notification permission denied.

## Reminder Strategy (Initial)
- Daily reminder at user-preferred local time.
- Gentle nudge if no session completed by configured hour.
- Milestone congratulation notification after achievement.

## Notification Preferences
- User controls:
  - reminders on/off
  - preferred reminder time
- Backend stores preferences and respects opt-out.

## Frequency Controls
- Max 1 reminder/day for standard users.
- Max 1 milestone message/event/day.
- Suppress reminder if session already completed that day.

## Message Guidelines (Indonesian)
- Concise and positive tone.
- Include streak context when relevant.
- Avoid guilt-based wording.

## Event Triggers
- `daily_reminder_scheduled`
- `daily_reminder_sent`
- `daily_reminder_opened`
- `streak_milestone_reached`

## Delivery Reliability
- Queue retries with exponential backoff.
- Dead-letter logging for failed deliveries.
- Track delivery/open rate metrics.
