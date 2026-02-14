# Profile API Contracts

## Base URL
`/api/v1/profile`

---

## GET /
Get current user profile.

### Headers
```
Authorization: Bearer {token}
```

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "Budi Santoso",
    "birthDate": "2010-05-15",
    "age": 14,
    "currentGrade": 5,
    "streak": {
      "current": 5,
      "longest": 12,
      "lastCompletedAt": "2024-01-14T10:30:00Z"
    },
    "totalSessions": 45,
    "createdAt": "2024-01-01T00:00:00Z"
  }
}
```

---

## PATCH /
Update user profile.

### Headers
```
Authorization: Bearer {token}
```

### Request
```json
{
  "name": "Budi Santoso Updated",
  "birthDate": "2010-06-20",
  "currentGrade": 6
}
```

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "id": "uuid",
    "email": "user@example.com",
    "name": "Budi Santoso Updated",
    "birthDate": "2010-06-20",
    "age": 14,
    "currentGrade": 6,
    "updatedAt": "2024-01-15T09:00:00Z"
  }
}
```

### Validation Rules
- `currentGrade`: Must be between 1 and 12
- `birthDate`: Must be valid date string (ISO 8601)

---

## POST /switch-grade
Switch user's current grade.

### Headers
```
Authorization: Bearer {token}
```

### Request
```json
{
  "grade": 7
}
```

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "previousGrade": 6,
    "currentGrade": 7,
    "message": "Grade switched successfully"
  }
}
```

### Errors
- `400` - Invalid grade (not 1-12)
- `400` - Same grade as current
