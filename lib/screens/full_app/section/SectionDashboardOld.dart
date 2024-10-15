import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/controllers/MainController.dart';
import 'package:schooldynamics/models/MyClasses.dart';
import 'package:schooldynamics/utils/AppConfig.dart';

import '../../../controllers/SectionDashboardController.dart';
import '../../../models/MySubjects.dart';
import '../../../models/UserModel.dart';
import '../../../sections/widgets.dart';
import '../../../theme/app_theme.dart';
import '../../classes/ClassScreen.dart';
import '../../classes/ClassesScreen.dart';
import '../../students/StudentsScreen.dart';
import '../../subjects/SubjectScreen.dart';
import '../../subjects/SubjectsScreen.dart';

class SectionDashboardOld extends StatefulWidget {
  MainController mainController;

  SectionDashboardOld(this.mainController, {Key? key}) : super(key: key);

  @override
  _SectionDashboardState createState() => _SectionDashboardState();
}

class _SectionDashboardState extends State<SectionDashboardOld> {
  late ThemeData theme;
  late SectionDashboardController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
    controller = FxControllerStore.putOrFind(SectionDashboardController());
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
/*      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: CustomTheme.primary,
        onPressed: () {
          UserModel.getItems();
          //widget.mainController.getMyClasses();
          //MyClasses.getItems();
        },
        child: const Icon(
          FeatherIcons.plus,
          size: 25,
        ),
      ),*/
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: Text("⌛ Loading..."),
                );
              default:
                return mainWidget();
            }
          }),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();
    setState(() {});
  }

  Future<dynamic> myInit() async {
    await widget.mainController.getMyClasses();
    await widget.mainController.getMyStudents();
    await widget.mainController.getMySubjects();
    return "Done";
  }

  testProcesses() async {
    print("===I LOVE ROMINA====");
    //await widget.mainController.getMySubjects();
    //print("=========geting=======");
    //List<MarksModel> marks = await MarksModel.getItems();
    //List<ExamModel> exams = await ExamModel.getItems();
    //print("=========FOUND-->${marks.length}<----=======");
    //Utils.initOneSignal();
  }

  Widget mainWidget() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            testProcesses();
          },
          child: Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              top: 18,
              bottom: 15,
            ),
            child: Flex(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              direction: Axis.horizontal,
              children: [
                const Icon(FeatherIcons.settings),
                FxText.titleLarge(
                  'School Dynamics'.toUpperCase(),
                  maxLines: 1,
                  fontWeight: 800,
                  color: CustomTheme.primaryDark,
                ),
                Icon(FeatherIcons.user),
              ],
            ),
          ),
        ),
        const Divider(
          height: 0,
        ),
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('Examination Marks', () {
                            Get.to(() => SubjectsScreen({}));
                          });
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          ExamAndSubjectModel item = widget.mainController.exams[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => SubjectScreen(
                                    data: item,
                                  ));
                            },
                            child: FxContainer(
                              width: (Get.width / 6),
                              height: (Get.width / 6),
                              borderRadiusAll: 10,
                              borderColor: Colors.red.shade700,
                              bordered: true,
                              color: CustomTheme.red.withAlpha(40),
                              paddingAll: 10,
                              alignment: Alignment.center,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  FxText.titleLarge(
                                    "${item.subject.short_name}",
                                    color: Colors.black,
                                    fontWeight: 900,
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  FxText.bodyMedium(
                                    item.subject.subject_name,
                                    color: Colors.black,
                                    maxLines: 1,
                                    height: 1,
                                  ),
                                  Spacer(),
                                  FxText.bodySmall(
                                    "${item.marks_pending} marks not submitted.",
                                    color: Colors.red,
                                    fontWeight: 800,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                        childCount: widget.mainController.exams.length,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('My Top Subjects', () {
                            Get.to(() => SubjectsScreen({}));
                          });
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          MySubjects item =
                              widget.mainController.my_top_subjects[index];
                          return InkWell(
                            onTap: () {
                              Get.to(() => SubjectScreen(
                                    data: item,
                                  ));
                            },
                            child: Column(
                              children: [
                                FxContainer(
                                  width: (Get.width / 6),
                                  height: (Get.width / 6),
                                  borderRadiusAll: 100,
                                  color: CustomTheme.primary.withAlpha(40),
                                  paddingAll: 10,
                                  alignment: Alignment.center,
                                  child: FxText.titleLarge(
                                    "${item.short_name}",
                                    color: Colors.black,
                                    fontWeight: 900,
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Center(
                                  child: FxText.bodyMedium(
                                    item.subject_name,
                                    color: Colors.black,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: widget.mainController.my_top_subjects.length,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('My Classes', () {
                            Get.to(() => ClassesScreen({}));
                          });
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          MyClasses myClass =
                              widget.mainController.my_top_classes[index];
                          return FxContainer(
                            onTap: () {
                              Get.to(() => ClassScreen(data: myClass));
                            },
                            borderColor: CustomTheme.primaryDark,
                            bordered: true,
                            borderRadiusAll: 8,
                            color: CustomTheme.primary.withAlpha(40),
                            paddingAll: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  FeatherIcons.award,
                                  color: CustomTheme.primaryDark,
                                  size: 30,
                                ),
                                Spacer(),
                                FxText.titleSmall(
                                  "${myClass.name} - ${myClass.short_name} ",
                                  height: .9,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                FxText.bodySmall(
                                  "${myClass.class_teacher_name}",
                                  height: .9,
                                  maxLines: 2,
                                  color: CustomTheme.primaryDark,
                                ),
                                Spacer(),
                                FxText.bodySmall(
                                  "${myClass.students_count} Students",
                                  height: .8,
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: widget.mainController.my_top_classes.length,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('My Students', () {
                            Get.to(() => StudentsScreen(const {}));
                          });
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.65,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          UserModel item =
                              widget.mainController.my_top_students[index];
                          return userWidget1(item);
                        },
                        childCount: widget.mainController.my_top_students.length,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return titleWidget('Recent news', () {});
                        },
                        childCount: 1, // 1000 list items
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Text("Coming soon...");
                          return Container(
                            padding: EdgeInsets.only(bottom: 15),
                            child: Flex(
                              direction: Axis.horizontal,
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                roundedImage(
                                    [
                                      'https://images.unsplash.com/photo-1499651681375-8afc5a4db253?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1397&q=80',
                                      'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2080&q=80',
                                      'https://images.unsplash.com/photo-1560087637-bf1e338a40a6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8OXw1MDU0NDQ2fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                                      'https://images.unsplash.com/photo-1530785602389-07594beb8b73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YWZyaWNhbiUyMGZhY2V8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
                                      'https://images.unsplash.com/photo-1519699047748-de8e457a634e?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2080&q=80',
                                      'https://images.unsplash.com/photo-1560087637-bf1e338a40a6?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxjb2xsZWN0aW9uLXBhZ2V8OXw1MDU0NDQ2fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                                      'https://images.unsplash.com/photo-1530785602389-07594beb8b73?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8YWZyaWNhbiUyMGZhY2V8ZW58MHx8MHx8&auto=format&fit=crop&w=500&q=60',
                                      'https://images.unsplash.com/photo-1613005341945-35e159e522f1?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8MTV8fGFmcmljYW4lMjBmYWNlfGVufDB8fDB8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                                      'https://images.unsplash.com/photo-1517090186835-e348b621c9ca?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDJ8fHxlbnwwfHx8fA%3D%3D&auto=format&fit=crop&w=500&q=60',
                                      'https://images.unsplash.com/photo-1589156191108-c762ff4b96ab?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1yZWxhdGVkfDE5fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60'
                                    ][index]
                                        .toString(),
                                    2.8,
                                    4.5),
                                SizedBox(
                                  width: 10,
                                ),
                                Expanded(
                                  child: Flex(
                                    direction: Axis.vertical,
                                    children: [
                                      FxText.titleMedium(
                                        AppConfig.lorem_1,
                                        maxLines: 2,
                                        color: Colors.black,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(
                                        height: 24,
                                      ),
                                      Row(
                                        children: [
                                          Icon(
                                            FeatherIcons.user,
                                            size: 12,
                                            color: CustomTheme.primaryDark,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          FxText.bodySmall('By John Doe'),
                                          Spacer(),
                                          Icon(
                                            FeatherIcons.clock,
                                            size: 12,
                                            color: CustomTheme.primaryDark,
                                          ),
                                          SizedBox(
                                            width: 2,
                                          ),
                                          FxText.bodySmall('12 Feb,2019'),
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                        childCount: 5, // 1000 list items
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
