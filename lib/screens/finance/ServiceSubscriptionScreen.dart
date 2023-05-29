import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/MarksModel.dart';
import 'package:schooldynamics/models/ServiceSubscription.dart';
import 'package:schooldynamics/screens/finance/ServiceSubscriptionCreateScreen.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';

class ServiceSubscriptionScreen extends StatefulWidget {
  ServiceSubscriptionScreen({Key? key}) : super(key: key);

  @override
  ServiceSubscriptionScreenState createState() =>
      ServiceSubscriptionScreenState();
}

class ServiceSubscriptionScreenState extends State<ServiceSubscriptionScreen> {
  List<ServiceSubscription> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  Future<dynamic> doRefresh() async {
    futureInit = init();
    setState(() {});
  }

  bool canCreate = false;

  late Future<dynamic> futureInit;
  MarksModel localMark = MarksModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      floatingActionButton: !canCreate
          ? null
          : FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () async {
                await Get.to(() =>   ServiceSubscriptionCreateScreen({}));
                doRefresh();
              }),
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: FxText.titleLarge(
            "Service subscriptions",
            color: Colors.white,
          )),
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return myListLoaderWidget(context);
            }
            if (items.isEmpty) {
              return Center(child: FxText('No item found.'));
            }

            return RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: doRefresh,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        height: 15,
                      ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final ServiceSubscription m = items[index];
                    return Flex(
                      direction: Axis.horizontal,
                      children: [
                        const SizedBox(
                          width: 15,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.titleMedium(
                                "${m.administrator_text}",
                                color: Colors.black,
                                fontWeight: 700,
                              ),
                              FxText.bodySmall(
                                "TERM: ${m.due_term_text} \n ${m.service_text} X ${m.quantity}",
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              FxText.titleLarge(
                                Utils.moneyFormat(m.total),
                                color: Colors.black,
                                fontWeight: 800,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          width: 15,
                        ),
                      ],
                    );
                  }),
            );
          }),
    );
  }

  Future<void> init() async {
    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    items = await ServiceSubscription.getItems();
    if (u.isRole('bursar') || u.isRole('dos') || u.isRole('admin')) {
      canCreate = true;
    }
    setState(() {});
  }
}
