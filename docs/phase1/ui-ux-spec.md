# Phase 1 UI/UX Specification

## Design Principles
- Child-friendly but not childish.
- Clear visual hierarchy for fast comprehension.
- Minimal cognitive load during quiz session.
- Consistent interaction language across all screens.

## Screen-by-Screen Spec

### 1) Onboarding & Auth
Purpose: fast entry, profile bootstrap.
- Elements:
  - Welcome panel with app value proposition.
  - Register/login form.
  - Birth date and current grade setup.
- UX requirements:
  - Validation errors inline and in Indonesian.
  - Can complete setup under 60 seconds.

### 2) Home
Purpose: launch practice quickly and show learning status.
- Elements:
  - Greeting card (name + streak).
  - Grade selector chips (1-12).
  - Category/topic cards.
  - Last score summary.
- UX requirements:
  - Start session CTA always visible above fold.
  - Grade switch updates content immediately.

### 3) Quiz Session
Purpose: distraction-free answering flow.
- Elements:
  - Top bar with timer and question index.
  - Question card (text + optional image).
  - Multiple-choice options.
  - Previous/Next/Submit controls.
- UX requirements:
  - One question per screen.
  - Option selection feedback in <100ms perceived response.
  - Auto-submit when timer reaches 0.

### 4) Results
Purpose: immediate feedback and next action.
- Elements:
  - Score summary.
  - Correct/incorrect count.
  - Topic breakdown.
  - CTA: retry / next session.
- UX requirements:
  - Show completion status clearly.
  - Encourage next daily session for streak continuity.

### 5) Progress
Purpose: show growth and weak topics.
- Elements:
  - Weekly activity.
  - Mastery by topic.
  - Session history list.
- UX requirements:
  - Use clear progress indicators, not dense tables.
  - Grade filter is persistent.

### 6) Profile
Purpose: manage account and preferences.
- Elements:
  - User profile info.
  - Current grade.
  - Notification preference.
  - Logout.

## UX States Matrix
Each core screen must include:
- Loading state.
- Empty state.
- Error state with retry action.
- Success/default state.

## Navigation Rules
- Bottom navigation tabs: Home, Practice, Progress, Profile.
- Quiz route should not be opened twice in stack.
- Back from quiz requires confirmation when answers are in progress.

## Motion Guidance
- Short transitions (150-250ms).
- Use easing that feels soft and educational, not aggressive.
- No distracting looping animation during active quiz.
