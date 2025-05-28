import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../controllers/MainController.dart';
import '../../models/MenuItem.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/MainMenuWidget.dart';
import '../../utils/my_widgets.dart';
import '../account/EnterpriseUpdateScreen.dart';
import 'MenuEditList.dart';
import 'StudentsVerificationScreen.dart';

class AdminMenuScreen extends StatefulWidget {
  const AdminMenuScreen({super.key});

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
  final MainController mainController = Get.find<MainController>();
  @override
  Widget build(BuildContext context) {
    menuItems = [
      MenuItem('Main Menu', 'Menu details go here', FeatherIcons.menu, '', () {
        Get.to(() => const MenuEditList());
      }),
      MenuItem(
          'Students verification',
          'Verify students status (Active or Inactive).',
          FeatherIcons.userCheck, '', () {
        Get.to(() => const StudentsVerificationScreen());
      }),
      MenuItem('School info update', 'Update school details',
          FeatherIcons.settings, '', () async {
        await Get.to(() => EnterpriseUpdateScreen({
              'item': mainController.ent,
            }));
        mainController.getEnt();
        setState(() {});
      })
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        systemOverlayStyle: Utils.overlay(),
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        title: FxText.titleLarge(
          "System admin",
          color: Colors.white,
        ),
      ),
      body: true
          ? MainMenuWidget(
              MenuItem('Main Menu', 'Menu details go here', FeatherIcons.menu,
                  '', () {}),
              menuItems)
          : ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                return listItem(menuItems[index]);
          },
          separatorBuilder: (context, index) =>
              Divider(height: 1, color: Colors.grey.shade200),
          itemCount: menuItems.length),
    );
  }
}
