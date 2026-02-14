# Math App

A Flutter-based mobile learning app for Indonesian math practice from Kelas 1 SD to Kelas 12 SMA.

## Overview

Math App helps Indonesian students practice math through short daily sessions with streak motivation.

### Key Features
- 📚 Grade levels 1-12 (SD-SMA)
- ⏱️ 15-minute daily sessions
- 📝 10 questions per session
- 🔥 Streak tracking for daily practice
- 📊 Progress monitoring
- 🌐 Indonesian language

## Project Structure

This is a monorepo containing:

```
math-app/
├── apps/
│   └── mobile_flutter/     # Flutter mobile app
├── services/
│   └── api/                # NestJS backend API
├── packages/
│   └── shared_models/      # Shared TypeScript models
├── docs/
│   ├── api_contracts/      # API documentation
│   └── phase0/             # Phase 0 planning docs
└── .github/
    └── workflows/          # CI/CD pipelines
```

## Tech Stack

### Frontend (Mobile)
- **Framework**: Flutter 3.19+
- **State Management**: Riverpod
- **Navigation**: GoRouter
- **HTTP**: Dio
- **Auth**: Firebase Auth

### Backend (API)
- **Runtime**: Node.js 18+
- **Framework**: NestJS + TypeScript
- **Database**: PostgreSQL
- **ORM**: Prisma
- **Auth**: Firebase Auth

## Getting Started

### Prerequisites
- Node.js 18+
- Flutter 3.19+
- PostgreSQL 14+
- Firebase project

### Installation

1. Clone the repository:
```bash
git clone <repo-url>
cd math-app
```

2. Install root dependencies:
```bash
npm install
```

3. Setup environment:
```bash
cp .env.example .env
# Edit .env with your configuration
```

4. Setup API:
```bash
cd services/api
npm install
npx prisma generate
npx prisma migrate dev
npm run start:dev
```

5. Setup Flutter app:
```bash
cd apps/mobile_flutter
flutter pub get
flutter run
```

## Development

### Running Tests

**API:**
```bash
cd services/api
npm run test
```

**Flutter:**
```bash
cd apps/mobile_flutter
flutter test
```

### Code Quality

```bash
# Lint all code
npm run lint

# Format all code
npm run format

# Type check
npm run typecheck:api

# Flutter analyze
cd apps/mobile_flutter && flutter analyze
```

## Documentation

- [MVP Scope](docs/phase0/mvp-scope.md)
- [Architecture Decisions](docs/phase0/architecture-decisions.md)
- [API Contracts](docs/api_contracts/)
- [Phase 0 Checklist](docs/phase0/phase-0-checklist.md)
- [Initial Backlog](docs/phase0/initial-backlog.md)

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines and branch strategy.

## License

UNLICENSED - Proprietary software
