import 'package:flutter/material.dart';

import '../../../domain/entities/grade_entity.dart';
import '../../../domain/entities/school_class_entity.dart';
import '../../../domain/repositories/activity_repository.dart';
import '../../../domain/repositories/grade_repository.dart';
import '../../../domain/repositories/school_class_repository.dart';
import '../../../core/di/service_locator.dart';

/// ViewModel for the teacher role.
///
/// It provides the list of classes the teacher is responsible for,
/// the pending grade submissions that need correction, and helpers to
/// create activities and classes.
class TeacherViewModel extends ChangeNotifier {
  final SchoolClassRepository schoolClassRepository;
  final ActivityRepository activityRepository;
  final GradeRepository gradeRepository;

  TeacherViewModel({
    required this.schoolClassRepository,
    required this.activityRepository,
    required this.gradeRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<SchoolClassEntity> _classes = [];
  List<SchoolClassEntity> get classes => _classes;

  List<GradeEntity> _pendingGrades = [];
  List<GradeEntity> get pendingGrades => _pendingGrades;

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      final teacherId = ServiceLocator.sessionStorage.getUserId()!;
      final profile = await ServiceLocator.profileRepository.getProfile(
        teacherId,
        role: 'teacher',
      );
      _classes = profile.schoolClasses ?? [];

      final allGrades = await gradeRepository.getGradesByTeacher(teacherId);
      _pendingGrades = allGrades
          .where((g) => g.isSubmitted && !g.isGraded)
          .toList();
    } catch (e) {
      _errorMessage = e.toString();
    }
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submitGrade(
    String gradeId,
    double score,
    String feedback,
  ) async {
    try {
      await gradeRepository.gradeSubmission(
        gradeId,
        score: score,
        feedback: feedback,
      );
      await loadData();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createActivity(
    String classId, {
    required String title,
    required String description,
    required String deliveryDate,
  }) async {
    try {
      await schoolClassRepository.addActivityToClass(
        classId,
        title: title,
        description: description,
        deliveryDate: deliveryDate,
      );
      await loadData();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }

  Future<bool> createClass(String className) async {
    try {
      await schoolClassRepository.createClass(className);
      await loadData();
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      notifyListeners();
      return false;
    }
  }
}
