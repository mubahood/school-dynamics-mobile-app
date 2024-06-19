import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart' as dioPackage;
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutx/flutx.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:schooldynamics/models/MarkLocalModel.dart';
import 'package:schooldynamics/models/MySubjects.dart';
import 'package:schooldynamics/models/SessionLocal.dart';
import 'package:schooldynamics/models/StreamModel.dart';
import 'package:schooldynamics/models/StudentHasClassModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/EnterpriseModel.dart';
import '../models/ExamModel.dart';
import '../models/LoggedInUserModel.dart';
import '../theme/app_theme.dart';
import 'AppConfig.dart';

class Utils {
  static String prepare_phone_number(String phone_number) {
    if (phone_number.isEmpty) {
      return "";
    }
    if (phone_number.substring(0, 1) != '0') {
      phone_number = phone_number.replaceFirst('+', "");
      phone_number = phone_number.replaceFirst('256', "");
    } else {
      phone_number = phone_number.replaceFirst('0', "");
    }
    if (phone_number.length != 9) {
      return "";
    }
    phone_number = "+256" + phone_number;
    return phone_number;
  }

  static bool phone_number_is_valid(String phone_number) {
    if (phone_number.length != 13) {
      return false;
    }

    if (phone_number.substring(0, 4) != "+256") {
      return false;
    }

    return true;
  }

  static Future<String> get_temp_dir() async {
    //get parent storage path for the app
    Directory dir = await getApplicationDocumentsDirectory();
    //check if dir contains folder called temp, else create it
    if (!Directory("${dir.path}/temp").existsSync()) {
      Directory("${dir.path}/temp").createSync();
    }
    Directory tempDir = Directory("${dir.path}/temp");

    //check if tempDir exists
    if (!tempDir.existsSync()) {
      Utils.toast("Failed to create temp directory.");
      return "";
    }
    return tempDir.path;
  }

