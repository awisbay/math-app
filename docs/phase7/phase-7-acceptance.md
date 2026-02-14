# Phase 7 Acceptance Criteria

## Functional Acceptance
- [ ] Content ingestion, validation, moderation, and publish flows all operate end-to-end.
- [ ] First batch (200 questions) can be processed with traceable status per item.
- [ ] Only approved + published questions are eligible for serving.

## Quality Acceptance
- [ ] Validation checks cover schema, answer integrity, and language baseline.
- [ ] Rejection reason taxonomy is implemented and reportable.
- [ ] Reviewer workflow is documented and reproducible.

## Reliability Acceptance
- [ ] Import and publish workflows are idempotent where applicable.
- [ ] Rollback procedure tested successfully.
- [ ] Monitoring dashboard provides actionable quality signals.

## Governance Acceptance
- [ ] Audit trails exist for status transitions and reviewer decisions.
- [ ] Content versioning/changelog process is in place.

## Exit Decision
Phase 7 is complete when all P0 backlog items, critical test matrix checks, and acceptance criteria are satisfied.
