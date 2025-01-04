import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/MySubjects.dart';

import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import 'SubjectModelEditScreen.dart';
import 'SubjectScreen.dart';

class SubjectsScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  SubjectsScreen(this.params, {Key? key}) : super(key: key);

  @override
  SubjectsScreenState createState() => new SubjectsScreenState();
}

class SubjectsScreenState extends State<SubjectsScreen> {
  List<MySubjects> items = [];

  String title = '';
  bool isPicker = false;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SubjectModelEditScreen({}));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: FxText.titleLarge(
            title.isNotEmpty ? title : 'Subjects (${items.length})',
            color: Colors.white,
            fontWeight: 700,
            height: .6,
          )),
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return myListLoaderWidget(context);
            }
            if (items.isEmpty) {
              return emptyListWidget(
                  "No Item Found. Press (+) button to add new.", () {
                init();
              });
            }

            return RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: doRefresh,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                      ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final MySubjects m = items[index];
                    return ListTile(
                      onTap: () {
                        if (isPicker) {
                          Get.back(result: m);
                          return;
                        }

                        Get.to(() => SubjectScreen(
                              data: m,
                            ));
                      },
                      leading: FxContainer(
                        width: (Get.width / 6),
                        height: (Get.width / 6),
                        borderRadiusAll: 100,
                        color: CustomTheme.primary.withAlpha(40),
                        paddingAll: 10,
                        alignment: Alignment.center,
                        child: FxText.titleLarge(
                          "${m.short_name}",
                          color: Colors.black,
                          fontWeight: 900,
                        ),
                      ),
                      title: FxText.titleMedium(
                        m.subject_name,
                        color: Colors.black,
                        fontWeight: 700,
                      ),
                      subtitle: FxText.bodySmall(
                        m.exams.length > 0
                            ? "${m.exams.length} marks pending for submission"
                            : "${m.name} - ${m.subject_teacher_name}.",
                        color: m.exams.isNotEmpty ? Colors.red.shade800 : null,
                        fontWeight: 600,
                      ),
                      trailing: FxContainer(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        color: CustomTheme.primary.withAlpha(10),
                        child: Icon(Icons.chevron_right),
                      ),
                    );
                  }),
            );
          }),
    );
  }

  Future<void> init() async {
    if (widget.params['title'] != null) {
      title = widget.params['title'];
    }
    if (widget.params['task'].toString() == 'Select'.toString()) {
      isPicker = true;
    }
    if (widget.params['academic_class_id'].toString().trim().isNotEmpty) {
      String academic_class_id = widget.params['academic_class_id'].toString();
      items = await MySubjects.getItems(
          where: " academic_class_id = '$academic_class_id' ");
    } else {
      items = await MySubjects.getItems();
    }

    setState(() {});
  }
}
