import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/Transaction.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/screens/students/StudentsScreen.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../../sections/widgets.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/my_widgets.dart';
import '../../finance/TransactionCreateScreen.dart';
import '../../finance/TransactionScreen.dart';

class TransactionsScreen extends StatefulWidget {
  // ignore: prefer_const_constructors_in_immutables

  Map<String,dynamic> params= {};
  TransactionsScreen(this.params);

  @override
  _TransactionsScreenState createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends State<TransactionsScreen> {
  late Future<dynamic> futureInit;

  UserModel activeAccount = UserModel();

  Future<dynamic> do_refresh() async {

    futureInit = init();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    if(widget.params!=null){
      if(widget.params['activeAccount'] != null){
        if(widget.params['activeAccount'].runtimeType == activeAccount.runtimeType){
          activeAccount = widget.params['activeAccount'];
        }
      }
    }

    do_refresh();
  }

  Future<dynamic> init() async {
    if(activeAccount.id>0){
      items = await Transaction.getItems(where: 'administrator_id = ${activeAccount.id}');
    }else{
      items = await Transaction.getItems(where: '1');
    }
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
        title: FxText.titleLarge(
          "School fees payment",
          fontWeight: 900,
          color: Colors.white,
        ),
      ),
      //floating action button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          //show bottom sheet of create transaction
          Get.to(() => TransactionCreateScreen({}));
        },
        child: Icon(FeatherIcons.plus),
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
                      SliverAppBar(
                        toolbarHeight: Get.width / 5,
                        backgroundColor: Colors.white,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FxContainer(
                              color: Colors.white,
                              borderRadiusAll: 0,
                              padding: EdgeInsets.only(top: 8),
                              child: Wrap(
                                runSpacing: 0,
                                children: <Widget>[
                                  FxContainer(
                                    onTap: () async {
                                      if (activeAccount.id > 0) {
                                        activeAccount = UserModel();
                                        setState(() {});
                                        doRefresh();
                                        return;
                                      }
                                      var resp = await Get.to(
                                          StudentsScreen(const {
                                        "task_picker": 'task_picker'
                                      }));

                                      if (resp.runtimeType ==
                                          activeAccount.runtimeType) {
                                        activeAccount = resp;
                                        setState(() {});
                                        doRefresh();
                                      }

                                      //account_id = "a";
                                      setState(() {});
                                      return;
                                    },
                                    margin:
                                        const EdgeInsets.only(right: 5, top: 5),
                                    padding: const EdgeInsets.only(
                                        left: 5, right: 5, top: 5, bottom: 5),
                                    borderRadiusAll: 20,
                                    borderColor: CustomTheme.primary,
                                    bordered: true,
                                    color: (activeAccount.id > 0)
                                        ? CustomTheme.primary
                                        : Colors.grey.shade100,
                                    child: FxText(
                                      'Filter By Student',
                                      fontSize: 14,
                                      fontWeight: 700,
                                      color: activeAccount.id > 0
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Divider(
                              color: CustomTheme.primary,
                              height: 0,
                            ),
                            Container(
                                padding: EdgeInsets.only(bottom: 10, top: 5),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [

                                        FxText.bodyLarge(
                                          activeAccount.id>0?"Filter by ":  "Found ",
                                          fontWeight: 800,
                                        ),
                                        FxText.bodyLarge(
                                          activeAccount.id>0?activeAccount.name : "${items.length} transactions",
                                          color: Colors.black,
                                          fontWeight: 800,
                                        ),
                                      ],
                                    ),
                                  ],
                                ))
                          ],
                        ),
                        automaticallyImplyLeading: false,
                        floating: true,
                        elevation: 1,
                        leadingWidth: 0,
                        stretch: true,
                        shadowColor: CustomTheme.primary,
                      ),
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
