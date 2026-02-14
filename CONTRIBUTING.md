# Contributing Guidelines

## Branch Strategy

### Main Branches
- `main` - Production-ready code
- `develop` - Integration branch for features

### Feature Branches
- Pattern: `feature/TICKET-ID-short-description`
- Example: `feature/MA-12-add-login-screen`

### Bugfix Branches
- Pattern: `fix/TICKET-ID-short-description`
- Example: `fix/MA-15-fix-timer-bug`

## Commit Message Convention

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Types
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, semicolons, etc)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes

### Examples
```
feat(auth): add Firebase login integration

fix(quiz): correct timer countdown logic

docs(api): update auth endpoint documentation
```

## Code Review Process

1. Create feature branch from `develop`
2. Make changes and commit following conventions
3. Push branch and create PR to `develop`
4. Ensure CI passes
5. Request review from at least 1 team member
6. Address review feedback
7. Merge after approval

## Definition of Done

- [ ] Code implements the requirement
- [ ] Code follows style guidelines (lint + format)
- [ ] Unit tests pass
- [ ] No console errors/warnings
- [ ] PR template filled out
- [ ] Reviewed and approved by at least 1 person

## Module Owners

| Module | Owner |
|--------|-------|
| Mobile App (Flutter) | TBD |
| API (NestJS) | TBD |
| Content/Questions | TBD |
