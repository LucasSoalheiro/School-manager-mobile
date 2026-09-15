class ActivityEntity {
  final String id;
  final String title;
  final String description;
  final String? createdAt;
  final String? deliveryDate;
  final String? schoolClassId;

  const ActivityEntity({
    required this.id,
    required this.title,
    required this.description,
    this.createdAt,
    this.deliveryDate,
    this.schoolClassId,
  });
}
