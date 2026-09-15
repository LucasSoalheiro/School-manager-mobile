import 'activity_entity.dart';

class StudentSummary {
  final String id;
  final String name;
  final String email;

  const StudentSummary({
    required this.id,
    required this.name,
    required this.email,
  });
}

class SchoolClassEntity {
  final String id;
  final String className;
  final bool isActive;
  final List<StudentSummary> students;
  final List<ActivityEntity> activities;

  const SchoolClassEntity({
    required this.id,
    required this.className,
    this.isActive = true,
    this.students = const [],
    this.activities = const [],
  });

  String get name => className;
}
