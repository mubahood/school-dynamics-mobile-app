import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/theme/custom_theme.dart';
import 'package:schooldynamics/utils/my_widgets.dart';

import '../../models/MySubjects.dart';
import 'SubjectSchemeWorkScreen.dart';

class SchemeWorkHomeScreen extends StatefulWidget {
  SchemeWorkHomeScreen({Key? key}) : super(key: key);

  @override
  _SchemeWorkHomeScreenState createState() => _SchemeWorkHomeScreenState();
}

class _SchemeWorkHomeScreenState extends State<SchemeWorkHomeScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  List<MySubjects> mySubjects = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    my_init();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> my_init() async {
    loading = true;
    setState(() {});

    mySubjects = await MySubjects.getItems();
    mySubjects.sort((a, b) => a.id.compareTo(b.id));

    loading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: const Icon(
              Icons.refresh,
              size: 35,
            ),
            onPressed: () {
              // show_found_passenger(widget.item.passengers[0]);
              // return;
              my_init();
            },
          )
        ],
        backgroundColor: CustomTheme.primary,
        title: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FxText.titleMedium(
              "Scheme Work".toUpperCase(),
              color: Colors.white,
              maxLines: 2,
              fontWeight: 700,
            ),
            FxText.bodySmall(
              'Expected: 40%',
              color: Colors.white,
              maxLines: 2,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.center,
          isScrollable: false,
          tabs: const [
            Tab(text: 'MY SUBJECTS'),
            Tab(text: 'MY SUPERVISIONS'),
          ],
          indicatorColor: Colors.white,
          labelColor: Colors.white,
          unselectedLabelColor: Colors.white.withOpacity(0.6),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                loading ? myListLoaderWidget(context) : mySubjectWidget(),
                loading
                    ? myListLoaderWidget(context)
                    : ListView.separated(
                        separatorBuilder: (context, index) => const Divider(),
                        itemCount: [].length,
                        itemBuilder: (context, index) {
                          return const Text("data");
                        }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  bool loading = false;

  mySubjectWidget() {
    if ((mySubjects.isEmpty && !loading)) {
      return emptyListWidget('No Subject found.', () {
        my_init();
      });
    }

    return RefreshIndicator(
      onRefresh: my_init,
      child: ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: mySubjects.length,
          itemBuilder: (context, index) {
            return subject_widget(mySubjects[index]);
          }),
    );
  }

  subject_widget(MySubjects mySubject) {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => SubjectSchemeWorkScreen(mySubject));
        my_init();
      },
      child: Container(
        padding: const EdgeInsets.only(left: 10, top: 10, right: 10),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: CustomTheme.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: FxText.titleLarge(
                  mySubject.short_name,
                  color: Colors.white,
                  fontWeight: 800,
                ),
              ),
            ),
            const SizedBox(
              width: 10,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FxText.titleLarge(
                  "${mySubject.subject_name} - #${mySubject.id} - ${mySubject.class_teahcer_id}",
                  fontSize: 16,
                  color: Colors.grey.shade900,
                  fontWeight: 600,
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    FxText.bodySmall(
                      'LESSONS PLANNED: '.toUpperCase(),
                      color: Colors.black,
                      height: 1,
                      fontWeight: 800,
                    ),
                    FxText.bodySmall(
                      '23',
                      color: Colors.black,
                      height: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    FxText.bodySmall(
                      'LESSONS TAUGHT: '.toUpperCase(),
                      color: Colors.black,
                      height: 1,
                      fontWeight: 800,
                    ),
                    FxText.bodySmall(
                      '23',
                      color: Colors.black,
                      height: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    FxText.bodySmall(
                      'LESSONS SKIPPED: '.toUpperCase(),
                      color: Colors.black,
                      height: 1,
                      fontWeight: 800,
                    ),
                    FxText.bodySmall(
                      '23',
                      color: Colors.black,
                      height: 1,
                    ),
                  ],
                ),
                Row(
                  children: [
                    FxText.bodySmall(
                      'LESSONS NOT YET TAUGHT: '.toUpperCase(),
                      color: Colors.black,
                      fontWeight: 800,
                      height: 1,
                    ),
                    FxText.bodySmall(
                      '23',
                      color: Colors.black,
                      height: 1,
                    ),
                  ],
                ),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
