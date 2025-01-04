import 'package:schooldynamics/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

class MenuModel {
  static String tableName = "local_menus";

  int id = 0;
  int menu_order = 0;
  String title = "";
  String subTitle = "";
  String img = "";
  String fav = "No";
  String is_main = "No";
  int parent_id = 0;

  MenuModel({
    required this.id,
    required this.menu_order,
    required this.title,
    required this.subTitle,
    required this.img,
    required this.fav,
    required this.is_main,
    required this.parent_id,
  });

  static MenuModel fromJson(dynamic m) {
    MenuModel obj = MenuModel(
      id: 0,
      menu_order: 0,
      title: '',
      subTitle: '',
      img: '',
      fav: '',
      is_main: '',
      parent_id: 0,
    );

    if (m == null) {
      return obj;
    }
    obj.id = Utils.int_parse(m['id']);
    obj.menu_order = Utils.int_parse(m['menu_order']);
    obj.title = Utils.to_str(m['title'], '');
    obj.subTitle = Utils.to_str(m['subTitle'], '');
    obj.img = Utils.to_str(m['img'], '');
    obj.fav = Utils.to_str(m['fav'], '');
    obj.is_main = Utils.to_str(m['is_main'], '');
    obj.parent_id = Utils.int_parse(m['parent_id']);
    return obj;
  }

  static Future<List<MenuModel>> getItems(
      {String where = '1', bool forceWait = true}) async {
    List<MenuModel> data = await getLocalData(where: where);
    if (data.isEmpty && forceWait) {
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
    }
    data.sort((b, a) => b.menu_order.compareTo(a.menu_order));
    return data;
  }

  static Future<List<MenuModel>> getLocalData({String where = "1"}) async {
    List<MenuModel> data = [];

    if (!(await MenuModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(MenuModel.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(MenuModel.fromJson(maps[i]));
    });

    return data;
  }

  save() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.insert(
        tableName,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    Map<String, dynamic> map = {
      'menu_order': menu_order,
      'title': title,
      'subTitle': subTitle,
      'img': img,
      'fav': fav,
      'is_main': is_main,
      'parent_id': parent_id,
    };
    if (id != 0) {
      map['id'] = id;
    }
    return map;
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "menu_order INTEGER,"
        "title TEXT,"
        "subTitle TEXT,"
        "img TEXT,"
        "fav TEXT,"
        "is_main TEXT,"
        "parent_id INTEGER"
        ")";

    try {
      //await db.delete(tableName);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await MenuModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }

  //delete
  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  //saveByOrder
  saveByOrder(int order) async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    //all items
    List<MenuModel> items = await getItems();
    //sort by order
    items.sort((a, b) => a.menu_order.compareTo(b.menu_order));

    //now update each order and change the order of this item to new order
    List.generate(items.length, (i) {
      if (items[i].menu_order == order) {
        items[i].menu_order = order;
      } else if (items[i].menu_order > order) {
        items[i].menu_order = items[i].menu_order + 1;
      } else if (items[i].menu_order < order) {
        items[i].menu_order = items[i].menu_order - 1;
      } else {
        items[i].menu_order = items[i].menu_order;
      }
      items[i].save();
    });
  }
}
