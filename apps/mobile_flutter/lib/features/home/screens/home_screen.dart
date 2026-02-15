import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';
import '../../../providers/auth_provider.dart';
import '../../../providers/quiz_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final quizState = ref.watch(quizProvider);

    if (authState.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // App Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: AppSpacing.lg),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat Datang! 👋',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    color: AppColors.onSurfaceVariant,
                                  ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              user?.name ?? 'Pengguna',
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                        StreakBadge(streak: user?.currentStreak ?? 0),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // Quick Stats Card
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: AppCard.elevated(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _StatItem(
                        icon: Icons.school,
                        value: 'Kelas ${user?.currentGrade ?? 1}',
                        label: 'Saat Ini',
                        color: AppColors.primary,
                      ),
                      _StatItem(
                        icon: Icons.assignment_turned_in,
                        value: '${user?.totalSessions ?? 0}',
                        label: 'Sesi',
                        color: AppColors.success,
                      ),
                      _StatItem(
                        icon: Icons.trending_up,
                        value: '${(user?.accuracy ?? 0).round()}%',
                        label: 'Akurasi',
                        color: AppColors.info,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Current Grade Section
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Kelas Saat Ini',
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        TextButton(
                          onPressed: () => _showGradeSelector(
                              context, ref, user?.currentGrade ?? 1),
                          child: const Text('Ubah'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GradeChip(
                      grade: user?.currentGrade ?? 1,
                      isSelected: true,
                      onTap: () => _showGradeSelector(
                          context, ref, user?.currentGrade ?? 1),
                      showLabel: true,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Start Session Button
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: quizState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : AppButton.primary(
                        text: 'Mulai Latihan',
                        isFullWidth: true,
                        size: AppButtonSize.large,
                        icon: const Icon(Icons.play_arrow),
                        onPressed: () => _startSession(context, ref),
                      ),
              ),
            ),

            if (quizState.errorMessage != null)
              SliverToBoxAdapter(
                child: Padding(
                  padding: AppSpacing.paddingHorizontal,
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        quizState.errorMessage!,
                        style: const TextStyle(color: AppColors.error),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Recent Topics Section
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: Text(
                  'Topik Populer',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // Topics placeholder - will be populated when topics API is available
            SliverPadding(
              padding: AppSpacing.paddingHorizontal,
              sliver: SliverToBoxAdapter(
                child: AppCard(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  child: Column(
                    children: [
                      Icon(
                        Icons.auto_stories,
                        size: 48,
                        color: AppColors.onSurfaceVariant.withOpacity(0.4),
                      ),
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        'Topik akan tampil setelah Anda menyelesaikan latihan pertama',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.onSurfaceVariant,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }

  Future<void> _startSession(BuildContext context, WidgetRef ref) async {
    final success = await ref.read(quizProvider.notifier).startSession();

    if (success && context.mounted) {
      context.push('/quiz');
    }
  }

  void _showGradeSelector(
      BuildContext context, WidgetRef ref, int currentGrade) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => GradeSelectorSheet(
        selectedGrade: currentGrade,
        onGradeSelected: (grade) async {
          Navigator.pop(context);
          if (grade != currentGrade) {
            final success =
                await ref.read(authProvider.notifier).switchGrade(grade);
            if (success && context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Kelas berhasil diubah ke $grade')),
              );
            }
          }
        },
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _StatItem({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: AppSpacing.sm),
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
        ),
      ],
    );
  }
}

class GradeSelectorSheet extends StatefulWidget {
  final int selectedGrade;
  final ValueChanged<int> onGradeSelected;

  const GradeSelectorSheet({
    super.key,
    required this.selectedGrade,
    required this.onGradeSelected,
  });

  @override
  State<GradeSelectorSheet> createState() => _GradeSelectorSheetState();
}

class _GradeSelectorSheetState extends State<GradeSelectorSheet> {
  late int _tempGrade;

  @override
  void initState() {
    super.initState();
    _tempGrade = widget.selectedGrade;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
      ),
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.onSurfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          Text(
            'Pilih Kelas',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Pilih kelas yang sesuai dengan tingkat pendidikanmu',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppSpacing.xl),
          GradeGrid(
            selectedGrade: _tempGrade,
            onGradeSelected: (grade) {
              setState(() => _tempGrade = grade);
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton.primary(
            text: 'Pilih Kelas',
            isFullWidth: true,
            onPressed: () => widget.onGradeSelected(_tempGrade),
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
