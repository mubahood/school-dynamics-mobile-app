import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TransportVehicleModel {
  static String end_point = "transport-vehicles";
  static String tableName = "transport_vehicles";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String name = "";
  String registration_number = "";
  String type = "";
  String description = "";
  String enterprise_id = "";
  String enterprise_text = "";

  static fromJson(dynamic m) {
    TransportVehicleModel obj = TransportVehicleModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.registration_number = Utils.to_str(m['registration_number'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');

    return obj;
  }

  static Future<List<TransportVehicleModel>> getLocalData(
      {String where = "1"}) async {
    List<TransportVehicleModel> data = [];
    if (!(await TransportVehicleModel.initTable())) {
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
      data.add(TransportVehicleModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TransportVehicleModel>> get_items(
      {String where = '1'}) async {
    List<TransportVehicleModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TransportVehicleModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TransportVehicleModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<TransportVehicleModel>> getOnlineItems() async {
    List<TransportVehicleModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get(TransportVehicleModel.end_point, {}));

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
        await TransportVehicleModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TransportVehicleModel sub = TransportVehicleModel.fromJson(x);
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
      'name': name,
      'registration_number': registration_number,
      'type': type,
      'description': description,
      'enterprise_id': enterprise_id,
      'enterprise_text': enterprise_text,
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
        ",name TEXT"
        ",registration_number TEXT"
        ",type TEXT"
        ",description TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
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
    if (!(await TransportVehicleModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TransportVehicleModel.tableName);
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
