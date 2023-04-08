import 'package:schooldynamics/models/MarksModel.dart';
import 'package:schooldynamics/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import 'RespondModel.dart';

class ExamModel {
  static String endPoint = "exams";
  static String tableName = "exams";

  int id = 0;
  String term_id = "";
  String type = "";
  String name = "";
  String max_mark = "";
  String marks_generated = "";
  String can_submit_marks = "";
  String term_name = "";

  static ExamModel fromJson(dynamic m) {
    ExamModel obj = new ExamModel();
    if (m == null) {
      return obj;
    }
    obj.id = Utils.int_parse(m['id']);
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.max_mark = Utils.to_str(m['max_mark'], '');
    obj.marks_generated = Utils.to_str(m['marks_generated'], '');
    obj.can_submit_marks = Utils.to_str(m['can_submit_marks'], '');
    obj.term_name = Utils.to_str(m['term_name'], '');
    return obj;
  }

  static Future<List<ExamModel>> getItems({String where = '1',bool forceWait  = true}) async {
    List<ExamModel> data = await getLocalData(where: where);
    if (data.isEmpty && forceWait) {
      await ExamModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      ExamModel.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<ExamModel>> getLocalData({String where: "1"}) async {
    List<ExamModel> data = [];

    if (!(await ExamModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(ExamModel.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(ExamModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ExamModel>> getOnlineItems() async {
    List<ExamModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${ExamModel.endPoint}', {}));

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
        await ExamModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ExamModel sub = ExamModel.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {}
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {}
      });

      MarksModel.initTable();
      for (var x in resp.data) {
        if (x['items'] != null) {
          await MarksModel.initTable();

          await db.transaction((txn) async {
            var batch = txn.batch();

            for (var mark in x['items']) {
              MarksModel myMark = MarksModel.fromJson(mark);
              if (myMark.id > 0) {
                try {
                  batch.insert(MarksModel.tableName, myMark.toJson(),
                      conflictAlgorithm: ConflictAlgorithm.replace);
                } catch (e) {}
              }
            }

            try {
              await batch.commit(continueOnError: true);
            } catch (e) {}
          });
        }
      }
    }

    return [];

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
      'term_id': term_id,
      'type': type,
      'name': name,
      'max_mark': max_mark,
      'marks_generated': marks_generated,
      'can_submit_marks': can_submit_marks,
      'term_name': term_name,
    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "${tableName} ("
        "id INTEGER PRIMARY KEY,"
        "term_id TEXT,"
        "type TEXT,"
        "name TEXT,"
        "max_mark TEXT,"
        "marks_generated TEXT,"
        "can_submit_marks TEXT,"
        "term_name TEXT"
        ")";

    try {
      //await db.delete(tableName);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await ExamModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
