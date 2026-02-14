import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/widgets/widgets.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Mock data - will be replaced with actual data in Phase 2
    const totalSessions = 45;
    const totalQuestions = 450;
    const correctAnswers = 380;
    const accuracy = 84.4;
    const currentStreak = 5;
    const longestStreak = 12;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Progress Belajar'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Overall Stats Card
            AppCard.elevated(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ringkasan',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          value: '$totalSessions',
                          label: 'Total Sesi',
                          icon: Icons.assignment_turned_in,
                          color: AppColors.primary,
                        ),
                      ),
                      Expanded(
                        child: _StatItem(
                          value: '$accuracy%',
                          label: 'Akurasi',
                          icon: Icons.trending_up,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    children: [
                      Expanded(
                        child: _StatItem(
                          value: '$correctAnswers',
                          label: 'Jawaban Benar',
                          icon: Icons.check_circle,
                          color: AppColors.info,
                        ),
                      ),
                      Expanded(
                        child: _StatItem(
                          value: '$totalQuestions',
                          label: 'Total Soal',
                          icon: Icons.help_outline,
                          color: AppColors.warning,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Streak Card
            StreakCard(
              currentStreak: currentStreak,
              longestStreak: longestStreak,
            ),
            const SizedBox(height: AppSpacing.xl),
            // Progress by Grade
            Text(
              'Progress per Kelas',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            _GradeProgressCard(
              grade: 5,
              sessions: 30,
              accuracy: 85.2,
              avgScore: 8.5,
              isCurrent: true,
            ),
            const SizedBox(height: AppSpacing.md),
            _GradeProgressCard(
              grade: 4,
              sessions: 15,
              accuracy: 82.0,
              avgScore: 8.2,
              isCurrent: false,
            ),
            const SizedBox(height: AppSpacing.xl),
            // Progress by Topic
            Text(
              'Progress per Topik',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                children: [
                  _TopicProgressTile(
                    topic: 'Penjumlahan',
                    sessions: 10,
                    accuracy: 92,
                    color: AppColors.gradeColors[0],
                  ),
                  const Divider(height: 1),
                  _TopicProgressTile(
                    topic: 'Perkalian',
                    sessions: 8,
                    accuracy: 85,
                    color: AppColors.gradeColors[2],
                  ),
                  const Divider(height: 1),
                  _TopicProgressTile(
                    topic: 'Pecahan',
                    sessions: 6,
                    accuracy: 78,
                    color: AppColors.gradeColors[4],
                  ),
                  const Divider(height: 1),
                  _TopicProgressTile(
                    topic: 'Geometri',
                    sessions: 4,
                    accuracy: 88,
                    color: AppColors.gradeColors[6],
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xl),
            // Recent Sessions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sesi Terakhir',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text('Lihat Semua'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            _RecentSessionCard(
              date: 'Hari ini',
              grade: 5,
              score: 8,
              totalQuestions: 10,
              isToday: true,
            ),
            const SizedBox(height: AppSpacing.md),
            _RecentSessionCard(
              date: 'Kemarin',
              grade: 5,
              score: 9,
              totalQuestions: 10,
              isToday: false,
            ),
            const SizedBox(height: AppSpacing.md),
            _RecentSessionCard(
              date: '2 hari lalu',
              grade: 5,
              score: 7,
              totalQuestions: 10,
              isToday: false,
            ),
            const SizedBox(height: AppSpacing.xl),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  final IconData icon;
  final Color color;

  const _StatItem({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: AppRadius.lgRadius,
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
          ),
        ),
      ],
    );
  }
}

class _GradeProgressCard extends StatelessWidget {
  final int grade;
  final int sessions;
  final double accuracy;
  final double avgScore;
  final bool isCurrent;

  const _GradeProgressCard({
    required this.grade,
    required this.sessions,
    required this.accuracy,
    required this.avgScore,
    required this.isCurrent,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.gradeColors[grade - 1];

    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: isCurrent ? color : color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$grade',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? Colors.white : color,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Kelas $grade',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (isCurrent) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primaryContainer,
                          borderRadius: AppRadius.chip,
                        ),
                        child: const Text(
                          'Aktif',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$sessions sesi • Skor rata-rata $avgScore',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${accuracy.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              SizedBox(
                width: 60,
                child: ClipRRect(
                  borderRadius: AppRadius.chip,
                  child: LinearProgressIndicator(
                    value: accuracy / 100,
                    minHeight: 6,
                    backgroundColor: AppColors.surfaceVariant,
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopicProgressTile extends StatelessWidget {
  final String topic;
  final int sessions;
  final int accuracy;
  final Color color;

  const _TopicProgressTile({
    required this.topic,
    required this.sessions,
    required this.accuracy,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: AppRadius.lgRadius,
            ),
            child: Icon(Icons.calculate, color: color, size: 20),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  topic,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  '$sessions sesi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '$accuracy%',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: accuracy >= 80
                  ? AppColors.success
                  : accuracy >= 60
                      ? AppColors.warning
                      : AppColors.error,
            ),
          ),
        ],
      ),
    );
  }
}

class _RecentSessionCard extends StatelessWidget {
  final String date;
  final int grade;
  final int score;
  final int totalQuestions;
  final bool isToday;

  const _RecentSessionCard({
    required this.date,
    required this.grade,
    required this.score,
    required this.totalQuestions,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.gradeColors[grade - 1];
    final percentage = (score / totalQuestions * 100).round();

    return AppCard(
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
            child: Center(
              child: Text(
                '$grade',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      date,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    if (isToday) ...[
                      const SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.success.withOpacity(0.1),
                          borderRadius: AppRadius.chip,
                        ),
                        child: const Text(
                          'Baru',
                          style: TextStyle(
                            fontSize: 10,
                            color: AppColors.success,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Kelas $grade • $percentage% akurasi',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            decoration: BoxDecoration(
              color: percentage >= 60
                  ? AppColors.success.withOpacity(0.1)
                  : AppColors.error.withOpacity(0.1),
              borderRadius: AppRadius.chip,
            ),
            child: Text(
              '$score/$totalQuestions',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: percentage >= 60 ? AppColors.success : AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
