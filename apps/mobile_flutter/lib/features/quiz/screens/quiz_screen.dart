import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../providers/quiz_provider.dart';
import '../../../data/sources/api_client.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key});

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  bool _hasNavigatedToResult = false;

  @override
  void initState() {
    super.initState();
    // Listen for quiz completion and navigate to result
    ref.listenManual(quizProvider.select((s) => s.result), (previous, next) {
      if (next != null && !_hasNavigatedToResult) {
        _hasNavigatedToResult = true;
        context.pushReplacement('/quiz/result');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final quizState = ref.watch(quizProvider);
    final currentQuestion = ref.watch(currentQuestionProvider);

    if (quizState.session == null || currentQuestion == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final progress =
        (quizState.currentQuestionIndex + 1) / quizState.totalQuestions;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          _showExitConfirmation();
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: AppColors.onSurface),
            onPressed: _showExitConfirmation,
          ),
          title: Column(
            children: [
              Text(
                'Soal ${quizState.currentQuestionIndex + 1} dari ${quizState.totalQuestions}',
                style: const TextStyle(fontSize: 14),
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: AppRadius.chip,
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 4,
                  backgroundColor: AppColors.surfaceVariant,
                  valueColor:
                      const AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ],
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: AppSpacing.screenPadding),
              child: Center(
                child: _TimerBadge(seconds: quizState.timeRemaining),
              ),
            ),
          ],
        ),
        body: SafeArea(
          child: Column(
            children: [
              // Question Card
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.paddingHorizontal,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: AppSpacing.lg),
                      AppCard.elevated(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Difficulty badge
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              decoration: BoxDecoration(
                                color: _getDifficultyColor(
                                        currentQuestion.difficulty)
                                    .withOpacity(0.1),
                                borderRadius: AppRadius.chip,
                              ),
                              child: Text(
                                _getDifficultyLabel(currentQuestion.difficulty),
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: _getDifficultyColor(
                                      currentQuestion.difficulty),
                                ),
                              ),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            // Question text
                            Text(
                              currentQuestion.question,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    height: 1.5,
                                  ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // Answer options
                      ...currentQuestion.options.asMap().entries.map((entry) {
                        final index = entry.key;
                        final option = entry.value;
                        final isSelected =
                            quizState.answers[currentQuestion.id] == index;

                        return Padding(
                          padding: const EdgeInsets.only(bottom: AppSpacing.md),
                          child: AnswerOption(
                            label: String.fromCharCode(65 + index),
                            text: option,
                            state: isSelected
                                ? AnswerOptionState.selected
                                : AnswerOptionState.normal,
                            onTap: () => _selectAnswer(index),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: AppSpacing.lg),
                    ],
                  ),
                ),
              ),

              // Navigation buttons
              Container(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  boxShadow: AppShadows.small,
                ),
                child: SafeArea(
                  child: Row(
                    children: [
                      // Previous button
                      if (!quizState.isFirstQuestion)
                        AppButton.secondary(
                          text: 'Sebelumnya',
                          onPressed: () {
                            ref.read(quizProvider.notifier).previousQuestion();
                          },
                        )
                      else
                        const SizedBox(width: 100),
                      const Spacer(),
                      // Next/Submit button
                      if (quizState.isLastQuestion)
                        AppButton.primary(
                          text: quizState.isSubmitting
                              ? 'Menyimpan...'
                              : 'Selesai',
                          isLoading: quizState.isSubmitting,
                          onPressed:
                              quizState.answeredCount < quizState.totalQuestions
                                  ? () => _showIncompleteWarning()
                                  : () => _submitQuiz(),
                        )
                      else
                        AppButton.primary(
                          text: 'Selanjutnya',
                          onPressed: () {
                            ref.read(quizProvider.notifier).nextQuestion();
                          },
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _selectAnswer(int index) {
    final quizNotifier = ref.read(quizProvider.notifier);
    quizNotifier.answerQuestion(index);

    // Auto-advance after a short delay if not last question
    final quizState = ref.read(quizProvider);
    if (!quizState.isLastQuestion) {
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) {
          quizNotifier.nextQuestion();
        }
      });
    }
  }

  void _showExitConfirmation() {
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
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(quizProvider.notifier).abandonSession();
              if (mounted) {
                context.go('/');
              }
            },
          ),
        ],
      ),
    );
  }

  void _showIncompleteWarning() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Belum Selesai'),
        content: const Text(
          'Kamu belum menjawab semua soal. Yakin ingin menyelesaikan?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Lanjutkan'),
          ),
          AppButton.primary(
            text: 'Selesaikan',
            onPressed: () {
              Navigator.pop(context);
              _submitQuiz();
            },
          ),
        ],
      ),
    );
  }

  Future<void> _submitQuiz() async {
    final success = await ref.read(quizProvider.notifier).submitSession();

    if (success && mounted) {
      context.pushReplacement('/quiz/result');
    }
  }

  Color _getDifficultyColor(int difficulty) {
    if (difficulty <= 2) return AppColors.success;
    if (difficulty == 3) return AppColors.warning;
    return AppColors.error;
  }

  String _getDifficultyLabel(int difficulty) {
    if (difficulty <= 2) return 'Mudah';
    if (difficulty == 3) return 'Sedang';
    return 'Sulit';
  }
}

class _TimerBadge extends StatelessWidget {
  final int seconds;

  const _TimerBadge({required this.seconds});

  @override
  Widget build(BuildContext context) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    final timeString =
        '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';

    // Determine color based on remaining time
    Color color = AppColors.timerNormal;
    if (seconds < 60) {
      color = AppColors.timerCritical;
    } else if (seconds < 180) color = AppColors.timerWarning;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.chip,
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.timer, size: 16, color: color),
          const SizedBox(width: AppSpacing.xs),
          Text(
            timeString,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: color,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
        ],
      ),
    );
  }
}
