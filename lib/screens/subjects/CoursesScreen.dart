import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/MainCourse.dart';
import 'package:schooldynamics/sections/widgets.dart';
import 'package:schooldynamics/utils/Utils.dart';

class MainCoursesScreen extends StatefulWidget {
  Map<String, dynamic> params;

  MainCoursesScreen(
    this.params, {
    super.key,
  });
  @override
  State<MainCoursesScreen> createState() => _MainCoursesScreenState();
}

class _MainCoursesScreenState extends State<MainCoursesScreen> {
  List<MainCourse> items = [];
  List<MainCourse> allItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInit();
  }

  bool isLoading = false;
  bool is_select = false;
  bool isSearch = false;
  bool searchIsOpen = false;
  String searchWord = "";

  Future<void> myInit() async {
    if (widget.params['is_select'].toString() == 'is_select') {
      is_select = true;
    }

    setState(() {
      isLoading = true;
    });
    allItems = await MainCourse.get_items();
    items = [];

    allItems.forEach((element) {
      if (element.get_name().toLowerCase().contains(searchWord.toLowerCase())) {
        items.add(element);
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  Widget searchInput() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: TextField(
        autofocus: true,
        decoration: const InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
        ),
        onChanged: (value) {
          setState(() {
            searchWord = value;
          });
          myInit();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: true
          ? null
          : FloatingActionButton(
              onPressed: () {
                // Get.to(()=>CourseEditScreen());
              },
              child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: searchIsOpen
            ? searchInput()
            : FxText.titleLarge(
                "Courses",
                color: Colors.white,
                fontWeight: 700,
              ),
        systemOverlayStyle: Utils.overlay(),
        actions: [
          IconButton(
            icon: Icon(
              searchIsOpen ? Icons.close : Icons.search,
            ),
            onPressed: () {
              setState(() {
                searchIsOpen = !searchIsOpen;
              });
              if (!searchIsOpen) {
                searchWord = "";
                myInit();
              }
            },
          ),
          SizedBox(
            width: 15,
          ),
        ],
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : items.isEmpty
              ? noItemWidget('No Item Found', () {
                  myInit();
                })
              : RefreshIndicator(
                  onRefresh: myInit,
                  backgroundColor: Colors.white,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      MainCourse item = items[index];
                      return Container(
                        color:
                            index.isOdd ? Colors.grey[100] : Colors.grey[300],
                        child: ListTile(
                          dense: true,
                          onTap: () {
                            if (is_select) {
                              Get.back(result: item);
                              return;
                            }
                            // Get.to(()=>CourseScreen({'item': item}), arguments: item);
                          },
                          title: FxText.bodyMedium(
                            item.get_name(),
                            color: Colors.black,
                            fontWeight: 700,
                          ),
                          subtitle: FxText.bodySmall(
                            item.get_description(),
                          ),
                          //popup menu with edit and delete
                          trailing: true
                              ? null
                              : PopupMenuButton(
                                  itemBuilder: (BuildContext context) {
                                    return [
                                      PopupMenuItem(
                                        child: ListTile(
                                          title: FxText.bodyMedium("Edit"),
                                          onTap: () {
                                            // Get.to(()=>CourseEditScreen({'item': item}), arguments: item);
                                          },
                                        ),
                                      ),
                                      PopupMenuItem(
                                        child: ListTile(
                                          title: FxText.bodyMedium("Delete"),
                                          onTap: () {
                                            Utils.confirmDialog(
                                              context,
                                              "Delete",
                                              "Are you sure you want to delete this item?",
                                              () async {
                                                await item.delete();
                                                myInit();
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ];
                                  },
                                ),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}