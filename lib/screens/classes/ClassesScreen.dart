import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/MyClasses.dart';
import '../../theme/custom_theme.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';
import 'ClassScreen.dart';

class ClassesScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  ClassesScreen(this.params, {Key? key}) : super(key: key);

  @override
  ClassesScreenState createState() => new ClassesScreenState();
}

class ClassesScreenState extends State<ClassesScreen> {
  List<MyClasses> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  String title = '';
  bool isPicker = false;
  Future<dynamic> doRefresh() async {
    if (widget.params['title'] != null) {
      title = widget.params['title'];
    }
    if (widget.params['task'].toString() == 'Select'.toString()) {
      isPicker = true;
    }

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
              padding: EdgeInsets.only(left: 5, right: 5),
              child: RefreshIndicator(
                backgroundColor: Colors.white,
                onRefresh: doRefresh,
                child: CustomScrollView(
                  slivers: [
                    SliverGrid(
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 5,
                        childAspectRatio: 0.7,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          MyClasses myClass = items[index];
                          return FxContainer(
                            margin: EdgeInsets.only(top: 5),
                            onTap: () {
                              if (isPicker) {
                                Get.back(result: myClass);
                                return;
                              }

                              Get.to(() => ClassScreen(data: myClass));
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
                                  "${myClass.name} - ${myClass.short_name}",
                                  height: .8,
                                  color: Colors.black,
                                ),
                                const SizedBox(
                                  height: 5,
                                ),
                                FxText.bodySmall(
                                  myClass.class_teacher_name,
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
            );
          }),
    );
  }

  Future<void> init() async {
    items = await MyClasses.getItems();
    setState(() {});
  }
}
