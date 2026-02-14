# Phase 2 API Contract

Base path: `/api/v1`
Content-Type: `application/json`
Auth: `Authorization: Bearer <token>` for protected endpoints

## 1) Register
`POST /auth/register`

Request:
```json
{
  "email": "user@example.com",
  "password": "StrongPassword123",
  "full_name": "Budi",
  "birth_date": "2014-05-10"
}
```

Response 201:
```json
{
  "user": {
    "id": "uuid",
    "email": "user@example.com",
    "full_name": "Budi",
    "age": 11,
    "current_grade": 5
  }
}
```

## 2) Login
`POST /auth/login`

Request:
```json
{
  "email": "user@example.com",
  "password": "StrongPassword123"
}
```

Response 200:
```json
{
  "access_token": "jwt_or_provider_token",
  "token_type": "Bearer",
  "expires_in": 3600
}
```

## 3) Get My Profile
`GET /me`

Response 200:
```json
{
  "id": "uuid",
  "email": "user@example.com",
  "full_name": "Budi",
  "birth_date": "2014-05-10",
  "age": 11,
  "current_grade": 5,
  "streak_count": 0
}
```

## 4) Update My Profile
`PATCH /me`

Request:
```json
{
  "full_name": "Budi Santoso",
  "birth_date": "2014-05-10"
}
```

Response 200:
```json
{
  "id": "uuid",
  "full_name": "Budi Santoso",
  "age": 11,
  "current_grade": 5
}
```

## 5) Switch Grade
`POST /me/grade-switch`

Request:
```json
{
  "target_grade": 6
}
```

Response 200:
```json
{
  "id": "uuid",
  "current_grade": 6,
  "updated_at": "2026-02-14T10:00:00Z"
}
```

## 6) Health
`GET /health`

Response 200:
```json
{
  "status": "ok"
}
```

## Error Example
```json
{
  "code": "VALIDATION_ERROR",
  "message": "Invalid request payload",
  "details": [
    {"field": "target_grade", "message": "must be between 1 and 12"}
  ],
  "request_id": "req_123"
}
```
