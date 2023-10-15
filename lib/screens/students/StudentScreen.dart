import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/UserModel.dart';
import 'package:schooldynamics/utils/Utils.dart';

import '../../models/Transaction.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/my_widgets.dart';
import '../finance/TransactionScreen.dart';
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
    get_transactions();
    setState(() {});
    return "Done";
  }

  Future<void> get_transactions() async {
    transactions_loading = true;
    setState(() {});
    transactions = await Transaction.getItems(where: ' 1 ');
    transactions_loading = false;
    setState(() {});
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
        length: 5,
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
                        child: FxText.titleSmall("SCHOOL FEES".toUpperCase(),
                            fontWeight: 600, color: Colors.white)),
                    Tab(
                        height: 30,
                        child: Container(
                          child: FxText.titleMedium("Attendance".toUpperCase(),
                              fontWeight: 600, color: Colors.white),
                        )),
                    Tab(
                        height: 30,
                        child: Container(
                          child: FxText.titleSmall("DISCIPLINARY".toUpperCase(),
                              fontWeight: 600, color: Colors.white),
                        )),
                    Tab(
                        height: 30,
                        child: Container(
                          child: FxText.titleSmall("REPORT".toUpperCase(),
                              fontWeight: 600, color: Colors.white),
                        )),
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
                        return studentsFragment();
                    }
                  }),
              CustomScrollView(
                slivers: [
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Text("Tab data 2");
                      },
                      childCount: 1,
                    ),
                  )
                ],
              ),
              Text("Records"),
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
                    child: Container(
                        child: Column(
                      children: [
                        title_widget('BIO DATA'),
                        SizedBox(
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
                    )),
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

  studentsFragment() {
    return Container(
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return FxText.bodyMedium("$index");
              },
              childCount: 100,
            ),
          ),
        ],
      ),
    );
  }

  List<Transaction> transactions = [];
  bool transactions_loading = false;

  feesFragment() {
    return transactions_loading
        ? myListLoaderWidget(context)
        : transactions.isEmpty
            ? emptyListWidget('No Transaction.', () {
                get_transactions();
              })
            : Container(
                padding: EdgeInsets.only(left: 5, right: 5),
                child: RefreshIndicator(
                  onRefresh: () async {
                    await my_init();
                  },
                  color: CustomTheme.primary,
                  backgroundColor: Colors.white,
                  child: CustomScrollView(
                    slivers: [
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            return const SizedBox(
                              height: 10,
                            );
                          },
                          childCount: 1, // 1000 list items
                        ),
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            Transaction m = transactions[index];

                            return InkWell(
                              onTap: () {
                                Get.to(() => TransactionScreen(
                                      data: m,
                                    ));
                              },
                              child: Column(
                                children: [
                                  Flex(
                                    direction: Axis.horizontal,
                                    children: [
                                      FxContainer(
                                        color:
                                            CustomTheme.primary.withAlpha(20),
                                        paddingAll: 10,
                                        margin: const EdgeInsets.only(
                                            left: 10,
                                            right: 10,
                                            bottom: 0,
                                            top: 0),
                                        child: Icon(
                                          m.amount_figure < 1
                                              ? FeatherIcons.arrowUp
                                              : FeatherIcons.arrowDown,
                                          color: m.amount_figure < 1
                                              ? Colors.red.shade800
                                              : Colors.green.shade800,
                                        ),
                                      ),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            FxText.bodySmall(
                                                Utils.to_date(m.created_at)),
                                            FxText.titleMedium(
                                              m.account_name,
                                              maxLines: 1,
                                              color: Colors.grey.shade800,
                                              fontWeight: 800,
                                            )
                                          ],
                                        ),
                                      ),
                                      FxText.bodyLarge(
                                        Utils.moneyFormat(m.amount),
                                        fontWeight: 700,
                                        color: (m.amount_figure < 0)
                                            ? Colors.red.shade700
                                            : Colors.green.shade700,
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      )
                                    ],
                                  ),
                                  const Padding(
                                    padding:
                                        EdgeInsets.only(left: 10, right: 10),
                                    child: Divider(),
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: transactions.length, // 1000 list items
                        ),
                      )
                    ],
                  ),
                ),
              );
  }
}
