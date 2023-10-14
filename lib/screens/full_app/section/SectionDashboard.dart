import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/screens/classes/ClassesScreen.dart';
import 'package:schooldynamics/screens/finance/ServiceSubscriptionScreen.dart';
import 'package:schooldynamics/screens/full_app/section/TransactionsScreen.dart';

import '../../../models/MenuItem.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/my_widgets.dart';
import '../../admin/AdminMenuScreen.dart';
import '../../finance/FinancialAccountsScreen.dart';
import '../../students/StudentsScreen.dart';
import 'AccountSection.dart';

class SectionDashboard extends StatefulWidget {
  SectionDashboard({Key? key}) : super(key: key);

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

  LoggedInUserModel u = LoggedInUserModel();

  Future<dynamic> myInit() async {
    u = await LoggedInUserModel.getLoggedInUser();
    //Utils.initOneSignal();

    return "Done";
  }

  Widget mainWidget() {
    menuItems = [];
    //4194 parent ID
    if (u.isRole('teacher')) {
      menuItems
          .add(MenuItem('Classes', 'T 1', FeatherIcons.edit, 'classes.png', () {
        Get.to(() => ClassesScreen());
      }));
    }

    if (u.isRole('teacher') || u.isRole('parent')) {
      String title = "Students";
      if (u.isRole('parent')) {
        title = "My Children";
      }
      menuItems
          .add(MenuItem(title, 'T 1', FeatherIcons.edit, 'students.png', () {
        Get.to(() => StudentsScreen({}));
      }));
    }

    if (u.isRole('dos') ||
        u.isRole('admin') ||
        u.isRole('bursar') ||
        u.isRole('parent')) {
      menuItems.add(MenuItem(
          'School Fees', 'T 1', FeatherIcons.edit, 'financial-account.jpg', () {
        Get.to(() => FinancialAccountsScreen({}));
      }));
    }

    if (u.isRole('bursar')) {
      menuItems.add(
          MenuItem('Transactions', 'T 1', FeatherIcons.edit, 'finance.png', () {
        Get.to(() => TransactionsScreen({}));
      }));
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
      menuItems.add(MenuItem(
          'Service Subscription', 'T 1', FeatherIcons.edit, 'admin.png', () {
        Get.to(() => ServiceSubscriptionScreen());
      }));
    }

    if (u.isRole('dos') ||
        u.isRole('admin') ||
        u.isRole('bursar') ||
        u.isRole('parent')) {
      menuItems.add(MenuItem(
          'Financial Accounts', 'T 1', FeatherIcons.edit, 'admin.png', () {
        Get.to(() => FinancialAccountsScreen({}));
      }));
    }

    return Column(
      children: [
        Container(
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
              InkWell(
                onTap: () {
                  myInit();
                },
                child: FxText.titleLarge(
                  'School Dynamics'.toUpperCase(),
                  maxLines: 1,
                  fontWeight: 800,
                  color: CustomTheme.primaryDark,
                ),
              ),
              InkWell(
                  onTap: () {
                    Get.to(() => const AccountSection());
                  },
                  child: const Icon(FeatherIcons.user)),
            ],
          ),
        ),
        const Divider(
          height: 0,
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
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
      ],
    );
  }
}
