# Phase 3 Backlog (Data Layer + Content Schema)

## Priority Legend
- P0: required for Phase 4 start.
- P1: strong stability/performance improvements.
- P2: scalability enhancements.

## Epic A: Schema Implementation

### P0
- [x] Translate approved schema into Prisma models.
- [x] Create initial migration for all core tables.
- [x] Add constraints and foreign keys.
- [x] Add enum/check constraints for status fields.

### P1
- [x] Add db-level defaults and triggers for updated timestamps.
- [x] Add partial indexes for active question filtering.

## Epic B: Seed and Taxonomy

### P0
- [x] Seed topics for grades 1-12.
- [x] Seed grade metadata and sample placeholders.
- [x] Validate uniqueness for topic code by grade.

### P1
- [x] Add seed verification command.
- [ ] Add taxonomy diff checker to prevent accidental removals.

## Epic C: Query Performance

### P0
- [x] Add critical indexes for read-heavy paths.
- [x] Benchmark key queries with sample dataset.
- [x] Optimize anti-repeat lookup query path.

### P1
- [ ] Add query observability logs for slow SQL.
- [ ] Add read model/helper views if needed.

## Epic D: Data Access Layer

### P0
- [x] Create repository patterns for users/topics/questions/sessions.
- [x] Standardize pagination + filtering conventions.
- [x] Add transactional utility for session-write operations.

### P1
- [ ] Add caching strategy draft for Phase 4 session generation.

## Epic E: Testing & Reliability

### P0
- [ ] Migration tests (up/down where supported).
- [ ] Seed idempotency test.
- [x] Integration test for data integrity constraints.

### P1
- [ ] Synthetic load test on question selection query.
