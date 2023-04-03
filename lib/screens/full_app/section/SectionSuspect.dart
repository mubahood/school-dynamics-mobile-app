import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/Transaction.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../../sections/widgets.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/my_widgets.dart';
import '../../finance/TransactionScreen.dart';

class SectionSuspect extends StatefulWidget {
  SectionSuspect({Key? key}) : super(key: key);

  @override
  _SectionSuspectState createState() => _SectionSuspectState();
}

class _SectionSuspectState extends State<SectionSuspect> {
  late Future<dynamic> futureInit;

  Future<dynamic> do_refresh() async {
    futureInit = init();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    do_refresh();
  }

  Random random = new Random();

  Future<dynamic> init() async {
    items = await Transaction.getItems();
    return "Done";
  }

  List<Transaction> items = [];

  Future<dynamic> doRefresh() async {
    futureInit = init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
              "Finance",
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return myListLoaderWidget(context);
              }
              if (items.isEmpty) {
                return noItemWidget('', () {
                  do_refresh();
                });
              }

              return Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: doRefresh,
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
                            Transaction m = items[index];
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
                                        color:
                                            CustomTheme.primary.withAlpha(20),
                                        paddingAll: 10,
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 0,
                                            top: 0),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FxText.bodySmall(
                                                Utils.to_date(m.created_at)),
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
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Divider(),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: items.length, // 1000 list items
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}
