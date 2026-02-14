import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  int _selectedGrade = 5;
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _register() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // TODO: Implement actual registration in Phase 2
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          setState(() => _isLoading = false);
          context.go('/');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daftar'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalLarge,
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: AppSpacing.lg),
                // Title
                Text(
                  'Buat Akun Baru',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Isi data diri kamu untuk mulai belajar',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Name field
                AppTextField.name(
                  controller: _nameController,
                  label: 'Nama Lengkap',
                  hint: 'Masukkan nama lengkap',
                ),
                const SizedBox(height: AppSpacing.lg),
                // Email field
                AppTextField.email(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                ),
                const SizedBox(height: AppSpacing.lg),
                // Password field
                AppTextField.password(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Minimal 6 karakter',
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: AppColors.onSurfaceVariant,
                    ),
                    onPressed: () {
                      setState(() {
                        _obscurePassword = !_obscurePassword;
                      });
                    },
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                // Grade selection
                Text(
                  'Pilih Kelas',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                GradeGrid(
                  selectedGrade: _selectedGrade,
                  onGradeSelected: (grade) {
                    setState(() {
                      _selectedGrade = grade;
                    });
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                // Terms checkbox
                Row(
                  children: [
                    Checkbox(
                      value: true,
                      onChanged: (value) {},
                    ),
                    Expanded(
                      child: Text(
                        'Saya menyetujui Syarat dan Ketentuan serta Kebijakan Privasi',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                // Register Button
                AppButton.primary(
                  text: 'Daftar',
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  isLoading: _isLoading,
                  onPressed: _register,
                ),
                const SizedBox(height: AppSpacing.lg),
                // Login link
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Sudah punya akun? ',
                        style: TextStyle(
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      TextButton(
                        onPressed: () => context.pop(),
                        child: const Text('Masuk'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
