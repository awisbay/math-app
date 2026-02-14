# Phase 5 Test Matrix

## A. Authentication
- [ ] Register flow success.
- [ ] Login flow success.
- [ ] Invalid credential error handling.
- [ ] Token expiry redirect behavior.

## B. Profile and Grade
- [ ] Profile fetch on app open.
- [ ] Profile update persistence.
- [ ] Grade switch updates home and session context.

## C. Session and Quiz
- [ ] Session creation shows 10 ordered questions.
- [ ] Timer countdown and expiration behavior.
- [ ] Single answer submit per question path works.
- [ ] Network failure during answer submit handled safely.
- [ ] Final submit returns and renders results correctly.

## D. Recovery and State
- [ ] In-progress quiz recover after app restart.
- [ ] Duplicate submit tap does not double-submit.
- [ ] App handles offline transition gracefully.

## E. UI/UX
- [ ] Layout integrity on small and large devices.
- [ ] Loading/empty/error states visible and actionable.
- [ ] Navigation stack behavior correct across tabs.

## F. Performance
- [ ] Home initial render acceptable.
- [ ] Quiz interactions responsive.
- [ ] No visible jank on key transitions.
