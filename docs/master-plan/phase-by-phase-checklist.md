# Detailed Implementation Plan (Phase by Phase + Checklist)

## Phase 0: Project Setup (Week 1)
Goal: lock scope, architecture, tooling.

Checklist:
- [ ] Confirm MVP scope: auth, grade switch, 15-min/10-question session, streak, progress.
- [ ] Finalize monorepo structure: `apps/mobile_flutter`, `services/api`, `packages/shared_models`, `docs`.
- [ ] Create product requirement doc and user stories.
- [ ] Choose state management (`Riverpod` or `Bloc`) and navigation (`GoRouter`).
- [ ] Setup coding standards, linting, formatting, branch strategy, PR template.
- [ ] Setup CI skeleton (build + lint on PR).
- [ ] Create Figma style guide from your reference UI.

Exit criteria:
- [ ] Team agrees on scope and technical baseline.
- [ ] Repo and CI are ready for feature development.

## Phase 1: UX/UI System (Week 1-2)
Goal: modern, consistent UI ready for implementation.

Checklist:
- [ ] Define color tokens and typography scale.
- [ ] Build reusable components: cards, grade chips, answer buttons, timer, progress bars.
- [ ] Design full flows: onboarding, home, quiz, results, progress, profile.
- [ ] Define responsive behavior for small and large phones.
- [ ] Add interaction states: loading, empty, error, success.
- [ ] Create design QA checklist and spacing rules.

Exit criteria:
- [ ] Clickable prototype approved.
- [ ] Component list mapped to Flutter widgets.

## Phase 2: Backend Foundation + Auth (Week 2-3)
Goal: secure user identity and profile.

Checklist:
- [ ] Setup backend project (Firebase + Cloud Functions/Run or Node service).
- [ ] Implement auth: register, login, token validation, logout.
- [ ] Implement profile API: age, birthdate, current grade.
- [ ] Implement age-to-grade default mapping logic.
- [ ] Add grade switch endpoint and validation (1-12 only).
- [ ] Add logging and request tracing.

Exit criteria:
- [ ] Mobile app can create account, login, and update profile.

## Phase 3: Data Layer + Content Schema (Week 3)
Goal: stable schema for users, questions, sessions, streak.

Checklist:
- [ ] Create DB tables/collections from the drafted schema.
- [ ] Add indexes for session retrieval and anti-repeat.
- [ ] Implement topic taxonomy per grade (1-12).
- [ ] Build admin seed scripts for grade/topic metadata.
- [ ] Add audit fields (`created_at`, `updated_at`, source type, quality status).
- [ ] Write migration/versioning strategy.

Exit criteria:
- [ ] Schema validated and seed data loaded successfully.

## Phase 4: Question Engine v1 (Week 4-5)
Goal: generate 10-question sessions with low repetition.

Checklist:
- [ ] Build session generator with difficulty distribution.
- [ ] Implement anti-repeat filter with 30-day history window.
- [ ] Implement template-based question variation (seed-driven).
- [ ] Build fallback rules when question pool is limited.
- [ ] Add answer validation and scoring logic.
- [ ] Add explanation and metadata payloads for result screen.

Exit criteria:
- [ ] API returns valid 10-question sessions in <1s for warm cache.
- [ ] Repeat rate is controlled per configured threshold.

## Phase 5: Flutter Core App (Week 4-6)
Goal: complete first playable app loop.

Checklist:
- [ ] Build onboarding and auth screens.
- [ ] Build home screen with greeting, grade chips, categories, streak card.
- [ ] Build quiz screen with timer, paging, answer states, submit flow.
- [ ] Build result screen with score and topic-level feedback.
- [ ] Build progress screen with recent sessions and mastery bars.
- [ ] Build profile screen with age/grade management.
- [ ] Implement API client layer and error handling.

Exit criteria:
- [ ] User can finish full session end-to-end from login to result.

## Phase 6: Streak + Retention System (Week 6)
Goal: daily habit mechanics.

Checklist:
- [ ] Implement daily activity ledger and streak increment logic.
- [ ] Implement streak reset policy and optional grace/freeze rule.
- [ ] Add daily reminder notifications.
- [ ] Add streak milestone badges (3, 7, 14, 30 days).
- [ ] Add anti-abuse checks for streak farming.

Exit criteria:
- [ ] Streak updates correctly across timezone/date boundaries.

## Phase 7: Content Pipeline (Week 6-7)
Goal: produce high-quality Indonesian math content.

Checklist:
- [ ] Finalize first 200-question blueprint (G1-G3).
- [ ] Build content authoring template format (CSV/JSON).
- [ ] Build validation checks: one correct answer, language quality, difficulty tag.
- [ ] Add review workflow: draft, review, approved, rejected.
- [ ] Seed curated bank and template bank.
- [ ] Add AI generation pipeline behind moderation gate.

Exit criteria:
- [ ] 200 approved questions live in database.

## Phase 8: Analytics + Quality (Week 7-8)
Goal: measurement and reliability.

Checklist:
- [ ] Track events: session_start, answer_submit, session_complete, streak_update.
- [ ] Add crash reporting and error monitoring.
- [ ] Add API metrics: latency, error rate, session generation success.
- [ ] Add dashboards for DAU, completion rate, repeat rate, streak retention.
- [ ] Add feature flags for experiment rollout.

Exit criteria:
- [ ] Core product metrics visible in one dashboard.

## Phase 9: QA, Security, Performance (Week 8-9)
Goal: production-readiness baseline.

Checklist:
- [ ] Unit tests for scoring, anti-repeat, streak logic.
- [ ] Integration tests for session lifecycle API.
- [ ] Flutter widget/integration tests for core flows.
- [ ] Security review: auth, token expiry, API authorization.
- [ ] Load tests for session generation endpoint.
- [ ] Accessibility pass: readable text, contrast, touch targets.

Exit criteria:
- [ ] Test pass rate target achieved.
- [ ] No P0/P1 bugs open.

## Phase 10: Beta Launch (Week 10)
Goal: controlled release and feedback loop.

Checklist:
- [ ] Prepare TestFlight and Play Internal builds.
- [ ] Add in-app feedback channel.
- [ ] Run beta with target users (parents/students).
- [ ] Monitor metrics and prioritize fixes.
- [ ] Prepare v1.1 backlog from real usage data.

Exit criteria:
- [ ] Beta stable for at least 7 days.
- [ ] Prioritized post-beta roadmap approved.

## Master Checklist (Go/No-Go for MVP)
- [ ] End-to-end session works on Android and iOS.
- [ ] 15-minute timer and 10-question cap enforced server-side.
- [ ] Indonesian-only content for target grades in MVP scope.
- [ ] Anti-repeat logic active with measurable low duplication.
- [ ] Daily streak accurate by local date.
- [ ] Analytics and crash monitoring live.
- [ ] Security baseline passed.
- [ ] 200 vetted questions available at launch.
- [ ] App store beta builds distributed successfully.
