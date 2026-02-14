# Phase 5 Checklist (Flutter Core App)

## Goal
Ship complete mobile app core flow in Flutter (Android/iOS) integrated with backend foundation and question engine.

## Scope
- App architecture and routing.
- Auth/profile integration.
- Home, quiz, results, progress, profile screens.
- API integration with loading/error handling.
- Local persistence and session resilience.

## Functional Checklist
- [ ] Setup Flutter app architecture with modular folders.
- [ ] Setup global app theme from Phase 1 tokens.
- [ ] Configure GoRouter with route guards.
- [ ] Implement authentication flow:
  - [ ] Register screen.
  - [ ] Login screen.
  - [ ] Session/token persistence.
- [ ] Implement onboarding/profile bootstrap:
  - [ ] Birth date input.
  - [ ] Current grade setup.
  - [ ] Grade switch flow.
- [ ] Implement Home screen:
  - [ ] Greeting + streak summary.
  - [ ] Grade chips.
  - [ ] Start session CTA.
  - [ ] Recent performance card.
- [ ] Implement Quiz screen:
  - [ ] Timer display synced with backend expiry.
  - [ ] Question pager 1..10.
  - [ ] Answer selection state.
  - [ ] Previous/Next/Submit actions.
- [ ] Implement Results screen:
  - [ ] Score and percentage.
  - [ ] Correct/incorrect count.
  - [ ] Topic-level breakdown.
- [ ] Implement Progress screen:
  - [ ] Session history list.
  - [ ] Topic mastery summary.
  - [ ] Grade filter.
- [ ] Implement Profile screen:
  - [ ] User data view/edit.
  - [ ] Notification preference toggle.
  - [ ] Logout action.

## Integration Checklist
- [ ] Integrate auth APIs.
- [ ] Integrate profile APIs.
- [ ] Integrate session APIs (`create`, `answer`, `submit`).
- [ ] Integrate progress APIs.
- [ ] Handle API error states consistently.

## Reliability Checklist
- [ ] Persist active session state locally for app resume.
- [ ] Recover in-progress quiz after app restart.
- [ ] Prevent duplicate submit button taps.
- [ ] Add global error boundary handling.

## Accessibility Checklist
- [ ] Semantic labels for key actions and quiz answers.
- [ ] Minimum touch target 44x44.
- [ ] Font scaling behavior verified.

## Exit Criteria
- [ ] End-to-end flow works on Android and iOS in staging.
- [ ] Core screens are stable and responsive.
- [ ] No blocker UI/API integration issues.
