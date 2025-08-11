import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';

import '../../models/MyClasses.dart';
import '../../models/UserModel.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../design_system/design_system.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/Utils.dart';
import '../../utils/my_widgets.dart';
import 'StudentCreateScreen.dart';

class StudentsScreen extends StatefulWidget {
  final Map<String, dynamic> params;

  const StudentsScreen(this.params, {super.key});

  @override
  StudentsScreenState createState() => StudentsScreenState();
}

class StudentsScreenState extends State<StudentsScreen> {
  List<UserModel> items = [];

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
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => StudentCreateScreen(const {}));
          init();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(
          Icons.add,
          color: AppColors.onPrimary,
        ),
      ),
      resizeToAvoidBottomInset: false,
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
        automaticallyImplyLeading: true,
        title: searchIsopen
            ? AppCard.filled(
                backgroundColor: AppColors.surface,
                padding: AppSpacing.allSM,
                child: TextField(
                  onChanged: (x) {
                    setState(() {
                      searchKeyWord = x.toString();
                    });
                    doRefresh();
                  },
                  decoration: InputDecoration(
                    hintText: "Search students...",
                    hintStyle: AppTypography.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTypography.bodyMedium,
                  controller: search_controler,
                  focusNode: searchFocusNode,
                  textInputAction: TextInputAction.search,
                  textCapitalization: TextCapitalization.sentences,
                  keyboardType: TextInputType.name,
                ),
              )
            : Text(
                'Students',
                style: AppTypography.titleLarge.copyWith(
                  color: AppColors.onPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
        actions: [
          IconButton(
            onPressed: () {
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
            icon: Icon(
              searchIsopen ? FeatherIcons.x : FeatherIcons.search,
              color: AppColors.onPrimary,
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
                return Center(
                    child: Container(
                  padding: AppSpacing.allMD,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      AppCard.outlined(
                        padding: AppSpacing.allXL,
                        child: Column(
                          children: [
                            Icon(
                              Icons.school_outlined,
                              size: AppSpacing.iconXL * 2,
                              color: AppColors.textSecondary,
                            ),
                            AppSpacing.gapMD,
                            Text(
                              'No Students Yet',
                              style: AppTypography.titleLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            AppSpacing.gapSM,
                            Text(
                              'You have not added any student yet. Press the + button to add a student.',
                              style: AppTypography.bodyMedium.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            AppSpacing.gapMD,
                            AppButton.primary(
                              text: 'Reload',
                              onPressed: () {
                                doRefresh(isRefresh: true);
                              },
                            ),
                          ],
                        ),
                      ),
                      const Spacer(),
                    ],
                  ),
                ));
              }

              return RefreshIndicator(
                backgroundColor: AppColors.surface,
                color: AppColors.primary,
                onRefresh: doRefresh1,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      toolbarHeight: Get.width / 5,
                      backgroundColor: AppColors.surfaceVariant,
                      title: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Filter chips with design system styling
                          Container(
                            padding: AppSpacing.allSM,
                            child: Wrap(
                              spacing: AppSpacing.sm,
                              runSpacing: AppSpacing.sm,
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
                          AppSpacing.gapSM,
                          Divider(
                            color: AppColors.primary,
                            height: 1,
                          ),
                          // Enhanced results counter
                          Container(
                            padding: AppSpacing.allSM,
                            child: Row(
                              children: [
                                Text(
                                  "Found ",
                                  style: AppTypography.bodyMedium.copyWith(
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.textSecondary,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: AppSpacing.sm,
                                    vertical: AppSpacing.xs,
                                  ),
                                  decoration: BoxDecoration(
                                    color:
                                        AppColors.primaryLight.withOpacity(0.1),
                                    borderRadius: AppSpacing.borderRadiusSM,
                                  ),
                                  child: Text(
                                    "${items.length} students",
                                    style: AppTypography.bodyMedium.copyWith(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ),
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
                      shadowColor: AppColors.primary.withOpacity(0.2),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          UserModel m = items[index];
                          return userWidget(m, context,
                              task_picker: task_picker);
                        },
                        childCount: items.length, // 1000 list items
                      ),
                    )
                  ],
                ),
              );
            }),
      ),
    );
  }

  List<UserModel> originalItems = [];
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
      originalItems = await UserModel.getItems();
    }
    if (classes.isEmpty) {
      classes = await MyClasses.getItems();
    }
    items.clear();
    for (UserModel element in originalItems) {
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

    return Container(
      margin: const EdgeInsets.only(right: AppSpacing.sm, top: AppSpacing.sm),
      child: isSelected
          ? AppCard.filled(
              onTap: () {
                addItemToFilter(label);
              },
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              backgroundColor: AppColors.primary,
              child: Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.onPrimary,
                ),
              ),
            )
          : AppCard.outlined(
              onTap: () {
                addItemToFilter(label);
              },
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              backgroundColor: AppColors.surface,
              child: Text(
                label,
                style: AppTypography.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
    );
  }
}
