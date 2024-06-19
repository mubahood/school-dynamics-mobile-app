/*
* File : Login
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';

import '../../models/RespondModel.dart';
import '../../models/SchemeWorkItemModel.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';

class SchemeItemWorkCreateScreen extends StatefulWidget {
  SchemeWorkItemModel item;

  SchemeItemWorkCreateScreen(
    this.item, {
    Key? key,
  }) : super(key: key);

  @override
  _SchemeItemWorkCreateScreenState createState() =>
      _SchemeItemWorkCreateScreenState();
}

class _SchemeItemWorkCreateScreenState
    extends State<SchemeItemWorkCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();

  final List<String> weeks = [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '10',
    '11',
    '12',
    '13',
    '14',
    '15',
    '16',
    '17',
    '18',
  ];
  bool onLoading = false;

  List<String> skills = [
    "Listening",
    "Speaking",
    "Reading",
    "Writing",
    "Critical thinking",
    "Effective communication",
    "Creative thinking",
    "Problem solving",
    "Collaboration",
    "Teamwork",
    "Leadership",
    "Adaptability",
    "Time management",
    "Organization",
    "Goal setting",
    "Decision making",
    "Stress management",
    "Conflict resolution",
    "Negotiation",
    "Networking",
    "Public speaking",
    "Presentation",
    "Research",
    "Data analysis",
    "Computer skills",
    "Technical skills",
    "Mathematical skills",
  ];
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
    init();
    super.initState();
  }

  List<String> topics = [];
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
    await widget.item.get_scheme_work_items_for_same_class();
    topics.clear();
    for (SchemeWorkItemModel x in widget.item.schemeWorkItemsForSameClass) {
      if (topics.contains(x.topic)) {
        continue;
      }
      topics.add(x.topic);
    }
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
                Utils.toast2("Fill all fields",
                    background_color: CustomTheme.red);
                return;
              }

              //validate direction
              if (widget.item.topic == '') {
                Utils.toast2("Select trip direction",
                    background_color: CustomTheme.red);
                return;
              }

              //validate teacher_status
              if (widget.item.teacher_status == 'Yes' &&
                  widget.item.teacher_comment == '') {
                Utils.toast2("Enter teacher comment",
                    background_color: CustomTheme.red);
                return;
              }

              do_submit();
            },
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
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
                              name: 'subject_text',
                              readOnly: true,
                              initialValue: widget.item.subject_text,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.name,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Subject",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Select subject",
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderDropdown(
                              name: 'week',
                              initialValue:
                                  weeks.contains(widget.item.week.toString())
                                      ? widget.item.week.toString()
                                      : null,
                              onChanged: (x) {
                                setState(() {
                                  widget.item.week = x.toString();
                                });
                              },
                              dropdownColor: Colors.grey.shade200,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Week",
                                hasPadding: true,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Title",
                                ),
                              ]),
                              items: weeks
                                  .map((x) => DropdownMenuItem(
                                        value: x,
                                        child: FxText.bodyLarge(
                                          "Week $x",
                                          color: Colors.black,
                                          fontWeight: 600,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderDropdown(
                              name: 'period',
                              initialValue:
                                  weeks.contains(widget.item.period.toString())
                                      ? widget.item.period.toString()
                                      : null,
                              onChanged: (x) {
                                setState(() {
                                  widget.item.period = x.toString();
                                });
                              },
                              dropdownColor: Colors.grey.shade200,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Periods",
                                hasPadding: true,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Periods",
                                ),
                              ]),
                              items: weeks
                                  .map((x) => DropdownMenuItem(
                                        value: x,
                                        child: FxText.bodyLarge(
                                          "$x Periods",
                                          color: Colors.black,
                                          fontWeight: 600,
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'topic',
                              initialValue: widget.item.topic,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.name,
                              autocorrect: true,
                              onChanged: (x) {
                                widget.item.topic = x.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Enter New Topic",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Topic is required",
                                ),
                              ]),
                            ),
                            topics.isEmpty
                                ? Container()
                                : Column(
                                    children: [
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      FxText.bodyMedium(
                                          "Or select from previous topics"),
                                      myHorizontalList(topics, (x) {
                                        _formKey.currentState!.patchValue(
                                            {'topic': x.toString()});
                                        //remove all focus
                                        FocusScope.of(context).unfocus();
                                      }),
                                    ],
                                  ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'competence',
                              initialValue: widget.item.competence.isEmpty
                                  ? "- "
                                  : widget.item.competence,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              autocorrect: true,
                              enableSuggestions: true,
                              textAlignVertical: TextAlignVertical.top,
                              onChanged: (x) {
                                widget.item.competence = x.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Competence",
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'methods',
                              initialValue: widget.item.methods.isEmpty
                                  ? "- "
                                  : widget.item.methods,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              autocorrect: true,
                              enableSuggestions: true,
                              textAlignVertical: TextAlignVertical.top,
                              onChanged: (x) {
                                widget.item.methods = x.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Teaching Methods",
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FxText.bodyMedium(
                                "Or Add Teaching Methods from the list below",
                                fontWeight: 600),
                            myHorizontalList(teaching_methods, (x) {
                              if (widget.item.methods.trim().length < 3) {
                                widget.item.methods = "- $x";
                              } else {
                                widget.item.methods += "\n - $x";
                              }
                              _formKey.currentState!
                                  .patchValue({'methods': widget.item.methods});
                              //remove all focus
                              FocusScope.of(context).unfocus();
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              name: 'skills',
                              initialValue: widget.item.skills.isEmpty
                                  ? "- "
                                  : widget.item.skills,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              autocorrect: true,
                              enableSuggestions: true,
                              textAlignVertical: TextAlignVertical.top,
                              onChanged: (x) {
                                widget.item.skills = x.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Skills",
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FxText.bodyMedium(
                                "Or Add Skills from the list below",
                                fontWeight: 600),
                            myHorizontalList(skills, (x) {
                              if (widget.item.skills.trim().length < 3) {
                                widget.item.skills = "- $x";
                              } else {
                                widget.item.skills += "\n - $x";
                              }
                              _formKey.currentState!
                                  .patchValue({'skills': widget.item.skills});
                              //remove all focus
                              FocusScope.of(context).unfocus();
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                            //suggested_activity
                            FormBuilderTextField(
                              name: 'suggested_activity',
                              initialValue:
                                  widget.item.suggested_activity.isEmpty
                                      ? "- "
                                      : widget.item.suggested_activity,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              autocorrect: true,
                              enableSuggestions: true,
                              textAlignVertical: TextAlignVertical.top,
                              onChanged: (x) {
                                widget.item.suggested_activity = x.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Suggested Activity",
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //instructional_material
                            FormBuilderTextField(
                              name: 'instructional_material',
                              initialValue:
                                  widget.item.instructional_material.isEmpty
                                      ? "- "
                                      : widget.item.instructional_material,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              autocorrect: true,
                              enableSuggestions: true,
                              textAlignVertical: TextAlignVertical.top,
                              onChanged: (x) {
                                widget.item.instructional_material =
                                    x.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Instructional Material",
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //references use FormBuilderTextField
                            FormBuilderTextField(
                              name: 'references',
                              initialValue: widget.item.references.isEmpty
                                  ? "- "
                                  : widget.item.references,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.multiline,
                              textInputAction: TextInputAction.newline,
                              autocorrect: true,
                              enableSuggestions: true,
                              textAlignVertical: TextAlignVertical.top,
                              onChanged: (x) {
                                widget.item.references = x.toString();
                                widget.item.references_1 = x.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "References",
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            FormBuilderRadioGroup(
                              name: 'teacher_status',
                              wrapRunSpacing: 0,
                              wrapSpacing: 0,
                              initialValue: widget.item.teacher_status,
                              onChanged: (val) {
                                widget.item.teacher_status =
                                    Utils.to_str(val, '');
                                setState(() {});
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Has the teacher completed this?",
                                hasPadding: false,
                              ),
                              orientation: OptionsOrientation.horizontal,
                              validator: FormBuilderValidators.required(),
                              options: [
                                'Pending',
                                'Skipped',
                                'Conducted',
                              ]
                                  .map((lang) => FormBuilderFieldOption(
                                        value: lang,
                                      ))
                                  .toList(growable: false),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            //if teacher_status yes, enter teacher_comment
                            widget.item.teacher_status == 'Conducted'
                                ? FormBuilderTextField(
                                    name: 'teacher_comment',
                                    initialValue: widget.item.teacher_comment,
                                    textCapitalization:
                                        TextCapitalization.sentences,
                                    keyboardType: TextInputType.multiline,
                                    textInputAction: TextInputAction.newline,
                                    autocorrect: true,
                                    enableSuggestions: true,
                                    textAlignVertical: TextAlignVertical.top,
                                    onChanged: (x) {
                                      widget.item.teacher_comment =
                                          x.toString();
                                    },
                                    decoration: AppTheme.InputDecorationTheme1(
                                      label: "Teacher's Remarks",
                                    ),
                                    minLines: 3,
                                    maxLines: 5,
                                  )
                                : const SizedBox(),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          _keyboardVisible
              ? const SizedBox()
              : Container(
                  padding: const EdgeInsets.only(
                    left: 15,
                    right: 15,
                    bottom: 10,
                  ),
                  child: Column(
                    children: [
                      error_message.isNotEmpty
                          ? FxContainer(
                              padding: const EdgeInsets.all(10),
                              margin: const EdgeInsets.only(bottom: 10),
                              borderRadiusAll: 10,
                              color: Colors.red.shade100,
                              child: FxText.bodyMedium(
                                error_message,
                                color: CustomTheme.red,
                                maxLines: 20,
                                fontWeight: 600,
                                overflow: TextOverflow.ellipsis,
                              ),
                            )
                          : const SizedBox(),
                      FxButton.block(
                          onPressed: () {
                            if (!_formKey.currentState!.saveAndValidate()) {
                              Utils.toast2("Fill all fields",
                                  background_color: CustomTheme.red);
                              return;
                            }

                            //validate direction
                            if (widget.item.topic == '') {
                              Utils.toast2("Select trip direction",
                                  background_color: CustomTheme.red);
                              return;
                            }

                            //validate teacher_status
                            if (widget.item.teacher_status == 'Yes' &&
                                widget.item.teacher_comment == '') {
                              Utils.toast2("Enter teacher comment",
                                  background_color: CustomTheme.red);
                              return;
                            }

                            do_submit();
                          },
                          padding: const EdgeInsets.fromLTRB(15, 15, 15, 15),
                          borderRadiusAll: 10,
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
                                "SAVE",
                                color: Colors.white,
                                fontWeight: 700,
                              )),
                            ],
                          )),
                    ],
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
              selected: widget.item.references.contains(list[index]),
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

    if (!(await Utils.is_connected())) {
      Utils.toast2("No internet connection", background_color: CustomTheme.red);
      return;
    }
    setState(() {
      error_message = '';
      onLoading = true;
    });

    Map<String, dynamic> data = widget.item.toJson();
    data['references'] = widget.item.references_1;
    data['references_1'] = widget.item.references_1;

    RespondModel? resp;
    try {
      resp = RespondModel(await Utils.http_post(
        'schemework-items-create',
        data,
      ));
    } catch (e) {
      error_message = e.toString();
      onLoading = false;
      setState(() {});
      return;
    }

    if (resp.code != 1) {
      error_message = resp.message;
      onLoading = false;
      setState(() {});
      return;
    }

    widget.item = SchemeWorkItemModel.fromJson(resp.data);
    if (widget.item.id < 1) {
      error_message = "Failed to save";
      onLoading = false;
      setState(() {});
      return;
    }
    await widget.item.save();
    Utils.toast2("Saved successfully", background_color: CustomTheme.green);
    Navigator.pop(context);
  }
}
