import 'package:schooldynamics/utils/Utils.dart';
import 'package:sqflite/sqflite.dart';

import 'RespondModel.dart';

class ServiceSubscription {
  static String endPoint = "service-subscriptions";
  static String tableName = "service_subscriptions";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String service_id = "";
  String service_text = "";
  String administrator_id = "";
  String administrator_text = "";
  String quantity = "";
  String total = "";
  String due_academic_year_id = "";
  String due_academic_year_text = "";
  String due_term_id = "";
  String due_term_text = "";

  static fromJson(dynamic m) {
    ServiceSubscription obj = new ServiceSubscription();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.service_id = Utils.to_str(m['service_id'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.quantity = Utils.to_str(m['quantity'], '');
    obj.total = Utils.to_str(m['total'], '');
    obj.due_academic_year_id = Utils.to_str(m['due_academic_year_id'], '');
    obj.due_term_id = Utils.to_str(m['due_term_id'], '');
    obj.service_text = Utils.to_str(m['service_text'], '');
    obj.due_academic_year_text = Utils.to_str(m['due_academic_year_text'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');
    obj.due_term_text = Utils.to_str(m['due_term_text'], '');

    return obj;
  }

  static Future<List<ServiceSubscription>> getLocalData(
      {String where = "1"}) async {
    List<ServiceSubscription> data = [];
    if (!(await ServiceSubscription.initTable())) {
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
      print("======>${maps[i]['service_text'].toString()}<=======");
      data.add(ServiceSubscription.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<ServiceSubscription>> getItems(
      {String where = '1'}) async {
    List<ServiceSubscription> data = await getLocalData(where: where);
    if (data.isEmpty && where.length < 2) {
      await ServiceSubscription.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      ServiceSubscription.getOnlineItems();
    }
    data.sort((a, b) => b.id.compareTo(a.id));
    return data;
  }

  static Future<List<ServiceSubscription>> getOnlineItems() async {
    List<ServiceSubscription> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${ServiceSubscription.endPoint}', {}));

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
        await ServiceSubscription.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          ServiceSubscription sub = ServiceSubscription.fromJson(x);
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
      'service_id': service_id,
      'administrator_id': administrator_id,
      'quantity': quantity,
      'total': total,
      'due_academic_year_id': due_academic_year_id,
      'due_term_id': due_term_id,
      'service_text': service_text,
      'due_academic_year_text': due_academic_year_text,
      'administrator_text': administrator_text,
      'due_term_text': due_term_text,
    };
  }

  static Future initTable() async {
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }

    String sql = " CREATE TABLE IF NOT EXISTS "
        "service_subscriptions ("
        "id INTEGER PRIMARY KEY"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",service_id TEXT"
        ",service_text TEXT"
        ",administrator_id TEXT"
        ",administrator_text TEXT"
        ",quantity TEXT"
        ",total TEXT"
        ",due_academic_year_id TEXT"
        ",due_academic_year_text TEXT"
        ",due_term_id TEXT"
        ",due_term_text TEXT"
        ")";

    try {
      //await db.delete(tableName);

      await db.execute(sql);
    } catch (e) {
      Utils.log('Failed to create table because ${e.toString()}');

      return false;
    }

    return true;
  }

  static deleteAll() async {
    if (!(await ServiceSubscription.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(ServiceSubscription.tableName);
  }
}
