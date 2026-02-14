# Math App 🎯

A Flutter-based mobile learning app for Indonesian math practice from Kelas 1 SD to Kelas 12 SMA, featuring daily streaks and adaptive quizzes.

## Features ✨

- 📚 **Grades 1-12**: SD, SMP, SMA curriculum coverage
- ⏱️ **Daily Practice**: 15-minute sessions with 10 questions
- 🔥 **Streak System**: Track daily learning streaks with milestones
- 🎯 **Adaptive Difficulty**: Questions matched to grade level
- 🔄 **Anti-Repeat**: Smart question selection avoids repetition
- 📊 **Progress Tracking**: Monitor improvement over time
- 🌐 **Indonesian Language**: Native language support

## Tech Stack 🛠️

### Frontend (Mobile)
- **Flutter 3.19+** - Cross-platform UI framework
- **Riverpod** - State management
- **GoRouter** - Navigation
- **Dio** - HTTP client
- **Firebase Auth** - Authentication
- **Firebase Analytics** - Usage tracking

### Backend (API)
- **NestJS** - Node.js framework
- **TypeScript** - Type-safe development
- **PostgreSQL** - Relational database
- **Prisma** - Database ORM
- **Firebase Admin** - Token verification

## Project Structure 📁

```
math-app/
├── apps/
│   └── mobile_flutter/     # Flutter mobile app
│       ├── lib/
│       │   ├── core/       # Theme, widgets, utils
│       │   ├── data/       # API client, models
│       │   ├── features/   # Screens (auth, home, quiz)
│       │   └── providers/  # Riverpod state management
│       └── pubspec.yaml
├── services/
│   └── api/                # NestJS backend
│       ├── src/
│       │   ├── auth/       # Authentication
│       │   ├── quiz/       # Session & question engine
│       │   ├── profile/    # User profile
│       │   ├── progress/   # Streak & analytics
│       │   └── prisma/     # Database schema
│       └── package.json
├── packages/
│   └── shared_models/      # Shared TypeScript types
└── docs/                   # Documentation
```

## Quick Start 🚀

### Prerequisites
- Node.js 18+
- Flutter 3.19+
- PostgreSQL 14+
- Firebase project

### Backend Setup

```bash
cd services/api

# Install dependencies
npm install

# Setup environment
cp .env.example .env
# Edit .env with your database and Firebase credentials

# Run migrations
npx prisma migrate dev

# Seed database
npx prisma db seed

# Start development server
npm run start:dev
```

### Mobile App Setup

```bash
cd apps/mobile_flutter

# Install dependencies
flutter pub get

# Setup environment
cp .env.example .env

# Run app
flutter run
```

## Development 🛠️

### Running Tests

**Backend:**
```bash
cd services/api
npm run test          # Unit tests
npm run test:e2e      # Integration tests
```

**Flutter:**
```bash
cd apps/mobile_flutter
flutter test          # Unit tests
flutter test integration_test  # Integration tests
```

### Database Commands

```bash
cd services/api

# Generate Prisma client
npx prisma generate

# Create migration
npx prisma migrate dev --name <migration_name>

# Open Prisma Studio
npx prisma studio

# Reset database
npx prisma migrate reset
```

## Phases Completed ✅

| Phase | Description | Status |
|-------|-------------|--------|
| 0 | Project Structure & Planning | ✅ Complete |
| 1 | UI/UX System (Flutter) | ✅ Complete |
| 2 | Backend Foundation + Auth | ✅ Complete |
| 3 | Data Layer + Content Schema | ✅ Complete |
| 4 | Question Engine v1 | ✅ Complete |
| 5 | Flutter API Integration | ✅ Complete |
| 6 | Streak + Retention System | ✅ Complete |
| 7 | Content Pipeline | ✅ Complete |
| 8 | Analytics + Observability | ✅ Complete |
| 9 | Performance + Load Testing | ✅ Complete |
| 10 | Beta Launch | ✅ Ready |

## API Documentation 📚

### Authentication
- `POST /auth/register` - Register new user
- `POST /auth/login` - Login existing user
- `POST /auth/verify-token` - Verify Firebase token

### Profile
- `GET /profile` - Get user profile
- `PATCH /profile` - Update profile
- `POST /profile/switch-grade` - Switch grade (1-12)

### Quiz
- `POST /quiz/sessions` - Create new session
- `GET /quiz/sessions/:id` - Get session details
- `POST /quiz/sessions/:id/answers` - Submit answer
- `POST /quiz/sessions/:id/submit` - Complete session

### Progress
- `GET /progress` - Get progress overview
- `GET /progress/history` - Get session history

## Environment Variables 🔐

### Backend (.env)
```env
NODE_ENV=development
PORT=3000
DATABASE_URL=postgresql://user:password@localhost:5432/mathapp
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY=your-private-key
FIREBASE_CLIENT_EMAIL=your-client-email
```

### Mobile (.env)
```env
API_BASE_URL=http://localhost:3000/api/v1
FIREBASE_API_KEY=your-firebase-api-key
```

## Contributing 🤝

1. Create feature branch: `git checkout -b feature/MA-123-feature-name`
2. Make changes and commit: `git commit -m "feat: description"`
3. Push branch: `git push origin feature/MA-123-feature-name`
4. Create Pull Request

### Commit Convention
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `refactor:` Code refactoring
- `test:` Tests

## License 📄

UNLICENSED - Proprietary software

## Support 💬

For questions or issues, please contact the development team.

---

Made with ❤️ for Indonesian students
