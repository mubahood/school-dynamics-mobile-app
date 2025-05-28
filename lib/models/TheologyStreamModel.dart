import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TheologyStreamModel {
  static String end_point = "theology-streams";
  static String tableName = "theology_streams";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String name = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String theology_class_id = "";
  String theology_class_text = "";
  String teacher_id = "";
  String teacher_text = "";

  static fromJson(dynamic m) {
    TheologyStreamModel obj = TheologyStreamModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.theology_class_id = Utils.to_str(m['theology_class_id'], '');
    obj.theology_class_text = Utils.to_str(m['theology_class_text'], '');
    obj.teacher_id = Utils.to_str(m['teacher_id'], '');
    obj.teacher_text = Utils.to_str(m['teacher_text'], '');

    return obj;
  }

  static Future<List<TheologyStreamModel>> getLocalData(
      {String where = "1"}) async {
    List<TheologyStreamModel> data = [];
    if (!(await TheologyStreamModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(TheologyStreamModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TheologyStreamModel>> get_items(
      {String where = '1'}) async {
    List<TheologyStreamModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TheologyStreamModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TheologyStreamModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<TheologyStreamModel>> getOnlineItems() async {
    List<TheologyStreamModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(TheologyStreamModel.end_point, {}));

    if (resp.code != 1) {
      return [];
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return [];
    }

    if (resp.data.runtimeType.toString().contains('List')) {
      if (await Utils.is_connected()) {
        await TheologyStreamModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TheologyStreamModel sub = TheologyStreamModel.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {
            print("faied to save becaus ${e.toString()}");
          }
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {
          print("faied to save to commit BRECASE == ${e.toString()}");
        }
      });
    }

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
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'name': name,
      'enterprise_id': enterprise_id,
      'enterprise_text': enterprise_text,
      'theology_class_id': theology_class_id,
      'theology_class_text': theology_class_text,
      'teacher_id': teacher_id,
      'teacher_text': teacher_text,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",name TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",theology_class_id TEXT"
        ",theology_class_text TEXT"
        ",teacher_id TEXT"
        ",teacher_text TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE ${tableName}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await TheologyStreamModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TheologyStreamModel.tableName);
  }

  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(tableName, where: 'id = $id');
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }
}
