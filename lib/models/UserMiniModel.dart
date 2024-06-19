import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class UserMiniModel {
  static String table_name = "users_mini_2";
  static String end_point = "users-mini";
  int id = 0;
  String name = "";
  String avatar = "";
  String user_type = "";
  String phone_number = "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
      'user_type': user_type,
      'phone_number': phone_number,
    };
  }

  static UserMiniModel fromJson(dynamic m) {
    UserMiniModel obj = UserMiniModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.name = Utils.to_str(m['name'], '');
    obj.avatar = Utils.to_str(m['avatar'], '');
    obj.user_type = Utils.to_str(m['user_type'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');

    return obj;
  }

  String s(dynamic m) {
    return Utils.to_str(m, '');
  }

  static deleteAllItems() async {}

  static Future<UserMiniModel> getItemById(String id) async {
    UserMiniModel item = UserMiniModel();
    try {
      List<UserMiniModel> items =
          await UserMiniModel.getItems(where: "id = $id");
      if (items.isNotEmpty) {
        item = items.first;
      }
    } catch (E) {
      item = UserMiniModel();
    }
    return item;
  }

  static Future<List<UserMiniModel>> getItems({String where = '1'}) async {
    List<UserMiniModel> items = await UserMiniModel.getLocalData(where);

    if (items.isEmpty) {
      await UserMiniModel.getOnlineData();
      items = await UserMiniModel.getLocalData(where);
    } else {
      UserMiniModel.getOnlineData();
    }

    return items;
  }

  static Future<void> getOnlineData() async {
    if (!(await Utils.is_connected())) {
      return;
    }

    RespondModel resp =
        RespondModel(await Utils.http_get(UserMiniModel.end_point, {}));

    if (resp.code != 1) {
      return;
    }

    if (!resp.data.runtimeType.toString().contains('List')) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await db.transaction((txn) async {
      for (dynamic d in resp.data) {
        UserMiniModel _u = UserMiniModel.fromJson(d);
        try {
          await txn.insert(
            UserMiniModel.table_name,
            _u.toJson(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } catch (e) {
          Utils.toast("Failed to save student because ${e.toString()}");
        }
      }
    });

    return;
  }

  static Future<List<UserMiniModel>> getLocalData(String where) async {
    List<UserMiniModel> data = [];
    if (!(await UserMiniModel.initTable())) {
      Utils.toast("Failed to init students store.");
      return data;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(UserMiniModel.table_name, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(UserMiniModel.fromJson(maps[i]));
    });
    return data;
  }

  Future<bool> save() async {
    bool isSuccess = false;
    if (!(await initTable())) {
      return false;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    try {
      await db.insert(
        UserMiniModel.table_name,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      isSuccess = true;
    } catch (e) {
      Utils.toast("Failed because ${e.toString()}");
      isSuccess = false;
    }

    return isSuccess;
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    //await db.execute('DROP TABLE ${UserMiniModel.table_name}');
    String sql = "CREATE TABLE IF NOT EXISTS ${UserMiniModel.table_name} ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT, "
        "avatar TEXT, "
        "phone_number TEXT, "
        "user_type TEXT)";

    try {
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');
      return false;
    }
/*    int balance = 0;
    int account_id = 0;*/
    return true;
  }
}
