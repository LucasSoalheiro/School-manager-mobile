import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/utils/date_formatter.dart';
import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/grade_entity.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/empty_state.dart';
import 'student_view_model.dart';

/// Tab that displays the student's activities grouped by status.
///
/// The view model provides the list of all activities and the grades for each.
/// We derive the status from the grade (if any) and render three sub‑tabs:
///   * "A Fazer"   – activities with a pending grade.
///   * "Entregues" – activities with a submitted grade awaiting grading.
///   * "Avaliadas" – activities already graded.
///
/// The UI uses a `TabBar` + `TabBarView`. Each activity is shown as a
/// `ListTile` with an icon, title, deadline and a `StatusBadge`. For pending
/// activities we also show a button to submit the activity, which calls
/// `viewModel.submitActivity(gradeId)`.
class StudentActivitiesTab extends StatefulWidget {
  final StudentViewModel viewModel;
  final VoidCallback onRefresh;

  const StudentActivitiesTab({
    super.key,
    required this.viewModel,
    required this.onRefresh,
  });

  @override
  State<StudentActivitiesTab> createState() => _StudentActivitiesTabState();
}

class _StudentActivitiesTabState extends State<StudentActivitiesTab>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  /// Helper to resolve the grade belonging to an activity.
  GradeEntity? _gradeForActivity(String activityId) =>
      widget.viewModel.getGradeForActivity(activityId);

  /// Returns a filtered list of activities for the given status.
  List<ActivityEntity> _activitiesForStatus(String status) {
    final all = widget.viewModel.allActivities;
    return all.where((activity) {
      final grade = _gradeForActivity(activity.id);
      if (grade == null) return status == 'pending';
      if (status == 'pending') return grade.isPending;
      if (status == 'submitted') return grade.isSubmitted && !grade.isGraded;
      if (status == 'graded') return grade.isGraded;
      return false;
    }).toList();
  }

  Widget _buildActivityList(String status) {
    final activities = _activitiesForStatus(status);
    if (activities.isEmpty) {
      return Center(
        child: EmptyState(
          icon: Icons.assignment_outlined,
          title: 'Nenhuma atividade $status',
          message: 'Você não possui atividades neste estado.',
        ),
      );
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final grade = _gradeForActivity(activity.id);
        final badgeStatus = grade?.status ?? 'pending';
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading: Icon(Icons.description, color: AppColors.primary),
            title: Text(
              activity.title,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            subtitle: Text(
              DateFormatter.getRelativeDeadline(activity.deliveryDate),
              style: TextStyle(
                color: DateFormatter.isPast(activity.deliveryDate)
                    ? AppColors.error
                    : AppColors.textSecondaryLight,
                fontSize: 12,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                StatusBadge.fromStatus(badgeStatus),
                if (status == 'pending')
                  IconButton(
                    icon: Icon(Icons.upload, color: AppColors.success),
                    tooltip: 'Entregar',
                    onPressed: () async {
                      final success = await widget.viewModel.submitActivity(
                        grade!.id,
                      );
                      if (success && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Atividade entregue')),
                        );
                        widget.onRefresh();
                      }
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if (widget.viewModel.isLoading && widget.viewModel.allActivities.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return RefreshIndicator(
      onRefresh: () async => widget.viewModel.loadData(),
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondaryLight,
            indicatorColor: AppColors.primary,
            tabs: const [
              Tab(text: 'A Fazer'),
              Tab(text: 'Entregues'),
              Tab(text: 'Avaliadas'),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildActivityList('pending'),
                _buildActivityList('submitted'),
                _buildActivityList('graded'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
