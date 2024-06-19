import 'dart:async';

import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class SchemeWorkItemModel {
  static String end_point = "schemework-items";
  static String tableName = "scheme_work_items";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String term_id = "";
  String term_text = "";
  String subject_id = "";
  String subject_text = "";
  String teacher_id = "";
  String teacher_text = "";
  String supervisor_id = "";
  String supervisor_text = "";
  String teacher_status = "";
  String teacher_comment = "";
  String supervisor_status = "";
  String supervisor_comment = "";
  String status = "";
  String week = "";
  String period = "";
  String topic = "";
  String competence = "";
  String methods = "";
  String skills = "";
  String suggested_activity = "";
  String instructional_material = "";
  String references_1 = "";
  String references = "";

  List<SchemeWorkItemModel> schemeWorkItemsForSameClass = [];

  Future<List<SchemeWorkItemModel>>
      get_scheme_work_items_for_same_class() async {
    schemeWorkItemsForSameClass = await SchemeWorkItemModel.get_items(
        where:
            "enterprise_id = '$enterprise_id' AND term_id = '$term_id' AND subject_id = '$subject_id'");
    return schemeWorkItemsForSameClass;
  }

  static fromJson(dynamic m) {
    SchemeWorkItemModel obj = new SchemeWorkItemModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.subject_id = Utils.to_str(m['subject_id'], '');
    obj.subject_text = Utils.to_str(m['subject_text'], '');
    obj.teacher_id = Utils.to_str(m['teacher_id'], '');
    obj.teacher_text = Utils.to_str(m['teacher_text'], '');
    obj.supervisor_id = Utils.to_str(m['supervisor_id'], '');
    obj.supervisor_text = Utils.to_str(m['supervisor_text'], '');
    obj.teacher_status = Utils.to_str(m['teacher_status'], '');
    obj.teacher_comment = Utils.to_str(m['teacher_comment'], '');
    obj.supervisor_status = Utils.to_str(m['supervisor_status'], '');
    obj.supervisor_comment = Utils.to_str(m['supervisor_comment'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.week = Utils.to_str(m['week'], '');
    obj.period = Utils.to_str(m['period'], '');
    obj.topic = Utils.to_str(m['topic'], '');
    obj.competence = Utils.to_str(m['competence'], '');
    obj.methods = Utils.to_str(m['methods'], '');
    obj.skills = Utils.to_str(m['skills'], '');
    obj.suggested_activity = Utils.to_str(m['suggested_activity'], '');
    obj.instructional_material = Utils.to_str(m['instructional_material'], '');
    obj.references_1 = Utils.to_str(m['references'], '');

    if (obj.references_1.length < 2) {
      obj.references_1 = Utils.to_str(m['references_1'], '');
    }

    obj.references = obj.references;

    if (obj.references_1.length < 3) {
      obj.references_1 = obj.references;
    } else {
      obj.references = obj.references_1;
    }

    return obj;
  }

  static Future<List<SchemeWorkItemModel>> getLocalData(
      {String where = "1"}) async {
    List<SchemeWorkItemModel> data = [];
    if (!(await SchemeWorkItemModel.initTable())) {
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
      data.add(SchemeWorkItemModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<SchemeWorkItemModel>> get_items(
      {String where = '1'}) async {
    List<SchemeWorkItemModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await SchemeWorkItemModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      SchemeWorkItemModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<SchemeWorkItemModel>> getOnlineItems() async {
    List<SchemeWorkItemModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${SchemeWorkItemModel.end_point}', {}));

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
        await SchemeWorkItemModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          SchemeWorkItemModel sub = SchemeWorkItemModel.fromJson(x);
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
    if (references_1.length < 3) {
      references_1 = references;
    } else {
      references = references_1;
    }
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'enterprise_id': enterprise_id,
      'enterprise_text': enterprise_text,
      'term_id': term_id,
      'term_text': term_text,
      'subject_id': subject_id,
      'subject_text': subject_text,
      'teacher_id': teacher_id,
      'teacher_text': teacher_text,
      'supervisor_id': supervisor_id,
      'supervisor_text': supervisor_text,
      'teacher_status': teacher_status,
      'teacher_comment': teacher_comment,
      'supervisor_status': supervisor_status,
      'supervisor_comment': supervisor_comment,
      'status': status,
      'week': week,
      'period': period,
      'topic': topic,
      'competence': competence,
      'methods': methods,
      'skills': skills,
      'suggested_activity': suggested_activity,
      'instructional_material': instructional_material,
      'references_1': references_1,
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
        ",term_id TEXT"
        ",term_text TEXT"
        ",subject_id TEXT"
        ",subject_text TEXT"
        ",teacher_id TEXT"
        ",teacher_text TEXT"
        ",supervisor_id TEXT"
        ",supervisor_text TEXT"
        ",teacher_status TEXT"
        ",teacher_comment TEXT"
        ",supervisor_status TEXT"
        ",supervisor_comment TEXT"
        ",status TEXT"
        ",week TEXT"
        ",period TEXT"
        ",topic TEXT"
        ",competence TEXT"
        ",methods TEXT"
        ",skills TEXT"
        ",suggested_activity TEXT"
        ",instructional_material TEXT"
        ",references_1 TEXT"
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
    if (!(await SchemeWorkItemModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(SchemeWorkItemModel.tableName);
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
