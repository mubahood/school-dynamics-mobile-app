import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TheologySubjectModel {
  static String end_point = "theology-subjects";
  static String tableName = "theology_subjects";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String theology_class_id = "";
  String theology_class_text = "";
  String subject_teacher = "";
  String teacher_1 = "";
  String teacher_2 = "";
  String teacher_3 = "";
  String code = "";
  String details = "";
  String theology_course_id = "";
  String theology_course_text = "";
  String name = "";

  static fromJson(dynamic m) {
    TheologySubjectModel obj = TheologySubjectModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.theology_class_id = Utils.to_str(m['theology_class_id'], '');
    obj.theology_class_text = Utils.to_str(m['theology_class_text'], '');
    obj.subject_teacher = Utils.to_str(m['subject_teacher'], '');
    obj.teacher_1 = Utils.to_str(m['teacher_1'], '');
    obj.teacher_2 = Utils.to_str(m['teacher_2'], '');
    obj.teacher_3 = Utils.to_str(m['teacher_3'], '');
    obj.code = Utils.to_str(m['code'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.theology_course_id = Utils.to_str(m['theology_course_id'], '');
    obj.theology_course_text = Utils.to_str(m['theology_course_text'], '');
    obj.name = Utils.to_str(m['name'], '');

    return obj;
  }

  static Future<List<TheologySubjectModel>> getLocalData(
      {String where = "1"}) async {
    List<TheologySubjectModel> data = [];
    if (!(await TheologySubjectModel.initTable())) {
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
      data.add(TheologySubjectModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TheologySubjectModel>> get_items(
      {String where = '1'}) async {
    List<TheologySubjectModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TheologySubjectModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TheologySubjectModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<TheologySubjectModel>> getOnlineItems() async {
    List<TheologySubjectModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(TheologySubjectModel.end_point, {}));


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
        await TheologySubjectModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TheologySubjectModel sub = TheologySubjectModel.fromJson(x);
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
      'theology_class_id': theology_class_id,
      'theology_class_text': theology_class_text,
      'subject_teacher': subject_teacher,
      'teacher_1': teacher_1,
      'teacher_2': teacher_2,
      'teacher_3': teacher_3,
      'code': code,
      'details': details,
      'theology_course_id': theology_course_id,
      'theology_course_text': theology_course_text,
      'name': name,
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
        ",theology_class_id TEXT"
        ",theology_class_text TEXT"
        ",subject_teacher TEXT"
        ",teacher_1 TEXT"
        ",teacher_2 TEXT"
        ",teacher_3 TEXT"
        ",code TEXT"
        ",details TEXT"
        ",theology_course_id TEXT"
        ",theology_course_text TEXT"
        ",name TEXT"
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
    if (!(await TheologySubjectModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TheologySubjectModel.tableName);
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
