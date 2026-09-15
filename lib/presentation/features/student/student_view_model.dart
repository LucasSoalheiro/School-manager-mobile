import 'package:flutter/material.dart';

import '../../../domain/entities/activity_entity.dart';
import '../../../domain/entities/enrollment_entity.dart';
import '../../../domain/entities/grade_entity.dart';
import '../../../domain/entities/school_class_entity.dart';
import '../../../domain/repositories/grade_repository.dart';
import '../../../domain/repositories/school_class_repository.dart';

class StudentViewModel extends ChangeNotifier {
  final String studentId;
  final SchoolClassRepository schoolClassRepository;
  final GradeRepository gradeRepository;

  StudentViewModel({
    required this.studentId,
    required this.schoolClassRepository,
    required this.gradeRepository,
  });

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<EnrollmentEntity> _enrollments = [];
  List<EnrollmentEntity> get enrollments => _enrollments;

  List<SchoolClassEntity> _classes = [];
  List<SchoolClassEntity> get classes => _classes;

  List<GradeEntity> _grades = [];
  List<GradeEntity> get grades => _grades;

  List<ActivityEntity> _allActivities = [];
  List<ActivityEntity> get allActivities => _allActivities;

  // Estatísticas calculadas
  int get totalClasses => _classes.length;

  int get pendingActivitiesCount {
    return _grades.where((g) => g.isPending).length;
  }

  double get averageScore {
    final graded = _grades.where((g) => g.isGraded && g.score != null).toList();
    if (graded.isEmpty) return 0.0;
    final total = graded.fold<double>(0.0, (acc, g) => acc + g.score!);
    return total / graded.length;
  }

  Future<void> loadData() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Busca matrículas e notas do estudante
      final results = await Future.wait([
        schoolClassRepository.getStudentEnrollments(studentId),
        gradeRepository.getGradesByStudent(studentId),
      ]);

      _enrollments = results[0] as List<EnrollmentEntity>;
      _grades = results[1] as List<GradeEntity>;

      // 2. Busca os detalhes das turmas ativas matriculadas
      final loadedClasses = <SchoolClassEntity>[];
      final loadedActivities = <ActivityEntity>[];

      for (final enrollment in _enrollments) {
        if (enrollment.isActive) {
          try {
            final schoolClass = await schoolClassRepository.getClassById(
              enrollment.schoolClassId,
            );
            loadedClasses.add(schoolClass);
            loadedActivities.addAll(schoolClass.activities);
          } catch (_) {
            // Se falhar ao buscar uma turma individualmente, continua as outras
          }
        }
      }

      _classes = loadedClasses;
      _allActivities = loadedActivities;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> submitActivity(String gradeId) async {
    try {
      await gradeRepository.submitGrade(gradeId);
      await loadData();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceAll('Exception: ', '');
      notifyListeners();
      return false;
    }
  }

  GradeEntity? getGradeForActivity(String activityId) {
    try {
      return _grades.firstWhere((g) => g.activityId == activityId);
    } catch (_) {
      return null;
    }
  }
}
