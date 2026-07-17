import 'dart:convert';

import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

// ─── Subject score item inside a report ───────────────────────────────────────

class ProgressiveReportItem {
  int id = 0;
  String subject_id = "";
  String subject_name = "";
  String main_course_id = "";
  String main_course_name = "";
  String average_mark = "";
  String grade_name = "";
  String aggregates = "";
  String remarks = "";
  String initials = "";
  String test_scores = ""; // raw JSON string from server
  List<Map<String, dynamic>> test_scores_parsed = [];

  static ProgressiveReportItem fromJson(dynamic m) {
    ProgressiveReportItem obj = ProgressiveReportItem();
    if (m == null) return obj;
    obj.id = Utils.int_parse(m['id']);
    obj.subject_id = Utils.to_str(m['subject_id'], '');
    obj.subject_name = Utils.to_str(m['subject_name'], '');
    obj.main_course_id = Utils.to_str(m['main_course_id'], '');
    obj.main_course_name = Utils.to_str(m['main_course_name'], '');
    obj.average_mark = Utils.to_str(m['average_mark'], '');
    obj.grade_name = Utils.to_str(m['grade_name'], '');
    obj.aggregates = Utils.to_str(m['aggregates'], '');
    obj.remarks = Utils.to_str(m['remarks'], '');
    obj.initials = Utils.to_str(m['initials'], '');
    obj.test_scores = Utils.to_str(m['test_scores'], '[]');

    // Parse test_scores_parsed if the server enriched it
    try {
      final raw = m['test_scores_parsed'];
      if (raw != null && raw is List) {
        obj.test_scores_parsed = List<Map<String, dynamic>>.from(
            raw.map((e) => Map<String, dynamic>.from(e as Map)));
      } else if (obj.test_scores.isNotEmpty) {
        final decoded = jsonDecode(obj.test_scores);
        if (decoded is List) {
          obj.test_scores_parsed = List<Map<String, dynamic>>.from(
              decoded.map((e) => Map<String, dynamic>.from(e as Map)));
        }
      }
    } catch (_) {}

    return obj;
  }

  /// Returns true if this item has at least one submitted score
  bool get hasScores => test_scores_parsed.any(
      (s) => (s['submitted'] == 'Yes') && s['score'] != null);

  /// Display name: prefer course name if distinct, else subject name
  String get displayName {
    if (main_course_name.isNotEmpty &&
        main_course_name.toLowerCase() != subject_name.toLowerCase()) {
      return main_course_name;
    }
    return subject_name;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'subject_id': subject_id,
        'subject_name': subject_name,
        'main_course_id': main_course_id,
        'main_course_name': main_course_name,
        'average_mark': average_mark,
        'grade_name': grade_name,
        'aggregates': aggregates,
        'remarks': remarks,
        'initials': initials,
        'test_scores': test_scores,
        'test_scores_parsed': test_scores_parsed,
      };
}

// ─── Progressive Assessment summary linked to a report ────────────────────────

class ProgressiveAssessmentSummary {
  int id = 0;
  String title = "";
  String term_id = "";
  String number_of_tests = "1";
  String display_to_parents = "No";

