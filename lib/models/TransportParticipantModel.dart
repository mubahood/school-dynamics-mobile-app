import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';

class TransportParticipantModel {
  static String tableName = "transport_participants_1";
  int id = 0;
  int trip_id = 0;
  String name = "";
  String avatar = "";
  String status = "";
  String start_time = "";
  String end_time = "";
  String student_id = "";

  static fromJson(dynamic m) {
    TransportParticipantModel obj = new TransportParticipantModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.trip_id = Utils.int_parse(m['trip_id']);
    obj.name = Utils.to_str(m['name'], '');
    obj.avatar = Utils.to_str(m['avatar'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.start_time = Utils.to_str(m['start_time'], '');
    obj.end_time = Utils.to_str(m['end_time'], '');
    obj.student_id = Utils.to_str(m['student_id'], '');

    return obj;
  }

  static Future<List<TransportParticipantModel>> getLocalData(
      {String where = "1"}) async {
    List<TransportParticipantModel> data = [];
    if (!(await TransportParticipantModel.initTable())) {
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
      data.add(TransportParticipantModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TransportParticipantModel>> get_items(
      {String where = '1'}) async {
    List<TransportParticipantModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      data = await getLocalData(where: where);
    } else {}
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
      dynamic my_data = toJson();
      if (id == 0) {
        my_data.remove('id');
      }

      await db.insert(
        tableName,
        my_data,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'trip_id': trip_id,
      'name': name,
      'avatar': avatar,
      'status': status,
      'start_time': start_time,
      'end_time': end_time,
      'student_id': student_id,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$tableName ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT"
        ",trip_id TEXT"
        ",name TEXT"
        ",avatar TEXT"
        ",status TEXT"
        ",start_time TEXT"
        ",end_time TEXT"
        ",student_id TEXT"
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
    if (!(await TransportParticipantModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TransportParticipantModel.tableName);
  }

  static Future<void> delete(String where) async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(tableName, where: where);
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }
}
