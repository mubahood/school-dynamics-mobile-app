import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TermlyReportCard {
  static String end_point = "termly-report-cards";
  static String tableName = "termly_report_cards_2";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String academic_year_id = "";
  String academic_year_text = "";
  String term_id = "";
  String term_text = "";
  String has_beginning_term = "";
  String has_mid_term = "";
  String has_end_term = "";
  String report_title = "";
  String grading_scale_id = "";
  String grading_scale_text = "";
  String do_update = "";
  String generate_marks = "";
  String delete_marks_for_non_active = "";
  String bot_max = "";
  String mot_max = "";
  String eot_max = "";
  String display_bot_to_teachers = "";
  String display_mot_to_teachers = "";
  String display_eot_to_teachers = "";
  String display_bot_to_others = "";
  String display_mot_to_others = "";
  String display_eot_to_others = "";
  String can_submit_bot = "";
  String can_submit_mot = "";
  String can_submit_eot = "";
  String reports_generate = "";
  String reports_delete_for_non_active = "";
  String reports_include_bot = "";
  String reports_include_mot = "";
  String reports_include_eot = "";
  String reports_template = "";
  String reports_who_fees_balance = "";
  String reports_display_report_to_parents = "";
  String hm_communication = "";
  String classes = "";
  String user_custom_header = "";
  String custom_header_image = "";
  String use_background_image = "";
  String background_image = "";
  String generate_class_teacher_comment = "";
  String generate_head_teacher_comment = "";
  String generate_positions = "";
  String display_positions = "";
  String bottom_message = "";
  String positioning_type = "";
  String positioning_method = "";
  String positioning_exam = "";
  String generate_marks_for_classes = "";
  String display_class_teacher_comments = "";
  String display_class_other_comments = "";
  String bot_name = "";
  String mot_name = "";
  String eot_name = "";

  String getName(String name) {
    if (name == 'B.O.T') {
      return bot_name;
    } else if (name == 'M.O.T') {
      return mot_name;
    } else if (name == 'E.O.T') {
      return eot_name;
    }
    return 'NONE';
  }

  String activeMarkSubmission() {
    if (can_submit_bot == 'Yes') {
      return 'B.O.T';
    } else if (can_submit_mot == 'Yes') {
      return 'M.O.T';
    } else if (can_submit_eot == 'Yes') {
      return 'E.O.T';
    }
    return 'NONE';
  }

  static fromJson(dynamic m) {
    TermlyReportCard obj = TermlyReportCard();
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
    obj.has_beginning_term = Utils.to_str(m['has_beginning_term'], '');
    obj.has_mid_term = Utils.to_str(m['has_mid_term'], '');
    obj.has_end_term = Utils.to_str(m['has_end_term'], '');
    obj.report_title = Utils.to_str(m['report_title'], '');
    obj.grading_scale_id = Utils.to_str(m['grading_scale_id'], '');
    obj.grading_scale_text = Utils.to_str(m['grading_scale_text'], '');
    obj.do_update = Utils.to_str(m['do_update'], '');
    obj.generate_marks = Utils.to_str(m['generate_marks'], '');
    obj.delete_marks_for_non_active =
        Utils.to_str(m['delete_marks_for_non_active'], '');
    obj.bot_max = Utils.to_str(m['bot_max'], '');
    obj.mot_max = Utils.to_str(m['mot_max'], '');
    obj.eot_max = Utils.to_str(m['eot_max'], '');
    obj.display_bot_to_teachers =
        Utils.to_str(m['display_bot_to_teachers'], '');
    obj.display_mot_to_teachers =
        Utils.to_str(m['display_mot_to_teachers'], '');
    obj.display_eot_to_teachers =
        Utils.to_str(m['display_eot_to_teachers'], '');
    obj.display_bot_to_others = Utils.to_str(m['display_bot_to_others'], '');
    obj.display_mot_to_others = Utils.to_str(m['display_mot_to_others'], '');
    obj.display_eot_to_others = Utils.to_str(m['display_eot_to_others'], '');
    obj.can_submit_bot = Utils.to_str(m['can_submit_bot'], '');
    obj.can_submit_mot = Utils.to_str(m['can_submit_mot'], '');
    obj.can_submit_eot = Utils.to_str(m['can_submit_eot'], '');
    obj.reports_generate = Utils.to_str(m['reports_generate'], '');
    obj.reports_delete_for_non_active =
        Utils.to_str(m['reports_delete_for_non_active'], '');
    obj.reports_include_bot = Utils.to_str(m['reports_include_bot'], '');
    obj.reports_include_mot = Utils.to_str(m['reports_include_mot'], '');
    obj.reports_include_eot = Utils.to_str(m['reports_include_eot'], '');
    obj.reports_template = Utils.to_str(m['reports_template'], '');
    obj.reports_who_fees_balance =
        Utils.to_str(m['reports_who_fees_balance'], '');
    obj.reports_display_report_to_parents =
        Utils.to_str(m['reports_display_report_to_parents'], '');
    obj.hm_communication = Utils.to_str(m['hm_communication'], '');
    obj.classes = Utils.to_str(m['classes'], '');
    obj.user_custom_header = Utils.to_str(m['user_custom_header'], '');
    obj.custom_header_image = Utils.to_str(m['custom_header_image'], '');
    obj.use_background_image = Utils.to_str(m['use_background_image'], '');
    obj.background_image = Utils.to_str(m['background_image'], '');
    obj.generate_class_teacher_comment =
        Utils.to_str(m['generate_class_teacher_comment'], '');
    obj.generate_head_teacher_comment =
        Utils.to_str(m['generate_head_teacher_comment'], '');
    obj.generate_positions = Utils.to_str(m['generate_positions'], '');
    obj.display_positions = Utils.to_str(m['display_positions'], '');
    obj.bottom_message = Utils.to_str(m['bottom_message'], '');
    obj.positioning_type = Utils.to_str(m['positioning_type'], '');
    obj.positioning_method = Utils.to_str(m['positioning_method'], '');
    obj.positioning_exam = Utils.to_str(m['positioning_exam'], '');
    obj.generate_marks_for_classes =
        Utils.to_str(m['generate_marks_for_classes'], '');
    obj.display_class_teacher_comments =
        Utils.to_str(m['display_class_teacher_comments'], '');
    obj.display_class_other_comments =
        Utils.to_str(m['display_class_other_comments'], '');
    obj.bot_name = Utils.to_str(m['bot_name'], '');
    obj.mot_name = Utils.to_str(m['mot_name'], '');
    obj.eot_name = Utils.to_str(m['eot_name'], '');

    return obj;
  }

  static Future<List<TermlyReportCard>> getLocalData(
      {String where = "1"}) async {
    List<TermlyReportCard> data = [];
    if (!(await TermlyReportCard.initTable())) {
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
      data.add(TermlyReportCard.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TermlyReportCard>> get_items({String where = '1'}) async {
    List<TermlyReportCard> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TermlyReportCard.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TermlyReportCard.getOnlineItems();
    }
    return data;
  }

  static Future<List<TermlyReportCard>> getOnlineItems() async {
    List<TermlyReportCard> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(TermlyReportCard.end_point, {}));

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
        await TermlyReportCard.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TermlyReportCard sub = TermlyReportCard.fromJson(x);
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
      'has_beginning_term': has_beginning_term,
      'has_mid_term': has_mid_term,
      'has_end_term': has_end_term,
      'report_title': report_title,
      'grading_scale_id': grading_scale_id,
      'grading_scale_text': grading_scale_text,
      'do_update': do_update,
      'generate_marks': generate_marks,
      'delete_marks_for_non_active': delete_marks_for_non_active,
      'bot_max': bot_max,
      'mot_max': mot_max,
      'eot_max': eot_max,
      'display_bot_to_teachers': display_bot_to_teachers,
      'display_mot_to_teachers': display_mot_to_teachers,
      'display_eot_to_teachers': display_eot_to_teachers,
      'display_bot_to_others': display_bot_to_others,
      'display_mot_to_others': display_mot_to_others,
      'display_eot_to_others': display_eot_to_others,
      'can_submit_bot': can_submit_bot,
      'can_submit_mot': can_submit_mot,
      'can_submit_eot': can_submit_eot,
      'reports_generate': reports_generate,
      'reports_delete_for_non_active': reports_delete_for_non_active,
      'reports_include_bot': reports_include_bot,
      'reports_include_mot': reports_include_mot,
      'reports_include_eot': reports_include_eot,
      'reports_template': reports_template,
      'reports_who_fees_balance': reports_who_fees_balance,
      'reports_display_report_to_parents': reports_display_report_to_parents,
      'hm_communication': hm_communication,
      'classes': classes,
      'user_custom_header': user_custom_header,
      'custom_header_image': custom_header_image,
      'use_background_image': use_background_image,
      'background_image': background_image,
      'generate_class_teacher_comment': generate_class_teacher_comment,
      'generate_head_teacher_comment': generate_head_teacher_comment,
      'generate_positions': generate_positions,
      'display_positions': display_positions,
      'bottom_message': bottom_message,
      'positioning_type': positioning_type,
      'positioning_method': positioning_method,
      'positioning_exam': positioning_exam,
      'generate_marks_for_classes': generate_marks_for_classes,
      'display_class_teacher_comments': display_class_teacher_comments,
      'display_class_other_comments': display_class_other_comments,
      'bot_name': bot_name,
      'mot_name': mot_name,
      'eot_name': eot_name,
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
        ",has_beginning_term TEXT"
        ",has_mid_term TEXT"
        ",has_end_term TEXT"
        ",report_title TEXT"
        ",grading_scale_id TEXT"
        ",grading_scale_text TEXT"
        ",do_update TEXT"
        ",generate_marks TEXT"
        ",delete_marks_for_non_active TEXT"
        ",bot_max TEXT"
        ",mot_max TEXT"
        ",eot_max TEXT"
        ",display_bot_to_teachers TEXT"
        ",display_mot_to_teachers TEXT"
        ",display_eot_to_teachers TEXT"
        ",display_bot_to_others TEXT"
        ",display_mot_to_others TEXT"
        ",display_eot_to_others TEXT"
        ",can_submit_bot TEXT"
        ",can_submit_mot TEXT"
        ",can_submit_eot TEXT"
        ",reports_generate TEXT"
        ",reports_delete_for_non_active TEXT"
        ",reports_include_bot TEXT"
        ",reports_include_mot TEXT"
        ",reports_include_eot TEXT"
        ",reports_template TEXT"
        ",reports_who_fees_balance TEXT"
        ",reports_display_report_to_parents TEXT"
        ",hm_communication TEXT"
        ",classes TEXT"
        ",user_custom_header TEXT"
        ",custom_header_image TEXT"
        ",use_background_image TEXT"
        ",background_image TEXT"
        ",generate_class_teacher_comment TEXT"
        ",generate_head_teacher_comment TEXT"
        ",generate_positions TEXT"
        ",display_positions TEXT"
        ",bottom_message TEXT"
        ",positioning_type TEXT"
        ",positioning_method TEXT"
        ",positioning_exam TEXT"
        ",generate_marks_for_classes TEXT"
        ",display_class_teacher_comments TEXT"
        ",display_class_other_comments TEXT"
        ",bot_name TEXT"
        ",mot_name TEXT"
        ",eot_name TEXT"
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
    if (!(await TermlyReportCard.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TermlyReportCard.tableName);
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
