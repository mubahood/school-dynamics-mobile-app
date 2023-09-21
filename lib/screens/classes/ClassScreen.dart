import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';

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
            const SizedBox(
              height: 8,
            ),
            Container(
              padding:
              child: singleWidget2(
                  'Class', '${widget.data.name} - ${widget.data.short_name}'),
            ),
            singleWidget2('Academic year', '${widget.data.academic_year_id}'),
            singleWidget2('Class teacher', '${widget.data.class_teacher_name}'),
            singleWidget2('Students', '${widget.data.students_count}'),
            ListTile(
              title: FxText.titleMedium(
                'Create Attendance',
                color: Colors.black,
                fontWeight: 700,
              ),
            ),
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
      ),
    );
  }
}
