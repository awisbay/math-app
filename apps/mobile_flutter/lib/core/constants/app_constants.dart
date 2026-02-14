class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'Math App';
  static const String appVersion = '0.0.1';

  // Session Rules
  static const int sessionDurationSeconds = 900; // 15 minutes
  static const int questionsPerSession = 10;
  static const int minGrade = 1;
  static const int maxGrade = 12;

  // Language
  static const String defaultLanguage = 'id';

  // API
  static const String apiBaseUrl = 'http://localhost:3000/api/v1';
  static const int apiTimeoutSeconds = 30;

  // Storage Keys
  static const String authTokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String settingsKey = 'app_settings';
}
