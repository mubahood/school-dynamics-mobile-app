import 'package:dio/dio.dart' as dio;
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/utils/Utils.dart';

class AssignmentApi {
  static Future<RespondModel> fetchAssignments({
    String status = '',
    String type = '',
    int subjectId = 0,
    int classId = 0,
    int limit = 100,
  }) async {
    final query = <String, dynamic>{
      'limit': limit,
    };

    if (status.isNotEmpty) {
      query['status'] = status;
    }
    if (type.isNotEmpty) {
      query['type'] = type;
    }
    if (subjectId > 0) {
      query['subject_id'] = subjectId;
    }
    if (classId > 0) {
      query['academic_class_id'] = classId;
    }

    return RespondModel(await Utils.http_get('assignments', query));
  }

  static Future<RespondModel> fetchSubmissions({
    int assignmentId = 0,
    String status = '',
    int studentId = 0,
    int limit = 200,
  }) async {
    final query = <String, dynamic>{
      'limit': limit,
    };

    if (assignmentId > 0) {
      query['assignment_id'] = assignmentId;
    }
    if (status.isNotEmpty) {
      query['status'] = status;
    }
    if (studentId > 0) {
      query['student_id'] = studentId;
    }

    return RespondModel(await Utils.http_get('assignment-submissions', query));
  }

  static Future<RespondModel> createAssignment({
    required String title,
    required int classId,
    int subjectId = 0,
    int streamId = 0,
    String dueDate = '',
    String issueDate = '',
    String description = '',
    String instructions = '',
    String type = 'Homework',
    String status = 'Published',
    String submissionType = 'Both',
    String isAssessed = 'Yes',
    String marksDisplay = 'No',
    double? maxScore,
    String details = '',
    String? attachmentPath,
  }) async {
    final body = <String, dynamic>{
      'title': title,
      'academic_class_id': classId,
      'type': type,
      'status': status,
      'submission_type': submissionType,
      'is_assessed': isAssessed,
      'marks_display': marksDisplay,
    };

    if (subjectId > 0) {
      body['subject_id'] = subjectId;
    }
    if (streamId > 0) {
      body['stream_id'] = streamId;
    }
    if (dueDate.isNotEmpty) {
      body['due_date'] = dueDate;
    }
    if (issueDate.isNotEmpty) {
      body['issue_date'] = issueDate;
    }
    if (description.isNotEmpty) {
      body['description'] = description;
    }
    if (instructions.isNotEmpty) {
      body['instructions'] = instructions;
    }
    if (details.isNotEmpty) {
      body['details'] = details;
    }
    if (maxScore != null) {
      body['max_score'] = maxScore;
    }
    if (attachmentPath != null && attachmentPath.isNotEmpty) {
      body['attachment'] = await dio.MultipartFile.fromFile(
        attachmentPath,
        filename: attachmentPath.split('/').last,
      );
    }

    return RespondModel(await Utils.http_post('assignments', body));
  }

  static Future<RespondModel> updateAssignmentStatus(
      int assignmentId, String status) async {
    return RespondModel(await Utils.http_post(
      'assignments/$assignmentId/status',
      {'status': status},
    ));
  }

  static Future<RespondModel> regenerateSubmissions(int assignmentId) async {
    return RespondModel(await Utils.http_post(
      'assignments/$assignmentId/regenerate-submissions',
      {},
    ));
  }

  static Future<RespondModel> submitAssignment({
    required int submissionId,
    String submissionText = '',
    String? attachmentPath,
  }) async {
    final body = <String, dynamic>{};

    if (submissionText.trim().isNotEmpty) {
      body['submission_text'] = submissionText.trim();
    }

    if (attachmentPath != null && attachmentPath.isNotEmpty) {
      body['attachment'] = await dio.MultipartFile.fromFile(
        attachmentPath,
        filename: attachmentPath.split('/').last,
      );
    }

    return RespondModel(await Utils.http_post(
      'assignment-submissions/$submissionId/submit',
      body,
    ));
  }

  static Future<RespondModel> gradeSubmission({
    required int submissionId,
    required String status,
    double? score,
    String feedback = '',
    String teacherComment = '',
  }) async {
    final body = <String, dynamic>{
      'status': status,
    };

    if (score != null) {
      body['score'] = score;
    }
    if (feedback.trim().isNotEmpty) {
      body['feedback'] = feedback.trim();
    }
    if (teacherComment.trim().isNotEmpty) {
      body['teacher_comment'] = teacherComment.trim();
    }

    return RespondModel(await Utils.http_post(
      'assignment-submissions/$submissionId/grade',
      body,
    ));
  }
}
