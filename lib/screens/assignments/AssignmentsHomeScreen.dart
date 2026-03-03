import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutx/flutx.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schooldynamics/models/AssignmentApi.dart';
import 'package:schooldynamics/models/AssignmentModel.dart';
import 'package:schooldynamics/models/AssignmentSubmissionModel.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/MyClasses.dart';
import 'package:schooldynamics/models/MySubjects.dart';
import 'package:schooldynamics/screens/students/PdfViewer.dart';
import 'package:schooldynamics/design_system/design_system.dart';
import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:schooldynamics/utils/Utils.dart';
import 'package:schooldynamics/utils/my_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

class AssignmentsHomeScreen extends StatefulWidget {
  const AssignmentsHomeScreen({super.key});

  @override
  _AssignmentsHomeScreenState createState() => _AssignmentsHomeScreenState();
}

class _AssignmentsHomeScreenState extends State<AssignmentsHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  bool loading = false;

  LoggedInUserModel u = LoggedInUserModel();
  List<AssignmentModel> assignments = [];
  List<AssignmentSubmissionModel> submissions = [];
  List<MyClasses> myClasses = [];
  List<MySubjects> mySubjects = [];

  int submissionFilterAssignmentId = 0;

  bool get isStaff {
    final userType = u.user_type.toLowerCase();
    if (userType == 'employee' || userType == 'admin') {
      return true;
    }
    return u.isRole('teacher') ||
        u.isRole('admin') ||
        u.isRole('dos') ||
        u.isRole('hm');
  }

  bool get isStudent {
    return u.user_type.toLowerCase() == 'student';
  }

  bool get isParent {
    return u.user_type.toLowerCase() == 'parent';
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    my_init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<dynamic> my_init() async {
    loading = true;
    setState(() {});

    u = await LoggedInUserModel.getLoggedInUser();
    myClasses = await MyClasses.getItems();
    mySubjects = await MySubjects.getItems();

    final assignResp = await AssignmentApi.fetchAssignments(limit: 200);
    if (assignResp.code == 1 && assignResp.data is List) {
      assignments = (assignResp.data as List)
          .map((e) => AssignmentModel.fromJson(e))
          .toList();
    } else if (assignResp.code != 1 && assignResp.message.isNotEmpty) {
      Utils.toast(assignResp.message, color: Colors.red);
    }

    final subResp = await AssignmentApi.fetchSubmissions(limit: 300);
    if (subResp.code == 1 && subResp.data is List) {
      submissions = (subResp.data as List)
          .map((e) => AssignmentSubmissionModel.fromJson(e))
          .toList();
    } else if (subResp.code != 1 && subResp.message.isNotEmpty) {
      Utils.toast(subResp.message, color: Colors.red);
    }

    loading = false;
    setState(() {});
    return "Done";
  }

  AssignmentModel? findAssignment(int assignmentId) {
    for (final a in assignments) {
      if (a.id == assignmentId) return a;
    }
    return null;
  }

  List<AssignmentSubmissionModel> get visibleSubmissions {
    if (submissionFilterAssignmentId < 1) return submissions;
    return submissions
        .where((s) => s.assignmentId == submissionFilterAssignmentId)
        .toList();
  }

  Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
      case 'graded':
      case 'submitted':
        return Colors.green;
      case 'closed':
      case 'returned':
        return Colors.orange;
      case 'late':
      case 'not submitted':
        return Colors.red;
      case 'draft':
        return Colors.grey;
      default:
        return Colors.blueGrey;
    }
  }

  Future<void> showCreateSheet() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    final instructionController = TextEditingController();
    final maxScoreController = TextEditingController(text: '100');

    int selectedClassId = myClasses.isNotEmpty ? myClasses.first.id : 0;
    int selectedSubjectId = 0;
    String selectedType = 'Homework';
    String selectedStatus = 'Published';
    String selectedSubmissionType = 'Both';
    String selectedIsAssessed = 'Yes';
    String selectedMarksDisplay = 'No';
    DateTime? dueDate;
    DateTime? issueDate;

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                left: 16,
                right: 16,
                top: 16,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.titleLarge('Create Assignment', fontWeight: 700),
                    const SizedBox(height: 12),
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Title *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: selectedClassId > 0 ? selectedClassId : null,
                      items: myClasses
                          .map((e) => DropdownMenuItem<int>(
                                value: e.id,
                                child: Text(e.name),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setModalState(() {
                          selectedClassId = value ?? 0;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Class *',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<int>(
                      value: selectedSubjectId > 0 ? selectedSubjectId : null,
                      items: [
                        const DropdownMenuItem<int>(
                          value: 0,
                          child: Text('No Subject'),
                        ),
                        ...mySubjects.map((e) => DropdownMenuItem<int>(
                              value: e.id,
                              child: Text(e.subject_name),
                            )),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          selectedSubjectId = value ?? 0;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Subject',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedType,
                      items: const [
                        DropdownMenuItem(
                            value: 'Homework', child: Text('Homework')),
                        DropdownMenuItem(
                            value: 'Assignment', child: Text('Assignment')),
                        DropdownMenuItem(
                            value: 'Project', child: Text('Project')),
                        DropdownMenuItem(
                            value: 'Classwork', child: Text('Classwork')),
                        DropdownMenuItem(value: 'Quiz', child: Text('Quiz')),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          selectedType = value ?? 'Homework';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Type',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedSubmissionType,
                      items: const [
                        DropdownMenuItem(
                            value: 'Both', child: Text('Both (Text or File)')),
                        DropdownMenuItem(
                            value: 'Text', child: Text('Text only')),
                        DropdownMenuItem(
                            value: 'File', child: Text('File only')),
                        DropdownMenuItem(
                            value: 'None', child: Text('No direct submission')),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          selectedSubmissionType = value ?? 'Both';
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Submission Type',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: maxScoreController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Max Score',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedIsAssessed,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Yes', child: Text('Assessed: Yes')),
                              DropdownMenuItem(
                                  value: 'No', child: Text('Assessed: No')),
                            ],
                            onChanged: (value) {
                              setModalState(() {
                                selectedIsAssessed = value ?? 'Yes';
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedStatus,
                            items: const [
                              DropdownMenuItem(
                                  value: 'Draft', child: Text('Draft')),
                              DropdownMenuItem(
                                  value: 'Published', child: Text('Published')),
                              DropdownMenuItem(
                                  value: 'Closed', child: Text('Closed')),
                            ],
                            onChanged: (value) {
                              setModalState(() {
                                selectedStatus = value ?? 'Published';
                              });
                            },
                            decoration: const InputDecoration(
                              labelText: 'Status',
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: selectedMarksDisplay,
                            items: const [
                              DropdownMenuItem(
                                  value: 'No', child: Text('Show Marks: No')),
                              DropdownMenuItem(
                                  value: 'Yes', child: Text('Show Marks: Yes')),
                            ],
                            onChanged: (value) {
                              setModalState(() {
                                selectedMarksDisplay = value ?? 'No';
                              });
                            },
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: dueDate ?? DateTime.now(),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  dueDate = picked;
                                });
                              }
                            },
                            icon: const Icon(FeatherIcons.calendar),
                            label: Text(dueDate == null
                                ? 'Due Date'
                                : Utils.to_date_1(dueDate!.toIso8601String())),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picked = await showDatePicker(
                                context: ctx,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                                initialDate: issueDate ?? DateTime.now(),
                              );
                              if (picked != null) {
                                setModalState(() {
                                  issueDate = picked;
                                });
                              }
                            },
                            icon: const Icon(FeatherIcons.calendar),
                            label: Text(issueDate == null
                                ? 'Issue Date'
                                : Utils.to_date_1(
                                    issueDate!.toIso8601String())),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: descriptionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: instructionController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Instructions',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () async {
                          if (titleController.text.trim().isEmpty ||
                              selectedClassId < 1) {
                            Utils.toast('Title and class are required.',
                                color: Colors.red);
                            return;
                          }

                          final parsedScore =
                              double.tryParse(maxScoreController.text.trim());

                          Utils.showLoader(true);
                          final resp = await AssignmentApi.createAssignment(
                            title: titleController.text.trim(),
                            classId: selectedClassId,
                            subjectId: selectedSubjectId,
                            dueDate: dueDate == null
                                ? ''
                                : dueDate!.toIso8601String().split('T').first,
                            issueDate: issueDate == null
                                ? ''
                                : issueDate!.toIso8601String().split('T').first,
                            description: descriptionController.text.trim(),
                            instructions: instructionController.text.trim(),
                            type: selectedType,
                            status: selectedStatus,
                            submissionType: selectedSubmissionType,
                            isAssessed: selectedIsAssessed,
                            marksDisplay: selectedMarksDisplay,
                            maxScore: parsedScore,
                          );
                          Utils.hideLoader();

                          if (resp.code == 1) {
                            Utils.toast(resp.message.isEmpty
                                ? 'Assignment created successfully.'
                                : resp.message);
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            await my_init();
                            return;
                          }

                          Utils.toast(
                            resp.message.isEmpty
                                ? 'Failed to create assignment.'
                                : resp.message,
                            color: Colors.red,
                          );
                        },
                        icon: const Icon(FeatherIcons.save),
                        label: const Text('Create Assignment'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> showSubmitSheet(
      AssignmentSubmissionModel submission, AssignmentModel? assignment) async {
    final submType = assignment?.submissionType ?? 'Both';

    if (submType == 'None') {
      Utils.toast('This assignment does not require direct submission.',
          color: Colors.orange);
      return;
    }

    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubmissionSubmitScreen(
          submission: submission,
          assignment: assignment,
        ),
      ),
    );
    await my_init();
  }

  Future<void> showGradeSheet(AssignmentSubmissionModel submission) async {
    String selectedStatus =
        submission.status == 'Pending' ? 'Graded' : submission.status;
    final scoreController = TextEditingController(
      text:
          submission.score == null ? '' : submission.score!.toStringAsFixed(1),
    );
    final feedbackController = TextEditingController(text: submission.feedback);
    final commentController =
        TextEditingController(text: submission.teacherComment);

    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
          ),
          child: StatefulBuilder(
            builder: (ctx, setModalState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.titleLarge('Grade Submission', fontWeight: 700),
                    const SizedBox(height: 8),
                    FxText.bodyMedium(
                      submission.assignmentTitle.isEmpty
                          ? 'Assignment #${submission.assignmentId}'
                          : submission.assignmentTitle,
                    ),
                    if (submission.studentName.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      FxText.bodySmall('Student: ${submission.studentName}'),
                    ],
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      items: const [
                        DropdownMenuItem(
                            value: 'Pending', child: Text('Pending')),
                        DropdownMenuItem(
                            value: 'Submitted', child: Text('Submitted')),
                        DropdownMenuItem(
                            value: 'Graded', child: Text('Graded')),
                        DropdownMenuItem(
                            value: 'Returned', child: Text('Returned')),
                        DropdownMenuItem(value: 'Late', child: Text('Late')),
                        DropdownMenuItem(
                            value: 'Not Submitted',
                            child: Text('Not Submitted')),
                      ],
                      onChanged: (value) {
                        setModalState(() {
                          selectedStatus = value ?? selectedStatus;
                        });
                      },
                      decoration: const InputDecoration(
                        labelText: 'Status',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: scoreController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText:
                            'Score (max ${submission.maxScore?.toStringAsFixed(1) ?? '-'})',
                        border: const OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: feedbackController,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        labelText: 'Feedback',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: commentController,
                      maxLines: 2,
                      decoration: const InputDecoration(
                        labelText: 'Teacher comment',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        onPressed: () async {
                          final score =
                              double.tryParse(scoreController.text.trim());

                          Utils.showLoader(true);
                          final resp = await AssignmentApi.gradeSubmission(
                            submissionId: submission.id,
                            status: selectedStatus,
                            score: score,
                            feedback: feedbackController.text.trim(),
                            teacherComment: commentController.text.trim(),
                          );
                          Utils.hideLoader();

                          if (resp.code == 1) {
                            Utils.toast(resp.message.isEmpty
                                ? 'Submission graded successfully.'
                                : resp.message);
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            await my_init();
                            return;
                          }

                          Utils.toast(
                            resp.message.isEmpty
                                ? 'Failed to save grade.'
                                : resp.message,
                            color: Colors.red,
                          );
                        },
                        icon: const Icon(FeatherIcons.checkCircle),
                        label: const Text('Save Grade'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<void> changeAssignmentStatus(
      AssignmentModel assignment, String status) async {
    Utils.showLoader(true);
    final resp =
        await AssignmentApi.updateAssignmentStatus(assignment.id, status);
    Utils.hideLoader();

    if (resp.code == 1) {
      Utils.toast(resp.message.isEmpty ? 'Status updated.' : resp.message);
      await my_init();
      return;
    }

    Utils.toast(
        resp.message.isEmpty ? 'Failed to update status.' : resp.message,
        color: Colors.red);
  }

  Future<void> regenerateSubmissions(AssignmentModel assignment) async {
    Utils.showLoader(true);
    final resp = await AssignmentApi.regenerateSubmissions(assignment.id);
    Utils.hideLoader();

    if (resp.code == 1) {
      Utils.toast(
          resp.message.isEmpty ? 'Submissions regenerated.' : resp.message);
      await my_init();
      return;
    }

    Utils.toast(
        resp.message.isEmpty
            ? 'Failed to regenerate submissions.'
            : resp.message,
        color: Colors.red);
  }

  Future<void> onAssignmentCardTap(
      AssignmentModel item, AssignmentSubmissionModel? mySubmission) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AssignmentDetailScreen(
          assignment: item,
          mySubmission: mySubmission,
          isStaff: isStaff,
          isStudent: isStudent || isParent,
          statusColor: statusColor,
          onViewSubmissions: () async {
            setState(() {
              submissionFilterAssignmentId = item.id;
            });
            _tabController.animateTo(1);
          },
          onPublish: () => changeAssignmentStatus(item, 'Published'),
          onClose: () => changeAssignmentStatus(item, 'Closed'),
          onDraft: () => changeAssignmentStatus(item, 'Draft'),
          onRegenerate: () => regenerateSubmissions(item),
          onSubmitUpdate: mySubmission == null
              ? null
              : () => showSubmitSheet(mySubmission, item),
        ),
      ),
    );
    await my_init();
  }

  Future<void> onSubmissionCardTap(
      AssignmentSubmissionModel item, AssignmentModel? assignment) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SubmissionDetailScreen(
          submission: item,
          assignment: assignment,
          isStaff: isStaff,
          isStudent: isStudent || isParent,
          statusColor: statusColor,
          onGrade: () => showGradeSheet(item),
          onSubmitUpdate: () => showSubmitSheet(item, assignment),
        ),
      ),
    );
    await my_init();
  }

  Widget smallInfoChip(String label, String value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.zero,
      ),
      child: FxText.bodySmall('$label: $value'),
    );
  }

  Widget assignmentCard(AssignmentModel item) {
    AssignmentSubmissionModel? mySubmission;
    for (final sub in submissions) {
      if (sub.assignmentId == item.id) {
        mySubmission = sub;
        break;
      }
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => onAssignmentCardTap(item, mySubmission),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FxText.titleMedium(
                      item.title,
                      fontWeight: 700,
                      maxLines: 2,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor(item.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.zero,
                    ),
                    child: FxText.bodySmall(
                      item.status,
                      color: statusColor(item.status),
                      fontWeight: 700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  smallInfoChip('Type', item.type),
                  smallInfoChip('Target', item.targetText),
                  smallInfoChip(
                      'Due',
                      item.dueDate.isEmpty
                          ? '-'
                          : Utils.to_date_1(item.dueDate)),
                  smallInfoChip('Progress', item.progressText),
                ],
              ),
              if (item.subjectName.isNotEmpty) ...[
                const SizedBox(height: 8),
                FxText.bodySmall('Subject: ${item.subjectName}'),
              ],
              const SizedBox(height: 10),
              Row(
                children: [
                  if (isStaff)
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          submissionFilterAssignmentId = item.id;
                        });
                        _tabController.animateTo(1);
                      },
                      icon: const Icon(FeatherIcons.list, size: 16),
                      label: const Text('Submissions'),
                    ),
                  if (isStaff)
                    PopupMenuButton<String>(
                      onSelected: (value) async {
                        if (value == 'publish') {
                          await changeAssignmentStatus(item, 'Published');
                        } else if (value == 'close') {
                          await changeAssignmentStatus(item, 'Closed');
                        } else if (value == 'draft') {
                          await changeAssignmentStatus(item, 'Draft');
                        } else if (value == 'regenerate') {
                          await regenerateSubmissions(item);
                        }
                      },
                      itemBuilder: (ctx) => const [
                        PopupMenuItem(
                            value: 'publish', child: Text('Set Published')),
                        PopupMenuItem(
                            value: 'close', child: Text('Set Closed')),
                        PopupMenuItem(value: 'draft', child: Text('Set Draft')),
                        PopupMenuItem(
                            value: 'regenerate',
                            child: Text('Regenerate Submissions')),
                      ],
                    ),
                  if (isStudent || isParent)
                    TextButton.icon(
                      onPressed: mySubmission == null
                          ? null
                          : () => showSubmitSheet(mySubmission!, item),
                      icon: const Icon(FeatherIcons.uploadCloud, size: 16),
                      label: Text(mySubmission == null
                          ? 'No Submission Slot'
                          : 'Submit / Update'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget submissionCard(AssignmentSubmissionModel item) {
    final assignment = findAssignment(item.assignmentId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: InkWell(
        onTap: () => onSubmissionCardTap(item, assignment),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: FxText.titleMedium(
                      item.assignmentTitle.isEmpty
                          ? (assignment?.title.isNotEmpty == true
                              ? assignment!.title
                              : 'Assignment #${item.assignmentId}')
                          : item.assignmentTitle,
                      fontWeight: 700,
                      maxLines: 2,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor(item.status).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.zero,
                    ),
                    child: FxText.bodySmall(
                      item.status,
                      color: statusColor(item.status),
                      fontWeight: 700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 6,
                children: [
                  smallInfoChip('Score', item.scoreText),
                  smallInfoChip('Class', item.classTargetText),
                  smallInfoChip(
                    'Submitted',
                    item.submittedAt.isEmpty
                        ? '-'
                        : Utils.to_date_1(item.submittedAt),
                  ),
                  if (item.studentName.isNotEmpty)
                    smallInfoChip('Student', item.studentName),
                ],
              ),
              if (item.feedback.isNotEmpty) ...[
                const SizedBox(height: 8),
                FxText.bodySmall('Feedback: ${item.feedback}'),
              ],
              const SizedBox(height: 8),
              Row(
                children: [
                  if (isStaff)
                    TextButton.icon(
                      onPressed: () => showGradeSheet(item),
                      icon: const Icon(FeatherIcons.edit3, size: 16),
                      label: const Text('Grade'),
                    ),
                  if (isStudent || isParent)
                    TextButton.icon(
                      onPressed: () => showSubmitSheet(item, assignment),
                      icon: const Icon(FeatherIcons.uploadCloud, size: 16),
                      label: const Text('Submit / Update'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget assignmentsTab() {
    if (assignments.isEmpty) {
      return emptyListWidget("No assignments found", my_init);
    }

    return RefreshIndicator(
      onRefresh: () => my_init(),
      child: ListView.builder(
        itemCount: assignments.length,
        itemBuilder: (context, index) {
          return assignmentCard(assignments[index]);
        },
      ),
    );
  }

  Widget submissionsTab() {
    final items = visibleSubmissions;

    return Column(
      children: [
        if (submissionFilterAssignmentId > 0)
          Container(
            color: Colors.amber.shade50,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: FxText.bodySmall(
                      'Filtered by assignment #$submissionFilterAssignmentId'),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      submissionFilterAssignmentId = 0;
                    });
                  },
                  child: const Text('Clear'),
                ),
              ],
            ),
          ),
        Expanded(
          child: items.isEmpty
              ? emptyListWidget("No submissions found", my_init)
              : RefreshIndicator(
                  onRefresh: () => my_init(),
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return submissionCard(items[index]);
                    },
                  ),
                ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          'Assignments & Homework',
          color: Colors.white,
          fontWeight: 700,
        ),
        actions: [
          IconButton(
            onPressed: () {
              my_init();
            },
            icon: const Icon(
              Icons.refresh,
              size: 35,
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withValues(alpha: 0.6),
          tabs: [
            Tab(text: 'Assignments (${assignments.length})'),
            Tab(text: 'Submissions (${submissions.length})'),
          ],
        ),
      ),
      floatingActionButton: isStaff
          ? FloatingActionButton(
              backgroundColor: AppColors.primary,
              onPressed: showCreateSheet,
              child: const Icon(Icons.add),
            )
          : null,
      body: loading
          ? myListLoaderWidget(context)
          : TabBarView(
              controller: _tabController,
              children: [
                assignmentsTab(),
                submissionsTab(),
              ],
            ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Assignment Detail Screen
// ─────────────────────────────────────────────────────────────────────────────
class AssignmentDetailScreen extends StatelessWidget {
  const AssignmentDetailScreen({
    super.key,
    required this.assignment,
    required this.mySubmission,
    required this.isStaff,
    required this.isStudent,
    required this.statusColor,
    required this.onViewSubmissions,
    required this.onPublish,
    required this.onClose,
    required this.onDraft,
    required this.onRegenerate,
    required this.onSubmitUpdate,
  });

  final AssignmentModel assignment;
  final AssignmentSubmissionModel? mySubmission;
  final bool isStaff;
  final bool isStudent;
  final Color Function(String) statusColor;
  final Future<void> Function() onViewSubmissions;
  final Future<void> Function() onPublish;
  final Future<void> Function() onClose;
  final Future<void> Function() onDraft;
  final Future<void> Function() onRegenerate;
  final Future<void> Function()? onSubmitUpdate;

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _attachmentUrl(String path) {
    if (path.startsWith('http')) return path;
    return '${AppConfig.MAIN_SITE_URL}/storage/$path';
  }

  bool _isPdf(String path) {
    return path.toLowerCase().endsWith('.pdf');
  }

  bool _isImage(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp');
  }

  void _openAttachment(BuildContext context, String path) {
    final url = _attachmentUrl(path);
    if (_isPdf(path)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(url, 'Assignment Attachment'),
        ),
      );
    } else {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  // ── Reusable widgets ──────────────────────────────────────────────────────

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: Row(
        children: [
          Container(
              width: 3,
              height: 14,
              color: AppColors.primary,
              margin: const EdgeInsets.only(right: 8)),
          Text(title.toUpperCase(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 0.8)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {IconData? icon}) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: AppColors.textSecondary),
            const SizedBox(width: 6),
          ],
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status, {bool inHeader = false}) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: inHeader ? Colors.white : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(status,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _typeBadge(String type, {bool inHeader = false}) {
    final colors = {
      'Homework': Colors.blue,
      'Assignment': Colors.indigo,
      'Project': Colors.orange,
      'Classwork': Colors.teal,
      'Quiz': Colors.purple,
    };
    final color = colors[type] ?? Colors.blueGrey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: inHeader ? Colors.white : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            type == 'Homework'
                ? FeatherIcons.home
                : type == 'Quiz'
                    ? FeatherIcons.helpCircle
                    : type == 'Project'
                        ? FeatherIcons.layers
                        : FeatherIcons.fileText,
            size: 12,
            color: color,
          ),
          const SizedBox(width: 4),
          Text(type,
              style: TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w700, color: color)),
        ],
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required VoidCallback? onPressed,
    Color? bg,
    Color? fg,
    bool outlined = false,
  }) {
    if (outlined) {
      return SizedBox(
        width: double.infinity,
        height: 44,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            foregroundColor: bg ?? AppColors.primary,
            side: BorderSide(color: bg ?? AppColors.primary),
            shape: const RoundedRectangleBorder(),
          ),
          onPressed: onPressed,
          icon: Icon(icon, size: 16),
          label: Text(label, style: const TextStyle(fontSize: 13)),
        ),
      );
    }
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        style: ElevatedButton.styleFrom(
          backgroundColor: bg ?? AppColors.primary,
          foregroundColor: fg ?? Colors.white,
          shape: const RoundedRectangleBorder(),
          elevation: 0,
        ),
        onPressed: onPressed,
        icon: Icon(icon, size: 16),
        label: Text(label, style: const TextStyle(fontSize: 13)),
      ),
    );
  }

  Widget _htmlContent(String htmlData) {
    return Html(
      data: htmlData,
      style: {
        '*': Style(
          color: AppColors.textPrimary,
          fontSize: FontSize(14),
          lineHeight: const LineHeight(1.6),
        ),
        'strong': Style(
          fontWeight: FontWeight.w700,
        ),
        'a': Style(
          color: AppColors.primary,
          textDecoration: TextDecoration.underline,
        ),
      },
    );
  }

  Widget _attachmentCard(BuildContext context, String path, String label) {
    final fileName = path.split('/').last;
    final isPdf = _isPdf(path);
    final isImg = _isImage(path);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (isPdf
                      ? Colors.red
                      : isImg
                          ? Colors.blue
                          : Colors.grey)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Icon(
              isPdf
                  ? FeatherIcons.fileText
                  : isImg
                      ? FeatherIcons.image
                      : FeatherIcons.file,
              color: isPdf
                  ? Colors.red
                  : isImg
                      ? Colors.blue
                      : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(fileName,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _openAttachment(context, path),
            borderRadius: BorderRadius.circular(3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isPdf ? FeatherIcons.eye : FeatherIcons.externalLink,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(isPdf ? 'View' : 'Open',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final total = assignment.totalStudents;
    final submitted = assignment.submittedCount;
    final graded = assignment.gradedCount;
    final progressPct = total > 0 ? submitted / total : 0.0;

    final bool isOverdue = assignment.dueDate.isNotEmpty &&
        DateTime.tryParse(assignment.dueDate)?.isBefore(DateTime.now()) ==
            true &&
        assignment.status.toLowerCase() != 'closed' &&
        assignment.status.toLowerCase() != 'archived';

    final bool hasDescription = assignment.description.trim().isNotEmpty;
    final bool hasInstructions = assignment.instructions.trim().isNotEmpty;
    final bool hasAttachment = assignment.attachment.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: const Text('Assignment Details',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
        actions: [
          if (isStaff)
            PopupMenuButton<String>(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onSelected: (v) async {
                if (v == 'publish') await onPublish();
                if (v == 'close') await onClose();
                if (v == 'draft') await onDraft();
                if (v == 'regenerate') await onRegenerate();
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'publish', child: Text('Set Published')),
                PopupMenuItem(value: 'close', child: Text('Set Closed')),
                PopupMenuItem(value: 'draft', child: Text('Set Draft')),
                PopupMenuItem(
                    value: 'regenerate', child: Text('Regenerate Submissions')),
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header banner ─────────────────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(assignment.title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: [
                      _typeBadge(assignment.type, inHeader: true),
                      _statusBadge(assignment.status, inHeader: true),
                      if (isOverdue)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FeatherIcons.alertCircle,
                                  size: 12, color: Colors.red),
                              SizedBox(width: 4),
                              Text('OVERDUE',
                                  style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.red)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Progress ───────────────────────────────────────────
                  if (total > 0) ...[
                    _sectionHeader('Progress'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                  '$submitted of $total submitted  (${(progressPct * 100).toStringAsFixed(0)}%)',
                                  style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600)),
                              Text('$graded graded',
                                  style: const TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textSecondary)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: progressPct,
                              minHeight: 6,
                              backgroundColor: Colors.grey.shade200,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                  progressPct >= 1.0
                                      ? AppColors.success
                                      : AppColors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── Academic Context ───────────────────────────────────
                  _sectionHeader('Academic Context'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                            'Subject',
                            assignment.subjectName.isEmpty
                                ? '-'
                                : assignment.subjectName,
                            icon: FeatherIcons.book),
                        _infoRow('Class', assignment.targetText,
                            icon: FeatherIcons.users),
                        _infoRow(
                            'Term',
                            assignment.termName.isEmpty
                                ? '-'
                                : assignment.termName,
                            icon: FeatherIcons.calendar),
                      ],
                    ),
                  ),

                  // ── Timeline ───────────────────────────────────────────
                  _sectionHeader('Timeline'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                            'Issued',
                            assignment.issueDate.isEmpty
                                ? '-'
                                : Utils.to_date_1(assignment.issueDate),
                            icon: FeatherIcons.calendar),
                        _infoRow(
                            'Due',
                            assignment.dueDate.isEmpty
                                ? '-'
                                : Utils.to_date_1(assignment.dueDate),
                            icon: FeatherIcons.clock),
                      ],
                    ),
                  ),

                  // ── Scoring & Submission Settings ──────────────────────
                  _sectionHeader('Scoring & Submission'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _infoRow('Submit Via', assignment.submissionType,
                            icon: FeatherIcons.upload),
                        _infoRow('Assessed', assignment.isAssessed,
                            icon: FeatherIcons.checkSquare),
                        _infoRow('Max Score',
                            assignment.maxScore?.toStringAsFixed(1) ?? '-',
                            icon: FeatherIcons.award),
                        _infoRow('Show Marks', assignment.marksDisplay,
                            icon: FeatherIcons.eye),
                      ],
                    ),
                  ),

                  // ── Description (HTML) ─────────────────────────────────
                  if (hasDescription) ...[
                    _sectionHeader('Description'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: _htmlContent(assignment.description),
                    ),
                  ],

                  // ── Instructions (HTML) ────────────────────────────────
                  if (hasInstructions) ...[
                    _sectionHeader('Instructions'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        border: Border.all(color: Colors.blue.shade100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(top: 12),
                            child: Icon(FeatherIcons.info,
                                size: 16, color: Colors.blue.shade700),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                              child: _htmlContent(assignment.instructions)),
                        ],
                      ),
                    ),
                  ],

                  // ── Attachment ─────────────────────────────────────────
                  if (hasAttachment) ...[
                    _sectionHeader('Attachment'),
                    _attachmentCard(
                        context, assignment.attachment, 'Reference Material'),
                  ],

                  // ── Actions ────────────────────────────────────────────
                  const SizedBox(height: 24),
                  if (isStaff) ...[
                    _actionButton(
                      label: 'View Submissions ($submitted)',
                      icon: FeatherIcons.list,
                      onPressed: () async {
                        await onViewSubmissions();
                        if (!context.mounted) return;
                        Navigator.pop(context);
                      },
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            label: 'Publish',
                            icon: FeatherIcons.send,
                            onPressed: onPublish,
                            outlined: true,
                            bg: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _actionButton(
                            label: 'Close',
                            icon: FeatherIcons.lock,
                            onPressed: onClose,
                            outlined: true,
                            bg: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _actionButton(
                            label: 'Draft',
                            icon: FeatherIcons.edit,
                            onPressed: onDraft,
                            outlined: true,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: _actionButton(
                            label: 'Regenerate',
                            icon: FeatherIcons.refreshCw,
                            onPressed: onRegenerate,
                            outlined: true,
                          ),
                        ),
                      ],
                    ),
                  ],

                  if (isStudent) ...[
                    _actionButton(
                      label: onSubmitUpdate == null
                          ? 'No Submission Slot'
                          : (mySubmission != null &&
                                  mySubmission!.status != 'Pending'
                              ? 'Update Submission'
                              : 'Submit Assignment'),
                      icon: FeatherIcons.uploadCloud,
                      onPressed: onSubmitUpdate,
                    ),
                    if (mySubmission != null &&
                        mySubmission!.status != 'Pending') ...[
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(FeatherIcons.checkCircle,
                                    size: 14, color: AppColors.textSecondary),
                                const SizedBox(width: 6),
                                const Text('My Submission',
                                    style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.textPrimary)),
                                const Spacer(),
                                _statusBadge(mySubmission!.status),
                              ],
                            ),
                            if (mySubmission!.submittedAt.isNotEmpty) ...[
                              const SizedBox(height: 6),
                              _infoRow('Submitted',
                                  Utils.to_date_1(mySubmission!.submittedAt),
                                  icon: FeatherIcons.clock),
                            ],
                            if (mySubmission!.score != null) ...[
                              const SizedBox(height: 4),
                              _infoRow('Score', mySubmission!.scoreText,
                                  icon: FeatherIcons.award),
                            ],
                            if (mySubmission!.feedback.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              _infoRow('Feedback', mySubmission!.feedback,
                                  icon: FeatherIcons.messageSquare),
                            ],
                            if (mySubmission!.attachment.isNotEmpty) ...[
                              const SizedBox(height: 8),
                              InkWell(
                                onTap: () => _openAttachment(
                                    context, mySubmission!.attachment),
                                child: Row(
                                  children: [
                                    Icon(FeatherIcons.paperclip,
                                        size: 14, color: AppColors.primary),
                                    const SizedBox(width: 6),
                                    Expanded(
                                      child: Text(
                                        'View my document',
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.underline),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                            // Photo gallery thumbnails
                            if (mySubmission!.photos.isNotEmpty) ...[
                              const SizedBox(height: 10),
                              Text(
                                  '${mySubmission!.photos.length} photo(s) submitted',
                                  style: const TextStyle(
                                      fontSize: 11,
                                      color: AppColors.textSecondary)),
                              const SizedBox(height: 6),
                              SizedBox(
                                height: 72,
                                child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: mySubmission!.photos.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(width: 8),
                                  itemBuilder: (ctx, i) {
                                    final photoPath = mySubmission!.photos[i];
                                    final photoUrl = _attachmentUrl(photoPath);
                                    return InkWell(
                                      onTap: () => launchUrl(
                                          Uri.parse(photoUrl),
                                          mode: LaunchMode.externalApplication),
                                      borderRadius: BorderRadius.circular(6),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(6),
                                        child: Image.network(photoUrl,
                                            width: 72,
                                            height: 72,
                                            fit: BoxFit.cover,
                                            errorBuilder: (_, __, ___) =>
                                                Container(
                                                  width: 72,
                                                  height: 72,
                                                  color: Colors.grey.shade200,
                                                  child: const Icon(
                                                      FeatherIcons.image,
                                                      size: 20,
                                                      color: Colors.grey),
                                                )),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Submission Detail Screen
// ─────────────────────────────────────────────────────────────────────────────
class SubmissionDetailScreen extends StatelessWidget {
  const SubmissionDetailScreen({
    super.key,
    required this.submission,
    required this.assignment,
    required this.isStaff,
    required this.isStudent,
    required this.statusColor,
    required this.onGrade,
    required this.onSubmitUpdate,
  });

  final AssignmentSubmissionModel submission;
  final AssignmentModel? assignment;
  final bool isStaff;
  final bool isStudent;
  final Color Function(String) statusColor;
  final Future<void> Function() onGrade;
  final Future<void> Function() onSubmitUpdate;

  // ── Helpers ───────────────────────────────────────────────────────────────

  String _attachmentUrl(String path) {
    if (path.startsWith('http')) return path;
    return '${AppConfig.MAIN_SITE_URL}/storage/$path';
  }

  bool _isPdf(String path) {
    return path.toLowerCase().endsWith('.pdf');
  }

  bool _isImage(String path) {
    final lower = path.toLowerCase();
    return lower.endsWith('.jpg') ||
        lower.endsWith('.jpeg') ||
        lower.endsWith('.png') ||
        lower.endsWith('.gif') ||
        lower.endsWith('.webp');
  }

  void _openAttachment(BuildContext context, String path) {
    final url = _attachmentUrl(path);
    if (_isPdf(path)) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PdfViewerScreen(url, 'Submission Attachment'),
        ),
      );
    } else {
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    }
  }

  // ── Reusable widgets ──────────────────────────────────────────────────────

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: Row(
        children: [
          Container(
              width: 3,
              height: 14,
              color: AppColors.primary,
              margin: const EdgeInsets.only(right: 8)),
          Text(title.toUpperCase(),
              style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primary,
                  letterSpacing: 0.8)),
        ],
      ),
    );
  }

  Widget _infoRow(String label, String value, {IconData? icon}) {
    if (value.trim().isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: AppColors.textSecondary),
            const SizedBox(width: 6),
          ],
          SizedBox(
            width: 110,
            child: Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w500)),
          ),
          Expanded(
            child: Text(value,
                style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status, {bool inHeader = false}) {
    final color = statusColor(status);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: inHeader ? Colors.white : color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(3),
      ),
      child: Text(status,
          style: TextStyle(
              fontSize: 12, fontWeight: FontWeight.w700, color: color)),
    );
  }

  Widget _htmlContent(String htmlData) {
    return Html(
      data: htmlData,
      style: {
        '*': Style(
          color: AppColors.textPrimary,
          fontSize: FontSize(14),
          lineHeight: const LineHeight(1.6),
        ),
        'strong': Style(
          fontWeight: FontWeight.w700,
        ),
        'a': Style(
          color: AppColors.primary,
          textDecoration: TextDecoration.underline,
        ),
      },
    );
  }

  Widget _attachmentCard(BuildContext context, String path, String label) {
    final fileName = path.split('/').last;
    final isPdf = _isPdf(path);
    final isImg = _isImage(path);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: (isPdf
                      ? Colors.red
                      : isImg
                          ? Colors.blue
                          : Colors.grey)
                  .withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: Icon(
              isPdf
                  ? FeatherIcons.fileText
                  : isImg
                      ? FeatherIcons.image
                      : FeatherIcons.file,
              color: isPdf
                  ? Colors.red
                  : isImg
                      ? Colors.blue
                      : Colors.grey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w500)),
                const SizedBox(height: 2),
                Text(fileName,
                    style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          const SizedBox(width: 8),
          InkWell(
            onTap: () => _openAttachment(context, path),
            borderRadius: BorderRadius.circular(3),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(isPdf ? FeatherIcons.eye : FeatherIcons.externalLink,
                      size: 14, color: AppColors.primary),
                  const SizedBox(width: 4),
                  Text(isPdf ? 'View' : 'Open',
                      style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final title = submission.assignmentTitle.isNotEmpty
        ? submission.assignmentTitle
        : (assignment?.title.isNotEmpty == true
            ? assignment!.title
            : 'Assignment #${submission.assignmentId}');

    final hasScore = submission.score != null;
    final scoreColor = hasScore
        ? (submission.maxScore != null &&
                submission.score! >= submission.maxScore! * 0.5
            ? AppColors.success
            : AppColors.error)
        : AppColors.textSecondary;

    final bool hasSubmissionText = submission.submissionText.trim().isNotEmpty;
    final bool hasAttachment = submission.attachment.trim().isNotEmpty;
    final bool hasPhotos = submission.photos.isNotEmpty;
    final bool hasAssignmentAttachment =
        assignment != null && assignment!.attachment.trim().isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: const Text('Submission Details',
            style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header banner ─────────────────────────────────────────
            Container(
              width: double.infinity,
              color: AppColors.primary,
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      _statusBadge(submission.status, inHeader: true),
                      if (hasScore) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(3),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(FeatherIcons.award,
                                  size: 13, color: scoreColor),
                              const SizedBox(width: 4),
                              Text(submission.scoreText,
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: scoreColor)),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),

            // ── Score highlight card (when graded) ───────────────────
            if (hasScore)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: scoreColor.withValues(alpha: 0.06),
                  border: Border.all(color: scoreColor.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: BoxDecoration(
                        color: scoreColor.withValues(alpha: 0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          submission.score!.toStringAsFixed(0),
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: scoreColor),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Score: ${submission.scoreText}',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: scoreColor),
                          ),
                          if (submission.maxScore != null) ...[
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(2),
                              child: LinearProgressIndicator(
                                value: submission.score! / submission.maxScore!,
                                minHeight: 5,
                                backgroundColor: Colors.grey.shade200,
                                valueColor:
                                    AlwaysStoppedAnimation<Color>(scoreColor),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Student Info ─────────────────────────────────────
                  _sectionHeader('Student Information'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                            'Student',
                            submission.studentName.isEmpty
                                ? '-'
                                : submission.studentName,
                            icon: FeatherIcons.user),
                        _infoRow('Class', submission.classTargetText,
                            icon: FeatherIcons.users),
                        _infoRow(
                            'Subject',
                            submission.subjectName.isEmpty
                                ? '-'
                                : submission.subjectName,
                            icon: FeatherIcons.book),
                      ],
                    ),
                  ),

                  // ── Timeline ─────────────────────────────────────────
                  _sectionHeader('Timeline'),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      border: Border.all(color: AppColors.border),
                    ),
                    child: Column(
                      children: [
                        _infoRow(
                            'Submitted',
                            submission.submittedAt.isEmpty
                                ? 'Not yet submitted'
                                : Utils.to_date_1(submission.submittedAt),
                            icon: FeatherIcons.uploadCloud),
                        _infoRow(
                            'Graded',
                            submission.gradedAt.isEmpty
                                ? 'Not yet graded'
                                : Utils.to_date_1(submission.gradedAt),
                            icon: FeatherIcons.checkCircle),
                        if (assignment != null &&
                            assignment!.dueDate.isNotEmpty)
                          _infoRow(
                              'Due Date', Utils.to_date_1(assignment!.dueDate),
                              icon: FeatherIcons.clock),
                      ],
                    ),
                  ),

                  // ── Submission Content ───────────────────────────────
                  if (hasSubmissionText) ...[
                    _sectionHeader('Submission Content'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: _htmlContent(submission.submissionText),
                    ),
                  ],

                  // ── Submitted Attachment ─────────────────────────────
                  if (hasAttachment) ...[
                    _sectionHeader('Submitted File'),
                    _attachmentCard(
                        context, submission.attachment, 'Student Submission'),
                  ],

                  // ── Submitted Photos ────────────────────────────────
                  if (hasPhotos) ...[
                    _sectionHeader(
                        'Submitted Photos (${submission.photos.length})'),
                    SizedBox(
                      height: 120,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: submission.photos.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 10),
                        itemBuilder: (ctx, i) {
                          final photoPath = submission.photos[i];
                          final photoUrl = _attachmentUrl(photoPath);
                          return InkWell(
                            onTap: () => launchUrl(Uri.parse(photoUrl),
                                mode: LaunchMode.externalApplication),
                            borderRadius: BorderRadius.circular(6),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(6),
                              child: Image.network(
                                photoUrl,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  width: 120,
                                  height: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const Icon(FeatherIcons.image,
                                          size: 24, color: Colors.grey),
                                      const SizedBox(height: 4),
                                      Text('Photo ${i + 1}',
                                          style: const TextStyle(
                                              fontSize: 10,
                                              color: Colors.grey)),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],

                  // ── Assignment Reference Attachment ──────────────────
                  if (hasAssignmentAttachment) ...[
                    _sectionHeader('Assignment Reference'),
                    _attachmentCard(context, assignment!.attachment,
                        'Teacher Reference Material'),
                  ],

                  // ── Assignment Description (for context) ─────────────
                  if (assignment != null &&
                      assignment!.description.trim().isNotEmpty) ...[
                    _sectionHeader('Assignment Description'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade50,
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      child: _htmlContent(assignment!.description),
                    ),
                  ],

                  // ── Feedback ─────────────────────────────────────────
                  if (submission.feedback.isNotEmpty) ...[
                    _sectionHeader('Teacher Feedback'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.green.shade50,
                        border: Border.all(color: Colors.green.shade100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(FeatherIcons.messageSquare,
                              size: 16, color: Colors.green.shade700),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(submission.feedback,
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.green.shade900)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── Teacher Comment (internal, staff only) ──────────
                  if (submission.teacherComment.isNotEmpty && isStaff) ...[
                    _sectionHeader('Internal Comment'),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        border: Border.all(color: Colors.amber.shade100),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(FeatherIcons.lock,
                              size: 16, color: Colors.amber.shade800),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(submission.teacherComment,
                                style: TextStyle(
                                    fontSize: 14,
                                    height: 1.5,
                                    color: Colors.amber.shade900)),
                          ),
                        ],
                      ),
                    ),
                  ],

                  // ── Actions ──────────────────────────────────────────
                  const SizedBox(height: 24),
                  if (isStaff)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(),
                          elevation: 0,
                        ),
                        onPressed: onGrade,
                        icon: const Icon(FeatherIcons.edit3, size: 18),
                        label: const Text('Grade Submission',
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),
                  if (isStudent)
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(),
                          elevation: 0,
                        ),
                        onPressed: onSubmitUpdate,
                        icon: const Icon(FeatherIcons.uploadCloud, size: 18),
                        label: Text(
                            submission.status == 'Pending'
                                ? 'Submit Assignment'
                                : 'Update Submission',
                            style: const TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600)),
                      ),
                    ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Submission Submit Screen  (full independent screen — not a modal)
