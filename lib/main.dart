import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
// Hot reload test comment - modified!
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:schooldynamics/screens/OnBoardingScreen.dart';
import 'package:schooldynamics/screens/full_app/full_app.dart';
import 'package:schooldynamics/screens/simple_design_demo.dart';
// import 'package:schooldynamics/screens/design_system_showcase.dart'; // Temporarily commented out
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:schooldynamics/utils/Utils.dart';
import 'package:schooldynamics/controllers/MainController.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  await Utils.init_theme();

  runApp(const MyApp());
}

/*
*    flutter run --debug info option to get more log output.
[        ] > flutter run --scan to get full insights.
* */
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppTheme.init();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      builder: EasyLoading.init(),
      home: const DemoSchoolDynamicsApp(), // Show demo version with sample data
      routes: {
        '/OnBoardingScreen': (context) => const OnBoardingScreen(),
        '/SimpleDesignDemo': (context) => const SimpleDesignDemo(),
        // '/DesignSystemShowcase': (context) => const DesignSystemShowcase(), // Temporarily commented out
        AppConfig.FullApp: (context) => const FullApp(),
      },
    );
  }
}

class GlobalMaterialLocalizations {}

/// Demo app that shows School Dynamics with sample data
/// This bypasses authentication to showcase the final app ready for Play Store
class DemoSchoolDynamicsApp extends StatefulWidget {
  const DemoSchoolDynamicsApp({super.key});

  @override
  State<DemoSchoolDynamicsApp> createState() => _DemoSchoolDynamicsAppState();
}

class _DemoSchoolDynamicsAppState extends State<DemoSchoolDynamicsApp> {
  @override
  void initState() {
    super.initState();
    _initializeDemoData();
  }

  Future<void> _initializeDemoData() async {
    // Initialize the main controller with demo data
    final MainController mainController = Get.put(MainController());

    // Initialize demo enterprise data directly to avoid API calls
    mainController.ent.id = 1;
    mainController.ent.name = "Greenfield International School";
    mainController.ent.short_name = "Greenfield";
    mainController.ent.motto = "Excellence in Education";
    mainController.ent.phone_number = "+256 700 123 456";
    mainController.ent.email = "info@greenfield.edu.ug";
    mainController.ent.address = "Kampala, Uganda";
    mainController.ent.logo =
        "https://via.placeholder.com/100x100?text=GIS"; // Use placeholder for demo
    mainController.ent.details =
        "A modern international school providing quality education";
    mainController.ent.administrator_text = "Demo Administrator";
    mainController.ent.administrator_id = "1";

    // Create and save demo user with admin role
    LoggedInUserModel demoUser = LoggedInUserModel();
    demoUser.id = 1;
    demoUser.name = "Demo Administrator";
    demoUser.first_name = "Demo";
    demoUser.last_name = "Administrator";
    demoUser.email = "admin@greenfield.edu.ug";
    demoUser.phone_number_1 = "+256 700 123 456";
    demoUser.user_type = "admin";
    demoUser.username = "admin";
    demoUser.avatar =
        "https://via.placeholder.com/100x100?text=DA"; // Demo avatar

    // Set up demo roles - admin has all permissions
    demoUser.roles_text = jsonEncode([
      {'id': 1, 'name': 'Administrator', 'slug': 'admin'},
      {'id': 2, 'name': 'Teacher', 'slug': 'teacher'},
      {'id': 3, 'name': 'Director of Studies', 'slug': 'dos'},
      {'id': 4, 'name': 'Bursar', 'slug': 'bursar'},
      {'id': 5, 'name': 'Headmaster', 'slug': 'hm'},
    ]);

    // Save demo user to local storage for the app to use
    await demoUser.save();

    // Add a small delay for initialization
    await Future.delayed(const Duration(milliseconds: 1500));

    // Navigate to the full app
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FullApp()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.school,
                size: 64,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              Text(
                'School Dynamics',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Professional School Management',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white70,
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
