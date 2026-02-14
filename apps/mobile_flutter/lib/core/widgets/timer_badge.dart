import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// A badge widget for displaying countdown timer.
class TimerBadge extends StatelessWidget {
  final int secondsRemaining;
  final int totalSeconds;
  final bool showProgress;
  final VoidCallback? onTap;

  const TimerBadge({
    super.key,
    required this.secondsRemaining,
    this.totalSeconds = 900, // 15 minutes default
    this.showProgress = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final progress = secondsRemaining / totalSeconds;
    final color = _getColor(progress);
    final timeString = _formatTime(secondsRemaining);

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Icon(
              Icons.timer,
              size: 18,
              color: color,
            ),
            const SizedBox(width: AppSpacing.sm),
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
      ),
    );
  }

  Color _getColor(double progress) {
    if (progress > 0.5) return AppColors.timerNormal;
    if (progress > 0.25) return AppColors.timerWarning;
    return AppColors.timerCritical;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}

/// A linear progress indicator for quiz progress.
class QuizProgressBar extends StatelessWidget {
  final int currentQuestion;
  final int totalQuestions;
  final double? value;

  const QuizProgressBar({
    super.key,
    required this.currentQuestion,
    required this.totalQuestions,
    this.value,
  });

  @override
  Widget build(BuildContext context) {
    final progress = value ?? currentQuestion / totalQuestions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Soal $currentQuestion dari $totalQuestions',
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            Text(
              '${(progress * 100).toInt()}%',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.sm),
        ClipRRect(
          borderRadius: AppRadius.chip,
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
          ),
        ),
      ],
    );
  }
}

/// A circular countdown timer for quiz sessions.
class CircularTimer extends StatelessWidget {
  final int secondsRemaining;
  final int totalSeconds;
  final double size;

  const CircularTimer({
    super.key,
    required this.secondsRemaining,
    required this.totalSeconds,
    this.size = 64,
  });

  @override
  Widget build(BuildContext context) {
    final progress = secondsRemaining / totalSeconds;
    final color = _getColor(progress);
    final timeString = _formatTime(secondsRemaining);

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CircularProgressIndicator(
            value: progress,
            strokeWidth: 4,
            backgroundColor: AppColors.surfaceVariant,
            valueColor: AlwaysStoppedAnimation<Color>(color),
          ),
          Center(
            child: Text(
              timeString,
              style: TextStyle(
                fontSize: size * 0.25,
                fontWeight: FontWeight.bold,
                color: color,
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getColor(double progress) {
    if (progress > 0.5) return AppColors.timerNormal;
    if (progress > 0.25) return AppColors.timerWarning;
    return AppColors.timerCritical;
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }
}
