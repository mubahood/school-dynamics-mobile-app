// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/LoggedInUserModel.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/Transaction.dart';
import 'package:schooldynamics/models/UserModel.dart';

import '../../../theme/app_theme.dart';
import '../../../utils/Utils.dart';

class ChangeAccountStatusScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  ChangeAccountStatusScreen(
    this.params, {
    Key? key,
  }) : super(key: key);

  @override
  ChangeAccountStatusScreenState createState() =>
      ChangeAccountStatusScreenState();
}

class ChangeAccountStatusScreenState extends State<ChangeAccountStatusScreen>
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
            color: Colors.black,
          ),
        ),
        title: FxText.titleMedium(
          "Changing account status",
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
                                                FxContainer(
                                                  width: double.infinity,
                                                  child: FxText.bodySmall(
                                                    "Current account status is ${account.status == '1' ? 'Verified' : 'Not Verified'}",
                                                    fontWeight: 700,
                                                    color: CustomTheme.primary,
                                                    textAlign: TextAlign.start,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                FormBuilderDropdown<String>(
                                                  name: 'status',
                                                  dropdownColor: Colors.white,
                                                  decoration: AppTheme
                                                      .InputDecorationTheme1(
                                                    label: "Stream",
                                                  ),
                                                  onChanged: (x) {
                                                    String y = x.toString();
                                                    if (y ==
                                                        'Account verified') {
                                                      account.status = '1';
                                                    } else {
                                                      account.status = '0';
                                                    }
                                                    setState(() {});
                                                  },
                                                  isDense: true,
                                                  items: [
                                                    'Account verified',
                                                    'Not verified',
                                                  ]
                                                      .map((sub) =>
                                                          DropdownMenuItem(
                                                            alignment:
                                                                AlignmentDirectional
                                                                    .centerStart,
                                                            value: sub,
                                                            child: Text(sub),
                                                          ))
                                                      .toList(),
                                                ),
                                                error_message.isEmpty
                                                    ? SizedBox()
                                                    : const SizedBox(
                                                        height: 10),
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

                                                          Get.defaultDialog(
                                                              middleText: ""
                                                                  "Are you sure you want to change the account status?",
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
        RespondModel(await Utils.http_post('accounts-change-status', {
      'status': account.status,
      'account_id': account.id,
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

   // account.save();

    Navigator.pop(context);
    return;
  }

  Future<bool> init_form() async {
    item = await LoggedInUserModel.getLoggedInUser();
    return true;
  }
}
