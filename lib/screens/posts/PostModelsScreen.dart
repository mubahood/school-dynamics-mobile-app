import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/PostModel.dart';

import '../../sections/widgets.dart';
import '../../theme/custom_theme.dart';
import '../../utils/AppConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';
import 'PostModelScreen.dart';

class PostModelsScreen extends StatefulWidget {
  String type;
  bool hasBack = true;

  PostModelsScreen(this.type,this.hasBack, {super.key});

  @override
  _PostModelsScreenState createState() => _PostModelsScreenState();
}

class _PostModelsScreenState extends State<PostModelsScreen> {
  @override
  void initState() {
    super.initState();
    doRefresh();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: Utils.get_theme(),
        backgroundColor: CustomTheme.primary,
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        toolbarHeight: widget. hasBack ? 60 : 0,
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleLarge(
              widget.type == 'Notice' ? 'Notice board' : widget.type,
              color: Colors.white,
              fontWeight: 900,
              height: 1,
            ),
            FxText.titleSmall(
              "${posts.length} article${posts.length == 1 ? "" : "s"} found.",
              color: Colors.white,
              fontWeight: 500,
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: Text('Loading...'),
                  );
                default:
                  return mainWidget();
              }
            }),
      ),
    );
  }

  late Future<dynamic> futureInit;

  Future<dynamic> doRefresh() async {
    futureInit = myInit();

    setState(() {});
  }

  List<PostModel> posts = [];

  Future<dynamic> myInit() async {
    // ResourceModel resp = ResourceModel();
    //
    // farmers = await FarmerModel.get_items();

    // categories = await ResourceCategory.get_items();
    posts = await PostModel.get_items(where: ' type = "${widget.type}"');

    if (widget.type == 'Event') {
      List<PostModel> past = [];
      List<PostModel> future = [];
      posts = PostModel.sortByDate(posts);
      for (var item in posts) {
        if (item.isBeforeToday()) {
          past.add(item);
        } else {
          future.add(item);
        }
      }

      //reverse future
      future = future.reversed.toList();
      //merge
      posts = [];
      posts.addAll(future);
      posts.addAll(past);
    }

    setState(() {});
  }

  Widget mainWidget() {
    if (posts.isEmpty) {
      return Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            FxText("No Item Found."),
            const SizedBox(
              height: 5,
            ),
            FxButton.small(
                onPressed: () {
                  doRefresh();
                },
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                borderRadiusAll: 100,
                child: FxText.titleMedium(
                  "Refresh",
                  color: Colors.white,
                )),
            const Spacer(),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: doRefresh,
      color: CustomTheme.primary,
      backgroundColor: Colors.white,
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) {
                  PostModel item = posts[index];
                  if (item.type == 'Event') {
                    return postWidget3(item, () {
                      Get.to(() => PostModelScreen(
                            item: item,
                          ));
                    }, context);
                  }
                  if (item.type == 'News') {
                    return postWidget2(item, (x) {
                      Get.to(() => PostModelScreen(
                            item: item,
                          ));
                    }, context);
                  }
                  return postWidget(item, (x) {
                    Get.to(() => PostModelScreen(
                          item: item,
                        ));
                  }, context);

                  return InkWell(
                    onTap: () {
                      /*Get.to(() =>
                          ResourceDetailScreen(resourceModel: item));*/
                    },
                    child: FxContainer(
                      bordered: true,
                      borderRadiusAll: 10,
                      borderColor: CustomTheme.primary.withOpacity(.4),
                      color: CustomTheme.primary.withOpacity(.2),
                      padding: const EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 10),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 10),
                      child: Flex(
                        direction: Axis.horizontal,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              fit: BoxFit.cover,
                              width: Get.width / 2.5,
                              height: Get.width / 3.5,
                              imageUrl:
                                  '${AppConfig.STORAGE_URL}${item.posted_by_id}',
                              placeholder: (context, url) =>
                                  ShimmerLoadingWidget(height: Get.width / 3.5),
                              errorWidget: (context, url, error) => const Image(
                                image: AssetImage(
                                  AppConfig.NO_IMAGE,
                                ),
                                fit: BoxFit.cover,
                                height: 60,
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: Get.height / 9,
                                  child: FxText.titleMedium(
                                    item.title,
                                    color: Colors.black,
                                    maxLines: 4,
                                    fontWeight: 700,
                                    fontSize: 18,
                                    letterSpacing: .01,
                                    height: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                Flex(
                                  direction: Axis.horizontal,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    FxContainer(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 2),
                                      color: CustomTheme.primary,
                                      child: FxText.bodySmall(
                                        item.type,
                                        color: Colors.white,
                                        fontWeight: 600,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const Spacer(),
                                    FxText.bodySmall(
                                      Utils.to_date_1(item.created_at),
                                      color: Colors.grey.shade700,
                                      fontWeight: 600,
                                      fontSize: 14,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
                childCount: posts.length, // 1000 list items
              ),
            ),
          ],
        ),
      ),
    );
  }
}
