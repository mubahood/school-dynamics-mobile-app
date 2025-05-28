import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class SubjectModel {
  static String end_point = "subjects";
  static String tableName = "subjects_2";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String academic_class_id = "";
  String academic_class_text = "";
  String subject_teacher = "";
  String code = "";
  String details = "";
  String course_id = "";
  String course_text = "";
  String subject_name = "";
  String demo_id = "";
  String demo_text = "";
  String is_optional = "";
  String main_course_id = "";
  String main_course_text = "";
  String teacher_1 = "";
  String teacher_2 = "";
  String teacher_3 = "";
  String parent_course_id = "";
  String parent_course_text = "";
  String academic_year_id = "";
  String academic_year_text = "";
  String show_in_report = "";
  String grade_subject = "";

  String name = "";
  String teacher_name = "";
  String teacher_1_name = "";
  String teacher_2_name = "";
  String teacher_3_name = "";

  String get_other_teachers() {
    String other = "";
    if (teacher_1_name.isNotEmpty) {
      other += teacher_1_name;
    }
    if (teacher_2_name.isNotEmpty) {
      if (other.isEmpty) {
        other += teacher_2_name;
      } else {
        other += ", $teacher_2_name";
      }
    }
    if (teacher_3_name.isNotEmpty) {
      if (other.isEmpty) {
        other += teacher_3_name;
      } else {
        other += ", $teacher_3_name";
      }
    }
    if (other.isEmpty) {
      other = "None";
    }
    return other;
  }

  String get_name() {
    return name;
  }

  static fromJson(dynamic m) {
    SubjectModel obj = SubjectModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.academic_class_id = Utils.to_str(m['academic_class_id'], '');
    obj.academic_class_text = Utils.to_str(m['academic_class_text'], '');
    obj.subject_teacher = Utils.to_str(m['subject_teacher'], '');
    obj.code = Utils.to_str(m['code'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.course_id = Utils.to_str(m['course_id'], '');
    obj.course_text = Utils.to_str(m['course_text'], '');
    obj.subject_name = Utils.to_str(m['subject_name'], '');
    obj.demo_id = Utils.to_str(m['demo_id'], '');
    obj.demo_text = Utils.to_str(m['demo_text'], '');
    obj.is_optional = Utils.to_str(m['is_optional'], '');
    obj.main_course_id = Utils.to_str(m['main_course_id'], '');
    obj.main_course_text = Utils.to_str(m['main_course_text'], '');
    obj.teacher_1 = Utils.to_str(m['teacher_1'], '');
    obj.teacher_2 = Utils.to_str(m['teacher_2'], '');
    obj.teacher_3 = Utils.to_str(m['teacher_3'], '');
    obj.parent_course_id = Utils.to_str(m['parent_course_id'], '');
    obj.parent_course_text = Utils.to_str(m['parent_course_text'], '');
    obj.academic_year_id = Utils.to_str(m['academic_year_id'], '');
    obj.academic_year_text = Utils.to_str(m['academic_year_text'], '');
    obj.show_in_report = Utils.to_str(m['show_in_report'], '');
    obj.grade_subject = Utils.to_str(m['grade_subject'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.teacher_name = Utils.to_str(m['teacher_name'], '');
    obj.teacher_1_name = Utils.to_str(m['teacher_1_name'], '');
    obj.teacher_2_name = Utils.to_str(m['teacher_2_name'], '');
    obj.teacher_3_name = Utils.to_str(m['teacher_3_name'], '');

    return obj;
  }

  static Future<List<SubjectModel>> getLocalData({String where = "1"}) async {
    List<SubjectModel> data = [];
    if (!(await SubjectModel.initTable())) {
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
      data.add(SubjectModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<SubjectModel>> get_items({String where = '1'}) async {
    List<SubjectModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await SubjectModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      SubjectModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<SubjectModel>> getOnlineItems() async {
    List<SubjectModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(SubjectModel.end_point, {}));

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
        await SubjectModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          SubjectModel sub = SubjectModel.fromJson(x);
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
      'academic_class_id': academic_class_id,
      'academic_class_text': academic_class_text,
      'subject_teacher': subject_teacher,
      'code': code,
      'details': details,
      'course_id': course_id,
      'course_text': course_text,
      'subject_name': subject_name,
      'demo_id': demo_id,
      'demo_text': demo_text,
      'is_optional': is_optional,
      'main_course_id': main_course_id,
      'main_course_text': main_course_text,
      'teacher_1': teacher_1,
      'teacher_2': teacher_2,
      'teacher_3': teacher_3,
      'parent_course_id': parent_course_id,
      'parent_course_text': parent_course_text,
      'academic_year_id': academic_year_id,
      'academic_year_text': academic_year_text,
      'show_in_report': show_in_report,
      'grade_subject': grade_subject,
      'name': name,
      'teacher_name': teacher_name,
      'teacher_1_name': teacher_1_name,
      'teacher_2_name': teacher_2_name,
      'teacher_3_name': teacher_3_name,
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
        ",subject_teacher TEXT"
        ",code TEXT"
        ",details TEXT"
        ",course_id TEXT"
        ",course_text TEXT"
        ",subject_name TEXT"
        ",demo_id TEXT"
        ",demo_text TEXT"
        ",is_optional TEXT"
        ",main_course_id TEXT"
        ",main_course_text TEXT"
        ",teacher_1 TEXT"
        ",teacher_2 TEXT"
        ",teacher_3 TEXT"
        ",parent_course_id TEXT"
        ",parent_course_text TEXT"
        ",academic_year_id TEXT"
        ",academic_year_text TEXT"
        ",show_in_report TEXT"
        ",grade_subject TEXT"
        ",name TEXT"
        ",teacher_name TEXT"
        ",teacher_1_name TEXT"
        ",teacher_2_name TEXT"
        ",teacher_3_name TEXT"
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
    if (!(await SubjectModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(SubjectModel.tableName);
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
