import '../../domain/entities/grade_entity.dart';

class GradeModel {
  final String id;
  final String studentId;
  final String activityId;
  final double? score;
  final String status;
  final String? submittedAt;
  final String? feedback;

  GradeModel({
    required this.id,
    required this.studentId,
    required this.activityId,
    this.score,
    required this.status,
    this.submittedAt,
    this.feedback,
  });

  factory GradeModel.fromJson(Map<String, dynamic> json) {
    double? parsedScore;
    if (json['score'] != null) {
      if (json['score'] is num) {
        parsedScore = (json['score'] as num).toDouble();
      } else if (json['score'] is String) {
        parsedScore = double.tryParse(json['score'] as String);
      }
    }

    return GradeModel(
      id: (json['id'] ?? json['grade_id']) as String? ?? '',
      studentId: json['student_id'] as String? ?? '',
      activityId: json['activity_id'] as String? ?? '',
      score: parsedScore,
      status: json['status'] as String? ?? 'pending',
      submittedAt: json['submitted_at'] as String?,
      feedback: json['feedback'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'activity_id': activityId,
      'score': score,
      'status': status,
      'submitted_at': submittedAt,
      'feedback': feedback,
    };
  }

  GradeEntity toEntity() {
    return GradeEntity(
      id: id,
      studentId: studentId,
      activityId: activityId,
      score: score,
      status: status,
      submittedAt: submittedAt,
      feedback: feedback,
    );
  }
}
