# Phase 7 Backlog (Content Pipeline)

## Priority Legend
- P0: required for Phase 7 completion.
- P1: stabilization and quality improvement.
- P2: advanced optimization.

## Epic A: Authoring and Ingestion

### P0
- [ ] Define canonical content schema and templates.
- [ ] Build import parser for CSV/JSON.
- [ ] Build import validation report generator.

### P1
- [ ] Build bulk edit support for metadata updates.

## Epic B: Validation Engine

### P0
- [ ] Implement schema and semantic validators.
- [ ] Implement answer integrity checker.
- [ ] Implement language quality heuristics.
- [ ] Implement duplicate similarity detector.

### P1
- [ ] Add numerical expression solver for auto-checking math correctness.

## Epic C: Moderation Workflow

### P0
- [ ] Implement moderation states and transitions.
- [ ] Implement reviewer action endpoints/UI hooks.
- [ ] Store rejection reasons and notes.

### P1
- [ ] SLA dashboard for moderation throughput.

## Epic D: AI Pipeline

### P0
- [ ] Implement AI generation request service.
- [ ] Implement auto-validation gate for generated items.
- [ ] Implement review queue ingestion.

### P1
- [ ] Add prompt template library by grade/topic.
- [ ] Add multi-model fallback strategy.

## Epic E: Publishing and Versioning

### P0
- [ ] Implement publish-set creation.
- [ ] Implement atomic publish.
- [ ] Implement rollback to previous publish set.

### P1
- [ ] Add canary publish for limited user segment.

## Epic F: Testing and Monitoring

### P0
- [ ] Unit tests for validators and transition rules.
- [ ] Integration tests for end-to-end content lifecycle.
- [ ] Monitoring dashboard for content quality metrics.

### P1
- [ ] Add drift detection for recurring rejection categories.
