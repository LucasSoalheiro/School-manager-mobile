import '../../domain/entities/activity_entity.dart';
import '../../domain/entities/enrollment_entity.dart';
import '../../domain/entities/school_class_entity.dart';
import '../../domain/repositories/school_class_repository.dart';
import '../datasources/remote_data_source.dart';

class SchoolClassRepositoryImpl implements SchoolClassRepository {
  final RemoteDataSource remoteDataSource;

  SchoolClassRepositoryImpl({required this.remoteDataSource});

  @override
  Future<SchoolClassEntity> getClassById(String id) async {
    final model = await remoteDataSource.getClassById(id);
    return model.toEntity();
  }

  @override
  Future<SchoolClassEntity> createClass(String className) async {
    final model = await remoteDataSource.createClass(className);
    return model.toEntity();
  }

  @override
  Future<void> addStudentToClass(String classId, String studentId) async {
    await remoteDataSource.addStudentToClass(classId, studentId);
  }

  @override
  Future<ActivityEntity> addActivityToClass(
    String classId, {
    required String title,
    required String description,
    required String deliveryDate,
  }) async {
    final model = await remoteDataSource.addActivityToClass(
      classId,
      title: title,
      description: description,
      deliveryDate: deliveryDate,
    );
    return model.toEntity();
  }

  @override
  Future<void> closeClass(String classId) async {
    await remoteDataSource.closeClass(classId);
  }

  @override
  Future<List<EnrollmentEntity>> getStudentEnrollments(String studentId) async {
    final models = await remoteDataSource.getEnrollmentsByStudent(studentId);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> cancelEnrollment(String enrollmentId) async {
    await remoteDataSource.cancelEnrollment(enrollmentId);
  }
}
