import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';

/// Analytics service for tracking user events
class AnalyticsService {
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  static Future<void> logEvent({
    required String name,
    Map<String, dynamic>? parameters,
  }) async {
    if (kDebugMode) {
      print('[Analytics] $name: $parameters');
    }
    await _analytics.logEvent(name: name, parameters: parameters);
  }

  static Future<void> logSessionStart({required int grade}) async {
    await logEvent(
      name: 'session_start',
      parameters: {'grade': grade},
    );
  }

  static Future<void> logSessionComplete({
    required int score,
    required int totalQuestions,
    required int grade,
  }) async {
    await logEvent(
      name: 'session_complete',
      parameters: {
        'score': score,
        'total_questions': totalQuestions,
        'grade': grade,
      },
    );
  }

  static Future<void> logAnswerSubmit({
    required bool isCorrect,
    required int timeSpent,
    required int difficulty,
  }) async {
    await logEvent(
      name: 'answer_submit',
      parameters: {
        'is_correct': isCorrect,
        'time_spent': timeSpent,
        'difficulty': difficulty,
      },
    );
  }

  static Future<void> setUserProperties({
    required String userId,
    required int grade,
  }) async {
    await _analytics.setUserId(id: userId);
    await _analytics.setUserProperty(name: 'grade', value: grade.toString());
  }
}
