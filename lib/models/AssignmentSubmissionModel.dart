import 'package:schooldynamics/utils/Utils.dart';

class AssignmentSubmissionModel {
  int id = 0;
  int assignmentId = 0;
  int studentId = 0;
  int subjectId = 0;
  int academicClassId = 0;
  int streamId = 0;
  String status = 'Pending';
  String submissionText = '';
  String attachment = '';
  String submittedAt = '';
  String gradedAt = '';
  double? score;
  double? maxScore;
  String feedback = '';
  String teacherComment = '';

  String assignmentTitle = '';
  String subjectName = '';
  String className = '';
  String streamName = '';
  String studentName = '';

  static AssignmentSubmissionModel fromJson(dynamic json) {
    final model = AssignmentSubmissionModel();
    if (json == null) {
      return model;
    }

    model.id = Utils.int_parse(json['id']);
    model.assignmentId = Utils.int_parse(json['assignment_id']);
    model.studentId = Utils.int_parse(json['student_id']);
    model.subjectId = Utils.int_parse(json['subject_id']);
    model.academicClassId = Utils.int_parse(json['academic_class_id']);
    model.streamId = Utils.int_parse(json['stream_id']);
    model.status = Utils.to_str(json['status'], 'Pending');
    model.submissionText = Utils.to_str(json['submission_text'], '');
    model.attachment = Utils.to_str(json['attachment'], '');
    model.submittedAt = Utils.to_str(json['submitted_at'], '');
    model.gradedAt = Utils.to_str(json['graded_at'], '');
    model.feedback = Utils.to_str(json['feedback'], '');
    model.teacherComment = Utils.to_str(json['teacher_comment'], '');

    final scoreRaw = json['score'];
    if (scoreRaw != null && scoreRaw.toString().trim().isNotEmpty) {
      model.score = double.tryParse(scoreRaw.toString());
    }

    final maxScoreRaw = json['max_score'];
    if (maxScoreRaw != null && maxScoreRaw.toString().trim().isNotEmpty) {
      model.maxScore = double.tryParse(maxScoreRaw.toString());
    }

    final assignment = json['assignment'];
    if (assignment is Map) {
      model.assignmentTitle = Utils.to_str(assignment['title'], '');
    }

    final subject = json['subject'];
    if (subject is Map) {
      model.subjectName = Utils.to_str(subject['subject_name'], '');
    }

    final academicClass = json['academicClass'];
    if (academicClass is Map) {
      model.className = Utils.to_str(academicClass['name'], '');
    }

    final stream = json['stream'];
    if (stream is Map) {
      model.streamName = Utils.to_str(stream['name'], '');
    }

    final student = json['student'];
    if (student is Map) {
      model.studentName = Utils.to_str(student['name'], '');
    }

    return model;
  }

  String get scoreText {
    if (score == null) {
      return '-';
    }
    if (maxScore == null) {
      return score!.toStringAsFixed(1);
    }
    return '${score!.toStringAsFixed(1)}/${maxScore!.toStringAsFixed(1)}';
  }

  String get classTargetText {
    if (className.isEmpty && streamName.isEmpty) {
      return '-';
    }
    if (streamName.isEmpty) {
      return className;
    }
    return '$className - $streamName';
  }
}
