import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class MarkRecordModel {
  static String end_point = "mark-records";
  static String tableName = "mark_records";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String termly_report_card_id = "";
  String termly_report_card_text = "";
  String term_id = "";
  String term_text = "";
  String administrator_id = "";
  String administrator_text = "";
  String academic_class_id = "";
  String academic_class_text = "";
  String academic_class_sctream_id = "";
  String academic_class_sctream_text = "";
  String main_course_id = "";
  String main_course_text = "";
  String subject_id = "";
  String subject_text = "";
  String bot_score = "";
  String mot_score = "";
  String eot_score = "";
  String bot_is_submitted = "";
  String mot_is_submitted = "";
  String eot_is_submitted = "";
  String bot_missed = "";
  String mot_missed = "";
  String eot_missed = "";
  String initials = "";
  String remarks = "";
  String total_score = "";
  String total_score_display = "";
  String aggr_name = "";
  String aggr_value = "";

  static fromJson(dynamic m) {
    MarkRecordModel obj = new MarkRecordModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.termly_report_card_id = Utils.to_str(m['termly_report_card_id'], '');
    obj.termly_report_card_text =
        Utils.to_str(m['termly_report_card_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');
    obj.academic_class_id = Utils.to_str(m['academic_class_id'], '');
    obj.academic_class_text = Utils.to_str(m['academic_class_text'], '');
    obj.academic_class_sctream_id =
        Utils.to_str(m['academic_class_sctream_id'], '');
    obj.academic_class_sctream_text =
        Utils.to_str(m['academic_class_sctream_text'], '');
    obj.main_course_id = Utils.to_str(m['main_course_id'], '');
    obj.main_course_text = Utils.to_str(m['main_course_text'], '');
    obj.subject_id = Utils.to_str(m['subject_id'], '');
    obj.subject_text = Utils.to_str(m['subject_text'], '');
    obj.bot_score = Utils.to_str(m['bot_score'], '');
    obj.mot_score = Utils.to_str(m['mot_score'], '');
    obj.eot_score = Utils.to_str(m['eot_score'], '');
    obj.bot_is_submitted = Utils.to_str(m['bot_is_submitted'], '');
    obj.mot_is_submitted = Utils.to_str(m['mot_is_submitted'], '');
    obj.eot_is_submitted = Utils.to_str(m['eot_is_submitted'], '');
    obj.bot_missed = Utils.to_str(m['bot_missed'], '');
    obj.mot_missed = Utils.to_str(m['mot_missed'], '');
    obj.eot_missed = Utils.to_str(m['eot_missed'], '');
    obj.initials = Utils.to_str(m['initials'], '');
    obj.remarks = Utils.to_str(m['remarks'], '');
    obj.total_score = Utils.to_str(m['total_score'], '');
    obj.total_score_display = Utils.to_str(m['total_score_display'], '');
    obj.aggr_name = Utils.to_str(m['aggr_name'], '');
    obj.aggr_value = Utils.to_str(m['aggr_value'], '');

    return obj;
  }

  static Future<List<MarkRecordModel>> getLocalData(
      {String where = "1"}) async {
    List<MarkRecordModel> data = [];
    if (!(await MarkRecordModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(tableName, where: where, orderBy: ' administrator_text ASC');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(MarkRecordModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<MarkRecordModel>> get_items({String where = '1'}) async {
    List<MarkRecordModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await MarkRecordModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      MarkRecordModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<MarkRecordModel>> getOnlineItems() async {
    List<MarkRecordModel> data = [];
    RespondModel resp =
        RespondModel(await Utils.http_get(MarkRecordModel.end_point, {}));

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
        await MarkRecordModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          MarkRecordModel sub = MarkRecordModel.fromJson(x);
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
          print("FAILED to save to commit BECAUSE == ${e.toString()}");
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
      'termly_report_card_id': termly_report_card_id,
      'termly_report_card_text': termly_report_card_text,
      'term_id': term_id,
      'term_text': term_text,
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'academic_class_id': academic_class_id,
      'academic_class_text': academic_class_text,
      'academic_class_sctream_id': academic_class_sctream_id,
      'academic_class_sctream_text': academic_class_sctream_text,
      'main_course_id': main_course_id,
      'main_course_text': main_course_text,
      'subject_id': subject_id,
      'subject_text': subject_text,
      'bot_score': bot_score,
      'mot_score': mot_score,
      'eot_score': eot_score,
      'bot_is_submitted': bot_is_submitted,
      'mot_is_submitted': mot_is_submitted,
      'eot_is_submitted': eot_is_submitted,
      'bot_missed': bot_missed,
      'mot_missed': mot_missed,
      'eot_missed': eot_missed,
      'initials': initials,
      'remarks': remarks,
      'total_score': total_score,
      'total_score_display': total_score_display,
      'aggr_name': aggr_name,
      'aggr_value': aggr_value,
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
        ",termly_report_card_id TEXT"
        ",termly_report_card_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",administrator_id TEXT"
        ",administrator_text TEXT"
        ",academic_class_id TEXT"
        ",academic_class_text TEXT"
        ",academic_class_sctream_id TEXT"
        ",academic_class_sctream_text TEXT"
        ",main_course_id TEXT"
        ",main_course_text TEXT"
        ",subject_id TEXT"
        ",subject_text TEXT"
        ",bot_score TEXT"
        ",mot_score TEXT"
        ",eot_score TEXT"
        ",bot_is_submitted TEXT"
        ",mot_is_submitted TEXT"
        ",eot_is_submitted TEXT"
        ",bot_missed TEXT"
        ",mot_missed TEXT"
        ",eot_missed TEXT"
        ",initials TEXT"
        ",remarks TEXT"
        ",total_score TEXT"
        ",total_score_display TEXT"
        ",aggr_name TEXT"
        ",aggr_value TEXT"
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
    if (!(await MarkRecordModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(MarkRecordModel.tableName);
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
