import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class TransportSubscriptionModel {
  static String end_point = "transport-subscriptions";
  static String tableName = "transport_subscriptions";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String user_id = "";
  String user_text = "";
  String transport_route_id = "";
  String transport_route_text = "";
  String term_id = "";
  String term_text = "";
  String status = "";
  String trip_type = "";
  String amount = "";
  String description = "";
  String service_subscription_id = "";
  String service_subscription_text = "";


  static fromJson(dynamic m) {
    TransportSubscriptionModel obj = new TransportSubscriptionModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.transport_route_id = Utils.to_str(m['transport_route_id'], '');
    obj.transport_route_text = Utils.to_str(m['transport_route_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.trip_type = Utils.to_str(m['trip_type'], '');
    obj.amount = Utils.to_str(m['amount'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.service_subscription_id =
        Utils.to_str(m['service_subscription_id'], '');
    obj.service_subscription_text =
        Utils.to_str(m['service_subscription_text'], '');

    return obj;
  }

  static Future<List<TransportSubscriptionModel>> getLocalData(
      {String where = "1"}) async {
    List<TransportSubscriptionModel> data = [];
    if (!(await TransportSubscriptionModel.initTable())) {
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
      data.add(TransportSubscriptionModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<TransportSubscriptionModel>> get_items(
      {String where = '1'}) async {
    List<TransportSubscriptionModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await TransportSubscriptionModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      TransportSubscriptionModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<TransportSubscriptionModel>> getOnlineItems() async {
    List<TransportSubscriptionModel> data = [];

    RespondModel resp = RespondModel(
        await Utils.http_get('${TransportSubscriptionModel.end_point}', {}));

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
        await TransportSubscriptionModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          TransportSubscriptionModel sub =
              TransportSubscriptionModel.fromJson(x);
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
      'user_id': user_id,
      'user_text': user_text,
      'transport_route_id': transport_route_id,
      'transport_route_text': transport_route_text,
      'term_id': term_id,
      'term_text': term_text,
      'status': status,
      'trip_type': trip_type,
      'amount': amount,
      'description': description,
      'service_subscription_id': service_subscription_id,
      'service_subscription_text': service_subscription_text,
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
        ",user_id TEXT"
        ",user_text TEXT"
        ",transport_route_id TEXT"
        ",transport_route_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",status TEXT"
        ",trip_type TEXT"
        ",amount TEXT"
        ",description TEXT"
        ",service_subscription_id TEXT"
        ",service_subscription_text TEXT"
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
    if (!(await TransportSubscriptionModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(TransportSubscriptionModel.tableName);
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
