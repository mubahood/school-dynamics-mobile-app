import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/controllers/MainController.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/screens/classes/ClassesScreen.dart';
import 'package:schooldynamics/sections/widgets.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../../models/MenuItem.dart';
import '../../../theme/app_theme.dart';
import '../../../design_system/design_system.dart';
import '../../account/login_screen.dart';
import '../../admin/AdminMenuScreen.dart';
import '../../exams/ExamsHomeScreen.dart';
import '../../finance/FinancialAccountsScreen.dart';
import '../../finance/ServicesScreen.dart';
import '../../posts/NewsHomeScreen.dart';
import '../../schemework/SchemeWorkHomeScreen.dart';
import '../../sessions/AttendanceScreen.dart';
import '../../sessions/SessionsScreen.dart';
import '../../students/StudentsScreen.dart';
import '../../transport/TransportHomeScreen.dart';
import '../../visitors/VisitorsBookScreen.dart';
import 'TransactionsScreen.dart';

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
      appBar: AppBar(
        backgroundColor: AppColors.primary,
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
    // Skip update check in demo mode to avoid API errors
    // checkForUpdate();

    futureInit = myInit();
    setState(() {});
  }

  List<MenuItem> menuItems = [];

  LoggedInUserModel u = LoggedInUserModel();

  //maincontroller find
  final MainController man = Get.find<MainController>();

  bool is_first_time = true;
  Future<dynamic> myInit() async {
    // In demo mode, avoid API calls that cause 500 errors
    // Only initialize essential local data

    if (is_first_time) {
      await Utils.init_theme();
    } else {
      Utils.init_theme();
    }

    // Skip version checks and online calls for demo
    // man.ent.get_version();
    // await man.ent.check_version();
    // LoggedInUserModel.getLoggedInUserOnline();

    u = await LoggedInUserModel.getLoggedInUser();

    // If no user found, create a basic demo user
    if (u.id == 0) {
      u.id = 1;
      u.name = "Demo Administrator";
      u.first_name = "Demo";
      u.last_name = "Administrator";
      u.user_type = "admin";
      // Initialize roles for demo user
      u.roles_text = jsonEncode([
        {'id': 1, 'name': 'Administrator', 'slug': 'admin'},
        {'id': 2, 'name': 'Teacher', 'slug': 'teacher'},
        {'id': 3, 'name': 'Director of Studies', 'slug': 'dos'},
        {'id': 4, 'name': 'Bursar', 'slug': 'bursar'},
        {'id': 5, 'name': 'Headmaster', 'slug': 'hm'},
      ]);
    }

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
        Get.to(() => ClassesScreen(const {}));
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
      menuItems.add(MenuItem(
          'School Fees', 'T 1', FeatherIcons.edit, 'financial-account.jpg', () {
        Get.to(() => FinancialAccountsScreen(const {}));
      }));
    }

    if (u.isRole('bursar')) {
      menuItems.add(
          MenuItem('Transactions', 'T 1', FeatherIcons.edit, 'finance.png', () {
        Get.to(() => TransactionsScreen(const {}));
      }));
      menuItems.add(
          MenuItem('Services', 'T 1', FeatherIcons.edit, 'services.png', () {
        Get.to(() => ServicesScreen(const {}));
      }));
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

    if (!u.isRole('parent')) {
      menuItems.add(MenuItem(
          'Roll-calling', 'T 1', FeatherIcons.edit, 'attandance.png', () {
        Get.to(() => const SessionsScreen());
      }));
    } else {
      menuItems.add(MenuItem(
          'Roll-calling', 'T 1', FeatherIcons.edit, 'attandance.png', () {
        Get.to(() => const AttendanceScreen());
      }));
    }

    if (u.isRole('dos') ||
        u.isRole('admin') ||
        u.isRole('hm') ||
        u.isRole('gate')) {
      menuItems.add(MenuItem(
          'Visitors\' Book', 'T 1', FeatherIcons.edit, 'visitor.png', () {
        Get.to(() => const VisitorsBookScreen());
      }));
    }

    if (u.isRole('teacher') || u.isRole('admin') || u.isRole('dos')) {
      menuItems.add(
          MenuItem('Scheme-work', 'T 1', FeatherIcons.edit, 'scheme.png', () {
        Get.to(() => const SchemeWorkHomeScreen());
      }));
    }

    if (u.isRole('driver') || u.isRole('admin')) {
      menuItems
          .add(MenuItem('Transport', 'T 1', FeatherIcons.edit, 'bus.jpg', () {
        Get.to(() => const TransportHomeScreen());
      }));
    }

    menuItems
        .add(MenuItem('School News', 'T 1', FeatherIcons.edit, 'news.png', () {
      Get.to(() => const NewsHomeScreen());
    }));

    if (u.isRole('teacher') || u.isRole('admin') || u.isRole('dos')) {
      menuItems.add(MenuItem(
          'Exams & Report Cards', 'T 1', FeatherIcons.edit, 'exams.png', () {
        Get.to(() => const ExamsHomeScreen());
      }));
    }

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
        // Enhanced Header with Modern Gradient
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1976D2), // Primary blue
                Color(0xFF1565C0), // Darker blue
                Color(0xFF0D47A1), // Even darker blue
              ],
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${Utils.greet(u.name)}, Welcome to',
                          style: AppTypography.bodyMedium.copyWith(
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w300,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        InkWell(
                          onTap: () {
                            myInit();
                          },
                          child: Text(
                            "${man.ent.name.toUpperCase()}.",
                            style: AppTypography.headlineSmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              height: 1.2,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withOpacity(0.2),
                                  offset: const Offset(0, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: roundedImage(man.ent.getLogo(), 8, 8, radius: 0),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding:
                const EdgeInsets.fromLTRB(16, 8, 16, 16), // Optimized padding
            child: RefreshIndicator(
              onRefresh: doRefresh,
              color: AppColors.primary,
              backgroundColor: AppColors.surface,
              child: SafeArea(
                child: CustomScrollView(
                  physics:
                      const BouncingScrollPhysics(), // Better scroll physics
                  slivers: [
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount:
                            3, // Changed to 3-column for compactness
                        crossAxisSpacing: AppSpacing.sm,
                        mainAxisSpacing: AppSpacing.sm,
                        childAspectRatio: 0.85, // More compact ratio
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          MenuItem item = menuItems[index];
                          return _buildEnhancedMenuItem(item);
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
        AppSpacing.gapMD,
      ],
    );
  }

  /// Modern compact menu item widget with gradient and visual appeal
  Widget _buildEnhancedMenuItem(MenuItem item) {
    // Create different gradient colors for visual variety
    final List<List<Color>> gradientOptions = [
      [const Color(0xFF6366F1), const Color(0xFF8B5CF6)], // Purple gradient
      [const Color(0xFF059669), const Color(0xFF10B981)], // Green gradient
      [const Color(0xFFDC2626), const Color(0xFFEF4444)], // Red gradient
      [const Color(0xFFD97706), const Color(0xFFF59E0B)], // Orange gradient
      [const Color(0xFF7C3AED), const Color(0xFFA855F7)], // Violet gradient
      [const Color(0xFF0EA5E9), const Color(0xFF3B82F6)], // Blue gradient
      [const Color(0xFFEC4899), const Color(0xFFF472B6)], // Pink gradient
      [const Color(0xFF14B8A6), const Color(0xFF06B6D4)], // Teal gradient
    ];

    // Select gradient based on item index for variety
    final gradientIndex = item.hashCode % gradientOptions.length;
    final selectedGradient = gradientOptions[gradientIndex];

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => item.f(),
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.white.withOpacity(0.3),
          highlightColor: Colors.white.withOpacity(0.1),
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  selectedGradient[0],
                  selectedGradient[1],
                ],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: selectedGradient[0].withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(12), // Much reduced padding
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Modern icon container with subtle backdrop
                  Container(
                    width: 44, // Slightly increased for better balance
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Center(
                      child: Image.asset(
                        'assets/icons/${item.img}',
                        width: 26, // Slightly larger icon
                        height: 26,
                        color: Colors.white,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            item.icon,
                            size: 26,
                            color: Colors.white,
                          );
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 10), // Slightly more spacing
                  // Improved title with better contrast
                  Text(
                    item.title,
                    style: AppTypography.bodySmall.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      fontSize: 11.5, // Slightly larger
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
