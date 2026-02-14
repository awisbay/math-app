# Quick Start (Docker + Env)

## 1) Copy env files
```bash
cp services/api/.env.local.example services/api/.env.local
cp apps/mobile_flutter/.env.dev.example apps/mobile_flutter/.env.dev
```

## 2) Start infrastructure only
```bash
docker compose up -d postgres redis
```

## 3) Run API on host
```bash
cd services/api
npm install
npm run db:generate
npm run db:migrate
npm run db:seed
npm run start:dev
```

## 4) Run Flutter app
```bash
cd apps/mobile_flutter
flutter pub get
flutter run
```

## Optional: run API via Docker compose
```bash
docker compose --profile app up -d
```

## Stop services
```bash
docker compose down
```
