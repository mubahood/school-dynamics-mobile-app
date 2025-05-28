import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/SchemeWorkItemModel.dart';
import 'package:schooldynamics/theme/app_theme.dart';
import 'package:schooldynamics/theme/custom_theme.dart';
import 'package:schooldynamics/utils/my_widgets.dart';

import '../../models/MySubjects.dart';
import 'SubjectSchemeWorkScreen.dart';

class SchemeWorkHomeScreen extends StatefulWidget {
  const SchemeWorkHomeScreen({super.key});

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
    List<SchemeWorkItemModel> items = await SchemeWorkItemModel.get_items();
    for (int i = 0; i < mySubjects.length; i++) {
      //lessons_planned_count
      mySubjects[i].lessons_planned_count = items
          .where((element) => element.subject_id == mySubjects[i].id.toString())
          .length;
      //lessons_planned_taught, where teacher_status = 'Conducted'
      mySubjects[i].lessons_planned_taught = items
          .where((element) =>
              element.subject_id == mySubjects[i].id.toString() &&
              element.teacher_status == 'Conducted')
          .length;
      //lessons_skipped_count, where teacher_status = 'Skipped'
      mySubjects[i].lessons_skipped_count = items
          .where((element) =>
              element.subject_id == mySubjects[i].id.toString() &&
              element.teacher_status == 'Skipped')
          .length;

      //lessons_planned_pending, where teacher_status = 'Pending'
      mySubjects[i].lessons_planned_pending = items
          .where((element) =>
              element.subject_id == mySubjects[i].id.toString() &&
              element.teacher_status == 'Pending')
          .length;
    }

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
            FxText.titleLarge(
              "Scheme Work".toUpperCase(),
              color: Colors.white,
              maxLines: 2,
              fontWeight: 700,
            ),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabAlignment: TabAlignment.center,
          isScrollable: false,
          tabs: [
            Tab(text: 'MY SUBJECTS (${mySubjects.length})'),
            const Tab(text: 'MY SUPERVISIONS'),
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
      color: Colors.white,
      backgroundColor: CustomTheme.primary,
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
                  "${mySubject.subject_name} - ${mySubject.name}",
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
                    ),
                    FxText.bodySmall(
                      mySubject.lessons_planned_count.toString(),
                      color: Colors.black,
                      height: 1,
                      fontWeight: 800,
                    ),
                  ],
                ),
                Row(
                  children: [
                    FxText.bodySmall(
                      'LESSONS Conducted: '.toUpperCase(),
                      color: Colors.black,
                      height: 1,
                    ),
                    FxText.bodySmall(
                      mySubject.lessons_planned_taught.toString(),
                      color: Colors.black,
                      height: 1,
                      fontWeight: 800,
                    ),
                  ],
                ),
                Row(
                  children: [
                    FxText.bodySmall(
                      'LESSONS SKIPPED: '.toUpperCase(),
                      color: Colors.black,
                      height: 1,
                    ),
                    FxText.bodySmall(
                      mySubject.lessons_skipped_count.toString(),
                      color: Colors.black,
                      height: 1,
                      fontWeight: 800,
                    ),
                  ],
                ),
                Row(
                  children: [
                    FxText.bodySmall(
                      'LESSONS NOT TAUGHT YET: '.toUpperCase(),
                      color: Colors.black,
                      height: 1,
                    ),
                    FxText.bodySmall(
                      mySubject.lessons_planned_pending.toString(),
                      color: Colors.black,
                      height: 1,
                      fontWeight: 800,
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
