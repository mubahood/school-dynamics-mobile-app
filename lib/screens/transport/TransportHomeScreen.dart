import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/TripModelLocal.dart';
import '../../models/TripModelOnline.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import 'PendingTripsScreen.dart';
import 'TripCreateScreen.dart';

//TransportHomeScreen
class TransportHomeScreen extends StatefulWidget {
  TransportHomeScreen({Key? key}) : super(key: key);

  @override
  TransportHomeScreenState createState() => new TransportHomeScreenState();
}

class TransportHomeScreenState extends State<TransportHomeScreen> {
  Future<void> submit_form() async {
    init();
    return;
  }

  String error_message = "";
  bool is_loading = false;
  bool hasOnGoingTrip = false;

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
                'Trips',
                color: Colors.white,
                fontWeight: 700,
                height: 1,
              ),
              FxText.titleSmall(
                'Found ${trips.length} trips',
                color: Colors.white,
              ),
            ],
          )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (hasOnGoingTrip) {
            Utils.toast2('There is still ongoing trip.',
                background_color: CustomTheme.red);
            return;
          }
          //show bottom sheet asking for create new trip
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
                      padding: EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.pop(context);
                              TripModelLocal trip = TripModelLocal();
                              Get.to(() => TripCreateScreen(trip));
                            },
                            leading: Icon(
                              FeatherIcons.plus,
                              color: CustomTheme.primary,
                              size: 26,
                            ),
                            title: FxText.titleMedium(
                              "Create new trip",
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
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          localTrips.isNotEmpty
              ? InkWell(
                  onTap: () {
                    Get.to(() => PendingTripsScreen());
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 16,
                    ),
                    color: Colors.red,
                    width: double.infinity,
                    child: Row(
                      children: [
                        FxText.titleSmall(
                          'You have ${localTrips.length} offline trips. Please sync to server.',
                          color: Colors.white,
                        ),
                        const Spacer(),
                        const Icon(
                          FeatherIcons.chevronRight,
                          color: Colors.white,
                        )
                      ],
                    ),
                  ),
                )
              : SizedBox(),
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
                        TripModelOnline m = trips[index];

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
                                "${m.trip_direction}, TRIP #${m.id}",
                                fontSize: 16,
                                fontWeight: 600,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FxText.bodyMedium(
                                      "DATE: ${Utils.to_date(m.created_at)},"
                                      "\nPassengers: ${m.expected_passengers}"),
                                  FxText.bodySmall(
                                    "STATUS: SUBMITTED",
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
                      childCount: trips.length, // 1000 list items
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<TripModelLocal> localTrips = [];
  List<TripModelOnline> trips = [];

  Future<void> init() async {
    localTrips = await TripModelLocal.get_items();
    hasOnGoingTrip = false;
    for (var element in localTrips) {
      if (element.status == 'Ongoing') {
        hasOnGoingTrip = true;
        setState(() {});
        break;
      }
    }
    trips = await TripModelOnline.get_items();
    setState(() {});
  }
}
