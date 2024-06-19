import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/controllers/MainController.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/screens/classes/ClassesScreen.dart';
import 'package:schooldynamics/sections/widgets.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../../models/MenuItem.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/SignScreen.dart';
import '../../../utils/my_widgets.dart';
import '../../account/login_screen.dart';
import '../../admin/AdminMenuScreen.dart';
import '../../posts/NewsHomeScreen.dart';
import '../../schemework/SchemeWorkHomeScreen.dart';
import '../../sessions/AttendanceScreen.dart';
import '../../students/StudentsScreen.dart';
import '../../transport/TransportHomeScreen.dart';
import '../../visitors/VisitorsBookScreen.dart';

class SectionDashboard extends StatefulWidget {
  const SectionDashboard({super.key});

  @override
  _SectionDashboardState createState() => _SectionDashboardState();
}

class _SectionDashboardState extends State<SectionDashboard> {
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingManagerTheme;
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: true
          ? const SizedBox()
          : FloatingActionButton(
              onPressed: () async {
                Get.to(() => const SignScreen());
              },
              child: const Icon(Icons.logout),
            ),
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        systemOverlayStyle: Utils.get_theme(),
        toolbarHeight: 0,
        automaticallyImplyLeading: false,
      ),
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
    checkForUpdate();
    futureInit = myInit();
    setState(() {});
  }

  List<MenuItem> menuItems = [];

  LoggedInUserModel u = LoggedInUserModel();

  //maincontroller find
  final MainController man = Get.find<MainController>();

  bool is_first_time = true;
  Future<dynamic> myInit() async {
    if (is_first_time) {
      await man.getEnt();
      await Utils.init_theme();
    } else {
      man.getEnt();
      Utils.init_theme();
    }

    LoggedInUserModel.getLoggedInUserOnline();
    u = await LoggedInUserModel.getLoggedInUser();
    //Utils.initOneSignal();
    Utils.init_theme();
    if (is_first_time) {
      is_first_time = false;
    }

    return "Done";
  }

  Widget mainWidget() {
    menuItems = [];
    //4194 parent ID

    if (u.isRole('teacher') || u.isRole('admin') || u.isRole('dos')) {
      menuItems
          .add(MenuItem('Classes', 'T 1', FeatherIcons.edit, 'classes.png', () {
        Get.to(() => ClassesScreen());
      }));
    }

    if (u.isRole('teacher') || u.isRole('parent') || u.isRole('admin')) {
      String title = "Students";
      if (u.isRole('parent')) {
        title = "My Children";
      }
      menuItems
          .add(MenuItem(title, 'T 1', FeatherIcons.edit, 'students.png', () {
        Get.to(() => StudentsScreen(const {}));
      }));
    }

    if (u.isRole('dos') ||
        u.isRole('admin') ||
        u.isRole('bursar') ||
        u.isRole('parent')) {
      /*menuItems.add(MenuItem(
          'School Fees', 'T 1', FeatherIcons.edit, 'financial-account.jpg', () {
        Get.to(() => FinancialAccountsScreen({}));
      }));*/
    }

    if (u.isRole('bursar')) {
      /*menuItems.add(
          MenuItem('Transactions', 'T 1', FeatherIcons.edit, 'finance.png', () {
        Get.to(() => TransactionsScreen({}));
      }));*/
/*      menuItems.add(
          MenuItem('Services', 'T 1', FeatherIcons.edit, 'finance.png', () {
        Get.to(() => ServicesScreen(const {}));
      }));*/
    }

    if (u.isRole('dos') || u.isRole('admin') || u.isRole('bursar')) {
      menuItems
          .add(MenuItem('Admin', 'T 1', FeatherIcons.edit, 'admin.png', () {
        Get.to(() => const AdminMenuScreen());
      }));
    }

    if (u.isRole('dos') ||
        u.isRole('admin') ||
        u.isRole('bursar') ||
        u.isRole('parent')) {
      /* menuItems.add(
          MenuItem('Services', 'T 1', FeatherIcons.edit, 'finance.png', () {
        Get.to(() => ServiceSubscriptionScreen());
      }));*/
    }

    if (u.isRole('parent') || u.isRole('admin')) {
      menuItems.add(MenuItem(
          'Attendance', 'T 1', FeatherIcons.edit, 'attandance.png', () {
        Get.to(() => AttendanceScreen());
      }));
    }

    if (u.isRole('dos') ||
        u.isRole('admin') ||
        u.isRole('hm') ||
        u.isRole('gate')) {
      menuItems.add(MenuItem(
          'Visitors\' Book', 'T 1', FeatherIcons.edit, 'visitor.png', () {
        Get.to(() => VisitorsBookScreen());
      }));
    }

    if (u.isRole('teacher') || u.isRole('admin') || u.isRole('dos')) {
      menuItems.add(
          MenuItem('Scheme-work', 'T 1', FeatherIcons.edit, 'scheme.png', () {
        Get.to(() => SchemeWorkHomeScreen());
      }));
    }

    if (u.isRole('driver') || u.isRole('admin')) {
      menuItems
          .add(MenuItem('Transport', 'T 1', FeatherIcons.edit, 'bus.jpg', () {
        Get.to(() => TransportHomeScreen());
      }));
    }

    menuItems
        .add(MenuItem('School News', 'T 1', FeatherIcons.edit, 'news.png', () {
      Get.to(() => NewsHomeScreen());
    }));

    /* if (u.isRole('dos') ||
        u.isRole('admin') ||
        u.isRole('bursar') ||
        u.isRole('parent')) {
      menuItems.add(MenuItem(
          'Financial Accounts', 'T 1', FeatherIcons.edit, 'admin.png', () {
        Get.to(() => FinancialAccountsScreen({}));
      }));
    }*/

    return Column(
      children: [
        Container(
            height: Get.height / 5,
            color: CustomTheme.primary,
            padding: const EdgeInsets.only(
              left: 20,
              top: 20,
              right: 20,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    FxText.bodySmall(
                      '${Utils.greet(u.name)}, Welcome to',
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      fontWeight: 300,
                      color: Colors.white,
                    ),
                    const Divider(),
                    InkWell(
                      onTap: () {
                        myInit();
                      },
                      child: FxText.titleLarge(
                        "${man.ent.name.toUpperCase()}.",
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.start,
                        fontWeight: 800,
                        color: Colors.white,
                        fontSize: 30,
                        height: 1.2,
                      ),
                    ),
                  ],
                )),
                FxContainer(
                  color: CustomTheme.primary,
                  border: Border.all(color: Colors.white, width: 1),
                  bordered: true,
                  borderRadiusAll: 0,
                  margin: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  padding: const EdgeInsets.all(5),
                  child: roundedImage(man.ent.getLogo(), 4, 0, radius: 0),
                ),
              ],
            )),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(
              left: 10,
              top: 10,
              right: 10,
            ),
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: SafeArea(
                child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.8,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          MenuItem item = menuItems[index];
                          return menuItemWidget(item);
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
        SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
