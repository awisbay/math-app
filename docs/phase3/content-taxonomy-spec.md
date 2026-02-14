# Phase 3 Content Taxonomy Specification

## Goal
Define normalized topic taxonomy for Indonesian math curriculum from grade 1 to 12.

## Taxonomy Rules
- Topic code format: `G{grade}_{DOMAIN}_{NN}`
  - Example: `G3_NUM_01`, `G8_ALG_02`
- `DOMAIN` examples:
  - `NUM` Number sense
  - `ALG` Algebra
  - `GEO` Geometry
  - `MEA` Measurement
  - `DAT` Data/Statistics
  - `PRO` Probability (upper grades)
- Topic names use Indonesian labels.
- Every question must map exactly to one primary topic.

## Grade Grouping
- SD: grades 1-6
- SMP: grades 7-9
- SMA: grades 10-12

## Metadata Required per Topic
- `grade`
- `code`
- `name_id`
- `sort_order`
- `difficulty_baseline` (1-5)
- `is_active`

## Question Metadata Required
- `grade`
- `topic_id`
- `difficulty`
- `source_type` (`curated`, `template`, `ai_generated`)
- `language_code` (`id`)
- `quality_status` (`draft`, `review`, `approved`, `rejected`)

## Seed Requirements (Phase 3)
- Create topic master for all grades 1-12.
- Create minimum placeholder question metadata rows for integration tests.
- Ensure each grade has at least 5 active topics to support early selection testing.

## Governance
- Content editor reviews naming consistency.
- Tech review ensures all topic codes are unique per grade.
- Changes to taxonomy must go through migration script and changelog update.
