class SubjectEntity {
  final String id;
  final String name;
  final String? description;
  final String teacherId;
  final String schoolClassId;

  const SubjectEntity({
    required this.id,
    required this.name,
    this.description,
    required this.teacherId,
    required this.schoolClassId,
  });
}
