import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/screens/full_app/section/SectionDashboard.dart';
import 'package:schooldynamics/theme/app_theme.dart';

import '../../controllers/full_app_controller.dart';

class FullApp extends StatefulWidget {
  const FullApp({Key? key}) : super(key: key);

  @override
  _FullAppState createState() => _FullAppState();
}

class _FullAppState extends State<FullApp> with SingleTickerProviderStateMixin {
  late ThemeData theme;

  late FullAppController controller;

  @override
  void initState() {
    super.initState();
    theme = AppTheme.shoppingTheme;
    controller = FxControllerStore.putOrFind(FullAppController(this));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: SectionDashboard()),
    );
  }
}
