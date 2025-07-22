import 'dart:convert';
import 'dart:math';

import 'package:schooldynamics/models/RespondModel.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'TransportParticipantModel.dart';

class TripModelLocal {
  static String table_name = "trips_local_3";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String driver_id = "";
  String driver_text = "";
  String term_id = "";
  String term_text = "";
  String transport_route_id = "";
  String transport_route_text = "";
  String date = "";
  String status = "";
  String start_time = "";
  String end_time = "";
  String start_gps = "";
  String end_gps = "";
  String trip_direction = "";
  String start_mileage = "";
  String end_mileage = "";
  String expected_passengers = "0";
  String actual_passengers = "";
  String absent_passengers = "";
  String local_id = "";
  String local_text = "";
  String failed_message = "";

  Future<String> do_submit() async {
    Map<String, dynamic> data = {
      'trip': toJson(),
      'passengers': json.encode(passengers
          .map((e) => {
                'trip_id': e.trip_id,
                'status': e.status,
                'start_time': e.start_time,
                'end_time': e.end_time,
                'student_id': e.student_id,
              })
          .toList())
    };

    RespondModel? resp;
    try {
      resp = RespondModel(await Utils.http_post('trips-create', data));
    } catch (e) {
      failed_message = e.toString();
      status = 'Failed';
      await save();
      return e.toString();
    }

    if (resp.code != 1) {
      failed_message = resp.message;
      status = 'Failed';
      await save();
      return failed_message;
    }
    await delete();
    return "";
  }
  static fromJson(dynamic m) {
    TripModelLocal obj = TripModelLocal();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.driver_id = Utils.to_str(m['driver_id'], '');
    obj.driver_text = Utils.to_str(m['driver_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.transport_route_id = Utils.to_str(m['transport_route_id'], '');
    obj.transport_route_text = Utils.to_str(m['transport_route_text'], '');
    obj.date = Utils.to_str(m['date'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.start_time = Utils.to_str(m['start_time'], '');
    obj.end_time = Utils.to_str(m['end_time'], '');
    obj.start_gps = Utils.to_str(m['start_gps'], '');
    obj.end_gps = Utils.to_str(m['end_gps'], '');
    obj.trip_direction = Utils.to_str(m['trip_direction'], '');
    obj.start_mileage = Utils.to_str(m['start_mileage'], '');
    obj.end_mileage = Utils.to_str(m['end_mileage'], '');
    obj.expected_passengers = Utils.to_str(m['expected_passengers'], '');
    obj.actual_passengers = Utils.to_str(m['actual_passengers'], '');
    obj.absent_passengers = Utils.to_str(m['absent_passengers'], '');
    obj.local_id = Utils.to_str(m['local_id'], '');
    obj.local_text = Utils.to_str(m['local_text'], '');
    obj.failed_message = Utils.to_str(m['failed_message'], '');

    return obj;
  }

  static Future<List<TripModelLocal>> getLocalData({String where = "1"}) async {
    List<TripModelLocal> data = [];
    if (!(await TripModelLocal.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps =
        await db.query(table_name, where: where, orderBy: ' id DESC ');

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(TripModelLocal.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TripModelLocal>> get_items({String where = '1'}) async {
    List<TripModelLocal> data = await getLocalData(where: where);
    if (data.isEmpty) {
      data = await getLocalData(where: where);
    } else {}
    return data;
  }

  save() async {
    if (local_id.isEmpty) {
      local_id = DateTime.now().millisecondsSinceEpoch.toString();
      local_id += Random().nextInt(1000000).toString();
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      dynamic myData = toJson();
      if (id == 0) {
        myData.remove('id');
      }
      await db.insert(
        table_name,
        myData,
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    if (local_id.length < 3) {
      local_id = DateTime.now().millisecondsSinceEpoch.toString();
      local_id += Random().nextInt(1000000).toString();
    }
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'enterprise_id': enterprise_id,
      'enterprise_text': enterprise_text,
      'driver_id': driver_id,
      'driver_text': driver_text,
      'term_id': term_id,
      'term_text': term_text,
      'transport_route_id': transport_route_id,
      'transport_route_text': transport_route_text,
      'date': date,
      'status': status,
      'start_time': start_time,
      'end_time': end_time,
      'start_gps': start_gps,
      'end_gps': end_gps,
      'trip_direction': trip_direction,
      'start_mileage': start_mileage,
      'end_mileage': end_mileage,
      'expected_passengers': expected_passengers,
      'actual_passengers': actual_passengers,
      'absent_passengers': absent_passengers,
      'local_id': local_id,
      'local_text': local_text,
      'failed_message': failed_message,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "$table_name ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",driver_id TEXT"
        ",driver_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",transport_route_id TEXT"
        ",transport_route_text TEXT"
        ",date TEXT"
        ",status TEXT"
        ",start_time TEXT"
        ",end_time TEXT"
        ",start_gps TEXT"
        ",end_gps TEXT"
        ",trip_direction TEXT"
        ",start_mileage TEXT"
        ",end_mileage TEXT"
        ",expected_passengers TEXT"
        ",actual_passengers TEXT"
        ",absent_passengers TEXT"
        ",local_id TEXT"
        ",failed_message TEXT"
        ",local_text TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE ${table_name}");
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await TripModelLocal.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TripModelLocal.table_name);
  }

  delete() async {

    await TransportParticipantModel.delete(' trip_id = $id ');

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      Utils.toast("Failed to init local store.");
      return;
    }

    await initTable();

    try {
      await db.delete(table_name, where: 'id = $id');
    } catch (e) {
      Utils.toast("Failed to save student because ${e.toString()}");
    }
  }

  List<TransportParticipantModel> passengers = [];

  //get passengers
  Future<List<TransportParticipantModel>> getPassengers() async {
    passengers =
        await TransportParticipantModel.get_items(where: ' trip_id = $id ');
    return passengers;
  }
}
