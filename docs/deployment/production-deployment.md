# Production Deployment Guide

## 1) Purpose
This guide describes production deployment for:
- Backend API on Google Cloud Run
- PostgreSQL on Cloud SQL
- Redis on Memorystore (optional but recommended)
- Mobile app release via Play Console and TestFlight
- Monitoring, security, and rollback controls

---

## 2) Reference Architecture

## Core services
- API: Cloud Run
- DB: Cloud SQL (PostgreSQL)
- Cache/Queue: Memorystore (Redis)
- Object assets: Cloud Storage
- Auth: Firebase Auth
- Notifications: Firebase Cloud Messaging
- Observability: Cloud Logging + Monitoring + Crashlytics + Analytics

## Environment strategy
- `staging`
- `production`

Never share database or secrets between environments.

---

## 3) Production Prerequisites

## Accounts and access
- Google Cloud project(s)
- Firebase project linked to GCP
- Apple Developer account
- Google Play Console account

## IAM roles (minimum)
- Cloud Run Admin / Developer
- Cloud SQL Admin
- Secret Manager Admin/Accessor
- Service Account User
- Firebase Admin (as needed)

## Required CLIs
- `gcloud`
- `firebase`
- `docker`

---

## 4) Infrastructure Provisioning

## 4.1 Create Cloud SQL instance (PostgreSQL)
- Enable automated backups
- Enable high availability (recommended for production)
- Restrict network access

## 4.2 Create Redis (Memorystore)
- Size based on expected queue/cache usage
- Private VPC access

## 4.3 Create Cloud Storage buckets
- `math-app-assets-prod`
- `math-app-exports-prod` (optional)

## 4.4 Create Secret Manager entries
Store all sensitive values:
- DB credentials / connection string
- JWT secrets
- Firebase credentials
- OpenAI key (if used)
- Any third-party API tokens

---

## 5) Backend Deployment (Cloud Run)

## 5.1 Build and push container
From `services/api`:
```bash
gcloud builds submit --tag gcr.io/<PROJECT_ID>/math-api:$(git rev-parse --short HEAD)
```

## 5.2 Deploy Cloud Run service
```bash
gcloud run deploy math-api \
  --image gcr.io/<PROJECT_ID>/math-api:$(git rev-parse --short HEAD) \
  --region <REGION> \
  --platform managed \
  --allow-unauthenticated
```

Then configure:
- Cloud SQL connection
- VPC connector (if needed)
- Environment variables (non-secret)
- Secret Manager mounts/env (secret values)
- Min instances and autoscaling

## 5.3 Database migration in production
Run migrations as controlled job (not on app boot):
```bash
npm run prisma:migrate:deploy
```

Recommended: run migration from CI/CD step with approval gate.

---

## 6) Mobile Production Deployment

## 6.1 Android (Play Console)
- Configure app signing
- Build release artifact
```bash
flutter build appbundle --release
```
- Upload to internal/closed track first
- Validate crash/analytics before broader rollout

## 6.2 iOS (TestFlight/App Store)
- Configure bundle id + signing/profiles
- Build release artifact
```bash
flutter build ipa --release
```
- Upload via Xcode/Transporter
- Release to internal/external testers first

---

## 7) CI/CD Pipeline (Recommended)

## Pipeline stages
1. Lint + test
2. Build artifacts (API + mobile)
3. Security scans
4. Deploy to staging
5. Smoke tests
6. Manual approval
7. Deploy to production
8. Post-deploy health checks

## Suggested tools
- GitHub Actions (or GitLab CI)
- Cloud Build integration

---

## 8) Production Config and Security

## Security controls
- HTTPS only
- Least-privilege IAM
- Secret Manager for secrets
- Log redaction for tokens/PII
- Rate limiting on auth/session endpoints

## Runtime controls
- Set CPU/memory limits for Cloud Run
- Configure request timeout
- Configure min instances for cold-start reduction
- Configure autoscaling caps to protect budget

---

## 9) Observability and Alerts

## Must-have dashboards
- API latency/error rate
- Session generation success/failure
- Crash-free rate (Android/iOS)
- Queue retry/dead-letter metrics

## Must-have alerts
- 5xx spike
- Session generation failure spike
- Crash-free drop
- DB connectivity failures

---

## 10) Release Strategy

## Safe rollout
- Deploy to staging first
- Deploy production with small exposure first (if possible)
- Monitor 30-60 minutes
- Continue rollout when stable

## Rollback triggers
- Critical auth/session failure
- Crash spike
- Data integrity risk

## Rollback actions
1. Route traffic to last stable revision
2. Halt new rollout
3. Communicate incident status
4. Start root-cause analysis

---

## 11) Production Verification Checklist (Post-Deploy)
- Health endpoint OK
- Login/register works
- Session create/answer/submit works
- Streak update works
- Metrics and logs visible
- No critical alerts firing

---

## 12) Disaster Recovery Basics
- Daily DB backups + retention policy
- Periodic restore drills
- Incident response owner and escalation matrix
- Documented RTO/RPO targets

---

## 13) Definition of Done (Production Ready)
- Staging and production deployments reproducible.
- Security and quality gates enforced.
- Monitoring and rollback verified.
- Mobile release tracks configured and operational.
