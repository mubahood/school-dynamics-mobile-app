import 'dart:convert';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/controllers/MainController.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/screens/classes/ClassesScreen.dart';
import 'package:schooldynamics/sections/widgets.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../../models/MenuItem.dart';
import '../../../theme/app_theme.dart';
import '../../../design_system/design_system.dart';
import '../../admin/AdminMenuScreen.dart';
import '../../assignments/AssignmentsHomeScreen.dart';
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

  List<dynamic> unclassedStudents = [];

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

    // Fetch unclassed students for admin/dos/hm roles
    if (u.isRole('admin') || u.isRole('dos') || u.isRole('hm')) {
      try {
        var resp = RespondModel(await Utils.http_get('unclassed-students', {}));
        if (resp.code == 200 && resp.data != null) {
          unclassedStudents = resp.data is List ? resp.data : [];
        }
      } catch (_) {
        unclassedStudents = [];
      }
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

    if (u.isRole('teacher') ||
        u.isRole('student') ||
        u.isRole('parent') ||
        u.isRole('admin') ||
        u.isRole('dos') ||
        u.isRole('hm')) {
      menuItems.add(MenuItem(
          'Assignments', 'T 1', FeatherIcons.bookOpen, 'scheme.png', () {
        Get.to(() => const AssignmentsHomeScreen());
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

    // ── Date & greeting ─────────────────────────────────────────
    final now = DateTime.now();
    const weekdays = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday'
    ];
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    final formattedDate =
        '${weekdays[now.weekday - 1]}, ${now.day} ${months[now.month - 1]} ${now.year}';
    final firstName = u.name.split(' ').first;
    final hour = now.hour;
    final greeting = hour < 12
        ? 'Good Morning,'
        : (hour < 17 ? 'Good Afternoon,' : 'Good Evening,');

    return Stack(
      children: [
        // Subtle dot-grid across entire background
        Positioned.fill(
          child: CustomPaint(painter: _SubtleDotPainter()),
        ),
        // Scrollable content
        RefreshIndicator(
          onRefresh: doRefresh,
          color: AppColors.primary,
          backgroundColor: Colors.white,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            slivers: [
              // Hero header with doodle pattern + floating welcome card
              SliverToBoxAdapter(
                child: _buildHeroHeader(greeting, firstName, formattedDate),
              ),
              // Unclassed students alert
              if (unclassedStudents.isNotEmpty)
                SliverToBoxAdapter(
                  child: _buildUnclassedStudentsAlert(),
                ),
              // Section label
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                  child: Row(
                    children: [
                      Container(width: 4, height: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      const Text(
                        'MODULES',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF424242),
                          letterSpacing: 1.2,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${menuItems.length} items',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFFBDBDBD),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 3-column grid of accent-topped cards
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
                sliver: SliverGrid(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _buildMenuItem(menuItems[index]),
                    childCount: menuItems.length,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // HERO HEADER — doodle pattern + floating welcome card
  // ═══════════════════════════════════════════════════════════════

  Widget _buildHeroHeader(
      String greeting, String firstName, String formattedDate) {
    return Column(
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            // Primary background with geometric doodle overlay
            Container(
              width: double.infinity,
              color: AppColors.primary,
              child: SafeArea(
                bottom: false,
                child: CustomPaint(
                  painter: _DoodlePatternPainter(color: Colors.white),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 24, 16, 80),
                    child: Column(
                      children: [
                        // Enterprise logo
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.3),
                              width: 1.5,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(3),
                            child: ClipRect(
                              child: roundedImage(man.ent.getLogo(), 48, 48,
                                  radius: 0),
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Enterprise name
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: Text(
                            man.ent.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            // Floating welcome card — overlaps header bottom
            Positioned(
              left: 16,
              right: 16,
              bottom: -40,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: const Color(0xFFE0E0E0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            greeting,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFF9E9E9E),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            firstName,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF212121),
                              letterSpacing: -0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            formattedDate,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: Color(0xFFBDBDBD),
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Role badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: AppColors.primarySurface,
                        border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.15)),
                      ),
                      child: Text(
                        u.user_type.capitalizeFirst ?? 'User',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Space for the overflowing welcome card
        const SizedBox(height: 52),
      ],
    );
  }

  // ═══════════════════════════════════════════════════════════════
  // MENU ITEM CARD — accent bar + icon + label
  // ═══════════════════════════════════════════════════════════════

  Widget _buildMenuItem(MenuItem item) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => item.f(),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: const Color(0xFFEEEEEE)),
          ),
          child: Column(
            children: [
              // Primary accent bar at top
              Container(height: 3, color: AppColors.primary),
              // Card content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Image.asset(
                          'assets/icons/${item.img}',
                          width: 44,
                          height: 44,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              item.icon,
                              size: 44,
                              color: AppColors.primary,
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF424242),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUnclassedStudentsAlert() {
    final count = unclassedStudents.length;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: GestureDetector(
        onTap: () {
          Get.to(() => UnclassedStudentsScreen(students: unclassedStudents));
        },
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFFFFF3E0),
            border: Border.all(color: const Color(0xFFFF9800)),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: const Color(0xFFFF9800).withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFE65100), size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$count Student${count > 1 ? 's' : ''} Not in Class',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFFE65100),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Active students not assigned to a class in the current academic year.',
                      style: TextStyle(fontSize: 12, color: Color(0xFF795548)),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: Color(0xFFE65100)),
            ],
          ),
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// UNCLASSED STUDENTS SCREEN
// ════════════════════════════════════════════════════════════════════

class UnclassedStudentsScreen extends StatelessWidget {
  final List<dynamic> students;
  const UnclassedStudentsScreen({super.key, required this.students});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Unclassed Students (${students.length})',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF212121),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(1),
          child: Container(height: 1, color: const Color(0xFFE0E0E0)),
        ),
      ),
      body: students.isEmpty
          ? const Center(child: Text('No unclassed students found.'))
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: students.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final s = students[index];
                final name = s['name'] ?? 'Unknown';
                final className = s['current_class_name'] ?? 'None';
                final yearName = s['year_name'] ?? 'N/A';
                return Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: const Color(0xFFE0E0E0)),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: AppColors.primarySurface,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          name.isNotEmpty ? name[0].toUpperCase() : '?',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              name,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF212121),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.class_outlined,
                                    size: 14, color: Color(0xFF9E9E9E)),
                                const SizedBox(width: 4),
                                Text(
                                  className,
                                  style: const TextStyle(
                                    fontSize: 12,
                                    color: Color(0xFF757575),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFFFF3E0),
                                    border: Border.all(
                                        color: const Color(0xFFFFCC80)),
                                  ),
                                  child: Text(
                                    yearName,
                                    style: const TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFFE65100),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}

// ════════════════════════════════════════════════════════════════════
// CUSTOM PAINTERS — Background patterns & geometric doodles
// ════════════════════════════════════════════════════════════════════

/// Draws education-themed geometric doodles on the primary header.
///
/// Scatters circles, stars, diamonds, triangles, plus signs,
/// dot clusters, and small squares across the painting area using
/// [color] at low opacity. A fixed random seed (42) ensures the
/// pattern is deterministic and consistent across rebuilds.
class _DoodlePatternPainter extends CustomPainter {
  final Color color;
  _DoodlePatternPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final strokePaint = Paint()
      ..color = color.withValues(alpha: 0.10)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = color.withValues(alpha: 0.06)
      ..style = PaintingStyle.fill;

    final rng = math.Random(42);

    for (int i = 0; i < 45; i++) {
      final x = rng.nextDouble() * size.width;
      final y = rng.nextDouble() * size.height;
      final shape = rng.nextInt(7);
      final s = 6.0 + rng.nextDouble() * 16;

      switch (shape) {
        case 0: // Circle
          canvas.drawCircle(Offset(x, y), s / 2, strokePaint);
          break;
        case 1: // Plus sign
          canvas.drawLine(
              Offset(x - s / 2, y), Offset(x + s / 2, y), strokePaint);
          canvas.drawLine(
              Offset(x, y - s / 2), Offset(x, y + s / 2), strokePaint);
          break;
        case 2: // Diamond
          final path = Path()
            ..moveTo(x, y - s / 2)
            ..lineTo(x + s / 2, y)
            ..lineTo(x, y + s / 2)
            ..lineTo(x - s / 2, y)
            ..close();
          canvas.drawPath(path, strokePaint);
          break;
        case 3: // Triangle
          final path = Path()
            ..moveTo(x, y - s / 2)
            ..lineTo(x + s / 2, y + s / 3)
            ..lineTo(x - s / 2, y + s / 3)
            ..close();
          canvas.drawPath(path, strokePaint);
          break;
        case 4: // Five-point star
          _drawStar(canvas, x, y, s / 2, strokePaint);
          break;
        case 5: // Dot cluster
          for (int j = 0; j < 3; j++) {
            canvas.drawCircle(
              Offset(x + rng.nextDouble() * s - s / 2,
                  y + rng.nextDouble() * s - s / 2),
              1.5,
              dotPaint,
            );
          }
          break;
        case 6: // Small square
          canvas.drawRect(
            Rect.fromCenter(
                center: Offset(x, y), width: s * 0.7, height: s * 0.7),
            strokePaint,
          );
          break;
      }
    }
  }

  void _drawStar(Canvas canvas, double cx, double cy, double r, Paint paint) {
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outerAngle = (i * 72 - 90) * math.pi / 180;
      final innerAngle = ((i * 72) + 36 - 90) * math.pi / 180;
      final outerX = cx + r * math.cos(outerAngle);
      final outerY = cy + r * math.sin(outerAngle);
      final innerX = cx + r * 0.4 * math.cos(innerAngle);
      final innerY = cy + r * 0.4 * math.sin(innerAngle);
      if (i == 0) {
        path.moveTo(outerX, outerY);
      } else {
        path.lineTo(outerX, outerY);
      }
      path.lineTo(innerX, innerY);
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Draws a subtle evenly-spaced dot grid across the content background,
/// adding visual texture without distracting from the UI content.
class _SubtleDotPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFE8E8E8)
      ..style = PaintingStyle.fill;

    const spacing = 24.0;
    for (double x = 12; x < size.width; x += spacing) {
      for (double y = 12; y < size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
