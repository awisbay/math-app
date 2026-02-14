# Phase 4 Question Engine Specification

## 1. Engine Responsibilities
- Build a session with 10 valid questions aligned to user grade.
- Minimize repetition while maintaining balanced difficulty and topics.
- Ensure deterministic and auditable selection decisions.
- Support mixed sources: fixed bank + template variants.

## 2. Inputs
- `user_id`
- `target_grade` (nullable; fallback to `users.current_grade`)
- optional tuning flags (for admin/testing):
  - `difficulty_profile`
  - `topic_bias`

## 3. Outputs
- Session payload:
  - `session_id`
  - `started_at`
  - `expires_at`
  - `duration_seconds`
  - ordered question list (10)
- Selection metadata (internal):
  - source type mix
  - fallback level used
  - excluded count by anti-repeat

## 4. Selection Constraints
- Must return exactly 10 questions.
- All questions must match selected grade.
- Language fixed to `id`.
- Questions must be approved and active.
- No duplicate question references in one session.
- Respect anti-repeat window (default 30 days, configurable).

## 5. Difficulty Policy
Default profile:
- Easy (1-2): 4
- Medium (3): 4
- Hard (4-5): 2

Grade adjustments (recommended):
- Grades 1-3: reduce hard to 1 and increase easy by 1.
- Grades 10-12: allow up to 3 hard questions.

## 6. Topic Spread Policy
- Use at least 3 topics per session when pool allows.
- No single topic should exceed 40% of session (max 4 questions).
- Prefer weaker topics based on `user_topic_mastery` when available.

## 7. Anti-Repeat Policy
Window: 30 days (default).
Rules:
- Exclude exact same question/variant seen in window.
- For template-based items, exclude same `template_id + seed` first.
- If candidate pool < required count:
  - Relax anti-repeat in tiers (30d -> 14d -> 7d).
  - Keep no-duplicate-in-session as absolute rule.

## 8. Source Priority
1. Fixed bank (`questions` table)
2. Pre-generated variants (`question_variants`)
3. On-demand variant generation from templates

Rationale:
- Stable quality first.
- Randomization depth second.
- Real-time generation only when needed.

## 9. Session Lifecycle
- `in_progress` created at start.
- `completed` on user submit.
- `expired` when timer hits zero and auto-submit runs.
- `abandoned` optional if user exits and does not finish.

## 10. Scoring Rules (v1)
- Correct answer: +1 point.
- Incorrect/unanswered: +0.
- Final score:
  - raw score (0-10)
  - percent score (`raw / 10 * 100`)
- Store per-question correctness and response time.

## 11. Consistency and Idempotency
- Session creation request should be idempotent per request token (recommended).
- Answer submit endpoint should handle duplicate client retries safely.
- Final submit should be idempotent and return same result on repeated call.

## 12. Observability
Track metrics:
- `session_generation_latency_ms`
- `session_generation_success_total`
- `session_generation_failure_total`
- `fallback_tier_usage_total`
- `repeat_rate_percent`
- `avg_questions_from_template_percent`
