import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

enum AppCardVariant {
  default_,
  elevated,
  outlined,
  highlighted,
  resultSuccess,
  resultFailure,
}

class AppCard extends StatelessWidget {
  final Widget child;
  final AppCardVariant variant;
  final EdgeInsets? padding;
  final VoidCallback? onTap;
  final Widget? header;
  final Widget? footer;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.default_,
    this.padding,
    this.onTap,
    this.header,
    this.footer,
  });

  factory AppCard.elevated({
    required Widget child,
    EdgeInsets? padding,
    VoidCallback? onTap,
    Widget? header,
    Widget? footer,
  }) {
    return AppCard(
      child: child,
      variant: AppCardVariant.elevated,
      padding: padding,
      onTap: onTap,
      header: header,
      footer: footer,
    );
  }

  factory AppCard.highlighted({
    required Widget child,
    EdgeInsets? padding,
    VoidCallback? onTap,
    Widget? header,
    Widget? footer,
  }) {
    return AppCard(
      child: child,
      variant: AppCardVariant.highlighted,
      padding: padding,
      onTap: onTap,
      header: header,
      footer: footer,
    );
  }

  factory AppCard.result({
    required Widget child,
    required bool isSuccess,
    EdgeInsets? padding,
    Widget? header,
    Widget? footer,
  }) {
    return AppCard(
      child: child,
      variant: isSuccess ? AppCardVariant.resultSuccess : AppCardVariant.resultFailure,
      padding: padding,
      header: header,
      footer: footer,
    );
  }

  @override
  Widget build(BuildContext context) {
    final style = _getStyle();
    final defaultPadding = padding ?? const EdgeInsets.all(AppSpacing.lg);

    Widget content = Container(
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: AppRadius.card,
        border: style.border,
        boxShadow: style.shadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (header != null)
            Padding(
              padding: defaultPadding.copyWith(bottom: AppSpacing.sm),
              child: header!,
            ),
          Padding(
            padding: header != null
                ? defaultPadding.copyWith(top: 0)
                : footer != null
                    ? defaultPadding.copyWith(bottom: 0)
                    : defaultPadding,
            child: child,
          ),
          if (footer != null)
            Padding(
              padding: defaultPadding.copyWith(top: AppSpacing.sm),
              child: footer!,
            ),
        ],
      ),
    );

    if (onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.card,
          child: content,
        ),
      );
    }

    return content;
  }

  _CardStyle _getStyle() {
    switch (variant) {
      case AppCardVariant.default_:
        return _CardStyle(
          backgroundColor: AppColors.surface,
          shadow: AppShadows.none,
        );
      case AppCardVariant.elevated:
        return _CardStyle(
          backgroundColor: AppColors.surface,
          shadow: AppShadows.medium,
        );
      case AppCardVariant.outlined:
        return _CardStyle(
          backgroundColor: AppColors.surface,
          border: Border.all(color: AppColors.onSurfaceVariant.withOpacity(0.2)),
          shadow: AppShadows.none,
        );
      case AppCardVariant.highlighted:
        return _CardStyle(
          backgroundColor: AppColors.primaryContainer,
          border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          shadow: AppShadows.small,
        );
      case AppCardVariant.resultSuccess:
        return _CardStyle(
          backgroundColor: AppColors.secondaryContainer,
          border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
          shadow: AppShadows.success,
        );
      case AppCardVariant.resultFailure:
        return _CardStyle(
          backgroundColor: AppColors.errorContainer,
          border: Border.all(color: AppColors.error.withOpacity(0.3)),
          shadow: AppShadows.error,
        );
    }
  }
}

class _CardStyle {
  final Color backgroundColor;
  final Border? border;
  final List<BoxShadow> shadow;

  _CardStyle({
    required this.backgroundColor,
    this.border,
    required this.shadow,
  });
}

/// A specialized card for displaying grade information
class GradeCard extends StatelessWidget {
  final int grade;
  final bool isSelected;
  final VoidCallback? onTap;
  final String? subtitle;

  const GradeCard({
    super.key,
    required this.grade,
    this.isSelected = false,
    this.onTap,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.gradeColors[grade - 1];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? color : AppColors.surface,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: isSelected ? color : color.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
        boxShadow: isSelected ? AppShadows.primary(color) : AppShadows.none,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgRadius,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.lg,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '$grade',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
                if (subtitle != null)
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected
                          ? Colors.white.withOpacity(0.8)
                          : AppColors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A specialized card for displaying topic/category
class TopicCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;
  final int? questionCount;
  final VoidCallback? onTap;

  const TopicCard({
    super.key,
    required this.title,
    required this.icon,
    required this.color,
    this.questionCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      onTap: onTap,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: AppRadius.lgRadius,
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.onSurface,
                  ),
                ),
                if (questionCount != null)
                  Text(
                    '$questionCount soal',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right,
            color: AppColors.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
