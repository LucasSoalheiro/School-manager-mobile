import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/status_badge.dart';
import 'student_view_model.dart';
import '../../../domain/entities/grade_entity.dart';

/// Tab that shows the student's grade history (boletim).
///
/// It lists all grades with their score, status and submission date.
/// The UI groups grades by class for easier navigation.
class StudentGradesTab extends StatelessWidget {
  final StudentViewModel viewModel;
  final VoidCallback onRefresh;

  const StudentGradesTab({
    super.key,
    required this.viewModel,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.grades.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final grades = viewModel.grades;
    if (grades.isEmpty) {
      return const Center(
        child: EmptyState(
          icon: Icons.school_outlined,
          title: 'Nenhum registro de notas',
          message: 'Ainda não há notas lançadas para você.',
        ),
      );
    }

    // Group grades by class name (if available)
    final gradesByClass = <String, List<GradeEntity>>{};
    for (final grade in grades) {
      final className = grade.schoolClass?.name ?? 'Turma desconhecida';
      gradesByClass.putIfAbsent(className, () => []).add(grade);
    }

    return RefreshIndicator(
      onRefresh: () async => viewModel.loadData(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: gradesByClass.keys.length,
        itemBuilder: (context, index) {
          final className = gradesByClass.keys.elementAt(index);
          final classGrades = gradesByClass[className]!;
          return ExpansionTile(
            title: Text(
              className,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            children: classGrades.map((grade) {
              final date = grade.submittedAt != null
                  ? DateFormatter.formatDate(grade.submittedAt!)
                  : '-';
              final score = grade.isGraded && grade.score != null
                  ? grade.score!.toStringAsFixed(1)
                  : '--';
              return ListTile(
                leading: Icon(Icons.assignment, color: AppColors.primary),
                title: Text('Atividade: ${grade.activity?.title ?? '---'}'),
                subtitle: Text('Data: $date'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    StatusBadge.fromStatus(grade.status),
                    const SizedBox(width: 8),
                    Text(
                      score,
                      style: TextStyle(
                        color: grade.isGraded
                            ? AppColors.success
                            : AppColors.textSecondaryLight,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
