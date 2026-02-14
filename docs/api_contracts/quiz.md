# Quiz API Contracts

## Base URL
`/api/v1/quiz`

---

## POST /session/start
Start a new quiz session.

### Headers
```
Authorization: Bearer {token}
```

### Response (201 Created)
```json
{
  "success": true,
  "data": {
    "sessionId": "session_uuid",
    "grade": 5,
    "questions": [
      {
        "id": "q1_uuid",
        "type": "multiple_choice",
        "question": "Berapakah 25 + 37?",
        "options": ["52", "62", "72", "82"],
        "correctAnswer": 1,
        "timeLimit": 90,
        "topic": "penjumlahan"
      }
    ],
    "totalQuestions": 10,
    "sessionDuration": 900,
    "startedAt": "2024-01-15T10:00:00Z",
    "expiresAt": "2024-01-15T10:15:00Z"
  }
}
```

### Notes
- Returns exactly 10 questions
- Session expires after 15 minutes (900 seconds)
- Questions are selected with anti-repeat algorithm

---

## POST /session/:id/submit
Submit answers for a session.

### Headers
```
Authorization: Bearer {token}
```

### Request
```json
{
  "answers": [
    {
      "questionId": "q1_uuid",
      "selectedOption": 1,
      "timeSpent": 45
    }
  ]
}
```

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "sessionId": "session_uuid",
    "score": 8,
    "totalQuestions": 10,
    "correctAnswers": 8,
    "timeSpent": 720,
    "completedAt": "2024-01-15T10:12:00Z",
    "streakUpdated": true,
    "newStreak": 6
  }
}
```

### Errors
- `400` - Session expired
- `400` - Invalid answers format
- `404` - Session not found

---

## GET /session/:id/result
Get session result details.

### Headers
```
Authorization: Bearer {token}
```

### Response (200 OK)
```json
{
  "success": true,
  "data": {
    "sessionId": "session_uuid",
    "score": 8,
    "totalQuestions": 10,
    "correctAnswers": 8,
    "percentage": 80,
    "timeSpent": 720,
    "grade": 5,
    "completedAt": "2024-01-15T10:12:00Z",
    "breakdown": [
      {
        "questionId": "q1_uuid",
        "question": "Berapakah 25 + 37?",
        "correct": true,
        "correctAnswer": 1,
        "userAnswer": 1,
        "timeSpent": 45
      }
    ]
  }
}
```
