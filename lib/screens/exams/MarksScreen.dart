import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/models/ExamModel.dart';
import 'package:schooldynamics/models/MarkLocalModel.dart';
import 'package:schooldynamics/models/MarksModel.dart';
import 'package:schooldynamics/models/MySubjects.dart';

import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';

class MarksScreen extends StatefulWidget {
  MarksScreen(this.exam, this.subject, {Key? key}) : super(key: key);

  ExamModel exam;
  MySubjects subject;

  @override
  MarksScreenState createState() => MarksScreenState(exam, subject);
}

class MarksScreenState extends State<MarksScreen> {
  List<MarksModel> items = [];
  ExamModel exam;

  MySubjects subject;

  MarksScreenState(this.exam, this.subject);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  Future<dynamic> doRefresh() async {
    futureInit = init();
    setState(() {});
  }

  late Future<dynamic> futureInit;
  MarksModel localMark = MarksModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleMedium(
                'Marks',
                color: Colors.white,
                fontWeight: 700,
                height: .6,
              ),
              FxText.bodySmall(
                'TERM: ${exam.term_name}, '
                'EXAM: ${exam.type}, '
                '\nCLASS: ${exam.name}, '
                'SUBJECT: ${subject.subject_name}',
                color: Colors.white,
                maxLines: 2,
              )
            ],
          )),
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return myListLoaderWidget(context);
            }
            if (items.isEmpty) {
              return Center(child: FxText('No item found.'));
            }

            return RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: doRefresh,
              child: Column(
                children: [
                  FxContainer(
                    width: double.infinity,
                    child: FxText.bodySmall(
                      'SUBMITTED MARKS: ${items.length}'
                      '\nNOT SUBMITTED MARKS: ${items.length}',
                      color: CustomTheme.primary,
                      fontWeight: 700,
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                        separatorBuilder: (context, index) => const Divider(
                              height: 15,
                            ),
                        itemCount: items.length,
                        itemBuilder: (context, index) {
                          final MarksModel m = items[index];
                          return Flex(
                            direction: Axis.horizontal,
                            children: [
                              const SizedBox(
                                width: 15,
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    FxText.titleMedium(
                                      m.student_name,
                                      color: Colors.black,
                                      fontWeight: 700,
                                    ),
                                    FxText.bodySmall("${m.remarks}"),
                                  ],
                                ),
                              ),
                              Container(
                                child: Flex(
                                  direction: Axis.horizontal,
                                  children: [
                                    FxText.titleLarge(
                                      m.score,
                                      color: Colors.black,
                                      fontWeight: 800,
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    FxContainer(
                                      onTap: () {
                                        showBottomSheetAccountPicker(index);
                                      },
                                      padding: const EdgeInsets.only(
                                          left: 5, right: 5, top: 5, bottom: 5),
                                      color: CustomTheme.primary.withAlpha(10),
                                      child: Icon(
                                        Icons.edit,
                                        color: CustomTheme.primary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          );
                        }),
                  ),
                ],
              ),
            );
          }),
    );


  }

  Future<void> saveMark(int index) async {

    await items[index].save();
    MarkLocalModel local = MarkLocalModel();
    local.remarks = items[index].remarks;
    local.score = items[index].score;
    local.id = items[index].id;
    await local.save();
  }

  void showBottomSheetAccountPicker(int index) {
    String tempScore = items[index].score;
    String tempRemarks = items[index].remarks;
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        isScrollControlled: true,
        builder: (BuildContext buildContext) {
          return WillPopScope(
            onWillPop: () async {
              return false;
            },
            child: Container(
              padding: EdgeInsets.only(left: 15, right: 15),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(0),
                ),
              ),
              child: Container(
                padding: EdgeInsets.only(top: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 25,
                    ),
                    FxText.titleLarge(
                      items[index].student_name,
                      color: Colors.black,
                      fontWeight: 700,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Expanded(
                      child: ListView(
                        children: [
                          FormBuilderTextField(
                            decoration: CustomTheme.in_4(
                              label: "Score",
                            ),
                            initialValue: items[index].score == '0'
                                ? ''
                                : items[index].score.toString(),
                            name: "score",
                            autofocus: true,
                            keyboardType: TextInputType.number,
                            onChanged: (x) {
                              tempScore = x.toString();
                            },
                            textInputAction: TextInputAction.next,
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FormBuilderTextField(
                            decoration: CustomTheme.in_4(
                              label: "Remarks",
                            ),
                            initialValue: items[index].is_submitted != '1'
                                ? ""
                                : items[index].remarks.toString(),
                            name: "remarks",
                            keyboardType: TextInputType.text,
                            onChanged: (x) {
                              tempRemarks = x.toString();
                            },
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                          ),
                        ],
                      ),
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: FxButton.outlined(
                            borderColor: CustomTheme.primary,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: FxText.titleMedium(
                              'CANCEL',
                              color: CustomTheme.primary,
                              fontWeight: 800,
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        Expanded(
                          child: FxButton.block(
                            borderColor: CustomTheme.primary,
                            padding:
                            const EdgeInsets.fromLTRB(24, 24, 24, 24),
                            onPressed: () {
                              if (Utils.int_parse(tempScore) >
                                  Utils.int_parse(exam.max_mark)) {
                                Utils.toast(
                                    "Enter mark below ${exam.max_mark}",color: CustomTheme.red);
                                return;
                              }
                              items[index].score = tempScore;
                              items[index].remarks = tempRemarks;

                              saveMark(index);
                              setState(() {});

                              Navigator.pop(context);
                            },
                            child: FxText.titleMedium(
                              'SAVE',
                              color: Colors.white,
                              fontWeight: 800,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    )
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> init() async {
    items = await MarksModel.getItems(
        where:
            'exam_id = ${widget.exam.id} AND subject_id = ${widget.subject.id} ');
    setState(() {});
  }
/*
  *

  String exam_id = "";
  String subject_id = "";

  String class_id = "";
  String student_id = "";
  String student_name = "";
  String score = "";
  String remarks = "";
  String main_course_id = "";
  String is_submitted = "";

  * */
}
