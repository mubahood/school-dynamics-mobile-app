import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/VisitorRecordModelLocal.dart';
import '../../models/VisitorRecordModelOnline.dart';
import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import 'OfflineVisitorsRecordsScreen.dart';
import 'VisitorRecordCreateScreen.dart';

//VisitorsBookScreen
class VisitorsBookScreen extends StatefulWidget {
  VisitorsBookScreen({Key? key}) : super(key: key);

  @override
  VisitorsBookScreenState createState() => VisitorsBookScreenState();
}

class VisitorsBookScreenState extends State<VisitorsBookScreen> {
  Future<void> submit_form() async {
    init();
    return;
  }

  String error_message = "";
  bool is_loading = false;
  bool searchMode = false;
  String keyWord = "";

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          VisitorRecordModelLocal rec = VisitorRecordModelLocal();
          rec.isEdit = false;
          await Get.to(() => VisitorRecordCreateScreen(rec));
          await rec.save();
          await init();
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  searchMode = !searchMode;
                  setState(() {});
                },
                iconSize: 30,
                icon: searchMode
                    ? const Icon(Icons.close)
                    : const Icon(Icons.search)),
            const SizedBox(
              width: 5,
            ),
          ],
          backgroundColor: CustomTheme.primary,
          titleSpacing: 0,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: searchMode
              ? FxContainer(
                  paddingAll: 0,
                  borderRadiusAll: 10,
                  color: Colors.white,
                  child: TextField(
                    onChanged: (value) {
                      keyWord = value.toString();
                      if (keyWord.isNotEmpty) {
                        applySearch();
                        setState(() {});
                      } else {
                        init();
                        setState(() {});
                      }
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search',
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                    ),
                  ),
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FxText.titleLarge(
                      'Visitors Book',
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
          localItems.isNotEmpty
              ? InkWell(
                  onTap: () async {
                    await Get.to(() => OfflineVisitorsRecordsScreen());
                    await VisitorRecordModelLocal.submit_records();
                    init();
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
                          'You have ${localItems.length} records pending for upload',
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
                        VisitorRecordModelOnline m = items[index];
                        return FxContainer(
                          onTap: () {
                            _showBottomSheet(m);
                          },
                          color: m.isOut()
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          paddingAll: 0,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Flex(
                                direction: Axis.horizontal,
                                children: [
                                  const SizedBox(
                                    width: 15,
                                  ),
                                  FxContainer(
                                    paddingAll: 5,
                                    borderRadiusAll: 10,
                                    child: roundedImage(
                                        Utils.getImg(m.signature_src), 8, 8),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        FxText.titleMedium(
                                          m.name,
                                          maxLines: 1,
                                          height: 1,
                                          color: Colors.grey.shade800,
                                          fontWeight: 800,
                                        ),
                                        FxText.bodySmall(m.phone_number),
                                        Row(
                                          children: [
                                            FxCard(
                                                color: m.isOut()
                                                    ? Colors.green.shade700
                                                    : Colors.red.shade700,
                                                padding: const EdgeInsets.only(
                                                  top: 2,
                                                  bottom: 4,
                                                  left: 8,
                                                  right: 8,
                                                ),
                                                borderRadiusAll: 50,
                                                child: FxText.bodySmall(
                                                  m.isOut()
                                                      ? 'CHECKED OUT'
                                                      : 'CHECKED IN',
                                                  color: Colors.white,
                                                  fontWeight: 900,
                                                  height: 1,
                                                  fontSize: 10,
                                                )),
                                            const Spacer(),
                                            FxText.bodySmall(
                                                Utils.to_date(m.created_at)),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                height: 1,
                                thickness: 1,
                              ),
                            ],
                          ),
                        );
                      },
                      childCount: items.length, // 1000 list items
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

  List<VisitorRecordModelOnline> items = [];
  List<VisitorRecordModelLocal> localItems = [];

  Future<void> init() async {
    localItems = await VisitorRecordModelLocal.get_items();
    items = await VisitorRecordModelOnline.get_items();
    VisitorRecordModelLocal.submit_records();
    setState(() {});
  }

  void _showBottomSheet(VisitorRecordModelOnline m) {
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
                  left: 15,
                  right: 15,
                  top: 15,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        IconButton(
                          icon: const Icon(
                            FeatherIcons.x,
                            color: Colors.black,
                            size: 30,
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        )
                      ],
                    ),
                    Expanded(
                        child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Center(
                            child: FxContainer(
                              paddingAll: 5,
                              borderRadiusAll: 10,
                              child: roundedImage(
                                  Utils.getImg(m.signature_src), 6, 6),
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FxText.titleLarge(
                            m.name,
                            fontWeight: 800,
                            color: Colors.black,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          const Divider(),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('Date', Utils.to_date(m.created_at)),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('PHONE NUMBER', m.phone_number),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('STATUS',
                              m.isOut() ? 'CHECKED OUT' : 'CHECKED IN'),
                          const SizedBox(
                            height: 15,
                          ),
                          (m.isOut())
                              ? const SizedBox()
                              : FxButton.block(
                                  onPressed: () async {
                                    //pop
                                    Navigator.pop(context);

                                    VisitorRecordModelLocal rec =
                                        VisitorRecordModelLocal.fromJson(
                                            m.toJson());
                                    rec.isEdit = true;
                                    m.delete();
                                    await Get.to(
                                        () => VisitorRecordCreateScreen(rec));
                                    await init();
                                  },
                                  child: FxText.titleLarge(
                                    'UPDATE RECORD',
                                    color: Colors.white,
                                  ),
                                ),
                        ],
                      ),
                    ))
                  ],
                ),
              ),
            ),
          );
        });
  }

  void applySearch() {
    if (keyWord.isEmpty) {
      items = items;
    } else {
      //search by name and phone number
      items = items
          .where((element) =>
              element.name.toLowerCase().contains(keyWord.toLowerCase()) ||
              element.phone_number
                  .toLowerCase()
                  .contains(keyWord.toLowerCase()))
          .toList();
    }
    setState(() {});
  }
}
