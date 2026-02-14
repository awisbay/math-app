# Phase 7 Checklist (Content Pipeline)

## Goal
Build end-to-end content pipeline for high-quality Indonesian math questions across grades, including authoring, validation, review, publishing, and version control.

## Scope
- Content authoring standard.
- Validation and quality gates.
- Human moderation workflow.
- AI-assisted generation workflow.
- Content publishing and rollback.

## Functional Checklist
- [ ] Define canonical question schema for authoring.
- [ ] Define content source policy (`curated`, `template`, `ai_generated`).
- [ ] Create authoring templates (CSV/JSON).
- [ ] Implement import pipeline for curated questions.
- [ ] Implement template registry pipeline.
- [ ] Implement AI generation request pipeline with constraints.
- [ ] Implement automated validation checks.
- [ ] Implement moderation states and transitions.
- [ ] Implement publish flow to production-eligible set.
- [ ] Implement versioning/changelog for content updates.

## Quality Checklist
- [ ] Language quality check for Indonesian clarity.
- [ ] One-correct-answer enforcement.
- [ ] Distractor plausibility checks.
- [ ] Difficulty alignment checks by grade.
- [ ] Unit and numerical correctness checks.
- [ ] Image/media link validity checks.

## Reliability Checklist
- [ ] Import pipeline idempotent behavior.
- [ ] Failed records produce actionable error reports.
- [ ] Reprocessing of rejected content supported.
- [ ] Publish process supports rollback by content version.

## Governance Checklist
- [ ] Editor and reviewer roles defined.
- [ ] Approval SLA and handoff rules documented.
- [ ] Audit trail captured for status changes.

## Exit Criteria
- [ ] Pipeline can process, validate, review, and publish first 200 questions.
- [ ] Quality gate pass rate is measurable and reported.
- [ ] No question can be served unless approved + published.
