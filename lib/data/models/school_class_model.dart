import '../../domain/entities/school_class_entity.dart';
import 'activity_model.dart';

class StudentSummaryModel {
  final String id;
  final String name;
  final String email;

  StudentSummaryModel({
    required this.id,
    required this.name,
    required this.email,
  });

  factory StudentSummaryModel.fromJson(Map<String, dynamic> json) {
    return StudentSummaryModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
    );
  }

  StudentSummary toEntity() {
    return StudentSummary(id: id, name: name, email: email);
  }
}

class SchoolClassModel {
  final String id;
  final String className;
  final bool isActive;
  final List<StudentSummaryModel> students;
  final List<ActivityModel> activities;

  SchoolClassModel({
    required this.id,
    required this.className,
    this.isActive = true,
    this.students = const [],
    this.activities = const [],
  });

  factory SchoolClassModel.fromJson(Map<String, dynamic> json) {
    final rawStudents = json['students'] as List<dynamic>? ?? [];
    final rawActivities = json['activities'] as List<dynamic>? ?? [];

    return SchoolClassModel(
      id: json['id'] as String? ?? '',
      className: (json['class_name'] ?? json['name']) as String? ?? '',
      isActive: json['is_active'] as bool? ?? true,
      students: rawStudents
          .whereType<Map<String, dynamic>>()
          .map((s) => StudentSummaryModel.fromJson(s))
          .toList(),
      activities: rawActivities
          .whereType<Map<String, dynamic>>()
          .map((a) => ActivityModel.fromJson(a))
          .toList(),
    );
  }

  SchoolClassEntity toEntity() {
    return SchoolClassEntity(
      id: id,
      className: className,
      isActive: isActive,
      students: students.map((s) => s.toEntity()).toList(),
      activities: activities.map((a) => a.toEntity()).toList(),
    );
  }
}
