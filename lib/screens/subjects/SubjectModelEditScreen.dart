import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/EmployeeModel.dart';
import 'package:schooldynamics/models/MainCourse.dart';
import 'package:schooldynamics/screens/classes/ClassesScreen.dart';
import 'package:schooldynamics/screens/employees/EmployeesScreen.dart';

import '../../models/MyClasses.dart';
import '../../models/RespondModel.dart';
import '../../models/SubjectModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import 'CoursesScreen.dart';

class SubjectModelEditScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  SubjectModelEditScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  SubjectModelEditScreenState createState() => SubjectModelEditScreenState();
}

class SubjectModelEditScreenState extends State<SubjectModelEditScreen>
    with SingleTickerProviderStateMixin {
  var initFuture;
  final _fKey = GlobalKey<FormBuilderState>();
  bool is_loading = false;
  String error_message = "";
  SubjectModel item = SubjectModel();

  bool isUpdating = false;

  Future<bool> init_form() async {
    if (widget.params['item'].runtimeType == item.runtimeType) {
      item = widget.params['item'];
      if (item.id > 0) {
        isUpdating = true;
      } else {
        isUpdating = false;
      }
    }
    return true;
  }

  @override
  void initState() {
    super.initState();
    initFuture = init_form();
  }

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      appBar: AppBar(
        title: FxText.titleMedium(
          isUpdating ? 'Edit Subject' : 'Add Subject',
          color: Colors.white,
          fontSize: 20,
          fontWeight: 700,
        ),
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: CustomTheme.primary,
        actions: [
          is_loading
              ? Padding(
                  padding: EdgeInsets.only(right: 20, top: 10, bottom: 10),
                  child: Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2.0,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                    ),
                  ),
                )
              : FxButton.text(
                  onPressed: () {
                    submit_form();
                  },
                  backgroundColor: Colors.white,
                  child: Icon(
                    FeatherIcons.check,
                    color: Colors.white,
                    size: 35,
                  ))
        ],
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return FormBuilder(
              key: _fKey,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Container(
                        padding: const EdgeInsets.only(
                          left: 15,
                          top: 10,
                          right: 15,
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 10),
                            error_message.isEmpty
                                ? const SizedBox()
                                : FxContainer(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    color: Colors.red.shade50,
                                    child: Text(
                                      error_message,
                                    ),
                                  ),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("Select Subject")
                                    .capitalize!,
                              ),
                              readOnly: true,
                              initialValue: item.subject_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "main_course_text",
                              enableSuggestions: true,
                              onTap: () async {
                                MainCourse? selectedItem = await Get.to(() =>
                                    MainCoursesScreen(
                                        const {'is_select': 'is_select'}));
                                if (selectedItem == null) {
                                  return;
                                }
                                item.course_id = selectedItem.id.toString();
                                item.main_course_id =
                                    selectedItem.id.toString();
                                item.main_course_text = selectedItem.name;
                                item.course_text = selectedItem.name;

                                _fKey.currentState!.patchValue({
                                  'main_course_text': item.main_course_text,
                                });

                                setState(() {});
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "academic_class_text is required.",
                                ),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("Select class").capitalize!,
                              ),
                              readOnly: true,
                              initialValue: item.academic_class_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "academic_class_text",
                              enableSuggestions: true,
                              onTap: () async {
                                MyClasses? myClass = await Get.to(() =>
                                    ClassesScreen(const {'task': 'Select'}));
                                if (myClass == null) {
                                  return;
                                }
                                item.academic_class_id = myClass.id.toString();
                                item.academic_class_text = myClass.name;

                                _fKey.currentState!.patchValue({
                                  'academic_class_text':
                                      item.academic_class_text,
                                });

                                setState(() {});
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "academic_class_text is required.",
                                ),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("subject - Main teacher *")
                                        .capitalize!,
                              ),
                              readOnly: true,
                              onTap: () async {
                                EmployeeModel? x = await Get.to(() =>
                                    EmployeesScreen(
                                        const {'task_picker': 'task_picker'}));
                                if (x == null) {
                                  return;
                                }
                                item.subject_teacher = x.id.toString();
                                item.teacher_name = x.name.toString();
                                _fKey.currentState!.patchValue({
                                  'teacher_name': item.teacher_name,
                                });
                                setState(() {});
                              },
                              initialValue: item.teacher_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "teacher_name",
                              enableSuggestions: true,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "subject_teacher is required.",
                                ),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("Teacher - 2 (Optional)")
                                    .capitalize!,
                              ),
                              readOnly: true,
                              onTap: () async {
                                EmployeeModel? x = await Get.to(() =>
                                    EmployeesScreen(
                                        const {'task_picker': 'task_picker'}));
                                if (x == null) {
                                  return;
                                }
                                item.teacher_1 = x.id.toString();
                                item.teacher_1_name = x.name.toString();
                                _fKey.currentState!.patchValue({
                                  'teacher_1_name': item.teacher_1_name,
                                });
                                setState(() {});
                              },
                              initialValue: item.teacher_1_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "teacher_1_name",
                              enableSuggestions: true,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("Teacher - 3 (Optional)")
                                    .capitalize!,
                              ),
                              readOnly: true,
                              onTap: () async {
                                EmployeeModel? x = await Get.to(() =>
                                    EmployeesScreen(
                                        const {'task_picker': 'task_picker'}));
                                if (x == null) {
                                  return;
                                }
                                item.teacher_2 = x.id.toString();
                                item.teacher_2_name = x.name.toString();
                                _fKey.currentState!.patchValue({
                                  'teacher_2_name': item.teacher_2_name,
                                });
                                setState(() {});
                              },
                              initialValue: item.teacher_2_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "teacher_2_name",
                              enableSuggestions: true,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("Teacher - 4 (Optional)")
                                    .capitalize!,
                              ),
                              readOnly: true,
                              onTap: () async {
                                EmployeeModel? x = await Get.to(() =>
                                    EmployeesScreen(
                                        const {'task_picker': 'task_picker'}));
                                if (x == null) {
                                  return;
                                }
                                item.teacher_3 = x.id.toString();
                                item.teacher_3_name = x.name.toString();
                                _fKey.currentState!.patchValue({
                                  'teacher_3_name': item.teacher_3_name,
                                });
                                setState(() {});
                              },
                              initialValue: item.teacher_3_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "teacher_3_name",
                              enableSuggestions: true,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderRadioGroup(
                              decoration: CustomTheme.in_4(
                                hPadding: 0,
                                vPadding: 0,
                                label:
                                    GetStringUtils("Is this subject optional?")
                                        .capitalize!,
                              ),
                              name: 'is_optional',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "This field is required.",
                                ),
                              ]),
                              initialValue: item.is_optional,
                              onChanged: (val) {
                                item.is_optional = Utils.to_str(val, '');
                                setState(() {});
                              },
                              orientation: OptionsOrientation.horizontal,
                              options: const [
                                FormBuilderFieldOption(
                                  value: '1',
                                  child: Text(
                                    'Yes (Optional)',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                FormBuilderFieldOption(
                                  value: '0',
                                  child: Text(
                                    'No (Compulsory)',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            const SizedBox(height: 10),
                            FormBuilderRadioGroup(
                              decoration: CustomTheme.in_4(
                                hPadding: 0,
                                vPadding: 0,
                                label: GetStringUtils(
                                        "Show this subject in report cards?")
                                    .capitalize!,
                              ),
                              name: 'show_in_report',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "This field is required.",
                                ),
                              ]),
                              initialValue: item.show_in_report,
                              onChanged: (val) {
                                item.show_in_report = Utils.to_str(val, '');
                                setState(() {});
                              },
                              orientation: OptionsOrientation.horizontal,
                              options: const [
                                FormBuilderFieldOption(
                                  value: 'Yes',
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                FormBuilderFieldOption(
                                  value: 'No',
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            FormBuilderRadioGroup(
                              decoration: CustomTheme.in_4(
                                hPadding: 0,
                                vPadding: 0,
                                label: GetStringUtils("Grade this subject?")
                                    .capitalize!,
                              ),
                              name: 'grade_subject',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "This field is required.",
                                ),
                              ]),
                              initialValue: item.grade_subject,
                              onChanged: (val) {
                                item.grade_subject = Utils.to_str(val, '');
                                setState(() {});
                              },
                              orientation: OptionsOrientation.horizontal,
                              options: const [
                                FormBuilderFieldOption(
                                  value: 'Yes',
                                  child: Text(
                                    'Yes',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                                FormBuilderFieldOption(
                                  value: 'No',
                                  child: Text(
                                    'No',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  _keyboardVisible
                      ? SizedBox()
                      : FxContainer(
                          color: Colors.white,
                          borderRadiusAll: 0,
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          child: FxButton.block(
                              onPressed: () {
                                submit_form();
                              },
                              backgroundColor: CustomTheme.primary,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FxText.titleLarge(
                                    'SUBMIT',
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  const Icon(
                                    FeatherIcons.check,
                                    color: Colors.white,
                                    size: 35,
                                  )
                                ],
                              )))
                ],
              ),
            );
          }),
    );
  }

  bool _keyboardVisible = false;

  submit_form() async {
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    setState(() {
      error_message = "";
      is_loading = true;
    });

    RespondModel resp =
        RespondModel(await Utils.http_post('subject-create', item.toJson()));

    setState(() {
      error_message = "";
      is_loading = false;
    });

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      Utils.toast('Failed', color: Colors.red.shade700);
      return;
    }

    SubjectModel? s;
    try {
      s = SubjectModel.fromJson(resp.data);
    } catch (x) {
      Utils.toast("Saved but Failed to parse.");
      Navigator.pop(context);
      return;
    }
    if (s == null) {
      Utils.toast("Saved but did not manage to parse.");
      Navigator.pop(context);
      return;
    }
    if (s.id < 1) {
      Utils.toast("Saved but did not manage to parse.");
      Navigator.pop(context);
      return;
    }
    await s.save();

    Utils.toast(resp.message, color: Colors.green.shade700);

    Navigator.pop(context);
    return;
  }
}
