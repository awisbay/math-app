import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

class ResultScreen extends StatelessWidget {
  final String sessionId;

  const ResultScreen({
    super.key,
    required this.sessionId,
  });

  @override
  Widget build(BuildContext context) {
    // Mock result data - will be replaced with actual data in Phase 2
    const score = 8;
    const totalQuestions = 10;
    const correctAnswers = 8;
    const timeSpent = 720; // seconds
    const newStreak = 6;
    const streakIncreased = true;

    final percentage = (correctAnswers / totalQuestions * 100).round();
    final isSuccess = percentage >= 60;

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
                    // Streak notification
                    if (streakIncreased)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.md,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.warning.withOpacity(0.1),
                          borderRadius: AppRadius.lgRadius,
                          border: Border.all(
                            color: AppColors.warning.withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.local_fire_department,
                              color: AppColors.warning,
                            ),
                            const SizedBox(width: AppSpacing.sm),
                            Text(
                              'Streak $newStreak hari!',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.warning,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: AppSpacing.xxl),
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
                                    '$score',
                                    style: TextStyle(
                                      fontSize: 56,
                                      fontWeight: FontWeight.bold,
                                      color: isSuccess
                                          ? AppColors.success
                                          : AppColors.error,
                                    ),
                                  ),
                                  Text(
                                    '/$totalQuestions',
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
                            '$percentage% Benar',
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
                            value: '$correctAnswers',
                            label: 'Benar',
                            color: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.cancel,
                            value: '${totalQuestions - correctAnswers}',
                            label: 'Salah',
                            color: AppColors.error,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _StatCard(
                            icon: Icons.timer,
                            value: '${timeSpent ~/ 60}m',
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
                      onPressed: () => context.pushReplacement('/quiz'),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    AppButton.secondary(
                      text: 'Kembali ke Beranda',
                      isFullWidth: true,
                      onPressed: () => context.go('/'),
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
