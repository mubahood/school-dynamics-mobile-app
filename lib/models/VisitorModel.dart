import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class VisitorModel {
  static String end_point = "visitors";
  static String tableName = "visitors";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String name = "";
  String nin = "";
  String phone_number = "";
  String email = "";
  String organization = "";
  String address = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String number_of_visits = "";

  bool isLikeSameNumber(String num) {
    num = num.trim();
    if (num.isEmpty) {
      return false;
    }
    if (phone_number.contains(num)) {
      return true;
    }
    //check if it starts with 0
    if (num.startsWith('0')) {
      //remove the start 0
      num = num.substring(1);
    }
    if (phone_number.contains(num)) {
      return true;
    }
    return false;
  }

  bool hasSameNumber(String num) {
    num = num.trim();
    if (num == phone_number) {
      return true;
    }
    String prepared_1 = Utils.prepare_phone_number(num);
    if (prepared_1 == phone_number) {
      return true;
    }
    String prepared_2 = Utils.prepare_phone_number(phone_number);
    if (prepared_2 == num) {
      return true;
    }
    return false;
  }

  static fromJson(dynamic m) {
    VisitorModel obj = new VisitorModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.nin = Utils.to_str(m['nin'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.organization = Utils.to_str(m['organization'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.number_of_visits = Utils.to_str(m['number_of_visits'], '');

    return obj;
  }

  static Future<List<VisitorModel>> getLocalData({String where = "1"}) async {
    List<VisitorModel> data = [];
    if (!(await VisitorModel.initTable())) {
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
      data.add(VisitorModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<VisitorModel>> get_items({String where = '1'}) async {
    List<VisitorModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await VisitorModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      VisitorModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<VisitorModel>> getOnlineItems() async {
    List<VisitorModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${VisitorModel.end_point}', {}));

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
        await VisitorModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          VisitorModel sub = VisitorModel.fromJson(x);
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
      print("Failed to save student because ${e.toString()}");
    }
  }

  toJson() {
    return {
      'id': id,
      'created_at': created_at,
      'updated_at': updated_at,
      'name': name,
      'nin': nin,
      'phone_number': phone_number,
      'email': email,
      'organization': organization,
      'address': address,
      'enterprise_id': enterprise_id,
      'enterprise_text': enterprise_text,
      'number_of_visits': number_of_visits,
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
        ",nin TEXT"
        ",phone_number TEXT"
        ",email TEXT"
        ",organization TEXT"
        ",address TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",number_of_visits TEXT"
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
    if (!(await VisitorModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(VisitorModel.tableName);
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
