import 'package:flutter/material.dart';

import '../../../core/di/service_locator.dart';
import '../../../core/theme/app_theme.dart';
import '../profile/profile_screen.dart';
import 'teacher_classes_tab.dart';
import 'teacher_dashboard_tab.dart';
import 'teacher_grading_tab.dart';
import 'teacher_view_model.dart';

class TeacherHomeScreen extends StatefulWidget {
  final VoidCallback onLogout;

  const TeacherHomeScreen({super.key, required this.onLogout});

  @override
  State<TeacherHomeScreen> createState() => _TeacherHomeScreenState();
}

class _TeacherHomeScreenState extends State<TeacherHomeScreen> {
  late final TeacherViewModel _viewModel;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _viewModel = TeacherViewModel(
      schoolClassRepository: ServiceLocator.schoolClassRepository,
      activityRepository: ServiceLocator.activityRepository,
      gradeRepository: ServiceLocator.gradeRepository,
    );
    _viewModel.loadData();
  }

  void _onTabChanged(int index) {
    setState(() => _selectedIndex = index);
  }

  List<Widget> get _tabs => [
    TeacherDashboardTab(
      viewModel: _viewModel,
      onTabChange: (i) => _onTabChanged(i),
    ),
    TeacherClassesTab(viewModel: _viewModel),
    TeacherGradingTab(viewModel: _viewModel),
    ProfileScreen(onLogout: widget.onLogout),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.secondary,
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
            icon: Icon(Icons.fact_check_rounded),
            label: 'Correções',
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
