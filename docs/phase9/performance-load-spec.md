# Phase 9 Performance and Load Specification

## Objectives
- Ensure stable user experience under expected beta load.
- Validate API and worker scalability for session workflows.

## Key Performance Targets (initial baseline)
- Session generation endpoint:
  - P50 <= 350ms
  - P95 <= 1200ms
- Submit endpoint:
  - P95 <= 800ms
- API 5xx rate under load <= agreed threshold.
- Mobile quiz interaction remains responsive on mid-range devices.

## Test Scenarios

### API Load Scenarios
- Constant load at expected beta concurrency.
- Burst load at 2x expected peak.
- Mixed traffic (auth + session + submit + progress).

### Queue/Worker Scenarios
- Reminder scheduling batch run.
- Auto-submit expiration job load.
- Retry handling under transient failures.

### Database Scenarios
- Query latency for session candidate retrieval.
- Contention under concurrent answer submissions.
- Index hit verification for anti-repeat lookups.

## Result Analysis
- Capture latency distributions and error codes.
- Identify bottlenecks (DB, app, queue, external API).
- Document optimization actions and rerun verification.
