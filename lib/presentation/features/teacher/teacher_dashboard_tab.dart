import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/stat_card.dart';
import '../teacher/teacher_view_model.dart';

class TeacherDashboardTab extends StatelessWidget {
  final TeacherViewModel viewModel;
  final Function(int) onTabChange;

  const TeacherDashboardTab({
    super.key,
    required this.viewModel,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.classes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final totalClasses = viewModel.classes.length;
    final totalPendingGrading = viewModel.pendingGrades.length;
    int totalStudents = 0;
    for (final c in viewModel.classes) {
      totalStudents += c.students.length;
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner do Professor
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.secondary, Color(0xFF0F766E)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.secondary.withValues(alpha: 0.3),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.cast_for_education_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Portal do Docente',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  const Text(
                    'Painel de Gestão',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Gerencie turmas, crie atividades e lance notas com facilidade.',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Métricas
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Minhas Turmas',
                    value: '$totalClasses',
                    icon: Icons.meeting_room_outlined,
                    accentColor: AppColors.primary,
                    onTap: () => onTabChange(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'Aguardando Nota',
                    value: '$totalPendingGrading',
                    icon: Icons.assignment_late_outlined,
                    accentColor: totalPendingGrading > 0
                        ? AppColors.warning
                        : AppColors.success,
                    onTap: () => onTabChange(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StatCard(
              title: 'Total de Alunos Matriculados',
              value: '$totalStudents',
              icon: Icons.people_alt_outlined,
              accentColor: AppColors.accent,
              onTap: () => onTabChange(1),
            ),
            const SizedBox(height: 24),

            // Entregas recentes pendentes de correção
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Entregas para Avaliar',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.3,
                  ),
                ),
                TextButton(
                  onPressed: () => onTabChange(2),
                  child: const Text('Ver todas'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (viewModel.pendingGrades.isEmpty)
              const EmptyState(
                icon: Icons.task_alt_rounded,
                title: 'Tudo em dia!',
                message:
                    'Você não tem atividades aguardando correção no momento.',
              )
            else
              ...viewModel.pendingGrades.take(3).map((grade) {
                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.warning.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.rate_review_outlined,
                        color: AppColors.warning,
                      ),
                    ),
                    title: Text(
                      'Submissão #${grade.id.length > 8 ? grade.id.substring(0, 8) : grade.id}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                    subtitle: Text('ID do Aluno: ${grade.studentId}'),
                    trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                    onTap: () => onTabChange(2),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
