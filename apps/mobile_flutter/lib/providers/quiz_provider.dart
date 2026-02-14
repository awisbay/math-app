import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/sources/api_client.dart';

final quizProvider = StateNotifierProvider<QuizNotifier, QuizState>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return QuizNotifier(apiClient);
});

final currentQuestionProvider = Provider<QuizQuestion?>((ref) {
  final state = ref.watch(quizProvider);
  if (state.session == null || state.currentQuestionIndex >= state.session!.questions.length) {
    return null;
  }
  return state.session!.questions[state.currentQuestionIndex];
});

final timeRemainingProvider = Provider<int>((ref) {
  return ref.watch(quizProvider).timeRemaining;
});

class QuizState {
  final bool isLoading;
  final QuizSession? session;
  final int currentQuestionIndex;
  final int timeRemaining;
  final Map<String, int> answers; // questionId -> selectedOption
  final Map<String, int> timeSpent; // questionId -> seconds
  final String? errorMessage;
  final bool isSubmitting;
  final SessionResult? result;

  QuizState({
    this.isLoading = false,
    this.session,
    this.currentQuestionIndex = 0,
    this.timeRemaining = 0,
    this.answers = const {},
    this.timeSpent = const {},
    this.errorMessage,
    this.isSubmitting = false,
    this.result,
  });

  QuizState copyWith({
    bool? isLoading,
    QuizSession? session,
    int? currentQuestionIndex,
    int? timeRemaining,
    Map<String, int>? answers,
    Map<String, int>? timeSpent,
    String? errorMessage,
    bool? isSubmitting,
    SessionResult? result,
  }) {
    return QuizState(
      isLoading: isLoading ?? this.isLoading,
      session: session ?? this.session,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      timeRemaining: timeRemaining ?? this.timeRemaining,
      answers: answers ?? this.answers,
      timeSpent: timeSpent ?? this.timeSpent,
      errorMessage: errorMessage,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      result: result ?? this.result,
    );
  }

  bool get isLastQuestion {
    if (session == null) return false;
    return currentQuestionIndex >= session!.questions.length - 1;
  }

  bool get isFirstQuestion => currentQuestionIndex == 0;

  int get answeredCount => answers.length;

  int get totalQuestions => session?.questions.length ?? 0;

  double get progress => totalQuestions > 0 ? answeredCount / totalQuestions : 0;
}

class QuizNotifier extends StateNotifier<QuizState> {
  final ApiClient _apiClient;
  Timer? _timer;
  DateTime? _questionStartTime;

  QuizNotifier(this._apiClient) : super(QuizState());

  Future<bool> startSession({int? grade}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    
    final response = await _apiClient.createSession(grade: grade);
    
    if (response.success && response.data != null) {
      final session = response.data!;
      final now = DateTime.now();
      final expiresAt = session.expiresAt;
      final timeRemaining = expiresAt.difference(now).inSeconds;
      
      state = QuizState(
        session: session,
        timeRemaining: timeRemaining > 0 ? timeRemaining : 0,
      );
      
      _questionStartTime = DateTime.now();
      _startTimer();
      
      return true;
    } else {
      state = state.copyWith(
        isLoading: false,
        errorMessage: response.errorMessage,
      );
      return false;
    }
  }

  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (state.timeRemaining <= 0) {
        timer.cancel();
        _autoSubmit();
      } else {
        state = state.copyWith(timeRemaining: state.timeRemaining - 1);
      }
    });
  }

  void pauseTimer() {
    _timer?.cancel();
  }

  void resumeTimer() {
    if (state.timeRemaining > 0 && state.result == null) {
      _startTimer();
    }
  }

  void answerQuestion(int selectedOption) {
    if (state.session == null) return;
    
    final currentQuestion = state.session!.questions[state.currentQuestionIndex];
    final questionId = currentQuestion.id;
    
    // Calculate time spent on this question
    final now = DateTime.now();
    final timeSpent = _questionStartTime != null
        ? now.difference(_questionStartTime!).inSeconds
        : 0;
    
    // Update answers
    final newAnswers = Map<String, int>.from(state.answers);
    newAnswers[questionId] = selectedOption;
    
    final newTimeSpent = Map<String, int>.from(state.timeSpent);
    newTimeSpent[questionId] = timeSpent;
    
    state = state.copyWith(
      answers: newAnswers,
      timeSpent: newTimeSpent,
    );
    
    // Submit answer to server (async, don't wait)
    _submitAnswerToServer(questionId, selectedOption, timeSpent);
  }

  Future<void> _submitAnswerToServer(
    String questionId,
    int selectedOption,
    int timeSpentSeconds,
  ) async {
    if (state.session == null) return;
    
    await _apiClient.submitAnswer(
      sessionId: state.session!.sessionId,
      sessionQuestionId: questionId,
      selectedOption: selectedOption,
      timeSpentSeconds: timeSpentSeconds,
    );
  }

  void nextQuestion() {
    if (state.session == null) return;
    if (state.currentQuestionIndex < state.session!.questions.length - 1) {
      _questionStartTime = DateTime.now();
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex + 1);
    }
  }

  void previousQuestion() {
    if (state.currentQuestionIndex > 0) {
      _questionStartTime = DateTime.now();
      state = state.copyWith(currentQuestionIndex: state.currentQuestionIndex - 1);
    }
  }

  void goToQuestion(int index) {
    if (state.session == null) return;
    if (index >= 0 && index < state.session!.questions.length) {
      _questionStartTime = DateTime.now();
      state = state.copyWith(currentQuestionIndex: index);
    }
  }

  Future<bool> submitSession() async {
    if (state.session == null) return false;
    
    _timer?.cancel();
    state = state.copyWith(isSubmitting: true);
    
    final response = await _apiClient.completeSession(state.session!.sessionId);
    
    if (response.success && response.data != null) {
      state = state.copyWith(
        isSubmitting: false,
        result: response.data,
      );
      return true;
    } else {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: response.errorMessage,
      );
      // Restart timer if failed
      _startTimer();
      return false;
    }
  }

  Future<void> _autoSubmit() async {
    if (state.session == null || state.result != null) return;
    await submitSession();
  }

  Future<void> abandonSession() async {
    if (state.session == null) return;
    
    _timer?.cancel();
    
    await _apiClient.abandonSession(state.session!.sessionId);
    
    state = QuizState();
  }

  void reset() {
    _timer?.cancel();
    state = QuizState();
  }

  void clearError() {
    state = state.copyWith(errorMessage: null);
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
