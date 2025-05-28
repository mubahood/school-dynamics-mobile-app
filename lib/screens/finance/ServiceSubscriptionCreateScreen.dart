// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/Service.dart';
import 'package:schooldynamics/models/ServiceSubscription.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/screens/finance/ServicesScreen.dart';

import '../../../theme/app_theme.dart';
import '../../../theme/custom_theme.dart';
import '../../../utils/Utils.dart';
import '../../sections/widgets.dart';
import '../students/StudentsScreen.dart';

class ServiceSubscriptionCreateScreen extends StatefulWidget {
  Map<String,dynamic> data = {};
  ServiceSubscriptionCreateScreen( this.data,{
    super.key,
  });

  @override
  ServiceSubscriptionCreateScreenState createState() =>
      ServiceSubscriptionCreateScreenState();
}

class ServiceSubscriptionCreateScreenState
    extends State<ServiceSubscriptionCreateScreen>
    with SingleTickerProviderStateMixin {
  // ignore: non_constant_identifier_names
  bool is_loading = false;

  // ignore: non_constant_identifier_names
  bool miain_loading = false;

  String text = "";

  var initFuture;

  int acc_id = 0;
  @override
  void initState() {
    super.initState();
    if(widget.data['id']!=null){
      if(Utils.int_parse(widget.data['id']) >0 ){
        acc_id = Utils.int_parse(widget.data['id']);

      }
    }
      initFuture = init_form();
  }

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
        actions: [
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
              : FxButton.text(
                  onPressed: () {
                    initFuture = init_form();
                    setState(() {

                    });
                  },
                  child: FxText.bodyLarge(
                    "REFRESH",
                    color: CustomTheme.primary,
                    fontWeight: 800,
                  ))
        ],
        title: FxText.titleMedium(
          "New Service Subscription",
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
            //error_message = "";

            return FormBuilder(
              key: _fKey,
              child: Stack(
                children: [
                  if (miain_loading)
                    const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.0,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                      ),
                    )
                  else
                    Column(
                      children: [
                        Container(
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
                                        decoration: CustomTheme.in_3(
                                          label: "Select service subscriber",
                                        ),
                                        onTap: () async {
                                          var resp = await Get.to(
                                              StudentsScreen(const {
                                            "task_picker": 'task_picker'
                                          }));

                                          if (resp.runtimeType ==
                                              subscriber.runtimeType) {
                                            subscriber = resp;

                                            _fKey.currentState!.patchValue({
                                              'subscriber_name':
                                                  subscriber.name,
                                            });
                                            initFuture = init_form();
                                            setState(() {});
                                          }
                                        },
                                        validator: MyWidgets
                                            .my_validator_field_required(
                                                context, 'This field '),
                                        initialValue: subscriber.name,
                                        textCapitalization:
                                            TextCapitalization.words,
                                        name: "subscriber_name",
                                        readOnly: true,
                                        textInputAction: TextInputAction.next,
                                      ),




                                      const SizedBox(height: 15),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_3(
                                          label: "Select service",
                                        ),
                                        initialValue: service.name,
                                        onTap: () async {
                                          var resp = await Get.to(
                                              ServicesScreen(const {
                                            "task_picker": 'task_picker'
                                          }));

                                          if (resp.runtimeType ==
                                              service.runtimeType) {
                                            service = resp;

                                            _fKey.currentState!.patchValue({
                                              'quantity': '',
                                              'service_name':
                                                  "${service.name} @UGX ${Utils.moneyFormat(service.fee.toString())}",
                                            });
                                            setState(() {});
                                          }
                                        },
                                        textCapitalization:
                                            TextCapitalization.words,
                                        name: "service_name",
                                        readOnly: true,
                                        textInputAction: TextInputAction.next,
                                      ),
                                      const SizedBox(height: 15),
                                      FormBuilderTextField(
                                        decoration: CustomTheme.in_3(
                                          label: "Quantity",
                                        ),
                                        keyboardType: TextInputType.number,
                                        validator: MyWidgets
                                            .my_validator_field_required(
                                                context, 'This field '),
                                        name: "quantity",
                                        onChanged: (x) {
                                          subscription.quantity =
                                              Utils.to_str(x, "");
                                          subscription.total = (Utils.int_parse(
                                                      service.fee) *
                                                  Utils.int_parse(
                                                      subscription.quantity))
                                              .toString();
                                          setState(() {});
                                        },
                                        textInputAction: TextInputAction.done,
                                      ),
                                      const SizedBox(height: 15),
                                      Utils.int_parse(subscription.total) < 1
                                          ? const SizedBox()
                                          : FxText(
                                              'TOTAL: UGX ${Utils.moneyFormat(subscription.total)}',
                                              fontWeight: 800,
                                              color: CustomTheme.primary,
                                            ),
                                      const SizedBox(height: 5),

                                      error_message.isEmpty
                                          ? const SizedBox()
                                          : FxContainer(
                                        margin:
                                        const EdgeInsets.only(bottom: 10,top: 15),
                                        color: Colors.red.shade100,
                                        child: Text(
                                          error_message,
                                        ),
                                      ),


                                      const Divider(),
                                      const SizedBox(height: 5),
                                      FxContainer(
                                        color: CustomTheme.primary,
                                        paddingAll: 10,
                                        borderRadiusAll: 0,
                                        child: FxText(
                                          "Below is a list of other service subscriptions by selected subscriber.",
                                          color: Colors.white,
                                          fontWeight: 800,
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      items.isNotEmpty
                                          ? const SizedBox()
                                          : FxContainer(
                                              child: FxText(
                                                  "Selected subscriber has no any service subscription."))
                                    ],
                                  ),
                                ),
                              ],
                            )),
                        Expanded(
                          child: CustomScrollView(
                            slivers: [
                              SliverList(
                                delegate: SliverChildBuilderDelegate(
                                  (BuildContext context, int index) {
                                    final ServiceSubscription m = items[index];
                                    return Flex(
                                      direction: Axis.horizontal,
                                      children: [
                                        const SizedBox(
                                          width: 15,
                                        ),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              FxText.titleMedium(
                                                m.administrator_text,
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
                                        const SizedBox(
                                          width: 15,
                                        ),
                                      ],
                                    );
                                  },
                                  childCount: items.length, // 1000 list items
                                ),
                              ),
                            ],
                          ),
                        ),
                        is_loading? Container(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: const CircularProgressIndicator(
                            strokeWidth: 2.5,
                            valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.red),
                          ),
                        ): Container(
                          padding: const EdgeInsets.only(
                            left: 10,
                            right: 10,
                            bottom: 8,
                          ),
                          child: FxButton.block(
                            padding:
                            const EdgeInsets.fromLTRB(24, 24, 24, 24),
                            borderRadiusAll: 0,
                            backgroundColor: CustomTheme.primary,
                            onPressed: () {
                              save_form();
                            },
                            child: FxText.titleLarge(
                              'SUBMIT',
                              fontWeight: 800,
                              color: Colors.white,
                            ),
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
    if (!_fKey.currentState!.validate()) {
      Utils.toast('Fix some errors first.', color: Colors.red.shade700);
      return;
    }

    if (subscriber.id < 1) {
      Utils.toast("Please select subscriber.");
      return;
    }

    if (service.id < 1) {
      Utils.toast("Please select service.");
      return;
    }


    Get.defaultDialog(
        middleText: "Are you sure you want submit this records?",
        titleStyle: const TextStyle(color: Colors.black),
        actions: <Widget>[
          FxButton.small(
            onPressed: () {
              doUploadProcess();
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: FxText(
              'SUBMIT',
              color: Colors.white,
            ),
          ),
          FxButton.outlined(
            onPressed: () {
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            borderColor: CustomTheme.primary,
            child: FxText(
              'CANCEL',
              color: CustomTheme.primary,
            ),
          ),
        ]);

  }

  doUploadProcess() async {
    setState(() {
      error_message = "";
      is_loading = true;
    });

    RespondModel resp = RespondModel(await Utils.http_post('service-subscriptions', {
      'service_id': service.id,
      'administrator_id': subscriber.id,
      'quantity': subscription.quantity,
    }));

    if (resp.code != 1) {
      setState(() {
        error_message = "";
        is_loading = false;
      });

      is_loading = false;
      error_message = resp.message;
      setState(() {});
      Utils.toast('Failed', color: Colors.red.shade700);
      return;
    }

    Utils.toast(resp.message);
    subscription = ServiceSubscription();
    service = ServiceModel();
    _fKey.currentState!.patchValue({'quantity': '', 'service_name': ''});

    setState(() {
      error_message = "";
      is_loading = false;
    });

    Get.defaultDialog(
        middleText:
            "Do you want to create another record the selected subscriber?",
        titleStyle: const TextStyle(color: Colors.black),
        actions: <Widget>[
          FxButton.small(
            onPressed: () {
              Navigator.pop(context);

            },
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: FxText(
              'YES',
              color: Colors.white,
            ),
          ),
          FxButton.outlined(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            borderColor: CustomTheme.primary,
            child: FxText(
              'NO',
              color: CustomTheme.primary,
            ),
          ),
        ]);

    return;
  }

  ServiceSubscription subscription = ServiceSubscription();
  UserModel subscriber = UserModel();
  ServiceModel service = ServiceModel();
  List<ServiceSubscription> items = [];

  Future<bool> init_form() async {

    if(acc_id>0){
      List<UserModel> subs = await UserModel.getItems();
      for (var element in subs) {
        if(element.id == acc_id){
          subscriber = element;
          print("================FOUND <<<<<<<${subscriber.name}>>>>>>>>>=========");
          setState(() {
          });break;
        }
      }

    }


    items = await ServiceSubscription.getItems(
        where: ' administrator_id = ${subscriber.id} ');

    return true;
  }
}
