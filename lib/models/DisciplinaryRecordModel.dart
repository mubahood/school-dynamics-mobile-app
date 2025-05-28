import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class DisciplinaryRecordModel {
  static String end_point = "disciplinary-records";
  static String tableName = "disciplinary_records";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String administrator_id = "";
  String administrator_text = "";
  String avatar = "";
  String reported_by_id = "";
  String reported_by_text = "";
  String academic_year_id = "";
  String academic_year_text = "";
  String term_id = "";
  String term_text = "";
  String type = "";
  String title = "";
  String status = "";
  String description = "";
  String action_taken = "";
  String hm_comment = "";
  String parent_comment = "";
  String teacher_comment = "";
  String student_comment = "";
  String photo = "";
  String file = "";

  static fromJson(dynamic m) {
    DisciplinaryRecordModel obj = DisciplinaryRecordModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');
    obj.reported_by_id = Utils.to_str(m['reported_by_id'], '');
    obj.reported_by_text = Utils.to_str(m['reported_by_text'], '');
    obj.academic_year_id = Utils.to_str(m['academic_year_id'], '');
    obj.academic_year_text = Utils.to_str(m['academic_year_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.title = Utils.to_str(m['title'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.action_taken = Utils.to_str(m['action_taken'], '');
    obj.hm_comment = Utils.to_str(m['hm_comment'], '');
    obj.parent_comment = Utils.to_str(m['parent_comment'], '');
    obj.teacher_comment = Utils.to_str(m['teacher_comment'], '');
    obj.student_comment = Utils.to_str(m['student_comment'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.file = Utils.to_str(m['file'], '');
    obj.avatar = Utils.to_str(m['avatar'], '');

    return obj;
  }

  static Future<List<DisciplinaryRecordModel>> getLocalData(
      {String where = "1"}) async {
    List<DisciplinaryRecordModel> data = [];
    if (!(await DisciplinaryRecordModel.initTable())) {
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
      data.add(DisciplinaryRecordModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<DisciplinaryRecordModel>> get_items(
      {String where = '1'}) async {
    List<DisciplinaryRecordModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await DisciplinaryRecordModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      DisciplinaryRecordModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<DisciplinaryRecordModel>> getOnlineItems() async {
    List<DisciplinaryRecordModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(DisciplinaryRecordModel.end_point, {}));

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
        await DisciplinaryRecordModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          DisciplinaryRecordModel sub = DisciplinaryRecordModel.fromJson(x);
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
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'reported_by_id': reported_by_id,
      'reported_by_text': reported_by_text,
      'academic_year_id': academic_year_id,
      'academic_year_text': academic_year_text,
      'term_id': term_id,
      'term_text': term_text,
      'type': type,
      'title': title,
      'status': status,
      'description': description,
      'action_taken': action_taken,
      'hm_comment': hm_comment,
      'parent_comment': parent_comment,
      'teacher_comment': teacher_comment,
      'student_comment': student_comment,
      'photo': photo,
      'file': file,
      'avatar': avatar,
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
        ",administrator_id TEXT"
        ",administrator_text TEXT"
        ",reported_by_id TEXT"
        ",reported_by_text TEXT"
        ",academic_year_id TEXT"
        ",academic_year_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",type TEXT"
        ",title TEXT"
        ",status TEXT"
        ",description TEXT"
        ",action_taken TEXT"
        ",hm_comment TEXT"
        ",parent_comment TEXT"
        ",teacher_comment TEXT"
        ",student_comment TEXT"
        ",photo TEXT"
        ",file TEXT"
        ",avatar TEXT"
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
    if (!(await DisciplinaryRecordModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(DisciplinaryRecordModel.tableName);
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

  bool p() {
    return type.toLowerCase() == "good";
  }

  String getDisplayText() {
    return title;
  }
}
