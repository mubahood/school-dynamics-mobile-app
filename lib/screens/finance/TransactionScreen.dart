import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/Transaction.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../theme/custom_theme.dart';
import '../students/StudentScreen.dart';

class TransactionScreen extends StatefulWidget {
  dynamic data;

  TransactionScreen({super.key, this.data});

  @override
  TransactionScreenState createState() => TransactionScreenState();
}

class TransactionScreenState extends State<TransactionScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxButton.text(
                padding: const EdgeInsets.only(top: 20, left: 15),
                onPressed: () {
                  Get.back();
                },
                child: Icon(
                  FeatherIcons.x,
                  size: 30,
                  color: Colors.grey.shade700,
                )),
            const SizedBox(
              height: 10,
            ),
            Center(
                child: FxText.titleLarge(
              "TRANSACTION DETAILS",
              color: Colors.black,
            )),
            const SizedBox(
              height: 15,
            ),
            Center(
                child: FxContainer(
              height: 6,
              width: 70,
              color: CustomTheme.primary,
            )),
            const SizedBox(
              height: 15,
            ),
            Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: FxText.bodyLarge(
                  item.description,
                  height: 1.2,
                )),
            const SizedBox(
              height: 10,
            ),
            itemWidget('TYPE', item.type),
            Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: const Divider(
                  thickness: 3,
                  height: 20,
                )),
            itemWidget('DATE', Utils.to_date(item.payment_date)),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: const Divider(
                  thickness: 3,
                  height: 20,
                )),
            itemWidget('ACCOUNT', item.account_name),
            const SizedBox(
              height: 10,
            ),
            Container(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: const Divider(
                  thickness: 3,
                  height: 20,
                )),
            itemWidget(
              'AMOUNT',
              "UGX ${Utils.moneyFormat(item.amount)}",
              color: item.amount_figure < 1
                  ? Colors.red.shade800
                  : Colors.green.shade800,
            ),
            const SizedBox(
              height: 30,
            ),
            ListTile(
              onTap: () {
                Utils.launchBrowser('print-receipt?id=${item.id}');
              },
              trailing: Icon(
                FeatherIcons.download,
                color: CustomTheme.primary,
              ),
              dense: true,
              title: FxText.titleLarge(
                'Download receipt',
                color: CustomTheme.primary,
              ),
            ),
            const Divider(),
            ListTile(
              onTap: () {
                openAccountDetails();
              },
              title: FxText.titleLarge(
                'View account details',
                color: CustomTheme.primary,
              ),
              trailing: Icon(
                FeatherIcons.eye,
                color: CustomTheme.primary,
                size: 30,
              ),
            )
          ],
        ),
      ),
    );
  }

  itemWidget(String title, String detail, {Color color = Colors.black}) {
    return Flex(
      direction: Axis.horizontal,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(
          width: 15,
        ),
        FxText.titleLarge(
          title,
          fontWeight: 600,
          color: Colors.grey.shade600,
        ),
        const SizedBox(
          width: 10,
        ),
        Expanded(
          child: FxText.titleLarge(
            detail,
            fontWeight: 600,
            textAlign: TextAlign.end,
            color: color,
          ),
        ),
        const SizedBox(
          width: 15,
        ),
      ],
    );
  }

/*

        "id": 13963,
        "created_at": "2023-02-21 20:34:10",
        "type": "FEES_PAYMENT",
        "payment_date": "2023-02-21 20:27:14",
        "account_id": 447,
        "amount": 435000,
        "description": "Mulindwa  Uthman paid UGX 435,000 school fees through school pay. Transaction ID #81602117291",
        "account_name": "Mulindwa Uthman",
        "administrator_id": 2653


*
* */
  Transaction item = Transaction();

  Future<void> init() async {
    if (widget.data.runtimeType.toString() != 'Transaction') {
      Utils.toast('Data not found.');
      Get.back();
      return;
    }
    item = widget.data;
    getAccount();
    setState(() {});
  }

  UserModel u = UserModel();

  Future<void> getAccount() async {
    u = await UserModel.getItemById(item.administrator_id);
  }

  Future<void> openAccountDetails() async {
    if (u.id < 1) {
      Utils.toast("Only student's account can be viewed on the mobile app.");
      return;
    }
    Get.to(() => StudentScreen(data: u));
  }
}
