# Deployment Checklists (Quick Reference)

## Local Bring-Up
- [ ] Start Postgres + Redis
- [ ] Configure API `.env.local`
- [ ] Run migrations and seed
- [ ] Start API
- [ ] Configure Flutter `.env.dev`
- [ ] Run app on simulator/emulator
- [ ] Complete smoke test flow

## Staging Deploy
- [ ] Build and deploy API image
- [ ] Apply DB migrations
- [ ] Update mobile staging config
- [ ] Run staging smoke tests
- [ ] Validate dashboards and alerts

## Production Deploy
- [ ] Approval gate completed
- [ ] Deploy API revision
- [ ] Run post-deploy verification
- [ ] Monitor errors/latency/crash signals
- [ ] Roll back immediately if trigger hit

## Mobile Release
- [ ] Android AAB uploaded to testing track
- [ ] iOS build uploaded to TestFlight
- [ ] Release notes prepared
- [ ] Tester cohort notified
