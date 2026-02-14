# Initial Backlog (Phase 1 and Phase 2)

## Priority Legend
- P0: must-have before any beta build.
- P1: must-have for closed beta.
- P2: important but can follow after beta.

## Phase 1 (UI/UX System) Backlog

### P0
- [ ] Create Flutter theme tokens (color, spacing, radius, typography).
- [ ] Implement reusable UI components:
  - [ ] App cards.
  - [ ] Grade chips.
  - [ ] Answer option buttons.
  - [ ] Timer badge.
  - [ ] Bottom navigation.
- [ ] Build static screen shells:
  - [ ] Home.
  - [ ] Quiz.
  - [ ] Results.
  - [ ] Progress.
  - [ ] Profile.

### P1
- [ ] Add loading/empty/error states for all core screens.
- [ ] Add responsive behavior for small and large phone layouts.
- [ ] Add basic animations for transitions and quiz interactions.

### P2
- [ ] Refine micro-interactions and haptic feedback.
- [ ] Add more visual illustrations per category.

## Phase 2 (Backend Foundation + Auth) Backlog

### P0
- [ ] Setup NestJS service with TypeScript strict mode.
- [ ] Setup PostgreSQL and Prisma schema baseline.
- [ ] Implement auth endpoints:
  - [ ] Register.
  - [ ] Login.
  - [ ] Token verification middleware.
- [ ] Implement profile endpoints:
  - [ ] Get current user profile.
  - [ ] Update age/birth date/current grade.
- [ ] Implement grade switch endpoint with validation.

### P1
- [ ] Add audit logging for auth/profile mutations.
- [ ] Add rate-limiting for auth endpoints.
- [ ] Add integration tests for auth and profile flows.

### P2
- [ ] Add account recovery and email verification hardening.
- [ ] Add admin role scaffolding.

## Cross-Cutting Setup Tasks
- [ ] Setup monorepo lint and formatting rules.
- [ ] Add CI pipeline:
  - [ ] lint
  - [ ] unit tests (smoke)
  - [ ] Flutter analyze/build check
- [ ] Add PR template and Definition of Done checklist.
- [ ] Add environment config templates for local/staging/prod.

## Done Criteria for Starting Phase 3
- [ ] Auth + profile flows are usable from Flutter app.
- [ ] UI component system is stable and reused across screens.
- [ ] CI passes on main branch.
- [ ] Team has clear owner per module (mobile/api/content).
