import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:schooldynamics/screens/OnBoardingScreen.dart';
import 'package:schooldynamics/screens/full_app/full_app.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:schooldynamics/utils/Utils.dart';

void main() {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();

  Utils.boot_system();
  Utils.init_databse();
  Utils.init_theme();

  CustomTheme.primary = Color(0xff225b4c);
  CustomTheme.primaryDark = Color(0xff225b4c);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AppTheme.init();

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      builder: (context, child) {
        return Directionality(
          textDirection: AppTheme.textDirection,
          child: child!,
        );
      },
      home: OnBoardingScreen(),
      routes: {
        '/OnBoardingScreen': (context) => OnBoardingScreen(),
        AppConfig.FullApp: (context) => FullApp(),
      },
    );
  }
}

class GlobalMaterialLocalizations {}
