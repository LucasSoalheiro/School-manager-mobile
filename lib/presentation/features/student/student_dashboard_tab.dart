import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/stat_card.dart';
import '../../core/widgets/status_badge.dart';
import 'student_view_model.dart';

class StudentDashboardTab extends StatelessWidget {
  final StudentViewModel viewModel;
  final Function(int) onTabChange;

  const StudentDashboardTab({
    super.key,
    required this.viewModel,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    if (viewModel.isLoading && viewModel.classes.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return RefreshIndicator(
      onRefresh: viewModel.loadData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Banner de boas-vindas
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryDark],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
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
                        child: const Icon(Icons.school_rounded, color: Colors.white, size: 24),
                      ),
                      const SizedBox(width: 12),
                      const Text(
                        'Espaço do Aluno',
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
                    'Seja bem-vindo(a)!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'Acompanhe seus prazos, entregas e notas em tempo real.',
                    style: TextStyle(color: Colors.white, fontSize: 13),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Métricas Rápidas
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Turmas Ativas',
                    value: '${viewModel.totalClasses}',
                    icon: Icons.meeting_room_outlined,
                    accentColor: AppColors.primary,
                    onTap: () => onTabChange(1),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    title: 'A Fazer',
                    value: '${viewModel.pendingActivitiesCount}',
                    icon: Icons.pending_actions_rounded,
                    accentColor: AppColors.warning,
                    onTap: () => onTabChange(2),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            StatCard(
              title: 'Média de Notas das Avaliações',
              value: viewModel.averageScore > 0
                  ? viewModel.averageScore.toStringAsFixed(1)
                  : '--',
              icon: Icons.stars_rounded,
              accentColor: viewModel.averageScore >= 7
                  ? AppColors.success
                  : (viewModel.averageScore >= 5 ? AppColors.warning : AppColors.error),
              onTap: () => onTabChange(3),
            ),
            const SizedBox(height: 24),

            // Cabeçalho de Próximas Atividades
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Próximas Atividades',
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

            // Lista das próximas atividades
            if (viewModel.allActivities.isEmpty)
              const EmptyState(
                icon: Icons.assignment_turned_in_outlined,
                title: 'Nenhuma atividade no momento',
                message: 'Parabéns! Você não tem atividades ou turmas pendentes no momento.',
              )
            else
              ...viewModel.allActivities.take(3).map((activity) {
                final grade = viewModel.getGradeForActivity(activity.id);
                final status = grade?.status ?? 'pending';

                return Card(
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.description_outlined, color: AppColors.primary),
                    ),
                    title: Text(
                      activity.title,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        Text(
                          activity.description,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.event_outlined, size: 14, color: AppColors.textSecondaryLight),
                            const SizedBox(width: 4),
                            Text(
                              DateFormatter.getRelativeDeadline(activity.deliveryDate),
                              style: TextStyle(
                                fontSize: 12,
                                color: DateFormatter.isPast(activity.deliveryDate)
                                    ? AppColors.error
                                    : AppColors.textSecondaryLight,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    trailing: StatusBadge.fromStatus(status),
                  ),
                );
              }),
          ],
        ),
      ),
    );
  }
}
