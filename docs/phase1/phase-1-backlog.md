# Phase 1 Backlog (UI/UX Implementation)

## Priority Legend
- P0: mandatory before Phase 2 integration.
- P1: required for polished beta-ready UX.
- P2: enhancements.

## Epic A: Design System Foundation

### P0
- [x] Define token files in Flutter (`colors`, `typography`, `spacing`, `radius`, `shadows`).
- [x] Create base theme (`lightTheme`) using tokens only.
- [x] Create reusable button component set.
- [x] Create reusable card component set.

### P1
- [x] Add theme extensions for gradients and quiz-specific states.
- [x] Add component preview/demo screen.

## Epic B: Navigation & Shell

### P0
- [x] Implement app shell with bottom navigation.
- [x] Configure route map with GoRouter.
- [x] Add route guards for auth-required screens.

### P1
- [ ] Add deep-link placeholders for future campaign links.

## Epic C: Screen Implementation

### P0
- [x] Build Onboarding/Auth UI.
- [x] Build Home UI with grade chips and start CTA.
- [x] Build Quiz UI with timer container and answer options.
- [x] Build Results UI with summary and next-action CTA.
- [x] Build Progress UI baseline.
- [x] Build Profile UI baseline.

### P1
- [x] Add empty/loading/error states for all screens.
- [x] Add consistent skeleton loaders.

## Epic D: UX Quality

### P0
- [x] Add state handling for button disabled/loading transitions.
- [x] Add confirmation dialog when exiting active quiz.
- [x] Add Indonesian text consistency pass for labels.

### P1
- [x] Add micro animations (screen transitions, answer selection feedback).
- [ ] Add haptics for answer confirmation (where supported).

## Epic E: QA and Acceptance

### P0
- [ ] Widget tests for shared components.
- [ ] Golden tests for key screens (optional if setup exists).
- [ ] Manual QA run using Phase 1 acceptance checklist.

### P1
- [ ] Accessibility test pass for touch targets and semantics.
