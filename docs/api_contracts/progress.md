# Progress API Contracts

## Base URL
`/api/v1/progress`

---

## GET /
Get user progress overview.

### Headers
```
Authorization: Bearer {token}
```

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "overall": {
      "totalSessions": 45,
      "totalQuestions": 450,
      "correctAnswers": 380,
      "accuracy": 84.4,
      "totalTimeSpent": 16200
    },
    "byGrade": [
      {
        "grade": 5,
        "sessions": 30,
        "accuracy": 85.2,
        "avgScore": 8.5
      }
    ],
    "byTopic": [
      {
        "topic": "penjumlahan",
        "sessions": 10,
        "accuracy": 92.0
      }
    ],
    "streak": {
      "current": 5,
      "longest": 12,
      "lastCompletedAt": "2024-01-14T10:30:00Z"
    }
  }
}
```

---

## GET /history
Get session history.

### Headers
```
Authorization: Bearer {token}
```

### Query Parameters
- `page` (number, default: 1)
- `limit` (number, default: 10)
- `grade` (number, optional): Filter by grade

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "sessions": [
      {
        "sessionId": "session_uuid",
        "grade": 5,
        "score": 8,
        "totalQuestions": 10,
        "accuracy": 80,
        "completedAt": "2024-01-15T10:12:00Z"
      }
    ],
    "pagination": {
      "page": 1,
      "limit": 10,
      "total": 45,
      "totalPages": 5
    }
  }
}
```
