import '../../domain/entities/activity_entity.dart';

class ActivityModel {
  final String id;
  final String title;
  final String description;
  final String? createdAt;
  final String? deliveryDate;
  final String? schoolClassId;

  ActivityModel({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.deliveryDate,
    this.schoolClassId,
  });

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      id: (json['id'] ?? json['activity_id']) as String? ?? '',
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      createdAt: json['created_at'] as String?,
      deliveryDate: json['delivery_date'] as String?,
      schoolClassId: json['school_class_id'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'created_at': createdAt,
      'delivery_date': deliveryDate,
      'school_class_id': schoolClassId,
    };
  }

  ActivityEntity toEntity() {
    return ActivityEntity(
      id: id,
      title: title,
      description: description,
      createdAt: createdAt,
      deliveryDate: deliveryDate,
      schoolClassId: schoolClassId,
    );
  }
}
