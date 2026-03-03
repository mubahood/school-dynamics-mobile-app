import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/screens/account/login_screen.dart';

import '../../../theme/app_theme.dart';
import '../controllers/MainController.dart';
import '../utils/AppConfig.dart';
import '../utils/Utils.dart';
import 'account/ConfirmCreateNewSchoolAccountScreen.dart';
import 'account/EmailVerificationScreen.dart';
import 'account/EnterpriseRegisterScreen.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  _OnBoardingScreenState createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  @override
  void initState() {
    futureInit = my_init();
    super.initState();
    AppTheme.init();
  }

  late Future<dynamic> futureInit;

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      SystemChrome.setSystemUIOverlayStyle(Utils.get_theme());

      return SafeArea(
        child: Scaffold(

          body: FutureBuilder(
              future: futureInit,
              builder: (context, snapshot) {
                if (ready_to_create_ent == 'Yes') {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          FxText.titleLarge(
                              "Congrats! You are ready to register your school!",
                              textAlign: TextAlign.center,
                              fontWeight: 900,
                              color: Colors.green.shade700),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                            indent: Get.width * 0.3,
                            endIndent: Get.width * 0.3,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FxText.bodyMedium(
                              "You have successfully created and verified school admin account. Now you are ready to register your school and start using the system."),
                          const SizedBox(
                            height: 25,
                          ),
                          FxButton.block(
                            onPressed: () {
                              Get.to(() => EnterpriseModelEditScreen(const {}));
                            },
                            child: FxText.titleMedium(
                              "Register School".toUpperCase(),
                              color: Colors.white,
                              fontWeight: 900,
                              fontSize: 20,
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          FxButton.text(
                            onPressed: () {
                              //are you sure you want to logout
                              Get.dialog(AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Utils.logout();
                                      Get.to(() => const OnBoardingScreen(),
                                          preventDuplicates: false);
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ],
                              ));
                            },
                            child: FxText.titleMedium("Logout",
                                color: CustomTheme.accent, fontWeight: 900),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (account_not_verified == 'Yes') {
                  return SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(
                            height: 50,
                          ),
                          FxText.titleLarge("Email not verified"),
                          const SizedBox(
                            height: 20,
                          ),
                          Divider(
                            height: 2,
                            color: Colors.grey,
                            indent: Get.width * 0.3,
                            endIndent: Get.width * 0.3,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          FxText.bodyMedium(
                              "Your email (${logged_in_user.email}) is not verified. Please verify your email to continue."),
                          const SizedBox(
                            height: 50,
                          ),
                          FxButton.block(
                            onPressed: () {
                              Get.to(() => EmailVerificationScreen(
                                    logged_in_user,
                                    'VERIFY_EMAIL',
                                  ));
                            },
                            child: FxText.titleMedium(
                              "Verify Email",
                              color: Colors.white,
                              fontWeight: 900,
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          FxButton.text(
                            onPressed: () {
                              //are you sure you want to logout
                              Get.dialog(AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await Utils.logout();
                                      Get.to(() => const OnBoardingScreen(),
                                          preventDuplicates: false);
                                    },
                                    child: const Text("Logout"),
                                  ),
                                ],
                              ));
                            },
                            child: FxText.titleMedium("Logout",
                                color: CustomTheme.accent, fontWeight: 900),
                          ),
                        ],
                      ),
                    ),
                  );
                }
                if (is_not_logged_in != 'Yes') {
                  return Center(
                    child: InkWell(
                      onTap: () {
                        re_load();
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(
                              image: AssetImage(
                                AppConfig.logo,
                              ),
                              fit: BoxFit.cover,
                              width: 200),
                          const SizedBox(
                            height: 50,
                          ),
                          const Text("⌛ Loading...")
                        ],
                      ),
                    ),
                  );
                } else {
                  // ── Redesigned "not logged in" landing screen ──────────────
                  return Container(
                    color: CustomTheme.primary,
                    child: CustomPaint(
                      painter:
                          _DotPatternPainter(Colors.white.withValues(alpha: 0.09)),
                      child: Column(
                        children: [
                          // Primary header — logo + app name
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  AppConfig.logo,
                                  width: 88,
                                  height: 88,
                                  fit: BoxFit.contain,
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  AppConfig.APP_NAME,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                    letterSpacing: 0.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Sign in to access your school',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Colors.white.withValues(alpha: 0.75),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          // White bottom panel — actions
                          Container(
                            color: Colors.white,
                            padding:
                                const EdgeInsets.fromLTRB(24, 28, 24, 0),
                            child: SafeArea(
                              top: false,
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.stretch,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    height: 52,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: CustomTheme.primary,
                                        foregroundColor: Colors.white,
                                        elevation: 0,
                                        shape: const RoundedRectangleBorder(
                                          borderRadius: BorderRadius.zero,
                                        ),
                                      ),
                                      icon: const Icon(
                                          Icons.person_outline,
                                          size: 20),
                                      label: const Text(
                                        'Sign in with Phone or Email',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      onPressed: () =>
                                          Get.to(() => const LoginScreen()),
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  const Divider(
                                      height: 1,
                                      color: Color(0xFFE0E0E0)),
                                  const SizedBox(height: 16),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    children: [
                                      const Text(
                                        'New School? ',
                                        style: TextStyle(
                                          color: Color(0xFF757575),
                                          fontSize: 14,
                                        ),
                                      ),
                                      GestureDetector(
                                        onTap: () => Get.to(() =>
                                            const ConfirmCreateNewSchoolAccountScreen()),
                                        child: Text(
                                          'Register New School',
                                          style: TextStyle(
                                            color: CustomTheme.primary,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 24),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }
              }),
        ),
      );
    });
  }

  String is_not_logged_in = "";
  String account_not_verified = "";
  String ready_to_create_ent = "";
  Future<dynamic> my_init() async {
    Get.put(MainController());
    String token = await Utils.getToken();
    if (token.toString().length < 20) {
      is_not_logged_in = "Yes";
      setState(() {});
      return;
    }

    logged_in_user = (await LoggedInUserModel.getLoggedInUser());

    if (logged_in_user.id < 1) {
      is_not_logged_in = "Yes";
      setState(() {});
      return;
    }

    await Utils.init_theme();
    Utils.boot_system();
    Utils.initOneSignal(logged_in_user);

    if (logged_in_user.enterprise_id == '1' &&
        logged_in_user.verification == '1' &&
        logged_in_user.user_type.toLowerCase() == 'employee') {
      ready_to_create_ent = "Yes";
      setState(() {});
      return;
    }

    if (logged_in_user.verification != '1' &&
        logged_in_user.user_type.toLowerCase() == 'employee') {
      account_not_verified = "Yes";
      setState(() {});
      return;
    }

    Navigator.pushNamedAndRemoveUntil(context, AppConfig.FullApp, (r) => false);

    return "Done";
  }

  bool is_loading = true;
  LoggedInUserModel logged_in_user = LoggedInUserModel();

  void re_load() {
    setState(() {
      futureInit = my_init();
    });
  }
}

/// Paints a uniform dot-grid pattern on top of a solid background.
class _DotPatternPainter extends CustomPainter {
  final Color dotColor;
  _DotPatternPainter(this.dotColor);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = dotColor
      ..style = PaintingStyle.fill;
    const double spacing = 22;
    const double radius = 1.5;
    for (double x = 0; x <= size.width; x += spacing) {
      for (double y = 0; y <= size.height; y += spacing) {
        canvas.drawCircle(Offset(x, y), radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(_DotPatternPainter old) => old.dotColor != dotColor;
}
