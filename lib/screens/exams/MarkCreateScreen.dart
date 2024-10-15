import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:schooldynamics/models/MarkRecordModel.dart';
import 'package:schooldynamics/models/RespondModel.dart';

import '../../models/TermlyReportCard.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';

//MarkCreateScreen
class MarkCreateScreen extends StatefulWidget {
  TermlyReportCard activeReportCard;
  MarkRecordModel mark;

  MarkCreateScreen(this.mark, this.activeReportCard, {super.key});

  @override
  MarkCreateScreenState createState() => MarkCreateScreenState();
}

class MarkCreateScreenState extends State<MarkCreateScreen> {
  Future<void> submit_form() async {
    init();
    return;
  }

  String error_message = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  final _formKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    // _keyboardVisible = MediaQuery.of(context).viewInsets.bottom != 0;

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
              do_submit();
            },
          )
        ],
        iconTheme: IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Updating Marks",
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
                            titleValueWidget2('EXAM',
                                "Term ${widget.activeReportCard.term_text} - ${widget.activeReportCard.getName(widget.activeReportCard.activeMarkSubmission())}"),
                            titleValueWidget2(
                                'STUDENT', (widget.mark.administrator_text)),
                            titleValueWidget2(
                                'CLASS', (widget.mark.academic_class_text)),
                            titleValueWidget2(
                                'SUBJECT', (widget.mark.subject_text)),
                            const SizedBox(
                              height: 10,
                            ),
                            Divider(
                              height: 2,
                              thickness: 2,
                              color: CustomTheme.primary,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            widget.activeReportCard.activeMarkSubmission() !=
                                    'B.O.T'
                                ? SizedBox()
                                : FormBuilderTextField(
                                    name: 'bot_score',
                                    onChanged: (value) {
                                      if (value.toString().isNotEmpty) {
                                        int max = int.parse(
                                            widget.activeReportCard.bot_max);
                                        if (int.parse(value.toString()) > max) {
                                          error_message =
                                              "Score cannot be more than 100";
                                          Utils.toast2(error_message,
                                              background_color:
                                                  CustomTheme.red);
                                          setState(() {});
                                          return;
                                        } else {
                                          error_message = "";
                                        }
                                        widget.mark.bot_score =
                                            value.toString();
                                      }
                                      setState(() {});
                                    },
                                    initialValue: widget.mark.bot_score == '0'
                                        ? ''
                                        : widget.mark.bot_score,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    decoration: AppTheme.InputDecorationTheme1(
                                      label:
                                          "Mid of Term - Score (MAX Score: ${widget.activeReportCard.bot_max})",
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText:
                                            "Enter Beginning of Term - Score",
                                      ),
                                      FormBuilderValidators.numeric(
                                        errorText:
                                            "Enter valid Beginning of Term - Score",
                                      ),
                                    ]),
                                  ),
                            widget.activeReportCard.activeMarkSubmission() !=
                                    'M.O.T'
                                ? SizedBox()
                                : FormBuilderTextField(
                                    name: 'mot_score',
                                    onChanged: (value) {
                                      if (value.toString().isNotEmpty) {
                                        int max = int.parse(
                                            widget.activeReportCard.mot_max);
                                        if (int.parse(value.toString()) > max) {
                                          error_message =
                                              "Score cannot be more than 100";
                                          Utils.toast2(error_message,
                                              background_color:
                                                  CustomTheme.red);
                                          setState(() {});
                                          return;
                                        } else {
                                          error_message = "";
                                        }
                                        widget.mark.mot_score =
                                            value.toString();
                                      }
                                      setState(() {});
                                    },
                                    initialValue: widget.mark.mot_score == '0'
                                        ? ''
                                        : widget.mark.mot_score,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    decoration: AppTheme.InputDecorationTheme1(
                                      label:
                                          "Mid of Term - Score (MAX Score: ${widget.activeReportCard.mot_max})",
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: "Enter Mid of Term - Score",
                                      ),
                                      FormBuilderValidators.numeric(
                                        errorText:
                                            "Enter valid Mid of Term - Score",
                                      ),
                                    ]),
                                  ),
                            widget.activeReportCard.activeMarkSubmission() !=
                                    'E.O.T'
                                ? SizedBox()
                                : FormBuilderTextField(
                                    name: 'eot_score',
                                    onChanged: (value) {
                                      if (value.toString().isNotEmpty) {
                                        int max = int.parse(
                                            widget.activeReportCard.eot_max);
                                        if (int.parse(value.toString()) > max) {
                                          error_message =
                                              "Score cannot be more than 100";
                                          Utils.toast2(error_message,
                                              background_color:
                                                  CustomTheme.red);
                                          setState(() {});
                                          return;
                                        } else {
                                          error_message = "";
                                        }
                                        widget.mark.eot_score =
                                            value.toString();
                                      }
                                      setState(() {});
                                    },
                                    initialValue: widget.mark.eot_score == '0'
                                        ? ''
                                        : widget.mark.eot_score,
                                    textCapitalization:
                                        TextCapitalization.words,
                                    keyboardType: TextInputType.number,
                                    autofocus: true,
                                    decoration: AppTheme.InputDecorationTheme1(
                                      label:
                                          "End of Term - Score (MAX Score: ${widget.activeReportCard.eot_max})",
                                    ),
                                    textInputAction: TextInputAction.next,
                                    validator: FormBuilderValidators.compose([
                                      FormBuilderValidators.required(
                                        errorText: "Enter End of Term - Score",
                                      ),
                                      FormBuilderValidators.numeric(
                                        errorText:
                                            "Enter valid End of Term - Score",
                                      ),
                                    ]),
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            FxText.bodyMedium(
                                "Or Select marks from the list below",
                                fontWeight: 600),
                            const SizedBox(
                              height: 10,
                            ),
                            myHorizontalList([
                              '40',
                              '45',
                              '50',
                              '55',
                              '60',
                              '65',
                              '70',
                              '75',
                              '80',
                              '85',
                              '90',
                              '95',
                              '100',
                            ], (x) {
                              if (widget.activeReportCard
                                      .activeMarkSubmission() ==
                                  'E.O.T') {
                                int max =
                                    int.parse(widget.activeReportCard.eot_max);
                                if (int.parse(x) > max) {
                                  error_message =
                                      "Score cannot be more than 100";
                                  Utils.toast2(error_message,
                                      background_color: CustomTheme.red);
                                  setState(() {});
                                  return;
                                } else {
                                  error_message = "";
                                }
                                widget.mark.eot_score = x;
                                _formKey.currentState!.patchValue(
                                    {'eot_score': widget.mark.eot_score});
                              } else if (widget.activeReportCard
                                      .activeMarkSubmission() ==
                                  'M.O.T') {
                                int max =
                                    int.parse(widget.activeReportCard.mot_max);
                                if (int.parse(x) > max) {
                                  error_message =
                                      "Score cannot be more than 100";
                                  Utils.toast2(error_message,
                                      background_color: CustomTheme.red);
                                  setState(() {});
                                  return;
                                } else {
                                  error_message = "";
                                }
                                widget.mark.mot_score = x;
                                _formKey.currentState!.patchValue(
                                    {'mot_score': widget.mark.mot_score});
                              } else if (widget.activeReportCard
                                      .activeMarkSubmission() ==
                                  'B.O.T') {
                                widget.mark.bot_score = x;
                                _formKey.currentState!.patchValue(
                                    {'bot_score': widget.mark.bot_score});
                              }

                              FocusScope.of(context).unfocus();
                            }),
                            const SizedBox(
                              height: 20,
                            ),
                            FormBuilderTextField(
                              name: 'remarks',
                              initialValue: widget.mark.bot_score == '0'
                                  ? ''
                                  : widget.mark.remarks,
                              textCapitalization: TextCapitalization.sentences,
                              keyboardType: TextInputType.text,
                              enableSuggestions: true,
                              autofocus: true,
                              onChanged: (value) {
                                widget.mark.remarks = value.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Remarks",
                              ),
                              textInputAction: TextInputAction.done,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FxText.bodyMedium(
                                "Or Select Remarks from the list below",
                                fontWeight: 600),
                            const SizedBox(
                              height: 10,
                            ),
                            myHorizontalList([
                              'Excellent',
                              'Very Good',
                              'Good',
                              'Fair',
                              'Tried',
                              'Poor',
                              'Very Poor',
                              'Average',
                            ], (x) {
                              widget.mark.remarks = x;
                              _formKey.currentState!
                                  .patchValue({'remarks': widget.mark.remarks});
                              //remove all focus
                              FocusScope.of(context).unfocus();
                            }),
                          ],
                        ),
                      ),
                    )),
              ],
            ),
          ),
          Column(
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
              FxContainer(
                color: Colors.grey.shade300,
                child: FxButton.block(
                    onPressed: () {
                      if (!_formKey.currentState!.saveAndValidate()) {
                        Utils.toast2("Fill all fields",
                            background_color: CustomTheme.red);
                        return;
                      }

                      do_submit();
                    },
                    padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
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
                            child: FxText.titleLarge(
                          "SAVE",
                          color: Colors.white,
                          fontWeight: 800,
                        )),
                      ],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<MarkRecordModel> localTrips = [];
  bool loading = false;

  Future<void> init() async {
    if (localTrips.length < 5) {}
    localTrips = await MarkRecordModel.get_items();

    setState(() {});
  }

  void _showMarkBottomSheet(MarkRecordModel m) {
    showModalBottomSheet(
        isScrollControlled: false,
        //min
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                  top: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FxText.titleLarge(m.administrator_text,
                            fontWeight: 800, color: Colors.black),
                        const SizedBox(
                          height: 5,
                        ),
                        const Divider(),
                        const SizedBox(
                          height: 0,
                        ),
                        titleValueWidget2('CLASS', Utils.to_date(m.created_at)),
                        const SizedBox(
                          height: 2,
                        ),
                        titleValueWidget2('SUBJECT', m.subject_text),
                        const SizedBox(
                          height: 2,
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        titleValueWidget2('M.O.T Score', m.mot_score),
                        const SizedBox(
                          height: 2,
                        ),
                        titleValueWidget2('E.O.T Score', m.eot_score),
                        const SizedBox(
                          height: 15,
                        ),
                        FxButton.block(
                          onPressed: () {},
                          padding: const EdgeInsets.symmetric(
                            vertical: 20,
                          ),
                          child: FxText.titleLarge(
                            'UPDATE MARKS',
                            color: Colors.white,
                            fontWeight: 700,
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> do_submit() async {
    //validate form
    if (!_formKey.currentState!.saveAndValidate()) {
      Utils.toast2("Fill all fields", background_color: CustomTheme.red);
      return;
    }
    error_message = '';
    FocusScope.of(context).unfocus();
    Utils.showLoader(true);
    RespondModel resp =
        RespondModel(await Utils.http_post('mark-records-update', {
      'record_id': widget.mark.id,
      'eot_score': widget.mark.eot_score,
      'mot_score': widget.mark.mot_score,
      'bot_score': widget.mark.bot_score,
      'remarks': widget.mark.remarks,
    }));
    Utils.hideLoader();

    if (resp.code != 1) {
      error_message = resp.message;
      Utils.toast2(resp.message, background_color: CustomTheme.red);
      setState(() {});
      return;
    }

    MarkRecordModel rec = MarkRecordModel.fromJson(resp.data);

    if (rec.id < 1) {
      error_message = 'Failed to update record';
      Utils.toast2(error_message, background_color: CustomTheme.red);
      setState(() {});
      return;
    }
    await rec.save();
    widget.mark = rec;
    Utils.toast2(resp.message, background_color: CustomTheme.green);
    Navigator.pop(context);
  }

  myHorizontalList(List<String> list, Function onTap) {
    return SizedBox(
      height: 32,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: list.length,
        itemBuilder: (context, index) {
          return FxContainer(
            onTap: () {
              onTap(list[index]);
              setState(() {});
            },
            alignment: Alignment.center,
            border: Border.all(color: Colors.grey.shade500),
            bordered: true,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
            margin: const EdgeInsets.only(right: 5),
            child: FxText.bodySmall(
              list[index],
            ),
          );
        },
      ),
    );
  }
}
