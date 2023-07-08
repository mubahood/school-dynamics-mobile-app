import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/MenuItem.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import '../admin/StudentsVerificationScreen.dart';
import 'FinancialAccountsScreen.dart';

class FinanceHomeScreen extends StatefulWidget {
  const FinanceHomeScreen({Key? key}) : super(key: key);

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<FinanceHomeScreen> {
  late ThemeData themeData;

  _CourseTasksScreenState();

  late Future<dynamic> futureInit;

  Future<Null> _my_init() async {
    futureInit = my_init();
    setState(() {});
  }

  Future<dynamic> my_init() async {
    //FinanceHomeScreen
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
      MenuItem('Statistics', 'Students school fees accounts',
          FeatherIcons.pieChart, 'accounts.png', () {
        Get.to(
          () => StudentsVerificationScreen(),
        );
      }),
      MenuItem('Financial accounts', 'Students school fees accounts',
          FeatherIcons.user, 'accounts.png', () {
        Get.to(
          () => FinancialAccountsScreen({}),
        );
      }),
      MenuItem('Transactions', 'List of recent school fees payments',
          FeatherIcons.dollarSign, 'transactions.png', () {
        Get.to(
          () => StudentsVerificationScreen(),
        );
      }),
      MenuItem('Service subscription', 'Manage students service subscriptions',
          FeatherIcons.server, 'transactions.png', () {
        Get.to(
          () => StudentsVerificationScreen(),
        );
      }),
      MenuItem('Bursary Beneficiaries', 'Manage Bursary Beneficiaries',
          FeatherIcons.award, 'transactions.png', () {
        Get.to(
          () => StudentsVerificationScreen(),
        );
      }),
    ];

    return Scaffold(
        appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          title: FxText.titleLarge(
            "Finance",
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: ListView.separated(
            itemBuilder: (BuildContext context, int index) {
              return listItem(menuItems[index]);
            },
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: Colors.grey.shade200),
            itemCount: menuItems.length,
          ),
        ));
  }
}
