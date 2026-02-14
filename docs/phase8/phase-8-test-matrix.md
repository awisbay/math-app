# Phase 8 Test Matrix

## A. Analytics Event Integrity
- [ ] Each core user action emits expected event.
- [ ] Required payload fields are present and typed.
- [ ] Event versions are correctly populated.

## B. Logging and Metrics
- [ ] API request logs include correlation IDs.
- [ ] Error logs include actionable context.
- [ ] Endpoint metrics match observed traffic.

## C. Alerting
- [ ] 5xx spike alert triggers as expected.
- [ ] Session failure alert triggers under synthetic fault.
- [ ] Alert recovery clears after issue resolved.

## D. Dashboards
- [ ] DAU/session metrics reconcile with source queries.
- [ ] Retention calculations are stable and reproducible.
- [ ] Content quality panel updates after moderation changes.

## E. Quality Gates
- [ ] Gate checks fail build when blocking conditions exist.
- [ ] Waiver path requires explicit approval and owner.
