import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  // Mock data - will be replaced with actual data in Phase 2
  final int _totalQuestions = 10;
  int _currentQuestionIndex = 0;
  int _secondsRemaining = 900; // 15 minutes
  int? _selectedAnswer;
  bool _showResult = false;
  Timer? _timer;

  // Mock question data
  final List<Map<String, dynamic>> _questions = [
    {
      'question': 'Berapakah hasil dari 25 + 37?',
      'options': ['52', '62', '72', '82'],
      'correct': 1,
    },
    {
      'question': 'Jika 8 × 7 = ?',
      'options': ['54', '56', '58', '62'],
      'correct': 1,
    },
    {
      'question': 'Hasil dari 100 - 45 adalah?',
      'options': ['45', '55', '65', '75'],
      'correct': 1,
    },
    {
      'question': 'Berapakah 72 ÷ 8?',
      'options': ['8', '9', '10', '12'],
      'correct': 1,
    },
    {
      'question': 'Nilai tempat angka 5 pada bilangan 3.567 adalah?',
      'options': ['Satuan', 'Puluhan', 'Ratusan', 'Ribuan'],
      'correct': 2,
    },
    {
      'question': 'Hasil dari 15 + 27 - 12 adalah?',
      'options': ['28', '30', '32', '34'],
      'correct': 1,
    },
    {
      'question': 'Manakah bilangan genap berikut?',
      'options': ['13', '17', '22', '29'],
      'correct': 2,
    },
    {
      'question': 'Jika a = 5 dan b = 3, maka a × b + 2 = ?',
      'options': ['15', '17', '19', '21'],
      'correct': 1,
    },
    {
      'question': 'Keliling persegi dengan sisi 6 cm adalah?',
      'options': ['12 cm', '18 cm', '24 cm', '36 cm'],
      'correct': 2,
    },
    {
      'question': 'Berapakah 1/4 dari 80?',
      'options': ['15', '20', '25', '30'],
      'correct': 1,
    },
  ];

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
        _finishQuiz();
      }
    });
  }

  void _selectAnswer(int index) {
    if (_showResult) return;
    
    setState(() {
      _selectedAnswer = index;
      _showResult = true;
    });

    // Delay before moving to next question
    Future.delayed(const Duration(seconds: 1), () {
      if (_currentQuestionIndex < _totalQuestions - 1) {
        setState(() {
          _currentQuestionIndex++;
          _selectedAnswer = null;
          _showResult = false;
        });
      } else {
        _finishQuiz();
      }
    });
  }

  void _finishQuiz() {
    _timer?.cancel();
    context.pushReplacement('/quiz/result?sessionId=mock-session-id');
  }

  void _exitQuiz() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Keluar dari Quiz?'),
        content: const Text(
          'Progress kamu tidak akan disimpan. Yakin ingin keluar?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          AppButton(
            text: 'Keluar',
            variant: AppButtonVariant.danger,
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
          ),
        ],
      ),
    );
  }

  AnswerOptionState _getOptionState(int index) {
    if (!_showResult) {
      if (_selectedAnswer == null) return AnswerOptionState.normal;
      return _selectedAnswer == index
          ? AnswerOptionState.selected
          : AnswerOptionState.normal;
    }

    final correctIndex = _questions[_currentQuestionIndex]['correct'] as int;
    if (index == correctIndex) return AnswerOptionState.correct;
    if (index == _selectedAnswer) return AnswerOptionState.wrong;
    return AnswerOptionState.disabled;
  }

  @override
  Widget build(BuildContext context) {
    final currentQuestion = _questions[_currentQuestionIndex];
    final questionText = currentQuestion['question'] as String;
    final options = currentQuestion['options'] as List<String>;
    final progress = (_currentQuestionIndex + 1) / _totalQuestions;

    return WillPopScope(
      onWillPop: () async {
        _exitQuiz();
        return false;
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.onSurface),
            onPressed: _exitQuiz,
          ),
          title: QuizProgressBar(
            currentQuestion: _currentQuestionIndex + 1,
            totalQuestions: _totalQuestions,
            value: progress,
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
              child: Center(
                child: TimerBadge(
                  secondsRemaining: _secondsRemaining,
                  totalSeconds: 900,
                ),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Padding(
            padding: AppSpacing.paddingHorizontal,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.xl),
                // Question Card
                Expanded(
                  child: AppCard.elevated(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Question number badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.xs,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryContainer,
                            borderRadius: AppRadius.chip,
                          ),
                          child: Text(
                            'Soal ${_currentQuestionIndex + 1}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        // Question text
                        Text(
                          questionText,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            height: 1.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Answer options
                Expanded(
                  flex: 2,
                  child: ListView.separated(
                    itemCount: options.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, index) {
                      return AnswerOption(
                        label: String.fromCharCode(65 + index), // A, B, C, D
                        text: options[index],
                        state: _getOptionState(index),
                        onTap: () => _selectAnswer(index),
                      );
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
