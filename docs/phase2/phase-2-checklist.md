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
- [x] Initialize backend project structure (NestJS + TypeScript strict mode).
- [x] Setup environment management for local/staging/prod.
- [x] Configure PostgreSQL connection and Prisma schema baseline.
- [x] Implement auth module:
  - [x] Register endpoint.
  - [x] Login endpoint.
  - [x] Token validation middleware/guard.
  - [x] Logout token invalidation strategy (if applicable).
- [x] Implement user profile module:
  - [x] `GET /me`
  - [x] `PATCH /me`
- [x] Implement grade switch module:
  - [x] `POST /me/grade-switch`
  - [x] Validation for grade range 1-12.
- [x] Implement age-to-default-grade mapping service.
- [x] Add standardized error response format.
- [x] Add request logging, basic tracing, and health check endpoint.
- [x] Add rate limiting for auth endpoints.
- [x] Add unit + integration tests for auth/profile/grade switch.
- [x] Generate API documentation for implemented endpoints.

## Exit Criteria
- [x] Flutter app can register/login and fetch profile using real API.
- [x] User can update profile and switch grade successfully.
- [x] Core endpoints are covered by tests and pass CI.
- [x] Staging environment is deployable and stable.
