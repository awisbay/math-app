import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class ApiClient {
  late final Dio _dio;
  String? _authToken;

  ApiClient() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:3000/api/v1', // TODO: Use env config
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 20),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Add auth token if available
          if (_authToken != null) {
            options.headers['Authorization'] = 'Bearer $_authToken';
          }
          
          if (kDebugMode) {
            print('[API] ${options.method} ${options.path}');
          }
          
          return handler.next(options);
        },
        onResponse: (response, handler) {
          if (kDebugMode) {
            print('[API] ${response.statusCode} ${response.requestOptions.path}');
          }
          
          return handler.next(response);
        },
        onError: (error, handler) {
          if (kDebugMode) {
            print('[API ERROR] ${error.response?.statusCode} ${error.message}');
          }
          
          return handler.next(error);
        },
      ),
    );
  }

  void setAuthToken(String? token) {
    _authToken = token;
  }

  // Auth APIs
  Future<ApiResponse<AuthData>> login(String email, String password) async {
    return _post('/auth/login', data: {
      'email': email,
      'password': password,
    }, parser: (data) => AuthData.fromJson(data['user']));
  }

  Future<ApiResponse<AuthData>> register({
    required String email,
    required String password,
    required String name,
    String? birthDate,
    int? currentGrade,
  }) async {
    return _post('/auth/register', data: {
      'email': email,
      'password': password,
      'name': name,
      if (birthDate != null) 'birthDate': birthDate,
      if (currentGrade != null) 'currentGrade': currentGrade,
    }, parser: (data) => AuthData.fromJson(data['user']));
  }

  // Profile APIs
  Future<ApiResponse<UserProfile>> getProfile() async {
    return _get('/profile', parser: (data) => UserProfile.fromJson(data));
  }

  Future<ApiResponse<UserProfile>> updateProfile({
    String? name,
    String? birthDate,
    int? currentGrade,
  }) async {
    return _patch('/profile', data: {
      if (name != null) 'name': name,
      if (birthDate != null) 'birthDate': birthDate,
      if (currentGrade != null) 'currentGrade': currentGrade,
    }, parser: (data) => UserProfile.fromJson(data));
  }

  Future<ApiResponse<GradeSwitchData>> switchGrade(int grade) async {
    return _post('/profile/switch-grade', data: {
      'grade': grade,
    }, parser: (data) => GradeSwitchData.fromJson(data));
  }

  // Quiz/Session APIs
  Future<ApiResponse<QuizSession>> createSession({int? grade}) async {
    return _post('/quiz/sessions', data: {
      if (grade != null) 'grade': grade,
    }, parser: (data) => QuizSession.fromJson(data));
  }

  Future<ApiResponse<QuizSession>> getSession(String sessionId) async {
    return _get('/quiz/sessions/$sessionId', parser: (data) => QuizSession.fromJson(data));
  }

  Future<ApiResponse<void>> submitAnswer({
    required String sessionId,
    required String sessionQuestionId,
    required int selectedOption,
    required int timeSpentSeconds,
  }) async {
    return _post('/quiz/sessions/$sessionId/answers', data: {
      'sessionQuestionId': sessionQuestionId,
      'selectedOption': selectedOption,
      'timeSpentSeconds': timeSpentSeconds,
    }, parser: (_) => null);
  }

  Future<ApiResponse<SessionResult>> completeSession(String sessionId) async {
    return _post('/quiz/sessions/$sessionId/submit', parser: (data) => SessionResult.fromJson(data));
  }

  Future<ApiResponse<void>> abandonSession(String sessionId) async {
    return _post('/quiz/sessions/$sessionId/abandon', parser: (_) => null);
  }

  // Progress APIs
  Future<ApiResponse<ProgressData>> getProgress() async {
    return _get('/progress', parser: (data) => ProgressData.fromJson(data));
  }

  // Generic HTTP methods
  Future<ApiResponse<T>> _get<T>(
    String path, {
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.get(path);
      return _handleResponse(response, parser);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<T>> _post<T>(
    String path, {
    dynamic data,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.post(path, data: data);
      return _handleResponse(response, parser);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  Future<ApiResponse<T>> _patch<T>(
    String path, {
    dynamic data,
    required T Function(dynamic data) parser,
  }) async {
    try {
      final response = await _dio.patch(path, data: data);
      return _handleResponse(response, parser);
    } on DioException catch (e) {
      return _handleError(e);
    }
  }

  ApiResponse<T> _handleResponse<T>(
    Response response,
    T Function(dynamic data) parser,
  ) {
    final data = response.data;
    
    if (data['success'] == true) {
      return ApiResponse.success(parser(data['data']));
    } else {
      return ApiResponse.error(
        code: data['error']?['code'] ?? 'UNKNOWN_ERROR',
        message: data['error']?['message'] ?? 'Terjadi kesalahan',
      );
    }
  }

  ApiResponse<T> _handleError<T>(DioException error) {
    final response = error.response;
    
    if (response != null) {
      final data = response.data;
      return ApiResponse.error(
        code: data?['error']?['code'] ?? 'HTTP_${response.statusCode}',
        message: _getErrorMessage(data?['error']?['code']),
        statusCode: response.statusCode,
      );
    }
    
    return ApiResponse.error(
      code: 'NETWORK_ERROR',
      message: 'Koneksi gagal. Periksa internet Anda.',
    );
  }

  String _getErrorMessage(String? code) {
    switch (code) {
      case 'VALIDATION_ERROR':
        return 'Data tidak valid.';
      case 'UNAUTHORIZED':
      case 'INVALID_TOKEN':
        return 'Sesi login habis. Silakan masuk lagi.';
      case 'EMAIL_EXISTS':
        return 'Email sudah terdaftar.';
      case 'INVALID_CREDENTIALS':
        return 'Email atau password salah.';
      case 'SESSION_POOL_INSUFFICIENT':
        return 'Soal belum tersedia cukup. Coba lagi sebentar.';
      case 'ACTIVE_SESSION_EXISTS':
        return 'Anda masih memiliki sesi aktif.';
      case 'SESSION_NOT_FOUND':
        return 'Sesi tidak ditemukan.';
      case 'SESSION_NOT_ACTIVE':
        return 'Sesi sudah tidak aktif.';
      default:
        return 'Terjadi kesalahan. Coba lagi.';
    }
  }
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? errorCode;
  final String? errorMessage;
  final int? statusCode;

  ApiResponse._({
    required this.success,
    this.data,
    this.errorCode,
    this.errorMessage,
    this.statusCode,
  });

  factory ApiResponse.success(T data) {
    return ApiResponse._(success: true, data: data);
  }

  factory ApiResponse.error({
    required String code,
    required String message,
    int? statusCode,
  }) {
    return ApiResponse._(
      success: false,
      errorCode: code,
      errorMessage: message,
      statusCode: statusCode,
    );
  }
}

// Model classes
class AuthData {
  final String id;
  final String email;
  final String name;

  AuthData({
    required this.id,
    required this.email,
    required this.name,
  });

  factory AuthData.fromJson(Map<String, dynamic> json) {
    return AuthData(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class UserProfile {
  final String id;
  final String email;
  final String name;
  final String? birthDate;
  final int? age;
  final int currentGrade;
  final int totalSessions;

  UserProfile({
    required this.id,
    required this.email,
    required this.name,
    this.birthDate,
    this.age,
    required this.currentGrade,
    this.totalSessions = 0,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'] ?? '',
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      birthDate: json['birthDate'],
      age: json['age'],
      currentGrade: json['currentGrade'] ?? 1,
      totalSessions: json['totalSessions'] ?? 0,
    );
  }
}

class GradeSwitchData {
  final int previousGrade;
  final int currentGrade;
  final String message;

  GradeSwitchData({
    required this.previousGrade,
    required this.currentGrade,
    required this.message,
  });

  factory GradeSwitchData.fromJson(Map<String, dynamic> json) {
    return GradeSwitchData(
      previousGrade: json['previousGrade'] ?? 0,
      currentGrade: json['currentGrade'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

class QuizQuestion {
  final String id;
  final int ordinal;
  final String question;
  final List<String> options;
  final int correctAnswer;
  final int difficulty;
  final int timeLimit;

  QuizQuestion({
    required this.id,
    required this.ordinal,
    required this.question,
    required this.options,
    required this.correctAnswer,
    required this.difficulty,
    required this.timeLimit,
  });

  factory QuizQuestion.fromJson(Map<String, dynamic> json) {
    return QuizQuestion(
      id: json['id'] ?? '',
      ordinal: json['ordinal'] ?? 0,
      question: json['question'] ?? '',
      options: List<String>.from(json['options'] ?? []),
      correctAnswer: json['correctAnswer'] ?? 0,
      difficulty: json['difficulty'] ?? 1,
      timeLimit: json['timeLimit'] ?? 90,
    );
  }
}

class QuizSession {
  final String sessionId;
  final int grade;
  final String status;
  final int durationSeconds;
  final DateTime expiresAt;
  final List<QuizQuestion> questions;

  QuizSession({
    required this.sessionId,
    required this.grade,
    required this.status,
    required this.durationSeconds,
    required this.expiresAt,
    required this.questions,
  });

  factory QuizSession.fromJson(Map<String, dynamic> json) {
    return QuizSession(
      sessionId: json['sessionId'] ?? '',
      grade: json['grade'] ?? 1,
      status: json['status'] ?? 'ACTIVE',
      durationSeconds: json['durationSeconds'] ?? 900,
      expiresAt: DateTime.parse(json['expiresAt'] ?? DateTime.now().toIso8601String()),
      questions: (json['questions'] as List?)
          ?.map((q) => QuizQuestion.fromJson(q))
          .toList() ?? [],
    );
  }
}

class SessionResult {
  final String sessionId;
  final int score;
  final int totalQuestions;
  final int correctAnswers;
  final int percentage;
  final int timeSpent;
  final DateTime completedAt;

  SessionResult({
    required this.sessionId,
    required this.score,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.percentage,
    required this.timeSpent,
    required this.completedAt,
  });

  factory SessionResult.fromJson(Map<String, dynamic> json) {
    return SessionResult(
      sessionId: json['sessionId'] ?? '',
      score: json['score'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 10,
      correctAnswers: json['correctAnswers'] ?? 0,
      percentage: json['percentage'] ?? 0,
      timeSpent: json['timeSpent'] ?? 0,
      completedAt: DateTime.parse(json['completedAt'] ?? DateTime.now().toIso8601String()),
    );
  }
}

class ProgressData {
  final int totalSessions;
  final int totalQuestions;
  final double accuracy;

  ProgressData({
    required this.totalSessions,
    required this.totalQuestions,
    required this.accuracy,
  });

  factory ProgressData.fromJson(Map<String, dynamic> json) {
    return ProgressData(
      totalSessions: json['totalSessions'] ?? 0,
      totalQuestions: json['totalQuestions'] ?? 0,
      accuracy: (json['accuracy'] ?? 0).toDouble(),
    );
  }
}
