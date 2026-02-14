# Phase 2 Backlog (Backend Foundation + Auth)

## Priority Legend
- P0: required before Phase 3.
- P1: needed for stable staging.
- P2: hardening and expansion.

## Epic A: Service Bootstrap

### P0
- [x] Create NestJS project scaffold with module boundaries.
- [x] Setup TypeScript strict mode and linting.
- [x] Setup Prisma with PostgreSQL and initial migration.
- [x] Setup environment config loader with validation.

### P1
- [x] Add Dockerfile and local compose for DB.
- [x] Add make/scripts for common commands.

## Epic B: Authentication

### P0
- [x] Implement register endpoint.
- [x] Implement login endpoint.
- [x] Implement auth guard/token verification.
- [x] Add password policy (if custom auth path).

### P1
- [ ] Add refresh token support (if needed).
- [ ] Add email verification path.

### P2
- [ ] Add account recovery flow.

## Epic C: User Profile + Grade

### P0
- [x] Implement `GET /me`.
- [x] Implement `PATCH /me`.
- [x] Implement `POST /me/grade-switch`.
- [x] Implement age-to-grade default mapping service.

### P1
- [ ] Add grade-switch audit trail table and endpoint log.
- [ ] Add validations for edge-case ages and birthday updates.

## Epic D: Reliability + Security

### P0
- [x] Standardized API error handler and response shape.
- [x] Rate limit auth endpoints.
- [x] Add `/health` endpoint.
- [x] Add request logging with correlation IDs.

### P1
- [x] Add `/ready` endpoint for deployment checks.
- [ ] Add baseline metrics and dashboards.

## Epic E: Testing + CI

### P0
- [x] Unit tests for mapping logic and validators.
- [ ] Integration tests for auth/profile/grade-switch endpoints.
- [x] CI checks: lint + unit + integration (or smoke integration).

### P1
- [ ] Add contract tests for API response schema.
