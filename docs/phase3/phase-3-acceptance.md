# Phase 3 Acceptance Criteria

## Functional Acceptance
- [ ] All core tables/entities are created and operational in staging.
- [ ] Topic taxonomy exists for grades 1-12 with unique codes.
- [ ] Seed scripts run successfully and are idempotent.

## Data Integrity Acceptance
- [ ] Invalid grades/difficulties are rejected by schema constraints.
- [ ] Broken foreign key inserts are rejected.
- [ ] Required metadata fields are enforced for question records.

## Performance Acceptance
- [ ] Critical read queries meet baseline latency targets in staging dataset.
- [ ] Anti-repeat lookup path is index-backed.

## Reliability Acceptance
- [ ] Migrations are versioned, reproducible, and documented.
- [ ] Data model documentation is aligned with actual schema.

## Exit Decision
Phase 3 is complete when all P0 backlog items and all acceptance criteria are checked.
