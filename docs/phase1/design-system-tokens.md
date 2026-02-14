# Phase 1 Design System Tokens

## Color Tokens
- `primary-500`: #3D4BEB
- `primary-400`: #6A7BFF
- `surface-50`: #F5F7FF
- `surface-0`: #FFFFFF
- `text-900`: #1C2140
- `text-700`: #4A4F75
- `success-500`: #39D98A
- `warning-500`: #FFB020
- `error-500`: #FF5A5F
- `info-500`: #2D9CFF
- `border-200`: #DDE3FF

## Gradient Tokens
- `bg-main`: linear-gradient(180deg, #6A7BFF 0%, #8B96FF 100%)
- `card-hero`: linear-gradient(135deg, #3D4BEB 0%, #5D6BFF 100%)

## Spacing Tokens (px)
- `xs`: 4
- `sm`: 8
- `md`: 12
- `lg`: 16
- `xl`: 24
- `2xl`: 32

## Radius Tokens (px)
- `sm`: 8
- `md`: 12
- `lg`: 16
- `xl`: 20
- `pill`: 999

## Shadow Tokens
- `card`: 0 8 24 rgba(61, 75, 235, 0.12)
- `floating`: 0 12 32 rgba(28, 33, 64, 0.16)

## Typography Tokens
- Font family recommendation:
  - Primary: `Nunito Sans`
  - Secondary: `Plus Jakarta Sans`
- Sizes:
  - `display`: 28 / 700
  - `h1`: 22 / 700
  - `h2`: 18 / 700
  - `body-lg`: 16 / 500
  - `body`: 14 / 500
  - `caption`: 12 / 500

## Component State Tokens
- Answer option:
  - default border: `border-200`
  - selected border: `primary-500`
  - correct background: `#E8FFF3`
  - wrong background: `#FFEDEE`
- Button:
  - primary bg: `primary-500`
  - primary disabled: `#A9B1F7`

## Accessibility Baseline
- Minimum contrast target: WCAG AA for body text.
- Minimum touch size: 44x44.
- Avoid color-only meaning; add icons/text labels for correctness states.
