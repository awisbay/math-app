# Phase 7 Content Pipeline Specification

## 1. Pipeline Stages
1. Authoring
2. Ingestion
3. Validation
4. Moderation
5. Publishing
6. Monitoring and feedback loop

## 2. Content Types
- Curated fixed questions.
- Template definitions for generated variants.
- AI-generated candidate questions.

## 3. Canonical Content Fields
Required fields:
- `grade`
- `topic_code` / `topic_id`
- `difficulty` (1-5)
- `language_code` (`id`)
- `stem`
- `choices[]`
- `answer_key`
- `explanation`
- `source_type`
- `quality_status`
- `version`

Optional fields:
- `image_url`
- `tags[]`
- `author_note`
- `review_note`

## 4. Validation Layers
- Schema validation: required fields and format correctness.
- Semantic validation:
  - answer key exists in choices
  - no duplicate choices
  - numeric/unit consistency
- Pedagogic validation:
  - grade appropriateness
  - difficulty appropriateness
- Language validation:
  - Indonesian grammar/readability baseline
  - avoid ambiguity and culturally confusing phrasing

## 5. Moderation Workflow
States:
- `draft` -> `review` -> `approved` -> `published`
- rejection path: `review` -> `rejected` -> `draft`

Rules:
- Only reviewers can set `approved`.
- Only approved records can be published.
- Published records are immutable; edits create new version.

## 6. Publishing Model
- Use publish set/version ID.
- Publish atomically by batch.
- Keep previous publish set available for rollback.

## 7. AI Generation Guardrails
- Prompt must include grade/topic/difficulty constraints.
- Enforce Indonesian output only.
- Auto-validate generated output before moderation.
- Reject generation if answer consistency checks fail.
- Human review required before publish.

## 8. Content Metrics
Track:
- import success/failure
- validation pass rate
- moderation turnaround time
- rejection reasons
- post-publish correction rate
