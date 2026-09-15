import 'package:flutter/material.dart';

import '../../../domain/entities/user_entity.dart';
import '../../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthViewModel({required this.authRepository}) {
    _currentUser = authRepository.getCurrentUser();
  }

  UserEntity? _currentUser;
  UserEntity? get currentUser => _currentUser;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  String _selectedRole = 'student'; // 'student' | 'teacher'
  String get selectedRole => _selectedRole;

  void setSelectedRole(String role) {
    if (_selectedRole != role) {
      _selectedRole = role;
      _errorMessage = null;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_selectedRole == 'student') {
        _currentUser = await authRepository.loginStudent(
          email.trim(),
          password.trim(),
        );
      } else {
        _currentUser = await authRepository.loginTeacher(
          email.trim(),
          password.trim(),
        );
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      if (_selectedRole == 'student') {
        await authRepository.registerStudent(
          name: name.trim(),
          lastName: lastName.trim(),
          email: email.trim(),
          password: password.trim(),
        );
      } else {
        await authRepository.registerTeacher(
          name: name.trim(),
          lastName: lastName.trim(),
          email: email.trim(),
          password: password.trim(),
        );
      }
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await authRepository.logout();
    _currentUser = null;
    notifyListeners();
  }

  bool get isAuthenticated =>
      authRepository.isLoggedIn() && _currentUser != null;
}
