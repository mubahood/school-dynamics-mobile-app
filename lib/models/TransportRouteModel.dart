import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TransportRouteModel {
  static String end_point = "transport-routes";
  static String tableName = "transport_routes";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String name = "";
  String description = "";
  String single_trip_fare = "";
  String round_trip_fare = "";

  static fromJson(dynamic m) {
    TransportRouteModel obj = new TransportRouteModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.single_trip_fare = Utils.to_str(m['single_trip_fare'], '');
    obj.round_trip_fare = Utils.to_str(m['round_trip_fare'], '');

    return obj;
  }

  static Future<List<TransportRouteModel>> getLocalData(
      {String where = "1"}) async {
    List<TransportRouteModel> data = [];
    if (!(await TransportRouteModel.initTable())) {
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
      data.add(TransportRouteModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TransportRouteModel>> get_items(
      {String where = '1'}) async {
    List<TransportRouteModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TransportRouteModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TransportRouteModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<TransportRouteModel>> getOnlineItems() async {
    List<TransportRouteModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${TransportRouteModel.end_point}', {}));

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
        await TransportRouteModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TransportRouteModel sub = TransportRouteModel.fromJson(x);
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
      'name': name,
      'description': description,
      'single_trip_fare': single_trip_fare,
      'round_trip_fare': round_trip_fare,
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
        ",name TEXT"
        ",description TEXT"
        ",single_trip_fare TEXT"
        ",round_trip_fare TEXT"
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
    if (!(await TransportRouteModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TransportRouteModel.tableName);
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
