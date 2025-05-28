import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TheologyClassModel {
  static String end_point = "theology-classes";
  static String tableName = "theology_classes";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String academic_year_id = "";
  String academic_year_text = "";
  String class_teahcer_id = "";
  String class_teahcer_text = "";
  String name = "";
  String short_name = "";
  String details = "";
  String students_count = "";

  static fromJson(dynamic m) {
    TheologyClassModel obj = TheologyClassModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.academic_year_id = Utils.to_str(m['academic_year_id'], '');
    obj.academic_year_text = Utils.to_str(m['academic_year_text'], '');
    obj.class_teahcer_id = Utils.to_str(m['class_teahcer_id'], '');
    obj.class_teahcer_text = Utils.to_str(m['class_teahcer_text'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.short_name = Utils.to_str(m['short_name'], '');
    obj.students_count = Utils.to_str(m['students_count'], '');
    obj.details = Utils.to_str(m['details'], '');

    return obj;
  }

  static Future<List<TheologyClassModel>> getLocalData(
      {String where = "1"}) async {
    List<TheologyClassModel> data = [];
    if (!(await TheologyClassModel.initTable())) {
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
      data.add(TheologyClassModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TheologyClassModel>> get_items(
      {String where = '1'}) async {
    List<TheologyClassModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TheologyClassModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TheologyClassModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<TheologyClassModel>> getOnlineItems() async {
    List<TheologyClassModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(TheologyClassModel.end_point, {}));

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
        await TheologyClassModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TheologyClassModel sub = TheologyClassModel.fromJson(x);
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
      'enterprise_id': enterprise_id,
      'enterprise_text': enterprise_text,
      'academic_year_id': academic_year_id,
      'academic_year_text': academic_year_text,
      'class_teahcer_id': class_teahcer_id,
      'class_teahcer_text': class_teahcer_text,
      'name': name,
      'students_count': students_count,
      'short_name': short_name,
      'details': details,
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
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",academic_year_id TEXT"
        ",academic_year_text TEXT"
        ",class_teahcer_id TEXT"
        ",class_teahcer_text TEXT"
        ",students_count TEXT"
        ",name TEXT"
        ",short_name TEXT"
        ",details TEXT"
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
    if (!(await TheologyClassModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TheologyClassModel.tableName);
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
