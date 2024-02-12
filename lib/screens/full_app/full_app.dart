import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/full_app/section/AccountSection.dart';
import 'package:schooldynamics/screens/full_app/section/SectionDashboard.dart';

import '../../controllers/MainController.dart';
import '../../theme/custom_theme.dart';

class FullApp extends StatefulWidget {
  static const String tag = "FullApp";

  const FullApp({Key? key}) : super(key: key);

  @override
  _FullAppState createState() => _FullAppState();
}

class _FullAppState extends State<FullApp> with SingleTickerProviderStateMixin {
  final MainController mainController = Get.put(MainController());

  @override
  void initState() {
    tabController = TabController(length: 5, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.defaultDialog(
            middleText: "Are you sure you want close this App?",
            titleStyle: const TextStyle(color: Colors.black),
            actions: <Widget>[
              FxButton.outlined(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context);
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                borderColor: CustomTheme.primary,
                child: FxText(
                  'CLOSE APP',
                  color: CustomTheme.primary,
                ),
              ),
              FxButton.small(
                onPressed: () {
                  Navigator.pop(context);
                },
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                child: FxText(
                  'CANCEL',
                  color: Colors.white,
                ),
              )
            ]);
        return false;
      },
      child: Scaffold(
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: TabBarView(
                        physics: const NeverScrollableScrollPhysics(),
                        controller: tabController,
                        children: const <Widget>[
                          SectionDashboard(),
                          SectionDashboard(),
                          SectionDashboard(),
                          SectionDashboard(),
                          AccountSection(),
                        ],
                      ),
                    ),
                    FxContainer(
                      color: Colors.white,
                      bordered: true,
                      enableBorderRadius: false,
                      border: Border(
                          top: BorderSide(
                              width: 2,
                              color: Colors.grey.shade400,
                              style: BorderStyle.solid)),
                      padding: FxSpacing.xy(0, 5),
                      marginAll: 0,
                      child: TabBar(
                        labelPadding: EdgeInsets.zero,
                        controller: tabController,
                        indicator: FxTabIndicator(
                            indicatorColor: CustomTheme.primary,
                            indicatorHeight: 2,
                            radius: 4,
                            width: 60,
                            indicatorStyle: FxTabIndicatorStyle.rectangle,
                            yOffset: -7),
                        indicatorSize: TabBarIndicatorSize.tab,
                        indicatorColor: CustomTheme.primary,
                        tabs: [
                          myNavItem('Home', FeatherIcons.home, 0),
                          myNavItem('Noticeboard', FeatherIcons.messageSquare, 1),
                          myNavItem('Calendar', FeatherIcons.calendar, 2),
                          myNavItem('News', FeatherIcons.fileText, 3),
                          myNavItem('Account', FeatherIcons.user, 4),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late TabController tabController;

  Widget myNavItem(String title, IconData icon, int i) {
    return Container(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          Icon(
            icon,
            size: title.length < 10 ? 22 : 25,
            color: (tabController.index == i)
                ? CustomTheme.primary
                : Colors.grey[700],
          ),
          const SizedBox(
            height: 3,
          ),
          FxText.bodySmall(
            title,
            fontSize: title.length < 10 ? 12 : 8,
            color: (tabController.index == i)
                ? CustomTheme.primary
                : Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
