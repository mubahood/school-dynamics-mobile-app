import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TripModelOnline {
  static String end_point = "trips";
  static String tableName = "trips_online";
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
  String expected_passengers = "";
  String actual_passengers = "";
  String absent_passengers = "";
  String local_id = "";
  String local_text = "";

  static fromJson(dynamic m) {
    TripModelOnline obj = new TripModelOnline();
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

    return obj;
  }

  static Future<List<TripModelOnline>> getLocalData(
      {String where = "1"}) async {
    List<TripModelOnline> data = [];
    if (!(await TripModelOnline.initTable())) {
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
      data.add(TripModelOnline.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TripModelOnline>> get_items({String where = '1'}) async {
    List<TripModelOnline> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TripModelOnline.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TripModelOnline.getOnlineItems();
    }
    return data;
  }

  static Future<List<TripModelOnline>> getOnlineItems() async {
    List<TripModelOnline> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${TripModelOnline.end_point}', {}));

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
        await TripModelOnline.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TripModelOnline sub = TripModelOnline.fromJson(x);
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
        ",local_text TEXT"
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
    if (!(await TripModelOnline.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TripModelOnline.tableName);
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
