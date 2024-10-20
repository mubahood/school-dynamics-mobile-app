import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/StreamModel.dart';

import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';

class StreamsScreen extends StatefulWidget {
  String class_id = '';

  StreamsScreen(this.class_id, {Key? key}) : super(key: key);

  @override
  StreamsScreenState createState() => new StreamsScreenState();
}

class StreamsScreenState extends State<StreamsScreen> {
  List<StreamModel> items = [];

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
          iconTheme: IconThemeData(color: Colors.white),
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
              return Center(child: FxText('No item found.'));
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
                          StreamModel item = items[index];
                          return FxContainer(
                            margin: EdgeInsets.only(top: 5),
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
                                Spacer(),
                                FxText.titleSmall(
                                  item.name,
                                  height: .8,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FxText.bodySmall(
                                  item.academic_class_text.toString(),
                                  height: .9,
                                  maxLines: 2,
                                  color: CustomTheme.primary,
                                ),
                                const Spacer(),
                                FxText.bodySmall(
                                  "${item.teacher_text} Students",
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
            );
          }),
    );
  }

  Future<void> init() async {
    items = await StreamModel.get_items(
      where: " academic_class_id = '${widget.class_id}' ",
    );
    setState(() {});
  }
}
