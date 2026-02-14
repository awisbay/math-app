import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

/// A badge displaying the user's current streak.
class StreakBadge extends StatelessWidget {
  final int streak;
  final bool isActive;
  final VoidCallback? onTap;
  final bool showLabel;

  const StreakBadge({
    super.key,
    required this.streak,
    this.isActive = true,
    this.onTap,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = isActive ? AppColors.warning : AppColors.onSurfaceVariant;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: isActive ? color.withOpacity(0.1) : AppColors.surfaceVariant,
          borderRadius: AppRadius.chip,
          border: Border.all(
            color: isActive ? color.withOpacity(0.3) : Colors.transparent,
          ),
          boxShadow: isActive ? AppShadows.small : AppShadows.none,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.local_fire_department,
              size: 20,
              color: color,
            ),
            const SizedBox(width: AppSpacing.xs),
            Text(
              '$streak',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            if (showLabel) ...[
              const SizedBox(width: AppSpacing.xs),
              Text(
                'hari',
                style: TextStyle(
                  fontSize: 12,
                  color: color.withOpacity(0.8),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// A widget displaying streak information in a card format.
class StreakCard extends StatelessWidget {
  final int currentStreak;
  final int longestStreak;
  final VoidCallback? onTap;

  const StreakCard({
    super.key,
    required this.currentStreak,
    required this.longestStreak,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.warning.withOpacity(0.2),
            AppColors.warning.withOpacity(0.05),
          ],
        ),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(color: AppColors.warning.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: AppColors.warning.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              color: AppColors.warning,
              size: 32,
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Streak Hari Ini',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Row(
                  children: [
                    Text(
                      '$currentStreak',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: AppColors.warning,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    const Text(
                      'hari',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Terpanjang: $longestStreak hari',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
