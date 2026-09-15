import '../../domain/entities/subject_entity.dart';

class SubjectModel {
  final String id;
  final String name;
  final String? description;
  final String teacherId;
  final String schoolClassId;

  SubjectModel({
    required this.id,
    required this.name,
    this.description,
    required this.teacherId,
    required this.schoolClassId,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      teacherId: json['teacher_id'] as String? ?? '',
      schoolClassId: (json['school_class_id'] ?? json['class_id']) as String? ?? '',
    );
  }

  SubjectEntity toEntity() {
    return SubjectEntity(
      id: id,
      name: name,
      description: description,
      teacherId: teacherId,
      schoolClassId: schoolClassId,
    );
  }
}
