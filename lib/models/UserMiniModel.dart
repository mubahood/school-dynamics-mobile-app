import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class UserMiniModel {
  static String end_point = "users-mini";
  static String table_name_6 = "users_mini_6";
  int id = 0;
  String name = "";
  String avatar = "";
  String user_type = "";
  String phone_number = "";
  String class_name = "";
  String class_id = "";
  String services = "";
  String user_number = "";
  String stream_id = "";
  String theology_stream_id = "";

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'avatar': avatar,
      'name': name,
      'user_type': user_type,
      'phone_number': phone_number,
      'class_name': class_name,
      'class_id': class_id,
      'services': services,
      'user_number': user_number,
      'stream_id': stream_id,
      'theology_stream_id': theology_stream_id,
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
    obj.class_name = Utils.to_str(m['class_name'], '');
    obj.class_id = Utils.to_str(m['class_id'], '');
    obj.class_id = Utils.to_str(m['class_id'], '');
    obj.user_number = Utils.to_str(m['user_number'], '');
    obj.stream_id = Utils.to_str(m['stream_id'], '');
    obj.theology_stream_id = Utils.to_str(m['theology_stream_id'], '');

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
            UserMiniModel.table_name_6,
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

    List<Map> maps = await db.query(UserMiniModel.table_name_6, where: where);

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
        UserMiniModel.table_name_6,
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

    String sql = "CREATE TABLE IF NOT EXISTS ${UserMiniModel.table_name_6} ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT, "
        "avatar TEXT, "
        "phone_number TEXT, "
        "class_name TEXT, "
        "class_id TEXT, "
        "services TEXT, "
        "user_number TEXT, "
        "stream_id TEXT, "
        "theology_stream_id TEXT,"
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
