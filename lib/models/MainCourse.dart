import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class MainCourse {
  static String end_point = "main-courses";
  static String tableName = "main_courses";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String name = "";
  String short_name = "";
  String code = "";
  String subject_type = "";
  String parent_course_id = "";
  String parent_course_text = "";
  String paper = "";
  String is_compulsory = "";

  String get_name() {
    return name;
  }
  String get_description() {
    return name;
  }

  static fromJson(dynamic m) {
    MainCourse obj = MainCourse();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.short_name = Utils.to_str(m['short_name'], '');
    obj.code = Utils.to_str(m['code'], '');
    obj.subject_type = Utils.to_str(m['subject_type'], '');
    obj.parent_course_id = Utils.to_str(m['parent_course_id'], '');
    obj.parent_course_text = Utils.to_str(m['parent_course_text'], '');
    obj.paper = Utils.to_str(m['paper'], '');
    obj.is_compulsory = Utils.to_str(m['is_compulsory'], '');

    return obj;
  }

  static Future<List<MainCourse>> getLocalData({String where = "1"}) async {
    List<MainCourse> data = [];
    if (!(await MainCourse.initTable())) {
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
      data.add(MainCourse.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<MainCourse>> get_items({String where = '1'}) async {
    List<MainCourse> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await MainCourse.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      MainCourse.getOnlineItems();
    }
    return data;
  }

  static Future<List<MainCourse>> getOnlineItems() async {
    List<MainCourse> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(MainCourse.end_point, {}));

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
        await MainCourse.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          MainCourse sub = MainCourse.fromJson(x);
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
      'short_name': short_name,
      'code': code,
      'subject_type': subject_type,
      'parent_course_id': parent_course_id,
      'parent_course_text': parent_course_text,
      'paper': paper,
      'is_compulsory': is_compulsory,
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
        ",short_name TEXT"
        ",code TEXT"
        ",subject_type TEXT"
        ",parent_course_id TEXT"
        ",parent_course_text TEXT"
        ",paper TEXT"
        ",is_compulsory TEXT"
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
    if (!(await MainCourse.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(MainCourse.tableName);
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
