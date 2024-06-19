import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/MyClasses.dart';

import '../../models/SessionLocal.dart';
import '../../models/SessionOnline.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';
import '../sessions/SessionCreateNewScreen.dart';
import '../sessions/SessionLocalScreen.dart';
import '../sessions/SessionOnlineScreen.dart';

class ClassAttendenciesScreen extends StatefulWidget {
  MyClasses data;

  ClassAttendenciesScreen(this.data, {Key? key}) : super(key: key);

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<ClassAttendenciesScreen> {
  _CourseTasksScreenState();

  bool loading = false;

  Future<dynamic> my_init() async {
    loading = true;
    setState(() {});
    await widget.data.getStudents();
    sessionsOnline = await SessionOnline.getItems(
        where: ' academic_class_id = ${widget.data.id} ', forceWait: false);
    await SessionLocal.uploadPending();
    sessionsLocal = await SessionLocal.getItems();
    loading = false;
    setState(() {});
    return "Done";
  }

  @override
  void initState() {
    my_init();
  }

  List<SessionOnline> sessionsOnline = [];
  List<SessionLocal> sessionsLocal = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          onPressed: () async {
            Get.to(() => SessionCreateNewScreen(
                  data: widget.data,
                ));
          }),
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FxText.titleMedium(
              "${widget.data.short_name} - Roll Calls",
              color: Colors.white,
              fontWeight: 800,
            ),
            FxText.bodySmall(
              widget.data.name,
              color: Colors.white,
            ),
          ],
        ),
      ),
      body: loading
          ? myListLoaderWidget(context)
          : Column(
              children: [
                sessionsLocal.isEmpty
                    ? const SizedBox()
                    : FxContainer(
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
                      ),
                sessionsOnline.isEmpty
                    ? emptyListWidget("", my_init)
                    : Expanded(
                        child: RefreshIndicator(
                          onRefresh: () {
                            return my_init();
                          },
                          backgroundColor: Colors.white,
                          child: CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    SessionOnline m = sessionsOnline[index];
                                    return FxContainer(
                                      bordered: true,
                                      onTap: () {
                                        Get.to(() => SessionOnlineScreen(
                                              data: m,
                                            ));
                                      },
                                      padding: const EdgeInsets.all(10),
                                      border: Border.all(
                                          color: Colors.grey.shade300,
                                          width: 1),
                                      margin: const EdgeInsets.only(
                                          left: 15,
                                          right: 15,
                                          top: 5,
                                          bottom: 5),
                                      paddingAll: 5,
                                      color: Colors.white,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Spacer(),
                                              FxText.titleMedium(
                                                "${Utils.to_date(m.due_date)}",
                                                fontWeight: 700,
                                                color: Colors.grey.shade700,
                                              ),
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 12,
                                          ),
                                          FxContainer(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 3,
                                                bottom: 3),
                                            color: CustomTheme.primary,
                                            child: FxText.titleSmall(
                                              m.subject_text,
                                              fontWeight: 700,
                                              color: Colors.white,
                                            ),
                                          ),
                                          FxText.titleMedium(
                                            "${m.academic_class_text}, ${m.stream_text} - Roll call",
                                            color: Colors.black,
                                            fontWeight: 700,
                                          ),
                                          const Divider(),
                                          FxText.titleMedium(
                                            "${m.present_count} present, ${m.absent_count} absent",
                                            color: Colors.black,
                                            fontWeight: 700,
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          FxText.bodySmall(
                                            'Conducted by ${m.administrator_text}',
                                            color: Colors.grey.shade700,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  childCount: sessionsOnline.length,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
              ],
            ),
    );
  }
}
