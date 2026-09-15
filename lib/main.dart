import 'package:flutter/material.dart';

import 'core/di/service_locator.dart';
import 'core/theme/app_theme.dart';
import 'presentation/features/auth/auth_view_model.dart';
import 'presentation/features/auth/login_screen.dart';
import 'presentation/features/student/student_home_screen.dart';
import 'presentation/features/teacher/teacher_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceLocator.setup();

  final authViewModel = AuthViewModel(
    authRepository: ServiceLocator.authRepository,
  );

  runApp(SchoolManagerApp(authViewModel: authViewModel));
}

class SchoolManagerApp extends StatelessWidget {
  final AuthViewModel authViewModel;

  const SchoolManagerApp({super.key, required this.authViewModel});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'School Manager',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: AppRootNavigator(authViewModel: authViewModel),
    );
  }
}

class AppRootNavigator extends StatefulWidget {
  final AuthViewModel authViewModel;

  const AppRootNavigator({super.key, required this.authViewModel});

  @override
  State<AppRootNavigator> createState() => _AppRootNavigatorState();
}

class _AppRootNavigatorState extends State<AppRootNavigator> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.authViewModel,
      builder: (context, _) {
        if (!widget.authViewModel.isAuthenticated) {
          return LoginScreen(
            authViewModel: widget.authViewModel,
            onLoginSuccess: () {
              setState(() {});
            },
          );
        }

        final user = widget.authViewModel.currentUser!;
        if (user.isTeacher) {
          return TeacherHomeScreen(
            onLogout: () async {
              await widget.authViewModel.logout();
            },
          );
        } else {
          return StudentHomeScreen(
            onLogout: () async {
              await widget.authViewModel.logout();
            },
          );
        }
      },
    );
  }
}
