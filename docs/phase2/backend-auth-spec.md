# Phase 2 Backend Auth Specification

## Architecture Overview
- Runtime: Node.js LTS + TypeScript.
- Framework: NestJS.
- Database: PostgreSQL.
- ORM: Prisma.
- Auth provider: Firebase Auth (recommended) or custom JWT.
- Deployment target: Cloud Run.

## Modules
- `auth` module
- `users` module
- `grades` module
- `health` module
- `shared` module (error handling, DTO validation, guards)

## Authentication Flows

### Option A (Recommended): Firebase Auth
1. Mobile app authenticates with Firebase SDK.
2. Mobile sends Firebase ID token to backend.
3. Backend verifies token and maps `firebase_uid` to internal user record.
4. Backend returns app profile payload.

### Option B: Custom JWT
1. Register/login handled directly by backend.
2. Passwords hashed with Argon2/Bcrypt.
3. Access + refresh token strategy required.

## User Profile Rules
- Required fields: `birth_date`, `age`, `current_grade`.
- `current_grade` must be between 1 and 12.
- If user has no explicit grade, backend computes default from age mapping.
- Grade switch is always explicit and audited.

## Default Grade Mapping (initial)
- Age 6-7 -> grade 1
- Age 7-8 -> grade 2
- Age 8-9 -> grade 3
- Age 9-10 -> grade 4
- Age 10-11 -> grade 5
- Age 11-12 -> grade 6
- Age 12-13 -> grade 7
- Age 13-14 -> grade 8
- Age 14-15 -> grade 9
- Age 15-16 -> grade 10
- Age 16-17 -> grade 11
- Age 17-18 -> grade 12

Note: mapping can be overridden by user choice.

## Security Requirements
- Enforce HTTPS only.
- Validate all request payloads using DTO/schema validation.
- Never trust client-provided user ID.
- Apply per-IP/per-account rate limits for auth endpoints.
- Store secrets in secret manager/environment, never in repo.

## Error Contract
Standard response for API errors:
- `code`: machine-readable code
- `message`: human-readable summary
- `details`: optional field-level errors
- `request_id`: correlation id

## Logging and Observability
- Include request id for all requests.
- Log auth failures with reason category (no secrets).
- Provide `/health` and `/ready` probes.
- Emit metrics: latency, 4xx/5xx counts, auth success/failure counts.
