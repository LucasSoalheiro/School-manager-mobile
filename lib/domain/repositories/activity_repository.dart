import '../entities/activity_entity.dart';

abstract class ActivityRepository {
  Future<ActivityEntity> getActivityById(String id);
  Future<void> updateDeliveryDate(String id, String newDeliveryDate);
}
