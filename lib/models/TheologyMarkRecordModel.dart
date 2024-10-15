import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TheologyMarkRecordModel {
  static String end_point = "theology-mark-records";
  static String tableName = "theology_mark_records";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String theology_termly_report_card_id = "";
  String theology_termly_report_card_text = "";
  String term_id = "";
  String term_text = "";
  String administrator_id = "";
  String administrator_text = "";
  String theology_class_id = "";
  String theology_class_text = "";
  String theology_stream_id = "";
  String theology_stream_text = "";
  String theology_subject_id = "";
  String theology_subject_text = "";
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
    TheologyMarkRecordModel obj = new TheologyMarkRecordModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.theology_termly_report_card_id =
        Utils.to_str(m['theology_termly_report_card_id'], '');
    obj.theology_termly_report_card_text =
        Utils.to_str(m['theology_termly_report_card_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');
    obj.theology_class_id = Utils.to_str(m['theology_class_id'], '');
    obj.theology_class_text = Utils.to_str(m['theology_class_text'], '');
    obj.theology_stream_id = Utils.to_str(m['theology_stream_id'], '');
    obj.theology_stream_text = Utils.to_str(m['theology_stream_text'], '');
    obj.theology_subject_id = Utils.to_str(m['theology_subject_id'], '');
    obj.theology_subject_text = Utils.to_str(m['theology_subject_text'], '');
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

  static Future<List<TheologyMarkRecordModel>> getLocalData(
      {String where = "1"}) async {
    List<TheologyMarkRecordModel> data = [];
    if (!(await TheologyMarkRecordModel.initTable())) {
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
      data.add(TheologyMarkRecordModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TheologyMarkRecordModel>> get_items(
      {String where = '1'}) async {
    List<TheologyMarkRecordModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TheologyMarkRecordModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TheologyMarkRecordModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<TheologyMarkRecordModel>> getOnlineItems() async {
    List<TheologyMarkRecordModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(TheologyMarkRecordModel.end_point, {}));

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
        await TheologyMarkRecordModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TheologyMarkRecordModel sub = TheologyMarkRecordModel.fromJson(x);
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
      'theology_termly_report_card_id': theology_termly_report_card_id,
      'theology_termly_report_card_text': theology_termly_report_card_text,
      'term_id': term_id,
      'term_text': term_text,
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'theology_class_id': theology_class_id,
      'theology_class_text': theology_class_text,
      'theology_stream_id': theology_stream_id,
      'theology_stream_text': theology_stream_text,
      'theology_subject_id': theology_subject_id,
      'theology_subject_text': theology_subject_text,
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
        ",theology_termly_report_card_id TEXT"
        ",theology_termly_report_card_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",administrator_id TEXT"
        ",administrator_text TEXT"
        ",theology_class_id TEXT"
        ",theology_class_text TEXT"
        ",theology_stream_id TEXT"
        ",theology_stream_text TEXT"
        ",theology_subject_id TEXT"
        ",theology_subject_text TEXT"
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
    if (!(await TheologyMarkRecordModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TheologyMarkRecordModel.tableName);
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
