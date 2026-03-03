import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:schooldynamics/screens/OnBoardingScreen.dart';
import 'package:schooldynamics/screens/full_app/full_app.dart';
import 'package:schooldynamics/screens/simple_design_demo.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:schooldynamics/utils/Utils.dart';
import 'package:schooldynamics/controllers/MainController.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Utils.init_theme();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme.init();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      builder: EasyLoading.init(),
      home: const SplashScreen(),
      routes: {
        '/OnBoardingScreen': (context) => const OnBoardingScreen(),
        '/SimpleDesignDemo': (context) => const SimpleDesignDemo(),
        AppConfig.FullApp: (context) => const FullApp(),
      },
    );
  }
}

class GlobalMaterialLocalizations {}

// ---------------------------------------------------------------------------
// Splash screen
// ---------------------------------------------------------------------------

/// Shows the branded splash while the app initialises, then routes the user to
/// [OnBoardingScreen] which decides whether to show the login page or jump
/// straight into the full app (based on saved token / user state).
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Primary colour bg + white icons — matches the splash background.
    SystemChrome.setSystemUIOverlayStyle(Utils.get_theme());
    _init();
  }

  Future<void> _init() async {
    // Seed the MainController so OnBoardingScreen can find it.
    Get.put(MainController());

    // Give the splash enough time to be seen (≈ 2 s).
    await Future.delayed(const Duration(milliseconds: 2000));

    if (!mounted) return;

    // OnBoardingScreen owns all auth-routing logic:
    //   • valid token  → FullApp
    //   • no token     → login form
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const OnBoardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Color primary = Theme.of(context).primaryColor;

    return Scaffold(
      backgroundColor: primary,
      body: Container(
        color: primary,
        child: CustomPaint(
          painter: _DotPatternPainter(Colors.white.withValues(alpha: 0.09)),
          child: SafeArea(
            child: Stack(
              children: [
                // ── Logo + title — truly centred regardless of bottom bar ──
                Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo tile
                      Container(
                        width: 100,
                        height: 100,
                        color: Colors.white.withValues(alpha: 0.15),
                        padding: const EdgeInsets.all(14),
                        child: Image.asset(
                          'assets/images/logo.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'School Dynamics',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                          letterSpacing: 0.4,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Professional School Management',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.white.withValues(alpha: 0.72),
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Progress indicator — pinned to bottom ──────────────────
                Positioned(
                  bottom: 52,
                  left: 0,
                  right: 0,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Center(
                        child: SizedBox(
                          width: 140,
                          child: LinearProgressIndicator(
                            color: Colors.white,
                            backgroundColor:
                                Colors.white.withValues(alpha: 0.25),
                            minHeight: 2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Loading…',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.55),
                          letterSpacing: 0.5,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Dot-grid background painter
// ---------------------------------------------------------------------------

/// Paints a uniform dot-grid pattern on primary-colour backgrounds.
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
