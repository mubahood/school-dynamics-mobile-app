import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class StreamModel {

  static String end_point = "class-streams";
  static String tableName = "academic_class_sctreams";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String academic_class_id = "";
  String academic_class_text = "";
  String name = "";
  String teacher_id = "";
  String teacher_text = "";


  static fromJson(dynamic m) {
    StreamModel obj = new StreamModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'],'');
    obj.updated_at = Utils.to_str(m['updated_at'],'');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'],'');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'],'');
    obj.academic_class_id = Utils.to_str(m['academic_class_id'],'');
    obj.academic_class_text = Utils.to_str(m['academic_class_text'],'');
    obj.name = Utils.to_str(m['name'],'');
    obj.teacher_id = Utils.to_str(m['teacher_id'],'');
    obj.teacher_text = Utils.to_str(m['teacher_text'],'');

    return obj;
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


    List<Map> maps = await db.query(tableName, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(StreamModel.fromJson(maps[i]));
    });

    return data;

  }


  static Future<List<StreamModel>> get_items({String where = '1'}) async {
    List<StreamModel> data = await getLocalData(where: where);
    if (data.isEmpty ) {
      await StreamModel.getOnlineItems();
      data = await getLocalData(where: where);
    }else{
      StreamModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<StreamModel>> getOnlineItems() async {
    List<StreamModel> data = [];

    RespondModel resp =
    RespondModel(await Utils.http_get('${StreamModel.end_point}', {}));

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
      'id' : id,
      'created_at' : created_at,
      'updated_at' : updated_at,
      'enterprise_id' : enterprise_id,
      'enterprise_text' : enterprise_text,
      'academic_class_id' : academic_class_id,
      'academic_class_text' : academic_class_text,
      'name' : name,
      'teacher_id' : teacher_id,
      'teacher_text' : teacher_text,

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
        ",academic_class_id TEXT"
        ",academic_class_text TEXT"
        ",name TEXT"
        ",teacher_id TEXT"
        ",teacher_text TEXT"

        ")";

    try {
      //await db.execute("DROP TABLE ${tableName}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e . toString()}');

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
    await db.delete(StreamModel.tableName);
  }





  delete() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(
          tableName,
          where: 'id = $id'
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }


}