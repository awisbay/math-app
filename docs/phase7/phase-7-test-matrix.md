# Phase 7 Test Matrix

## A. Ingestion
- [ ] Valid CSV/JSON imports successfully.
- [ ] Invalid schema rows are rejected with clear reason.
- [ ] Import operation is idempotent.

## B. Validation
- [ ] Missing answer key fails.
- [ ] Answer key not in options fails.
- [ ] Duplicate choice options fail.
- [ ] Grade-topic mismatch detected.

## C. Moderation
- [ ] Draft -> review -> approved transition works.
- [ ] Rejected items cannot be published.
- [ ] Reviewer notes are stored and visible.

## D. AI Generation
- [ ] Generated output conforms to contract.
- [ ] Auto-validation blocks low-quality outputs.
- [ ] Approved generated items can be published.

## E. Publishing
- [ ] Publish set activates atomically.
- [ ] Rollback restores previous published state.
- [ ] Non-approved items excluded from publish set.

## F. Quality Monitoring
- [ ] Rejection reason metrics are captured.
- [ ] Post-publish correction events are captured.
