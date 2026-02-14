# Phase 2 Checklist (Backend Foundation + Auth)

## Goal
Deliver stable backend foundation with authentication, profile management, and grade switching ready for mobile integration.

## Scope
- Backend service bootstrap and standards.
- Authentication and authorization baseline.
- User profile APIs.
- Grade switch logic.
- Core observability and test baseline.

## Checklist
- [ ] Initialize backend project structure (NestJS + TypeScript strict mode).
- [ ] Setup environment management for local/staging/prod.
- [ ] Configure PostgreSQL connection and Prisma schema baseline.
- [ ] Implement auth module:
  - [ ] Register endpoint.
  - [ ] Login endpoint.
  - [ ] Token validation middleware/guard.
  - [ ] Logout token invalidation strategy (if applicable).
- [ ] Implement user profile module:
  - [ ] `GET /me`
  - [ ] `PATCH /me`
- [ ] Implement grade switch module:
  - [ ] `POST /me/grade-switch`
  - [ ] Validation for grade range 1-12.
- [ ] Implement age-to-default-grade mapping service.
- [ ] Add standardized error response format.
- [ ] Add request logging, basic tracing, and health check endpoint.
- [ ] Add rate limiting for auth endpoints.
- [ ] Add unit + integration tests for auth/profile/grade switch.
- [ ] Generate API documentation for implemented endpoints.

## Exit Criteria
- [ ] Flutter app can register/login and fetch profile using real API.
- [ ] User can update profile and switch grade successfully.
- [ ] Core endpoints are covered by tests and pass CI.
- [ ] Staging environment is deployable and stable.
