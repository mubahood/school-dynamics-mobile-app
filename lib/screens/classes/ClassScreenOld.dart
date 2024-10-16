import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/ExamModel.dart';
import 'package:schooldynamics/models/MyClasses.dart';

import '../../models/MySubjects.dart';
import '../../models/StudentHasClassModel.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import '../exams/MarksScreen.dart';
import '../sessions/SessionCreateNewScreen.dart';

class ClassScreenOld extends StatefulWidget {
  const ClassScreenOld({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<ClassScreenOld> {
  late ThemeData themeData;

  _CourseTasksScreenState();

  late Future<dynamic> futureInit;

  Future<Null> _my_init() async {
    futureInit = my_init();
    setState(() {});
  }

  MyClasses item = MyClasses();


  List<MySubjects> subjects = [];
  List<ExamSubject> examSubjects = [];

  Future<dynamic> my_init() async {
    item = widget.data;
    List<ExamModel> exams = await ExamModel.getItems();
    subjects =
        await MySubjects.getItems(where: 'academic_class_id = ${item.id}');
    examSubjects.clear();
    for (var exam in exams) {
      for (var subject in subjects) {
        ExamSubject examSubject = ExamSubject();
        examSubject.subject = subject;
        examSubject.exam = exam;
        examSubjects.add(examSubject);
      }
    }


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
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: FxText.titleLarge(
          "Class details",
          color: Colors.white,
        ),
      ),
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
    );
  }

  Widget singleWidget2(String title, String subTitle) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 15,
        ),
        FxText.bodyLarge(
          '${title}'.toUpperCase(),
          color: CustomTheme.primary,
          textAlign: TextAlign.left,
          fontWeight: 700,
        ),
        SizedBox(
          width: 5,
        ),
        FxText.bodyLarge(
          subTitle,
          maxLines: 10,
        ),
        SizedBox(
          width: 15,
        ),
      ],
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
      padding: EdgeInsets.only(
        left: 15,
        right: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(
            height: 8,
          ),
          singleWidget2('Class', '${item.name} - ${item.short_name}'),
          singleWidget2('Academic year', '${item.academic_year_id}'),
          singleWidget2('Class teacher', '${item.class_teacher_name}'),
          singleWidget2('Students', '${item.students_count}'),
          ListTile(
            title: FxText.titleMedium(
              'Students',
              color: Colors.black,
              fontWeight: 700,
            ),
          ),
          ListTile(
            title: FxText.titleMedium(
              'Attendance',
              color: Colors.black,
              fontWeight: 700,
            ),
          ),
          ListTile(
            title: FxText.titleMedium(
              'Exams',
              color: Colors.black,
              fontWeight: 700,
            ),
          ),
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
                StudentHasClassModel m = item.students[index];
                return userWidget2(m,context);
              },
              childCount: item.students.length,
            ),
          ),
        ],
      ),
    );
  }

  Widget examsList() {
    return examSubjects.isEmpty
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
                      ExamSubject m = examSubjects[index];
                      return ListTile(
                        onTap: () {
                          //Get.to(() => MarksScreen({}));
                        },
                        title: FxText.titleMedium(
                          "${m.exam.type}, ${m.exam.term_name}",
                          color: Colors.black,
                          fontWeight: 700,
                        ),
                        dense: true,
                        subtitle: FxText.bodySmall(m.subject.subject_name),
                        trailing: FxContainer(
                          borderRadiusAll: 50,
                          padding: const EdgeInsets.only(
                              left: 5, right: 5, top: 5, bottom: 5),
                          color: Colors.green.shade50,
                          child: const Icon(FeatherIcons.chevronRight),
                        ),
                      );
                    },
                    childCount: examSubjects.length,
                  ),
                ),
              ],
            ),
          );
  }

  Widget attendanceList() {
    return Text("Attendance");
  }
}
