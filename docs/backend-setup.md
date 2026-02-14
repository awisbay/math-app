# Backend Setup Guide

## Prerequisites

- Node.js 18+
- PostgreSQL 14+
- Firebase Project (for authentication)

## Quick Start

### 1. Install Dependencies

```bash
cd services/api
npm install
```

### 2. Environment Setup

```bash
cp .env.example .env
```

Edit `.env` with your configuration:

```env
# Database
DATABASE_URL=postgresql://user:password@localhost:5432/mathapp

# Firebase (from Firebase Console > Project Settings > Service Accounts)
FIREBASE_PROJECT_ID=your-project-id
FIREBASE_PRIVATE_KEY="-----BEGIN PRIVATE KEY-----\n...\n-----END PRIVATE KEY-----"
FIREBASE_CLIENT_EMAIL=firebase-adminsdk-xxxxx@your-project.iam.gserviceaccount.com
```

### 3. Database Setup

Using Docker:
```bash
make db-up
```

Or use local PostgreSQL and update `DATABASE_URL`.

### 4. Run Migrations

```bash
make migrate
# or
npx prisma migrate dev
```

### 5. Start Development Server

```bash
make dev
# or
npm run start:dev
```

The API will be available at `http://localhost:3000/api/v1`

## Available Commands

| Command | Description |
|---------|-------------|
| `make install` | Install dependencies |
| `make dev` | Start development server |
| `make build` | Build for production |
| `make test` | Run all tests |
| `make test:watch` | Run tests in watch mode |
| `make migrate` | Run database migrations |
| `make db-up` | Start database with Docker |
| `make prisma-studio` | Open Prisma Studio |
| `make lint` | Run ESLint |
| `make format` | Format code with Prettier |

## API Endpoints

### Health
- `GET /api/v1/health` - Health check
- `GET /api/v1/health/ready` - Readiness check

### Auth
- `POST /api/v1/auth/register` - Register new user
- `POST /api/v1/auth/login` - Login user
- `POST /api/v1/auth/verify-token` - Verify Firebase token
- `POST /api/v1/auth/logout` - Logout user

### Profile (Protected)
- `GET /api/v1/profile` - Get current user profile
- `PATCH /api/v1/profile` - Update profile
- `POST /api/v1/profile/switch-grade` - Switch grade
- `GET /api/v1/profile/default-grade` - Get default grade from birth date

## Firebase Setup

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project (or use existing)
3. Go to Project Settings > Service Accounts
4. Click "Generate new private key"
5. Save the JSON file securely
6. Extract values for your `.env`:
   - `project_id` → `FIREBASE_PROJECT_ID`
   - `private_key` → `FIREBASE_PRIVATE_KEY`
   - `client_email` → `FIREBASE_CLIENT_EMAIL`

## Testing

### Unit Tests
```bash
npm run test
```

### Integration Tests
```bash
npm run test:e2e
```

### Coverage
```bash
npm run test:cov
```

## Deployment

### Docker
```bash
make docker-build
```

### Cloud Run
1. Build and push image to GCR
2. Deploy with environment variables
3. Configure database connection

## Architecture

```
services/api/
├── src/
│   ├── auth/          # Authentication module
│   ├── profile/       # User profile module
│   ├── quiz/          # Quiz module (Phase 4)
│   ├── progress/      # Progress module
│   ├── health/        # Health checks
│   ├── shared/        # Shared utilities
│   ├── common/        # Common services
│   ├── config/        # Configuration
│   └── main.ts        # Entry point
├── prisma/
│   └── schema.prisma  # Database schema
├── test/              # Test files
├── Dockerfile         # Container definition
└── docker-compose.yml # Local development stack
```
