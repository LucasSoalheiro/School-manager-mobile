import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../domain/entities/school_class_entity.dart';
import 'student_view_model.dart';

/// Tab that displays the list of classes the student is enrolled in.
///
/// It receives the [StudentViewModel] which already holds the loaded
/// classes in its [_classes] list. The UI simply presents each class as a
/// card with basic information. Tapping a card can be wired to a future
/// detailed screen – for now we just show a toast.
class StudentClassesTab extends StatelessWidget {
  final StudentViewModel viewModel;
  final VoidCallback onRefresh;
  final void Function(SchoolClassEntity) onClassTap;

  const StudentClassesTab({
    super.key,
    required this.viewModel,
    required this.onRefresh,
    required this.onClassTap,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.classes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: () async => viewModel.loadData(),
      child: viewModel.classes.isEmpty
          ? const Center(
              child: Text(
                'Você ainda não está matriculado em nenhuma turma.',
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: viewModel.classes.length,
              itemBuilder: (context, index) {
                final schoolClass = viewModel.classes[index];
                final studentCount = schoolClass.students.length;
                final activityCount = schoolClass.activities.length;
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: Icon(Icons.class_, color: AppColors.primary),
                    title: Text(schoolClass.name),
                    subtitle: Row(
                      children: [
                        Icon(
                          Icons.group,
                          size: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text('$studentCount alunos'),
                        const SizedBox(width: 12),
                        Icon(
                          Icons.assignment,
                          size: 14,
                          color: AppColors.textSecondaryLight,
                        ),
                        const SizedBox(width: 4),
                        Text('$activityCount atividades'),
                      ],
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => onClassTap(schoolClass),
                  ),
                );
              },
            ),
    );
  }
}
