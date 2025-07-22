import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/TheologyClassModel.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';
import 'ClassScreen.dart';

class TheologyClassesScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  TheologyClassesScreen(this.params, {super.key});

  @override
  TheologyClassesScreenState createState() => TheologyClassesScreenState();
}

class TheologyClassesScreenState extends State<TheologyClassesScreen> {
  List<TheologyClassModel> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  String title = '';
  bool isPicker = false;

  bool isMultiPicker = false;
  List<TheologyClassModel> selectedItems = [];
  List<int> selectedItemsIds = [];

  Future<dynamic> doRefresh() async {
    if (widget.params['title'] != null) {
      title = widget.params['title'];
    }
    if (widget.params['task'].toString() == 'Select'.toString()) {
      isPicker = true;
    } else if (widget.params['task'].toString() == 'MultiSelect'.toString()) {
      isMultiPicker = true;

      if (widget.params['selectedItems'] != null) {
        if (widget.params['selectedItems'].runtimeType ==
            selectedItems.runtimeType) {
          selectedItems = [];
          //selectedItemsIds
          widget.params['selectedItems'].forEach((x) {
            selectedItemsIds.add(x.id);
            selectedItems.add(x);
          });
        }
      }
    }

    futureInit = init();
    setState(() {});
  }

  late Future<dynamic> futureInit;

  doneSelecting() {
    Get.back(result: selectedItems);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          actions: [
            isMultiPicker
                ? IconButton(
                    onPressed: () {
                      doneSelecting();
                    },
                    icon: const Icon(
                      FeatherIcons.check,
                      size: 35,
                    ))
                : const SizedBox()
          ],
          systemOverlayStyle: Utils.get_theme(),
          titleSpacing: 0,
          backgroundColor: CustomTheme.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: FxText.titleLarge(
            title.isNotEmpty ? title : 'My Classes (${items.length})',
            color: Colors.white,
            fontWeight: 700,
            height: .6,
          )),
      body: FutureBuilder(
          future: futureInit,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return myListLoaderWidget(context);
            }
            if (items.isEmpty) {
              return Center(child: FxText('No item found.'));
            }

            return Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
              child: Column(
                children: [
                  Expanded(
                    child: RefreshIndicator(
                      backgroundColor: Colors.white,
                      onRefresh: doRefresh,
                      child: CustomScrollView(
                        slivers: [
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              crossAxisSpacing: 5,
                              childAspectRatio: 0.7,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                TheologyClassModel myClass = items[index];
                                return FxContainer(
                                  margin: const EdgeInsets.only(top: 5),
                                  onTap: () {
                                    if (isMultiPicker) {
                                      if (selectedItemsIds
                                          .contains(myClass.id)) {
                                        selectedItems.removeWhere(
                                            (item) => item.id == myClass.id);
                                        selectedItemsIds.remove(myClass.id);
                                      } else {
                                        selectedItems.add(myClass);
                                        selectedItemsIds.add(myClass.id);
                                      }
                                      setState(() {});
                                      return;
                                    }

                                    if (isPicker) {
                                      Get.back(result: myClass);
                                      return;
                                    }

                                    Get.to(() => ClassScreen(data: myClass));
                                  },
                                  borderColor: CustomTheme.primary,
                                  bordered: true,
                                  borderRadiusAll: 8,
                                  color: isMultiPicker &&
                                          selectedItemsIds.contains(myClass.id)
                                      ? CustomTheme.primary.withAlpha(80)
                                      : CustomTheme.primary.withAlpha(10),
                                  paddingAll: 10,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                        children: [
                                          Icon(
                                            FeatherIcons.award,
                                            color: CustomTheme.primary,
                                            size: 30,
                                          ),
                                          (isMultiPicker &&
                                              selectedItemsIds
                                                  .contains(myClass.id))
                                              ? FxContainer(
                                            width: 30,
                                            height: 30,
                                            paddingAll: 0,
                                            borderRadiusAll: 100,
                                            bordered: true,
                                            borderColor: Colors.green,
                                            child: Center(
                                              child: Icon(
                                                FeatherIcons.check,
                                                color:
                                                CustomTheme.primary,
                                                size: 24,
                                              ),
                                            ),
                                          )
                                              : SizedBox(),
                                        ],
                                      ),
                                      const Spacer(),
                                      FxText.titleSmall(
                                        "${myClass.name} - ${myClass.short_name}",
                                        height: .8,
                                        color: Colors.black,
                                      ),
                                      const SizedBox(
                                        height: 5,
                                      ),
                                      FxText.bodySmall(
                                        myClass.class_teahcer_text,
                                        height: .9,
                                        maxLines: 2,
                                        color: CustomTheme.primary,
                                      ),
                                      const Spacer(),
                                      FxText.bodySmall(
                                        "${myClass.students_count} Students",
                                        height: .8,
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: items.length,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  isMultiPicker
                      ? Container(
                          margin: EdgeInsets.all(15),
                          child: FxButton.block(
                              onPressed: () {
                                doneSelecting();
                              },
                              child: Center(
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    FxText.titleMedium(
                                      'DONE SELECTING',
                                      color: Colors.white,
                                      fontWeight: 700,
                                    ),
                                    const SizedBox(
                                      width: 15,
                                    ),
                                    const Icon(
                                      FeatherIcons.check,
                                      size: 25,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )),
                        )
                      : const SizedBox(),
                ],
              ),
            );
          }),
    );
  }

  Future<void> init() async {
    items = await TheologyClassModel.get_items();
    setState(() {});
  }
}
