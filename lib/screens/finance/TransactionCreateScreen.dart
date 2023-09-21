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

class TransactionCreateScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  TransactionCreateScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  TransactionCreateScreenState createState() => TransactionCreateScreenState();
}

class TransactionCreateScreenState extends State<TransactionCreateScreen>
    with SingleTickerProviderStateMixin {
  // ignore: non_constant_identifier_names
  bool is_loading = false;

  // ignore: non_constant_identifier_names
  bool miain_loading = false;

  String text = "";

  var initFuture;

  String amount = "";
  String date = "";

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
            color: Colors.black,
          ),
        ),
        title: FxText.titleMedium(
          "Creating school fees payament",
          fontSize: 20,
          color: Colors.black,
          fontWeight: 700,
        ),
      ),
      body: FutureBuilder(
          future: initFuture,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
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
                                                    label: "Amount",
                                                  ),
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators
                                                        .required(
                                                      errorText:
                                                          "Amount is required.",
                                                    ),
                                                    FormBuilderValidators
                                                        .numeric(
                                                      errorText:
                                                          "Amount must be a number.",
                                                    ),
                                                  ]),
                                                  keyboardType:
                                                      const TextInputType
                                                              .numberWithOptions(
                                                          decimal: false),
                                                  name: "amount",
                                                  onChanged: (value) {
                                                    amount = value.toString();
                                                  },
                                                  textInputAction:
                                                      TextInputAction.done,
                                                ),
                                                const SizedBox(height: 15),
                                                FormBuilderDateTimePicker(
                                                  decoration: CustomTheme.in_4(
                                                    label: "Due date",
                                                  ),
                                                  lastDate: DateTime.now(),
                                                  validator:
                                                      FormBuilderValidators
                                                          .compose([
                                                    FormBuilderValidators
                                                        .required(
                                                      errorText:
                                                          "Date is required.",
                                                    ),
                                                  ]),
                                                  onChanged: (value) {
                                                    date = value.toString();
                                                  },
                                                  name: "date",
                                                  textInputAction:
                                                      TextInputAction.done,
                                                ),

                                                error_message.isEmpty
                                                    ? SizedBox()
                                                    : const SizedBox(height: 10),
                                                error_message.isEmpty
                                                    ? SizedBox()
                                                    : FxContainer(
                                                  margin: EdgeInsets.only(
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
                                                  const EdgeInsets.only(right: 20, top: 10, bottom: 10),
                                                  child: Center(
                                                    child: CircularProgressIndicator(
                                                      strokeWidth: 2.0,
                                                      valueColor:
                                                      AlwaysStoppedAnimation<Color>(CustomTheme.primary),
                                                    ),
                                                  ),
                                                )
                                                    :                                                 FxButton.block(
                                                  onPressed: () {
                                                    if (!_fKey.currentState!
                                                        .validate()) {
                                                      Utils.toast(
                                                          'Fix some errors first.',
                                                          color: Colors
                                                              .red.shade700);
                                                      return;
                                                    }
                                                    Get.defaultDialog(
                                                        middleText: ""
                                                            "${account.name} paid school fees UGX ${Utils.moneyFormat(amount)} on ${(Utils.to_date(date))}"
                                                            "\n\nAre you sure you want submit this transaction?",
                                                        titleStyle:
                                                            const TextStyle(
                                                                color: Colors
                                                                    .black),
                                                        actions: <Widget>[
                                                          FxButton.small(
                                                            onPressed: () {
                                                              save_form();
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            padding:
                                                                const EdgeInsets
                                                                        .symmetric(
                                                                    vertical:
                                                                        10,
                                                                    horizontal:
                                                                        15),
                                                            child: FxText(
                                                              'SUBMIT',
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          FxButton.outlined(
                                                            onPressed: () {
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            padding: EdgeInsets
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
                                                  backgroundColor: FxAppTheme
                                                      .theme
                                                      .colorScheme
                                                      .primary,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          4.0),
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

    RespondModel resp = RespondModel(await Utils.http_post('transactions', {
      'account_id': account.id,
      'amount': amount,
      'date': date,
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

    Utils.toast(resp.message,isLong: true);

   Navigator.pop(context);
    return;
  }

  Future<bool> init_form() async {
    item = await LoggedInUserModel.getLoggedInUser();
    return true;
  }
}
