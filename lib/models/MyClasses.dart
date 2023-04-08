import 'package:schooldynamics/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/AppConfig.dart';
import 'RespondModel.dart';
import 'UserModel.dart';

class MyClasses {
  static String endPoint = "my-classes";
  static String tableName = "MyClassess";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String academic_year_id = "";
  String class_teahcer_id = "";
  String class_teacher_name = "";
  String students_count = "";
  String name = "";
  String short_name = "";
  String details = "";
  String compulsory_subjects = "";
  String optional_subjects = "";
  String class_type = "";
  String academic_class_level_id = "";


  List<UserModel> students = [];
  Future<List<UserModel>> getStudents() async {
    students = await UserModel.getItems(where: " current_class_id = '${id}' ");

    return students;
  }

  static MyClasses fromJson(dynamic d) {
    MyClasses obj = new MyClasses();
    if (d == null) {
      return obj;
    }
    obj.id = Utils.int_parse(d['id']);
    obj.created_at = Utils.to_str(d['created_at'], '');
    obj.enterprise_id = Utils.to_str(d['enterprise_id'], '');
    obj.academic_year_id = Utils.to_str(d['academic_year_id'], '');
    obj.class_teahcer_id = Utils.to_str(d['class_teahcer_id'], '');
    obj.name = Utils.to_str(d['name'], '');
    obj.short_name = Utils.to_str(d['short_name'], '');
    obj.details = Utils.to_str(d['details'], '');
    obj.compulsory_subjects = Utils.to_str(d['compulsory_subjects'], '');
    obj.optional_subjects = Utils.to_str(d['optional_subjects'], '');
    obj.class_type = Utils.to_str(d['class_type'], '');
    obj.students_count = Utils.to_str(d['students_count'], '');
    obj.class_teacher_name = Utils.to_str(d['class_teacher_name'], '');
    obj.academic_class_level_id =
        Utils.to_str(d['academic_class_level_id'], '');

    return obj;
  }

  static Future<List<MyClasses>> getItems({String where = '1'}) async {
    List<MyClasses> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await MyClasses.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      data = await getLocalData(where: where);
      MyClasses.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<MyClasses>> getLocalData({String where: "1"}) async {
    List<MyClasses> data = [];
    if (!(await MyClasses.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }


    List<Map> maps = await db.query(MyClasses.tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(MyClasses.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<MyClasses>> getOnlineItems() async {
    List<MyClasses> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${MyClasses.endPoint}', {}));

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
        await MyClasses.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          MyClasses sub = MyClasses.fromJson(x);
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
      'enterprise_id': enterprise_id,
      'academic_year_id': academic_year_id,
      'class_teahcer_id': class_teahcer_id,
      'class_teacher_name': class_teacher_name,
      'students_count': students_count,
      'name': name,
      'short_name': short_name,
      'compulsory_subjects': compulsory_subjects,
      'details': details,
      'optional_subjects': optional_subjects,
      'academic_class_level_id': academic_class_level_id,
      'class_type': class_type,
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
        "created_at TEXT,"
        "enterprise_id TEXT,"
        "academic_year_id TEXT,"
        "class_teahcer_id TEXT,"
        "class_teacher_name TEXT,"
        "students_count TEXT,"
        "name TEXT,"
        "short_name TEXT,"
        "details TEXT,"
        "compulsory_subjects TEXT,"
        "optional_subjects TEXT,"
        "class_type TEXT,"
        "academic_class_level_id TEXT"
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
    if (!(await MyClasses.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }
}
