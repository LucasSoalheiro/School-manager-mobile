import '../../domain/entities/user_entity.dart';
import 'school_class_model.dart';

class UserModel {
  final String id;
  final String name;
  final String? lastName;
  final String? fullName;
  final String email;
  final String role;
  final bool isActive;
  final List<SchoolClassModel>? schoolClasses;

  UserModel({
    required this.id,
    required this.name,
    this.lastName,
    this.fullName,
    required this.email,
    required this.role,
    this.isActive = true,
    this.schoolClasses,
  });

  factory UserModel.fromJson(
    Map<String, dynamic> json, {
    String defaultRole = 'student',
  }) {
    List<SchoolClassModel>? parsedClasses;
    if (json['school_classes'] != null && json['school_classes'] is List) {
      parsedClasses = (json['school_classes'] as List)
          .whereType<Map<String, dynamic>>()
          .map((c) => SchoolClassModel.fromJson(c))
          .toList();
    }

    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      lastName: json['last_name'] as String?,
      fullName: json['full_name'] as String?,
      email: json['email'] as String? ?? '',
      role: (json['role'] as String?) ?? defaultRole,
      isActive: json['is_active'] as bool? ?? true,
      schoolClasses: parsedClasses,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'last_name': lastName,
      'full_name': fullName,
      'email': email,
      'role': role,
      'is_active': isActive,
    };
  }

  UserEntity toEntity() {
    return UserEntity(
      id: id,
      name: name,
      lastName: lastName,
      fullName: fullName,
      email: email,
      role: role,
      isActive: isActive,
      schoolClasses: schoolClasses?.map((c) => c.toEntity()).toList(),
    );
  }
}
