import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutx/flutx.dart';

import '../../models/MyClasses.dart';
import '../../models/UserMiniModel.dart';
import '../../sections/widgets.dart';
import '../../theme/app_theme.dart';
import '../../theme/custom_theme.dart';
import '../../utils/SizeConfig.dart';
import '../../utils/my_widgets.dart';

class UsersPickerScreen extends StatefulWidget {
  Map<String, dynamic> params = {};

  UsersPickerScreen(this.params, {super.key});

  @override
  UsersPickerScreenState createState() => UsersPickerScreenState();
}

class UsersPickerScreenState extends State<UsersPickerScreen> {
  List<UserMiniModel> items = [];

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
  String title = "Users";
  TextEditingController search_controler = TextEditingController();
  var searchFocusNode = FocusNode();

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
            : FxText.titleLarge(
                title,
                color: Colors.white,
                fontWeight: 700,
                height: .6,
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
        child: Column(
          children: [
            const SizedBox(
              height: 5,
            ),
            Row(
              children: [
                const SizedBox(
                  width: 15,
                ),
                FxText.bodyLarge(
                  "Found ",
                  fontWeight: 800,
                ),
                FxText.bodyLarge(
                  "${items.length} records",
                  color: Colors.black,
                  fontWeight: 800,
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              height: 0,
            ),
            Expanded(
              child: FutureBuilder(
                  future: futureInit,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return myListLoaderWidget(context);
                    }
                    if (items.isEmpty) {
                      return Center(
                          child: Column(
                        children: [
                          const Spacer(),
                          FxText('No item found.'),
                          FxButton.text(
                            child: FxText(
                              'Reload',
                              color: CustomTheme.primary,
                            ),
                            onPressed: () {
                              doRefresh(isRefresh: true);
                            },
                          ),
                          const Spacer(),
                        ],
                      ));
                    }

                    return RefreshIndicator(
                      backgroundColor: Colors.white,
                      onRefresh: doRefresh1,
                      child: CustomScrollView(
                        slivers: [
                          SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                UserMiniModel m = items[index];
                                return InkWell(
                                  onTap: () {
                                    Navigator.pop(context, m);
                                  },
                                  child: Column(
                                    children: [
                                      userMiniWidget(m),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      const Divider(
                                        height: 0,
                                      )
                                    ],
                                  ),
                                );
                              },
                              childCount: items.length, // 1000 list items
                            ),
                          )
                        ],
                      ),
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }

  List<UserMiniModel> originalItems = [];
  String task_picker = "";
  String user_type = "";
  MyClasses selectedClass = MyClasses();

  Future<void> init({bool isRefresh = false}) async {
    if (originalItems.length < 10) {
      originalItems = await UserMiniModel.getItems();
    }

    if (widget.params['task_picker'] != null) {
      task_picker = 'task_picker';
    }

    if (widget.params['title'] != null) {
      title = widget.params['title'].toString();
    }

    if (widget.params['user_type'] != null) {
      user_type = widget.params['user_type'].toString();
    }

    items.clear();

    for (UserMiniModel element in originalItems) {
      if (searchKeyWord.isNotEmpty) {
        if (!element.name
            .toLowerCase()
            .contains(searchKeyWord.toString().toLowerCase().trim())) {
          continue;
        }
      }

      // print("---=>${originalItems.length}<===");
      if (user_type.isNotEmpty) {
        if (element.user_type.toLowerCase() != user_type.toLowerCase()) {
          continue;
        }
      }

      items.add(element);
    }

    items.sort((a, b) => a.name.compareTo(b.name));

    setState(() {});
  }
}
