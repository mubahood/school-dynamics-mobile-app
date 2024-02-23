import 'dart:convert';

import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class EnterpriseModel {
  static String end_point = "enterprises";
  static String tableName = "enterprises";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String name = "";
  String short_name = "";
  String details = "";
  String logo = "";
  String phone_number = "";
  String email = "";
  String address = "";
  String expiry = "";
  String administrator_id = "";
  String administrator_text = "";
  String subdomain = "";
  String color = "";
  String welcome_message = "";
  String type = "";
  String phone_number_2 = "";
  String p_o_box = "";
  String hm_signature = "";
  String dos_signature = "";
  String bursar_signature = "";
  String dp_year = "";
  String school_pay_code = "";
  String school_pay_password = "";
  String has_theology = "";
  String dp_term_id = "";
  String dp_term_text = "";
  String motto = "";
  String website = "";
  String hm_name = "";
  String wallet_balance = "";
  String can_send_messages = "";
  String has_valid_lisence = "";
  String school_pay_status = "";

  String getLogo() {
    return '${AppConfig.DASHBOARD_URL}/storage/${logo}';
  }

  static Future<EnterpriseModel> getEnt() async {
    EnterpriseModel ent = EnterpriseModel();
    String entText = await Utils.getPref('manifest');
    if (entText.isEmpty) {
      await getEntOnline();
      entText = await Utils.getPref('manifest');
    } else {
      await getEntOnline();
    }
    ent = EnterpriseModel.fromJson(json.decode(entText));
    if (ent.id == 0) {
      ent.name = 'School Dynamics';
      ent.short_name = 'SD';
      ent.details = 'School Dynamics';
      ent.logo = 'https://schooldynamics.org/assets/images/logo.png';
      ent.phone_number = '256 772 123 456';
      ent.email = 'info@schoooldynamics.ug';
      ent.address = 'Kampala, Uganda';
      ent.expiry = '2023-12-31';
      ent.administrator_id = '1';
      ent.administrator_text = 'Administrator';
      ent.subdomain = 'schooldynamics';
      ent.color = '#000000';
      ent.welcome_message = 'Welcome to School Dynamics';
      ent.type = 'Secondary';
      ent.phone_number_2 = '256 772 123 456';
      ent.p_o_box = 'P.O. Box 1234';
      ent.hm_signature = 'https://schooldynamics.org/assets/images/logo.png';
      ent.dos_signature = 'https://schooldynamics.org/assets/images/logo.png';
      ent.bursar_signature =
          'https://schooldynamics.org/assets/images/logo.png';
      ent.dp_year = '2023';
    }
    return ent;
  }

  static Future<void> getEntOnline() async {
    RespondModel resp = RespondModel(await Utils.http_get('manifest', {}));
    if (resp.code != 1) {
      return;
    }
    if (resp.data.toString().length > 3) {
      try {
        await Utils.setPref('manifest', json.encode(resp.data).toString());
      } catch (e) {
        print('Failed to save manifest because ${e.toString()}');
      }
    }
    return;
  }

  static fromJson(dynamic m) {
    EnterpriseModel obj = new EnterpriseModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.short_name = Utils.to_str(m['short_name'], '');
    obj.details = Utils.to_str(m['details'], '');
    obj.logo = Utils.to_str(m['logo'], '');
    obj.phone_number = Utils.to_str(m['phone_number'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.address = Utils.to_str(m['address'], '');
    obj.expiry = Utils.to_str(m['expiry'], '');
    obj.administrator_id = Utils.to_str(m['administrator_id'], '');
    obj.administrator_text = Utils.to_str(m['administrator_text'], '');
    obj.subdomain = Utils.to_str(m['subdomain'], '');
    obj.color = Utils.to_str(m['color'], '');
    obj.welcome_message = Utils.to_str(m['welcome_message'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.phone_number_2 = Utils.to_str(m['phone_number_2'], '');
    obj.p_o_box = Utils.to_str(m['p_o_box'], '');
    obj.hm_signature = Utils.to_str(m['hm_signature'], '');
    obj.dos_signature = Utils.to_str(m['dos_signature'], '');
    obj.bursar_signature = Utils.to_str(m['bursar_signature'], '');
    obj.dp_year = Utils.to_str(m['dp_year'], '');
    obj.school_pay_code = Utils.to_str(m['school_pay_code'], '');
    obj.school_pay_password = Utils.to_str(m['school_pay_password'], '');
    obj.has_theology = Utils.to_str(m['has_theology'], '');
    obj.dp_term_id = Utils.to_str(m['dp_term_id'], '');
    obj.dp_term_text = Utils.to_str(m['dp_term_text'], '');
    obj.motto = Utils.to_str(m['motto'], '');
    obj.website = Utils.to_str(m['website'], '');
    obj.hm_name = Utils.to_str(m['hm_name'], '');
    obj.wallet_balance = Utils.to_str(m['wallet_balance'], '');
    obj.can_send_messages = Utils.to_str(m['can_send_messages'], '');
    obj.has_valid_lisence = Utils.to_str(m['has_valid_lisence'], '');
    obj.school_pay_status = Utils.to_str(m['school_pay_status'], '');

    return obj;
  }

  static Future<List<EnterpriseModel>> getLocalData(
      {String where = "1"}) async {
    List<EnterpriseModel> data = [];
    if (!(await EnterpriseModel.initTable())) {
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
      data.add(EnterpriseModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<EnterpriseModel>> get_items({String where = '1'}) async {
    List<EnterpriseModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await EnterpriseModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      EnterpriseModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<EnterpriseModel>> getOnlineItems() async {
    return [];
    List<EnterpriseModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${EnterpriseModel.end_point}', {}));

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
        await EnterpriseModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          EnterpriseModel sub = EnterpriseModel.fromJson(x);
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
      'short_name': short_name,
      'details': details,
      'logo': logo,
      'phone_number': phone_number,
      'email': email,
      'address': address,
      'expiry': expiry,
      'administrator_id': administrator_id,
      'administrator_text': administrator_text,
      'subdomain': subdomain,
      'color': color,
      'welcome_message': welcome_message,
      'type': type,
      'phone_number_2': phone_number_2,
      'p_o_box': p_o_box,
      'hm_signature': hm_signature,
      'dos_signature': dos_signature,
      'bursar_signature': bursar_signature,
      'dp_year': dp_year,
      'school_pay_code': school_pay_code,
      'school_pay_password': school_pay_password,
      'has_theology': has_theology,
      'dp_term_id': dp_term_id,
      'dp_term_text': dp_term_text,
      'motto': motto,
      'website': website,
      'hm_name': hm_name,
      'wallet_balance': wallet_balance,
      'can_send_messages': can_send_messages,
      'has_valid_lisence': has_valid_lisence,
      'school_pay_status': school_pay_status,
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
        ",short_name TEXT"
        ",details TEXT"
        ",logo TEXT"
        ",phone_number TEXT"
        ",email TEXT"
        ",address TEXT"
        ",expiry TEXT"
        ",administrator_id TEXT"
        ",administrator_text TEXT"
        ",subdomain TEXT"
        ",color TEXT"
        ",welcome_message TEXT"
        ",type TEXT"
        ",phone_number_2 TEXT"
        ",p_o_box TEXT"
        ",hm_signature TEXT"
        ",dos_signature TEXT"
        ",bursar_signature TEXT"
        ",dp_year TEXT"
        ",school_pay_code TEXT"
        ",school_pay_password TEXT"
        ",has_theology TEXT"
        ",dp_term_id TEXT"
        ",dp_term_text TEXT"
        ",motto TEXT"
        ",website TEXT"
        ",hm_name TEXT"
        ",wallet_balance TEXT"
        ",can_send_messages TEXT"
        ",has_valid_lisence TEXT"
        ",school_pay_status TEXT"
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
    if (!(await EnterpriseModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(EnterpriseModel.tableName);
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
