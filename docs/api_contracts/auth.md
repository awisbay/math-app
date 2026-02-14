# Auth API Contracts

## Base URL
`/api/v1/auth`

---

## POST /register
Register a new user.

### Request
```json
{
  "email": "user@example.com",
  "password": "securePassword123",
  "name": "Budi Santoso",
  "birthDate": "2010-05-15",
  "currentGrade": 5
}
```

### Response (201 Created)
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "Budi Santoso",
      "birthDate": "2010-05-15",
      "currentGrade": 5,
      "createdAt": "2024-01-15T08:30:00Z"
    },
    "token": "firebase_id_token"
  }
}
```

### Errors
- `400` - Invalid input data
- `409` - Email already exists

---

## POST /login
Authenticate existing user.

### Request
```json
{
  "email": "user@example.com",
  "password": "securePassword123"
}
```

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "user": {
      "id": "uuid",
      "email": "user@example.com",
      "name": "Budi Santoso",
      "currentGrade": 5
    },
    "token": "firebase_id_token"
  }
}
```

### Errors
- `401` - Invalid credentials

---

## POST /logout
Sign out current user.

### Headers
```
Authorization: Bearer {token}
```

### Response (200 OK)
```json
{
  "success": true,
  "message": "Logged out successfully"
}
```

---

## POST /refresh
Refresh authentication token.

### Headers
```
Authorization: Bearer {refresh_token}
```

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "token": "new_firebase_id_token"
  }
}
```
