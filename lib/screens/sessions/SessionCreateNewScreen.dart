/*
* File : Login
* Version : 1.0.0
* */

import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/MyClasses.dart';
import 'package:schooldynamics/models/MySubjects.dart';
import 'package:schooldynamics/models/StreamModel.dart';
import 'package:schooldynamics/models/TheologyClassModel.dart';
import 'package:schooldynamics/models/TheologyStreamModel.dart';
import 'package:schooldynamics/screens/classes/ClassesScreen.dart';
import 'package:schooldynamics/screens/classes/TheologyClassesScreen.dart';
import 'package:schooldynamics/screens/classes/TheologyStreamsScreen.dart';
import 'package:schooldynamics/screens/subjects/TheologySubjectsScreen.dart';
import 'package:schooldynamics/sections/widgets.dart';

import '../../models/SessionLocal.dart';
import '../../models/TemporaryModel.dart';
import '../../models/TheologySubjectModel.dart';
import '../../models/UserMiniModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../classes/StreamsScreen.dart';
import '../subjects/SubjectsScreen.dart';
import 'SessionRollCallingScreen.dart';

class SessionCreateNewScreen extends StatefulWidget {
  final dynamic data;

  SessionCreateNewScreen({
    Key? key,
    this.data,
  }) : super(key: key);

  @override
  _SessionCreateNewScreenState createState() => _SessionCreateNewScreenState();
}

