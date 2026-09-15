class EnrollmentEntity {
  final String id;
  final String studentId;
  final String schoolClassId;
  final String enrolledAt;
  final String status;
  final bool isActive;

  const EnrollmentEntity({
    required this.id,
    required this.studentId,
    required this.schoolClassId,
    required this.enrolledAt,
    required this.status,
    this.isActive = true,
  });
}
