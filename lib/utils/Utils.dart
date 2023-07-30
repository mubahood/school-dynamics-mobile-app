import 'dart:convert';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:dio/dio.dart' as dioPackage;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:schooldynamics/models/MarkLocalModel.dart';
import 'package:schooldynamics/models/MySubjects.dart';
import 'package:schooldynamics/models/SessionLocal.dart';
import 'package:schooldynamics/models/StreamModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:url_launcher/url_launcher.dart';

import '../models/ExamModel.dart';
import '../models/LoggedInUserModel.dart';
import '../theme/app_theme.dart';
import 'AppConfig.dart';

class Utils {
  static Future<void> get_common() async {
    await ExamModel.getItems();
  }

  static Future<void> initOneSignal() async {
    WidgetsFlutterBinding.ensureInitialized();
    print("=====INVITING ONE SIGNAL=====");
    await Firebase.initializeApp();
    print("=====DONE INVITING ONE SIGNAL=====");
    // Set the background messaging handler early on, as a named top-level function

    OneSignal.shared.setAppId(AppConfig.ONESIGNAL_APP_ID);

    LoggedInUserModel u = await LoggedInUserModel.getLoggedInUser();
    if (u != null) {
      if (u.id > 0) {
        OneSignal.shared.setExternalUserId(u.id.toString());
        print("=====SET ONE SIGNAL USER ID: ${u.id} =====");
      }
    }

    OneSignal.shared
        .promptUserForPushNotificationPermission()
        .then((accepted) {});

    OneSignal.shared.setNotificationWillShowInForegroundHandler(
        (OSNotificationReceivedEvent event) {
          print("=====ONE SIGNAL event ID: ${event.notification.title} =====");
          print("=====ONE SIGNAL event ID: ${event.notification.subtitle} =====");
          print("=====ONE SIGNAL event ID: ${event.notification.category} =====");
          print("=====ONE SIGNAL event ID: ${event.notification.body} =====");
      // Will be called whenever a notification is received in foreground
      // Display Notification, pass null param for not displaying the notification
      event.complete(event.notification);
    });

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      // Will be called whenever a notification is opened/button pressed.
      print("=====ONE SIGNAL result ID: ${result.notification.title} =====");
      print("=====ONE SIGNAL result ID: ${result.notification.subtitle} =====");
      print("=====ONE SIGNAL result ID: ${result.notification.category} =====");
      print("=====ONE SIGNAL result ID: ${result.notification.body} =====");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      // Will be called whenever the permission changes
      // (ie. user taps Allow on the permission prompt in iOS)
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      // Will be called whenever the subscription changes
      // (ie. user gets registered with OneSignal and gets a user ID)
    });

    OneSignal.shared.setEmailSubscriptionObserver(
        (OSEmailSubscriptionStateChanges emailChanges) {
      // Will be called whenever then user's email subscription changes
      // (ie. OneSignal.setEmail(email) is called and the user gets registered
    });
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

  static Future<dynamic> http_post(
      String path, Map<String, dynamic> body) async {
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
      String token = await LoggedInUserModel.get_token();
      response = await dio.post(AppConfig.API_BASE_URL + "/${path}",
          data: da,
          options: Options(
            headers: <String, String>{
              "authorization": 'Bearer ${token}',
              "Content-Type": "application/json",
              "accept": "application/json",
            },
          ));

      return response.data;
    } on DioError catch (e) {
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

  static Future<dynamic> http_get(
      String path, Map<String, dynamic> body) async {
    var client = http.Client();
    String token = await LoggedInUserModel.get_token();

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
          }));

      return response.data;
    } on DioError catch (e) {
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
    await MySubjects.getItems();
    await StreamModel.getItems();
    await MarkLocalModel.uploadPendingMarks();
    await SessionLocal.uploadPending();

  }

  static void init_theme() {
    AppTheme.resetFont();

    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: CustomTheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: CustomTheme.primary,
      ),
    );
  }

  static Future<Database> getDb() async {
    print("===GETTING DB========");
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
    bool isConnected = false;
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      // I am connected to a mobile network.
      isConnected = true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a wifi network.
      isConnected = true;
    }

    return isConnected;
  }

  static log(String message) {
    debugPrint(message, wrapWidth: 1200);
  }

  static toast(String message,
      {Color color: Colors.green, bool isLong: false}) {
    if (Colors.green == color) {
      color = CustomTheme.primary;
    }

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

  static void go_to_home(context) {
    Navigator.pushNamedAndRemoveUntil(context, "/HomeScreen", (r) => false);
  }

  static Future<void> showConfirmDialog(
    BuildContext context,
    Function onPositiveClick,
    Function onNegativeClick, {
    String message: "Please confirm this action",
    String positive_text: "Confirm",
    String negative_text: "Cancel",
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
                    FxText.sh1(
                      "${message}\n",
                      fontWeight: 500,
                    ),
                    Container(
                        alignment: AlignmentDirectional.center,
                        child: Column(
                          children: [
                            FxButton.block(
                                onPressed: () {
                                  onPositiveClick();
                                  Navigator.pop(context);
                                },
                                borderRadiusAll: 4,
                                elevation: 0,
                                child: FxText.b2(positive_text,
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
                                child: FxText.b2(negative_text,
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

  static Future<Position> get_device_location() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
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

  static String getImageUrl(dynamic img) {
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
}
