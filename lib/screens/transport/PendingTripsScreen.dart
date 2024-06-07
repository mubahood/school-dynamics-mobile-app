import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/screens/transport/OnGoingTripScreen.dart';

import '../../models/TripModelLocal.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

//PendingTripsScreen
class PendingTripsScreen extends StatefulWidget {
  PendingTripsScreen({Key? key}) : super(key: key);

  @override
  PendingTripsScreenState createState() => new PendingTripsScreenState();
}

class PendingTripsScreenState extends State<PendingTripsScreen> {
  Future<void> submit_form() async {
    init();
    return;
  }

  String error_message = "";
  bool is_loading = false;

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
      appBar: AppBar(
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleLarge(
                'Pending Trips',
                color: Colors.white,
                fontWeight: 700,
                height: .8,
              ),
              FxText.titleSmall(
                'Found ${localTrips.length} records',
                color: Colors.white,
              ),
            ],
          )),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                await init();
              },
              color: CustomTheme.primary,
              backgroundColor: Colors.white,
              child: CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        TripModelLocal m = localTrips[index];
                        return Column(
                          children: [
                            ListTile(
                              onTap: () {
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
                                                  topRight:
                                                      Radius.circular(16))),
                                          child: Container(
                                            padding: EdgeInsets.all(24),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    await Get.to(() =>
                                                        OnGoingTripScreen(m));
                                                    init();
                                                  },
                                                  leading: Icon(
                                                    FeatherIcons.edit3,
                                                    color: CustomTheme.primary,
                                                    size: 26,
                                                  ),
                                                  title: FxText.titleMedium(
                                                    "Update trip",
                                                    fontSize: 20,
                                                    fontWeight: 800,
                                                    color: Colors.black,
                                                  ),
                                                ),

                                                //delete
                                                ListTile(
                                                  onTap: () async {
                                                    Navigator.pop(context);
                                                    //are you sure you want to delete this trip?
                                                    Get.defaultDialog(
                                                      title: "Delete trip",
                                                      middleText:
                                                          "Are you sure you want to delete this trip?",
                                                      textConfirm: "Yes",
                                                      textCancel: "No",
                                                      confirmTextColor:
                                                          Colors.white,
                                                      buttonColor:
                                                          CustomTheme.primary,
                                                      onConfirm: () async {
                                                        await m.delete();
                                                        init();
                                                        Get.back();
                                                      },
                                                    );
                                                  },
                                                  leading: Icon(
                                                    FeatherIcons.trash,
                                                    color: CustomTheme.primary,
                                                    size: 26,
                                                  ),
                                                  title: FxText.titleMedium(
                                                    "Delete trip",
                                                    fontSize: 20,
                                                    fontWeight: 800,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      );
                                    });
                              },
                              leading: Icon(
                                FeatherIcons.truck,
                                color: CustomTheme.primary,
                                size: 26,
                              ),
                              title: FxText(
                                "${m.transport_route_text} - ${m.trip_direction}, TRIP #${m.id}",
                                fontSize: 16,
                                fontWeight: 600,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FxText.bodyMedium(
                                    "Driver: ${m.driver_text}, Expected: ${m.expected_passengers}, Actual: ${m.actual_passengers}, Absent: ${m.absent_passengers}",
                                  ),
                                  FxText.bodySmall(
                                    "STATUS: ${m.status}",
                                    color: Colors.black,
                                    fontWeight: 900,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(
                              height: 1,
                            ),
                          ],
                        );
                      },
                      childCount: localTrips.length, // 1000 list items
                    ),
                  )
                ],
              ),
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
                        Utils.toast2("Time to submit...");
                      },
                      borderRadiusAll: 10,
                      child: FxText.titleLarge(
                        "SUBMIT ALL",
                        color: Colors.white,
                        fontWeight: 700,
                      )),
                )
        ],
      ),
    );
  }

  List<TripModelLocal> localTrips = [];
  bool loading = false;

  Future<void> init() async {
    localTrips = await TripModelLocal.get_items();
    setState(() {});
  }
}
