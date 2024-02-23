import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/students/StudentsScreen.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import 'ClassAttendenciesScreen.dart';

class ClassScreen extends StatefulWidget {
  const ClassScreen({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<ClassScreen> {
  _CourseTasksScreenState();

  Future<dynamic> my_init() async {
    return "Done";
  }

  @override
  void initState() {
    my_init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        systemOverlayStyle: Utils.get_theme(),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: FxText.titleLarge(
          "Class details",
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FxCard(
              bordered: true,
              width: double.infinity,
              margin: FxSpacing.all(16),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  Container(
                    padding: FxSpacing.xy(15, 5),
                    child: singleWidget2('Class',
                        '${widget.data.name} - ${widget.data.short_name}'),
                  ),
                  Container(
                      padding: FxSpacing.xy(15, 5),
                      child: singleWidget2(
                          'Academic year', '${widget.data.academic_year_id}')),
                  Container(
                      padding: FxSpacing.xy(15, 5),
                      child: singleWidget2('Class teacher',
                          '${widget.data.class_teacher_name}')),
                  Container(
                      padding: FxSpacing.xy(15, 5),
                      child: singleWidget2(
                          'Students', '${widget.data.students_count}')),
                ],
              ),
            ),
            myListTile(
                'Students', 'View students in this class.', FeatherIcons.users,
                () {
              Get.to(() => StudentsScreen({
                    'class': widget.data,
                  }));
            }),
            myListTile('Attendance', 'View attendance for this class.',
                FeatherIcons.checkCircle, () {
              Get.to(() => ClassAttendenciesScreen(widget.data));
            }),
            myListTile(
                'Exam Marks', 'View exams for this class.', FeatherIcons.file,
                () {
              Utils.toast("Coming soon...");
            }),
          ],
        ),
      ),
    );
  }
}
