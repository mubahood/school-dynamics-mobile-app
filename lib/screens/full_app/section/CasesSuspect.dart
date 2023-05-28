import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:schooldynamics/theme/app_theme.dart';

import '../../../sections/widgets.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/Utils.dart';
import '../../../utils/my_widgets.dart';

class SectionCases extends StatefulWidget {
  SectionCases({Key? key}) : super(key: key);

  @override
  _SectionCasesState createState() => _SectionCasesState();
}

class _SectionCasesState extends State<SectionCases> {
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
        barrierColor: CustomTheme.primary.withOpacity(.5),
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
                padding: EdgeInsets.all(12),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      onTap: () {},
                      leading: Icon(
                        FeatherIcons.plusCircle,
                        color: CustomTheme.primary,
                        size: 26,
                      ),
                      title: FxText.titleMedium(
                        "Create new case",
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
      floatingActionButton: FloatingActionButton(
        elevation: 10,
        backgroundColor: CustomTheme.primary,
        onPressed: () {
          my_init();
          //_showBottomSheet(context);
          //Utils.navigate_to(AppConfig.SuspectCreatePreviewScreen, context);
        },
        child: const Icon(
          FeatherIcons.plus,
          size: 25,
        ),
      ),
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
              "Academics",
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
                    "Sort",
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
                  return myListLoaderWidget(context);
                default:
                  return main_widget();
              }
            }),
      ),
    );
  }

  Widget main_widget() {
    if ([].isEmpty) {
      return noItemWidget('', () {
        do_refresh();
      });
    }
    return RefreshIndicator(
      onRefresh: do_refresh,
      color: CustomTheme.primary,
      backgroundColor: Colors.white,
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Text("romina");
              },
              childCount: [].length, // 1000 list items
            ),
          )
        ],
      ),
    );
  }
}
