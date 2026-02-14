# First Day Setup Checklist (Non-Technical)

Use this checklist to run the app locally for the first time.

## A. Install Required Apps
- [ ] Install **Flutter SDK**
- [ ] Install **Android Studio**
- [ ] Install **Xcode** (macOS only, for iOS simulator)
- [ ] Install **Node.js LTS**
- [ ] Install **Docker Desktop**
- [ ] Install **VS Code**

## B. Install VS Code Extensions
- [ ] Install extension: **Flutter**
- [ ] Install extension: **Dart**

## C. Verify Tools
Open Terminal and run:
```bash
flutter --version
flutter doctor
node -v
docker --version
```
- [ ] `flutter doctor` shows no blocking error

## D. Open Project
- [ ] Open project folder in VS Code:
  - `/Users/wisbay/Documents/wbcode/math-app`

## E. Prepare Environment Files
Run at project root:
```bash
cp services/api/.env.local.example services/api/.env.local
cp apps/mobile_flutter/.env.dev.example apps/mobile_flutter/.env.dev
```
- [ ] Both env files created

## F. Start Local Database and Redis
From project root:
```bash
docker compose up -d postgres redis
```
- [ ] Containers are running (`docker compose ps`)

## G. Start Backend API
```bash
cd services/api
npm install
npm run db:generate
npm run db:migrate
npm run db:seed
npm run start:dev
```
- [ ] API runs without error
- [ ] Health check works: `http://localhost:3000/health`

## H. Start Emulator / Simulator
### Android (recommended first)
- [ ] Open Android Studio
- [ ] Start one Android emulator device

### iOS (macOS only)
- [ ] Open Xcode Simulator

## I. Run Flutter App
In new terminal:
```bash
cd /Users/wisbay/Documents/wbcode/math-app/apps/mobile_flutter
flutter pub get
flutter devices
flutter run
```
- [ ] App opens in emulator/simulator

## J. Quick Functional Check
- [ ] Register or login works
- [ ] Home screen loads
- [ ] Start session works
- [ ] Submit quiz works
- [ ] Result screen appears

## K. Daily Start Command (after setup)
From project root:
```bash
docker compose up -d postgres redis
```
Then run API and Flutter again (sections G and I).

## L. If Something Breaks
- [ ] Check `/Users/wisbay/Documents/wbcode/math-app/docs/deployment/local-deployment.md`
- [ ] Ask team and share screenshot + terminal error log
