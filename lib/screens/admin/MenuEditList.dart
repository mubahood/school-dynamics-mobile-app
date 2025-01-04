import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:schooldynamics/models/MenuModel.dart';
import 'package:schooldynamics/utils/my_widgets.dart';

import '../../utils/Utils.dart';
import 'MenuCreateScreen.dart';

class MenuEditList extends StatefulWidget {
  const MenuEditList({super.key});

  @override
  State<MenuEditList> createState() => _MenuEditListState();
}

class _MenuEditListState extends State<MenuEditList> {
  List<MenuModel> menuItems = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    myInit();
  }

  Future<void> myInit() async {
    menuItems = await MenuModel.getItems();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Menu Edit List"),
        actions: [
          IconButton(
              icon: const Icon(CupertinoIcons.add),
              onPressed: () async {
                //MenuCreateScreen
                await Get.to(MenuCreateScreen({}));
                setState(() {});
              }),
          const SizedBox(
            width: 15,
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: myInit,
        backgroundColor: Colors.white,
        child: menuItems.isEmpty
            ? emptyListWidget("No Item", () {
                myInit();
              })
            : true
                ? ReorderableListView(
                    onReorder: (int oldIndex, int newIndex) async {
                      if (oldIndex < newIndex) {
                        newIndex -= 1;
                      }
                      final MenuModel oldItem = menuItems[oldIndex];
                      final MenuModel newItem = menuItems.removeAt(oldIndex);
                      oldItem.menu_order = newIndex;
                      newItem.menu_order = oldIndex;
                      await oldItem.save();
                      await newItem.save();
                      Utils.toast("New Index: $newIndex");
                      setState(() {});
                      myInit();
                    },
                    scrollDirection: Axis.vertical,
                    children: List.generate(
                      menuItems.length,
                      (index) {
                        MenuModel item = menuItems[index];
                        return ListTile(
                          key: Key('$index'),
                          title: Text("${item.menu_order}. ${item.title}"),
                          subtitle: Text(item.subTitle),
                          leading: Image(
                            image: AssetImage(Utils.icon(item.img)),
                            width: 40,
                            height: 40,
                          ),
                          trailing: Column(
                            children: [
                              InkWell(
                                child: const Icon(
                                  Icons.edit,
                                  color: Colors.blue,
                                ),
                                onTap: () async {
                                  await Get.to(MenuCreateScreen({
                                    'item': item,
                                  }));
                                  setState(() {});
                                },
                              ),
                              InkWell(
                                child: const Icon(Icons.delete),
                                onTap: () {
                                  Get.defaultDialog(
                                    title: "Delete",
                                    middleText:
                                        "Are you sure you want to delete?",
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Get.back();
                                        },
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          await item.delete();
                                          Get.back();
                                          Utils.toast("Deleted");
                                          setState(() {});
                                        },
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  )
                : ListView.builder(
                    itemCount: menuItems.length,
                    itemBuilder: (context, index) {
                      MenuModel item = menuItems[index];
                      return ListTile(
                        title: Text(item.title),
                        subtitle: Text(item.subTitle),
                        leading:
                            const Icon(CupertinoIcons.square_favorites_alt),
                        trailing: const Icon(CupertinoIcons.arrow_right),
                      );
                    },
                  ),
      ),
    );
  }
}
