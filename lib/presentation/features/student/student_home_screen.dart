import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

import 'student_dashboard_tab.dart';
import 'student_classes_tab.dart';
import 'student_activities_tab.dart';
import 'student_grades_tab.dart';
import 'student_view_model.dart';
import '../../../core/di/service_locator.dart';

import '../profile/profile_screen.dart';

/// Bottom navigation screen for the student role.
///
/// It creates the [StudentViewModel] using the [ServiceLocator] and
/// provides five tabs: Dashboard, Turmas, Atividades, Boletim and Perfil.
class StudentHomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const StudentHomeScreen({super.key, required this.onLogout});

  @override
  State<StudentHomeScreen> createState() => _StudentHomeScreenState();
}

class _StudentHomeScreenState extends State<StudentHomeScreen> {
  late final StudentViewModel _viewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final studentId = ServiceLocator.sessionStorage.getUserId()!;
    _viewModel = StudentViewModel(
      studentId: studentId,
      schoolClassRepository: ServiceLocator.schoolClassRepository,
      gradeRepository: ServiceLocator.gradeRepository,
    );
    // Load data initially
    _viewModel.loadData();
  }

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  List<Widget> get _tabs => [
    StudentDashboardTab(
      viewModel: _viewModel,
      onTabChange: (i) => _onTabChanged(i + 1),
    ),
    StudentClassesTab(
      viewModel: _viewModel,
      onRefresh: _viewModel.loadData,
      onClassTap: (_) {},
    ),
    StudentActivitiesTab(viewModel: _viewModel, onRefresh: _viewModel.loadData),
    StudentGradesTab(viewModel: _viewModel, onRefresh: _viewModel.loadData),
    ProfileScreen(onLogout: widget.onLogout),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textSecondaryLight,
        onTap: _onTabChanged,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_rounded),
            label: 'Início',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.meeting_room_rounded),
            label: 'Turmas',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_rounded),
            label: 'Atividades',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school_rounded),
            label: 'Boletim',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_rounded),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}
