import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity> loginStudent(String email, String password);
  Future<UserEntity> loginTeacher(String email, String password);
  Future<void> registerStudent({
    required String name,
    required String lastName,
    required String email,
    required String password,
  });
  Future<void> registerTeacher({
    required String name,
    required String lastName,
    required String email,
    required String password,
  });
  Future<void> logout();
  UserEntity? getCurrentUser();
  bool isLoggedIn();
}
