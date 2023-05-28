import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/ExamModel.dart';
import 'package:schooldynamics/models/MyClasses.dart';
import 'package:schooldynamics/models/SessionLocal.dart';
import 'package:schooldynamics/models/UserModel.dart';

import '../../models/SessionOnline.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';
import '../sessions/SessionCreateNewScreen.dart';
import '../sessions/SessionLocalScreen.dart';
import '../sessions/SessionOnlineScreen.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<ClassScreen> {
  late ThemeData themeData;

  _CourseTasksScreenState();

  late Future<dynamic> futureInit;

  Future<Null> _my_init() async {
    futureInit = my_init();
    setState(() {});
  }

  MyClasses item = MyClasses();

  List<SessionOnline> sessionsOnline = [];
  List<SessionLocal> sessionsLocal = [];
  List<ExamModel> exams = [];

  Future<dynamic> my_init() async {
    item = widget.data;
    await item.getStudents();
    exams = await ExamModel.getItems(forceWait: false);
    sessionsOnline = await SessionOnline.getItems(
        where: ' academic_class_id = ${item.id} ', forceWait: false);

    await SessionLocal.uploadPending();

    setState(() {});
    return "Done";
  }

  @override
  void initState() {
    _my_init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.primary,
        onPressed: () {
          _my_init();
        },
        child: PopupMenuButton<int>(
            onSelected: (x) {
              String y = x.toString();
              switch (y) {
                case '1':
                  Get.to(() => SessionCreateNewScreen(
                        data: item,
                      ));
                  break;
              }
            },
            icon: Icon(
              FeatherIcons.moreVertical,
              size: 25,
              color: Colors.white,
            ),
            itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Icon(
                          FeatherIcons.checkCircle,
                          color: CustomTheme.primary,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        Expanded(
                            child: FxText.bodyLarge('Create new roll call')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.camera,
                          color: CustomTheme.primary,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Add homework'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 9,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.messageCircle,
                          color: CustomTheme.primary,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Add a test'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.star,
                          color: CustomTheme.primary,
                        ),
                        SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Add class motes'),
                      ],
                    ),
                  ),
                ]),
      ),
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        // remove back button in appbar.
        actions: [
          InkWell(
              onTap: () {
                _my_init();
              },
              child: Padding(
                padding: EdgeInsets.only(right: 6),
                child: Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
              )),
        ],
        title: FxText.titleLarge(
          "${item.name} - ${item.short_name}",
          color: Colors.white,
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            toolbarHeight: 48,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*-------------- Build Tabs here ------------------*/
                TabBar(
                  padding: EdgeInsets.only(bottom: 0),
                  labelPadding: EdgeInsets.only(bottom: 2, left: 8, right: 8),
                  indicatorPadding: EdgeInsets.all(0),
                  labelColor: CustomTheme.primary,
                  isScrollable: true,
                  enableFeedback: true,
                  indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: CustomTheme.primary, width: 4)),
                  tabs: [
                    Tab(
                        height: 30,
                        child: FxText.titleMedium(
                          "Summary",
                          fontWeight: 600,
                          color: CustomTheme.primary,
                        )),
                    Tab(
                        height: 30,
                        child: FxText.titleMedium(
                            "Students (${item.students.length})",
                            fontWeight: 600,
                            color: CustomTheme.primary)),
                    Tab(
                        height: 30,
                        child: FxText.titleMedium("Attendance",
                            fontWeight: 600, color: CustomTheme.primary)),
                    Tab(
                        height: 30,
                        child: Container(
                          child: FxText.titleMedium("Exams",
                              fontWeight: 600, color: CustomTheme.primary),
                        )),
                  ],
                )
              ],
            ),
          ),

          /*--------------- Build Tab body here -------------------*/
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return mainFragment();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return studentsFragment();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return attendanceList();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return examsList();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  Widget singleWidget(String title, String subTitle) {
    /*   return Container(
      padding: EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      child: valueUnitWidget(
        context,
        '${title} :',
        subTitle,
        fontSize: 10,
        titleColor: CustomTheme.primary,
        color: Colors.grey.shade600,
      ),
    );*/
    return Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.only(top: 4, bottom: 4),
      child: Flex(
        direction: Axis.horizontal,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: MediaQuery.of(context).size.width / 2.5,
            alignment: Alignment.centerRight,
            child: FxText.bodyLarge(
              '${title} :'.toUpperCase(),
              textAlign: TextAlign.right,
              color: CustomTheme.primary,
              fontWeight: 700,
            ),
          ),
          SizedBox(
            width: 4,
          ),
          Expanded(
              child: FxText.bodyLarge(
            subTitle,
            maxLines: 10,
          )),
        ],
      ),
    );
  }

  mainFragment() {
    return Container(
      child: ListView(
        children: [
          const SizedBox(
            height: 8,
          ),
          singleWidget('Class', '${item.name} - ${item.short_name}'),
          singleWidget('Academic year', '${item.academic_year_id}'),
          singleWidget('Class teacher', '${item.class_teacher_name}'),
          singleWidget('Students', '${item.students_count}'),
        ],
      ),
    );
  }

  studentsFragment() {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                UserModel m = item.students[index];
                return userWidget(m,context);
              },
              childCount: item.students.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget examsList() {
    return exams.isEmpty
        ? Expanded(
            child: Center(
            child: FxText.bodyMedium('No exams.'),
          ))
        : RefreshIndicator(
            backgroundColor: Colors.white,
            onRefresh: _my_init,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                      ExamModel m = exams[index];
                      return ListTile(
                        onTap: () {
                          //showBottomSheetAccountPicker(m);
                        },
                        title: FxText.titleMedium(
                          "${m.term_name} - ${m.name}",
                          color: Colors.black,
                          fontWeight: 700,
                        ),
                        dense: true,
                        subtitle: FxText.bodySmall(m.type),
                        trailing: FxContainer(
                          borderRadiusAll: 50,
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          color: Colors.green.shade50,
                          child: const Icon(FeatherIcons.chevronRight),
                        ),
                      );
                    },
                    childCount: exams.length,
                  ),
                ),
              ],
            ),
          );
  }

  Widget attendanceList() {
    return CustomScrollView(
      slivers: [
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              return FxContainer(
                padding: const EdgeInsets.only(
                    top: 10, bottom: 10, right: 15, left: 15),
                color: Colors.red.shade700,
                borderRadiusAll: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    FxText.bodyMedium(
                      'You have ${sessionsLocal.length} roll-calls not submitted.',
                      color: Colors.white,
                    ),
                    FxContainer(
                      onTap: () {
                        Get.to(() => SessionLocalScreen());
                      },
                      color: Colors.white,
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, top: 2, bottom: 2),
                      child: FxText.bodySmall(
                        'VIEW',
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              );
            },
            childCount: sessionsLocal.isNotEmpty ? 1 : 0,
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (BuildContext context, int index) {
              SessionOnline m = sessionsOnline[index];
              return ListTile(
                onTap: () {
                  Get.to(() => SessionOnlineScreen(
                        data: m,
                      ));
                },
                title: FxText.titleMedium(
                  m.title,
                  color: Colors.black,
                  fontWeight: 700,
                ),
                subtitle: FxText.bodySmall(Utils.to_date_1(m.due_date)),
                trailing: FxContainer(
                  padding: const EdgeInsets.only(
                      left: 10, right: 10, top: 5, bottom: 5),
                  color: Colors.green.shade50,
                  child: FxText.bodySmall(
                    'SUBMITTED',
                    color: Colors.green.shade700,
                    fontWeight: 800,
                  ),
                ),
              );
            },
            childCount: sessionsOnline.length,
          ),
        ),
      ],
    );
  }
}
