import '../../domain/entities/activity_entity.dart';
import '../../domain/repositories/activity_repository.dart';
import '../datasources/remote_data_source.dart';

class ActivityRepositoryImpl implements ActivityRepository {
  final RemoteDataSource remoteDataSource;

  ActivityRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ActivityEntity> getActivityById(String id) async {
    final model = await remoteDataSource.getActivityById(id);
    return model.toEntity();
  }

  @override
  Future<void> updateDeliveryDate(String id, String newDeliveryDate) async {
    await remoteDataSource.updateActivityDeliveryDate(id, newDeliveryDate);
  }
}