class _SessionCreateNewScreenState extends State<SessionCreateNewScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  SessionLocal item = SessionLocal();

  @override
  void initState() {
    init();
    super.initState();
  }

  List<MySubjects> my_subjects = [];
  List<StreamModel> allStreams = [];

  init() async {
    if (widget.data.runtimeType.toString() == 'MyClasses') {
      classModel = widget.data;
      item.type = 'Class attendance';
      item.title = classModel.name;
      item.academic_class_id = classModel.id.toString();

      subs.clear();
      my_subjects = await MySubjects.getItems();
      allStreams = await StreamModel.get_items();

      streams.clear();
      for (StreamModel element in allStreams) {
        if (element.academic_class_id.toString() == classModel.id.toString()) {
          streams.add(element.name);
        }
      }

      for (MySubjects element in my_subjects) {
        if (element.academic_class_id.toString() == classModel.id.toString()) {
          subs.add("${element.subject_name} - ${element.name}");
        }
      }
    }
    setState(() {});
  }

  List<String> subs = [];
  List<String> streams = [];

  MyClasses classModel = MyClasses();

  Future<void> submit_form({
    bool announceChanges = false,
    bool askReset = false,
  }) async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }

    if (['CLASS_ATTENDANCE', 'THEOLOGY_ATTENDANCE'].contains(item.type)) {
      if (item.stream_id.isEmpty) {
        Utils.toast("Please select stream.");
        return;
      }
      if (Utils.int_parse(item.stream_id) < 1) {
        Utils.toast("Please select stream.");
        return;
      }

      if (item.subject_id.isEmpty) {
        Utils.toast('Select subject');
        return;
      }
    } else if (item.type == 'ACTIVITY_ATTENDANCE') {
      if (item.title.isEmpty) {
        Utils.toast('Enter title');
        return;
      }
    } else {
      item.title = item.type;
      setState(() {});
    }

    item.due_date =
        Utils.to_str(_formKey.currentState?.fields['date']?.value, '');
    if (item.due_date.isEmpty) {
      Utils.toast('Select date');
      return;
    }

    Utils.showLoader(true);
    List<Map<String, dynamic>> items = [];

    if (item.type == 'CLASS_ATTENDANCE') {
      item.title =
          "${item.academic_class_text} - ${item.stream_text} - ${item.subject_text} - ${Utils.to_date(item.due_date)}";
      List<UserMiniModel> students =
          await classModel.getStudents(item.academic_class_id.toString());
      for (var student in students) {
        if (student.stream_id == item.stream_id) {
          TemporaryModel x = TemporaryModel();
          x.id = Utils.int_parse(student.id.toString());
          x.title = student.name;
          x.image = student.avatar;
          x.details = student.user_number;
          items.add(x.toJson());
        }
      }
    } else if (item.type == 'THEOLOGY_ATTENDANCE') {
      item.title =
          "${item.academic_class_text} - ${item.stream_text} - ${item.subject_text} - ${Utils.to_date(item.due_date)}";
      List<UserMiniModel> students = await UserMiniModel.getItems(
          where: " theology_stream_id = ${item.stream_id} ");
      for (var student in students) {
        TemporaryModel x = TemporaryModel();
        x.id = Utils.int_parse(student.id.toString());
        x.title = student.name;
        x.image = student.avatar;
        x.details = student.user_number;
        items.add(x.toJson());
      }
    } else {
      List<UserMiniModel> students = await UserMiniModel.getItems();
      for (var student in students) {
        TemporaryModel x = TemporaryModel();
        x.id = Utils.int_parse(student.id.toString());
        x.title = student.name;
        x.image = student.avatar;
        x.details = student.user_number;
        items.add(x.toJson());
      }
    }
    Utils.hideLoader();

    if (items.isEmpty) {
      Utils.toast("No student found.", color: CustomTheme.red);
      return;
    }

    item.expected = jsonEncode(items);
    item.present = '[]';
    item.closed = 'No';
    if (item.id < 1) {
      item.id = Random().nextInt(10000000);
    }
    await item.save();
    Get.off(() => SessionRollCallingScreen(data: item));
    return;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleMedium(
          "Creating new roll-call",
          color: Colors.white,
          fontWeight: 800,
        ),
      ),
      body: ListView(
        children: [
          Container(
              color: Colors.white,
              padding:
                  EdgeInsets.only(left: MySize.size16, right: MySize.size16),
              child: FormBuilder(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MySize.size10,
                      left: MySize.size5,
                      right: MySize.size5,
                      bottom: MySize.size10),
                  child: Column(
                    children: <Widget>[
                      FormBuilderDropdown<String>(
                        name: 'type',
                        dropdownColor: Colors.white,
                        decoration: AppTheme.InputDecorationTheme1(
                          label: "Roll-call type",
                        ),
                        onChanged: (x) {
                          String y = x.toString();
                          item.type = y;
                          item.title = y;

                          setState(() {});
                        },
                        isDense: true,
                        items: const [
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: 'CLASS_ATTENDANCE',
                            child: Text('Secular Class attendance'),
                          ),
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: 'THEOLOGY_ATTENDANCE',
                            child: Text('Theology Class attendance'),
                          ),
                          /* DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: 'SECONDARY_CLASS_ATTENDANCE',
                            child: Text('Secondary Class attendance'),
                          ),*/
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: 'STUDENT_REPORT',
                            child: Text('Student Report at School'),
                          ),
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: 'STUDENT_LEAVE',
                            child: Text('Student Leave School'),
                          ),
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: 'STUDENT_MEAL',
                            child: Text('Student Meals Session'),
                          ),
                          DropdownMenuItem(
                            alignment: AlignmentDirectional.centerStart,
                            value: 'ACTIVITY_ATTENDANCE',
                            child: Text('Activity Roll-call'),
                          ),
                        ],
                      ),
                      item.type == 'ACTIVITY_ATTENDANCE'
                          ? //enter title
                          Container(
                              margin: EdgeInsets.only(bottom: 0, top: 15),
                              child: FormBuilderTextField(
                                name: 'title',
                                initialValue: item.title,
                                enableSuggestions: true,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                onChanged: (x) {
                                  item.title = x.toString();
                                },
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Enter Title",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Title is required",
                                  ),
                                ]),
                              ),
                            )
                          : const SizedBox(),
                      (!['CLASS_ATTENDANCE', 'THEOLOGY_ATTENDANCE']
                              .contains(item.type))
                          ? const SizedBox()
                          : Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: FormBuilderTextField(
                                name: 'academic_class_text',
                                readOnly: true,
                                onTap: () async {
                                  if (item.type == 'CLASS_ATTENDANCE') {
                                    MyClasses? myClass = await Get.to(() =>
                                        ClassesScreen(
                                            const {'task': 'Select'}));
                                    if (myClass == null) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    item.academic_class_id =
                                        myClass.id.toString();
                                    item.academic_class_text =
                                        myClass.short_name.toString();
                                  } else if (item.type ==
                                      'THEOLOGY_ATTENDANCE') {
                                    TheologyClassModel? myClass = await Get.to(
                                        () => TheologyClassesScreen(
                                            const {'task': 'Select'}));
                                    if (myClass == null) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    item.academic_class_id =
                                        myClass.id.toString();
                                    item.academic_class_text =
                                        myClass.short_name.toString();
                                  }

                                  item.stream_text = "";
                                  item.stream_id = "";
                                  item.subject_text = "";
                                  item.subject_id = "";

                                  _formKey.currentState!.patchValue({
                                    'academic_class_text':
                                        item.academic_class_text,
                                    'stream_text': "",
                                    'subject_text': ""
                                  });
                                  setState(() {});
                                },
                                initialValue: item.academic_class_text,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Select Class",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Class is required",
                                  ),
                                ]),
                              ),
                            ),
                      (!['CLASS_ATTENDANCE', 'THEOLOGY_ATTENDANCE']
                              .contains(item.type))
                          ? const SizedBox()
                          : Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: FormBuilderTextField(
                                name: 'stream_text',
                                readOnly: true,
                                onTap: () async {
                                  print(item.type);
                                  if (item.type == 'CLASS_ATTENDANCE') {
                                    if (item.academic_class_id.isEmpty) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    StreamModel? obj = await Get.to(() =>
                                        StreamsScreen(item.academic_class_id));
                                    if (obj == null) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    item.stream_id = obj.id.toString();
                                    item.stream_text = obj.name.toString();
                                  } else if (item.type ==
                                      'THEOLOGY_ATTENDANCE') {
                                    if (item.academic_class_id.isEmpty) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    TheologyStreamModel? obj = await Get.to(
                                        () => TheologyStreamsScreen(
                                            item.academic_class_id));
                                    if (obj == null) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    item.stream_id = obj.id.toString();
                                    item.stream_text = obj.name.toString();
                                  }

                                  _formKey.currentState!.patchValue({
                                    'stream_text': item.stream_text,
                                  });
                                  setState(() {});
                                },
                                initialValue: item.academic_class_text,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Select Stream",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Stream is required",
                                  ),
                                ]),
                              ),
                            ),
                      (!['CLASS_ATTENDANCE', 'THEOLOGY_ATTENDANCE']
                              .contains(item.type))
                          ? const SizedBox()
                          : Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: FormBuilderTextField(
                                name: 'subject_text',
                                readOnly: true,
                                onTap: () async {
                                  if (item.type == 'CLASS_ATTENDANCE') {
                                    if (item.stream_text.isEmpty) {
                                      Utils.toast("Please stream");
                                      return;
                                    }
                                    MySubjects? obj = await Get.to(() =>
                                        SubjectsScreen({
                                          'task': 'Select',
                                          'academic_class_id':
                                              item.academic_class_id
                                        }));
                                    if (obj == null) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    item.subject_id = obj.id.toString();
                                    item.subject_text =
                                        obj.subject_name.toString();
                                    Utils.toast(item.subject_text);
                                  } else if (item.type ==
                                      'THEOLOGY_ATTENDANCE') {
                                    if (item.stream_text.isEmpty) {
                                      Utils.toast("Please stream");
                                      return;
                                    }
                                    TheologySubjectModel? obj = await Get.to(
                                        () => TheologySubjectsScreen({
                                              'task': 'Select',
                                              'theology_class_id':
                                                  item.academic_class_id
                                            }));
                                    if (obj == null) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    item.subject_id = obj.id.toString();
                                    item.subject_text = obj.name.toString();
                                    Utils.toast(item.subject_text);
                                  }
                                  _formKey.currentState!.patchValue({
                                    'subject_text': item.subject_text,
                                  });
                                  setState(() {});
                                },
                                initialValue: item.subject_text,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Select Subject",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Subject is required",
                                  ),
                                ]),
                              ),
                            ),
                      Container(
                        margin: EdgeInsets.only(bottom: 20, top: 15),
                        child: FormBuilderDateTimePicker(
                          name: 'date',
                          initialEntryMode: DatePickerEntryMode.calendar,
                          initialValue: DateTime.now(),
                          inputType: InputType.both,
                          lastDate: DateTime.now(),
                          currentDate: DateTime.now(),
                          onChanged: (x) {
                            item.due_date = Utils.to_str(x, '');
                          },
                          keyboardType: TextInputType.datetime,
                          decoration: AppTheme.InputDecorationTheme1(
                            label: "Date",
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                              errorText: "Date",
                            ),
                          ]),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      alertWidget(error_message, 'success'),
                      onLoading
                          ? Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CircularProgressIndicator(
                                strokeWidth: 2.0,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    CustomTheme.primary),
                              ))
                          : FxButton.block(
                              onPressed: () {
                                submit_form();
                              },
                              padding:
                                  const EdgeInsets.fromLTRB(24, 24, 24, 24),
                              borderRadiusAll: 100,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(
                                    Icons.check,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Center(
                                      child: FxText.titleMedium(
                                    "START ROLL-CALLING",
                                    color: Colors.white,
                                    fontWeight: 700,
                                  )),
                                ],
                              ))
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
