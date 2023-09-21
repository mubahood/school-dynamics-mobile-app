import 'package:schooldynamics/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import 'RespondModel.dart';
import 'UserModel.dart';

class StudentVerificationModel {
  static String endPoint = "student-verification";
  static String tableName = "StudentVerificationModels";

  int id = 0;
  String name = "";
  String avatar = "";
  String sex = "";
  String status = "";
  String current_class_id = "";
  String student_has_class_id = "";
  String stream_id = "";
  String current_class_text = "";
  String current_stream_text = "";

  List<UserModel> students = [];

  Future<List<UserModel>> getStudents() async {
    students = await UserModel.getItems(where : " current_class_id = '${id}' ");
    return students;
  }

  static StudentVerificationModel fromJson(dynamic d) {
    StudentVerificationModel obj = new StudentVerificationModel();
    if (d == null) {
      return obj;
    }
    obj.id = Utils.int_parse(d['id']);
    obj.name = Utils.to_str(d['name'], '');
    obj.avatar = Utils.to_str(d['avatar'], '');
    obj.sex = Utils.to_str(d['sex'], '');
    obj.status = Utils.to_str(d['status'], '');
    obj.current_class_id = Utils.to_str(d['current_class_id'], '');
    obj.student_has_class_id = Utils.to_str(d['student_has_class_id'], '');
    obj.stream_id = Utils.to_str(d['stream_id'], '');
    obj.current_class_text = Utils.to_str(d['current_class_text'], '');
    obj.current_stream_text = Utils.to_str(d['current_stream_text'], '');
    return obj;
  }

  static Future<List<StudentVerificationModel>> getItems(
      {String where = '1'}) async {
    List<StudentVerificationModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await StudentVerificationModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      StudentVerificationModel.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<StudentVerificationModel>> getLocalData(
      {String where = "1"}) async {
    List<StudentVerificationModel> data = [];
    if (!(await StudentVerificationModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(StudentVerificationModel.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(StudentVerificationModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<StudentVerificationModel>> getOnlineItems() async {
    List<StudentVerificationModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${StudentVerificationModel.endPoint}', {}));

    print(resp.message);
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
        await StudentVerificationModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          StudentVerificationModel sub = StudentVerificationModel.fromJson(x);
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
          print("faied to save to commit BRECASE ==> ${e.toString()}");
        }
      });
    }

    return [];

    return data;
  }

  get_current_stream_text() async {

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
      'name': name,
      'avatar': avatar,
      'sex': sex,
      'status': status,
      'current_class_id': current_class_id,
      'student_has_class_id': student_has_class_id,
      'stream_id': stream_id,
      'current_class_text': current_class_text,
      'current_stream_text': current_stream_text,
    };
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql1 = " CREATE TABLE IF NOT EXISTS "
        "${tableName} ("
        "id INTEGER PRIMARY KEY,"
        "name TEXT,"
        "avatar TEXT,"
        "sex TEXT,"
        "status TEXT,"
        "current_class_id TEXT,"
        "student_has_class_id TEXT,"
        "stream_id TEXT,"
        "current_stream_text TEXT,"
        "current_class_text TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE $tableName");

      await db.execute(sql1);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await StudentVerificationModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
