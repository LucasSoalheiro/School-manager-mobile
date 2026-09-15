import '../../domain/entities/enrollment_entity.dart';

class EnrollmentModel {
  final String id;
  final String studentId;
  final String schoolClassId;
  final String enrolledAt;
  final String status;
  final bool isActive;

  EnrollmentModel({
    required this.id,
    required this.studentId,
    required this.schoolClassId,
    required this.enrolledAt,
    required this.status,
    this.isActive = true,
  });

  factory EnrollmentModel.fromJson(Map<String, dynamic> json) {
    return EnrollmentModel(
      id: json['id'] as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      schoolClassId: json['school_class_id'] as String? ?? '',
      enrolledAt: json['enrolled_at'] as String? ?? '',
      status: json['status'] as String? ?? 'active',
      isActive: json['is_active'] as bool? ?? true,
    );
  }

  EnrollmentEntity toEntity() {
    return EnrollmentEntity(
      id: id,
      studentId: studentId,
      schoolClassId: schoolClassId,
      enrolledAt: enrolledAt,
      status: status,
      isActive: isActive,
    );
  }
}
