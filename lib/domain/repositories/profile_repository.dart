import '../entities/user_entity.dart';

abstract class ProfileRepository {
  Future<UserEntity> getProfile(String userId, {String? role});
  Future<UserEntity> getStudentProfile(String studentId);
  Future<UserEntity> getTeacherProfile(String teacherId);
  Future<void> updateStudentName(String studentId, String name);
  Future<void> updateStudentPassword(
    String studentId, {
    required String currentPassword,
    required String newPassword,
  });
  Future<void> assignClassToTeacher(String teacherId, String classId);
  Future<void> removeClassFromTeacher(String teacherId, String classId);
}
