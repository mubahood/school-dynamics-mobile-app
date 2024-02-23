import 'package:schooldynamics/utils/AppConfig.dart';
import 'package:sqflite/sqflite.dart';

import '../utils/Utils.dart';
import 'RespondModel.dart';

class PostModel {
  static String end_point = "posts";
  static String tableName = "posts";
  int id = 0;
  String created_at = "";
  String updated_at = "";
  String enterprise_id = "";
  String enterprise_text = "";
  String academic_year_id = "";
  String academic_year_text = "";
  String term_id = "";
  String term_text = "";
  String posted_by_id = "";
  String posted_by_text = "";
  String title = "";
  String description = "";
  String photo = "";
  String file = "";
  String type = "";
  String target = "";
  String status = "";
  String event_date = "";

  static List<PostModel> sortByDate(List<PostModel> data) {
    data.sort((a, b) {
      if (a.event_date.isEmpty) {
        return 1;
      }
      if (b.event_date.isEmpty) {
        return -1;
      }
      DateTime? d1 = DateTime.parse(a.event_date);
      DateTime? d2 = DateTime.parse(b.event_date);

      return d2.compareTo(d1);
    });
    return data;
  }

  getLogo() {
    if (photo.isEmpty) {
      return "${AppConfig.STORAGE_URL}/logo.png";
    }
    return "${AppConfig.STORAGE_URL}/${photo}";
  }

  static fromJson(dynamic m) {
    PostModel obj = new PostModel();
    if (m == null) {
      return obj;
    }

    obj.id = Utils.int_parse(m['id']);
    obj.created_at = Utils.to_str(m['created_at'], '');
    obj.updated_at = Utils.to_str(m['updated_at'], '');
    obj.enterprise_id = Utils.to_str(m['enterprise_id'], '');
    obj.enterprise_text = Utils.to_str(m['enterprise_text'], '');
    obj.academic_year_id = Utils.to_str(m['academic_year_id'], '');
    obj.academic_year_text = Utils.to_str(m['academic_year_text'], '');
    obj.term_id = Utils.to_str(m['term_id'], '');
    obj.term_text = Utils.to_str(m['term_text'], '');
    obj.posted_by_id = Utils.to_str(m['posted_by_id'], '');
    obj.posted_by_text = Utils.to_str(m['posted_by_text'], '');
    obj.title = Utils.to_str(m['title'], '');
    obj.description = Utils.to_str(m['description'], '');
    obj.photo = Utils.to_str(m['photo'], '');
    obj.file = Utils.to_str(m['file'], '');
    obj.type = Utils.to_str(m['type'], '');
    obj.target = Utils.to_str(m['target'], '');
    obj.status = Utils.to_str(m['status'], '');
    obj.event_date = Utils.to_str(m['event_date'], '');

    return obj;
  }

  static Future<List<PostModel>> getLocalData({String where = "1"}) async {
    List<PostModel> data = [];
    if (!(await PostModel.initTable())) {
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
      data.add(PostModel.fromJson(maps[i]));
    });

    return data;
  }

  static Future<List<PostModel>> get_items({String where = '1'}) async {
    List<PostModel> data = await getLocalData(where: where);
    if (data.isEmpty) {
      await PostModel.getOnlineItems();
      data = await getLocalData(where: where);
    } else {
      PostModel.getOnlineItems();
    }
    return data;
  }

  static Future<List<PostModel>> getOnlineItems() async {
    List<PostModel> data = [];

    RespondModel resp =
        RespondModel(await Utils.http_get('${PostModel.end_point}', {}));

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
        await PostModel.deleteAll();
      }

      await db.transaction((txn) async {
        var batch = txn.batch();

        for (var x in resp.data) {
          PostModel sub = PostModel.fromJson(x);
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
      'academic_year_id': academic_year_id,
      'academic_year_text': academic_year_text,
      'term_id': term_id,
      'term_text': term_text,
      'posted_by_id': posted_by_id,
      'posted_by_text': posted_by_text,
      'title': title,
      'description': description,
      'photo': photo,
      'file': file,
      'type': type,
      'target': target,
      'status': status,
      'event_date': event_date,
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
        ",academic_year_id TEXT"
        ",academic_year_text TEXT"
        ",term_id TEXT"
        ",term_text TEXT"
        ",posted_by_id TEXT"
        ",posted_by_text TEXT"
        ",title TEXT"
        ",description TEXT"
        ",photo TEXT"
        ",file TEXT"
        ",type TEXT"
        ",target TEXT"
        ",status TEXT"
        ",event_date TEXT"
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
    if (!(await PostModel.initTable())) {
      return;
    }
    Database db = await Utils.getDb();
    if (!db.isOpen) {
      return false;
    }
    await db.delete(PostModel.tableName);
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

  bool isBeforeToday() {
    if (event_date.isEmpty) {
      return false;
    }
    DateTime? d1;
    try {
      d1 = DateTime.parse(event_date);
    } catch (e) {
      return false;
    }
    return d1.isBefore(DateTime.now());
  }
}
