import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Mock data - will be replaced with actual providers in Phase 2
    const currentGrade = 5;
    const streak = 5;
    const longestStreak = 12;

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
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'Budi Santoso',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        StreakBadge(streak: streak),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xl),
                  ],
                ),
              ),
            ),

            // Streak Card
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: StreakCard(
                  currentStreak: streak,
                  longestStreak: longestStreak,
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
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _showGradeSelector(context),
                          child: const Text('Ubah'),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.md),
                    GradeChip(
                      grade: currentGrade,
                      isSelected: true,
                      onTap: () => _showGradeSelector(context),
                      showLabel: true,
                    ),
                  ],
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),

            // Topics Section
            SliverToBoxAdapter(
              child: Padding(
                padding: AppSpacing.paddingHorizontal,
                child: Text(
                  'Topik Pembelajaran',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.md)),

            // Topics List
            SliverPadding(
              padding: AppSpacing.paddingHorizontal,
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  TopicCard(
                    title: 'Penjumlahan & Pengurangan',
                    icon: Icons.add,
                    color: AppColors.gradeColors[0],
                    questionCount: 45,
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TopicCard(
                    title: 'Perkalian & Pembagian',
                    icon: Icons.close,
                    color: AppColors.gradeColors[2],
                    questionCount: 32,
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TopicCard(
                    title: 'Pecahan',
                    icon: Icons.pie_chart_outline,
                    color: AppColors.gradeColors[4],
                    questionCount: 28,
                    onTap: () {},
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TopicCard(
                    title: 'Geometri Dasar',
                    icon: Icons.shape_line,
                    color: AppColors.gradeColors[6],
                    questionCount: 20,
                    onTap: () {},
                  ),
                ]),
              ),
            ),

            // Start Button
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.screenPadding),
                child: AppButton.primary(
                  text: 'Mulai Latihan',
                  isFullWidth: true,
                  size: AppButtonSize.large,
                  icon: const Icon(Icons.play_arrow),
                  onPressed: () => context.push('/quiz'),
                ),
              ),
            ),

            const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
          ],
        ),
      ),
    );
  }

  void _showGradeSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GradeSelectorSheet(),
    );
  }
}

class GradeSelectorSheet extends StatefulWidget {
  const GradeSelectorSheet({super.key});

  @override
  State<GradeSelectorSheet> createState() => _GradeSelectorSheetState();
}

class _GradeSelectorSheetState extends State<GradeSelectorSheet> {
  int selectedGrade = 5;

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
            selectedGrade: selectedGrade,
            onGradeSelected: (grade) {
              setState(() {
                selectedGrade = grade;
              });
            },
          ),
          const SizedBox(height: AppSpacing.xl),
          AppButton.primary(
            text: 'Pilih Kelas $selectedGrade',
            isFullWidth: true,
            onPressed: () {
              Navigator.pop(context);
              // TODO: Update grade via provider
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}
