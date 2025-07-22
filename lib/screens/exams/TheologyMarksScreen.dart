import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/TheologyClassModel.dart';
import 'package:schooldynamics/models/TheologyMarkRecordModel.dart';
import 'package:schooldynamics/screens/subjects/TheologySubjectsScreen.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/TheologySubjectModel.dart';
import '../../models/TheologyTermlyReportCard.dart';
import '../../theme/custom_theme.dart';
import '../classes/TheologyClassesScreen.dart';
import 'TheologyMarkCreateScreen.dart';

//TheologyMarksScreen
class TheologyMarksScreen extends StatefulWidget {
  Map<String, dynamic> params = {};
  TheologyTermlyReportCard activeReportCard;

  TheologyMarksScreen(this.params, this.activeReportCard, {super.key});

  @override
  TheologyMarksScreenState createState() => TheologyMarksScreenState();
}

class TheologyMarksScreenState extends State<TheologyMarksScreen> {
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

  TheologyClassModel activeClass = TheologyClassModel();
  TheologySubjectModel activeSubject = TheologySubjectModel();

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
            /*searchMode ICON BUTTON*/
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
                      TheologyClassModel? x =
                          await Get.to(() => TheologyClassesScreen(const {
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
                      TheologySubjectModel? y =
                          await Get.to(() => TheologySubjectsScreen(const {
                                'title': 'Select Theology Subject',
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
                      activeClass = TheologyClassModel();
                      activeSubject = TheologySubjectModel();
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
                                child: FxText.bodyLarge('Filter by class')),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 2,
                        child: Row(
                          children: [
                            FxText.bodyLarge('Filter by subject'),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 3,
                        child: Row(
                          children: [
                            FxText.bodyLarge('Clear filters'),
                          ],
                        ),
                      ),
                    ]),
            const SizedBox(
              width: 5,
            ),
          ],
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: searchMode
              ? FxContainer(
                  paddingAll: 0,
                  borderRadiusAll: 10,
                  margin: const EdgeInsets.only(
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
                      'Theology Marks${activeClass.id > 0 ? ' - For ${activeClass.name}' : ''} ',
                      color: Colors.white,
                      fontWeight: 700,
                      height: .9,
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    FxText.bodySmall(
                      'Found ${Utils.moneyFormat(displayClasses.length.toString())} records ${activeSubject.id > 0 ? ', for ${activeSubject.name} - ${activeSubject.theology_class_text}' : ''}',
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
                child: FxText.bodyLarge(
                  "NAME",
                  color: Colors.black,
                  fontWeight: 600,
                ),
              ),
              SizedBox(
                width: 45,
                child: FxText.bodyLarge("M.O.T"),
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
                width: 45,
                child: FxText.bodyLarge("E.O.T"),
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
                        TheologyMarkRecordModel m = displayClasses[index];

                        return Column(
                          children: [
                            InkWell(
                              onTap: () async {
                                await Get.to(() => TheologyMarkCreateScreen(
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
                                    FxText.bodyLarge(
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
                                          FxText.bodyLarge(
                                            m.administrator_text,
                                            color: Colors.black,
                                            fontWeight: 600,
                                            height: .8,
                                          ),
                                          const SizedBox(
                                            height: 2,
                                          ),
                                          FxText.bodySmall(
                                            'CLASS: ${m.theology_class_text},  SUBJECT: ${m.theology_subject_text} ',
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
                                      width: 45,
                                      child: FxText.bodyLarge(
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
                                      width: 45,
                                      child: FxText.bodyLarge(
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
                              title: FxText.titleLarge(m.remarks),
                              subtitle: FxText.bodyLarge(m.mot_score),
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

  List<TheologyMarkRecordModel> displayClasses = [];
  bool loading = false;
  bool searchMode = false;
  String searchText = "";

  Future<void> init() async {
    List<TheologyMarkRecordModel> allClasses =
        await TheologyMarkRecordModel.get_items();
    //activeClass
    displayClasses = [];
    if (activeClass.id > 0) {
      displayClasses = allClasses
          .where((element) =>
              element.theology_class_id.toString() == activeClass.id.toString())
          .toList();
    } else {
      displayClasses = allClasses;
    }

    if (activeSubject.id > 0) {
      displayClasses = displayClasses
          .where((element) =>
              element.theology_subject_id == activeSubject.id.toString())
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
}
