import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

class AppTextField extends StatelessWidget {
  final String? label;
  final String? hint;
  final String? errorText;
  final TextEditingController? controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool enabled;
  final int? maxLines;
  final int? minLines;
  final int? maxLength;
  final Widget? prefix;
  final Widget? suffix;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final AutovalidateMode autovalidateMode;

  const AppTextField({
    super.key,
    this.label,
    this.hint,
    this.errorText,
    this.controller,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
    this.maxLength,
    this.prefix,
    this.suffix,
    this.onTap,
    this.onChanged,
    this.validator,
    this.autovalidateMode = AutovalidateMode.onUserInteraction,
  });

  factory AppTextField.email({
    TextEditingController? controller,
    String? label,
    String? hint,
    bool enabled = true,
    FormFieldValidator<String>? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'Email',
      hint: hint ?? 'Masukkan email Anda',
      keyboardType: TextInputType.emailAddress,
      enabled: enabled,
      validator: validator,
      prefix: const Icon(Icons.email_outlined, size: 20),
    );
  }

  factory AppTextField.password({
    TextEditingController? controller,
    String? label,
    String? hint,
    bool enabled = true,
    FormFieldValidator<String>? validator,
    Widget? suffix,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'Password',
      hint: hint ?? 'Masukkan password Anda',
      keyboardType: TextInputType.visiblePassword,
      obscureText: true,
      enabled: enabled,
      validator: validator,
      prefix: const Icon(Icons.lock_outlined, size: 20),
      suffix: suffix,
    );
  }

  factory AppTextField.name({
    TextEditingController? controller,
    String? label,
    String? hint,
    bool enabled = true,
    FormFieldValidator<String>? validator,
  }) {
    return AppTextField(
      controller: controller,
      label: label ?? 'Nama',
      hint: hint ?? 'Masukkan nama Anda',
      keyboardType: TextInputType.name,
      enabled: enabled,
      validator: validator,
      prefix: const Icon(Icons.person_outlined, size: 20),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
        ],
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          enabled: enabled,
          maxLines: maxLines,
          minLines: minLines,
          maxLength: maxLength,
          onTap: onTap,
          onChanged: onChanged,
          validator: validator,
          autovalidateMode: autovalidateMode,
          style: TextStyle(
            fontSize: 16,
            color: enabled ? AppColors.onSurface : AppColors.onSurfaceVariant,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 16,
              color: AppColors.onSurfaceVariant.withOpacity(0.5),
            ),
            errorText: errorText,
            prefixIcon: prefix != null
                ? Padding(
                    padding: const EdgeInsets.only(left: AppSpacing.md, right: AppSpacing.sm),
                    child: IconTheme(
                      data: const IconThemeData(
                        color: AppColors.onSurfaceVariant,
                        size: 20,
                      ),
                      child: prefix!,
                    ),
                  )
                : null,
            suffixIcon: suffix != null
                ? Padding(
                    padding: const EdgeInsets.only(right: AppSpacing.md),
                    child: suffix,
                  )
                : null,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.lg,
            ),
          ),
        ),
      ],
    );
  }
}
