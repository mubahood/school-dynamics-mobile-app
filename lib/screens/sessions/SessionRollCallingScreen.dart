import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/SessionLocal.dart';
import '../../models/TemporaryModel.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import 'QRCodeScannerScreen.dart';

class SessionRollCallingScreen extends StatefulWidget {
  dynamic data;

  SessionRollCallingScreen({Key? key, this.data}) : super(key: key);

  @override
  SessionRollCallingScreenState createState() =>
      new SessionRollCallingScreenState();
}

class SessionRollCallingScreenState extends State<SessionRollCallingScreen> {
  Future<void> submit_form() async {
    /*if ((item.expectedMembers.length) >
        (item.presentMembers.length + item.absentMembers.length)) {
      Utils.toast("Please mark all present and absent students.",
          color: Colors.red.shade900);
      return;
    }*/
    if (await Utils.is_connected()) {
      Utils.showLoader(true);
      await item.submitSelf();
      Utils.hideLoader();
    }
    await doSave(true);
    Utils.boot_system();
    Get.back();
    Utils.toast("Thanks");
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
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 1,
          toolbarHeight: 65,
          actions: [
            IconButton(
              onPressed: () {
                Get.defaultDialog(
                  title: "Delete Session",
                  middleText: "Are you sure you want to delete this session?",
                  textConfirm: "Yes",
                  textCancel: "No",
                  confirmTextColor: Colors.white,
                  buttonColor: CustomTheme.primary,
                  onConfirm: () async {
                    await item.deleteSelf();
                    Get.back();
                    Get.back();
                  },
                );
              },
              icon: const Icon(
                Icons.delete_forever,
                color: Colors.red,
                size: 35,
              ),
            )
          ],
          automaticallyImplyLeading: true,
          flexibleSpace: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  FxText.bodyMedium(
                    '${item.title} - Roll call',
                    color: Colors.white,
                    fontWeight: 700,
                    height: .9,
                    textAlign: TextAlign.center,
                  ),
                  FxText.bodySmall(
                    'Expected: ${item.expectedMembers.length}, Present: ${item.presentMembers.length}, Absent: ${item.absentMembers.length}',
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(
                height: 3,
              ),
              const Divider(
                height: 1,
                indent: 50,
                endIndent: 50,
              ),
              TabBar(
                padding: const EdgeInsets.only(bottom: 0),
                labelPadding: EdgeInsets.only(bottom: 2, left: 8, right: 8),
                indicatorPadding: EdgeInsets.all(0),
                labelColor: CustomTheme.primary,
                isScrollable: false,
                enableFeedback: true,
                indicator: const UnderlineTabIndicator(
                    borderSide: BorderSide(color: Colors.white, width: 4)),
                tabs: [
                  Tab(
                      height: 30,
                      child: FxText.titleMedium(
                        "MANUAL".toUpperCase(),
                        fontWeight: 600,
                        color: Colors.white,
                      )),
                  Tab(
                      height: 30,
                      child: FxText.titleMedium("SCAN".toUpperCase(),
                          fontWeight: 600, color: Colors.white)),
                ],
              )
            ],
          ),
        ),
        body: TabBarView(
          children: [
            Column(
              children: [
                Expanded(
                  child: ListView.builder(
                      itemCount: item.expectedMembers.length,
                      itemBuilder: (context, index) {
                        final TemporaryModel member =
                            item.expectedMembers[index];
                        return Container(
                          color: item.presentMembers.contains(member.id)
                              ? Colors.green.shade50
                              : item.absentMembers.contains(member.id)
                                  ? Colors.red.shade50
                                  : Colors.white,
                          padding:
                              EdgeInsets.only(left: 10, top: 10, right: 10),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: [
                              roundedImage(member.image.toString(), 5, 5),
                              const SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                  child: FxText.titleLarge(
                                '${member.title}\n${member.details}',
                                fontSize: 16,
                                color: Colors.grey.shade900,
                                fontWeight: 600,
                              )),
                              Container(
                                child: Row(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        addToPresent(member.id);
                                      },
                                      child: Container(
                                        child: Column(
                                          children: [
                                            FxText.bodySmall(
                                              'PRESENT',
                                              fontWeight: 700,
                                              color: Colors.green.shade900,
                                              letterSpacing: .01,
                                            ),
                                            SizedBox(
                                              height: 3,
                                            ),
                                            FxContainer(
                                              borderRadiusAll: 100,
                                              width: 25,
                                              height: 25,
                                              bordered: true,
                                              color: item.presentMembers
                                                      .contains(member.id)
                                                  ? Colors.green.shade700
                                                  : Colors.white,
                                              borderColor:
                                                  Colors.green.shade900,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    InkWell(
                                      onTap: () {
                                        addToAbsent(member.id);
                                      },
                                      child: Container(
                                        child: Column(
                                          children: [
                                            FxText.bodySmall(
                                              'ABSENT',
                                              fontWeight: 700,
                                              color: Colors.red.shade900,
                                              letterSpacing: .01,
                                            ),
                                            const SizedBox(
                                              height: 3,
                                            ),
                                            FxContainer(
                                              borderRadiusAll: 100,
                                              width: 25,
                                              color: item.absentMembers
                                                      .contains(member.id)
                                                  ? Colors.red.shade700
                                                  : Colors.white,
                                              height: 25,
                                              bordered: true,
                                              borderColor: Colors.red.shade800,
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        );
                      }),
                ),
                Divider(),
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: FxButton.outlined(
                          borderColor: CustomTheme.primary,
                          onPressed: () {
                            pause_session();
                          },
                          child: FxText.titleMedium(
                            'PAUSE',
                            color: CustomTheme.primary,
                            fontWeight: 800,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Expanded(
                        child: FxButton.block(
                          borderColor: CustomTheme.primary,
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
                          onPressed: () {
                            submit_form();
                          },
                          child: FxText.titleMedium(
                            'SUBMIT',
                            color: Colors.white,
                            fontWeight: 800,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 5,
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: QRCodeScannerScreen((x) {
                    if (x != null) {
                      x = x.toUpperCase().trim();
                      List<TemporaryModel> temps = item.expectedMembers
                          .where((element) =>
                              element.details.toUpperCase().trim() == x)
                          .toList();
                      if (temps.isNotEmpty) {
                        Utils.toast("Found ${temps.first.title} - $x",
                            color: Colors.green.shade900);
                        addToPresent(Utils.int_parse(temps.first.id));
                        setState(() {});

                      } else {
                        Utils.toast("Student $x not found.",
                            color: Colors.red.shade900);
                      }
                      setState(() {});
                    }
                  }),
                ),
              ],
            ),
          ],
        ),
        /*   floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(() => QRCodeScannerScreen((x) {
                  Utils.toast(x.toString());
                }));
          },
          child: Icon(Icons.qr_code),
        ),*/
      ),
    );
  }

  SessionLocal item = SessionLocal();

  void init() {
    if (widget.data.runtimeType != item.runtimeType) {
      Utils.toast('Data not found.');
      Get.back();
      return;
    }
    item = widget.data;
    item.getExpectedMembers();
    item.getPresentMembers();
    item.getAbsentMembers();
    setState(() {});
  }

  Future<void> addToPresent(int _id) async {
    if (!item.presentMembers.contains(_id)) {
      item.presentMembers.add(_id);
    }
    item.absentMembers.remove(_id);
    setState(() {});
    await doSave(false);
    setState(() {});
  }

  Future<void> addToAbsent(int _id) async {
    if (!item.absentMembers.contains(_id)) {
      item.absentMembers.add(_id);
    }
    item.presentMembers.remove(_id);
    setState(() {});
    await doSave(false);
  }

  Future<void> doSave(bool isFinal) async {
    if (isFinal) {
      item.closed = 'yes';
    } else {
      item.closed = 'no';
    }

    item.present = jsonEncode(item.presentMembers);
    item.absent = jsonEncode(item.absentMembers);
    await item.save();
  }

  Future<void> pause_session() async {
    await doSave(false);
    //Get.back();
    Utils.toast("Roll call paused.");
  }
}