  static String greet(String name) {
    //split name by  space if it is more than one word and get the first word
    name = name.split(" ")[0];
    name = Utils.short_string(name);
    //greet name according to time of the day
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return 'Good Morning, $name';
    }
    if (hour < 17) {
      return 'Good Afternoon, $name';
    }
    return 'Good Evening, $name';
  }

  static String short_string(String name) {
    if (name.length > 10) {
      return '${name.substring(0, 10)}...';
    }
    return name;
  }

  static String shortString(String name, int length) {
    if (name.length > length) {
      return '${name.substring(0, length)}...';
    }
    return name;
  }

  static Future<void> initOneSignal() async {
    WidgetsFlutterBinding.ensureInitialized();
    //await Firebase.initializeApp();
    print("=====DONE INVITING ONE SIGNAL=====");
    // Set the background messaging handler early on, as a named top-level function

    OneSignal.initialize(AppConfig.ONESIGNAL_APP_ID);

    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    if (u != null) {
      if (u.id > 0) {
        OneSignal.login(u.id.toString());
        print("=====SET ONE SIGNAL USER ID: ${u.id} =====");
      }
    }

    OneSignal.Notifications.addPermissionObserver((state) {
      print("Has permission " + state.toString());
    });

    OneSignal.Notifications.addForegroundWillDisplayListener((event) {
      print(
          'NOTIFICATION WILL DISPLAY LISTENER CALLED WITH: ${event.notification.jsonRepresentation()}');

      /// Display Notification, preventDefault to not display
      event.preventDefault();

      /// Do async work

      /// notification.display() to display after preventing default
      event.notification.display();

      /*this.setState(() {
        _debugLabelString =
        "Notification received in foreground notification: \n${event.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });*/
    });

    OneSignal.InAppMessages.addWillDisplayListener((event) {
      print("ON WILL DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDisplayListener((event) {
      print("ON DID DISPLAY IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addWillDismissListener((event) {
      print("ON WILL DISMISS IN APP MESSAGE ${event.message.messageId}");
    });
    OneSignal.InAppMessages.addDidDismissListener((event) {
      print("ON DID DISMISS IN APP MESSAGE ${event.message.messageId}");
    });

    OneSignal.InAppMessages.paused(true);
  }

  static bool contains(List<dynamic> items, dynamic item) {
    bool yes = false;
    for (var e in items) {
      if (e.id == item.id) {
        yes = true;
        break;
      }
    }
    return yes;
  }

  static Future<dynamic> http_post(String path, Map<String, dynamic> body) async {
    bool is_online = await Utils.is_connected();
    if (!is_online) {
      return {
        'code': 0,
        'message': 'You are not connected to internet.',
        'data': null
      };
    }
    dynamic response;
    var dio = Dio();

    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    var da = dioPackage.FormData.fromMap(body); //.fromMap();

    try {
      String token = await Utils.getToken();
      response = await dio.post(AppConfig.API_BASE_URL + "/${path}",
          data: da,
          options: Options(
            headers: <String, String>{
              "authorization": 'Bearer $token',
              "Tok": 'Bearer $token',
              "tok": 'Bearer $token',
              "Content-Type": "application/json",
              "accept": "application/json",
            },
          ));
/*
      print("=====success=====");
      print(response.data.toString());*/
      return response.data;
    } on DioError catch (e) {
      print("failed");
      print(e.message);
      if (e.response?.data != null) {
        if (e.response?.data.runtimeType.toString() ==
            '_Map<String, dynamic>') {
          return e.response?.data;
        }
      }
      Map<String, dynamic> map = {
        'status': 0,
        'message': "Failed because ${e.message.toString()}"
      };
      return jsonEncode(map);
    }
  }

  static Future<bool> is_logged_in() async {
    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    if (u.id < 1) {
      return false;
    } else {
      //// await LoggedInUserModel.update_local_user();
      return true;
    }
  }

  static String get_file_url(String name) {
    String url = AppConfig.MAIN_SITE_URL + "/storage/uploads";
    if (name == null || (name.length < 2)) {
      url += '/default.png';
    } else {
      url += '/${name}';
    }
    return url;
  }

  static Future<String> getToken() async {
    String token = "";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    token = prefs.getString("token") ?? "";
    return token;
  }

  static Future<String> getPref(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(path) ?? "";
  }

  static Future<void> setPref(String path, String data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(path, data);
    return;
  }

  static Future<void> removePref(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(path);
    return;
  }

  static Future<void> setPrefInt(String path, int data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(path, data);
    return;
  }

  static Future<int> getPrefInt(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getInt(path) ?? 0;
  }

  static Future<void> removePrefInt(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(path);
    return;
  }

  static Future<void> setPrefBool(String path, bool data) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(path, data);
    return;
  }

  static Future<bool> getPrefBool(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool(path) ?? false;
  }

  static Future<void> removePrefBool(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove(path);
    return;
  }

  static Future<dynamic> http_get(String path, Map<String, dynamic> body) async {
    var client = http.Client();
    String token = await Utils.getToken();

    /* print("feting data...");

    var data = await client.read(Uri.http(
        '10.0.2.2:8000',
        "api/${path}"
    ),headers: {
      "Content-Type": "application/json",
      "accept": "application/json",
      "authorization": 'Bearer ${token}',
    });


    return  jsonDecode(data,) as Map;
    json.decode( json.encode(data));*/

    bool isOnline = await Utils.is_connected();
    if (!isOnline) {
      return {
        'code': 0,
        'message': 'You are not connected to internet.',
        'data': null
      };
    }

    var response;
    var dio = Dio();

    // print("feting data...");
    // print(AppConfig.API_BASE_URL + "/${path}");

    if (!kIsWeb) {
      (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
          (HttpClient client) {
        client.badCertificateCallback =
            (X509Certificate cert, String host, int port) => true;
        return client;
      };
    }

    try {
      response = await dio.get(AppConfig.API_BASE_URL + "/${path}",
          queryParameters: body,
          options: Options(headers: <String, String>{
            "Content-Type": "application/json",
            "accept": "application/json",
            "authorization": 'Bearer ${token}',
            "Tok": 'Bearer ${token}',
            "tok": 'Bearer ${token}',
          }));
      // print('=====||||==SUCCESS===||||====');
      // print(response.data);
      // print('====||||===>SUCCESS<===||||====');

      return response.data;
    } on DioError catch (e) {
      // print("=======ERROR=======");
      // print(e.message);
      // print(e.response?.data);
      // print('=======>ERROR<=======');
      if (e.response?.data != null) {
        if (e.response?.data.runtimeType.toString() ==
            '_Map<String, dynamic>') {
          return e.response?.data;
        }
      }
      return {
        'status': 0,
        'code': 0,
        'message': e.response?.data,
        'data': null,
      };
    }
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
    await deleteDatabase(AppConfig.DATABASE_PATH);
    return;
  }

  static void launchURL(String _url) async {
    if (!await launch(_url)) throw 'Could not launch $_url';
  }

  static Future<void> boot_system() async {
    await StudentHasClassModel.get_items();
    await MySubjects.getItems();
    await StreamModel.getItems();
    await MarkLocalModel.uploadPendingMarks();
    await SessionLocal.uploadPending();
    await ExamModel.getItems();
  }

  static SystemUiOverlayStyle get_theme() {
    /* SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: CustomTheme.primary,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));*/

    return SystemUiOverlayStyle(
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.dark,
      systemNavigationBarColor: CustomTheme.primary,
      systemNavigationBarDividerColor: CustomTheme.primary,
      systemNavigationBarContrastEnforced: true,
      systemStatusBarContrastEnforced: true, // For iOS (dark icons)
    );
  }

  static Future<SystemUiOverlayStyle> init_theme() async {
    try {
      EnterpriseModel ent = await EnterpriseModel.getEnt();
      if (ent.id > 1) {
        CustomTheme.primary =
            Color(int.parse(ent.color.replaceAll("#", "0xff")));
        CustomTheme.primaryDark = CustomTheme.primary;
      }
    } catch (e) {
      print("Error :===>  $e");
    }

    AppTheme.resetFont();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      systemNavigationBarColor: CustomTheme.primary,
      systemNavigationBarIconBrightness: Brightness.light,
      systemNavigationBarDividerColor: null,
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light,
    ));

    return SystemUiOverlayStyle(
        statusBarColor: CustomTheme.primary,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: CustomTheme.primary,
        systemNavigationBarDividerColor: CustomTheme.primary,
        systemNavigationBarContrastEnforced: true,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarIconBrightness:
        debugBrightnessOverride // For iOS (dark icons)
    );
  }

