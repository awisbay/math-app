# Phase 4 Session Generation Algorithm

## High-Level Flow
1. Resolve grade and session policy.
2. Build candidate pools by topic/difficulty.
3. Apply anti-repeat exclusion.
4. Fill quota by priority and fallback tiers.
5. Persist session atomically.
6. Return ordered question payload.

## Pseudocode
```text
function createSession(userId, requestedGrade):
  grade = resolveGrade(userId, requestedGrade)
  policy = loadPolicy(grade)

  begin transaction
    recentHistory = loadHistory(userId, window=30d)
    candidates = loadCandidates(grade, approved=true, active=true, lang=id)

    filtered = excludeByHistory(candidates, recentHistory)
    selected = []

    for bucket in policy.difficultyBuckets:
      bucketCandidates = filterByDifficultyAndTopic(filtered, bucket)
      picked = pickWithTopicSpread(bucketCandidates, bucket.count, selected)
      selected.append(picked)

    if selected.count < 10:
      selected = fillFromPreGeneratedVariants(selected, grade, policy)

    if selected.count < 10:
      generated = generateOnDemandVariants(grade, needed=10-selected.count)
      selected.append(generated)

    if selected.count < 10:
      selected = relaxAntiRepeatTiers(selected, grade, tiers=[14d, 7d])

    selected = dedupeAndTrimTo10(selected)

    if selected.count < 10:
      throw SessionGenerationInsufficientPoolError

    sessionId = insertSession(userId, grade, duration=900)
    insertSessionQuestions(sessionId, selected)
    insertQuestionHistory(userId, selected)
  commit transaction

  return buildSessionResponse(sessionId)
```

## Deterministic Selection Recommendations
- Seed random by `hash(user_id + date + session_sequence)` for reproducible debugging.
- Sort candidate IDs before randomized pick to avoid unstable DB ordering bias.

## Fallback Tiers
- Tier 0: 30-day anti-repeat strict.
- Tier 1: 14-day anti-repeat.
- Tier 2: 7-day anti-repeat.
- Tier 3: allow older repeats but still no duplicate in same session.

## Failure Handling
- If generation service fails for template variant:
  - retry up to 2 times.
  - downgrade to next candidate source.
- If still not enough pool:
  - return controlled error with code `SESSION_POOL_INSUFFICIENT`.

## Performance Targets (initial)
- P50 generation latency: <= 350ms.
- P95 generation latency: <= 1200ms.
- Error rate: <= 1% under expected staging load.
