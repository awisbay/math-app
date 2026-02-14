import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../providers/quiz_provider.dart';

class ResultScreen extends ConsumerWidget {
  const ResultScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quizState = ref.watch(quizProvider);
    final result = quizState.result;

    if (result == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final isSuccess = result.percentage >= 60;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingHorizontalLarge,
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    // Result Icon
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: isSuccess
                            ? AppColors.success.withOpacity(0.1)
                            : AppColors.error.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        isSuccess ? Icons.emoji_events : Icons.refresh,
                        size: 64,
                        color: isSuccess ? AppColors.success : AppColors.error,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Result Title
                    Text(
                      isSuccess ? 'Hebat!' : 'Terus Berlatih!',
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      isSuccess
                          ? 'Kamu telah menyelesaikan quiz dengan baik'
                          : 'Jangan menyerah, coba lagi untuk hasil yang lebih baik',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Score Card
                    AppCard.result(
                      isSuccess: isSuccess,
                      padding: const EdgeInsets.all(AppSpacing.xl),
                      child: Column(
                        children: [
                          // Score Circle
                          Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSuccess
                                    ? AppColors.success
                                    : AppColors.error,
                                width: 8,
                              ),
                            ),
                            child: Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    '${result.score}',
                                    style: TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.bold,
                                      color: isSuccess
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                                  Text(
                                    '/${result.totalQuestions}',
                                    style: TextStyle(
                                      fontSize: 24,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: AppSpacing.lg),
                          Text(
                            '${result.percentage}% Benar',
                            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Stats Grid
                    Row(
                      children: [
                        Expanded(
                          child: _StatCard(
                            icon: Icons.check_circle,
                            value: '${result.correctAnswers}',
                            label: 'Benar',
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.cancel,
                            value: '${result.totalQuestions - result.correctAnswers}',
                            label: 'Salah',
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.timer,
                            value: '${(result.timeSpent / 60).ceil()}m',
                            label: 'Waktu',
                            color: AppColors.info,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    // Action Buttons
                    AppButton.primary(
                      text: 'Latihan Lagi',
                      isFullWidth: true,
                      size: AppButtonSize.large,
                      icon: const Icon(Icons.refresh),
                      onPressed: () async {
                        ref.read(quizProvider.notifier).reset();
                        final success = await ref.read(quizProvider.notifier).startSession();
                        if (success && context.mounted) {
                          context.pushReplacement('/quiz');
                        }
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton.secondary(
                      text: 'Kembali ke Beranda',
                      isFullWidth: true,
                      onPressed: () {
                        ref.read(quizProvider.notifier).reset();
                        context.go('/');
                      },
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: AppRadius.lgRadius,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: AppSpacing.sm),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
            ),
          ),
        ],
      ),
    );
  }
}
