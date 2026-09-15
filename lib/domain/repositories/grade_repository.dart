import '../entities/grade_entity.dart';

abstract class GradeRepository {
  Future<GradeEntity> assignGrade({
    required String studentId,
    required String activityId,
  });
  Future<void> submitGrade(String gradeId);
  Future<void> gradeSubmission(
    String gradeId, {
    required double score,
    required String feedback,
  });
  Future<List<GradeEntity>> getGradesByStudent(String studentId);
  Future<List<GradeEntity>> getGradesByActivity(String activityId);
  Future<List<GradeEntity>> getGradesByTeacher(String teacherId);
}
