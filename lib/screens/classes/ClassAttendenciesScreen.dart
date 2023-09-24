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
              "${widget.data.short_name} - attendance lists",
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
                        child: CustomScrollView(
                          slivers: [
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
                                    subtitle: FxText.bodySmall(
                                        Utils.to_date_1(m.due_date)),
                                    trailing: FxContainer(
                                      padding: const EdgeInsets.only(
                                          left: 10,
                                          right: 10,
                                          top: 5,
                                          bottom: 5),
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
                        ),
                      ),
              ],
            ),
    );
  }
}
