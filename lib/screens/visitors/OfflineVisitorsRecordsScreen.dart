import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/VisitorRecordModelLocal.dart';
import 'package:schooldynamics/screens/visitors/VisitorRecordCreateScreen.dart';

import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';

//OfflineVisitorsRecordsScreen
class OfflineVisitorsRecordsScreen extends StatefulWidget {
  const OfflineVisitorsRecordsScreen({super.key});

  @override
  OfflineVisitorsRecordsScreenState createState() =>
      OfflineVisitorsRecordsScreenState();
}

class OfflineVisitorsRecordsScreenState
    extends State<OfflineVisitorsRecordsScreen> {
  Future<void> submit_records() async {
    items = await VisitorRecordModelLocal.get_items();
    if (items.isEmpty) {
      return;
    }
    Utils.toast("Uploading ${items.length} records");
    await VisitorRecordModelLocal.submit_records();
    Utils.toast("Upload complete");
    items = await VisitorRecordModelLocal.get_items();
    setState(() {});
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
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              FxText.titleLarge(
                'Pending visitors records',
                color: Colors.white,
                fontWeight: 700,
                height: .8,
              ),
              FxText.titleSmall(
                'Found ${items.length} records',
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
                        VisitorRecordModelLocal m = items[index];
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
                                            padding: const EdgeInsets.all(24),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ListTile(
                                                  onTap: () async {
                                                    m.isEdit = true;
                                                    Navigator.pop(context);
                                                    await Get.to(() =>
                                                        VisitorRecordCreateScreen(
                                                            m));
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
                              title: FxText(
                                "${m.name} - ${m.phone_number}",
                                fontSize: 16,
                                fontWeight: 600,
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  FxText.bodyMedium(
                                    "STATUS: ${m.upload_status == 'Failed' ? 'FAILED TO UPLOAD: ${m.upload_error}' : 'Pending'}",
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
                      childCount: items.length, // 1000 list items
                    ),
                  )
                ],
              ),
            ),
          ),
          loading
              ? Container(
                  padding: const EdgeInsets.only(bottom: 10),
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
                        submit_records();
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

  List<VisitorRecordModelLocal> items = [];
  bool loading = false;

  Future<void> init() async {
    items = await VisitorRecordModelLocal.get_items();
    setState(() {});
  }
}
