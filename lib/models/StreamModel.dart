import 'package:schooldynamics/models/MarksModel.dart';
import 'package:schooldynamics/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import 'RespondModel.dart';

class StreamModel {
  static String endPoint = "class-streams";
  static String tableName = "class_streams";

  int id = 0;
  String academic_class_id = "";
  String name = "";
  String section = "";

  static StreamModel fromJson(dynamic m) {
    StreamModel obj = new StreamModel();
    if (m == null) {
      return obj;
    }
    obj.id = Utils.int_parse(m['id']);
    obj.academic_class_id = Utils.to_str(m['academic_class_id'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.section = Utils.to_str(m['section'], '');

    return obj;
  }

  static Future<List<StreamModel>> getItems({String where = '1'}) async {
    List<StreamModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await StreamModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      StreamModel.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<StreamModel>> getLocalData({String where = "1"}) async {
    List<StreamModel> data = [];
    if (!(await StreamModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(StreamModel.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(StreamModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<StreamModel>> getOnlineItems() async {
    List<StreamModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${StreamModel.endPoint}', {}));

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
        await StreamModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          StreamModel sub = StreamModel.fromJson(x);
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
      'academic_class_id': academic_class_id,
      'name': name,
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
        "academic_class_id TEXT,"
        "section TEXT,"
        "name TEXT"
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
    if (!(await StreamModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
