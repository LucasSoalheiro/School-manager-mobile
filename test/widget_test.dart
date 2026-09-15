import 'package:flutter_test/flutter_test.dart';
import 'package:school_manager_mobile/domain/entities/user_entity.dart';
import 'package:school_manager_mobile/domain/entities/grade_entity.dart';
import 'package:school_manager_mobile/domain/entities/school_class_entity.dart';

void main() {
  group('Domain Entities Tests', () {
    test('UserEntity roles and displayName', () {
      const student = UserEntity(
        id: '1',
        name: 'João',
        lastName: 'Silva',
        email: 'joao@escola.com',
        role: 'student',
      );

      expect(student.isStudent, true);
      expect(student.isTeacher, false);
      expect(student.displayName, 'João Silva');

      const teacher = UserEntity(
        id: '2',
        name: 'Prof. Carlos',
        email: 'carlos@escola.com',
        role: 'teacher',
      );

      expect(teacher.isTeacher, true);
      expect(teacher.isStudent, false);
      expect(teacher.displayName, 'Prof. Carlos');
    });

    test('GradeEntity status getters and labels', () {
      const pendingGrade = GradeEntity(
        id: 'g1',
        studentId: 's1',
        activityId: 'a1',
        status: 'pending',
      );

      expect(pendingGrade.isPending, true);
      expect(pendingGrade.statusLabel, 'Pendente');

      const gradedGrade = GradeEntity(
        id: 'g2',
        studentId: 's1',
        activityId: 'a1',
        score: 9.5,
        status: 'graded',
      );

      expect(gradedGrade.isGraded, true);
      expect(gradedGrade.statusLabel, 'Avaliado');
      expect(gradedGrade.score, 9.5);
    });

    test('SchoolClassEntity name getter', () {
      const schoolClass = SchoolClassEntity(id: 'c1', className: 'Turma 101');

      expect(schoolClass.name, 'Turma 101');
      expect(schoolClass.students.isEmpty, true);
      expect(schoolClass.activities.isEmpty, true);
    });
  });
}
