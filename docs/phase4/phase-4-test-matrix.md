# Phase 4 Test Matrix

## A. Session Generation
- [ ] Returns exactly 10 questions.
- [ ] All questions match selected grade.
- [ ] All questions are Indonesian language entries.
- [ ] Difficulty distribution follows policy.
- [ ] Topic spread constraints are respected.

## B. Anti-Repeat
- [ ] Recently seen question not served under strict window.
- [ ] Relaxation tier is triggered only when needed.
- [ ] No duplicate questions within same session.

## C. Template Variant Fallback
- [ ] Uses pre-generated variants when fixed bank insufficient.
- [ ] Uses on-demand generation when cached variants insufficient.
- [ ] Fails gracefully with structured error if all tiers exhausted.

## D. Answer and Scoring
- [ ] Correct answer increments score.
- [ ] Wrong/unanswered scored as 0.
- [ ] Duplicate answer submit remains idempotent.
- [ ] Final submit recalculates consistent score.

## E. Timer and Expiration
- [ ] Session expires at `started_at + 900s`.
- [ ] Auto-submit triggers on expiration.
- [ ] Post-expiration answer attempts are rejected.

## F. Security
- [ ] Unauthorized access to session endpoints is blocked.
- [ ] User cannot read/update another user's session.
- [ ] Invalid payloads return validation errors.

## G. Performance
- [ ] P50 and P95 generation latency within targets.
- [ ] Error rate within acceptable threshold.
- [ ] Load test verifies stability at expected concurrency.
