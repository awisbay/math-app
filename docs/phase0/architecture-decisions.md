# Architecture Decisions (Phase 0)

## ADR-001: Repository Strategy
Decision: Use monorepo for MVP.

Reason:
- Faster FE/BE contract iteration.
- Single PR can update backend API and Flutter model together.
- Lower coordination overhead for small early-stage team.

Structure:
- `apps/mobile_flutter`
- `services/api`
- `packages/shared_models`
- `docs`

## ADR-002: Frontend Stack
Decision: Flutter + Riverpod + GoRouter.

Reason:
- One codebase for Android and iOS.
- Riverpod offers scalable state management with clean testability.
- GoRouter simplifies app navigation and route guards.

## ADR-003: Backend Stack
Decision: Node.js (TypeScript) + NestJS + PostgreSQL + Prisma.

Reason:
- Type-safe backend and maintainable module structure.
- PostgreSQL is reliable for relational analytics and progress queries.
- Prisma improves development speed with schema-driven models.

## ADR-004: Authentication
Decision: Firebase Auth for MVP.

Reason:
- Speeds up secure auth implementation.
- Reduces custom auth risk during early stages.

## ADR-005: Hosting and Runtime
Decision: Google Cloud Run for API, Cloud Storage for assets.

Reason:
- Managed deployment with autoscaling.
- Good integration with Firebase and GCP ecosystem.

## ADR-006: Question Source Strategy
Decision: Hybrid approach.

Composition:
- 60% template-generated variants.
- 30% curated fixed question bank.
- 10% AI-generated with moderation/review gate.

Reason:
- Reduces repetition.
- Keeps quality stable with curated base.
- Enables scalable content expansion.

## ADR-007: Session Rules
Decision:
- Session duration = 900 seconds.
- Question count = 10.
- Grade range = 1-12.
- Language = Indonesian.

Reason:
- Matches product learning loop and user expectation.

## ADR-008: Observability
Decision: Firebase Analytics + Crashlytics + backend logs/metrics.

Reason:
- Fast production visibility for beta iteration.
