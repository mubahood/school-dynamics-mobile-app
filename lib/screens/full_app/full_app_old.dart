import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/screens/full_app/section/AccountSection.dart';
import 'package:schooldynamics/screens/full_app/section/CasesSuspect.dart';
import 'package:schooldynamics/screens/full_app/section/SectionDashboard.dart';
import 'package:schooldynamics/screens/full_app/section/SectionExhibits.dart';
import 'package:schooldynamics/screens/full_app/section/SectionSuspect.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../controllers/full_app_controller.dart';

class FullAppOld extends StatefulWidget {
  const FullAppOld({Key? key}) : super(key: key);

  @override
  _FullAppState createState() => _FullAppState();
}

class _FullAppState extends State<FullAppOld> with SingleTickerProviderStateMixin {
  late ThemeData theme;

  late FullAppController controller;

  @override
  void initState() {
    super.initState();

    theme = AppTheme.shoppingTheme;
    controller = FxControllerStore.putOrFind(FullAppController(this));
  }

  List<Widget> buildTab() {
    List<Widget> tabs = [];
    for (int i = 0; i < controller.navItems.length; i++) {
      tabs.add(
        Container(
          padding: EdgeInsets.zero,
          child: Column(
            children: [
              Icon(
                controller.navItems[i].iconData,
                size: controller.navItems[i].title.length < 10 ? 22 : 25,
                color: (controller.currentIndex == i)
                    ? CustomTheme.primary
                    : theme.colorScheme.onBackground,
              ),
              const SizedBox(
                height: 3,
              ),
              FxText.bodySmall(
                controller.navItems[i].title,
                fontSize: controller.navItems[i].title.length < 10 ? 12 : 8,
                color: (controller.currentIndex == i)
                    ? CustomTheme.primary
                    : theme.colorScheme.onBackground,
              ),
            ],
          ),
        ),
      );
    }
    return tabs;
  }

  @override
  Widget build(BuildContext context) {
    return FxBuilder<FullAppController>(
        controller: controller,
        builder: (controller) {
          return Scaffold(
            body: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      children: [

                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            controller: controller.tabController,
                            children: <Widget>[
                              SectionDashboard(),
                              SectionCases(),
                              SectionSuspect(),
                              SectionExhibits(),
                              AccountSection(),
                            ],
                          ),
                        ),
                        ([].isEmpty)
                            ? SizedBox()
                            : InkWell(
                          onTap: () {},
                          child: Container(
                            color: Colors.red.shade800,
                            child: Row(
                              children: [
                                FxSpacing.width(8),
                                FxText.titleSmall(
                                  "You have sc1121 cases not submitted.",
                                  color: Colors.white,
                                ),
                                const Spacer(),
                                FxContainer(
                                  margin: const EdgeInsets.only(
                                      right: 5, top: 5, bottom: 5),
                                  color: CustomTheme.bg_primary_light,
                                  padding: const EdgeInsets.only(
                                      left: 10,
                                      right: 5,
                                      top: 4,
                                      bottom: 2),
                                  child: Row(
                                    children: [
                                      FxText.bodySmall(
                                        "VIEW",
                                        fontWeight: 700,
                                        color: CustomTheme.primaryDark,
                                      ),
                                      Icon(
                                        FeatherIcons.chevronRight,
                                        color: CustomTheme.primaryDark,
                                        size: 15,
                                      )
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Utils.isDesktop(context)
                            ? SizedBox()
                            : FxContainer(
                          bordered: true,
                          enableBorderRadius: false,
                          border: Border(
                              top: BorderSide(
                                  color: theme.dividerColor,
                                  width: 1,
                                  style: BorderStyle.solid)),
                          padding: FxSpacing.xy(0, 5),
                          marginAll: 0,
                          color: theme.scaffoldBackgroundColor,
                          child: TabBar(
                            labelPadding: EdgeInsets.zero,
                            controller: controller.tabController,
                            indicator: FxTabIndicator(
                                indicatorColor: CustomTheme.primary,
                                indicatorHeight: 3,
                                radius: 4,
                                width: 60,
                                indicatorStyle:
                                FxTabIndicatorStyle.rectangle,
                                yOffset: -7),
                            indicatorSize: TabBarIndicatorSize.tab,
                            indicatorColor: CustomTheme.primary,
                            tabs: buildTab(),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
