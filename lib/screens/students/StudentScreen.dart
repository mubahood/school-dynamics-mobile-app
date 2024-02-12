import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/DisciplinaryRecordModel.dart';
import '../../models/RollCall/Participant.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import 'StudentEditBioScreen.dart';
import 'StudentEditGuardianScreen.dart';
import 'StudentEditPhotoScreen.dart';

class StudentScreen extends StatefulWidget {
  const StudentScreen({Key? key, required this.data}) : super(key: key);
  final dynamic data;

  @override
  _CourseTasksScreenState createState() => _CourseTasksScreenState();
}

class _CourseTasksScreenState extends State<StudentScreen> {
  late ThemeData themeData;

  _CourseTasksScreenState();

  late Future<dynamic> futureInit;

  Future<dynamic> _my_init() async {
    futureInit = my_init();
    setState(() {});
    return "done";
  }

  UserModel item = UserModel();

  Future<dynamic> my_init() async {
    item = widget.data;
    getAttendance();
    setState(() {});
    return "Done";
  }

  @override
  void initState() {
    _my_init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: CustomTheme.primary,
        onPressed: () {
          _my_init();
        },
        child: PopupMenuButton<int>(
            onSelected: (x) {
              switch (x.toString()) {
                case '1':
                  Get.to(() => StudentEditBioScreen(
                        data: item,
                      ));
                  break;
                case '2':
                  Get.to(() => StudentEditPhotoScreen(
                        data: item,
                      ));
                  break;

                case '3':
                  Get.to(() => StudentEditGuardianScreen(
                        data: item,
                      ));
                  break;
              }
            },
            icon: const Icon(
              FeatherIcons.moreVertical,
              size: 25,
              color: Colors.white,
            ),
            itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 1,
                    child: Flex(
                      direction: Axis.horizontal,
                      children: [
                        Icon(
                          FeatherIcons.user,
                          color: CustomTheme.primary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        Expanded(child: FxText.bodyLarge('Edit bio data')),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 2,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.camera,
                          color: CustomTheme.primary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Update photo'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 3,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.edit3,
                          color: CustomTheme.primary,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Edit guardian'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 4,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.smile,
                          color: Colors.green.shade700,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Add good record'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 9,
                    child: Row(
                      children: [
                        Icon(
                          FeatherIcons.frown,
                          color: Colors.red.shade700,
                        ),
                        const SizedBox(
                          width: 8,
                        ),
                        FxText.bodyLarge('Report indiscipline'),
                      ],
                    ),
                  ),
                ]),
      ),
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        // remove back button in appbar.

        title: FxText.titleLarge(
          item.name,
          color: Colors.white,
        ),
      ),
      body: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 1,
            backgroundColor: CustomTheme.primary,
            toolbarHeight: 35,
            automaticallyImplyLeading: false,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                /*-------------- Build Tabs here ------------------*/
                TabBar(
                  padding: const EdgeInsets.only(bottom: 0),
                  labelPadding:
                      const EdgeInsets.only(bottom: 2, left: 8, right: 8),
                  indicatorPadding: const EdgeInsets.all(0),
                  labelColor: Colors.white,
                  isScrollable: true,
                  enableFeedback: true,
                  indicator: const UnderlineTabIndicator(
                      borderSide: BorderSide(color: Colors.white, width: 4)),
                  tabs: [
                    Tab(
                        height: 30,
                        child: FxText.titleSmall(
                          "BIO".toUpperCase(),
                          fontWeight: 600,
                          color: Colors.white,
                        )),
                    Tab(
                        height: 30,
                        child: Container(
                          child: FxText.titleMedium("Attendance".toUpperCase(),
                              fontWeight: 600, color: Colors.white),
                        )),
                    Tab(
                        height: 30,
                        child: FxText.titleSmall("DISCIPLINARY".toUpperCase(),
                            fontWeight: 600, color: Colors.white)),
                    Tab(
                        height: 30,
                        child: FxText.titleSmall("REPORT CARDS".toUpperCase(),
                            fontWeight: 600, color: Colors.white)),
                  ],
                )
              ],
            ),
          ),

          /*--------------- Build Tab body here -------------------*/
          body: TabBarView(
            children: <Widget>[
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return mainFragment();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return feesFragment();
                    }
                  }),
              FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return myListLoaderWidget(context);
                      default:
                        return disciplineFragment();
                    }
                  }),
              const Text("Records"),
            ],
          ),
        ),
      ),
    );
  }

  mainFragment() {
    return Container(
      padding: const EdgeInsets.only(left: 15, right: 15),
      child: ListView(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 15,
              ),
              Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      children: [
                        title_widget('BIO DATA'),
                        const SizedBox(
                          height: 5,
                        ),
                        Container(
                            child: titleValueWidget('NAME', '${item.name}')),
                        Container(
                            child: titleValueWidget('SEX', '${item.sex}')),
                        Container(
                            child: titleValueWidget('Date of birth',
                                '${Utils.to_date_1(item.date_of_birth)}')),
                        /*           Container(
                        child: titleValueWidget(
                            'religion', '${item.religion}')),
                    Container(
                        child: titleValueWidget(
                            'nationality', '${item.nationality}')),*/
                        Container(
                            child: titleValueWidget(
                                'Home address', '${item.home_address}')),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  FxContainer(
                    bordered: true,
                    color: CustomTheme.primary.withAlpha(30),
                    borderColor: CustomTheme.primary,
                    paddingAll: 5,
                    borderRadiusAll: 0,
                    child: roundedImage(
                      item.avatar.toString(),
                      2.6,
                      2,
                      radius: 0,
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              const Divider(),
              titleValueWidget2(
                  'SCHOOL PAY CODE', '${item.school_pay_payment_code}'),
              const SizedBox(
                height: 15,
              ),
              title_widget('Academics'),
              titleValueWidget2('Current class', '${item.current_class_id}'),
              titleValueWidget2('Current theology class',
                  '${item.current_theology_class_id}'),
              titleValueWidget2('STUDENT ID', '${item.user_id}'),
              titleValueWidget2(
                  'school pay CODE', '${item.school_pay_payment_code}'),
              titleValueWidget2(
                  'status', '${item.status == '1' ? 'Active' : 'Pending'}'),
              titleValueWidget2(
                  'registered', '${Utils.to_date_1(item.created_at)}'),
              const SizedBox(
                height: 10,
              ),
              title_widget('Guardian'),
              titleValueWidget2("Father's name", '${item.father_name}'),
              titleValueWidget2("mother's name", '${item.mother_name}'),
              titleValueWidget2("guardian's contact", '${item.phone_number_1}'),
              titleValueWidget2(
                  "guArdian's contact 2", '${item.phone_number_2}'),
              titleValueWidget2("Email address", '${item.email}'),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Participant> participants = [];
  List<DisciplinaryRecordModel> disciplinaryRecords = [];

  getAttendance() async {
    transactions_loading = true;
    setState(() {});
    participants = await Participant.get_items(
        where: ' administrator_id = \'${item.id}\'');
    disciplinaryRecords = await DisciplinaryRecordModel.get_items(
        where: ' administrator_id = \'${item.id}\'');
    transactions_loading = false;
    setState(() {});
  }

  bool transactions_loading = false;

  disciplineFragment() {
    return transactions_loading
        ? myListLoaderWidget(context)
        : disciplinaryRecords.isEmpty
            ? emptyListWidget('No Disciplinary Records.', () {
                getAttendance();
              })
            : RefreshIndicator(
                onRefresh: () async {
                  await getAttendance();
                },
                color: CustomTheme.primary,
                backgroundColor: Colors.white,
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          DisciplinaryRecordModel m =
                              disciplinaryRecords[index];
                          return FxContainer(
                            onTap: () {
                              _disciplineBottomSheet(m);
                            },
                            color: m.p()
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
                                    roundedImage(m.avatar.toString(), 8, 8),
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
                                            m.administrator_text,
                                            maxLines: 1,
                                            height: 1,
                                            color: Colors.grey.shade800,
                                            fontWeight: 800,
                                          ),
                                          FxText.bodySmall(m.getDisplayText()),
                                          Row(
                                            children: [
                                              FxCard(
                                                  color: m.p()
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade700,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 2,
                                                    bottom: 4,
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  borderRadiusAll: 50,
                                                  child: FxText.bodySmall(
                                                    m.p()
                                                        ? 'Good Record'
                                                        : 'Indiscipline',
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
                                )
                              ],
                            ),
                          );
                        },
                        childCount:
                            disciplinaryRecords.length, // 1000 list items
                      ),
                    )
                  ],
                ),
              );
  }

  feesFragment() {
    return transactions_loading
        ? myListLoaderWidget(context)
        : participants.isEmpty
            ? emptyListWidget('No Attendance Record.', () {
                getAttendance();
              })
            : RefreshIndicator(
                onRefresh: () async {
                  await getAttendance();
                },
                color: CustomTheme.primary,
                backgroundColor: Colors.white,
                child: CustomScrollView(
                  slivers: [
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          Participant m = participants[index];
                          return FxContainer(
                            onTap: () {
                              _showBottomSheet(m);
                            },
                            color: m.p()
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
                                    roundedImage(m.avatar.toString(), 8, 8),
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
                                            m.administrator_text,
                                            maxLines: 1,
                                            height: 1,
                                            color: Colors.grey.shade800,
                                            fontWeight: 800,
                                          ),
                                          FxText.bodySmall(m.getDisplayText()),
                                          Row(
                                            children: [
                                              FxCard(
                                                  color: m.p()
                                                      ? Colors.green.shade700
                                                      : Colors.red.shade700,
                                                  padding:
                                                      const EdgeInsets.only(
                                                    top: 2,
                                                    bottom: 4,
                                                    left: 8,
                                                    right: 8,
                                                  ),
                                                  borderRadiusAll: 50,
                                                  child: FxText.bodySmall(
                                                    m.p()
                                                        ? 'Present'
                                                        : 'Absent',
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
                                )
                              ],
                            ),
                          );
                        },
                        childCount: participants.length, // 1000 list items
                      ),
                    )
                  ],
                ),
              );
  }

  void _disciplineBottomSheet(DisciplinaryRecordModel m) {
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
                          icon: Icon(
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
                            child: roundedImage(
                              item.avatar.toString(),
                              5,
                              5,
                              radius: 100,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FxText.titleLarge(
                            item.name,
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
                          titleValueWidget('Title', m.getDisplayText()),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('Record Category',
                              m.p() ? 'Good Record' : 'Indiscipline'),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('Details', m.description),
                          Divider(),
                          titleValueWidget(
                              'Head Teacher\'s Comment', m.hm_comment),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget(
                              'Class Teacher\'s Comment', m.teacher_comment),
                          SizedBox(
                            height: 5,
                          ),
                          titleValueWidget(
                              'Student\'s Comment', m.student_comment),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget(
                              'Parent\'s Comment', m.parent_comment),
                          const SizedBox(
                            height: 5,
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

  void _showBottomSheet(Participant m) {
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
                            child: roundedImage(
                              item.avatar.toString(),
                              5,
                              5,
                              radius: 100,
                            ),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          FxText.titleLarge(
                            item.name,
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
                          titleValueWidget('Roll Call', m.getDisplayText()),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget(
                              'Status', m.p() ? 'Present' : 'Absent'),
                          const SizedBox(
                            height: 5,
                          ),
                          titleValueWidget('Details', m.session_text),
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
}
