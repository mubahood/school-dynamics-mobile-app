import 'dart:convert';

import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/TemporaryModel.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';

class SessionLocal {
  static String table_name = "SessionLocal1";

  List<TemporaryModel> expectedMembers = [];
  List<int> presentMembers = [];
  List<int> absentMembers = [];

  getPresentMembers() {
    var temp = jsonDecode(present);

    if (temp.runtimeType.toString() != 'List<dynamic>') {
      return [];
    }

    presentMembers.clear();
    for (var x in temp) {
      presentMembers.add(Utils.int_parse(x));
    }
  }

  getAbsentMembers() {
    if (absent.length < 2) {
      return [];
    }
    var temp = null;

    try {
      temp = jsonDecode(absent);
    } catch (E) {
      temp = null;
    }
    if (temp == null) {
      return [];
    }

    if (temp.runtimeType.toString() != 'List<dynamic>') {
      return [];
    }

    absentMembers.clear();
    for (var x in temp) {
      absentMembers.add(Utils.int_parse(x));
    }
  }

  getExpectedMembers() {
    var temp = jsonDecode(expected);
    if (temp.runtimeType.toString() != 'List<dynamic>') {
      return [];
    }
    expectedMembers.clear();

    for (var x in temp) {
      expectedMembers.add(TemporaryModel.fromJson(x));
    }

    expectedMembers.sort((a, b) => a.title.compareTo(b.title));
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
        SessionLocal.table_name,
        toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  Future<void> submitSelf() async {
    print("======>$title<======");

    if (closed != 'yes') {
      return;
    }

    Map<String, dynamic> params = {
      'id': id,
      'due_date': due_date,
      'type': type,
      'title': title,
      'present': present,
      'academic_class_id': academic_class_id,
      'subject_id': subject_id,
      'service_id': service_id,
      'stream_id': stream_id,
    };
    RespondModel resp =
        RespondModel(await Utils.http_post('session-create', params));

    if (resp.code == 1) {
      await deleteSelf();
      print('Successfully Submitted');
    } else {
      print(resp.message);
      print("failed/");
    }
  }

  toJson() {
    Map<String, dynamic> data = {
      'due_date': due_date,
      'type': type,
      'closed': closed,
      'title': title,
      'present': present,
      'absent': absent,
      'expected': expected,
      'academic_class_id': academic_class_id,
      'subject_id': subject_id,
      'stream_id': stream_id,
      'service_id': service_id,
    };
    if (id != 0) {
      data['id'] = id;
    }
    return data;
  }

  static Future<List<SessionLocal>> getItems({String where = '1'}) async {
    List<SessionLocal> data = [];
    if (!(await SessionLocal.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(SessionLocal.table_name, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(SessionLocal.fromJson(maps[i]));
    });

    return data;
  }

  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String administrator_id = "";
  String administrator_text = "";
  String academic_year_id = "";
  String academic_year_text = "";
  String term_id = "";
  String term_text = "";
  String academic_class_id = "";
  String academic_class_text = "";
  String subject_id = "";
  String subject_text = "";
  String service_id = "";
  String service_text = "";
  String due_date = DateTime.now().toString();
  String title = "";
  String is_open = "";
  String prepared = "";
  String type = "";
  String stream_id = "";
  String stream_text = "";
  String notify_present = "";
  String notify_absent = "";
  String participants = "";
  String present = "";
  String absent = "";
  String expected = "";
  String closed = "";

  static SessionLocal fromJson(dynamic m) {
    SessionLocal obj = new SessionLocal();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');
    obj.academic_year_id = Utils.to_str(m['academic_year_id'], '');
    obj.academic_year_text = Utils.to_str(m['academic_year_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.academic_class_id = Utils.to_str(m['academic_class_id'], '');
    obj.academic_class_text = Utils.to_str(m['academic_class_text'], '');
    obj.subject_id = Utils.to_str(m['subject_id'], '');
    obj.subject_text = Utils.to_str(m['subject_text'], '');
    obj.service_id = Utils.to_str(m['service_id'], '');
    obj.service_text = Utils.to_str(m['service_text'], '');
    obj.due_date = Utils.to_str(m['due_date'], '');
    obj.title = Utils.to_str(m['title'], '');
    obj.is_open = Utils.to_str(m['is_open'], '');
    obj.prepared = Utils.to_str(m['prepared'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.stream_id = Utils.to_str(m['stream_id'], '');
    obj.stream_text = Utils.to_str(m['stream_text'], '');
    obj.notify_present = Utils.to_str(m['notify_present'], '');
    obj.notify_absent = Utils.to_str(m['notify_absent'], '');
    obj.participants = Utils.to_str(m['participants'], '');
    obj.academic_class_id = Utils.to_str(m['academic_class_id'], '');
    obj.present = Utils.to_str(m['present'], '');
    obj.absent = Utils.to_str(m['absent'], '');
    obj.expected = Utils.to_str(m['expected'], '');
    obj.closed = Utils.to_str(m['closed'], '');

    return obj;
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "${SessionLocal.table_name} (id INTEGER PRIMARY KEY AUTOINCREMENT,"
        "created_at TEXT"
        ",updated_at TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",administrator_id TEXT"
        ",administrator_text TEXT"
        ",academic_year_id TEXT"
        ",academic_year_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",academic_class_id TEXT"
        ",academic_class_text TEXT"
        ",subject_id TEXT"
        ",subject_text TEXT"
        ",service_id TEXT"
        ",service_text TEXT"
        ",due_date TEXT"
        ",title TEXT"
        ",is_open TEXT"
        ",prepared TEXT"
        ",type TEXT"
        ",stream_id TEXT"
        ",stream_text TEXT"
        ",notify_present TEXT"
        ",notify_absent TEXT"
        ",participants TEXT"
        ",present TEXT"
        ",absent TEXT"
        ",expected TEXT"
        ",closed TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE ${SessionLocal.table_name}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  deleteSelf() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(
        SessionLocal.table_name,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  static uploadPending() async {
    for (SessionLocal s in (await SessionLocal.getItems())) {
      if (s.closed == 'yes') {
        await s.submitSelf();
      } else {}
    }
  }
}
