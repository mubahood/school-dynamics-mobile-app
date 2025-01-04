import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class UserModel {
  static String tableName = "my_students_10";
  static String end_point = "my-students";
  int id = 0;
  String username = "";
  String password = "";
  String name = "";
  String avatar = "";
  String remember_token = "";
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String first_name = "";
  String last_name = "";
  String date_of_birth = "";
  String place_of_birth = "";
  String sex = "";
  String home_address = "";
  String current_address = "";
  String phone_number_1 = "";
  String phone_number_2 = "";
  String email = "";
  String nationality = "";
  String religion = "";
  String spouse_name = "";
  String spouse_phone = "";
  String father_name = "";
  String father_phone = "";
  String mother_name = "";
  String mother_phone = "";
  String languages = "";
  String emergency_person_name = "";
  String emergency_person_phone = "";
  String national_id_number = "";
  String national_text_number = "";
  String passport_number = "";
  String tin = "";
  String nssf_number = "";
  String bank_name = "";
  String bank_account_number = "";
  String primary_school_name = "";
  String primary_school_year_graduated = "";
  String seconday_school_name = "";
  String seconday_school_year_graduated = "";
  String high_school_name = "";
  String high_school_year_graduated = "";
  String degree_university_name = "";
  String degree_university_year_graduated = "";
  String masters_university_name = "";
  String masters_university_year_graduated = "";
  String phd_university_name = "";
  String phd_university_year_graduated = "";
  String user_type = "";
  String demo_id = "";
  String demo_text = "";
  String user_id = "";
  String user_text = "";
  String user_batch_importer_id = "";
  String user_batch_importer_text = "";
  String school_pay_account_id = "";
  String school_pay_account_text = "";
  String school_pay_payment_code = "";
  String given_name = "";
  String deleted_at = "";
  String marital_status = "";
  String verification = "";
  String current_class_id = "";
  String current_class_text = "";
  String current_theology_class_id = "";
  String current_theology_class_text = "";
  String status = "";
  String parent_id = "";
  String parent_text = "";
  String main_role_id = "";
  String main_role_text = "";
  String stream_id = "";
  String stream_text = "";
  String account_id = "";
  String account_text = "";
  String has_personal_info = "";
  String has_educational_info = "";
  String has_account_info = "";
  String diploma_school_name = "";
  String diploma_year_graduated = "";
  String certificate_school_name = "";
  String certificate_year_graduated = "";
  String theology_stream_id = "";
  String theology_stream_text = "";
  String lin = "";
  String occupation = "";
  String last_seen = "";
  String supervisor_id = "";
  String supervisor_text = "";
  String user_number = "";
  String token = "";
  String roles_text = "";
  String residence = "";
  String plain_password = "";
  String mail_verification_token = "";
  String confirm_password = "";
  int balance = 0;

  static fromJson(dynamic m) {
    UserModel obj = new UserModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.username = Utils.to_str(m['username'], '');
    obj.password = Utils.to_str(m['password'], '');
    obj.name = Utils.to_str(m['name'], '');
    obj.avatar = Utils.to_str(m['avatar'], '');
    obj.remember_token = Utils.to_str(m['remember_token'], '');
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.first_name = Utils.to_str(m['first_name'], '');
    obj.last_name = Utils.to_str(m['last_name'], '');
    obj.date_of_birth = Utils.to_str(m['date_of_birth'], '');
    obj.place_of_birth = Utils.to_str(m['place_of_birth'], '');
    obj.sex = Utils.to_str(m['sex'], '');
    obj.home_address = Utils.to_str(m['home_address'], '');
    obj.current_address = Utils.to_str(m['current_address'], '');
    obj.phone_number_1 = Utils.to_str(m['phone_number_1'], '');
    obj.phone_number_2 = Utils.to_str(m['phone_number_2'], '');
    obj.email = Utils.to_str(m['email'], '');
    obj.nationality = Utils.to_str(m['nationality'], '');
    obj.religion = Utils.to_str(m['religion'], '');
    obj.spouse_name = Utils.to_str(m['spouse_name'], '');
    obj.spouse_phone = Utils.to_str(m['spouse_phone'], '');
    obj.father_name = Utils.to_str(m['father_name'], '');
    obj.father_phone = Utils.to_str(m['father_phone'], '');
    obj.mother_name = Utils.to_str(m['mother_name'], '');
    obj.mother_phone = Utils.to_str(m['mother_phone'], '');
    obj.languages = Utils.to_str(m['languages'], '');
    obj.emergency_person_name = Utils.to_str(m['emergency_person_name'], '');
    obj.emergency_person_phone = Utils.to_str(m['emergency_person_phone'], '');
    obj.national_id_number = Utils.to_str(m['national_id_number'], '');
    obj.balance = Utils.int_parse(m['balance']);
    obj.national_text_number = Utils.to_str(m['national_text_number'], '');
    obj.passport_number = Utils.to_str(m['passport_number'], '');
    obj.tin = Utils.to_str(m['tin'], '');
    obj.nssf_number = Utils.to_str(m['nssf_number'], '');
    obj.bank_name = Utils.to_str(m['bank_name'], '');
    obj.bank_account_number = Utils.to_str(m['bank_account_number'], '');
    obj.primary_school_name = Utils.to_str(m['primary_school_name'], '');
    obj.primary_school_year_graduated =
        Utils.to_str(m['primary_school_year_graduated'], '');
    obj.seconday_school_name = Utils.to_str(m['seconday_school_name'], '');
    obj.seconday_school_year_graduated =
        Utils.to_str(m['seconday_school_year_graduated'], '');
    obj.high_school_name = Utils.to_str(m['high_school_name'], '');
    obj.high_school_year_graduated =
        Utils.to_str(m['high_school_year_graduated'], '');
    obj.degree_university_name = Utils.to_str(m['degree_university_name'], '');
    obj.degree_university_year_graduated =
        Utils.to_str(m['degree_university_year_graduated'], '');
    obj.masters_university_name =
        Utils.to_str(m['masters_university_name'], '');
    obj.masters_university_year_graduated =
        Utils.to_str(m['masters_university_year_graduated'], '');
    obj.phd_university_name = Utils.to_str(m['phd_university_name'], '');
    obj.phd_university_year_graduated =
        Utils.to_str(m['phd_university_year_graduated'], '');
    obj.user_type = Utils.to_str(m['user_type'], '');
    obj.demo_id = Utils.to_str(m['demo_id'], '');
    obj.demo_text = Utils.to_str(m['demo_text'], '');
    obj.user_id = Utils.to_str(m['user_id'], '');
    obj.user_text = Utils.to_str(m['user_text'], '');
    obj.user_batch_importer_id = Utils.to_str(m['user_batch_importer_id'], '');
    obj.user_batch_importer_text =
        Utils.to_str(m['user_batch_importer_text'], '');
    obj.school_pay_account_id = Utils.to_str(m['school_pay_account_id'], '');
    obj.school_pay_account_text =
        Utils.to_str(m['school_pay_account_text'], '');
    obj.school_pay_payment_code =
        Utils.to_str(m['school_pay_payment_code'], '');
    obj.given_name = Utils.to_str(m['given_name'], '');
    obj.deleted_at = Utils.to_str(m['deleted_at'], '');
    obj.marital_status = Utils.to_str(m['marital_status'], '');
    obj.verification = Utils.to_str(m['verification'], '');
    obj.current_class_id = Utils.to_str(m['current_class_id'], '');
    obj.current_class_text = Utils.to_str(m['current_class_text'], '');
    obj.current_theology_class_id =
        Utils.to_str(m['current_theology_class_id'], '');
    obj.current_theology_class_text =
        Utils.to_str(m['current_theology_class_text'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.parent_id = Utils.to_str(m['parent_id'], '');
    obj.parent_text = Utils.to_str(m['parent_text'], '');
    obj.main_role_id = Utils.to_str(m['main_role_id'], '');
    obj.main_role_text = Utils.to_str(m['main_role_text'], '');
    obj.stream_id = Utils.to_str(m['stream_id'], '');
    obj.stream_text = Utils.to_str(m['stream_text'], '');
    obj.account_id = Utils.to_str(m['account_id'], '');
    obj.account_text = Utils.to_str(m['account_text'], '');
    obj.has_personal_info = Utils.to_str(m['has_personal_info'], '');
    obj.has_educational_info = Utils.to_str(m['has_educational_info'], '');
    obj.has_account_info = Utils.to_str(m['has_account_info'], '');
    obj.diploma_school_name = Utils.to_str(m['diploma_school_name'], '');
    obj.diploma_year_graduated = Utils.to_str(m['diploma_year_graduated'], '');
    obj.certificate_school_name =
        Utils.to_str(m['certificate_school_name'], '');
    obj.certificate_year_graduated =
        Utils.to_str(m['certificate_year_graduated'], '');
    obj.theology_stream_id = Utils.to_str(m['theology_stream_id'], '');
    obj.theology_stream_text = Utils.to_str(m['theology_stream_text'], '');
    obj.lin = Utils.to_str(m['lin'], '');
    obj.occupation = Utils.to_str(m['occupation'], '');
    obj.last_seen = Utils.to_str(m['last_seen'], '');
    obj.supervisor_id = Utils.to_str(m['supervisor_id'], '');
    obj.supervisor_text = Utils.to_str(m['supervisor_text'], '');
    obj.user_number = Utils.to_str(m['user_number'], '');
    obj.token = Utils.to_str(m['token'], '');
    obj.roles_text = Utils.to_str(m['roles_text'], '');
    obj.residence = Utils.to_str(m['residence'], '');
    obj.plain_password = Utils.to_str(m['plain_password'], '');
    obj.mail_verification_token =
        Utils.to_str(m['mail_verification_token'], '');

    return obj;
  }

  static Future<UserModel> getItemById(String id) async {
    UserModel item = UserModel();
    try {
      List<UserModel> items = await UserModel.getItems(where : "id = ${id}");
      if (items.isNotEmpty) {
        item = items.first;
      }
    } catch (E) {
      item = UserModel();
    }
    return item;
  }

  static Future<List<UserModel>> getLocalData({String where = "1"}) async {
    List<UserModel> data = [];
    if (!(await UserModel.initTable())) {
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
      data.add(UserModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<UserModel>> getItems({String where = '1'}) async {
    List<UserModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await UserModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      UserModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<UserModel>> getOnlineItems() async {
    List<UserModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${UserModel.end_point}', {}));

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
        await UserModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          UserModel sub = UserModel.fromJson(x);
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
      'username': username,
      'password': password,
      'name': name,
      'avatar': avatar,
      'remember_token': remember_token,
      'created_at': created_at,
      'updated_at': updated_at,
      'enterprise_id': enterprise_id,
      'enterprise_text': enterprise_text,
      'first_name': first_name,
      'last_name': last_name,
      'date_of_birth': date_of_birth,
      'place_of_birth': place_of_birth,
      'sex': sex,
      'home_address': home_address,
      'current_address': current_address,
      'phone_number_1': phone_number_1,
      'phone_number_2': phone_number_2,
      'email': email,
      'nationality': nationality,
      'religion': religion,
      'spouse_name': spouse_name,
      'spouse_phone': spouse_phone,
      'father_name': father_name,
      'father_phone': father_phone,
      'mother_name': mother_name,
      'mother_phone': mother_phone,
      'languages': languages,
      'emergency_person_name': emergency_person_name,
      'emergency_person_phone': emergency_person_phone,
      'national_id_number': national_id_number,
      'national_text_number': national_text_number,
      'passport_number': passport_number,
      'tin': tin,
      'nssf_number': nssf_number,
      'bank_name': bank_name,
      'bank_account_number': bank_account_number,
      'primary_school_name': primary_school_name,
      'primary_school_year_graduated': primary_school_year_graduated,
      'seconday_school_name': seconday_school_name,
      'balance': balance,
      'seconday_school_year_graduated': seconday_school_year_graduated,
      'high_school_name': high_school_name,
      'high_school_year_graduated': high_school_year_graduated,
      'degree_university_name': degree_university_name,
      'degree_university_year_graduated': degree_university_year_graduated,
      'masters_university_name': masters_university_name,
      'masters_university_year_graduated': masters_university_year_graduated,
      'phd_university_name': phd_university_name,
      'phd_university_year_graduated': phd_university_year_graduated,
      'user_type': user_type,
      'demo_id': demo_id,
      'demo_text': demo_text,
      'user_id': user_id,
      'user_text': user_text,
      'user_batch_importer_id': user_batch_importer_id,
      'user_batch_importer_text': user_batch_importer_text,
      'school_pay_account_id': school_pay_account_id,
      'school_pay_account_text': school_pay_account_text,
      'school_pay_payment_code': school_pay_payment_code,
      'given_name': given_name,
      'deleted_at': deleted_at,
      'marital_status': marital_status,
      'verification': verification,
      'current_class_id': current_class_id,
      'current_class_text': current_class_text,
      'current_theology_class_id': current_theology_class_id,
      'current_theology_class_text': current_theology_class_text,
      'status': status,
      'parent_id': parent_id,
      'parent_text': parent_text,
      'main_role_id': main_role_id,
      'main_role_text': main_role_text,
      'stream_id': stream_id,
      'stream_text': stream_text,
      'account_id': account_id,
      'account_text': account_text,
      'has_personal_info': has_personal_info,
      'has_educational_info': has_educational_info,
      'has_account_info': has_account_info,
      'diploma_school_name': diploma_school_name,
      'diploma_year_graduated': diploma_year_graduated,
      'certificate_school_name': certificate_school_name,
      'certificate_year_graduated': certificate_year_graduated,
      'theology_stream_id': theology_stream_id,
      'theology_stream_text': theology_stream_text,
      'lin': lin,
      'occupation': occupation,
      'last_seen': last_seen,
      'supervisor_id': supervisor_id,
      'supervisor_text': supervisor_text,
      'user_number': user_number,
      'token': token,
      'roles_text': roles_text,
      'residence': residence,
      'plain_password': plain_password,
      'mail_verification_token': mail_verification_token,
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
        ",username TEXT"
        ",password TEXT"
        ",name TEXT"
        ",avatar TEXT"
        ",remember_token TEXT"
        ",created_at TEXT"
        ",updated_at TEXT"
        ",enterprise_id TEXT"
        ",enterprise_text TEXT"
        ",first_name TEXT"
        ",last_name TEXT"
        ",date_of_birth TEXT"
        ",place_of_birth TEXT"
        ",sex TEXT"
        ",home_address TEXT"
        ",current_address TEXT"
        ",phone_number_1 TEXT"
        ",phone_number_2 TEXT"
        ",email TEXT"
        ",nationality TEXT"
        ",religion TEXT"
        ",spouse_name TEXT"
        ",spouse_phone TEXT"
        ",father_name TEXT"
        ",father_phone TEXT"
        ",mother_name TEXT"
        ",balance TEXT"
        ",mother_phone TEXT"
        ",languages TEXT"
        ",emergency_person_name TEXT"
        ",emergency_person_phone TEXT"
        ",national_id_number TEXT"
        ",national_text_number TEXT"
        ",passport_number TEXT"
        ",tin TEXT"
        ",nssf_number TEXT"
        ",bank_name TEXT"
        ",bank_account_number TEXT"
        ",primary_school_name TEXT"
        ",primary_school_year_graduated TEXT"
        ",seconday_school_name TEXT"
        ",seconday_school_year_graduated TEXT"
        ",high_school_name TEXT"
        ",high_school_year_graduated TEXT"
        ",degree_university_name TEXT"
        ",degree_university_year_graduated TEXT"
        ",masters_university_name TEXT"
        ",masters_university_year_graduated TEXT"
        ",phd_university_name TEXT"
        ",phd_university_year_graduated TEXT"
        ",user_type TEXT"
        ",demo_id TEXT"
        ",demo_text TEXT"
        ",user_id TEXT"
        ",user_text TEXT"
        ",user_batch_importer_id TEXT"
        ",user_batch_importer_text TEXT"
        ",school_pay_account_id TEXT"
        ",school_pay_account_text TEXT"
        ",school_pay_payment_code TEXT"
        ",given_name TEXT"
        ",deleted_at TEXT"
        ",marital_status TEXT"
        ",verification TEXT"
        ",current_class_id TEXT"
        ",current_class_text TEXT"
        ",current_theology_class_id TEXT"
        ",current_theology_class_text TEXT"
        ",status TEXT"
        ",parent_id TEXT"
        ",parent_text TEXT"
        ",main_role_id TEXT"
        ",main_role_text TEXT"
        ",stream_id TEXT"
        ",stream_text TEXT"
        ",account_id TEXT"
        ",account_text TEXT"
        ",has_personal_info TEXT"
        ",has_educational_info TEXT"
        ",has_account_info TEXT"
        ",diploma_school_name TEXT"
        ",diploma_year_graduated TEXT"
        ",certificate_school_name TEXT"
        ",certificate_year_graduated TEXT"
        ",theology_stream_id TEXT"
        ",theology_stream_text TEXT"
        ",lin TEXT"
        ",occupation TEXT"
        ",last_seen TEXT"
        ",supervisor_id TEXT"
        ",supervisor_text TEXT"
        ",user_number TEXT"
        ",token TEXT"
        ",roles_text TEXT"
        ",residence TEXT"
        ",plain_password TEXT"
        ",mail_verification_token TEXT"
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
    if (!(await UserModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(UserModel.tableName);
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
