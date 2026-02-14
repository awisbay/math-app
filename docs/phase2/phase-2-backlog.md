# Phase 2 Backlog (Backend Foundation + Auth)

## Priority Legend
- P0: required before Phase 3.
- P1: needed for stable staging.
- P2: hardening and expansion.

## Epic A: Service Bootstrap

### P0
- [ ] Create NestJS project scaffold with module boundaries.
- [ ] Setup TypeScript strict mode and linting.
- [ ] Setup Prisma with PostgreSQL and initial migration.
- [ ] Setup environment config loader with validation.

### P1
- [ ] Add Dockerfile and local compose for DB.
- [ ] Add make/scripts for common commands.

## Epic B: Authentication

### P0
- [ ] Implement register endpoint.
- [ ] Implement login endpoint.
- [ ] Implement auth guard/token verification.
- [ ] Add password policy (if custom auth path).

### P1
- [ ] Add refresh token support (if needed).
- [ ] Add email verification path.

### P2
- [ ] Add account recovery flow.

## Epic C: User Profile + Grade

### P0
- [ ] Implement `GET /me`.
- [ ] Implement `PATCH /me`.
- [ ] Implement `POST /me/grade-switch`.
- [ ] Implement age-to-grade default mapping service.

### P1
- [ ] Add grade-switch audit trail table and endpoint log.
- [ ] Add validations for edge-case ages and birthday updates.

## Epic D: Reliability + Security

### P0
- [ ] Standardized API error handler and response shape.
- [ ] Rate limit auth endpoints.
- [ ] Add `/health` endpoint.
- [ ] Add request logging with correlation IDs.

### P1
- [ ] Add `/ready` endpoint for deployment checks.
- [ ] Add baseline metrics and dashboards.

## Epic E: Testing + CI

### P0
- [ ] Unit tests for mapping logic and validators.
- [ ] Integration tests for auth/profile/grade-switch endpoints.
- [ ] CI checks: lint + unit + integration (or smoke integration).

### P1
- [ ] Add contract tests for API response schema.
