import 'package:schooldynamics/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';

class MarksModel {
  static String tableName = "MarksModels";

  int id = 0;
  String exam_id = "";
  String class_id = "";
  String subject_id = "";
  String student_id = "";
  String student_name = "";
  String score = "";
  String remarks = "";
  String main_course_id = "";
  String is_submitted = "";


  static MarksModel fromJson(dynamic m) {
    MarksModel obj = new MarksModel();
    if (m == null) {
      return obj;
    }
    obj.id = Utils.int_parse(m['id']);
    obj.exam_id = Utils.to_str(m['exam_id'],'');
    obj.class_id = Utils.to_str(m['class_id'],'');
    obj.subject_id = Utils.to_str(m['subject_id'],'');
    obj.student_id = Utils.to_str(m['student_id'],'');
    obj.student_name = Utils.to_str(m['student_name'],'');
    obj.score = Utils.to_str(m['score'],'');
    obj.remarks = Utils.to_str(m['remarks'],'');
    obj.main_course_id = Utils.to_str(m['main_course_id'],'');
    obj.is_submitted = Utils.to_str(m['is_submitted'],'');
    return obj;
  }

  static Future<List<MarksModel>> getItems({String where = '1'}) async {
    List<MarksModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData( where: where );
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<MarksModel>> getLocalData({String where = "1"}) async {
    List<MarksModel> data = [];
    if (!(await MarksModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }
 

    List<Map> maps = await db.query(MarksModel.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(MarksModel.fromJson(maps[i]));
    });

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
      'exam_id' : exam_id,
      'class_id' : class_id,
      'subject_id' : subject_id,
      'student_id' : student_id,
      'student_name' : student_name,
      'score' : score,
      'remarks' : remarks,
      'main_course_id' : main_course_id,
      'is_submitted' : is_submitted,
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
        "exam_id Text,"
        "class_id Text,"
        "subject_id Text,"
        "student_id Text,"
        "student_name Text,"
        "score Text,"
        "remarks Text,"
        "main_course_id Text,"
        "is_submitted Text"
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
    if (!(await MarksModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
