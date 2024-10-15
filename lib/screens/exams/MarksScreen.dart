import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/MarkRecordModel.dart';
import 'package:schooldynamics/screens/subjects/SubjectsScreen.dart';

import '../../models/MyClasses.dart';
import '../../models/MySubjects.dart';
import '../../models/TermlyReportCard.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../classes/ClassesScreen.dart';
import 'MarkCreateScreen.dart';

//MarksScreen
class MarksScreen extends StatefulWidget {
  Map<String, dynamic> params = {};
  TermlyReportCard activeReportCard;

  MarksScreen(this.params, this.activeReportCard, {super.key});

  @override
  MarksScreenState createState() => MarksScreenState();
}

class MarksScreenState extends State<MarksScreen> {
  Future<void> submit_form() async {
    init();
    return;
  }

  String error_message = "";
  bool is_loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  MyClasses activeClass = MyClasses();
  MySubjects activeSubject = MySubjects();

  bool searchMode = false;
  String searchText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          toolbarHeight: 40,
          actions: [
            InkWell(
              child: Icon(
                searchMode ? FeatherIcons.x : FeatherIcons.search,
                size: 30,
                color: Colors.white,
              ),
              onTap: () {
                searchMode = !searchMode;
                if (!searchMode) {
                  searchText = '';
                  init();
                }
                setState(() {});
              },
            ),
            const SizedBox(
              width: 2,
            ),
            PopupMenuButton(
                onSelected: (x) async {
                  switch (x.toString()) {
                    case '1':
                      MyClasses? x = await Get.to(() => ClassesScreen(const {
                            'title': 'Select Class',
                            'task': 'Select',
                          }));
                      if (x == null) {
                        return;
                      }
                      activeClass = x;
                      setState(() {});
                      init();
                      break;
                    case '2':
                      MySubjects? y = await Get.to(() => SubjectsScreen(const {
                            'title': 'Select Subject',
                            'task': 'Select',
                          }));
                      if (y == null) {
                        return;
                      }
                      activeSubject = y;
                      setState(() {});
                      init();

                      break;
                    case '3':
                      activeClass = MyClasses();
                      activeSubject = MySubjects();
                      setState(() {});
                      init();
                      break;
                  }
                },
                icon: const Icon(
                  FeatherIcons.filter,
                  size: 25,
                  color: Colors.white,
                ),
                itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 1,
                        child: Flex(
                          direction: Axis.horizontal,
                          children: [
                            Expanded(
                                child: FxText.bodySmall('Filter by class')),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            FxText.bodySmall('Filter by subject'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          children: [
                            FxText.bodySmall('Clear filters'),
                          ],
                        ),
                      ),
                    ]),
            const SizedBox(
              width: 5,
            ),
          ],
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: searchMode
              ? FxContainer(
                  paddingAll: 0,
                  borderRadiusAll: 10,
                  margin: EdgeInsets.only(
                    right: 5,
                    bottom: 2,
                  ),
                  height: 30,
                  padding: EdgeInsets.zero,
                  color: Colors.white,
                  child: TextField(
                    autofocus: true,
                    onChanged: (value) {
                      searchText = value.toString();
                      if (searchText.isNotEmpty) {
                        init();
                        setState(() {});
                      } else {
                        init();
                        setState(() {});
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(
                        left: 10,
                        top: 0,
                        bottom: 10,
                      ),
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 5),
                    FxText.titleMedium(
                      'Marks${activeClass.id > 0 ? ' - For ${activeClass.name}' : ''} ',
                      color: Colors.white,
                      fontWeight: 700,
                      height: .6,
                    ),
                    const SizedBox(
                      height: 3,
                    ),
                    FxText.bodySmall(
                      'Found ${Utils.moneyFormat(displayClasses.length.toString())} records ${activeSubject.id > 0 ? ', for ${activeSubject.subject_name}' : ''}',
                      color: Colors.white,
                      height: 1,
                    ),
                  ],
                )),
      body: Column(
        children: [
          Row(
            children: [
              const SizedBox(
                width: 15,
              ),
              Expanded(
                child: FxText.bodySmall(
                  "NAME",
                  color: Colors.black,
                  fontWeight: 600,
                ),
              ),
              SizedBox(
                width: 35,
                child:
                    FxText.bodySmall(widget.activeReportCard.getName("B.O.T")),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                width: 2,
                height: 25,
                color: CustomTheme.primary,
              ),
              SizedBox(
                width: 35,
                child:
                    FxText.bodySmall(widget.activeReportCard.getName("M.O.T")),
              ),
              Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 5,
                ),
                width: 2,
                height: 25,
                color: CustomTheme.primary,
              ),
              SizedBox(
                width: 35,
                child:
                    FxText.bodySmall(widget.activeReportCard.getName("E.O.T")),
              ),
              const SizedBox(
                width: 15,
              ),
            ],
          ),
          Divider(
            height: 2,
            thickness: 2,
            color: CustomTheme.primary,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await init();
              },
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        MarkRecordModel m = displayClasses[index];

                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await Get.to(() => MarkCreateScreen(
                                    m, widget.activeReportCard));
                                setState(() {});
                                //init();
                                //_showMarkBottomSheet(m);
                              },
                              child: Container(
                                color: index % 2 == 0
                                    ? Colors.grey.shade300
                                    : Colors.white,
                                child: Row(
                                  children: [
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    FxText.bodySmall(
                                      "${index + 1}. ",
                                      color: Colors.black,
                                      fontWeight: 600,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          FxText.bodySmall(
                                            m.administrator_text,
                                            color: Colors.black,
                                            fontWeight: 600,
                                            height: .8,
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          FxText.bodySmall(
                                            'CLASS: ${m.academic_class_text},  SUBJECT: ${m.subject_text} ',
                                            color: Colors.grey.shade800,
                                            fontWeight: 400,
                                            height: 1,
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      width: 35,
                                      child: FxText.bodySmall(
                                        m.bot_score,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      width: 2,
                                      height: 40,
                                      color: CustomTheme.primary,
                                    ),
                                    SizedBox(
                                      width: 35,
                                      child: FxText.bodySmall(
                                        m.mot_score,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                      ),
                                      width: 2,
                                      height: 40,
                                      color: CustomTheme.primary,
                                    ),
                                    SizedBox(
                                      width: 35,
                                      child: FxText.bodySmall(
                                        m.eot_score,
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                  ],
                                ),
                              ),
                            )
                          ],
                        );

                        return Column(
                          children: [
                            ListTile(
                              onTap: () {},
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 5,
                              ),
                              title: FxText.titleLarge('${m.remarks}'),
                              subtitle: FxText.bodySmall('${m.mot_score}'),
                              leading: const Icon(FeatherIcons.bookOpen),
                              trailing: const Icon(
                                FeatherIcons.chevronRight,
                                size: 20,
                              ),
                            ),
                            const Divider(
                              height: 1,
                            ),
                          ],
                        );
                      },
                      childCount: displayClasses.length, // 1000 list items
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<MarkRecordModel> displayClasses = [];
  bool loading = false;

  Future<void> init() async {
    List<MarkRecordModel> allClasses = await MarkRecordModel.get_items();
    //activeClass
    displayClasses = [];
    if (activeClass.id > 0) {
      displayClasses = allClasses
          .where((element) =>
              element.academic_class_id == activeClass.id.toString())
          .toList();
    } else {
      displayClasses = allClasses;
    }

    if (activeSubject.id > 0) {
      displayClasses = displayClasses
          .where((element) => element.subject_id == activeSubject.id.toString())
          .toList();
    }

    if (searchText.isNotEmpty && searchMode) {
      displayClasses = displayClasses
          .where((element) => element.administrator_text
              .toLowerCase()
              .contains(searchText.toLowerCase()))
          .toList();
    }

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
                          onPressed: () async {
                            Navigator.pop(context);
                            await Get.to(() =>
                                MarkCreateScreen(m, widget.activeReportCard));
                            init();
                          },
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

}
