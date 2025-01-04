import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/classes/ClassesScreen.dart';

import '../../models/RespondModel.dart';
import '../../models/SubjectModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

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
                                label:
                                    GetStringUtils("Select class").capitalize!,
                              ),
                              readOnly: true,
                              initialValue: item.academic_class_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "academic_class_text",
                              enableSuggestions: true,
                              onTap: () async {
                                await Get.to(() =>
                                    ClassesScreen(const {'task': 'Select'}));
                                setState(() {});
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "academic_class_text is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText:
                                        "academic_class_text is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText:
                                        "academic_class_text is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("subject teacher")
                                    .capitalize!,
                              ),
                              initialValue: item.subject_teacher,
                              textCapitalization: TextCapitalization.sentences,
                              name: "subject_teacher",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.subject_teacher = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "subject_teacher is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "subject_teacher is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "subject_teacher is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("code").capitalize!,
                              ),
                              initialValue: item.code,
                              textCapitalization: TextCapitalization.sentences,
                              name: "code",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.code = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "code is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "code is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "code is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("details").capitalize!,
                              ),
                              initialValue: item.details,
                              textCapitalization: TextCapitalization.sentences,
                              name: "details",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.details = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "details is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "details is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "details is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("course text").capitalize!,
                              ),
                              initialValue: item.course_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "course_text",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.course_text = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "course_text is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "course_text is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "course_text is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("subject name").capitalize!,
                              ),
                              initialValue: item.subject_name,
                              textCapitalization: TextCapitalization.sentences,
                              name: "subject_name",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.subject_name = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "subject_name is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "subject_name is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "subject_name is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("demo text").capitalize!,
                              ),
                              initialValue: item.demo_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "demo_text",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.demo_text = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "demo_text is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "demo_text is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "demo_text is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("is optional").capitalize!,
                              ),
                              initialValue: item.is_optional,
                              textCapitalization: TextCapitalization.sentences,
                              name: "is_optional",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.is_optional = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "is_optional is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "is_optional is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "is_optional is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("main course text")
                                    .capitalize!,
                              ),
                              initialValue: item.main_course_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "main_course_text",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.main_course_text = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "main_course_text is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText:
                                        "main_course_text is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "main_course_text is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("teacher 1").capitalize!,
                              ),
                              initialValue: item.teacher_1,
                              textCapitalization: TextCapitalization.sentences,
                              name: "teacher_1",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.teacher_1 = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "teacher_1 is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "teacher_1 is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "teacher_1 is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("teacher 2").capitalize!,
                              ),
                              initialValue: item.teacher_2,
                              textCapitalization: TextCapitalization.sentences,
                              name: "teacher_2",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.teacher_2 = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "teacher_2 is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "teacher_2 is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "teacher_2 is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("teacher 3").capitalize!,
                              ),
                              initialValue: item.teacher_3,
                              textCapitalization: TextCapitalization.sentences,
                              name: "teacher_3",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.teacher_3 = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "teacher_3 is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "teacher_3 is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "teacher_3 is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("parent course text")
                                    .capitalize!,
                              ),
                              initialValue: item.parent_course_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "parent_course_text",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.parent_course_text = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "parent_course_text is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText:
                                        "parent_course_text is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText:
                                        "parent_course_text is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("academic year text")
                                    .capitalize!,
                              ),
                              initialValue: item.academic_year_text,
                              textCapitalization: TextCapitalization.sentences,
                              name: "academic_year_text",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.academic_year_text = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "academic_year_text is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText:
                                        "academic_year_text is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText:
                                        "academic_year_text is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label: GetStringUtils("show in report")
                                    .capitalize!,
                              ),
                              initialValue: item.show_in_report,
                              textCapitalization: TextCapitalization.sentences,
                              name: "show_in_report",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.show_in_report = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "show_in_report is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "show_in_report is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "show_in_report is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
                            FormBuilderTextField(
                              decoration: CustomTheme.in_4(
                                label:
                                    GetStringUtils("grade subject").capitalize!,
                              ),
                              initialValue: item.grade_subject,
                              textCapitalization: TextCapitalization.sentences,
                              name: "grade_subject",
                              enableSuggestions: true,
                              onChanged: (x) {
                                item.grade_subject = x.toString();
                              },
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "grade_subject is required.",
                                ),
                                //min 4
                                FormBuilderValidators.minLength(3,
                                    errorText: "grade_subject is too short."),
                                //max 30
                                FormBuilderValidators.maxLength(100,
                                    errorText: "grade_subject is too long."),
                              ]),
                              textInputAction: TextInputAction.next,
                            ),
                            const SizedBox(height: 15),
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

    Utils.toast('Updating...', color: Colors.green.shade700);

    RespondModel resp = RespondModel(
        await Utils.http_post(SubjectModel.end_point, item.toJson()));

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

    Utils.toast('Successfully!');

    Navigator.pop(context);
    return;
  }
}
