import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/TheologyStreamModel.dart';

import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';

class TheologyStreamsScreen extends StatefulWidget {
  String class_id = '';

  TheologyStreamsScreen(this.class_id, {super.key});

  @override
  TheologyStreamsScreenState createState() => TheologyStreamsScreenState();
}

class TheologyStreamsScreenState extends State<TheologyStreamsScreen> {
  List<TheologyStreamModel> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  String title = '';
  bool isPicker = false;

  Future<dynamic> doRefresh() async {
    isPicker = true;
    futureInit = init();
    setState(() {});
  }

  late Future<dynamic> futureInit;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
          systemOverlayStyle: Utils.get_theme(),
          titleSpacing: 0,
          backgroundColor: CustomTheme.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: Colors.white),
          automaticallyImplyLeading: true,
          // remove back button in appbar.
          title: FxText.titleLarge(
            title.isNotEmpty ? title : 'Streams (${items.length})',
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
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: FxText('No item found.')),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      doRefresh();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: CustomTheme.primary,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 10,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: FxText.bodyLarge(
                      'Reload',
                      color: Colors.white,
                    ),
                  ),
                ],
              );
            }

            return Container(
              padding: const EdgeInsets.only(left: 5, right: 5),
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
                          TheologyStreamModel item = items[index];
                          return FxContainer(
                            margin: const EdgeInsets.only(top: 5),
                            onTap: () {
                              if (isPicker) {
                                Get.back(result: item);
                                return;
                              }

                              // Get.to(() => ClassScreen(data: myClass));
                            },
                            borderColor: CustomTheme.primary,
                            bordered: true,
                            borderRadiusAll: 8,
                            color: CustomTheme.primary.withAlpha(40),
                            paddingAll: 10,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  FeatherIcons.award,
                                  color: CustomTheme.primary,
                                  size: 30,
                                ),
                                const Spacer(),
                                FxText.titleSmall(
                                  item.name,
                                  height: .8,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FxText.bodySmall(
                                  item.theology_class_text.toString(),
                                  height: .9,
                                  maxLines: 2,
                                  color: CustomTheme.primary,
                                ),
                                const Spacer(),
                                
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
            );
          }),
    );
  }

  Future<void> init() async {
    try {
      items = await TheologyStreamModel.get_items();
      if (items.isEmpty) {
        await TheologyStreamModel.getOnlineItems();
        items = await TheologyStreamModel.get_items(
        );
      }
    } catch (e) {}
  }
}
