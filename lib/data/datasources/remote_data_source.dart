import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/activity_model.dart';
import '../models/enrollment_model.dart';
import '../models/grade_model.dart';
import '../models/school_class_model.dart';
import '../models/user_model.dart';

class RemoteDataSource {
  final ApiClient _apiClient;

  RemoteDataSource(this._apiClient);

  // 1. Auth
  Future<Map<String, dynamic>> loginStudent(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.studentLogin,
      body: {'email': email, 'password': password},
      includeAuth: false,
    );
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> loginTeacher(String email, String password) async {
    final response = await _apiClient.post(
      ApiConstants.teacherLogin,
      body: {'email': email, 'password': password},
      includeAuth: false,
    );
    return response as Map<String, dynamic>;
  }

  // 2. Students
  Future<Map<String, dynamic>> registerStudent({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.students,
      body: {
        'name': name,
        'last_name': lastName,
        'email': email,
        'password': password,
      },
      includeAuth: false,
    );
    return response as Map<String, dynamic>;
  }

  Future<UserModel> getStudentById(String id) async {
    final response = await _apiClient.get(ApiConstants.studentById(id));
    return UserModel.fromJson(response as Map<String, dynamic>, defaultRole: 'student');
  }

  Future<void> updateStudentName(String id, String name) async {
    await _apiClient.patch(
      ApiConstants.studentName(id),
      body: {'name': name},
    );
  }

  Future<void> updateStudentPassword(
    String id, {
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.patch(
      ApiConstants.studentPassword(id),
      body: {
        'current_password': currentPassword,
        'new_password': newPassword,
      },
    );
  }

  // 3. Teachers
  Future<Map<String, dynamic>> registerTeacher({
    required String name,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.teachers,
      body: {
        'name': name,
        'last_name': lastName,
        'email': email,
        'password': password,
      },
      includeAuth: false,
    );
    return response as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getTeacherById(String id) async {
    final response = await _apiClient.get(ApiConstants.teacherById(id));
    return response as Map<String, dynamic>;
  }

  Future<void> assignClassToTeacher(String teacherId, String classId) async {
    await _apiClient.post(
      ApiConstants.teacherClasses(teacherId),
      body: {'class_id': classId},
    );
  }

  Future<void> removeClassFromTeacher(String teacherId, String classId) async {
    await _apiClient.delete(ApiConstants.teacherClassDelete(teacherId, classId));
  }

  // 4. Classes
  Future<SchoolClassModel> createClass(String className) async {
    final response = await _apiClient.post(
      ApiConstants.classes,
      body: {'class_name': className},
    );
    return SchoolClassModel.fromJson(response as Map<String, dynamic>);
  }

  Future<SchoolClassModel> getClassById(String id) async {
    final response = await _apiClient.get(ApiConstants.classById(id));
    return SchoolClassModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> addStudentToClass(String classId, String studentId) async {
    await _apiClient.post(
      ApiConstants.classStudents(classId),
      body: {'student_id': studentId},
    );
  }

  Future<ActivityModel> addActivityToClass(
    String classId, {
    required String title,
    required String description,
    required String deliveryDate,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.classActivities(classId),
      body: {
        'title': title,
        'description': description,
        'delivery_date': deliveryDate,
      },
    );
    return ActivityModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> closeClass(String classId) async {
    await _apiClient.patch(ApiConstants.classClose(classId));
  }

  // 5. Enrollments
  Future<List<EnrollmentModel>> getEnrollmentsByStudent(String studentId) async {
    final response = await _apiClient.get(ApiConstants.enrollmentsByStudent(studentId));
    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => EnrollmentModel.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<void> cancelEnrollment(String id) async {
    await _apiClient.patch(ApiConstants.enrollmentCancel(id));
  }

  // 6. Activities
  Future<ActivityModel> getActivityById(String id) async {
    final response = await _apiClient.get(ApiConstants.activityById(id));
    return ActivityModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> updateActivityDeliveryDate(String id, String deliveryDate) async {
    await _apiClient.patch(
      ApiConstants.activityDeliveryDate(id),
      body: {'delivery_date': deliveryDate},
    );
  }

  // 7. Grades
  Future<GradeModel> assignGrade({
    required String studentId,
    required String activityId,
  }) async {
    final response = await _apiClient.post(
      ApiConstants.gradesAssign,
      body: {
        'student_id': studentId,
        'activity_id': activityId,
      },
    );
    return GradeModel.fromJson(response as Map<String, dynamic>);
  }

  Future<void> submitGrade(String gradeId) async {
    await _apiClient.post(ApiConstants.gradeSubmit(gradeId));
  }

  Future<void> gradeSubmission(
    String gradeId, {
    required double score,
    required String feedback,
  }) async {
    await _apiClient.patch(
      ApiConstants.gradeScore(gradeId),
      body: {
        'score': score,
        'feedback': feedback,
      },
    );
  }

  Future<List<GradeModel>> getGradesByStudent(String studentId) async {
    final response = await _apiClient.get(ApiConstants.gradesByStudent(studentId));
    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => GradeModel.fromJson(json))
          .toList();
    }
    return [];
  }

  Future<List<GradeModel>> getGradesByActivity(String activityId) async {
    final response = await _apiClient.get(ApiConstants.gradesByActivity(activityId));
    if (response is List) {
      return response
          .whereType<Map<String, dynamic>>()
          .map((json) => GradeModel.fromJson(json))
          .toList();
    }
    return [];
  }
}
