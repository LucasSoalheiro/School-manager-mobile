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

  const GradeEntity({
    required this.id,
    required this.studentId,
    required this.activityId,
    this.score,
    required this.status,
    this.submittedAt,
    this.feedback,
  });

  // Placeholder getters for UI compatibility
  SchoolClassEntity? get schoolClass => null;
  ActivityEntity? get activity => null;

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
