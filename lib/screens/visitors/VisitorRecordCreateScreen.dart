/*
* File : Login
* Version : 1.0.0
* */

import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:schooldynamics/models/UserMiniModel.dart';
import 'package:schooldynamics/models/VisitorModel.dart';

import '../../models/VisitorRecordModelLocal.dart';
import '../../theme/app_theme.dart';
import '../../utils/SignScreen.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../pickers/UsersPickerScreen.dart';

class VisitorRecordCreateScreen extends StatefulWidget {
  VisitorRecordModelLocal item;

  VisitorRecordCreateScreen(
    this.item, {
    super.key,
  });

  @override
  _VisitorRecordCreateScreenState createState() =>
      _VisitorRecordCreateScreenState();
}

class _VisitorRecordCreateScreenState extends State<VisitorRecordCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  bool onLoading = false;

  String error_message = "";
  List<FormBuilderChipOption> options = [
    const FormBuilderChipOption(
      value: 'Transport Route 1',
    ),
    const FormBuilderChipOption(
      value: 'Transport Route 2',
    ),
    const FormBuilderChipOption(
      value: 'Transport Route 3',
    ),
  ];

  @override
  void initState() {
    if (widget.item.local_id.length < 3) {
      widget.item.local_id =
          "${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(1000000)}-${Random().nextInt(1000000)}";
      widget.item.status = "In";
    }
    init();
    super.initState();
  }

  List<VisitorModel> visitors = [];
  List<String> teaching_methods = [
    "Explanation",
    "Discussion",
    "Demonstration",
    "Homework",
    "Quiz",
    "Test",
    "Examination",
    "Assignment",
    "Project",
    "Practical",
    "Field Trip",
    "Group Work",
    "Individual Work",
    "Pair Work",
    "Peer Work",
    "Research",
    "Case Study",
    "Problem Solving",
    "Role Play",
    "Simulation",
    "Brainstorming",
    "Debate",
    "Panel Discussion",
    "Symposium",
    "Workshop",
    "Seminar",
    "Conference",
  ];

  init() async {
    setState(() {});
    prepareVisitorsDisplay();
  }

  List<VisitorModel> visitorsDisplay = [];

  List<UserMiniModel> parents = [];
  bool parentsAdded = false;

  prepareVisitorsDisplay() async {
    if (visitors.length < 10) {
      visitors = await VisitorModel.get_items();
    }

    if (!parentsAdded) {
      parentsAdded = true;
      parents = await UserMiniModel.getItems(where: "user_type = 'parent'");
      for (UserMiniModel parent in parents) {
        VisitorModel p = VisitorModel();
        p.id = 0;
        p.name = parent.name;
        p.phone_number = parent.phone_number;
        if (visitors
            .where((element) => element.hasSameNumber(p.phone_number))
            .isEmpty) {
          visitors.add(p);
        }
      }
    }

    visitorsDisplay.clear();
    //filter visitors that are not in the list
    visitorsDisplay = visitors.where((element) {
      return element.isLikeSameNumber(widget.item.phone_number);
    }).toList();
    setState(() {});
  }

  bool _keyboardVisible = false;

  @override
  Widget build(BuildContext context) {
    _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        actions: [
          //done
          IconButton(
            icon: const Icon(
              Icons.check,
              size: 30,
            ),
            onPressed: () {
              if (!_formKey.currentState!.saveAndValidate()) {
                Utils.toast2("Fill all required fields",
                    background_color: CustomTheme.red);
                return;
              }

              do_submit();
            },
          )
        ],
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "New scheme-work item",
          color: Colors.white,
          fontWeight: 800,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        left: MySize.size16, right: MySize.size16),
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
                            const SizedBox(
                              height: 5,
                            ),
                            FormBuilderTextField(
                              name: 'phone_number',
                              initialValue: widget.item.phone_number,
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              readOnly: widget.item.isEdit,
                              onChanged: (x) {
                                widget.item.phone_number = x.toString();
                                prepareVisitorsDisplay();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Visitor's Phone Number",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Phone number is required",
                                ),
                              ]),
                            ),
                            visitorsDisplay.isEmpty
                                ? const SizedBox(
                                    height: 12,
                                  )
                                : SizedBox(
                                    height: 50,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: visitorsDisplay.length,
                                      itemBuilder: (context, index) {
                                        bool isSelected =
                                            (visitorsDisplay[index]
                                                .hasSameNumber(
                                                    widget.item.phone_number));
                                        return Container(
                                          margin:
                                              const EdgeInsets.only(right: 5),
                                          child: ChoiceChip(
                                            backgroundColor: isSelected
                                                ? CustomTheme.primary
                                                : Colors.white,
                                            label: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                FxText.bodySmall(
                                                  Utils.shortString(
                                                      visitorsDisplay[index]
                                                          .name,
                                                      12),
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: 600,
                                                  letterSpacing: .01,
                                                  height: 1,
                                                ),
                                                FxText.bodySmall(
                                                  height: 1,
                                                  visitorsDisplay[index]
                                                      .phone_number,
                                                  color: isSelected
                                                      ? Colors.white
                                                      : Colors.black,
                                                  fontWeight: 600,
                                                  letterSpacing: .01,
                                                ),
                                              ],
                                            ),
                                            side: BorderSide(
                                              color: CustomTheme.primary,
                                            ),
                                            selected: [].contains(
                                                visitorsDisplay[index]),
                                            padding: const EdgeInsets.all(0),
                                            onSelected: (bool selected) {
                                              setState(() {
                                                VisitorModel visitor =
                                                    visitorsDisplay[index];

                                                widget.item.visitor_id =
                                                    visitorsDisplay[index]
                                                        .id
                                                        .toString();
                                                widget.item.visitor_text =
                                                    visitorsDisplay[index].name;
                                                widget.item.name =
                                                    visitorsDisplay[index].name;
                                                widget.item.phone_number =
                                                    visitorsDisplay[index]
                                                        .phone_number;
                                                widget.item.email =
                                                    visitorsDisplay[index]
                                                        .email;

                                                _formKey.currentState!
                                                    .patchValue({
                                                  'phone_number':
                                                      visitor.phone_number,
                                                  'name': visitor.name,
                                                  'email': visitor.email,
                                                  'organization':
                                                      visitor.organization,
                                                  'address': visitor.address,
                                                  'nin': visitor.nin,
                                                });

                                                setState(() {});
                                              });
                                            },
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                            const SizedBox(
                              height: 5,
                            ),
                            FormBuilderTextField(
                              name: 'name',
                              readOnly: widget.item.isEdit,
                              keyboardType: TextInputType.name,
                              initialValue: widget.item.name,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.next,
                              onChanged: (x) {
                                widget.item.name = x.toString();
                                prepareVisitorsDisplay();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Visitor's Name",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Name is required",
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'address',
                              keyboardType: TextInputType.name,
                              initialValue: widget.item.address,
                              readOnly: widget.item.isEdit,
                              textCapitalization: TextCapitalization.words,
                              textInputAction: TextInputAction.done,
                              onChanged: (x) {
                                widget.item.address = x.toString();
                                prepareVisitorsDisplay();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Visitor's Address",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Address is required",
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderRadioGroup(
                              decoration: AppTheme.InputDecorationTheme1(
                                  hasPadding: false,
                                  label: "Purpose of visit",
                                  isDense: true),
                              name: 'purpose',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              initialValue: widget.item.purpose,
                              onChanged: (val) {
                                widget.item.purpose = Utils.to_str(val, '');
                                setState(() {});
                              },
                              orientation: OptionsOrientation.horizontal,
                              enabled: (!widget.item.isEdit),
                              validator: FormBuilderValidators.required(),
                              options: [
                                'Official',
                                'Staff',
                                'Student',
                                'Other',
                              ]
                                  .map((lang) => FormBuilderFieldOption(
                                        value: lang,
                                      ))
                                  .toList(growable: false),
                            ),

                            (widget.item.purpose != 'Official')
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderRadioGroup(
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                                hasPadding: false,
                                                label: "Select office",
                                                isDense: true),
                                        name: 'purpose_office',
                                        wrapRunSpacing: 0,
                                        wrapSpacing: 0,
                                        initialValue:
                                            widget.item.purpose_office,
                                        onChanged: (val) {
                                          widget.item.purpose_office =
                                              Utils.to_str(val, '');
                                          setState(() {});
                                        },
                                        validator:
                                            FormBuilderValidators.required(),
                                        options: [
                                          'HM',
                                          'D/HM',
                                          'Bursar',
                                          'D.O.S',
                                          'Other',
                                        ]
                                            .map((lang) =>
                                                FormBuilderFieldOption(
                                                  value: lang,
                                                ))
                                            .toList(growable: false),
                                      ),
                                    ],
                                  ),

                            widget.item.isEdit
                                ? const SizedBox()
                                : (widget.item.purpose != 'Staff')
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          /*UsersPickerScreen*/
                                          FormBuilderTextField(
                                            name: 'purpose_staff_text',
                                            keyboardType: TextInputType.name,
                                            initialValue:
                                                widget.item.purpose_staff_text,
                                            readOnly: true,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textInputAction:
                                                TextInputAction.next,
                                            onTap: () async {
                                              if (widget.item.isEdit == true) {
                                                return;
                                              }
                                              UserMiniModel? u = await Get.to(
                                                  () =>
                                                      UsersPickerScreen(const {
                                                        'title':
                                                            'Select staff member',
                                                        'user_type': 'employee',
                                                      }));
                                              if (u == null) {
                                                Utils.toast(
                                                    'User not selected.');
                                                return;
                                              }
                                              widget.item.purpose_staff_id =
                                                  u.id.toString();
                                              widget.item.purpose_staff_text =
                                                  u.name.toString();

                                              _formKey.currentState!
                                                  .patchValue({
                                                'purpose_staff_text': widget
                                                    .item.purpose_staff_text,
                                              });
                                            },
                                            decoration:
                                                AppTheme.InputDecorationTheme1(
                                              label: "Select staff member",
                                            ),
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(
                                                errorText:
                                                    "Staff member of visit is required",
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),

                            widget.item.isEdit
                                ? const SizedBox()
                                : (widget.item.purpose != 'Student')
                                    ? const SizedBox()
                                    : Column(
                                        children: [
                                          const SizedBox(
                                            height: 15,
                                          ),
                                          /*UsersPickerScreen*/
                                          FormBuilderTextField(
                                            name: 'purpose_student_text',
                                            keyboardType: TextInputType.name,
                                            initialValue: widget
                                                .item.purpose_student_text,
                                            readOnly: true,
                                            textCapitalization:
                                                TextCapitalization.words,
                                            textInputAction:
                                                TextInputAction.next,
                                            onTap: () async {
                                              if (widget.item.isEdit == true) {
                                                return;
                                              }
                                              UserMiniModel? u = await Get.to(
                                                  () =>
                                                      UsersPickerScreen(const {
                                                        'title':
                                                            'Select student',
                                                        'user_type': 'student',
                                                      }));
                                              if (u == null) {
                                                Utils.toast(
                                                    'User not selected.');
                                                return;
                                              }
                                              widget.item.purpose_student_id =
                                                  u.id.toString();
                                              widget.item.purpose_student_text =
                                                  u.name.toString();
                                              _formKey.currentState!
                                                  .patchValue({
                                                'purpose_student_text': widget
                                                    .item.purpose_student_text,
                                              });
                                            },
                                            decoration:
                                                AppTheme.InputDecorationTheme1(
                                              label: "Select student",
                                            ),
                                            validator:
                                                FormBuilderValidators.compose([
                                              FormBuilderValidators.required(
                                                errorText:
                                                    "Student of visit is required",
                                              ),
                                            ]),
                                          ),
                                        ],
                                      ),
                            const SizedBox(
                              height: 15,
                            ),

                            FormBuilderTextField(
                              name: 'purpose_description',
                              keyboardType: TextInputType.text,
                              initialValue: widget.item.purpose_description,
                              autocorrect: true,
                              enableSuggestions: true,
                              textCapitalization: TextCapitalization.sentences,
                              textInputAction: TextInputAction.done,
                              onChanged: (x) {
                                widget.item.purpose_description = x.toString();
                                prepareVisitorsDisplay();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Specify purpose of visit",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Purpose is required",
                                ),
                              ]),
                            ),
                            //check_in_time time
                            const SizedBox(
                              height: 15,
                            ),
                            (widget.item.isEdit)
                                ? const SizedBox()
                                : FormBuilderDateTimePicker(
                                    name: 'check_in_time',
                                    inputType: InputType.time,
                              onChanged: (x) {
                                widget.item.check_in_time = x.toString();
                              },
                              format: DateFormat("HH:mm"),
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Check-in time",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Check-in time is required",
                                ),
                              ]),
                            ),

                            (!widget.item.isEdit)
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderRadioGroup(
                                          decoration:
                                              AppTheme.InputDecorationTheme1(
                                                  hasPadding: false,
                                                  label:
                                                      "Check-in/Check-Out status",
                                                  isDense: true),
                                          name: 'status',
                                          wrapRunSpacing: 0,
                                          wrapSpacing: 0,
                                          initialValue:
                                              widget.item.status.isEmpty
                                                  ? 'In'
                                                  : widget.item.status,
                                          onChanged: (val) {
                                            widget.item.status =
                                                Utils.to_str(val, '');
                                            setState(() {});
                                          },
                                          orientation:
                                              OptionsOrientation.horizontal,
                                          validator:
                                              FormBuilderValidators.required(),
                                          options: [
                                            FormBuilderFieldOption(
                                              value: 'In',
                                              child: FxText.bodyMedium(
                                                "Check-in",
                                                color: Colors.black,
                                                fontWeight: 600,
                                              ),
                                            ),
                                            FormBuilderFieldOption(
                                              value: 'Out',
                                              child: FxText.bodyMedium(
                                                "Check-out",
                                                color: Colors.black,
                                                fontWeight: 600,
                                              ),
                                            ),
                                          ]),
                                      widget.item.status != 'Out'
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                FormBuilderDateTimePicker(
                                                  name: 'check_out_time',
                                                  inputType: InputType.time,
                                                  format: DateFormat("HH:mm"),
                                                  onChanged: (x) {
                                                    widget.item.check_out_time =
                                                        x.toString();
                                                  },
                                                  decoration: AppTheme
                                                      .InputDecorationTheme1(
                                                    label: "Check-out time",
                                                  ),
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators
                                                        .required(
                                                      errorText:
                                                          "Check-out time is required",
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),
                            const SizedBox(
                              height: 15,
                            ),

                            widget.item.isEdit
                                ? const SizedBox()
                                : widget.item.signature_path.length > 3
                                    ? FxContainer(
                                        border: Border.all(
                                          color: Colors.grey.shade700,
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          vertical: 5,
                                        ),

                                        width: double.infinity,
                                        bordered: true,
                                        //display image file
                                        child: Column(
                                          children: [
                                            Image.file(
                                              File(widget.item.signature_path),
                                              fit: BoxFit.contain,
                                              height: Get.width * .2,
                                              width: Get.width * .2,
                                            ),
                                            FxButton.text(
                                              child: FxText.bodyMedium(
                                                "Remove Signature",
                                                color: Colors.red,
                                                fontWeight: 900,
                                              ),
                                              onPressed: () async {
                                                File sigFile = File(
                                                    widget.item.signature_path);
                                                if (sigFile.existsSync()) {
                                                  sigFile.deleteSync();
                                                }
                                                widget.item.signature_path = "";
                                                setState(() {});
                                              },
                                            ),
                                          ],
                                        ),
                                      )
                                    : FxContainer(
                                        height: Get.width * .35,
                                        onTap: () async {
                                          String? signPath = await Get.to(
                                              () => const SignScreen());
                                          if (signPath == null ||
                                              signPath.isEmpty) {
                                            Utils.toast("Signature not saved");
                                            return;
                                          }
                                          File? signFile = File(signPath);
                                          if (!signFile.existsSync()) {
                                            Utils.toast("Signature not saved");
                                            return;
                                          }
                                          widget.item.signature_path = signPath;
                                          setState(() {});
                                        },
                                        border: Border.all(
                                          color: Colors.grey.shade700,
                                        ),
                                        bordered: true,
                                        child: Center(
                                          child: FxText.titleMedium(
                                            "Signature",
                                            color: Colors.black,
                                            fontWeight: 600,
                                          ),
                                        ),
                                      ),

                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderRadioGroup(
                              decoration: AppTheme.InputDecorationTheme1(
                                  hasPadding: false,
                                  label: "Add more information",
                                  isDense: true),
                              name: 'purpose_other',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              initialValue: widget.item.purpose_other.isEmpty
                                  ? 'No'
                                  : widget.item.purpose_other,
                              onChanged: (val) {
                                widget.item.purpose_other =
                                    Utils.to_str(val, '');
                                setState(() {});
                              },
                              orientation: OptionsOrientation.horizontal,
                              validator: FormBuilderValidators.required(),
                              options: [
                                'Yes',
                                'No',
                              ]
                                  .map((lang) => FormBuilderFieldOption(
                                        value: lang,
                                      ))
                                  .toList(growable: false),
                            ),

                            widget.item.purpose_other != 'Yes'
                                ? const SizedBox()
                                : Column(
                                    children: [
                                      //organization
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderTextField(
                                        name: 'organization',
                                        keyboardType: TextInputType.text,
                                        initialValue: widget.item.organization,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (x) {
                                          widget.item.organization =
                                              x.toString();
                                          prepareVisitorsDisplay();
                                        },
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label: "Visitor's Organization",
                                        ),
                                      ),
                                      //nin
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderTextField(
                                        name: 'nin',
                                        keyboardType: TextInputType.text,
                                        initialValue: widget.item.nin,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (x) {
                                          widget.item.nin = x.toString();
                                          prepareVisitorsDisplay();
                                        },
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label: "Visitor's NIN",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      //email
                                      FormBuilderTextField(
                                        name: 'email',
                                        keyboardType:
                                            TextInputType.emailAddress,
                                        initialValue: widget.item.email,
                                        textInputAction: TextInputAction.next,
                                        onChanged: (x) {
                                          widget.item.email = x.toString();
                                          prepareVisitorsDisplay();
                                        },
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                          label: "Visitor's Email Address",
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 15,
                                      ),
                                      FormBuilderRadioGroup(
                                        decoration:
                                            AppTheme.InputDecorationTheme1(
                                                hasPadding: false,
                                                label: "Has a vehicle",
                                                isDense: true),
                                        name: 'has_car',
                                        wrapRunSpacing: 0,
                                        wrapSpacing: 0,
                                        initialValue:
                                            widget.item.has_car.isEmpty
                                                ? 'No'
                                                : widget.item.has_car,
                                        onChanged: (val) {
                                          widget.item.has_car =
                                              Utils.to_str(val, '');
                                          setState(() {});
                                        },
                                        validator:
                                            FormBuilderValidators.required(),
                                        options: [
                                          'Yes',
                                          'No',
                                        ]
                                            .map((lang) =>
                                                FormBuilderFieldOption(
                                                  value: lang,
                                                ))
                                            .toList(growable: false),
                                      ),
                                      widget.item.has_car != 'Yes'
                                          ? const SizedBox()
                                          : Column(
                                              children: [
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                FormBuilderTextField(
                                                  name: 'car_reg',
                                                  keyboardType:
                                                      TextInputType.text,
                                                  initialValue:
                                                      widget.item.car_reg,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  textInputAction:
                                                      TextInputAction.next,
                                                  onChanged: (x) {
                                                    widget.item.car_reg =
                                                        x.toString();
                                                    prepareVisitorsDisplay();
                                                  },
                                                  decoration: AppTheme
                                                      .InputDecorationTheme1(
                                                    label:
                                                        "Car registration number",
                                                  ),
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators
                                                        .required(
                                                      errorText:
                                                          "Car registration number is required",
                                                    ),
                                                  ]),
                                                ),
                                              ],
                                            ),
                                    ],
                                  ),

                            const SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          _keyboardVisible
              ? const SizedBox()
              : FxContainer(
                  borderRadiusAll: 0,
                  child: FxButton.block(
                    onPressed: () {
                      if (!_formKey.currentState!.saveAndValidate()) {
                        Utils.toast2("Fill all required fields",
                            background_color: CustomTheme.red);
                        return;
                      }

                      do_submit();
                    },
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FxText.titleLarge(
                          "Save",
                          color: Colors.white,
                          fontWeight: 900,
                        ),
                        const SizedBox(
                          width: 15,
                        ),
                        const Icon(
                          Icons.check,
                          color: Colors.white,
                        ),
                      ],
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  myHorizontalList(List<String> list, Function onTap) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(right: 5),
            child: ChoiceChip(
              label: FxText.bodySmall(
                list[index],
                color: Colors.black,
                fontWeight: 600,
              ),
              side: BorderSide(
                color: CustomTheme.primary,
              ),
              selected: [].contains(list[index]),
              padding: const EdgeInsets.all(0),
              onSelected: (bool selected) {
                setState(() {
                  onTap(list[index]);
                });
              },
            ),
          );
        },
      ),
    );
  }

  void do_submit() async {
    error_message = "";

    if (!_formKey.currentState!.saveAndValidate()) {
      Utils.toast2("Fill all required fields",
          background_color: CustomTheme.red);
      return;
    }

    await widget.item.save();

    Utils.toast("Saved for later upload.");
    VisitorRecordModelLocal.submit_records();
    Navigator.pop(context);
  }
}
