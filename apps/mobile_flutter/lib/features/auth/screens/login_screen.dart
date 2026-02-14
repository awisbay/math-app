import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      // TODO: Implement actual login in Phase 2
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
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.paddingHorizontalLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.xxl),
              // Logo/Icon
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.calculate,
                    size: 50,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Title
              Center(
                child: Text(
                  'Selamat Datang!',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Center(
                child: Text(
                  'Masuk untuk melanjutkan belajar matematika',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    AppTextField.email(
                      controller: _emailController,
                      label: 'Email',
                      hint: 'Masukkan email Anda',
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    AppTextField.password(
                      controller: _passwordController,
                      label: 'Password',
                      hint: 'Masukkan password Anda',
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
                    const SizedBox(height: AppSpacing.md),
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {},
                        child: const Text('Lupa Password?'),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    // Login Button
                    AppButton.primary(
                      text: 'Masuk',
                      isFullWidth: true,
                      size: AppButtonSize.large,
                      isLoading: _isLoading,
                      onPressed: _login,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
              // Divider
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: AppColors.onSurfaceVariant.withOpacity(0.3),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                    child: Text(
                      'atau',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: AppColors.onSurfaceVariant.withOpacity(0.3),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),
              // Google Sign In Button
              AppButton.secondary(
                text: 'Masuk dengan Google',
                isFullWidth: true,
                icon: const Icon(Icons.g_mobiledata, size: 24),
                onPressed: () {
                  // TODO: Implement Google Sign In
                },
              ),
              const SizedBox(height: AppSpacing.xxl),
              // Register link
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: TextStyle(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    TextButton(
                      onPressed: () => context.push('/register'),
                      child: const Text('Daftar'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
