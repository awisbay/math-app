# Phase 9 Backlog (QA + Security + Performance)

## Priority Legend
- P0: required for Phase 9 completion.
- P1: important hardening.
- P2: extended optimization.

## Epic A: QA Execution

### P0
- [ ] Complete automated test run for backend and mobile.
- [ ] Complete manual QA scripts on Android and iOS.
- [ ] Close/triage all critical regressions.

### P1
- [ ] Expand edge-case and negative-path e2e scenarios.

## Epic B: Security Hardening

### P0
- [ ] Run dependency vulnerability scans.
- [ ] Fix or mitigate critical/high findings.
- [ ] Verify authz ownership checks across APIs.
- [ ] Validate logging redaction and safe errors.

### P1
- [ ] Add automated security linting in CI pipeline.

## Epic C: Performance and Scalability

### P0
- [ ] Execute API load test plan.
- [ ] Profile and optimize top slow endpoints.
- [ ] Validate queue worker throughput and retries.

### P1
- [ ] Introduce caching/tuning for hot query paths.

## Epic D: Release Operations

### P0
- [ ] Execute release readiness gate checklist.
- [ ] Verify rollback procedures end-to-end.
- [ ] Prepare launch monitoring playbook.

### P1
- [ ] Build automated release report artifact.
