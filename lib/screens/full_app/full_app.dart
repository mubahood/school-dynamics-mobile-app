import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/full_app/section/AccountSection.dart';
import 'package:schooldynamics/screens/full_app/section/SectionDashboard.dart';

import '../../controllers/MainController.dart';
import '../../theme/custom_theme.dart';
import '../posts/PostModelsScreen.dart';

class FullApp extends StatefulWidget {
  static const String tag = "FullApp";

  const FullApp({super.key});

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
    return Scaffold(
            body: Row(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: TabBarView(
                          physics: const NeverScrollableScrollPhysics(),
                          controller: tabController,
                          children: <Widget>[
                            const SectionDashboard(),
                      PostModelsScreen('Notice', true),
                      PostModelsScreen('Event', true),
                      PostModelsScreen('News', true),
                      const AccountSection(),
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
                  padding: FxSpacing.only(
                    top: 5,
                    bottom: 3,
                  ),
                  marginAll: 0,
                  child: TabBar(
                    dividerColor: Colors.white,
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
                            myNavItem('Noticeboard',
                                Icons.chrome_reader_mode_outlined, 1),
                            myNavItem('Events', FeatherIcons.calendar, 2),
                            myNavItem('News', Icons.newspaper, 3),
                            myNavItem('Account', FeatherIcons.user, 4),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
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
            size: title.length < 16 ? 22 : 25,
            color: (tabController.index == i)
                ? CustomTheme.primary
                : Colors.grey[700],
          ),
          const SizedBox(
            height: 3,
          ),
          FxText.bodySmall(
            title,
            fontSize: title.length < 16 ? 12 : 8,
            color: (tabController.index == i)
                ? CustomTheme.primary
                : Colors.grey[700],
          ),
        ],
      ),
    );
  }
}
