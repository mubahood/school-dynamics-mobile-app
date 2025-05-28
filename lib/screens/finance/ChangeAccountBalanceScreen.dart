// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/Transaction.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/screens/finance/FinancialAccountsScreen.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/Utils.dart';

class ChangeAccountBalanceScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  ChangeAccountBalanceScreen(
    this.params, {
    super.key,
  });

  @override
  ChangeAccountBalanceScreenState createState() =>
      ChangeAccountBalanceScreenState();
}

class ChangeAccountBalanceScreenState extends State<ChangeAccountBalanceScreen>
    with SingleTickerProviderStateMixin {
  // ignore: non_constant_identifier_names
  bool is_loading = false;

  // ignore: non_constant_identifier_names
  bool miain_loading = false;

  String text = "";

  var initFuture;

  String amount = "";

  @override
  void initState() {
    super.initState();
    if (widget.params['account'].runtimeType == account.runtimeType) {
      account = widget.params['account'];
    }
    initFuture = init_form();
  }

  UserModel account = UserModel();

  LoggedInUserModel item = LoggedInUserModel();
  final _fKey = GlobalKey<FormBuilderState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        systemOverlayStyle: Utils.overlay(),
        leading: InkWell(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.white,
          ),
        ),
        title: FxText.titleMedium(
          "Changing account balance",
          fontSize: 20,
          color: Colors.white,
          fontWeight: 700,
        ),
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return FormBuilder(
              key: _fKey,
              child: Stack(
                children: [
                  miain_loading
                      ? const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        )
                      : CustomScrollView(
                          slivers: [
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                (BuildContext context, int index) {
                                  return Container(
                                      padding: const EdgeInsets.all(0),
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.only(
                                              left: 15,
                                              top: 10,
                                              right: 15,
                                            ),
                                            child: Column(
                                              children: [
                                                FxContainer(
                                                  width: double.infinity,
                                                  child: FxText.bodySmall(
                                                    "Current balance is UGX ${Utils.moneyFormat(account.balance.toString())}",
                                                    fontWeight: 700,
                                                    color: CustomTheme.primary,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                FormBuilderTextField(
                                                  decoration: CustomTheme.in_4(
                                                    label: "Select account",
                                                  ),
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators
                                                        .required(
                                                      errorText:
                                                          "Account is required.",
                                                    ),
                                                  ]),
                                                  initialValue: account.name,
                                                  textCapitalization:
                                                      TextCapitalization.words,
                                                  name: "account_text",
                                                  readOnly: true,
                                                  onTap: () async {
                                                    var result = await Get.to(() =>
                                                        FinancialAccountsScreen(
                                                            const {'isSelect': true}));
                                                    if (result != null &&
                                                        result.runtimeType ==
                                                            account
                                                                .runtimeType) {
                                                      account = result;
                                                      _fKey.currentState!
                                                          .patchValue({
                                                        'account_text':
                                                            account.name
                                                      });
                                                    }
                                                  },
                                                  textInputAction:
                                                      TextInputAction.next,
                                                ),
                                                const SizedBox(height: 15),
                                                FormBuilderTextField(
                                                  decoration: CustomTheme.in_4(
                                                    label:
                                                        "New Account Balance",
                                                  ),
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators
                                                        .required(
                                                      errorText:
                                                          "Balance is required.",
                                                    ),
                                                    FormBuilderValidators
                                                        .numeric(
                                                      errorText:
                                                          "Balance must be a number.",
                                                    ),
                                                  ]),
                                                  keyboardType:
                                                      const TextInputType
                                                              .numberWithOptions(
                                                          decimal: false),
                                                  name: "amount",
                                                  onChanged: (value) {
                                                    amount = value.toString();
                                                    if (int.parse(amount) > 0) {
                                                      amount = "-$amount";
                                                    }
                                                  },
                                                  textInputAction:
                                                      TextInputAction.done,
                                                ),
                                                error_message.isEmpty
                                                    ? const SizedBox()
                                                    : const SizedBox(
                                                        height: 10),
                                                error_message.isEmpty
                                                    ? const SizedBox()
                                                    : FxContainer(
                                                        margin: const EdgeInsets.only(
                                                            bottom: 10),
                                                        color:
                                                            Colors.red.shade50,
                                                        child: Text(
                                                          error_message,
                                                        ),
                                                      ),
                                                const SizedBox(height: 15),
                                                is_loading
                                                    ? Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                right: 20,
                                                                top: 10,
                                                                bottom: 10),
                                                        child: Center(
                                                          child:
                                                              CircularProgressIndicator(
                                                            strokeWidth: 2.0,
                                                            valueColor:
                                                                AlwaysStoppedAnimation<
                                                                        Color>(
                                                                    CustomTheme
                                                                        .primary),
                                                          ),
                                                        ),
                                                      )
                                                    : FxButton.block(
                                                  padding:
                                                  const EdgeInsets.fromLTRB(24, 24, 24, 24),
                                                        onPressed: () {
                                                          if (!_fKey
                                                              .currentState!
                                                              .validate()) {
                                                            Utils.toast(
                                                                'Fix some errors first.',
                                                                color: Colors
                                                                    .red
                                                                    .shade700);
                                                            return;
                                                          }
                                                          if (int.parse(
                                                                  amount) >
                                                              0) {
                                                            amount = "-$amount";
                                                          }
                                                          Get.defaultDialog(
                                                              middleText: ""
                                                                  "Are you sure you want to change the balance of this account to ${Utils.moneyFormat(amount.toString())} ?",
                                                              titleStyle:
                                                                  const TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                              actions: <Widget>[
                                                                FxButton.small(
                                                                  onPressed:
                                                                      () {
                                                                    save_form();
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          15),
                                                                  child: FxText(
                                                                    'SUBMIT',
                                                                    color: Colors
                                                                        .white,
                                                                  ),
                                                                ),
                                                                FxButton
                                                                    .outlined(
                                                                  onPressed:
                                                                      () {
                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  padding: const EdgeInsets
                                                                          .symmetric(
                                                                      vertical:
                                                                          10,
                                                                      horizontal:
                                                                          15),
                                                                  borderColor:
                                                                      CustomTheme
                                                                          .primary,
                                                                  child: FxText(
                                                                    'CANCEL',
                                                                    color: CustomTheme
                                                                        .primary,
                                                                  ),
                                                                ),
                                                              ]);
                                                        },
                                                        backgroundColor:
                                                            FxAppTheme
                                                                .theme
                                                                .colorScheme
                                                                .primary,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(4.0),
                                                        child: FxText.bodySmall(
                                                          "SUBMIT",
                                                          color: Colors.white,
                                                          fontWeight: 600,
                                                        ),
                                                      ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ));
                                },
                                childCount: 1, // 1000 list items
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            );
          }),
    );
  }

  String error_message = "";

  // ignore: non_constant_identifier_names
  save_form() async {
    if (is_loading) {
      return;
    }
    item = await LoggedInUserModel.getLoggedInUser();

    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }
    setState(() {
      error_message = "";
      is_loading = true;
    });

    RespondModel resp =
        RespondModel(await Utils.http_post('accounts-change-balance', {
      'account_id': account.id,
      'amount': amount,
    }));

    setState(() {
      error_message = "";
      is_loading = false;
    });

    if (resp.code != 1) {
      is_loading = false;
      error_message = resp.message;
      setState(() {});
      Utils.toast('Failed', color: Colors.red.shade700);
      return;
    }
    Transaction.getItems();
    UserModel.getItems();

    Utils.toast(resp.message, isLong: true);
    UserModel.getItems();
    Transaction.getItems();

    Navigator.pop(context);
    return;
  }

  Future<bool> init_form() async {
    item = await LoggedInUserModel.getLoggedInUser();
    return true;
  }
}
