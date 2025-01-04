import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/MenuItem.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import 'StudentsVerificationScreen.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({Key? key}) : super(key: key);

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<AdminMenuScreen> {
  late ThemeData themeData;

  _CourseTasksScreenState();

  late Future<dynamic> futureInit;

  Future<Null> _my_init() async {
    futureInit = my_init();
    setState(() {});
  }

  Future<dynamic> my_init() async {
    //AdminMenuScreen
    setState(() {});
    return "Done";
  }

  @override
  void initState() {
    _my_init();
  }

  List<MenuItem> menuItems = [];

  @override
  Widget build(BuildContext context) {
    menuItems = [
      MenuItem('Students verification', 'Manage students statuses',
          FeatherIcons.userCheck, '', () {
        Get.to(() => StudentsVerificationScreen());
      })
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: FxText.titleLarge(
          "System admin",
          color: Colors.white,
        ),
      ),
      body: ListView.separated(
          itemBuilder: (BuildContext context, int index) {
            return listItem(menuItems[index]);
          },
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey.shade200),
          itemCount: menuItems.length),
    );
  }
}
