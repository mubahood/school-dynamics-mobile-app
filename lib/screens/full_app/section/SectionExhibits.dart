import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/theme/app_theme.dart';

import '../../../theme/custom_theme.dart';
import '../../../utils/Utils.dart';

class SectionExhibits extends StatefulWidget {
  SectionExhibits({Key? key}) : super(key: key);

  @override
  _SectionExhibitsState createState() => _SectionExhibitsState();
}

class _SectionExhibitsState extends State<SectionExhibits> {
  late Future<dynamic> futureInit;

  Future<dynamic> do_refresh() async {
    futureInit = my_init();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    futureInit = my_init();
  }

  Future<dynamic> my_init() async {
    return "Done";
  }

  void _showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Container(
                padding: EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FeatherIcons.plus,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Add suspect with new case",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FeatherIcons.plusCircle,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Add suspect to existing case",
                        fontSize: 18,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Utils.overlay(),
        elevation: .5,
        title: Row(
          children: [
            FxContainer(
              width: 10,
              height: 20,
              color: CustomTheme.primary,
              borderRadiusAll: 2,
            ),
            FxSpacing.width(8),
            FxText.titleLarge(
              "Notice board",
              fontWeight: 900,
            ),
            const Spacer(),
            FxContainer(
              color: CustomTheme.bg_primary_light,
              padding:
                  const EdgeInsets.only(left: 10, right: 10, top: 6, bottom: 6),
              child: Row(
                children: [
                  FxText(
                    "Filter",
                    fontWeight: 700,
                    color: CustomTheme.primaryDark,
                    fontSize: 16,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Icon(
                    FeatherIcons.filter,
                    size: 20,
                    color: CustomTheme.primaryDark,
                  )
                ],
              ),
            )
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: Text("⌛ Loading..."),
                  );
                default:
                  return Text("Coming soon...");
              }
            }),
      ),
    );
  }
}
