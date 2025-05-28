/*
* File : Login
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/TransportStage.dart';

import '../../models/TransportParticipantModel.dart';
import '../../models/TransportSubscriptionModel.dart';
import '../../models/TransportVehicleModel.dart';
import '../../models/TripModelLocal.dart';
import '../../theme/app_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import 'OnGoingTripScreen.dart';
import 'TransportRoutesScreen.dart';
import 'TransportVehicleScreen.dart';

class TripCreateScreen extends StatefulWidget {
  TripModelLocal item;

  TripCreateScreen(
    this.item, {
    super.key,
  });

  @override
  _TripCreateScreenState createState() => _TripCreateScreenState();
}

class _TripCreateScreenState extends State<TripCreateScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool onLoading = false;
  String error_message = "";
  List<TransportSubscriptionModel> subscriptions = [];

  @override
  void initState() {
    init();
    super.initState();
  }

  init() async {
    subscriptions = await TransportSubscriptionModel.get_items();
    caltulate_passengers();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        titleSpacing: 0,
        title: FxText.titleLarge(
          "Creating new trip",
          color: Colors.white,
          fontWeight: 800,
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(
                        left: MySize.size16, right: MySize.size16),
                    child: FormBuilder(
                      key: _formKey,
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: MySize.size10,
                            left: MySize.size5,
                            right: MySize.size5,
                            bottom: MySize.size10),
                        child: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 15,
                            ),
                            FormBuilderTextField(
                              name: 'transport_route_text',
                              readOnly: true,
                              initialValue: widget.item.transport_route_text,
                              textCapitalization: TextCapitalization.words,
                              onTap: () async {
                                TransportStage? t = await Get.to(() =>
                                    TransportRoutesScreen(
                                        const {'task': 'picker'}));
                                if (t == null) {
                                  Utils.toast2("Route not selected");
                                  return;
                                }
                                widget.item.transport_route_text = t.name;
                                widget.item.transport_route_id =
                                    t.id.toString();
                                _formKey.currentState!.patchValue({
                                  'transport_route_text':
                                      widget.item.transport_route_text,
                                });
                                caltulate_passengers();

                                setState(() {});
                              },
                              keyboardType: TextInputType.name,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Select route",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Select route",
                                ),
                              ]),
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            FormBuilderRadioGroup(
                              name: 'trip_direction',
                              initialValue: widget.item.trip_direction,
                              onChanged: (x) {
                                if (widget.item.transport_route_text == '') {
                                  Utils.toast2("Select route first",
                                      background_color: CustomTheme.red);
                                  return;
                                }
                                widget.item.trip_direction =
                                    Utils.to_str(x, '');
                                caltulate_passengers();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Trip direction",
                                hasPadding: false,
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Title",
                                ),
                              ]),
                              options: const [
                                FormBuilderFieldOption(
                                  value: 'To School',
                                ),
                                FormBuilderFieldOption(
                                  value: 'From School',
                                ),
                              ],
                            ),

                            const SizedBox(
                              height: 20,
                            ),

                            FormBuilderTextField(
                              name: 'local_text',
                              readOnly: true,
                              initialValue: widget.item.local_text,
                              textCapitalization: TextCapitalization.words,
                              onTap: () async {
                                TransportVehicleModel? v = await Get.to(() =>
                                    TransportVehicleScreen(
                                        const {'task': 'picker'}));
                                if (v == null) {
                                  Utils.toast2("Route not selected");
                                  return;
                                }
                                widget.item.local_text =
                                    "${v.name} - ${v.registration_number}";
                                widget.item.local_id = v.id.toString();
                                _formKey.currentState!.patchValue({
                                  'local_text': widget.item.local_text,
                                });

                                setState(() {});
                              },
                              keyboardType: TextInputType.name,
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Select Vehicle",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Select Vehicle",
                                ),
                              ]),
                            ),
                            const SizedBox(
                              height: 20,
                            ),

                            //start_mileage
                            FormBuilderTextField(
                              name: 'start_mileage',
                              initialValue: widget.item.start_mileage,
                              textCapitalization: TextCapitalization.words,
                              keyboardType: TextInputType.number,
                              onChanged: (x) {
                                widget.item.start_mileage = x.toString();
                              },
                              decoration: AppTheme.InputDecorationTheme1(
                                label: "Enter start mileage",
                              ),
                              validator: FormBuilderValidators.compose([
                                FormBuilderValidators.required(
                                  errorText: "Start mileage",
                                ),
                              ]),
                            ),
                          ],
                        ),
                      ),
                    )),

                //show passengers
                Container(
                  padding: const EdgeInsets.only(
                    left: 20,
                    right: 15,
                    top: 10,
                  ),
                  child: FxText.bodyMedium(
                    "Expected Passengers: ${widget.item.expected_passengers}",
                    color: CustomTheme.primary,
                  ),
                ),
                //small refresh button
                InkWell(
                  onTap: () async {
                    Utils.toast2("Please wait...");
                    await TransportVehicleModel.getOnlineItems();
                    await TransportStage.getOnlineItems();
                    await TransportSubscriptionModel.getOnlineItems();
                    setState(() {});
                    caltulate_passengers();
                  },
                  child: Container(
                    padding: const EdgeInsets.only(
                      left: 20,
                      right: 15,
                      top: 15,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.refresh,
                            size: 25,
                            color: CustomTheme.accent,
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Center(
                              child: FxText.titleMedium(
                            "Refresh",
                            fontWeight: 700,
                            color: CustomTheme.accent,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(
              left: 15,
              right: 15,
              bottom: 15,
            ),
            child: FxButton.block(
                onPressed: () {
                  if (!_formKey.currentState!.saveAndValidate()) {
                    Utils.toast2("Fill all fields",
                        background_color: CustomTheme.red);
                    return;
                  }
                  //validate route
                  if (widget.item.transport_route_text == '') {
                    Utils.toast2("Select route first",
                        background_color: CustomTheme.red);
                    return;
                  }

                  //validate vehicle
                  if (widget.item.local_text == '') {
                    Utils.toast2("Select vehicle first",
                        background_color: CustomTheme.red);
                    return;
                  }

                  //validate direction
                  if (widget.item.trip_direction == '') {
                    Utils.toast2("Select trip direction",
                        background_color: CustomTheme.red);
                    return;
                  }

                  Get.defaultDialog(
                      middleText: ""
                          "Are you sure you want to start this trip?",
                      titleStyle: const TextStyle(color: Colors.black),
                      actions: <Widget>[
                        FxButton.small(
                          onPressed: () {
                            do_save();
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 15),
                          child: FxText(
                            'START TRIP',
                            color: Colors.white,
                          ),
                        ),
                        FxButton.outlined(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 15),
                          borderColor: Colors.red,
                          child: FxText(
                            'CANCEL',
                            color: Colors.red,
                          ),
                        ),
                      ]);
                },
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                borderRadiusAll: 10,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.play_arrow,
                      size: 30,
                      color: Colors.white,
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Center(
                        child: FxText.titleMedium(
                      "START TRIP",
                      color: Colors.white,
                      fontWeight: 700,
                    )),
                  ],
                )),
          ),
        ],
      ),
    );
  }

  /*
  *
int id = 0;
    int trip_id = 0;
    String name = "";
    String avatar = "";
    String status = "";
    String start_time = "";
    String end_time = "";
  * */
  List<TransportParticipantModel> passengers = [];

  Future<void> caltulate_passengers() async {
    if (widget.item.transport_route_id == '') {
      return;
    }

    if (widget.item.trip_direction == '') {
      return;
    }

    subscriptions = await TransportSubscriptionModel.get_items(
        where: ' transport_stage_id = ${widget.item.transport_route_id} ');

    passengers.clear();
    for (TransportSubscriptionModel s in subscriptions) {
      if (s.trip_type != 'Round Trip') {
        if (s.trip_type != widget.item.trip_direction) {
          continue;
        }
      }

      TransportParticipantModel p = TransportParticipantModel();
      p.name = s.description.toString();
      p.avatar = s.service_subscription_text;
      p.student_id = s.user_text;
      p.status = 'Absent';
      passengers.add(p);
    }
    widget.item.expected_passengers = passengers.length.toString();
    setState(() {});
  }

  void do_save() async {
    await caltulate_passengers();
    if (passengers.isEmpty) {
      Utils.toast2("No passengers found", background_color: CustomTheme.red);
      return;
    }

    widget.item.created_at = DateTime.now().toString();
    widget.item.date = DateTime.now().toString();
    widget.item.status = 'Ongoing';
    widget.item.start_time = DateTime.now().toString();
    widget.item.start_gps = '0.0,0.0';
    widget.item.end_gps = '0.0,0.0';
    widget.item.expected_passengers = passengers.length.toString();
    widget.item.save();
    List<TripModelLocal> temps = await TripModelLocal.get_items();
    if (temps.isEmpty) {
      Utils.toast2("Failed to save trip.", background_color: CustomTheme.red);
      return;
    }
    //order by id desc
    widget.item = temps[0];
    setState(() {});

    await TransportParticipantModel.delete(' trip_id = ${widget.item.id} ');
    for (TransportParticipantModel p in passengers) {
      p.trip_id = widget.item.id;
      await p.save();
    }
    Get.off(() => OnGoingTripScreen(widget.item));
  }
}
