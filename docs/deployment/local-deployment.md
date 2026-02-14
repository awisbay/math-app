# Local Deployment Guide (Beginner Friendly)

## 1) Purpose
This guide is for first-time Flutter users to run the app locally, including:
- Backend API (NestJS)
- PostgreSQL + Redis
- Flutter app preview on Android emulator / iOS simulator
- Optional Flutter Web preview

---

## 2) Can I preview in localhost like web?
Short answer:
- **Mobile app preview (recommended):** use **Android Emulator** or **iOS Simulator**.
- **Browser preview:** possible only if Flutter web is enabled and your app supports web path.

Important:
- If you want real mobile behavior (navigation, keyboard, push-notification flow), use emulator/simulator.
- Browser preview is useful for quick UI checks, but not full mobile parity.

---

## 3) Prerequisites

## System
- macOS recommended (best support for Android + iOS)
- Linux works for Android (no iOS simulator)

## Required tools
- Flutter stable SDK
- Node.js LTS (>=20)
- npm
- Docker Desktop
- Git

## For Android preview
- Android Studio
- Android SDK + Emulator image

## For iOS preview (macOS only)
- Xcode
- Xcode Command Line Tools

---

## 4) Install Flutter (first time)

## macOS (example with Homebrew)
```bash
brew install --cask flutter
```

Then verify:
```bash
flutter --version
```

Run diagnostics:
```bash
flutter doctor
```

Fix all items marked with `✗` before continuing.

---

## 5) Install Android toolchain

1. Install Android Studio.
2. Open Android Studio and install:
- Android SDK
- Android SDK Platform-Tools
- Android Emulator
3. Create one virtual device (AVD), for example Pixel + recent Android version.

Check available emulators:
```bash
flutter emulators
```

Start one emulator:
```bash
flutter emulators --launch <EMULATOR_ID>
```

---

## 6) Install iOS toolchain (macOS only)

1. Install Xcode from App Store.
2. Run once and accept license.
3. Set command-line tools:
```bash
sudo xcode-select -s /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```
4. Open iOS Simulator from Xcode (`Xcode > Open Developer Tool > Simulator`).

Check devices:
```bash
flutter devices
```

---

## 7) VS Code setup (recommended)
Install extensions:
- `Dart` (by Dart Code)
- `Flutter` (by Dart Code)
- `Error Lens` (optional)
- `Thunder Client` or `REST Client` (optional for API testing)

Useful VS Code actions:
- `Run > Start Debugging` for Flutter app
- Device selector in status bar to pick emulator/simulator
- Hot reload with `r`

---

## 8) Project structure (assumed)
- `apps/mobile_flutter`
- `services/api`
- `packages/shared_models`
- `docs`

---

## 9) Environment files

Create local env files from examples:
```bash
cp services/api/.env.local.example services/api/.env.local
cp apps/mobile_flutter/.env.dev.example apps/mobile_flutter/.env.dev
```

## 9.1 API local env notes
In `services/api/.env.local`:
- If API runs on host machine:
  - `DATABASE_URL=...@localhost:5432/...`
  - `REDIS_URL=redis://localhost:6379`
- If API runs inside Docker compose profile `app`:
  - compose overrides hostnames to `postgres` and `redis`

## 9.2 Flutter local env notes
In `apps/mobile_flutter/.env.dev`:
- Android emulator should use:
  - `API_BASE_URL=http://10.0.2.2:3000/api/v1`
- iOS simulator usually uses:
  - `API_BASE_URL=http://localhost:3000/api/v1`

---

## 10) Start local infrastructure (Postgres + Redis)
From repo root:
```bash
docker compose up -d postgres redis
```

Verify:
```bash
docker compose ps
```

---

## 11) Run backend API
From `services/api`:
```bash
npm install
npm run db:generate
npm run db:migrate
npm run db:seed
npm run start:dev
```

Expected:
- API runs on `http://localhost:3000`
- Health check:
```bash
curl http://localhost:3000/health
```

---

## 12) Run Flutter app (preview)
From `apps/mobile_flutter`:
```bash
flutter pub get
flutter doctor
flutter devices
flutter run
```

If multiple devices are connected:
```bash
flutter run -d <DEVICE_ID>
```

Examples:
- Android emulator:
```bash
flutter run -d emulator-5554
```
- iOS simulator:
```bash
flutter run -d ios
```

---

## 13) Optional: Flutter web preview
If web support is enabled in your project:
```bash
flutter config --enable-web
flutter devices
flutter run -d chrome
```

Notes:
- Web is for quick UI/dev checks.
- Some mobile-specific behavior may differ.

---

## 14) End-to-end smoke test
After API + app running:
1. Register/login.
2. Load profile.
3. Switch grade.
4. Start session.
5. Answer several questions.
6. Submit session.
7. Confirm result and streak update.

If this passes, local setup is healthy.

---

## 15) Common issues

## `flutter doctor` has errors
- Install missing SDK/toolchain shown by doctor.
- Re-run until no blocking errors.

## Android app cannot hit API
- Use `10.0.2.2`, not `localhost`.

## iOS build/sign issues
- Open Xcode once and accept license.
- Re-run `xcodebuild -runFirstLaunch`.

## API cannot connect DB
- Ensure Docker containers are running.
- Confirm `DATABASE_URL` matches runtime mode.

## Command not found: flutter/node/docker
- Add tool to PATH or reinstall properly.

---

## 16) Reset local data
Danger: this clears local DB/cache state.

```bash
docker compose down -v
docker compose up -d postgres redis
```

Then reseed:
```bash
cd services/api
npm run db:migrate
npm run db:seed
```

---

## 17) Definition of Done (Local Ready)
- `flutter doctor` is healthy.
- Emulator/simulator starts successfully.
- API runs and health endpoint responds.
- Mobile app runs and completes core flow.
- No blocker error in local logs.
