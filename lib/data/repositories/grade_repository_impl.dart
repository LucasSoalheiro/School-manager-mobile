import '../../domain/entities/grade_entity.dart';
import '../../domain/repositories/grade_repository.dart';
import '../datasources/remote_data_source.dart';

class GradeRepositoryImpl implements GradeRepository {
  final RemoteDataSource remoteDataSource;

  GradeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GradeEntity> assignGrade({
    required String studentId,
    required String activityId,
  }) async {
    final model = await remoteDataSource.assignGrade(
      studentId: studentId,
      activityId: activityId,
    );
    return model.toEntity();
  }

  @override
  Future<void> submitGrade(String gradeId) async {
    await remoteDataSource.submitGrade(gradeId);
  }

  @override
  Future<void> gradeSubmission(
    String gradeId, {
    required double score,
    required String feedback,
  }) async {
    await remoteDataSource.gradeSubmission(
      gradeId,
      score: score,
      feedback: feedback,
    );
  }

  @override
  Future<List<GradeEntity>> getGradesByStudent(String studentId) async {
    final models = await remoteDataSource.getGradesByStudent(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<GradeEntity>> getGradesByActivity(String activityId) async {
    final models = await remoteDataSource.getGradesByActivity(activityId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<List<GradeEntity>> getGradesByTeacher(String teacherId) async {
    try {
      final teacherData = await remoteDataSource.getTeacherById(teacherId);
      final rawClasses = teacherData['school_classes'] as List<dynamic>? ?? [];
      final List<GradeEntity> allGrades = [];

      for (final rawClass in rawClasses) {
        if (rawClass is Map<String, dynamic> && rawClass['id'] != null) {
          final classId = rawClass['id'] as String;
          try {
            final classDetails = await remoteDataSource.getClassById(classId);
            for (final activity in classDetails.activities) {
              final grades = await remoteDataSource.getGradesByActivity(
                activity.id,
              );
              allGrades.addAll(grades.map((m) => m.toEntity()));
            }
          } catch (_) {}
        }
      }
      return allGrades;
    } catch (_) {
      return [];
    }
  }
}
