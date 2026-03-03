import 'package:sqflite/sqflite.dart';

import '../../utils/Utils.dart';
import '../RespondModel.dart';

class Participant {
  static String end_point = "participants";
  static String tableName = "participants_2";
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
  String is_present = "";
  String session_id = "";
  String session_text = "";
  String type = "";
  String title = "";
  String is_done = "";
  String avatar = "";

  bool p(){
    return is_present.toLowerCase() == '1';
  }

  /// Returns a human-readable description of the attendance session.
  String getDisplayText() {
    // Prefer the session title stored on the record (most descriptive).
    if (title.isNotEmpty) {
      // The title is stored as e.g. "CLASS_ATTENDANCE, SECULAR_STREAM - P.2 - 2026 - RED".
      // Strip the leading type prefix so the UI shows only the class/stream part.
      final String cleaned = title
          .replaceFirst(RegExp(r'^[A-Z_]+,\s*'), '')
          .trim();
      return cleaned.isNotEmpty ? cleaned : _formatType();
    }
    // Fall back to subject or service if available.
    if (subject_text.length > 2) {
      return academic_class_text.length > 2
          ? '$academic_class_text · $subject_text'
          : subject_text;
    }
    if (service_text.length > 2) return service_text;
    // Last resort: format the type enum.
    return _formatType();
  }

  String _formatType() {
    if (type.isEmpty) return session_text.isNotEmpty ? session_text : 'Attendance';
    return type
        .split('_')
        .map((w) => w.isEmpty
            ? ''
            : '${w[0].toUpperCase()}${w.substring(1).toLowerCase()}')
        .join(' ');
  }

  static fromJson(dynamic m) {
    Participant obj = Participant();
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
    obj.is_present = Utils.to_str(m['is_present'], '');
    obj.session_id = Utils.to_str(m['session_id'], '');
    obj.session_text = Utils.to_str(m['session_text'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.title = Utils.to_str(m['title'], '');
    obj.is_done = Utils.to_str(m['is_done'], '');
    obj.avatar = Utils.to_str(m['avatar'], '');

    return obj;
  }

  static Future<List<Participant>> getLocalData({String where = "1"}) async {
    List<Participant> data = [];
    if (!(await Participant.initTable())) {
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
      data.add(Participant.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<Participant>> get_items({String where = '1'}) async {
    List<Participant> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await Participant.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      Participant.getOnlineItems();
    }
    return data;
  }

  static Future<List<Participant>> getOnlineItems() async {
    List<Participant> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(Participant.end_point, {}));

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
        await Participant.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          Participant sub = Participant.fromJson(x);
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
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'academic_year_id': academic_year_id,
      'academic_year_text': academic_year_text,
      'term_id': term_id,
      'term_text': term_text,
      'academic_class_id': academic_class_id,
      'academic_class_text': academic_class_text,
      'subject_id': subject_id,
      'subject_text': subject_text,
      'service_id': service_id,
      'service_text': service_text,
      'is_present': is_present,
      'session_id': session_id,
      'session_text': session_text,
      'type': type,
      'title': title,
      'is_done': is_done,
      'avatar': avatar,
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
        ",is_present TEXT"
        ",session_id TEXT"
        ",session_text TEXT"
        ",type TEXT"
        ",title TEXT"
        ",is_done TEXT"
        ",avatar TEXT"
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
    if (!(await Participant.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(Participant.tableName);
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
