import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/EmployeeModel.dart';
import 'package:schooldynamics/screens/employees/EmployeeCreateScreen.dart';

import '../../models/MyClasses.dart';
import '../../models/UserModel.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';

class EmployeesScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  EmployeesScreen(this.params, {Key? key}) : super(key: key);

  @override
  EmployeesScreenState createState() => EmployeesScreenState();
}

class EmployeesScreenState extends State<EmployeesScreen> {
  List<EmployeeModel> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    doRefresh(isRefresh: true);
  }

  Future<dynamic> doRefresh1() async {
    doRefresh(isRefresh: true);
  }

  Future<dynamic> doRefresh({bool isRefresh = false}) async {
    futureInit = init(isRefresh: isRefresh);
    setState(() {});
  }

  late Future<dynamic> futureInit;

  bool searchIsopen = false;
  String searchKeyWord = "";
  TextEditingController search_controler = TextEditingController();
  var searchFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => EmployeeCreateScreen({}));
          doRefresh(
            isRefresh: true,
          );
        },
        backgroundColor: CustomTheme.primary,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      appBar: AppBar(
        backgroundColor: CustomTheme.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        // remove back button in appbar.
        title: searchIsopen
            ? FxContainer(
                color: Colors.white,
                padding: const EdgeInsets.only(left: 10, top: 8, bottom: 8),
                child: FormBuilderTextField(
                  name: "search",
                  onChanged: (x) {
                    setState(() {
                      searchKeyWord = x.toString();
                    });
                    doRefresh();
                  },
                  decoration: InputDecoration(
                    hintText: "Search ...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(MySize.size8),
                        ),
                        borderSide: BorderSide.none),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(MySize.size8),
                        ),
                        borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(MySize.size8),
                        ),
                        borderSide: BorderSide.none),
                    isDense: true,
                    contentPadding: const EdgeInsets.all(0),
                  ),
                  controller: search_controler,
                  focusNode: searchFocusNode,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: MySize.size8,
                  ),
                  FxText.titleLarge(
                    'Employees',
                    color: Colors.white,
                    fontWeight: 700,
                    height: .6,
                  ),
                  //found
                  FxText.bodySmall(
                    "${items.length} employees",
                    color: Colors.white,
                    fontWeight: 500,
                  ),
                ],
              ),
        actions: [
          InkWell(
            onTap: () {
              searchKeyWord = "";
              setState(() {
                searchIsopen = !searchIsopen;
                if (searchIsopen) {
                  searchFocusNode.requestFocus();
                } else {
                  searchFocusNode.unfocus();
                }
              });
              doRefresh();
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Icon(
                searchIsopen ? FeatherIcons.x : FeatherIcons.search,
                color: Colors.white,
              ),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
            future: futureInit,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return myListLoaderWidget(context);
              }
              if (items.isEmpty) {
                return emptyListWidget(
                    "No Employee Found. Press (+) button to add new.", () {
                  init();
                });
              }

              return Container(
                child: RefreshIndicator(
                  backgroundColor: Colors.white,
                  onRefresh: doRefresh1,
                  child: CustomScrollView(
                    slivers: [
                      SliverAppBar(
                        toolbarHeight: 45,
                        backgroundColor: CupertinoColors.lightBackgroundGray,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FxContainer(
                              color: CupertinoColors.lightBackgroundGray,
                              borderRadiusAll: 0,
                              padding: const EdgeInsets.only(top: 0),
                              child: Wrap(
                                runSpacing: 0,
                                children: <Widget>[
                                  _buildChip('All'),
                                  _buildChip('Male'),
                                  _buildChip('Female'),
                                  _buildChip(selected_class_text.isEmpty
                                      ? "Class"
                                      : 'Class - $selected_class_text'),
                                  _buildChip('Fees'),
                                ],
                              ),
                            ),
                          ],
                        ),
                        automaticallyImplyLeading: false,
                        floating: true,
                        elevation: 1,
                        leadingWidth: 0,
                        stretch: true,
                        shadowColor: CustomTheme.primary,
                      ),
                      SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int index) {
                            UserModel m =
                                UserModel.fromJson(items[index].toJson());
                            return InkWell(
                              onTap: () async {
                                if (task_picker == 'task_picker') {
                                  Navigator.pop(context, items[index]);
                                } else {
                                  // Get.to(() => StudentScreen(data: items[index]));
                                }
                              },
                              child: userWidget3(m, context,
                                  task_picker: task_picker),
                            );
                          },
                          childCount: items.length, // 1000 list items
                        ),
                      )
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  List<EmployeeModel> originalItems = [];
  String task_picker = "";
  MyClasses selectedClass = MyClasses();

  Future<void> init({bool isRefresh = false}) async {
    if (widget.params['task_picker'] != null) {
      task_picker = 'task_picker';
    }

    if (widget.params['class'].runtimeType == MyClasses) {
      selectedClass = widget.params['class'];
      selected_class_id = selectedClass.id.toString();
      selected_class_text = selectedClass.short_name.toString();
    }

    if (isRefresh || originalItems.isEmpty) {
      originalItems = await EmployeeModel.get_items();
    }
    if (classes.isEmpty) {
      classes = await MyClasses.getItems();
    }
    items.clear();
    for (EmployeeModel element in originalItems) {
      if (searchKeyWord.isNotEmpty) {
        if (!element.name
            .toLowerCase()
            .contains(searchKeyWord.toString().toLowerCase().trim())) {
          continue;
        }
      }

      if (filteredParameters.contains('Male')) {
        if (element.sex != 'Male') {
          continue;
        }
      }
      if (filteredParameters.contains('Female')) {
        if (element.sex != 'Female') {
          continue;
        }
      }
      if (selected_class_id.isNotEmpty) {
        if (element.current_class_id != selected_class_id) {
          continue;
        }
      }

      items.add(element);
    }

    items.sort((a, b) => a.name.compareTo(b.name));

    setState(() {});
  }

  List<String> filteredParameters = ['All'];

  addItemToFilter(String label) async {
    if (label == 'Male') {
      filteredParameters.remove('Female');
      if (filteredParameters.contains('Male')) {
        filteredParameters.remove('Male');
      } else {
        filteredParameters.add('Male');
      }
    }
    if (label == 'Female') {
      filteredParameters.remove('Male');
      if (filteredParameters.contains('Female')) {
        filteredParameters.remove('Female');
      } else {
        filteredParameters.add('Female');
      }
    }

    if (label.contains('Class')) {
      if (classes.isEmpty) {
        Utils.toast('Fetching classes...');
        classes = await MyClasses.getItems();
      }
      showBottomSheetAccountPicker();
      return;
    }

    if (label != 'All') {
      filteredParameters.remove('All');
    } else {
      filteredParameters.clear();
      selected_class_id = "";
      selected_class_text = "";
      filteredParameters.add('All');
    }

    setState(() {});
    doRefresh();
  }

  List<MyClasses> classes = [];

  String selected_class_id = "";
  String selected_class_text = "";

  void showBottomSheetAccountPicker() {
    showModalBottomSheet(
        context: context,
        barrierColor: CustomTheme.primary.withOpacity(.5),
        builder: (BuildContext buildContext) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(MySize.size16),
                topRight: Radius.circular(MySize.size16),
              ),
            ),
            child: Container(
              padding: const EdgeInsets.only(top: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FxText.titleMedium(
                          'Filter by class',
                          color: Colors.black,
                        ),
                        InkWell(
                          onTap: () {
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child: const Icon(
                            FeatherIcons.x,
                            color: Colors.red,
                          ),
                        )
                      ],
                    ),
                  ),
                  const Divider(),
                  Expanded(
                    child: ListView.builder(
                        itemCount: classes.length,
                        itemBuilder: (context, position) {
                          MyClasses c = classes[position];
                          return ListTile(
                            onTap: () {
                              selected_class_id = c.id.toString();
                              selected_class_text = c.short_name.toString();
                              setState(() {});
                              Navigator.pop(context);
                              doRefresh();
                            },
                            title: FxText.titleMedium(
                              c.name,
                              color: CustomTheme.primary,
                              maxLines: 1,
                              fontWeight: 700,
                            ),
                            subtitle: FxText.bodySmall(
                              c.short_name,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            visualDensity: VisualDensity.compact,
                            dense: true,
                          );
                        }),
                  ),
                ],
              ),
            ),
          );
        });
  }

  Widget _buildChip(String label) {
    bool isSelected = false;
    if (filteredParameters.contains(label)) {
      isSelected = true;
    } else {
      isSelected = false;
    }
    if (label.contains('Class') && selected_class_text.isNotEmpty) {
      isSelected = true;
    }
    return FxContainer(
      onTap: () {
        addItemToFilter(label);
      },
      margin: const EdgeInsets.only(right: 5, top: 5),
      padding: const EdgeInsets.only(left: 5, right: 5, top: 5, bottom: 5),
      borderRadiusAll: 20,
      borderColor: CustomTheme.primary,
      bordered: true,
      color: isSelected ? CustomTheme.primary : Colors.grey.shade100,
      child: FxText(
        label,
        fontSize: 14,
        fontWeight: 700,
        color: isSelected ? Colors.white : Colors.black,
      ),
    );
  }
}
