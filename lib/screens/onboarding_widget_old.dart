/*
* File : Custom Onboarding
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/full_app/full_app.dart';

import '../../../utils/AppConfig.dart';
import '../../../utils/Utils.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import 'account/login_screen.dart';

class OnBoardingScreenOld extends StatefulWidget {
  @override
  _OnBoardingWidgeScreen createState() => _OnBoardingWidgeScreen();
}

class _OnBoardingWidgeScreen extends State<OnBoardingScreenOld> {
  late CustomTheme customTheme;
  late ThemeData theme;

  @override
  void initState() {
    super.initState();
    customTheme = AppTheme.customTheme;
    theme = AppTheme.theme;
  }

  String title = "NO title";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [


        ],
      ),
    ));
  }




}
