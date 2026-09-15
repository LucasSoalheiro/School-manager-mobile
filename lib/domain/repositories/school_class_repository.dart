import '../entities/activity_entity.dart';
import '../entities/enrollment_entity.dart';
import '../entities/school_class_entity.dart';

abstract class SchoolClassRepository {
  Future<SchoolClassEntity> getClassById(String id);
  Future<SchoolClassEntity> createClass(String className);
  Future<void> addStudentToClass(String classId, String studentId);
  Future<ActivityEntity> addActivityToClass(
    String classId, {
    required String title,
    required String description,
    required String deliveryDate,
  });
  Future<void> closeClass(String classId);
  Future<List<EnrollmentEntity>> getStudentEnrollments(String studentId);
  Future<void> cancelEnrollment(String enrollmentId);
}
