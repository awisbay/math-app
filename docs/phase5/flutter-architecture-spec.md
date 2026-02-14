# Phase 5 Flutter Architecture Specification

## Architecture Style
Recommended: Feature-first with shared core layers.

## Folder Structure (recommended)
- `lib/app/`
  - app bootstrap, router, theme
- `lib/core/`
  - networking, error handling, logging, storage, constants
- `lib/features/auth/`
- `lib/features/profile/`
- `lib/features/home/`
- `lib/features/quiz/`
- `lib/features/progress/`
- `lib/features/settings/`
- `lib/shared/`
  - reusable widgets, models, extensions

## Layering Per Feature
- `data/`
  - DTOs, API clients, repository implementations
- `domain/`
  - entities, repository contracts, use cases
- `presentation/`
  - screens, widgets, state providers/notifiers

## State Management
- Use Riverpod for global and feature states.
- Use `StateNotifier`/`Notifier` for async workflows.
- Keep screen state immutable and serializable where possible.

## Routing
- GoRouter with guarded routes:
  - Unauthenticated -> auth routes only.
  - Authenticated -> app shell routes.
- Quiz route should carry `sessionId` and deny duplicate stack instances.

## Networking
- Use Dio (or http client abstraction) with:
  - Auth interceptor.
  - Retry policy for idempotent requests.
  - Unified error mapping to app-level failures.

## Local Persistence
- Secure storage for tokens.
- Lightweight cache (Hive/SharedPreferences) for:
  - active session summary
  - last selected grade
  - app preferences

## Error Handling
- Global app error boundary.
- Per-screen error state with retry action.
- User-friendly Indonesian messages with technical logging hidden.

## Analytics Hook Points
- `screen_view`
- `session_start`
- `answer_selected`
- `session_submit`
- `session_complete`
- `grade_switch`
