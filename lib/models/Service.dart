import 'package:schooldynamics/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import 'RespondModel.dart';

class ServiceModel {
  static String endPoint = "services";
  static String tableName = "services";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String name = "";
  String description = "";
  String fee = "";
  String service_category_id = "";
  String service_category_text = "";

  static fromJson(dynamic m) {
    ServiceModel obj = ServiceModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.fee = Utils.to_str(m['fee'], '');
    obj.service_category_id = Utils.to_str(m['service_category_id'], '');

    return obj;
  }

  static Future<List<ServiceModel>> getLocalData({String where = "1"}) async {
    List<ServiceModel> data = [];
    if (!(await ServiceModel.initTable())) {
      Utils.toast("Failed to init dynamic store.");
      return data;
    }

    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return data;
    }

    List<Map> maps = await db.query(tableName, where: where);

    if (maps.isEmpty) {
      return data;
    }
    List.generate(maps.length, (i) {
      data.add(ServiceModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ServiceModel>> getItems({String where = '1'}) async {
    List<ServiceModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await ServiceModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      ServiceModel.getOnlineItems();
    }
    data.sort((a, b) => b.name.compareTo(a.name));
    return data;
  }

  static Future<List<ServiceModel>> getOnlineItems() async {
    List<ServiceModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get(ServiceModel.endPoint, {}));

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
        await ServiceModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ServiceModel sub = ServiceModel.fromJson(x);
          try {
            batch.insert(tableName, sub.toJson(),
                conflictAlgorithm: ConflictAlgorithm.replace);
          } catch (e) {

          }
        }

        try {
          await batch.commit(continueOnError: true);
        } catch (e) {
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
      'name': name,
      'description': description,
      'fee': fee,
      'service_category_id': service_category_id,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "services ("
        "id INTEGER PRIMARY KEY"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",name TEXT"
        ",description TEXT"
        ",fee TEXT"
        ",service_category_id TEXT"
        ",service_category_text TEXT"
        ")";

    try {
      //await db.execute("DROP TABLE "+tableName);
      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await ServiceModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(ServiceModel.tableName);
  }
}
