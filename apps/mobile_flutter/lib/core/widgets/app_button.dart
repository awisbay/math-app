import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_shadows.dart';
import '../theme/app_spacing.dart';
import '../theme/app_animations.dart';

enum AppButtonVariant {
  primary,
  secondary,
  ghost,
  danger,
}

enum AppButtonSize {
  small,
  medium,
  large,
}

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final bool isLoading;
  final bool isFullWidth;
  final Widget? icon;
  final Widget? trailingIcon;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.size = AppButtonSize.medium,
    this.isLoading = false,
    this.isFullWidth = false,
    this.icon,
    this.trailingIcon,
  });

  factory AppButton.primary({
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? icon,
    Widget? trailingIcon,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      trailingIcon: trailingIcon,
    );
  }

  factory AppButton.secondary({
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? icon,
    Widget? trailingIcon,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      trailingIcon: trailingIcon,
    );
  }

  factory AppButton.ghost({
    required String text,
    VoidCallback? onPressed,
    AppButtonSize size = AppButtonSize.medium,
    bool isLoading = false,
    bool isFullWidth = false,
    Widget? icon,
    Widget? trailingIcon,
  }) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      variant: AppButtonVariant.ghost,
      size: size,
      isLoading: isLoading,
      isFullWidth: isFullWidth,
      icon: icon,
      trailingIcon: trailingIcon,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();
    final dimensions = _getDimensions();

    Widget buttonContent = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (isLoading) ...[
          SizedBox(
            width: dimensions.iconSize,
            height: dimensions.iconSize,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
            ),
          ),
          SizedBox(width: dimensions.gap),
        ] else if (icon != null) ...[
          IconTheme(
            data: IconThemeData(
              color: colors.foreground,
              size: dimensions.iconSize,
            ),
            child: icon!,
          ),
          SizedBox(width: dimensions.gap),
        ],
        Text(
          text,
          style: TextStyle(
            color: colors.foreground,
            fontSize: dimensions.fontSize,
            fontWeight: FontWeight.w600,
          ),
        ),
        if (trailingIcon != null) ...[
          SizedBox(width: dimensions.gap),
          IconTheme(
            data: IconThemeData(
              color: colors.foreground,
              size: dimensions.iconSize,
            ),
            child: trailingIcon!,
          ),
        ],
      ],
    );

    final button = AnimatedContainer(
      duration: AppAnimations.fast,
      curve: AppAnimations.emphasized,
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: AppRadius.button,
        border: colors.border != null
            ? Border.all(color: colors.border!, width: 1.5)
            : null,
        boxShadow: onPressed != null && !isLoading ? colors.shadow : AppShadows.none,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: AppRadius.button,
          child: Container(
            width: isFullWidth ? double.infinity : null,
            padding: dimensions.padding,
            child: buttonContent,
          ),
        ),
      ),
    );

    return button;
  }

  _ButtonColors _getColors() {
    final isDisabled = onPressed == null || isLoading;

    switch (variant) {
      case AppButtonVariant.primary:
        return _ButtonColors(
          background: isDisabled ? AppColors.primary.withOpacity(0.5) : AppColors.primary,
          foreground: AppColors.onPrimary,
          shadow: isDisabled ? AppShadows.none : AppShadows.primary(AppColors.primary),
        );
      case AppButtonVariant.secondary:
        return _ButtonColors(
          background: isDisabled ? AppColors.surfaceVariant.withOpacity(0.5) : AppColors.surface,
          foreground: isDisabled ? AppColors.onSurfaceVariant.withOpacity(0.5) : AppColors.primary,
          border: isDisabled ? AppColors.onSurfaceVariant.withOpacity(0.2) : AppColors.primary,
          shadow: AppShadows.none,
        );
      case AppButtonVariant.ghost:
        return _ButtonColors(
          background: Colors.transparent,
          foreground: isDisabled ? AppColors.onSurfaceVariant.withOpacity(0.5) : AppColors.primary,
          shadow: AppShadows.none,
        );
      case AppButtonVariant.danger:
        return _ButtonColors(
          background: isDisabled ? AppColors.error.withOpacity(0.5) : AppColors.error,
          foreground: AppColors.onError,
          shadow: isDisabled ? AppShadows.none : AppShadows.error,
        );
    }
  }

  _ButtonDimensions _getDimensions() {
    switch (size) {
      case AppButtonSize.small:
        return _ButtonDimensions(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
          fontSize: 14,
          iconSize: 16,
          gap: AppSpacing.sm,
        );
      case AppButtonSize.medium:
        return _ButtonDimensions(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          fontSize: 16,
          iconSize: 20,
          gap: AppSpacing.sm,
        );
      case AppButtonSize.large:
        return _ButtonDimensions(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          fontSize: 18,
          iconSize: 24,
          gap: AppSpacing.md,
        );
    }
  }
}

class _ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;
  final List<BoxShadow> shadow;

  _ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
    required this.shadow,
  });
}

class _ButtonDimensions {
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;
  final double gap;

  _ButtonDimensions({
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.gap,
  });
}
