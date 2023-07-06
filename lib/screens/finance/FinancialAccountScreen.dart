import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/screens/students/StudentEditPhotoScreen.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/Transaction.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/my_widgets.dart';
import '../finance/TransactionScreen.dart';

class FinancialAccountScreen extends StatefulWidget {
  const FinancialAccountScreen({Key? key, required this.data})
      : super(key: key);
  final dynamic data;

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<FinancialAccountScreen> {
  late ThemeData themeData;

  _CourseTasksScreenState();

  late Future<dynamic> futureInit;

  Future<dynamic> _my_init() async {
    futureInit = my_init();
    setState(() {});
    return "done";
  }

  UserModel item = UserModel();

  Future<dynamic> my_init() async {
    item = widget.data;
    transactions =
        await Transaction.getItems(where: ' administrator_id = ${item.id} ');
    setState(() {});
    return "Done";
  }

  @override
  void initState() {
    _my_init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.primary,
        onPressed: () {
          _my_init();
        },
        child: PopupMenuButton<int>(
            onSelected: (x) {
              switch (x.toString()) {
                case '1':
                  break;
                case '2':
                  Get.to(() => StudentEditPhotoScreen(
                        data: item,
                      ));
                  break;

                case '3':
                  break;
              }
            },
            icon: const Icon(
              FeatherIcons.moreVertical,
              size: 25,
              color: Colors.white,
            ),
            itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Icon(
                          FeatherIcons.plus,
                          color: CustomTheme.primary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(child: FxText.bodyLarge('Add transaction')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.arrowLeft,
                          color: CustomTheme.primary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Add service'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.arrowRight,
                          color: CustomTheme.primary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Add bursary'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.edit3,
                          color: CustomTheme.primary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Change balance'),
                      ],
                    ),
                  ),
                ]),
      ),
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        // remove back button in appbar.

        title: FxText.titleLarge(
          item.name,
          color: Colors.white,
        ),
      ),
      body: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            toolbarHeight: 48,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*-------------- Build Tabs here ------------------*/
                TabBar(
                  padding: EdgeInsets.only(bottom: 0),
                  labelPadding: EdgeInsets.only(bottom: 2, left: 8, right: 8),
                  indicatorPadding: EdgeInsets.all(0),
                  labelColor: CustomTheme.primary,
                  isScrollable: true,
                  enableFeedback: true,
                  indicator: UnderlineTabIndicator(
                      borderSide:
                          BorderSide(color: CustomTheme.primary, width: 4)),
                  tabs: [
                    Tab(
                        height: 30,
                        child: FxText.titleMedium(
                          "SUMMARY".toUpperCase(),
                          fontWeight: 600,
                          color: CustomTheme.primary,
                        )),
                    Tab(
                        height: 30,
                        child: FxText.titleMedium("Services".toUpperCase(),
                            fontWeight: 600, color: CustomTheme.primary)),
                    Tab(
                        height: 30,
                        child: FxText.titleMedium("Fees payment".toUpperCase(),
                            fontWeight: 600, color: CustomTheme.primary)),
                  ],
                )
              ],
            ),
          ),

          /*--------------- Build Tab body here -------------------*/
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return mainFragment();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return studentsFragment();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return feesFragment();
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }

  mainFragment() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Container(
                        child: Column(
                      children: [
                        title_widget('BIO DATA'),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: titleValueWidget('NAME', '${item.name}')),
                        Container(
                            child: titleValueWidget('SEX', '${item.sex}')),
                        Container(
                            child: titleValueWidget(
                                'CLASS', '${item.current_class_text}')),
                      ],
                    )),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  FxContainer(
                    bordered: true,
                    color: CustomTheme.primary.withAlpha(30),
                    borderColor: CustomTheme.primary,
                    paddingAll: 5,
                    borderRadiusAll: 0,
                    child: roundedImage(
                      item.avatar.toString(),
                      2.6,
                      2,
                      radius: 0,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              title_widget('SCHOOL FEES BALANCE'),
              const SizedBox(
                height: 10,
              ),
              Center(
                child: FxText.titleLarge(
                  'UGX ${Utils.moneyFormat("${item.balance}")}',
                  fontSize: 35,
                  color: item.balance < 0
                      ? Colors.red.shade900
                      : Colors.green.shade900,
                  textAlign: TextAlign.center,
                  fontWeight: 700,
                ),
              ),
              SizedBox(
                width: 8,
              ),
              Center(
                child: FxCard(
                  child: FxText.bodySmall(
                    '${item.verification == '1' ? 'Verified Balance' : 'Not Verified Balance'}',
                    fontWeight: 800,
                    color: Colors.white,
                  ),
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 2),
                  marginAll: 0,
                  color: item.verification == '1'
                      ? Colors.green.shade700
                      : Colors.red.shade700,
                ),
              ),
              Divider(
                color: CustomTheme.primary,
              )
            ],
          ),
        ],
      ),
    );
  }

  studentsFragment() {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FxText.bodyMedium("$index");
              },
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }

  List<Transaction> transactions = [];

  feesFragment() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return const SizedBox(
                  height: 10,
                );
              },
              childCount: 1, // 1000 list items
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                Transaction m = transactions[index];
                return InkWell(
                  onTap: () {
                    Get.to(() => TransactionScreen(
                          data: m,
                        ));
                  },
                  child: Column(
                    children: [
                      Flex(
                        direction: Axis.horizontal,
                        children: [
                          FxContainer(
                            color: CustomTheme.primary.withAlpha(20),
                            paddingAll: 10,
                            margin: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 0, top: 0),
                            child: Icon(
                              m.amount_figure < 1
                                  ? FeatherIcons.arrowUp
                                  : FeatherIcons.arrowDown,
                              color: m.amount_figure < 1
                                  ? Colors.red.shade800
                                  : Colors.green.shade800,
                            ),
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FxText.bodySmall(Utils.to_date(m.created_at)),
                                FxText.titleMedium(
                                  m.account_name,
                                  maxLines: 1,
                                  color: Colors.grey.shade800,
                                  fontWeight: 800,
                                )
                              ],
                            ),
                          ),
                          FxText.bodyLarge(
                            Utils.moneyFormat(m.amount),
                            fontWeight: 700,
                            color: (m.amount_figure < 0)
                                ? Colors.red.shade700
                                : Colors.green.shade700,
                          ),
                          const SizedBox(
                            width: 10,
                          )
                        ],
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 10, right: 10),
                        child: Divider(),
                      ),
                    ],
                  ),
                );
              },
              childCount: transactions.length, // 1000 list items
            ),
          )
        ],
      ),
    );
  }
}
