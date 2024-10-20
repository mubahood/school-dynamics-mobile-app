import 'dart:convert';

import 'package:schooldynamics/models/MyClasses.dart';
import 'package:schooldynamics/models/RespondModel.dart';
import 'package:schooldynamics/models/TemporaryModel.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';

class SessionOnline {
  static String tableName = "SessionOnline1";
  static String endPoint = "my-sessions";

  List<TemporaryModel> expectedMembers = [];
  List<int> presentMembers = [];

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

  getExpectedMembers() async {
    List<MyClasses> myClasses = await MyClasses.getItems();

    MyClasses myClass = MyClasses();
    for (MyClasses c in myClasses) {
      if (c.id.toString() == academic_class_id.toString()) {
        myClass = c;
        break;
      }
    }
    if (myClass.id < 1) {
      return;
    }

    expectedMembers.clear();
    for (var student in (await myClass.getStudents(myClass.id.toString()))) {
      TemporaryModel x = TemporaryModel();
      x.id = student.id;
      x.title = student.name;
      x.image = student.avatar;
      expectedMembers.add(x);
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
        SessionOnline.tableName,
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
      'due_date': due_date,
      'type': type,
      'closed': closed,
      'title': title,
      'present': present,
      'absent': absent,
      'expected': expected,
      'academic_class_id': academic_class_id,
      'subject_id': subject_id,
      'service_id': service_id,
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'academic_class_text': academic_class_text,
      'subject_text': subject_text,
      'stream_text': stream_text,
      'present_count': present_count,
      'absent_count': absent_count,
    };
  }

  static Future<List<SessionOnline>> getItems(
      {String where = '1', bool forceWait = true}) async {
    List<SessionOnline> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await SessionOnline.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      SessionOnline.getOnlineItems();
    }
    return data;
  }

  static Future<List<SessionOnline>> getOnlineItems() async {
    List<SessionOnline> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(SessionOnline.endPoint, {}));

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
        await SessionOnline.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          SessionOnline sub = new SessionOnline();
          try {
            sub.id = Utils.int_parse(x['id']);
          } catch (xs) {
            sub.id = 0;
          }
          if (sub.id < 1) {
            continue;
          }
          sub = SessionOnline.fromJson(x);
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

  static deleteAll() async {
    if (!(await SessionOnline.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(tableName);
  }

  static Future<List<SessionOnline>> getLocalData({String where = '1'}) async {
    List<SessionOnline> data = [];
    if (!(await SessionOnline.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(SessionOnline.tableName,
        where: where, orderBy: 'id DESC');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(SessionOnline.fromJson(maps[i]));
    });

    return data;
  }

  int id = 0;
  String due_date = "";
  String type = "";
  String title = "";
  String present = "";
  String absent = "";
  String closed = "no";
  String expected = "";
  String academic_class_id = '';
  String subject_id = '';
  String service_id = '';
  String administrator_id = '';
  String administrator_text = '';
  String academic_class_text = '';
  String subject_text = '';
  String stream_text = '';
  String present_count = '';
  String absent_count = '';

  static SessionOnline fromJson(dynamic data) {
    SessionOnline item = new SessionOnline();
    if (data == null) {
      return item;
    }


    item.id = Utils.int_parse(data['id']);
    item.due_date = Utils.to_str(data['due_date'], '');
    item.type = Utils.to_str(data['type'], '');
    item.title = Utils.to_str(data['title'], '');
    item.present = Utils.to_str(data['present'], '');
    item.absent = Utils.to_str(data['absent'], '');
    item.closed = Utils.to_str(data['closed'], '');
    item.expected = Utils.to_str(data['expected'], '');
    item.academic_class_id = Utils.to_str(data['academic_class_id'], '');
    item.subject_id = Utils.to_str(data['subject_id'], '');
    item.service_id = Utils.to_str(data['service_id'], '');
    item.administrator_id = Utils.to_str(data['administrator_id'], '');
    item.administrator_text = Utils.to_str(data['administrator_text'], '');
    item.academic_class_text = Utils.to_str(data['academic_class_text'], '');
    item.subject_text = Utils.to_str(data['subject_text'], '');
    item.stream_text = Utils.to_str(data['stream_text'], '');
    item.present_count = Utils.to_str(data['present_count'], '');
    item.absent_count = Utils.to_str(data['absent_count'], '');

    return item;
  }

  static Future<bool> initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "${SessionOnline.tableName} (id INTEGER PRIMARY KEY ,"
        "due_date TEXT,"
        "type TEXT,"
        "expected TEXT,"
        "title TEXT,"
        "absent TEXT,"
        "present TEXT,"
        "service_id TEXT,"
        "subject_id TEXT,"
        "closed TEXT,"
        "administrator_id TEXT,"
        "administrator_text TEXT,"
        "academic_class_text TEXT,"
        "subject_text TEXT,"
        "stream_text TEXT,"
        "present_count TEXT,"
        "absent_count TEXT,"
        "academic_class_id TEXT)";

    try {
      //await db.delete(SessionOnline.tableName);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');
      return false;
    }
    return true;
  }
}
