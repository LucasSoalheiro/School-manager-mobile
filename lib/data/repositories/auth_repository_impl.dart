import '../../core/storage/session_storage.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/remote_data_source.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final RemoteDataSource remoteDataSource;
  final SessionStorage sessionStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.sessionStorage,
  });

  @override
  Future<UserEntity> loginStudent(String email, String password) async {
    final res = await remoteDataSource.loginStudent(email, password);
    final token = res['token'] as String;
    final userJson = res['user'] as Map<String, dynamic>;
    userJson['role'] = 'student';

    await sessionStorage.saveToken(token);
    await sessionStorage.saveUser(userJson);

    return UserModel.fromJson(userJson, defaultRole: 'student').toEntity();
  }

  @override
  Future<UserEntity> loginTeacher(String email, String password) async {
    final res = await remoteDataSource.loginTeacher(email, password);
    final token = res['token'] as String;
    final userJson = res['user'] as Map<String, dynamic>;
    userJson['role'] = 'teacher';

    await sessionStorage.saveToken(token);
    await sessionStorage.saveUser(userJson);

    return UserModel.fromJson(userJson, defaultRole: 'teacher').toEntity();
  }

  @override
  Future<void> registerStudent({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    await remoteDataSource.registerStudent(
      name: name,
      lastName: lastName,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> registerTeacher({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    await remoteDataSource.registerTeacher(
      name: name,
      lastName: lastName,
      email: email,
      password: password,
    );
  }

  @override
  Future<void> logout() async {
    await sessionStorage.clearSession();
  }

  @override
  UserEntity? getCurrentUser() {
    final json = sessionStorage.getUser();
    if (json == null) return null;
    return UserModel.fromJson(json).toEntity();
  }

  @override
  bool isLoggedIn() {
    return sessionStorage.isLoggedIn();
  }
}
