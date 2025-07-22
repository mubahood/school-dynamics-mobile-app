import 'dart:convert';

import 'package:schooldynamics/theme/app_theme.dart';

import '../utils/Utils.dart';

class RespondModel {
  dynamic raw;
  int code = 0;
  String message =
      "Failed to connect to internet. Check your connection and try again";
  dynamic data;

  RespondModel(this.raw) {
    if (raw == null) {
      return;
    }
    if (raw.runtimeType.toString() == '_JsonMap') {
      if (raw['code'] != null) {
        code = Utils.int_parse(raw['code']);
      }
      data = raw['data'];
      message = raw['message'];
      return;
    }

    Map<String, dynamic> resp = {};
    if (raw.runtimeType.toString() != '_Map<String, dynamic>') {
      try {
        resp = jsonDecode(raw);
      } catch (e) {
        resp = {'code': 0, 'message': raw.toString(), 'data': null};
      }
    } else {
      resp = raw;
    }

    if (resp['message'] == 'Unauthenticated') {
      Utils.toast("You are not logged in.",color: CustomTheme.red);
      return;
    }


    if (resp['code'] != null) {
      code = Utils.int_parse(resp['code'].toString());
      message = resp['message'].toString();
      data = resp['data'];
    } else if (resp['message'] != null) {
      code = Utils.int_parse(resp['code'].toString());
      message = resp['message'].toString();
      data = resp['data'];
    }
  }
}
