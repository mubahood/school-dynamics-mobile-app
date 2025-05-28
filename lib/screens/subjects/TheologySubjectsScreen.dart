import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/TheologySubjectModel.dart';

import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import 'SubjectScreen.dart';

class TheologySubjectsScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  TheologySubjectsScreen(this.params, {super.key});

  @override
  TheologySubjectsScreenState createState() => TheologySubjectsScreenState();
}

class TheologySubjectsScreenState extends State<TheologySubjectsScreen> {
  List<TheologySubjectModel> items = [];

  String title = '';
  bool isPicker = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh();
  }

  Future<dynamic> doRefresh() async {
    futureInit = init();
    setState(() {});
  }

  late Future<dynamic> futureInit;

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
          title: FxText.titleLarge(
            title.isNotEmpty ? title : 'My Subjects (${items.length})',
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

            return RefreshIndicator(
              backgroundColor: Colors.white,
              onRefresh: doRefresh,
              child: ListView.separated(
                  separatorBuilder: (context, index) => const Divider(
                        height: 1,
                      ),
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final TheologySubjectModel m = items[index];
                    return ListTile(
                      onTap: () {
                        if (isPicker) {
                          Get.back(result: m);
                          return;
                        }

                        Get.to(() => SubjectScreen(
                              data: m,
                            ));
                      },
                      title: FxText.titleMedium(
                        "${m.theology_class_text} - ${m.name}".toUpperCase(),
                        color: Colors.black,
                        fontWeight: 700,
                      ),
                      trailing: FxContainer(
                        padding: const EdgeInsets.only(
                            left: 5, right: 5, top: 5, bottom: 5),
                        color: CustomTheme.primary.withAlpha(10),
                        child: const Icon(Icons.chevron_right),
                      ),
                    );
                  }),
            );
          }),
    );
  }

  Future<void> init() async {
    if (widget.params['title'] != null) {
      title = widget.params['title'];
    }
    if (widget.params['task'].toString() == 'Select'.toString()) {
      isPicker = true;
    }
    if (widget.params['theology_class_id'] != null) {
      items = await TheologySubjectModel.get_items(
        where: " theology_class_id = '${widget.params['theology_class_id']}' ",
      );
    } else {
      items = await TheologySubjectModel.get_items();
    }

    setState(() {});
  }
}
