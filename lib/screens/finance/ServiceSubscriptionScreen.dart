import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/MarksModel.dart';
import 'package:schooldynamics/models/ServiceSubscription.dart';
import 'package:schooldynamics/screens/finance/ServiceSubscriptionCreateScreen.dart';

import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';

class ServiceSubscriptionScreen extends StatefulWidget {
  const ServiceSubscriptionScreen({super.key});

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
              child: const Icon(Icons.add),
              onPressed: () async {
                await Get.to(() =>   ServiceSubscriptionCreateScreen(const {}));
                doRefresh();
              }),
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
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
                    return ServiceSubscriptionWidget(m);
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
