import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConstants {
  // Configuração padrão de URL base dependendo da plataforma de execução
  static String get defaultBaseUrl {
    if (kIsWeb) return 'http://localhost:3000';
    if (Platform.isAndroid) return 'http://10.0.2.2:3000';
    return 'http://localhost:3000';
  }

  // Auth
  static const String studentLogin = '/auth/login/student';
  static const String teacherLogin = '/auth/login/teacher';

  // Students
  static const String students = '/students';
  static String studentById(String id) => '/students/$id';
  static String studentName(String id) => '/students/$id/name';
  static String studentPassword(String id) => '/students/$id/password';
  static String studentActivate(String id) => '/students/$id/activate';
  static String studentDeactivate(String id) => '/students/$id/deactivate';

  // Teachers
  static const String teachers = '/teachers';
  static String teacherById(String id) => '/teachers/$id';
  static String teacherClasses(String teacherId) => '/teachers/$teacherId/classes';
  static String teacherClassDelete(String teacherId, String classId) =>
      '/teachers/$teacherId/classes/$classId';

  // Classes
  static const String classes = '/classes';
  static String classById(String id) => '/classes/$id';
  static String classStudents(String classId) => '/classes/$classId/students';
  static String classActivities(String classId) => '/classes/$classId/activities';
  static String classClose(String classId) => '/classes/$classId/close';

  // Subjects
  static const String subjects = '/subjects';
  static String subjectById(String id) => '/subjects/$id';

  // Enrollments
  static String enrollmentsByStudent(String studentId) =>
      '/enrollments/student/$studentId';
  static String enrollmentCancel(String id) => '/enrollments/$id/cancel';

  // Activities
  static String activityById(String id) => '/activities/$id';
  static String activityDeliveryDate(String id) =>
      '/activities/$id/delivery-date';

  // Grades
  static const String gradesAssign = '/grades/assign';
  static String gradeSubmit(String gradeId) => '/grades/$gradeId/submit';
  static String gradeScore(String gradeId) => '/grades/$gradeId/grade';
  static String gradesByStudent(String studentId) => '/grades/student/$studentId';
  static String gradesByActivity(String activityId) =>
      '/grades/activity/$activityId';
}
