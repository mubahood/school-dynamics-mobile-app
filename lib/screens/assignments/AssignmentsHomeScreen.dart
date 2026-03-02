import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:image_picker/image_picker.dart';
import 'package:schooldynamics/models/AssignmentApi.dart';
import 'package:schooldynamics/models/AssignmentModel.dart';
import 'package:schooldynamics/models/AssignmentSubmissionModel.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/MyClasses.dart';
import 'package:schooldynamics/models/MySubjects.dart';
import 'package:schooldynamics/design_system/design_system.dart';
import 'package:schooldynamics/utils/Utils.dart';
import 'package:schooldynamics/utils/my_widgets.dart';

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
    final textController =
        TextEditingController(text: submission.submissionText);
    XFile? selectedImage;

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
                    FxText.titleLarge('Submit Assignment', fontWeight: 700),
                    const SizedBox(height: 8),
                    FxText.bodyMedium(
                      assignment?.title.isNotEmpty == true
                          ? assignment!.title
                          : 'Assignment #${submission.assignmentId}',
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: textController,
                      minLines: 3,
                      maxLines: 6,
                      decoration: const InputDecoration(
                        labelText: 'Submission text',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final picker = ImagePicker();
                              final image = await picker.pickImage(
                                source: ImageSource.gallery,
                                imageQuality: 85,
                              );
                              if (image != null) {
                                setModalState(() {
                                  selectedImage = image;
                                });
                              }
                            },
                            icon: const Icon(FeatherIcons.image),
                            label: Text(selectedImage == null
                                ? 'Attach Image'
                                : selectedImage!.name),
                          ),
                        ),
                      ],
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
                          Utils.showLoader(true);
                          final resp = await AssignmentApi.submitAssignment(
                            submissionId: submission.id,
                            submissionText: textController.text.trim(),
                            attachmentPath: selectedImage?.path,
                          );
                          Utils.hideLoader();

                          if (resp.code == 1) {
                            Utils.toast(resp.message.isEmpty
                                ? 'Submission sent successfully.'
                                : resp.message);
                            if (!ctx.mounted) return;
                            Navigator.pop(ctx);
                            await my_init();
                            return;
                          }

                          Utils.toast(
                            resp.message.isEmpty
                                ? 'Failed to submit assignment.'
                                : resp.message,
                            color: Colors.red,
                          );
                        },
                        icon: const Icon(FeatherIcons.send),
                        label: const Text('Submit'),
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
                smallInfoChip('Due',
                    item.dueDate.isEmpty ? '-' : Utils.to_date_1(item.dueDate)),
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
                      PopupMenuItem(value: 'close', child: Text('Set Closed')),
                      PopupMenuItem(value: 'draft', child: Text('Set Draft')),
                      PopupMenuItem(
                          value: 'regenerate',
                          child: Text('Regenerate Submissions')),
                    ],
                  ),
                if (isStudent)
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
    );
  }

  Widget submissionCard(AssignmentSubmissionModel item) {
    final assignment = findAssignment(item.assignmentId);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                if (isStudent)
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
