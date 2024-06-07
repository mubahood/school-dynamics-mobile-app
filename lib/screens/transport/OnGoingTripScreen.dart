import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/theme/custom_theme.dart';

import '../../models/TransportParticipantModel.dart';
import '../../models/TripModelLocal.dart';
import '../../sections/widgets.dart';
import '../../utils/Utils.dart';
import 'QRCodeCutScannerScreen.dart';

class OnGoingTripScreen extends StatefulWidget {
  TripModelLocal item;

  OnGoingTripScreen(this.item, {Key? key}) : super(key: key);

  @override
  _OnGoingTripScreenState createState() => _OnGoingTripScreenState();
}

class _OnGoingTripScreenState extends State<OnGoingTripScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    my_init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TransportParticipantModel> expected_passengers = [];
  int on_board_passengers = 0;
  int arrived_passengers = 0;
  int absent_passengers = 0;

  Future<void> my_init() async {
    await widget.item.getPassengers();
    setState(() {});
    arrived_passengers = 0;
    on_board_passengers = 0;
    absent_passengers = 0;
    expected_passengers.clear();

    for (var element in widget.item.passengers) {
      expected_passengers.add(element);
      if (element.status.toLowerCase() == 'absent') {
        absent_passengers++;
      } else if (element.status.toLowerCase() == 'ONBOARD'.toLowerCase()) {
        on_board_passengers++;
      } else if (element.status.toLowerCase() == 'ARRIVED'.toLowerCase()) {
        arrived_passengers++;
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 35,
            ),
            onPressed: () {
              // show_found_passenger(widget.item.passengers[0]);
              // return;
              my_init();
            },
          )
        ],
        backgroundColor: CustomTheme.primary,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleMedium(
              "${widget.item.transport_route_text} - ${widget.item.trip_direction}"
                  .toUpperCase(),
              color: Colors.white,
              maxLines: 2,
              fontWeight: 700,
            ),
            FxText.bodySmall(
              'Expected: ${expected_passengers.length},'
              ' Missing: $absent_passengers,'
              ' Onboard: $on_board_passengers,'
              ' Arrived: $arrived_passengers',
              color: Colors.white,
              maxLines: 2,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.center,
          isScrollable: false,
          tabs: const [
            Tab(text: 'SCAN QR CODE'),
            Tab(text: 'PASSENGERS'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                QRCodeCutScannerScreen((String x) {
                  get_subscriber_by_id(x);
                }),
                ListView.separated(
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: widget.item.passengers.length,
                    itemBuilder: (context, index) {
                      return passenger_widget(widget.item.passengers[index]);
                    }),
              ],
            ),
          ),
          loading
              ? Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: const CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                  ),
                )
              : FxContainer(
                  borderRadiusAll: 0,
                  color: Colors.grey.shade400,
                  padding: const EdgeInsets.only(
                      bottom: 10, top: 10, left: 15, right: 15),
                  child: FxButton.block(
                      onPressed: () {
/*                        widget.item.do_submit();
                        return;*/

                        Get.dialog(
                          AlertDialog(
                            title: const Text('End Session Confirmation'),
                            content: const Text(
                                'Are you sure you want to end this session?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Get.back();
                                },
                                child: const Text('Cancel'),
                              ),
                              TextButton(
                                onPressed: () async {
                                  Get.back();
                                  widget.item.status = 'Closed';
                                  widget.item.failed_message = '';
                                  await widget.item.save();
                                  setState(() {});
                                  if (!(await Utils.is_connected())) {
                                    Utils.toast2('Saved for later submission.');
                                    Get.back();
                                    return;
                                  }
                                  Utils.toast2("Submitting...");
                                  setState(() {
                                    loading = true;
                                  });
                                  String resp = await widget.item.do_submit();
                                  setState(() {
                                    loading = false;
                                  });
                                  if (resp.isNotEmpty) {
                                    Utils.toast2(
                                        "Failed to upload because, $resp.",
                                        background_color: CustomTheme.red);
                                    return;
                                  }
                                  Utils.toast2("Success");
                                  Get.back();
                                  return;
                                },
                                child: const Text('Confirm'),
                              ),
                            ],
                          ),
                        );
                      },
                      borderRadiusAll: 10,
                      padding: const EdgeInsets.symmetric(vertical: 25),
                      child: FxText.titleLarge(
                        "END SESSION",
                        color: Colors.white,
                        fontWeight: 700,
                      )),
                )
        ],
      ),
    );
  }

  bool loading = false;

  Future<void> get_subscriber_by_id(String x) async {
    await widget.item.getPassengers();
    for (var element in widget.item.passengers) {
      if (element.student_id.toString().trim().toUpperCase() ==
          x.toString().trim().toUpperCase()) {
        show_found_passenger(element);
        return;
      }
    }
    Utils.toast2("Student with id #$x not found.",
        background_color: CustomTheme.red);
  }

  void show_found_passenger(TransportParticipantModel passenger) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext buildContext) {
          return Container(
            color: Colors.transparent,
            child: Container(
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16))),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 0, right: 0, top: 15, bottom: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.topRight,
                        child: FxContainer(
                            onTap: () => {Get.back()},
                            margin: const EdgeInsets.only(
                              right: 15,
                            ),
                            padding: const EdgeInsets.all(15),
                            borderRadiusAll: 100,
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ))),
                    Center(child: FxText.titleLarge('Student Found')),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: FxContainer(
                        width: 100,
                        height: 10,
                        color: CustomTheme.primary,
                      ),
                    ),
                    passenger_widget(passenger)
                  ],
                ),
              ),
            ),
          );
        });
  }

  Widget passenger_widget(TransportParticipantModel pas) {
    return Container(
      padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
      child: Flex(
        direction: Axis.horizontal,
        children: [
          roundedImage(pas.avatar.toString(), 7, 7),
          const SizedBox(
            width: 10,
          ),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleLarge(
                pas.name,
                fontSize: 16,
                color: Colors.grey.shade900,
                fontWeight: 600,
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                children: [
                  FxText.bodySmall(
                    'status: '.toUpperCase(),
                    color: Colors.black,
                    fontWeight: 800,
                  ),
                  FxText.bodySmall(
                    pas.status.toUpperCase(),
                    color: pas.status == 'Onboard'
                        ? Colors.orange.shade800
                        : pas.status != 'Absent'
                            ? Colors.green.shade900
                            : Colors.red.shade900,
                  ),
                ],
              )
            ],
          )),
          pas.status != 'Absent'
              ? const SizedBox()
              : FxButton.small(
                  onPressed: () {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Onboard Confirmation'),
                        content: const Text(
                            'Are you sure you want to mark this passenger as onboard?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              pas.status = 'Onboard';
                              await pas.save();
                              my_init();
                              setState(() {});
                              Get.back();
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                  backgroundColor: Colors.orange.shade700,
                  borderRadiusAll: 100,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  child: FxText.titleMedium(
                    "Onboard",
                    fontWeight: 800,
                    color: Colors.white,
                  )),
          pas.status != 'Onboard'
              ? const SizedBox()
              : FxButton.small(
                  onPressed: () async {
                    Get.dialog(
                      AlertDialog(
                        title: const Text('Arrived Confirmation'),
                        content: const Text(
                            'Are you sure you want to mark this passenger as arrived?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              pas.status = 'Arrived';
                              await pas.save();
                              my_init();
                              setState(() {});
                              Get.back();
                            },
                            child: const Text('Confirm'),
                          ),
                        ],
                      ),
                    );
                  },
                  borderRadiusAll: 100,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                    horizontal: 20,
                  ),
                  child: FxText.titleMedium(
                    "Arrived",
                    fontWeight: 800,
                    color: Colors.white,
                  )),
        ],
      ),
    );
  }
}
