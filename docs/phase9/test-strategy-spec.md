# Phase 9 Test Strategy Specification

## 1. Test Pyramid
- Unit tests (largest volume): core logic and validators.
- Integration tests: API + DB + service coordination.
- End-to-end tests: user-critical workflows.
- Manual exploratory: UX, edge cases, device-specific behavior.

## 2. Coverage Priorities

### Backend Critical Paths
- Auth flow.
- Profile and grade switch.
- Session generation.
- Answer submit and final scoring.
- Streak update and reminder eligibility.

### Mobile Critical Paths
- Login/register.
- Start session.
- Question answering flow.
- Submit and results display.
- Resume interrupted session.

## 3. Regression Strategy
- Maintain fixed regression suite for previously resolved defects.
- Add test case for each high-severity bug fix.
- Execute smoke regression on every staging release.

## 4. Environment Strategy
- Test env mirrors staging config.
- Seed deterministic test data for repeatable runs.
- Isolate performance test data from functional test data.

## 5. Quality Gates
- Unit/integration/e2e pass required for release candidate.
- Manual QA sign-off required for Android and iOS.
- Any failed critical test blocks release.
