import 'package:flutter/material.dart';
import 'package:flutx/widgets/text/text.dart';
import 'package:schooldynamics/models/MainCourse.dart';
import 'package:schooldynamics/sections/widgets.dart';
import 'package:schooldynamics/utils/Utils.dart';

class CoursesScreen extends StatefulWidget {
  Map<String, dynamic> params;

  CoursesScreen(
    this.params, {
    super.key,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  List<MainCourse> items = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInit();
  }

  bool isLoading = false;

  Future<void> myInit() async {
    setState(() {
      isLoading = true;
    });
    items = await MainCourse.get_items();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Get.to(()=>CourseEditScreen());
        },
        child: Icon(Icons.add),
      ),
      appBar: AppBar(
        title: FxText.titleLarge(
          "Courses",
          color: Colors.white,
          fontWeight: 700,
        ),
        systemOverlayStyle: Utils.overlay(),
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
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      MainCourse item = items[index];
                      return ListTile(
                        onTap: () {
                          // Get.to(()=>CourseScreen({'item': item}), arguments: item);
                        },
                        title: FxText.bodyMedium(
                          item.get_name(),
                        ),
                        subtitle: FxText.bodySmall(
                          item.get_description(),
                        ),
                        //popup menu with edit and delete
                        trailing: PopupMenuButton(
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
                      );
                    },
                  ),
                ),
    );
  }
}
