# MVP Scope

## Product Vision
A Flutter-based mobile learning app for Indonesian math practice from Kelas 1 SD to Kelas 12 SMA, with short daily sessions and streak motivation.

## In Scope (MVP)
- User authentication (register/login/logout).
- User profile with age, birth date, and current grade.
- Grade selection/switching across grades 1-12.
- Quiz session engine:
  - 15-minute timer.
  - 10 questions per session.
  - Indonesian language only.
- Dynamic question selection with anti-repeat history.
- Session result screen with score and summary.
- Daily streak tracking and display.
- Basic progress view by grade/topic.
- Push notification reminder (daily practice reminder).

## Out of Scope (Post-MVP)
- Leaderboards.
- Real-time multiplayer quizzes.
- Parent deep analytics dashboard.
- Video lessons and live tutoring.
- Offline-first full mode.
- Web/desktop client.

## Non-Functional Requirements
- App startup under acceptable mobile baseline on mid-range devices.
- Core quiz flow must be stable and crash-free for beta users.
- API endpoints for session generation should respond consistently for normal load.
- Data and auth must follow basic security best practices.

## Acceptance Criteria
- A new user can register, set profile, and start a session in less than 2 minutes.
- Each session enforces 10 questions and 15-minute limit.
- User can switch grade and get grade-appropriate questions.
- Streak updates correctly for daily completion.
- Result and progress data are visible after session completion.
