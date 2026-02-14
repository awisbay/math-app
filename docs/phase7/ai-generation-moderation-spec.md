# Phase 7 AI Generation and Moderation Spec

## Objective
Use AI to scale content generation while preserving pedagogic and factual quality through strict validation and human review.

## Generation Input Contract
Required:
- `grade`
- `topic_code`
- `difficulty`
- `count`
- `language=indonesian`
- `format=multiple_choice`

Optional:
- `context_style` (school-life, daily-life, abstract)
- `avoid_concepts[]`

## Generation Output Contract
Each item must include:
- `stem`
- `choices` (4 options)
- `answer_key`
- `explanation`
- `difficulty`
- `topic_code`
- `source_type=ai_generated`

## Auto-Validation Pipeline
1. Schema validation.
2. Answer consistency validation.
3. Duplicate similarity check against existing bank.
4. Language and ambiguity heuristic checks.
5. Difficulty heuristic checks.

If any check fails:
- mark as `rejected_auto` with reason code.

## Human Moderation Workflow
- Queue accepted candidates to reviewer inbox.
- Reviewer actions:
  - approve
  - edit-and-approve
  - reject (with reason)
- Rejection reasons taxonomy:
  - wrong_answer
  - ambiguous
  - off_curriculum
  - language_issue
  - poor_distractors

## Safety and Policy Controls
- Block harmful/irrelevant content.
- Restrict prompts to curriculum-safe context.
- Log prompt and generation metadata for audit.

## KPI Targets
- Auto-validation pass rate target.
- Reviewer acceptance rate target.
- Post-publish issue rate target (< agreed threshold).
