import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/full_app/section/AccountSection.dart';
import 'package:schooldynamics/screens/full_app/section/SectionDashboard.dart';

import '../../controllers/MainController.dart';
import '../../theme/custom_theme.dart';
import '../../design_system/design_system.dart';
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
                AppCard.elevated(
                  child: TabBar(
                    dividerColor: Colors.transparent,
                    labelPadding: const EdgeInsets.all(AppSpacing.xs),
                    controller: tabController,
                    indicator: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: AppSpacing.borderRadiusSM,
                    ),
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabs: [
                      _buildNavItem('Home', FeatherIcons.home, 0),
                      _buildNavItem(
                          'Notices', Icons.chrome_reader_mode_outlined, 1),
                      _buildNavItem('Events', FeatherIcons.calendar, 2),
                      _buildNavItem('News', Icons.newspaper, 3),
                      _buildNavItem('Account', FeatherIcons.user, 4),
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

  Widget _buildNavItem(String title, IconData icon, int index) {
    final isActive = tabController.index == index;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: AppSpacing.iconMD,
            color: isActive ? AppColors.onPrimary : AppColors.textSecondary,
          ),
          AppSpacing.gapXS,
          Text(
            title,
            style: AppTypography.bodySmall.copyWith(
              color: isActive ? AppColors.onPrimary : AppColors.textSecondary,
              fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }

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
