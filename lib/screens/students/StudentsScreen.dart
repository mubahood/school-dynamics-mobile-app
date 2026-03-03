import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:get/get.dart';

import '../../models/MyClasses.dart';
import '../../models/UserModel.dart';
import '../../theme/custom_theme.dart';
import '../../design_system/design_system.dart';
import '../../sections/widgets.dart';
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
  List<UserModel> originalItems = [];
  List<MyClasses> classes = [];
  String task_picker = '';
  String selected_class_id = '';
  String selected_class_text = '';
  List<String> filteredParameters = ['All'];

  bool searchIsOpen = false;
  String searchKeyWord = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  late Future<dynamic> futureInit;

  @override
  void initState() {
    super.initState();
    doRefresh(isRefresh: true);
  }

  Future<void> doRefresh1() async => doRefresh(isRefresh: true);

  Future<void> doRefresh({bool isRefresh = false}) async {
    futureInit = _init(isRefresh: isRefresh);
    setState(() {});
  }

  Future<void> _init({bool isRefresh = false}) async {
    if (widget.params['task_picker'] != null) task_picker = 'task_picker';

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
    for (final UserModel u in originalItems) {
      if (searchKeyWord.isNotEmpty &&
          !u.name
              .toLowerCase()
              .contains(searchKeyWord.toLowerCase().trim())) {
        continue;
      }
      if (filteredParameters.contains('Male') && u.sex != 'Male') continue;
      if (filteredParameters.contains('Female') && u.sex != 'Female') continue;
      if (selected_class_id.isNotEmpty &&
          u.current_class_id != selected_class_id) continue;
      items.add(u);
    }
    items.sort((a, b) => a.name.compareTo(b.name));
    setState(() {});
  }

  MyClasses selectedClass = MyClasses();

  void _addFilter(String label) async {
    if (label == 'Male') {
      filteredParameters.remove('Female');
      filteredParameters.contains('Male')
          ? filteredParameters.remove('Male')
          : filteredParameters.add('Male');
    } else if (label == 'Female') {
      filteredParameters.remove('Male');
      filteredParameters.contains('Female')
          ? filteredParameters.remove('Female')
          : filteredParameters.add('Female');
    } else if (label.contains('Class')) {
      if (classes.isEmpty) {
        Utils.toast('Fetching classes…');
        classes = await MyClasses.getItems();
      }
      _showClassPicker();
      return;
    } else if (label == 'All') {
      filteredParameters
        ..clear()
        ..add('All');
      selected_class_id = '';
      selected_class_text = '';
    } else {
      filteredParameters.remove('All');
    }
    setState(() {});
    doRefresh();
  }

  void _showClassPicker() {
    showModalBottomSheet(
      context: context,
      barrierColor: CustomTheme.primary.withValues(alpha: 0.5),
      builder: (ctx) => Container(
        color: Colors.white,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 14, 8, 0),
              child: Row(
                children: [
                  Text('Filter by class',
                      style: AppTypography.titleMedium
                          .copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(FeatherIcons.x,
                        color: Colors.red, size: 20),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView.builder(
                itemCount: classes.length,
                itemBuilder: (_, i) {
                  final MyClasses c = classes[i];
                  final bool isSel =
                      selected_class_id == c.id.toString();
                  return ListTile(
                    dense: true,
                    selected: isSel,
                    selectedColor: AppColors.primary,
                    selectedTileColor:
                        AppColors.primary.withValues(alpha: 0.06),
                    onTap: () {
                      selected_class_id = c.id.toString();
                      selected_class_text = c.short_name;
                      setState(() {});
                      Navigator.pop(ctx);
                      doRefresh();
                    },
                    title: Text(c.name,
                        style: AppTypography.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                          color: isSel
                              ? AppColors.primary
                              : AppColors.textPrimary,
                        )),
                    subtitle: Text(c.short_name,
                        style: AppTypography.bodySmall
                            .copyWith(color: AppColors.textSecondary)),
                    trailing: isSel
                        ? Icon(Icons.check,
                            size: 18, color: AppColors.primary)
                        : null,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      /* floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Get.to(() => StudentCreateScreen(const {}));
          _init();
        },
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add, color: AppColors.onPrimary),
      ),*/
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        titleSpacing: 0,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.onPrimary),
        title: searchIsOpen
            ? Padding(
                padding: const EdgeInsets.only(right: 4),
                child: TextField(
                  controller: _searchController,
                  focusNode: _searchFocusNode,
                  onChanged: (v) {
                    searchKeyWord = v;
                    doRefresh();
                  },
                  textInputAction: TextInputAction.search,
                  keyboardType: TextInputType.name,
                  style: const TextStyle(color: Colors.white, fontSize: 15),
                  cursorColor: Colors.white,
                  decoration: InputDecoration(
                    hintText: 'Search students…',
                    hintStyle: TextStyle(
                        color: Colors.white.withValues(alpha: 0.65),
                        fontSize: 15),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              )
            : Text(
                'Students',
                style: AppTypography.titleLarge.copyWith(
                    color: AppColors.onPrimary, fontWeight: FontWeight.w700),
              ),
        actions: [
          IconButton(
            icon: Icon(
              searchIsOpen ? FeatherIcons.x : FeatherIcons.search,
              color: AppColors.onPrimary,
            ),
            onPressed: () {
              searchKeyWord = '';
              _searchController.clear();
              setState(() => searchIsOpen = !searchIsOpen);
              if (searchIsOpen) {
                _searchFocusNode.requestFocus();
              } else {
                _searchFocusNode.unfocus();
              }
              doRefresh();
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: futureInit,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return myListLoaderWidget(context);
          }
          return Column(
            children: [
              // ── Filter bar ─────────────────────────────────────────────
              Container(
                color: AppColors.surface,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.fromLTRB(12, 10, 12, 6),
                      child: Row(
                        children: [
                          _chip('All'),
                          _chip('Male'),
                          _chip('Female'),
                          _chip(selected_class_text.isEmpty
                              ? 'Class'
                              : 'Class: $selected_class_text'),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                      child: Row(
                        children: [
                          Text(
                            '${items.length} student${items.length == 1 ? '' : 's'}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Divider(height: 1, color: AppColors.border),
                  ],
                ),
              ),
              // ── List ───────────────────────────────────────────────────
              Expanded(
                child: items.isEmpty
                    ? _emptyState()
                    : RefreshIndicator(
                        color: AppColors.primary,
                        backgroundColor: AppColors.surface,
                        onRefresh: doRefresh1,
                        child: ListView.builder(
                          itemCount: items.length,
                          itemBuilder: (ctx, i) => userWidget(
                              items[i], ctx,
                              task_picker: task_picker),
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _chip(String label) {
    final bool sel = filteredParameters.contains(label) ||
        (label.contains('Class') && selected_class_text.isNotEmpty);
    return GestureDetector(
      onTap: () => _addFilter(label),
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        decoration: BoxDecoration(
          color: sel ? AppColors.primary : Colors.transparent,
          border: Border.all(
            color: sel ? AppColors.primary : AppColors.border,
          ),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          label,
          style: AppTypography.bodySmall.copyWith(
            fontWeight: FontWeight.w600,
            color: sel ? AppColors.onPrimary : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _emptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.school_outlined,
                size: 56, color: AppColors.textSecondary.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text('No students found',
                style: AppTypography.titleMedium
                    .copyWith(color: AppColors.textPrimary)),
            const SizedBox(height: 6),
            Text(
              searchKeyWord.isNotEmpty
                  ? 'Try a different search term.'
                  : 'Tap + to add the first student.',
              style: AppTypography.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => doRefresh(isRefresh: true),
              icon: const Icon(FeatherIcons.refreshCw, size: 14),
              label: const Text('Reload'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
