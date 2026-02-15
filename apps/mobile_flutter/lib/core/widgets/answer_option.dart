import 'package:flutter/material.dart';

import '../theme/app_animations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';

enum AnswerOptionState {
  normal,
  selected,
  correct,
  wrong,
  disabled,
}

class AnswerOption extends StatelessWidget {
  final String label;
  final String text;
  final AnswerOptionState state;
  final VoidCallback? onTap;
  final bool showIcon;

  const AnswerOption({
    super.key,
    required this.label,
    required this.text,
    this.state = AnswerOptionState.normal,
    this.onTap,
    this.showIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    final style = _getStyle();

    return AnimatedContainer(
      duration: AppAnimations.normal,
      curve: AppAnimations.emphasized,
      decoration: BoxDecoration(
        color: style.backgroundColor,
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: style.borderColor,
          width: state == AnswerOptionState.selected ? 2 : 1.5,
        ),
        boxShadow: style.shadow,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: state == AnswerOptionState.disabled ? null : onTap,
          borderRadius: AppRadius.lgRadius,
          child: Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Row(
              children: [
                // Option label (A, B, C, D)
                AnimatedContainer(
                  duration: AppAnimations.fast,
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: style.labelBackground,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: style.labelBorder,
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      label,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: style.labelColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: AppSpacing.lg),
                // Answer text
                Expanded(
                  child: Text(
                    text,
                    style: TextStyle(
                      fontSize: 16,
                      color: style.textColor,
                      fontWeight: state == AnswerOptionState.selected
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                ),
                // Status icon
                if (showIcon && style.icon != null)
                  AnimatedScale(
                    duration: AppAnimations.fast,
                    scale: state == AnswerOptionState.normal ? 0 : 1,
                    child: Icon(
                      style.icon,
                      color: style.iconColor,
                      size: 24,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _AnswerOptionStyle _getStyle() {
    switch (state) {
      case AnswerOptionState.normal:
        return _AnswerOptionStyle(
          backgroundColor: AppColors.surface,
          borderColor: AppColors.onSurfaceVariant.withOpacity(0.2),
          labelBackground: AppColors.surfaceVariant,
          labelBorder: AppColors.onSurfaceVariant.withOpacity(0.2),
          labelColor: AppColors.onSurface,
          textColor: AppColors.onSurface,
          shadow: AppShadows.none,
        );
      case AnswerOptionState.selected:
        return _AnswerOptionStyle(
          backgroundColor: AppColors.primaryContainer,
          borderColor: AppColors.primary,
          labelBackground: AppColors.primary,
          labelBorder: AppColors.primary,
          labelColor: Colors.white,
          textColor: AppColors.onSurface,
          shadow: AppShadows.primary(AppColors.primary),
        );
      case AnswerOptionState.correct:
        return _AnswerOptionStyle(
          backgroundColor: AppColors.secondaryContainer,
          borderColor: AppColors.success,
          labelBackground: AppColors.success,
          labelBorder: AppColors.success,
          labelColor: Colors.white,
          textColor: AppColors.onSurface,
          icon: Icons.check_circle,
          iconColor: AppColors.success,
          shadow: AppShadows.success,
        );
      case AnswerOptionState.wrong:
        return _AnswerOptionStyle(
          backgroundColor: AppColors.errorContainer,
          borderColor: AppColors.error,
          labelBackground: AppColors.error,
          labelBorder: AppColors.error,
          labelColor: Colors.white,
          textColor: AppColors.onSurface,
          icon: Icons.cancel,
          iconColor: AppColors.error,
          shadow: AppShadows.error,
        );
      case AnswerOptionState.disabled:
        return _AnswerOptionStyle(
          backgroundColor: AppColors.surfaceVariant.withOpacity(0.5),
          borderColor: AppColors.onSurfaceVariant.withOpacity(0.1),
          labelBackground: AppColors.onSurfaceVariant.withOpacity(0.2),
          labelBorder: AppColors.onSurfaceVariant.withOpacity(0.1),
          labelColor: AppColors.onSurfaceVariant.withOpacity(0.5),
          textColor: AppColors.onSurfaceVariant.withOpacity(0.5),
          shadow: AppShadows.none,
        );
    }
  }
}

class _AnswerOptionStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color labelBackground;
  final Color labelBorder;
  final Color labelColor;
  final Color textColor;
  final IconData? icon;
  final Color? iconColor;
  final List<BoxShadow> shadow;

  _AnswerOptionStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.labelBackground,
    required this.labelBorder,
    required this.labelColor,
    required this.textColor,
    this.icon,
    this.iconColor,
    required this.shadow,
  });
}
