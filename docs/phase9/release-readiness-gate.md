# Phase 9 Release Readiness Gate

## Blockers (Release Must Stop)
- Any open P0 defect.
- Unresolved critical security issue.
- Core e2e flow failure.
- Crash-free rate below defined threshold.
- Session generation failure spike above threshold.

## Must-Pass Criteria
- Backend and mobile test suites pass.
- Manual QA sign-off on target devices.
- Security checklist completed with approvals.
- Performance benchmarks executed and reviewed.
- Rollback and incident response plan confirmed.

## Waiver Rules
- Waiver allowed only for non-critical items.
- Must include owner, risk statement, and deadline.
- Requires explicit approval from engineering/product leads.
