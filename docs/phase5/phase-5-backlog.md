# Phase 5 Backlog (Flutter Core App)

## Priority Legend
- P0: must complete for Phase 5 sign-off.
- P1: high value for beta stability.
- P2: enhancement.

## Epic A: App Foundation

### P0
- [ ] Setup feature module skeleton and shared core.
- [ ] Setup theme and typography from tokens.
- [ ] Setup router and route guards.
- [ ] Setup network client and auth interceptor.

### P1
- [ ] Add environment switch tooling for dev/staging/prod.

## Epic B: Auth + Onboarding + Profile

### P0
- [ ] Build register/login screens.
- [ ] Implement token persistence + auto-login restore.
- [ ] Build profile bootstrap flow (age/birth date/grade).
- [ ] Implement profile update UI and API wiring.

### P1
- [ ] Add form analytics and validation quality logs.

## Epic C: Home and Quiz Flow

### P0
- [ ] Build home dashboard with grade selector.
- [ ] Implement start session action and loading states.
- [ ] Build quiz page with timer and pager.
- [ ] Implement answer submission and local optimistic update.
- [ ] Implement final submit + navigation to results.

### P1
- [ ] Add graceful recovery for interrupted session.

## Epic D: Results and Progress

### P0
- [ ] Build results page with breakdown and next CTA.
- [ ] Build progress page with history and topic mastery.
- [ ] Implement grade filter persistence.

### P1
- [ ] Add richer charts/visualization improvements.

## Epic E: Quality and Testing

### P0
- [ ] Unit tests for notifiers/use cases.
- [ ] Widget tests for key screens.
- [ ] Integration test for end-to-end happy path.
- [ ] Manual QA checklist run on Android and iOS.

### P1
- [ ] Golden tests for main screens.
- [ ] Accessibility-focused test pass.