/*

    return SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: CustomTheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: CustomTheme.primary,
        statusBarBrightness: Brightness.light,
        systemStatusBarContrastEnforced: true,
        systemNavigationBarContrastEnforced: true,
        systemNavigationBarDividerColor: CustomTheme.primary,
      ),
    );
* *
* */

  static Future<Database> getDb() async {
    //print("===GETTING DB========");
    return await openDatabase(AppConfig.DATABASE_PATH,
        version: AppConfig.DATABASE_VERSION);
  }

  static void init_dark_theme() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: CustomTheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: CustomTheme.primary));
  }

  static void launchPhone(String phoneNumber) async {
    if (!await launch('tel:${phoneNumber}'))
      throw 'Could not launch $phoneNumber';
  }

  static String yes_no_parse(dynamic x) {
    if (x == null) {
      return 'No';
    }
    if (Utils.int_parse(x) == 1) {
      return 'Yes';
    } else {
      return 'No';
    }
  }

  static String to_str(dynamic x, String y) {
    if (x == null) {
      return y;
    }
    if (x.toString().toString() == 'null') {
      return y;
    }
    if (x.toString().isEmpty) {
      return y.toString();
    }
    return x.toString();
  }

  static int int_parse(dynamic x) {
    if (x == null) {
      return 0;
    }
    int temp = 0;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    return temp;
  }

  static bool bool_parse(dynamic x) {
    int temp = 0;
    bool ans = false;
    try {
      temp = int.parse(x.toString());
    } catch (e) {
      temp = 0;
    }

    if (temp == 1) {
      ans = true;
    } else {
      ans = false;
    }
    return ans;
  }

  static double screen_width(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static double screen_height(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static Future<bool> is_connected() async {
    if (AppConfig.API_BASE_URL.contains('10.0.2.2')) {
      return true;
    }
    return await InternetConnectionChecker().hasConnection;
  }

  static log(String message) {
    debugPrint(message, wrapWidth: 1200);
  }

  static toast(String message,
      {Color color = Colors.green, bool isLong = false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }
    toast2(message,
        background_color: color, color: Colors.white, is_long: isLong);
    return;

    Get.snackbar('Alert', message,
        dismissDirection: DismissDirection.down,
        colorText: Colors.white,
        backgroundColor: color,
        margin: EdgeInsets.zero,
        duration:
        isLong ? const Duration(seconds: 3) : const Duration(seconds: 5),
        snackPosition: SnackPosition.BOTTOM,
        snackStyle: SnackStyle.GROUNDED);
  }

  static void toast2(String message,
      {Color background_color = Colors.green,
        color = Colors.white,
        bool is_long = false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }

    Fluttertoast.showToast(
        msg: message,
        toastLength: is_long ? Toast.LENGTH_LONG : Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: background_color,
        textColor: color,
        fontSize: 16.0);
  }

  static void go_to_home(context) {
    Navigator.pushNamedAndRemoveUntil(context, "/HomeScreen", (r) => false);
  }

  static Future<void> showConfirmDialog(BuildContext context,
      Function onPositiveClick,
      Function onNegativeClick, {
        String message = "Please confirm this action",
        String positive_text = "Confirm",
        String negative_text = "Cancel",
      }) async {
    await showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        int selectedRadio = 0;
        return AlertDialog(
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Container(
                padding: FxSpacing.all(0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FxText.bodySmall(
                      "${message}\n",
                      fontWeight: 500,
                    ),
                    Container(
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          children: [
                            FxButton.block(
                                padding:
                                const EdgeInsets.fromLTRB(24, 24, 24, 24),
                                onPressed: () {
                                  onPositiveClick();
                                  Navigator.pop(context);
                                },
                                borderRadiusAll: 4,
                                elevation: 0,
                                child: FxText.bodySmall(positive_text,
                                    letterSpacing: 0.3, color: Colors.white)),
                            SizedBox(
                              height: 10,
                            ),
                            FxButton.outlined(
                                onPressed: () {
                                  onNegativeClick();
                                  Navigator.pop(context);
                                },
                                borderRadiusAll: 4,
                                elevation: 0,
                                child: FxText.bodySmall(negative_text,
                                    letterSpacing: 0.3, color: Colors.red)),
                          ],
                        )),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  // ignore: non_constant_identifier_names
  static SystemUiOverlayStyle overlay() {
    return SystemUiOverlayStyle(
      statusBarColor: CustomTheme.primary,
      statusBarIconBrightness: Brightness.light,
      statusBarBrightness: Brightness.light, // For iOS (dark icons)
    );
  }

  void upload_image(String path) async {}

  static double mediaWidth(BuildContext context) {
    return MediaQuery.of(context).size.width;
  }

  static bool isDesktop(BuildContext context) {
    return false;
    if (MediaQuery.of(context).size.width > 700) {
      return true;
    }
    ;
    return false;
  }

  static double mediaHeight(BuildContext context) {
    return MediaQuery.of(context).size.height;
  }

  static double sizeByWidth(BuildContext context, double w) {
    return MediaQuery.of(context).size.width / w;
  }

  static double fs1(BuildContext context) {
    return Utils.sizeByWidth(context, 5);
  }

  static double fs2(BuildContext context) {
    return Utils.sizeByWidth(context, 6);
  }

  static double fs3(BuildContext context) {
    return Utils.sizeByWidth(context, 6.5);
  }

  static double fs4(BuildContext context) {
    return Utils.sizeByWidth(context, 7);
  }

  static double fs5(BuildContext context) {
    return Utils.sizeByWidth(context, 7.5);
  }

  static double fs6(BuildContext context) {
    return Utils.sizeByWidth(context, 8);
  }

  static double fs7(BuildContext context) {
    return Utils.sizeByWidth(context, 8.5);
  }

  static double fs8(BuildContext context) {
    return Utils.sizeByWidth(context, 9);
  }

  static double fs9(BuildContext context) {
    return Utils.sizeByWidth(context, 9.5);
  }

  static double fs10(BuildContext context) {
    return Utils.sizeByWidth(context, 10);
  }

  static double fs11(BuildContext context) {
    return Utils.sizeByWidth(context, 10.6);
  }

  static double fs12(BuildContext context) {
    return Utils.sizeByWidth(context, 11);
  }

  static double fs13(BuildContext context) {
    return Utils.sizeByWidth(context, 11.5);
  }

  static double fs14(BuildContext context) {
    return Utils.sizeByWidth(context, 12);
  }

  static double fs15(BuildContext context) {
    return Utils.sizeByWidth(context, 15);
  }

  static double fs16(BuildContext context) {
    return Utils.sizeByWidth(context, 16);
  }

  static double fs17(BuildContext context) {
    return Utils.sizeByWidth(context, 17);
  }

  static double fs18(BuildContext context) {
    return Utils.sizeByWidth(context, 18);
  }

  static double fs19(BuildContext context) {
    return Utils.sizeByWidth(context, 19);
  }

  static double fs20(BuildContext context) {
    return Utils.sizeByWidth(context, 20);
  }

  static String to_date(dynamic updated_at) {
    String date_text = "--:--";
    if (updated_at == null) {
      return "--:--";
    }
    if (updated_at.toString().length < 5) {
      return "--:--";
    }

    try {
      DateTime date = DateTime.parse(updated_at.toString());

      date_text = DateFormat("d MMM, y - ").format(date);
      date_text += DateFormat("jm").format(date);
    } catch (e) {}

    return date_text;
  }

  static String getImg(dynamic img) {
    String _img = "logo.png";
    if (img != null) {
      img = img.toString();
      if (img.toString().length > 3) {
        if (img.toString().contains('/')) {
          _img = img.split('/').last;
        } else {
          _img = img;
        }
      }
    }

    return "${AppConfig.MAIN_SITE_URL}/storage/images/${_img}";
  }

  static String getImageUrl(dynamic img) {
    return getImg(img);
    String _img = "logo.png";
    if (img != null) {
      img = img.toString();
      if (img.toString().isNotEmpty) {
        _img = img;
      }
    }
    _img.replaceAll('/images', '');
    return "${AppConfig.MAIN_SITE_URL}/storage/images/${_img}";
  }

  static String to_date_1(dynamic updated_at) {
    String date_text = "__/__/___";
    if (updated_at == null) {
      return "__/__/____";
    }
    if (updated_at.toString().length < 5) {
      return "__/__/____";
    }

    try {
      DateTime date = DateTime.parse(updated_at.toString());

      date_text = DateFormat("d MMM, y").format(date);
    } catch (e) {}

    return date_text;
  }

  static String moneyFormat(String price) {
    int value0 = Utils.int_parse(price);
    if (price.length > 2) {
      var value = price;
      value = value.replaceAll(RegExp(r'\D'), '');
      value = value.replaceAll(RegExp(r'\B(?=(\d{3})+(?!\d))'), ',');
      if (value0 < 0) {
        value = "-$value";
      }
      return value;
    }
    return price;
  }

  static Future<void> launchBrowser(String path) async {
    Uri uri = Uri.parse('${AppConfig.MAIN_SITE_URL}/${path}');

    if (!await launchUrl(
      uri,
      mode: LaunchMode.externalApplication,
    )) {
      Utils.toast('Could not launch ${uri.toString()}', color: CustomTheme.red);
    }
  }

  static String get_file_size(String filePath) {
    File file = File(filePath);
    int sizeInBytes = file.lengthSync();
    double sizeInMb = sizeInBytes / (1024 * 1024);
    return sizeInMb.toStringAsFixed(2) + " MB";
  }
}
