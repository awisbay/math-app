# Math App Design System

This document outlines the design system used throughout the Math App Flutter application.

## Design Tokens

### Colors (`AppColors`)

#### Primary Colors
- `primary` - Main brand color (Indigo)
- `primaryContainer` - Container backgrounds for primary elements
- `onPrimary` - Text color on primary backgrounds

#### Secondary Colors
- `secondary` - Success/accent color (Green)
- `secondaryContainer` - Container backgrounds for success states
- `onSecondary` - Text color on secondary backgrounds

#### Semantic Colors
- `success` - Positive actions/states
- `warning` - Caution states
- `error` - Error states
- `info` - Informational states

#### Timer Colors
- `timerNormal` - Timer > 50% remaining
- `timerWarning` - Timer 25-50% remaining
- `timerCritical` - Timer < 25% remaining

#### Grade Colors
12 distinct colors for grades 1-12, accessible via `AppColors.gradeColors[index]`.

### Spacing (`AppSpacing`)

Base unit: `4px`

| Token | Value | Usage |
|-------|-------|-------|
| `xs` | 4px | Tight spacing |
| `sm` | 8px | Small gaps |
| `md` | 12px | Standard gaps |
| `lg` | 16px | Section gaps |
| `xl` | 24px | Large sections |
| `xxl` | 32px | Major sections |

### Border Radius (`AppRadius`)

| Token | Value | Usage |
|-------|-------|-------|
| `buttonRadius` | 16px | Buttons |
| `cardRadius` | 24px | Cards |
| `chipRadius` | Full | Chips, badges |
| `inputRadius` | 16px | Text fields |

### Shadows (`AppShadows`)

- `none` - Flat elements
- `small` - Buttons, chips
- `medium` - Cards, elevated surfaces
- `large` - Modals, dialogs
- `primary(color)` - Colored shadows for CTAs

## Components

### Buttons (`AppButton`)

```dart
// Primary button
AppButton.primary(
  text: 'Mulai',
  onPressed: () {},
  isFullWidth: true,
)

// Secondary button
AppButton.secondary(
  text: 'Batal',
  onPressed: () {},
)

// Ghost button
AppButton.ghost(
  text: 'Lewati',
  onPressed: () {},
)
```

Variants: `primary`, `secondary`, `ghost`, `danger`
Sizes: `small`, `medium`, `large`

### Cards (`AppCard`)

```dart
// Default card
AppCard(
  child: Text('Content'),
)

// Elevated card
AppCard.elevated(
  child: Text('Elevated content'),
)

// Result card
AppCard.result(
  isSuccess: true,
  child: Text('Success!'),
)
```

Variants: `default`, `elevated`, `outlined`, `highlighted`, `resultSuccess`, `resultFailure`

### Answer Options (`AnswerOption`)

```dart
AnswerOption(
  label: 'A',
  text: 'Option text',
  state: AnswerOptionState.normal,
  onTap: () {},
)
```

States: `normal`, `selected`, `correct`, `wrong`, `disabled`

### Timer Components

```dart
// Badge timer
TimerBadge(
  secondsRemaining: 450,
  totalSeconds: 900,
)

// Circular timer
CircularTimer(
  secondsRemaining: 450,
  totalSeconds: 900,
)

// Progress bar
QuizProgressBar(
  currentQuestion: 3,
  totalQuestions: 10,
)
```

### Grade Components

```dart
// Single grade chip
GradeChip(
  grade: 5,
  isSelected: true,
  onTap: () {},
)

// Horizontal list
GradeChipList(
  selectedGrade: 5,
  onGradeSelected: (grade) {},
)

// Selection grid
GradeGrid(
  selectedGrade: 5,
  onGradeSelected: (grade) {},
)
```

### Input Fields (`AppTextField`)

```dart
// Email field
AppTextField.email(
  controller: emailController,
)

// Password field
AppTextField.password(
  controller: passwordController,
)

// Name field
AppTextField.name(
  controller: nameController,
)
```

### Loading States

```dart
// Skeleton card
CardSkeleton(height: 120)

// List item skeleton
ListItemSkeleton(hasLeading: true, lines: 2)

// Empty state
EmptyState(
  icon: Icons.inbox,
  title: 'Belum ada data',
  subtitle: 'Mulai latihan untuk melihat progress',
)

// Error state
ErrorState(
  onRetry: () {},
)
```

## Screen Structure

### Navigation

The app uses a shell route with bottom navigation for main screens:
- Home (`/`)
- Practice (`/practice`)
- Progress (`/progress`)
- Profile (`/profile`)

Special screens (no bottom nav):
- Quiz (`/quiz`)
- Quiz Result (`/quiz/result`)
- Auth (`/login`, `/register`)

### Responsive Guidelines

- Minimum touch target: 44x44 dp
- Screen padding: 16px (standard), 24px (large)
- Max content width: 600px on tablets

## Animation Guidelines

| Duration | Usage |
|----------|-------|
| 150ms | Button taps, quick feedback |
| 250ms | Screen transitions, dialogs |
| 350ms | Complex animations |

Easing: `easeInOutCubic` for most transitions

## Indonesian Text Conventions

- Use formal Indonesian ("Anda" not "kamu")
- Keep labels concise
- Use action verbs for buttons ("Mulai", "Simpan", "Batal")
- Error messages should be helpful and specific

## Accessibility

- All interactive elements have minimum 44x44 touch targets
- Color contrast meets WCAG 2.1 AA standards
- Semantic labels for screen readers
- Focus indicators visible
