import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/SubjectModel.dart';
import 'package:schooldynamics/screens/subjects/SubjectModelEditScreen.dart';
import 'package:schooldynamics/sections/widgets.dart';
import 'package:schooldynamics/utils/Utils.dart';

class SubjectsScreen extends StatefulWidget {
  Map<String, dynamic> params;

  SubjectsScreen(
    this.params, {
    super.key,
  });
  @override
  State<SubjectsScreen> createState() => _SubjectsScreenState();
}

class _SubjectsScreenState extends State<SubjectsScreen> {
  List<SubjectModel> items = [];
  List<SubjectModel> allItems = [];

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
    if (widget.params['task'].toString() == 'Select') {
      is_select = true;
    }

    setState(() {
      isLoading = true;
    });
    allItems = await SubjectModel.get_items();
    items = [];

    for (var element in allItems) {
      if (element.get_name().toLowerCase().contains(searchWord.toLowerCase())) {
        items.add(element);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  Widget searchInput() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => SubjectModelEditScreen(const {}));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: searchIsOpen
            ? searchInput()
            : FxText.titleLarge(
                "Subjects",
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
          const SizedBox(
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
                      SubjectModel item = items[index];
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
                          title: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              FxText.bodyMedium(
                                "#${item.id}. ${item.get_name()}",
                                color: Colors.black,
                                fontWeight: 700,
                              ),
                              FxText.bodySmall("TEACHER: ${item.teacher_name}"),
                              FxText.bodySmall("CLASS: ${item.academic_class_text}"),
                              FxText.bodySmall("Other Teachers: "
                                  "${item.get_other_teachers()}"),
                            ],
                          ),
                          //popup menu with edit and delete
                          trailing: PopupMenuButton(
                            itemBuilder: (BuildContext context) {
                              return [
                                PopupMenuItem(
                                  child: ListTile(
                                    dense: true,
                                    title: FxText.bodyMedium("Edit"),
                                    onTap: () {
                                      Get.back();
                                      Get.to(
                                          () => SubjectModelEditScreen(
                                              {'item': item}),
                                          arguments: item);
                                    },
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    title: FxText.bodyMedium("Delete"),
                                    dense: true,
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
