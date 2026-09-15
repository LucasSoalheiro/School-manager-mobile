import '../network/api_client.dart';
import '../storage/session_storage.dart';
import '../../data/datasources/remote_data_source.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/school_class_repository_impl.dart';
import '../../data/repositories/activity_repository_impl.dart';
import '../../data/repositories/grade_repository_impl.dart';
import '../../data/repositories/profile_repository_impl.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/school_class_repository.dart';
import '../../domain/repositories/activity_repository.dart';
import '../../domain/repositories/grade_repository.dart';
import '../../domain/repositories/profile_repository.dart';

class ServiceLocator {
  static late final SessionStorage sessionStorage;
  static late final ApiClient apiClient;
  static late final RemoteDataSource remoteDataSource;

  static late final AuthRepository authRepository;
  static late final SchoolClassRepository schoolClassRepository;
  static late final ActivityRepository activityRepository;
  static late final GradeRepository gradeRepository;
  static late final ProfileRepository profileRepository;

  static Future<void> setup() async {
    sessionStorage = await SessionStorage.init();
    apiClient = ApiClient(sessionStorage: sessionStorage);
    remoteDataSource = RemoteDataSource(apiClient);

    authRepository = AuthRepositoryImpl(
      remoteDataSource: remoteDataSource,
      sessionStorage: sessionStorage,
    );

    schoolClassRepository = SchoolClassRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    activityRepository = ActivityRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    gradeRepository = GradeRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );

    profileRepository = ProfileRepositoryImpl(
      remoteDataSource: remoteDataSource,
    );
  }
}
