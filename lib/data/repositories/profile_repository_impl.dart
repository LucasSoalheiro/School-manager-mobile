import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/user_model.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final RemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<UserEntity> getProfile(String userId, {String? role}) async {
    if (role == 'teacher') {
      return getTeacherProfile(userId);
    } else if (role == 'student') {
      return getStudentProfile(userId);
    }

    try {
      return await getTeacherProfile(userId);
    } catch (_) {
      return await getStudentProfile(userId);
    }
  }

  @override
  Future<UserEntity> getStudentProfile(String studentId) async {
    final model = await remoteDataSource.getStudentById(studentId);
    return model.toEntity();
  }

  @override
  Future<UserEntity> getTeacherProfile(String teacherId) async {
    final map = await remoteDataSource.getTeacherById(teacherId);
    return UserModel.fromJson(map, defaultRole: 'teacher').toEntity();
  }

  @override
  Future<void> updateStudentName(String studentId, String name) async {
    await remoteDataSource.updateStudentName(studentId, name);
  }

  @override
  Future<void> updateStudentPassword(
    String studentId, {
    required String currentPassword,
    required String newPassword,
  }) async {
    await remoteDataSource.updateStudentPassword(
      studentId,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }

  @override
  Future<void> assignClassToTeacher(String teacherId, String classId) async {
    await remoteDataSource.assignClassToTeacher(teacherId, classId);
  }

  @override
  Future<void> removeClassFromTeacher(String teacherId, String classId) async {
    await remoteDataSource.removeClassFromTeacher(teacherId, classId);
  }
}
