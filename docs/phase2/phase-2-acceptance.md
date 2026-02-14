# Phase 2 Acceptance Criteria

## Functional Acceptance
- [ ] New user can register and login using real backend.
- [ ] Authenticated user can fetch profile via `GET /me`.
- [ ] Authenticated user can update profile via `PATCH /me`.
- [ ] Authenticated user can switch grade (1-12) via `POST /me/grade-switch`.
- [ ] Invalid grade payloads are rejected with clear validation error.

## Security Acceptance
- [ ] Protected endpoints reject missing/invalid tokens.
- [ ] Auth endpoints have rate limiting.
- [ ] Sensitive data is not leaked in errors/logs.

## Quality Acceptance
- [ ] Unit/integration tests pass for implemented modules.
- [ ] API docs are updated and accurate.
- [ ] `/health` is stable in staging.

## Integration Acceptance
- [ ] Flutter app can complete auth + profile + grade-switch flow in staging.
- [ ] No blocking API contract mismatch for Phase 3 handoff.

## Exit Decision
Phase 2 is complete when all P0 backlog items and all acceptance criteria are checked.
