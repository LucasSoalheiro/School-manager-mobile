import 'school_class_entity.dart';

class UserEntity {
  final String id;
  final String name;
  final String? lastName;
  final String? fullName;
  final String email;
  final String role; // 'student' | 'teacher'
  final bool isActive;
  final List<SchoolClassEntity>? schoolClasses;

  const UserEntity({
    required this.id,
    required this.name,
    this.lastName,
    this.fullName,
    required this.email,
    required this.role,
    this.isActive = true,
    this.schoolClasses,
  });

  bool get isTeacher => role.toLowerCase() == 'teacher';
  bool get isStudent => role.toLowerCase() == 'student';

  String get displayName {
    if (fullName != null && fullName!.isNotEmpty) return fullName!;
    if (lastName != null && lastName!.isNotEmpty) return '$name $lastName';
    return name;
  }
}