// ─────────────────────────────────────────────────────────────────────────────
class SubmissionSubmitScreen extends StatefulWidget {
  const SubmissionSubmitScreen({
    super.key,
    required this.submission,
    required this.assignment,
  });

  final AssignmentSubmissionModel submission;
  final AssignmentModel? assignment;

  @override
  State<SubmissionSubmitScreen> createState() => _SubmissionSubmitScreenState();
}

class _SubmissionSubmitScreenState extends State<SubmissionSubmitScreen> {
  final _textController = TextEditingController();

  // Multi-photo state: list of {path, name}
  final List<Map<String, String>> _photos = [];
  static const int _maxPhotos = 10;

  // Optional document attachment (PDF, doc, etc.)
  String? _docPath;
  String? _docName;

  bool _submitting = false;
  bool _compressing = false;

  AssignmentSubmissionModel get sub => widget.submission;
  AssignmentModel? get asgn => widget.assignment;
  String get _submType => asgn?.submissionType ?? 'Both';

  @override
  void initState() {
    super.initState();
    _textController.text = sub.submissionText;
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  // ── Image Compression ─────────────────────────────────────────────────────

  Future<String?> _compressImage(String sourcePath) async {
    try {
      final dir = await getTemporaryDirectory();
      final ts = DateTime.now().millisecondsSinceEpoch;
      final targetPath = '${dir.path}/compressed_${ts}_${_photos.length}.jpg';

      final result = await FlutterImageCompress.compressAndGetFile(
        sourcePath,
        targetPath,
        quality: 70,
        minWidth: 1920,
        minHeight: 1080,
        format: CompressFormat.jpeg,
      );

      if (result != null) {
        final originalSize = File(sourcePath).lengthSync();
        final compressedSize = File(result.path).lengthSync();
        final saved =
            ((1 - compressedSize / originalSize) * 100).toStringAsFixed(0);
        debugPrint(
            '📸 Compressed: ${_formatBytes(originalSize)} → ${_formatBytes(compressedSize)} ($saved% saved)');
        return result.path;
      }
    } catch (e) {
      debugPrint('Compression failed for $sourcePath: $e');
    }
    return sourcePath; // Fallback to original
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '${bytes}B';
    if (bytes < 1048576) return '${(bytes / 1024).toStringAsFixed(1)}KB';
    return '${(bytes / 1048576).toStringAsFixed(1)}MB';
  }

  // ── Pickers ───────────────────────────────────────────────────────────────

  Future<void> _pickCamera() async {
    if (_photos.length >= _maxPhotos) {
      Utils.toast('Maximum $_maxPhotos photos allowed.', color: Colors.orange);
      return;
    }
    final XFile? img =
        await ImagePicker().pickImage(source: ImageSource.camera);
    if (img == null) return;

    setState(() => _compressing = true);
    final compressed = await _compressImage(img.path);
    if (compressed != null && mounted) {
      setState(() {
        _photos.add({'path': compressed, 'name': img.name});
        _compressing = false;
      });
    }
  }

  Future<void> _pickGallery() async {
    final remaining = _maxPhotos - _photos.length;
    if (remaining <= 0) {
      Utils.toast('Maximum $_maxPhotos photos allowed.', color: Colors.orange);
      return;
    }

    final List<XFile> images = await ImagePicker().pickMultiImage();
    if (images.isEmpty) return;

    final toProcess =
        images.length > remaining ? images.sublist(0, remaining) : images;
    if (images.length > remaining) {
      Utils.toast(
          'Selected ${images.length} but only $remaining slots left. Taking first $remaining.',
          color: Colors.orange);
    }

    setState(() => _compressing = true);
    for (final img in toProcess) {
      final compressed = await _compressImage(img.path);
      if (compressed != null && mounted) {
        setState(() {
          _photos.add({'path': compressed, 'name': img.name});
        });
      }
    }
    if (mounted) setState(() => _compressing = false);
  }

  Future<void> _pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'docx',
        'xls',
        'xlsx',
        'ppt',
        'pptx',
        'txt'
      ],
    );
    if (result != null && result.files.isNotEmpty) {
      setState(() {
        _docPath = result.files.first.path;
        _docName = result.files.first.name;
      });
    }
  }

  void _removePhoto(int index) {
    setState(() => _photos.removeAt(index));
  }

  void _removeDocument() {
    setState(() {
      _docPath = null;
      _docName = null;
    });
  }

  // ── Submit ────────────────────────────────────────────────────────────────

  Future<void> _submit() async {
    final text = _textController.text.trim();
    final hasNewPhotos = _photos.isNotEmpty;
    final hasNewDoc = _docPath != null;
    final hasExistingDoc = sub.attachment.isNotEmpty;
    final hasExistingPhotos = sub.photos.isNotEmpty;
    final hasAnyFile =
        hasNewPhotos || hasNewDoc || hasExistingDoc || hasExistingPhotos;

    if (_submType == 'Text' && text.isEmpty) {
      Utils.toast('Please type your answer.', color: Colors.red);
      return;
    }
    if (_submType == 'File' && !hasAnyFile) {
      Utils.toast('Please attach a file or take photos.', color: Colors.red);
      return;
    }
    if (_submType == 'Both' && text.isEmpty && !hasAnyFile) {
      Utils.toast('Please type your answer or attach files.',
          color: Colors.red);
      return;
    }

    setState(() => _submitting = true);
    final resp = await AssignmentApi.submitAssignment(
      submissionId: sub.id,
      submissionText: text,
      attachmentPath: _docPath,
      photoPaths: _photos.map((p) => p['path']!).toList(),
    );
    if (!mounted) return;
    setState(() => _submitting = false);

    if (resp.code == 1) {
      Utils.toast(
          resp.message.isEmpty ? 'Submitted successfully.' : resp.message);
      Navigator.pop(context);
      return;
    }
    Utils.toast(
      resp.message.isEmpty ? 'Failed to submit. Try again.' : resp.message,
      color: Colors.red,
    );
  }

  // ── Widgets ───────────────────────────────────────────────────────────────

  Widget _sectionLabel(String label, {String suffix = ''}) {
    return Row(children: [
      Container(
          width: 3,
          height: 14,
          color: AppColors.primary,
          margin: const EdgeInsets.only(right: 8)),
      Text(label.toUpperCase(),
          style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
              letterSpacing: 0.8)),
      if (suffix.isNotEmpty)
        Text(suffix,
            style:
                const TextStyle(fontSize: 11, color: AppColors.textSecondary)),
    ]);
  }

  Widget _attachTile({
    required String label,
    required IconData icon,
    required MaterialColor color,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 18),
          decoration: BoxDecoration(
            color: color.shade50,
            border: Border.all(color: color.shade100),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Icon(icon, size: 28, color: color.shade600),
              const SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: color.shade700)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _photoGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Counter & compression indicator
        Row(
          children: [
            Text('${_photos.length} / $_maxPhotos photos',
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary)),
            if (_compressing) ...[
              const SizedBox(width: 10),
              const SizedBox(
                  width: 12,
                  height: 12,
                  child: CircularProgressIndicator(strokeWidth: 2)),
              const SizedBox(width: 6),
              const Text('Compressing...',
                  style:
                      TextStyle(fontSize: 11, color: AppColors.textSecondary)),
            ],
          ],
        ),
        const SizedBox(height: 8),
        // Photo thumbnail grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
          ),
          itemCount: _photos.length,
          itemBuilder: (context, index) {
            final photo = _photos[index];
            return Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.file(
                    File(photo['path']!),
                    width: double.infinity,
                    height: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                // Remove button
                Positioned(
                  top: 4,
                  right: 4,
                  child: InkWell(
                    onTap: () => _removePhoto(index),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                          color: Colors.red.shade600, shape: BoxShape.circle),
                      child: const Icon(FeatherIcons.x,
                          size: 12, color: Colors.white),
                    ),
                  ),
                ),
                // Filename badge
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.7),
                            Colors.transparent
                          ]),
                      borderRadius: const BorderRadius.vertical(
                          bottom: Radius.circular(6)),
                    ),
                    child: Text(
                      photo['name'] ?? '',
                      style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _documentPreviewCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(FeatherIcons.file,
                size: 18, color: Colors.orange.shade700),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(_docName ?? 'Document selected',
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                const SizedBox(height: 2),
                const Text('Ready to submit',
                    style: TextStyle(fontSize: 11, color: AppColors.success)),
              ],
            ),
          ),
          InkWell(
            onTap: _removeDocument,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                  color: Colors.red.shade50, shape: BoxShape.circle),
              child: Icon(FeatherIcons.x, size: 14, color: Colors.red.shade600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _existingAttachmentsBadge() {
    final hasDoc = sub.attachment.isNotEmpty;
    final photoCount = sub.photos.length;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Icon(FeatherIcons.paperclip, size: 15, color: Colors.grey.shade500),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Previous files (replaced when you pick new ones)',
                    style: TextStyle(
                        fontSize: 11, color: AppColors.textSecondary)),
                const SizedBox(height: 2),
                Text(
                    [
                      if (hasDoc) sub.attachment.split('/').last,
                      if (photoCount > 0) '$photoCount photo(s)',
                    ].join(' · '),
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isOverdue = asgn != null &&
        asgn!.dueDate.isNotEmpty &&
        DateTime.tryParse(asgn!.dueDate)?.isBefore(DateTime.now()) == true;

    final isUpdate = sub.status != 'Pending';

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: Text(isUpdate ? 'Update Submission' : 'Submit Assignment',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700)),
      ),
      body: Column(
        children: [
          // ── Scrollable content ───────────────────────────────────────────
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Assignment info banner
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.05),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.15)),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          asgn?.title.isNotEmpty == true
                              ? asgn!.title
                              : 'Assignment #${sub.assignmentId}',
                          style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary),
                        ),
                        if (asgn?.subjectName.isNotEmpty == true) ...[
                          const SizedBox(height: 4),
                          Text(asgn!.subjectName,
                              style: const TextStyle(
                                  fontSize: 13,
                                  color: AppColors.textSecondary)),
                        ],
                        const SizedBox(height: 10),
                        Wrap(
                          spacing: 10,
                          runSpacing: 6,
                          children: [
                            if (asgn != null && asgn!.dueDate.isNotEmpty)
                              Row(mainAxisSize: MainAxisSize.min, children: [
                                Icon(FeatherIcons.clock,
                                    size: 13,
                                    color: isOverdue
                                        ? Colors.red
                                        : AppColors.textSecondary),
                                const SizedBox(width: 4),
                                Text('Due: ${Utils.to_date_1(asgn!.dueDate)}',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: isOverdue
                                            ? Colors.red
                                            : AppColors.textSecondary,
                                        fontWeight: isOverdue
                                            ? FontWeight.w700
                                            : FontWeight.normal)),
                              ]),
                            if (isOverdue)
                              Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 3),
                                  color: Colors.red,
                                  child: const Text('OVERDUE',
                                      style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700))),
                            if (isUpdate)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(3),
                                ),
                                child: Text('Status: ${sub.status}',
                                    style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w600)),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // ── Text answer ──────────────────────────────────────────
                  if (_submType != 'File') ...[
                    const SizedBox(height: 24),
                    _sectionLabel('Your Answer',
                        suffix: _submType == 'Text'
                            ? ' *'
                            : '  (optional if attaching file)'),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _textController,
                      minLines: 5,
                      maxLines: 20,
                      textInputAction: TextInputAction.newline,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                        hintText: 'Type your answer here...',
                        border: const OutlineInputBorder(),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: AppColors.primary)),
                        contentPadding: const EdgeInsets.all(14),
                      ),
                    ),
                  ],

                  // ── Attachment ───────────────────────────────────────────
                  if (_submType != 'Text') ...[
                    // ── Photos Section ──────────────────────────────────
                    const SizedBox(height: 24),
                    _sectionLabel('Photos',
                        suffix: ' (up to $_maxPhotos, auto-compressed)'),
                    const SizedBox(height: 10),
                    Row(children: [
                      _attachTile(
                          label: 'Camera',
                          icon: FeatherIcons.camera,
                          color: Colors.deepPurple,
                          onTap: _pickCamera),
                      const SizedBox(width: 10),
                      _attachTile(
                          label: 'Gallery',
                          icon: FeatherIcons.image,
                          color: Colors.blue,
                          onTap: _pickGallery),
                    ]),
                    const SizedBox(height: 12),
                    if (_photos.isNotEmpty) _photoGrid(),

                    // ── Document Section ────────────────────────────────
                    const SizedBox(height: 20),
                    _sectionLabel('Document',
                        suffix: '  (optional — PDF, Word, etc.)'),
                    const SizedBox(height: 10),
                    Row(children: [
                      _attachTile(
                          label: 'Pick Document',
                          icon: FeatherIcons.file,
                          color: Colors.orange,
                          onTap: _pickDocument),
                      const Spacer(),
                    ]),
                    const SizedBox(height: 12),
                    if (_docPath != null)
                      _documentPreviewCard()
                    else if (sub.attachment.isNotEmpty || sub.photos.isNotEmpty)
                      _existingAttachmentsBadge(),
                  ],

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),

          // ── Sticky submit button ─────────────────────────────────────────
          Container(
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(
                16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(),
                  elevation: 0,
                ),
                onPressed: _submitting ? null : _submit,
                icon: _submitting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                            strokeWidth: 2, color: Colors.white))
                    : const Icon(FeatherIcons.send, size: 18),
                label: Text(
                  _submitting
                      ? 'Submitting...'
                      : (isUpdate ? 'Update Submission' : 'Submit Assignment'),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
