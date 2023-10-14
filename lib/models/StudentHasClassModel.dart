import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class StudentHasClassModel {
  static String end_point = "student-has-class";
  static String tableName = "student_has_classes";
  int id = 0;
  String enterprise_id = "";
  String academic_class_id = "";
  String administrator_id = "";
  String administrator_text = "";
  String academic_class_text = "";
  String stream_id = "";
  String stream_text = "";
  String administrator_photo = "";




  static fromJson(dynamic m) {
    StudentHasClassModel obj = new StudentHasClassModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.administrator_photo = Utils.to_str(m['administrator_photo'], '');
    obj.academic_class_id = Utils.to_str(m['academic_class_id'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');
    obj.academic_class_text = Utils.to_str(m['academic_class_text'], '');
    obj.stream_id = Utils.to_str(m['stream_id'], '');
    obj.stream_text = Utils.to_str(m['stream_text'], '');

    return obj;
  }

  static Future<List<StudentHasClassModel>> getLocalData(
      {String where = "1"}) async {
    List<StudentHasClassModel> data = [];
    if (!(await StudentHasClassModel.initTable())) {
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
      data.add(StudentHasClassModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<StudentHasClassModel>> get_items(
      {String where = '1'}) async {
    List<StudentHasClassModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await StudentHasClassModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      StudentHasClassModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<StudentHasClassModel>> getOnlineItems() async {
    List<StudentHasClassModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${StudentHasClassModel.end_point}', {}));

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
        await StudentHasClassModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          StudentHasClassModel sub = StudentHasClassModel.fromJson(x);
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
      'enterprise_id': enterprise_id,
      'academic_class_id': academic_class_id,
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'stream_id': stream_id,
      'stream_text': stream_text,
      'academic_class_text': academic_class_text,
      'administrator_photo': administrator_photo,
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
        ",enterprise_id TEXT"
        ",academic_class_id TEXT"
        ",administrator_id TEXT"
        ",administrator_text TEXT"
        ",academic_class_text TEXT"
        ",administrator_photo TEXT"
        ",stream_id TEXT"
        ",stream_text TEXT"
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
    if (!(await StudentHasClassModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(StudentHasClassModel.tableName);
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
