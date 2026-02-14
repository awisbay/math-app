# Phase 8 Observability Specification

## 1. Logging
- Use structured JSON logs across services.
- Required log fields:
  - `timestamp`
  - `level`
  - `service`
  - `request_id`
  - `user_id` (if available)
  - `endpoint`
  - `status_code`
  - `latency_ms`

## 2. Metrics

### API Metrics
- Request count by endpoint/method.
- P50/P95/P99 latency.
- 4xx and 5xx error rates.
- Auth failure rates.

### Session Engine Metrics
- Session generation success rate.
- Fallback tier usage.
- Repeat-rate estimate.

### Worker/Queue Metrics
- Job throughput.
- Retry counts.
- Dead-letter queue size.

### Mobile Quality Metrics
- Crash-free sessions.
- App ANR/freeze indicators.
- API failure impact on user flow.

## 3. Tracing
- Distributed traces for critical workflows:
  - login
  - session generation
  - submit and scoring
  - streak update

## 4. Alerting
Critical alerts:
- API 5xx rate above threshold.
- Session generation failure spike.
- Crash-free rate drop below threshold.
- Notification delivery failures above threshold.

## 5. Incident Handling
- Severity matrix P0-P3.
- On-call ownership for backend/mobile/content.
- Post-incident review template and timeline.
