# Phase 5 Mobile API Integration Specification

## Environment Configuration
- `dev`, `staging`, `prod` base URLs.
- Feature flags loaded from backend config endpoint.
- API timeout defaults:
  - connect: 10s
  - receive: 20s

## Auth Integration
- Login/register returns or exchanges token.
- Store token securely.
- Attach bearer token for protected requests.
- On 401:
  - clear invalid auth state
  - redirect to login

## Profile Integration
- Fetch profile at app start after authentication.
- Update profile endpoint supports partial updates.
- Grade switch endpoint updates local state immediately on success.

## Session Integration
- `POST /sessions` when user taps Start Session.
- Render ordered question payload from API response.
- `POST /sessions/{id}/answers` on answer action (debounced/idempotent).
- `POST /sessions/{id}/submit` on final action or timer expiration.
- Poll/reload `GET /sessions/{id}` when recovering app state.

## Progress Integration
- Fetch summary and history on Progress tab open.
- Cache last successful progress payload for offline fallback view.

## Error Mapping
Map backend error codes to user messages:
- `VALIDATION_ERROR` -> "Data tidak valid."
- `UNAUTHORIZED` -> "Sesi login habis. Silakan masuk lagi."
- `SESSION_POOL_INSUFFICIENT` -> "Soal belum tersedia cukup. Coba lagi sebentar."
- generic -> "Terjadi kesalahan. Coba lagi."

## Retry and Idempotency
- Retry only safe requests automatically.
- For answer and submit operations, include idempotency key where supported.
- Disable repeated submit tap while request in-flight.
