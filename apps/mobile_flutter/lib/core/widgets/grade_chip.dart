import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';

/// A chip component for displaying grade selection.
class GradeChip extends StatelessWidget {
  final int grade;
  final bool isSelected;
  final VoidCallback? onTap;
  final bool showLabel;

  const GradeChip({
    super.key,
    required this.grade,
    this.isSelected = false,
    this.onTap,
    this.showLabel = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.gradeColors[grade - 1];
    final label = _getGradeLabel(grade);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? color : color.withOpacity(0.1),
        borderRadius: AppRadius.chip,
        border: Border.all(
          color: isSelected ? color : color.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.chip,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : color,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '$grade',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? color : Colors.white,
                      ),
                    ),
                  ),
                ),
                if (showLabel) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : color,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getGradeLabel(int grade) {
    if (grade <= 6) return 'SD';
    if (grade <= 9) return 'SMP';
    return 'SMA';
  }
}

/// A horizontal scrollable list of grade chips.
class GradeChipList extends StatelessWidget {
  final int selectedGrade;
  final ValueChanged<int> onGradeSelected;
  final bool showAllGrades;

  const GradeChipList({
    super.key,
    required this.selectedGrade,
    required this.onGradeSelected,
    this.showAllGrades = false,
  });

  @override
  Widget build(BuildContext context) {
    final grades = showAllGrades
        ? List.generate(12, (i) => i + 1)
        : [selectedGrade];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
      child: Row(
        children: grades.map((grade) {
          return Padding(
            padding: const EdgeInsets.only(right: AppSpacing.sm),
            child: GradeChip(
              grade: grade,
              isSelected: grade == selectedGrade,
              onTap: () => onGradeSelected(grade),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// A grid of grade cards for grade selection screen.
class GradeGrid extends StatelessWidget {
  final int selectedGrade;
  final ValueChanged<int> onGradeSelected;

  const GradeGrid({
    super.key,
    required this.selectedGrade,
    required this.onGradeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        crossAxisSpacing: AppSpacing.md,
        mainAxisSpacing: AppSpacing.md,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        final grade = index + 1;
        return _GradeGridItem(
          grade: grade,
          isSelected: grade == selectedGrade,
          onTap: () => onGradeSelected(grade),
        );
      },
    );
  }
}

class _GradeGridItem extends StatelessWidget {
  final int grade;
  final bool isSelected;
  final VoidCallback onTap;

  const _GradeGridItem({
    required this.grade,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = AppColors.gradeColors[grade - 1];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeInOut,
      decoration: BoxDecoration(
        color: isSelected ? color : color.withOpacity(0.1),
        borderRadius: AppRadius.lgRadius,
        border: Border.all(
          color: isSelected ? color : color.withOpacity(0.3),
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: AppRadius.lgRadius,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$grade',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : color,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                _getLevelLabel(grade),
                style: TextStyle(
                  fontSize: 12,
                  color: isSelected
                      ? Colors.white.withOpacity(0.8)
                      : AppColors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getLevelLabel(int grade) {
    if (grade <= 6) return 'SD';
    if (grade <= 9) return 'SMP';
    return 'SMA';
  }
}
