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
import 'package:schooldynamics/sections/widgets.dart';

import '../../models/SessionLocal.dart';
import '../../models/TemporaryModel.dart';
import '../../models/UserMiniModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../classes/StreamsScreen.dart';
import '../finance/ServicesScreen.dart';
import 'SessionRollCallingScreen.dart';

class SessionCreateNewScreen extends StatefulWidget {
  final dynamic data;

  const SessionCreateNewScreen({
    super.key,
    this.data,
  });

  @override
  _SessionCreateNewScreenState createState() => _SessionCreateNewScreenState();
}

class _SessionCreateNewScreenState extends State<SessionCreateNewScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  SessionLocal item = SessionLocal();
  List<MyClasses> selectedClasses = [];
  List<TheologyClassModel> selectedTheologyClasses = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  List<MySubjects> my_subjects = [];
  List<StreamModel> allStreams = [];

  Future<void> init() async {
    allStudents = await UserMiniModel.getItems();
    if (allStudents.length < 3) {
      await UserMiniModel.getOnlineData();
      allStudents = await UserMiniModel.getItems();
      if (allStudents.length < 3) {
        Utils.toast(
            "No students found. Please connect to the internet and try again.",
            color: CustomTheme.red);
      }
    }
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
  List<UserMiniModel> allStudents = [];

  Future<void> submit_form({
    bool announceChanges = false,
    bool askReset = false,
  }) async {
    if (!_formKey.currentState!.validate()) {
      Utils.toast("Please first fix errors.");
      return;
    }

    item.due_date =
        Utils.to_str(_formKey.currentState?.fields['date']?.value, '');
    if (item.due_date.isEmpty) {
      Utils.toast('Select date');
      return;
    }
    Utils.showLoader(true);

    if (allStudents.length < 5) {
      Utils.toast("Please wait...");
      await init();
      allStudents = await UserMiniModel.getItems();
      if (allStudents.length < 5) {
        Utils.toast(
            "No students found. Please connect to the internet and try again.",
            color: CustomTheme.red);
        Utils.hideLoader();
        return;
      }
    } else {
      UserMiniModel.getOnlineData();
      allStudents = await UserMiniModel.getItems();
    }

    if (item.type.isEmpty) {
      Utils.toast("Please select roll-call type.");
      Utils.hideLoader();
      return;
    }
    if (item.target.isEmpty) {
      Utils.toast("Please select roll-call target.");
      Utils.hideLoader();
      return;
    }

    List<Map<String, dynamic>> items = [];
    try {
      if (item.target == 'ENTIRE_SCHOOL') {
        for (var student in allStudents) {
          TemporaryModel x = TemporaryModel();
          x.id = Utils.int_parse(student.id.toString());
          x.title = student.name;
          x.image = student.avatar;
          x.details = student.user_number;
          items.add(x.toJson());
        }
      } else if (item.target == 'SECULAR_CLASSES') {
        if (selectedClasses.isEmpty) {
          Utils.toast("Please select classes.");
          return;
        }
        List<String> classIds = [];
        for (var selectedClass in selectedClasses) {
          classIds.add(selectedClass.id.toString());
        }
        item.secular_casses = json.encode(classIds);
        for (var student in allStudents) {
          if (classIds.contains(student.class_id.toString())) {
            TemporaryModel x = TemporaryModel();
            x.id = Utils.int_parse(student.id.toString());
            x.title = student.name;
            x.image = student.avatar;
            x.details = student.user_number;
            items.add(x.toJson());
          }
        }
      } else if (item.target == 'THEOLOGY_CLASSES') {
        if (selectedTheologyClasses.isEmpty) {
          Utils.toast("Please select theology classes.");
          return;
        }
        List<String> classIds = [];
        for (var selectedClass in selectedTheologyClasses) {
          classIds.add(selectedClass.id.toString());
        }
        item.theology_classes = json.encode(classIds);
        for (var student in allStudents) {
          if (classIds.contains(student.theology_class_id.toString())) {
            TemporaryModel x = TemporaryModel();
            x.id = Utils.int_parse(student.id.toString());
            x.title = student.name;
            x.image = student.avatar;
            x.details = student.user_number;
            items.add(x.toJson());
          }
        }
      } else if (item.target == 'SECULAR_STREAM') {
        if (item.stream_id.isEmpty || Utils.int_parse(item.stream_id) < 1) {
          Utils.toast("Please select secular stream.");
          return;
        }
        item.secular_stream_id = item.stream_id;
        if (item.secular_stream_id.isEmpty) {
          Utils.toast("Please select secular stream.");
          return;
        }
        for (var student in allStudents) {
          if (student.stream_id == item.stream_id) {
            TemporaryModel x = TemporaryModel();
            x.id = Utils.int_parse(student.id.toString());
            x.title = student.name;
            x.image = student.avatar;
            x.details = student.user_number;
            items.add(x.toJson());
          }
        }
      } else if (item.target == 'THEOLOGY_STREAM') {
        if (item.stream_id.isEmpty || Utils.int_parse(item.stream_id) < 1) {
          Utils.toast("Please select theology stream.");
          return;
        }
        item.theology_stream_id = item.stream_id;
        if (item.theology_stream_id.isEmpty) {
          Utils.toast("Please select theology stream.");
          return;
        }
        for (var student in allStudents) {
          if (student.theology_stream_id == item.stream_id) {
            TemporaryModel x = TemporaryModel();
            x.id = Utils.int_parse(student.id.toString());
            x.title = student.name;
            x.image = student.avatar;
            x.details = student.user_number;
            items.add(x.toJson());
          }
        }
      } else if (item.target == 'SERVICE') {
        if (item.service.id == 0) {
          Utils.toast("Please select service.");
          return;
        }
        item.service_text = item.service.name;
        item.service_id = item.service.id.toString();
        if (item.service_text.isEmpty) {
          Utils.toast("Please select service.");
          return;
        }
        if (item.service.id < 1) {
          Utils.toast("Please select service.");
          return;
        }
        item.service_id = item.service.id.toString();
        for (var student in allStudents) {
          if (student.services.isEmpty) {
            continue;
          }
          student.getServicesList();
          if (student.servicesList.contains(item.service.id.toString())) {
            TemporaryModel x = TemporaryModel();
            x.id = Utils.int_parse(student.id.toString());
            x.title = student.name;
            x.image = student.avatar;
            x.details = student.user_number;
            items.add(x.toJson());
          }
        }
      } else {
        Utils.toast("Invalid target selected.");
        Utils.hideLoader();
        return;
      }
    } catch (e) {
      Utils.hideLoader();
      Utils.toast("Error fetching students: $e", color: CustomTheme.red);
      return;
    } finally {
      Utils.hideLoader();
    }

    if (items.isEmpty) {
      Utils.toast("No students found for the selected criteria.",
          color: CustomTheme.red);
      Utils.hideLoader();
      return;
    }

    Utils.hideLoader();

    if (items.isEmpty) {
      Utils.toast("No student found.", color: CustomTheme.red);
      Utils.hideLoader();
      return;
    }

    //if target is SECULAR_CLASSES
    if (item.target == 'SECULAR_CLASSES') {
      if (item.secular_casses.length < 2) {
        Utils.toast("Please select classes.");
        return;
      }
    }

    //if target is THEOLOGY_CLASSES
    if (item.target == 'THEOLOGY_CLASSES') {
      if (item.theology_classes.length < 2) {
        Utils.toast("Please select theology classes.");
        return;
      }
    }

    item.expected = jsonEncode(items);
    item.present = '[]';
    item.closed = 'No';
    if (item.id < 1) {
      item.id = Random().nextInt(100000000);
    }

    if (item.title.isEmpty) {
      item.title = "${item.type}, ${item.target} - ${item.details}";
    }

    await item.save();
    Utils.toast("Session created successfully. Start roll-calling",
        color: CustomTheme.green);
    Utils.hideLoader();
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
        iconTheme: const IconThemeData(color: Colors.white),
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
                        decoration: AppTheme.InputDecorationTheme1(
                          label: "Roll-call type",
                        ),
                        onChanged: (x) {
                          String y = x.toString();
                          item.type = y;
                          item.title = y;
                          setState(() {});
                        },
                        dropdownColor: Colors.white,
                        items: const [
                          DropdownMenuItem(
                            value: 'STUDENT_REPORT',
                            child: Text('Student Report at School'),
                          ),
                          DropdownMenuItem(
                            value: 'STUDENT_LEAVE',
                            child: Text('Student Leave School'),
                          ),
                          DropdownMenuItem(
                            value: 'STUDENT_MEAL',
                            child: Text('Student Meals Session'),
                          ),
                          DropdownMenuItem(
                            value: 'CLASS_ATTENDANCE',
                            child: Text('Class attendance'),
                          ),
                          DropdownMenuItem(
                            value: 'THEOLOGY_ATTENDANCE',
                            child: Text('Theology Class attendance'),
                          ),
                          DropdownMenuItem(
                            value: 'ACTIVITY_ATTENDANCE',
                            child: Text('Activity participation'),
                          ),
                        ],
                        validator: FormBuilderValidators.required(
                          errorText: "Roll-call type is required",
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      FormBuilderDropdown<String>(
                        dropdownColor: Colors.white,
                        name: 'target',
                        decoration: AppTheme.InputDecorationTheme1(
                          label: "Target",
                        ),
                        onChanged: (x) {
                          item.target = x.toString();
                          item.academic_class_text = '';
                          item.stream_text = '';
                          item.service_text = '';

                          selectedClasses.clear();
                          _formKey.currentState!.patchValue({
                            'academic_class_text': '',
                            'stream_text': "",
                            'service_text': ''
                          });

                          setState(() {});
                        },
                        items: const [
                          DropdownMenuItem(
                            value: 'ENTIRE_SCHOOL',
                            child: Text('All active students'),
                          ),
                          DropdownMenuItem(
                            value: 'SECULAR_CLASSES',
                            child: Text('Specific secular classes'),
                          ),
                          DropdownMenuItem(
                            value: 'THEOLOGY_CLASSES',
                            child: Text('Specific theology classes'),
                          ),
                          DropdownMenuItem(
                            value: 'SECULAR_STREAM',
                            child: Text('Specific secular stream'),
                          ),
                          DropdownMenuItem(
                            value: 'THEOLOGY_STREAM',
                            child: Text('Specific theology stream'),
                          ),
                          DropdownMenuItem(
                            value: 'SERVICE',
                            child: Text('Specific service subscribers'),
                          ),
                        ],
                        validator: FormBuilderValidators.required(
                          errorText: "Target is required",
                        ),
                      ),
                      item.type == 'ACTIVITY_ATTENDANCE'
                          ? //enter title
                          Container(
                              margin: const EdgeInsets.only(bottom: 0, top: 15),
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
                      Visibility(
                        visible: ['SECULAR_CLASSES', 'THEOLOGY_CLASSES']
                            .contains(item.target),
                        child: Container(
                          margin: const EdgeInsets.only(top: 15),
                          child: FormBuilderTextField(
                            name: 'academic_class_text',
                            readOnly: true,
                            onTap: () async {
                              if (item.target == 'SECULAR_CLASSES') {
                                List<MyClasses>? classes = await Get.to(() =>
                                    ClassesScreen({
                                      'task': 'MultiSelect',
                                      'selectedItems': selectedClasses
                                    }));
                                if (classes == null) {
                                  Utils.toast("Please select classes.");
                                  return;
                                }

                                selectedClasses = [];

                                if (classes.runtimeType ==
                                    selectedClasses.runtimeType) {
                                  for (var x in classes) {
                                    selectedClasses.add(x);
                                  }
                                }

                                item.academic_class_text = '';
                                for (int i = 0;
                                    i < selectedClasses.length;
                                    i++) {
                                  item.academic_class_text +=
                                      selectedClasses[i].short_name;
                                  if (i != selectedClasses.length - 1) {
                                    item.academic_class_text += ", ";
                                  }
                                }

                                setState(() {});
                              } else if (item.target == 'THEOLOGY_CLASSES') {
                                List<TheologyClassModel>? myClasses =
                                    await Get.to(() => TheologyClassesScreen({
                                          'task': 'MultiSelect',
                                          'selectedItems':
                                              selectedTheologyClasses,
                                        }));

                                if (myClasses == null) {
                                  return;
                                }
                                selectedTheologyClasses = [];

                                if (myClasses.runtimeType ==
                                    selectedTheologyClasses.runtimeType) {
                                  for (var x in myClasses) {
                                    selectedTheologyClasses.add(x);
                                  }
                                }

                                item.academic_class_text = '';
                                for (int i = 0;
                                    i < selectedTheologyClasses.length;
                                    i++) {
                                  item.academic_class_text +=
                                      selectedTheologyClasses[i].short_name;
                                  if (i != selectedTheologyClasses.length - 1) {
                                    item.academic_class_text += ", ";
                                  }
                                }
                              }

                              item.title =
                                  "${item.type}, ${item.target} - ${item.academic_class_text}";
                              _formKey.currentState!.patchValue({
                                'academic_class_text': item.academic_class_text,
                                'stream_text': "",
                                'subject_text': ""
                              });

                              setState(() {});
                            },
                            initialValue: item.academic_class_text,
                            textCapitalization: TextCapitalization.words,
                            keyboardType: TextInputType.name,
                            decoration: AppTheme.InputDecorationTheme1(
                                label:
                                    "Select ${item.target == 'SECULAR_CLASSES' ? "Classes" : "Theology Classes"}"),
                            validator: FormBuilderValidators.compose([
                              FormBuilderValidators.required(
                                errorText: "Classes are required",
                              ),
                            ]),
                          ),
                        ),
                      ),
                      (!['SECULAR_STREAM', 'THEOLOGY_STREAM']
                              .contains(item.target))
                          ? const SizedBox()
                          : Container(
                              margin: const EdgeInsets.only(top: 10),
                              child: FormBuilderTextField(
                                name: 'stream_text',
                                readOnly: true,
                                onTap: () async {
                                  if (item.target == 'SECULAR_STREAM') {
                                    StreamModel? obj = await Get.to(() =>
                                        StreamsScreen(item.academic_class_id));
                                    if (obj == null) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    item.stream_id = obj.id.toString();
                                    item.stream_text =
                                        "${obj.academic_class_text.toString()} - ${obj.name.toString()}";
                                    item.secularStreamModel = obj;
                                  } else if (item.target == 'THEOLOGY_STREAM') {
                                    TheologyStreamModel? obj = await Get.to(
                                        () => TheologyStreamsScreen(
                                            item.academic_class_id));
                                    if (obj == null) {
                                      Utils.toast("Please select class.");
                                      return;
                                    }
                                    item.stream_id = obj.id.toString();
                                    item.stream_text =
                                        "${obj.theology_class_text.toString()} - ${obj.name.toString()}";
                                    item.theologyStreamModel = obj;
                                  }

                                  item.title =
                                      "${item.type}, ${item.target} - ${item.stream_text}";
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
                      (!['SERVICE'].contains(item.target))
                          ? const SizedBox()
                          : Container(
                              margin: const EdgeInsets.only(top: 15),
                              child: FormBuilderTextField(
                                name: 'service_text',
                                readOnly: true,
                                onTap: () async {
                                  var resp = await Get.to(ServicesScreen(
                                      const {"task_picker": 'task_picker'}));

                                  if (resp.runtimeType ==
                                      item.service.runtimeType) {
                                    item.service = resp;

                                    item.title =
                                        "${item.type}, ${item.target} - ${item.service.name}";
                                    _formKey.currentState!.patchValue({
                                      'service_text': item.service.name,
                                    });
                                    setState(() {});
                                  }
                                },
                                initialValue: item.subject_text,
                                textCapitalization: TextCapitalization.words,
                                keyboardType: TextInputType.name,
                                decoration: AppTheme.InputDecorationTheme1(
                                  label: "Select Service",
                                ),
                                validator: FormBuilderValidators.compose([
                                  FormBuilderValidators.required(
                                    errorText: "Subject is required",
                                  ),
                                ]),
                              ),
                            ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 20, top: 15),
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
                        height: 10,
                      ),
                      FormBuilderTextField(
                        name: 'details',
                        initialValue: item.details,
                        maxLines: 3,
                        minLines: 1,
                        enableSuggestions: true,
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(fontSize: 14),
                        decoration: AppTheme.InputDecorationTheme1(
                          label: "Session Description",
                          hintText:
                              "Add more details about this session, like the reason for the roll-call, or specify the activity, etc.",
                        ),
                        validator: FormBuilderValidators.compose([
                          FormBuilderValidators.required(
                            errorText: "Session description is required",
                          ),
                        ]),
                        onChanged: (x) {
                          item.details = x.toString();
                        },
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
