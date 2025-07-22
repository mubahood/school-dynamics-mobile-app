import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class VisitorRecordModelOnline {
  static String end_point = "visitors-records";
  static String tableName = "visitor_records_online_1";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String visitor_id = "";
  String visitor_text = "";
  String purpose_staff_id = "";
  String purpose_staff_text = "";
  String purpose_student_id = "";
  String purpose_student_text = "";
  String name = "";
  String phone_number = "";
  String organization = "";
  String email = "";
  String address = "";
  String nin = "";
  String check_in_time = "";
  String check_out_time = "";
  String purpose = "";
  String purpose_description = "";
  String purpose_office = "";
  String purpose_other = "";
  String signature_src = "";
  String signature_path = "";
  String local_id = "";
  String local_text = "";
  String lacal_id = "";
  String lacal_text = "";
  String has_car = "";
  String car_reg = "";
  String due_term_id = "";
  String due_term_text = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String created_by_id = "";
  String created_by_text = "";
  String status = "";

  static fromJson(dynamic m) {
    VisitorRecordModelOnline obj = VisitorRecordModelOnline();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.visitor_id = Utils.to_str(m['visitor_id'], '');
    obj.visitor_text = Utils.to_str(m['visitor_text'], '');
    obj.purpose_staff_id = Utils.to_str(m['purpose_staff_id'], '');
    obj.purpose_staff_text = Utils.to_str(m['purpose_staff_text'], '');
    obj.purpose_student_id = Utils.to_str(m['purpose_student_id'], '');
    obj.purpose_student_text = Utils.to_str(m['purpose_student_text'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.organization = Utils.to_str(m['organization'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.nin = Utils.to_str(m['nin'], '');
    obj.check_in_time = Utils.to_str(m['check_in_time'], '');
    obj.check_out_time = Utils.to_str(m['check_out_time'], '');
    obj.purpose = Utils.to_str(m['purpose'], '');
    obj.purpose_description = Utils.to_str(m['purpose_description'], '');
    obj.purpose_office = Utils.to_str(m['purpose_office'], '');
    obj.purpose_other = Utils.to_str(m['purpose_other'], '');
    obj.signature_src = Utils.to_str(m['signature_src'], '');
    obj.signature_path = Utils.to_str(m['signature_path'], '');
    obj.local_id = Utils.to_str(m['local_id'], '');
    obj.local_text = Utils.to_str(m['local_text'], '');
    obj.lacal_id = Utils.to_str(m['lacal_id'], '');
    obj.lacal_text = Utils.to_str(m['lacal_text'], '');
    obj.has_car = Utils.to_str(m['has_car'], '');
    obj.car_reg = Utils.to_str(m['car_reg'], '');
    obj.due_term_id = Utils.to_str(m['due_term_id'], '');
    obj.due_term_text = Utils.to_str(m['due_term_text'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.created_by_id = Utils.to_str(m['created_by_id'], '');
    obj.created_by_text = Utils.to_str(m['created_by_text'], '');
    obj.status = Utils.to_str(m['status'], '');

    return obj;
  }

  static Future<List<VisitorRecordModelOnline>> getLocalData(
      {String where = "1"}) async {
    List<VisitorRecordModelOnline> data = [];
    if (!(await VisitorRecordModelOnline.initTable())) {
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
      data.add(VisitorRecordModelOnline.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<VisitorRecordModelOnline>> get_items(
      {String where = '1'}) async {
    List<VisitorRecordModelOnline> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await VisitorRecordModelOnline.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      VisitorRecordModelOnline.getOnlineItems();
    }
    return data;
  }

  static Future<List<VisitorRecordModelOnline>> getOnlineItems() async {
    List<VisitorRecordModelOnline> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(VisitorRecordModelOnline.end_point, {}));

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
        await VisitorRecordModelOnline.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          VisitorRecordModelOnline sub = VisitorRecordModelOnline.fromJson(x);
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
      'visitor_id': visitor_id,
      'visitor_text': visitor_text,
      'purpose_staff_id': purpose_staff_id,
      'purpose_staff_text': purpose_staff_text,
      'purpose_student_id': purpose_student_id,
      'purpose_student_text': purpose_student_text,
      'name': name,
      'phone_number': phone_number,
      'organization': organization,
      'email': email,
      'address': address,
      'nin': nin,
      'check_in_time': check_in_time,
      'check_out_time': check_out_time,
      'purpose': purpose,
      'purpose_description': purpose_description,
      'purpose_office': purpose_office,
      'purpose_other': purpose_other,
      'signature_src': signature_src,
      'signature_path': signature_path,
      'local_id': local_id,
      'local_text': local_text,
      'lacal_id': lacal_id,
      'lacal_text': lacal_text,
      'has_car': has_car,
      'car_reg': car_reg,
      'due_term_id': due_term_id,
      'due_term_text': due_term_text,
      'enterprise_id': enterprise_id,
      'enterprise_text': enterprise_text,
      'created_by_id': created_by_id,
      'created_by_text': created_by_text,
      'status': status,
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
        ",visitor_id TEXT"
        ",visitor_text TEXT"
        ",purpose_staff_id TEXT"
        ",purpose_staff_text TEXT"
        ",purpose_student_id TEXT"
        ",purpose_student_text TEXT"
        ",name TEXT"
        ",phone_number TEXT"
        ",organization TEXT"
        ",email TEXT"
        ",address TEXT"
        ",nin TEXT"
        ",check_in_time TEXT"
        ",check_out_time TEXT"
        ",purpose TEXT"
        ",purpose_description TEXT"
        ",purpose_office TEXT"
        ",purpose_other TEXT"
        ",signature_src TEXT"
        ",signature_path TEXT"
        ",local_id TEXT"
        ",local_text TEXT"
        ",lacal_id TEXT"
        ",lacal_text TEXT"
        ",has_car TEXT"
        ",car_reg TEXT"
        ",due_term_id TEXT"
        ",due_term_text TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",created_by_id TEXT"
        ",created_by_text TEXT"
        ",status TEXT"
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
    if (!(await VisitorRecordModelOnline.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(VisitorRecordModelOnline.tableName);
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

  bool isOut() {
    if (status.toLowerCase() != 'out') {
      return false;
    }
    return true;
  }
}
