import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class StudentReportCard {
  static String end_point = "student-report-cards";
  static String tableName = "student_report_cards";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String academic_year_id = "";
  String academic_year_text = "";
  String term_id = "";
  String term_text = "";
  String student_id = "";
  String student_text = "";
  String academic_class_id = "";
  String academic_class_text = "";
  String termly_report_card_id = "";
  String termly_report_card_text = "";
  String total_marks = "";
  String total_aggregates = "";
  String position = "";
  String class_teacher_comment = "";
  String head_teacher_comment = "";
  String class_teacher_commented = "";
  String head_teacher_commented = "";
  String total_students = "";
  String average_aggregates = "";
  String grade = "";
  String stream_id = "";
  String stream_text = "";
  String sports_comment = "";
  String mentor_comment = "";
  String nurse_comment = "";
  String parent_can_view = "";
  String is_ready = "";
  String date_gnerated = "";
  String pdf_url = "";
  String vatar = "";

  String getPdf() {
    if (pdf_url.contains("files/")) {
      pdf_url.replaceAll("files/", "");
    }
    return "${AppConfig.DASHBOARD_URL}/storage/files/$pdf_url";
    return pdf_url;
  }

  static fromJson(dynamic m) {
    StudentReportCard obj = StudentReportCard();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.academic_year_id = Utils.to_str(m['academic_year_id'], '');
    obj.academic_year_text = Utils.to_str(m['academic_year_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.student_id = Utils.to_str(m['student_id'], '');
    obj.student_text = Utils.to_str(m['student_text'], '');
    obj.academic_class_id = Utils.to_str(m['academic_class_id'], '');
    obj.academic_class_text = Utils.to_str(m['academic_class_text'], '');
    obj.termly_report_card_id = Utils.to_str(m['termly_report_card_id'], '');
    obj.termly_report_card_text =
        Utils.to_str(m['termly_report_card_text'], '');
    obj.total_marks = Utils.to_str(m['total_marks'], '');
    obj.total_aggregates = Utils.to_str(m['total_aggregates'], '');
    obj.position = Utils.to_str(m['position'], '');
    obj.class_teacher_comment = Utils.to_str(m['class_teacher_comment'], '');
    obj.head_teacher_comment = Utils.to_str(m['head_teacher_comment'], '');
    obj.class_teacher_commented =
        Utils.to_str(m['class_teacher_commented'], '');
    obj.head_teacher_commented = Utils.to_str(m['head_teacher_commented'], '');
    obj.total_students = Utils.to_str(m['total_students'], '');
    obj.average_aggregates = Utils.to_str(m['average_aggregates'], '');
    obj.grade = Utils.to_str(m['grade'], '');
    obj.stream_id = Utils.to_str(m['stream_id'], '');
    obj.stream_text = Utils.to_str(m['stream_text'], '');
    obj.sports_comment = Utils.to_str(m['sports_comment'], '');
    obj.mentor_comment = Utils.to_str(m['mentor_comment'], '');
    obj.nurse_comment = Utils.to_str(m['nurse_comment'], '');
    obj.parent_can_view = Utils.to_str(m['parent_can_view'], '');
    obj.is_ready = Utils.to_str(m['is_ready'], '');
    obj.date_gnerated = Utils.to_str(m['date_gnerated'], '');
    obj.pdf_url = Utils.to_str(m['pdf_url'], '');
    obj.vatar = Utils.to_str(m['vatar'], '');

    return obj;
  }

  static Future<List<StudentReportCard>> getLocalData(
      {String where = "1"}) async {
    List<StudentReportCard> data = [];
    if (!(await StudentReportCard.initTable())) {
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
      data.add(StudentReportCard.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<StudentReportCard>> get_items({String where = '1'}) async {
    List<StudentReportCard> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await StudentReportCard.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      StudentReportCard.getOnlineItems();
    }
    return data;
  }

  static Future<List<StudentReportCard>> getOnlineItems() async {
    List<StudentReportCard> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(StudentReportCard.end_point, {}));

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
        await StudentReportCard.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          StudentReportCard sub = StudentReportCard.fromJson(x);
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
      'academic_year_id': academic_year_id,
      'academic_year_text': academic_year_text,
      'term_id': term_id,
      'term_text': term_text,
      'student_id': student_id,
      'student_text': student_text,
      'academic_class_id': academic_class_id,
      'academic_class_text': academic_class_text,
      'termly_report_card_id': termly_report_card_id,
      'termly_report_card_text': termly_report_card_text,
      'total_marks': total_marks,
      'total_aggregates': total_aggregates,
      'position': position,
      'class_teacher_comment': class_teacher_comment,
      'head_teacher_comment': head_teacher_comment,
      'class_teacher_commented': class_teacher_commented,
      'head_teacher_commented': head_teacher_commented,
      'total_students': total_students,
      'average_aggregates': average_aggregates,
      'grade': grade,
      'stream_id': stream_id,
      'stream_text': stream_text,
      'sports_comment': sports_comment,
      'mentor_comment': mentor_comment,
      'nurse_comment': nurse_comment,
      'parent_can_view': parent_can_view,
      'is_ready': is_ready,
      'date_gnerated': date_gnerated,
      'pdf_url': pdf_url,
      'vatar': vatar,
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
        ",academic_year_id TEXT"
        ",academic_year_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",student_id TEXT"
        ",student_text TEXT"
        ",academic_class_id TEXT"
        ",academic_class_text TEXT"
        ",termly_report_card_id TEXT"
        ",termly_report_card_text TEXT"
        ",total_marks TEXT"
        ",total_aggregates TEXT"
        ",position TEXT"
        ",class_teacher_comment TEXT"
        ",head_teacher_comment TEXT"
        ",class_teacher_commented TEXT"
        ",head_teacher_commented TEXT"
        ",total_students TEXT"
        ",average_aggregates TEXT"
        ",grade TEXT"
        ",stream_id TEXT"
        ",stream_text TEXT"
        ",sports_comment TEXT"
        ",mentor_comment TEXT"
        ",nurse_comment TEXT"
        ",parent_can_view TEXT"
        ",is_ready TEXT"
        ",date_gnerated TEXT"
        ",pdf_url TEXT"
        ",vatar TEXT"
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
    if (!(await StudentReportCard.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(StudentReportCard.tableName);
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
