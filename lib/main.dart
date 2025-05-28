import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:schooldynamics/screens/OnBoardingScreen.dart';
import 'package:schooldynamics/screens/full_app/full_app.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:schooldynamics/utils/Utils.dart';

Future<void> main() async {
  //You will need to initialize AppThemeNotifier class for theme changes.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

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
      home: const OnBoardingScreen(),
      routes: {
        '/OnBoardingScreen': (context) => const OnBoardingScreen(),
        AppConfig.FullApp: (context) => const FullApp(),
      },
    );
  }
}

class GlobalMaterialLocalizations {}
