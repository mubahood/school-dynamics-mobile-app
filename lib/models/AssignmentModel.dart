import 'package:schooldynamics/utils/Utils.dart';

class AssignmentModel {
  int id = 0;
  int subjectId = 0;
  int academicClassId = 0;
  int streamId = 0;
  int createdById = 0;
  String title = '';
  String description = '';
  String instructions = '';
  String type = '';
  String dueDate = '';
  String issueDate = '';
  String submissionType = '';
  String status = '';
  String isAssessed = '';
  String marksDisplay = '';
  double? maxScore;
  int totalStudents = 0;
  int submittedCount = 0;
  int gradedCount = 0;
  String attachment = '';

  String subjectName = '';
  String className = '';
  String streamName = '';
  String termName = '';

  static AssignmentModel fromJson(dynamic json) {
    final model = AssignmentModel();
    if (json == null) {
      return model;
    }

    model.id = Utils.int_parse(json['id']);
    model.subjectId = Utils.int_parse(json['subject_id']);
    model.academicClassId = Utils.int_parse(json['academic_class_id']);
    model.streamId = Utils.int_parse(json['stream_id']);
    model.createdById = Utils.int_parse(json['created_by_id']);
    model.title = Utils.to_str(json['title'], '');
    model.description = Utils.to_str(json['description'], '');
    model.instructions = Utils.to_str(json['instructions'], '');
    model.type = Utils.to_str(json['type'], 'Homework');
    model.dueDate = Utils.to_str(json['due_date'], '');
    model.issueDate = Utils.to_str(json['issue_date'], '');
    model.submissionType = Utils.to_str(json['submission_type'], 'Both');
    model.status = Utils.to_str(json['status'], 'Draft');
    model.isAssessed = Utils.to_str(json['is_assessed'], 'Yes');
    model.marksDisplay = Utils.to_str(json['marks_display'], 'No');
    model.attachment = Utils.to_str(json['attachment'], '');

    final maxScoreRaw = json['max_score'];
    if (maxScoreRaw != null && maxScoreRaw.toString().trim().isNotEmpty) {
      model.maxScore = double.tryParse(maxScoreRaw.toString());
    }

    model.totalStudents = Utils.int_parse(json['total_students']);
    model.submittedCount = Utils.int_parse(json['submitted_count']);
    model.gradedCount = Utils.int_parse(json['graded_count']);

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

    final term = json['term'];
    if (term is Map) {
      model.termName =
          Utils.to_str(term['name_text'], Utils.to_str(term['name'], ''));
    }

    return model;
  }

  String get targetText {
    if (className.isEmpty && streamName.isEmpty) {
      return '-';
    }
    if (streamName.isEmpty) {
      return className;
    }
    return '$className - $streamName';
  }

  String get progressText {
    if (totalStudents < 1) {
      return '0/0 submitted';
    }
    return '$submittedCount/$totalStudents submitted';
  }
}
