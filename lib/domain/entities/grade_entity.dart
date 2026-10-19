import 'activity_entity.dart';
import 'school_class_entity.dart';

class GradeEntity {
  final String id;
  final String studentId;
  final String activityId;
  final double? score;
  final String status; // 'pending' | 'submitted' | 'graded'
  final String? submittedAt;
  final String? feedback;
  final String? activityTitle;
  final String? className;

  const GradeEntity({
    required this.id,
    required this.studentId,
    required this.activityId,
    this.score,
    required this.status,
    this.submittedAt,
    this.feedback,
    this.activityTitle,
    this.className,
  });

  SchoolClassEntity? get schoolClass =>
      className != null ? SchoolClassEntity(id: '', className: className!) : null;
  ActivityEntity? get activity =>
      activityTitle != null ? ActivityEntity(id: activityId, title: activityTitle!, description: '') : null;

  bool get isPending => status == 'pending';
  bool get isSubmitted => status == 'submitted';
  bool get isGraded => status == 'graded';

  String get statusLabel {
    switch (status) {
      case 'submitted':
        return 'Entregue';
      case 'graded':
        return 'Avaliado';
      case 'pending':
      default:
        return 'Pendente';
    }
  }
}
