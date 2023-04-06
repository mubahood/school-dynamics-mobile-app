import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../../controllers/SectionDashboardController.dart';
import '../../../models/MenuItem.dart';
import '../../../theme/app_theme.dart';
import '../../admin/AdminMenuScreen.dart';

class SectionDashboard extends StatefulWidget {
  SectionDashboard({Key? key}) : super(key: key);

  @override
  _SectionDashboardState createState() => _SectionDashboardState();
}

class _SectionDashboardState extends State<SectionDashboard> {
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

  List<MenuItem> menuItems = [];

  Future<dynamic> myInit() async {
    menuItems = [
      MenuItem('Admin', 'T 1', FeatherIcons.edit,'', () {
        Get.to(() => const AdminMenuScreen());
      })
    ];
    return "Done";
    // await widget.mainController.getMyClasses();
    // await widget.mainController.getMyStudents();
    // await widget.mainController.getMySubjects();
  }

  Widget mainWidget() {
    return Column(
      children: [
        InkWell(
          onTap: () {},
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
                    SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          MenuItem item = menuItems[index];
                          return FxContainer(
                            width: (Get.width / 6),
                            height: (Get.width / 6),
                            borderRadiusAll: 10,
                            borderColor: Colors.red.shade700,
                            bordered: true,
                            onTap: () {
                              item.f();
                            },
                            color: CustomTheme.red.withAlpha(40),
                            paddingAll: 10,
                            alignment: Alignment.center,
                            child: Text(item.title),
                          );
                        },
                        childCount: menuItems.length,
                      ),
                    ),
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