  static ProgressiveAssessmentSummary fromJson(dynamic m) {
    ProgressiveAssessmentSummary obj = ProgressiveAssessmentSummary();
    if (m == null) return obj;
    obj.id = Utils.int_parse(m['id']);
    obj.title = Utils.to_str(m['title'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.number_of_tests = Utils.to_str(m['number_of_tests'], '1');
    obj.display_to_parents = Utils.to_str(m['display_to_parents'], 'No');
    return obj;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'term_id': term_id,
        'number_of_tests': number_of_tests,
        'display_to_parents': display_to_parents,
      };
}

// ─── Main model ───────────────────────────────────────────────────────────────

class ProgressiveReportModel {
  static String end_point = "student-progressive-reports";
  static String tableName = "student_progressive_reports_local";

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String progressive_assessment_id = "";
  String student_id = "";
  String student_text = "";
  String term_id = "";
  String term_text = "";
  String academic_year_id = "";
  String academic_class_id = "";
  String academic_class_text = "";
  String stream_id = "";
  String total_marks = "";
  String total_aggregates = "";
  String average_aggregates = "";
  String grade = "";
  String position = "";
  String total_students = "";
  String class_teacher_comment = "";
  String head_teacher_comment = "";
  String pdf_url = "";
  String is_ready = "";
  String date_generated = "";
  // Cached serialised blobs for SQLite persistence
  String items_json = "[]";
  String progressive_assessment_json = "{}";
  String local_synced_at = "";

  List<ProgressiveReportItem> items = [];
  ProgressiveAssessmentSummary? progressive_assessment;

  // ── Helpers ──────────────────────────────────────────────────────────────

  String getPdf() {
    if (pdf_url.isEmpty) return '';
    String clean = pdf_url.replaceAll("files/", "");
    return "${AppConfig.DASHBOARD_URL}/storage/files/$clean";
  }

  bool get hasPdf => pdf_url.isNotEmpty;

  String get assessmentTitle =>
      progressive_assessment?.title.isNotEmpty == true
          ? progressive_assessment!.title
          : 'Progressive Assessment';

  int get numTests =>
      int.tryParse(progressive_assessment?.number_of_tests ?? '1') ?? 1;

  // ── Parsing ───────────────────────────────────────────────────────────────

  static ProgressiveReportModel fromJson(dynamic m) {
    ProgressiveReportModel obj = ProgressiveReportModel();
    if (m == null) return obj;

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.progressive_assessment_id =
        Utils.to_str(m['progressive_assessment_id'], '');
    obj.student_id = Utils.to_str(m['student_id'], '');
    obj.student_text = Utils.to_str(m['student_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'] ?? m['term_id'], '');
    obj.academic_year_id = Utils.to_str(m['academic_year_id'], '');
    obj.academic_class_id = Utils.to_str(m['academic_class_id'], '');
    obj.academic_class_text = Utils.to_str(m['academic_class_text'], '');
    obj.stream_id = Utils.to_str(m['stream_id'], '');
    obj.total_marks = Utils.to_str(m['total_marks'], '');
    obj.total_aggregates = Utils.to_str(m['total_aggregates'], '');
    obj.average_aggregates = Utils.to_str(m['average_aggregates'], '');
    obj.grade = Utils.to_str(m['grade'], '');
    obj.position = Utils.to_str(m['position'], '');
    obj.total_students = Utils.to_str(m['total_students'], '');
    obj.class_teacher_comment = Utils.to_str(m['class_teacher_comment'], '');
    obj.head_teacher_comment = Utils.to_str(m['head_teacher_comment'], '');
    obj.pdf_url = Utils.to_str(m['pdf_url'], '');
    obj.is_ready = Utils.to_str(m['is_ready'], '');
    obj.date_generated =
        Utils.to_str(m['date_generated'] ?? m['date_generated'], '');
    obj.items_json = Utils.to_str(m['items_json'], '[]');
    obj.progressive_assessment_json =
        Utils.to_str(m['progressive_assessment_json'], '{}');
    obj.local_synced_at = Utils.to_str(m['local_synced_at'], '');

    // Parse nested items — prefer live List from API; fall back to cached JSON
    try {
      final rawItems = m['items'];
      if (rawItems != null && rawItems is List) {
        obj.items = rawItems
            .map((e) => ProgressiveReportItem.fromJson(e))
            .toList();
        // Keep items_json in sync for the next SQLite write
        obj.items_json = jsonEncode(obj.items.map((i) => i.toJson()).toList());
      } else if (obj.items_json.isNotEmpty && obj.items_json != '[]') {
        final decoded = jsonDecode(obj.items_json);
        if (decoded is List) {
          obj.items = decoded
              .map((e) => ProgressiveReportItem.fromJson(e))
              .toList();
        }
      }
    } catch (_) {}

    // Parse nested assessment summary — prefer live Map from API; fall back
    try {
      final rawPa = m['progressive_assessment'];
      if (rawPa != null && rawPa is Map) {
        obj.progressive_assessment =
            ProgressiveAssessmentSummary.fromJson(rawPa);
        obj.progressive_assessment_json =
            jsonEncode(obj.progressive_assessment!.toJson());
      } else if (obj.progressive_assessment_json.isNotEmpty &&
          obj.progressive_assessment_json != '{}') {
        final decoded = jsonDecode(obj.progressive_assessment_json);
        if (decoded is Map) {
          obj.progressive_assessment =
              ProgressiveAssessmentSummary.fromJson(decoded);
        }
      }
    } catch (_) {}

    return obj;
  }

  Map<String, dynamic> toJson() {
    // Serialise nested objects so they survive a SQLite round-trip
    final resolvedItemsJson = items.isNotEmpty
        ? jsonEncode(items.map((i) => i.toJson()).toList())
        : items_json;
    final resolvedPaJson = progressive_assessment != null
        ? jsonEncode(progressive_assessment!.toJson())
        : progressive_assessment_json;

    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'enterprise_id': enterprise_id,
      'progressive_assessment_id': progressive_assessment_id,
      'student_id': student_id,
      'student_text': student_text,
      'term_id': term_id,
      'term_text': term_text,
      'academic_year_id': academic_year_id,
      'academic_class_id': academic_class_id,
      'academic_class_text': academic_class_text,
      'stream_id': stream_id,
      'total_marks': total_marks,
      'total_aggregates': total_aggregates,
      'average_aggregates': average_aggregates,
      'grade': grade,
      'position': position,
      'total_students': total_students,
      'class_teacher_comment': class_teacher_comment,
      'head_teacher_comment': head_teacher_comment,
      'pdf_url': pdf_url,
      'is_ready': is_ready,
      'date_generated': date_generated,
      'items_json': resolvedItemsJson,
      'progressive_assessment_json': resolvedPaJson,
      'local_synced_at': local_synced_at,
    };
  }

  // ── Local SQLite ──────────────────────────────────────────────────────────

  static Future<List<ProgressiveReportModel>> getLocalData(
      {String where = "1"}) async {
    List<ProgressiveReportModel> data = [];
    if (!(await ProgressiveReportModel.initTable())) return data;
    Database db = await Utils.getDb();
    if (!db.isOpen) return data;
    List<Map> maps =
        await db.query(tableName, where: where, orderBy: 'id DESC');
    for (var m in maps) {
      data.add(ProgressiveReportModel.fromJson(m));
    }
    return data;
  }

  static Future<List<ProgressiveReportModel>> get_items(
      {String where = '1'}) async {
    List<ProgressiveReportModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await ProgressiveReportModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      ProgressiveReportModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<ProgressiveReportModel>> getOnlineItems(
      {Map<String, dynamic> params = const {}}) async {
    RespondModel resp =
        RespondModel(await Utils.http_get(end_point, params));
    if (resp.code != 1) return [];

    Database db = await Utils.getDb();
    if (!db.isOpen) return [];

    if (resp.data.runtimeType.toString().contains('List')) {
      if (await Utils.is_connected()) {
        await deleteAll();
      }
      await saveItems(resp.data as List);
    }
    return [];
  }

  /// Persist a raw API list to SQLite, stamping [local_synced_at].
  /// Uses REPLACE so individual records are updated without wiping all rows.
  static Future<void> saveItems(List<dynamic> data) async {
    if (!(await initTable())) return;
    Database db = await Utils.getDb();
    if (!db.isOpen) return;
    final now = DateTime.now().toIso8601String();
    await db.transaction((txn) async {
      var batch = txn.batch();
      for (var x in data) {
        ProgressiveReportModel item = ProgressiveReportModel.fromJson(x);
        item.local_synced_at = now;
        try {
          batch.insert(tableName, item.toJson(),
              conflictAlgorithm: ConflictAlgorithm.replace);
        } catch (_) {}
      }
      try {
        await batch.commit(continueOnError: true);
      } catch (_) {}
    });
  }

  save() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) return;
    await initTable();
    try {
      await db.insert(tableName, toJson(),
          conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      Utils.toast("Failed to save because ${e.toString()}");
    }
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) return false;
    String sql = "CREATE TABLE IF NOT EXISTS $tableName ("
        "id INTEGER PRIMARY KEY"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",enterprise_id TEXT"
        ",progressive_assessment_id TEXT"
        ",student_id TEXT"
        ",student_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",academic_year_id TEXT"
        ",academic_class_id TEXT"
        ",academic_class_text TEXT"
        ",stream_id TEXT"
        ",total_marks TEXT"
        ",total_aggregates TEXT"
        ",average_aggregates TEXT"
        ",grade TEXT"
        ",position TEXT"
        ",total_students TEXT"
        ",class_teacher_comment TEXT"
        ",head_teacher_comment TEXT"
        ",pdf_url TEXT"
        ",is_ready TEXT"
        ",date_generated TEXT"
        ",items_json TEXT"
        ",progressive_assessment_json TEXT"
        ",local_synced_at TEXT"
        ")";
    try {
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table: ${e.toString()}');
      return false;
    }
    // Migrate existing installs: add columns that may not exist yet
    for (final col in [
      "ALTER TABLE $tableName ADD COLUMN items_json TEXT DEFAULT '[]'",
      "ALTER TABLE $tableName ADD COLUMN progressive_assessment_json TEXT DEFAULT '{}'",
      "ALTER TABLE $tableName ADD COLUMN local_synced_at TEXT DEFAULT ''",
    ]) {
      try {
        await db.execute(col);
      } catch (_) {
        // Column already exists — safe to ignore
      }
    }
    return true;
  }

  static deleteAll() async {
    if (!(await initTable())) return;
    Database db = await Utils.getDb();
    if (!db.isOpen) return;
    await db.delete(tableName);
  }
}
