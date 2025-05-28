import 'package:flutter/material.dart';
import 'package:flutx/flutx.dart';

class CustomTheme {
  static const Color primary_1 = Colors.green;
  static  Color primary = const Color.fromRGBO(25, 131, 192, 1.0);
  static const Color bg_primary_light = Color.fromRGBO(239, 252, 240, 1.0);
  static   Color primaryDark = const Color.fromRGBO(8, 79, 124, 1.0);
  static const Color primary_bg = Color(0xfff8fffb);
  static const Color onPrimary = Colors.white;
  static const Color accent = Color(0xffdf7463);
  static const Color occur = Color(0xffb38220);
  static const Color peach = Color(0xffe09c5f);
  static const Color skyBlue = Color(0xff639fdc);
  static const Color darkGreen = Color(0xff226e79);
  static const Color red = Color(0xfff8575e);
  static const Color purple = Color(0xff9f50bf);
  static const Color pink = Color(0xffd17b88);
  static const Color brown = Color(0xffbd631a);
  static const Color blue = Color(0xff1a71bd);
  static const Color green = Color(0xff068425);
  static const Color yellow = Color(0xfffff44f);
  static const Color orange = Color(0xffFFA500);
  static final input_outline_border = OutlineInputBorder(
    borderSide: BorderSide(color: CustomTheme.primary),
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  );
  static final input_outline_focused_border = OutlineInputBorder(
    borderSide: BorderSide(color: CustomTheme.primary),
    gapPadding: 20,
    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
  );



  static InputDecoration in_4(
      {bool isDense = true,
        String label = "",
        IconData iconData = Icons.edit,
        String hintText = "",
        double hPadding = 10,
        double vPadding = 10
      }) {
    return InputDecoration(
      hintText: hintText.isEmpty ? null : hintText,
      isDense: isDense,
      label: (label.isEmpty)
          ? null
          : Text(
        label,
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 16,
            color: Colors.grey.shade500),
      ),
      hintStyle: const TextStyle(fontSize: 15, color: Color(0xaa495057)),
      focusedBorder: OutlineInputBorder(
        gapPadding: 5,
        borderRadius: const BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: CustomTheme.primaryDark),
      ),
      enabledBorder: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      disabledBorder: const OutlineInputBorder(
        gapPadding: 0,
        borderRadius: BorderRadius.all(Radius.circular(4)),
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      contentPadding: EdgeInsets.symmetric(
          horizontal: hPadding, vertical: hPadding),
      fillColor: Colors.grey.shade100,
      border: const OutlineInputBorder(
        gapPadding: 0,
          borderRadius: BorderRadius.all(Radius.circular(4)),
          borderSide: BorderSide(width: 1, color: Colors.black54)),
    );
  }


  static InputDecoration in_3(
      {String label = "", String hintText = "", double label_font_size = 16}) {
    return InputDecoration(
      filled: true,
      isDense: false,
      errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
        color: Colors.red,
      )),
      enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          )),
      focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          )),
      disabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade200,
          )),
      border: UnderlineInputBorder(
          borderSide: BorderSide(
            color: Colors.grey.shade400,
          )),
      labelStyle: FxTextStyle.bodyMedium(
        color: Colors.grey.shade800,
        fontSize: label_font_size,
      ),
      contentPadding: const EdgeInsets.only(left: 0, bottom: 0, right: 0, top: 0),
      label: FxText(
        label,
        color: primary,
      ),
      hintText: hintText,
      helperMaxLines: 2,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
      fillColor: Colors.white,
    );
  }

  InputDecoration input_decoration_2({String labelText = "",
    String hintText = "",
    dynamic suffixIcon,
    double label_font_size = 18}) {
    return InputDecoration(
      suffixIcon: (suffixIcon == null)
          ? const SizedBox()
          : Icon(
        suffixIcon,
        size: 30,
      ),
      focusedBorder: InputBorder.none,
      enabledBorder: InputBorder.none,
      filled: true,
      border: InputBorder.none,
      labelStyle: FxTextStyle.bodySmall(
        color: Colors.grey.shade700,
        fontSize: label_font_size,
      ),
      labelText: labelText,
      hintText: hintText,
      hintStyle: const TextStyle(
        fontWeight: FontWeight.w300,
      ),
      fillColor: Colors.white,
    );
  }

  static InputDecoration input_decoration_4({String labelText = ""}) {
    return InputDecoration(
      hintText: labelText,
      hintStyle: const TextStyle(),
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
          borderSide: BorderSide.none),
      enabledBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
          borderSide: BorderSide.none),
      focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(18),
          ),
          borderSide: BorderSide.none),
      isDense: true,
      contentPadding: const EdgeInsets.all(0),
    );
  }

  InputDecoration input_decoration({String labelText = "", IconData icon = Icons.edit}) {
    return InputDecoration(
      prefixIcon: Icon(icon, color: CustomTheme.primary),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomTheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: CustomTheme.primary),
        borderRadius: const BorderRadius.all(Radius.circular(5.0)),
      ),
      filled: true,
      border: InputBorder.none,
      labelStyle: FxTextStyle.bodySmall(color: CustomTheme.accent),
      labelText: labelText,
      fillColor: CustomTheme.primary.withAlpha(40),
    );
  }

  final Color card,
      cardDark,
      border,
      borderDark,
      disabledColor,
      onDisabled,
      colorInfo,
      colorWarning,
      colorSuccess,
      colorError,
      shadowColor,
      onInfo,
      onWarning,
      onSuccess,
      onError,
      shimmerBaseColor,
      shimmerHighlightColor;

  final Color groceryPrimary, groceryOnPrimary;

  final Color medicarePrimary, medicareOnPrimary;

  final Color cookifyPrimary, cookifyOnPrimary;

  final Color lightBlack, violet, indigo;

  final Color estatePrimary,
      estateOnPrimary,
      estateSecondary,
      estateOnSecondary;
  final Color datingPrimary,
      datingOnPrimary,
      datingSecondary,
      datingOnSecondary;

  final Color homemadePrimary,
      homemadeSecondary,
      homemadeOnPrimary,
      homemadeOnSecondary;
  final Color muviPrimary, muviOnPrimary;

  @deprecated
  final Color learningPrimary,
      learningOnPrimary,
      learningCategory1,
      learningCategory2,
      learningCategory3,
      learningCategory4,
      learningCategory5;

  final Color fitnessPrimary,
      fitnessOnPrimary,
      magenta,
      oliveGreen,
      carolinaBlue;

  CustomTheme({
    this.border = const Color(0xffeeeeee),
    this.borderDark = const Color(0xffe6e6e6),
    this.card = const Color(0xfff0f0f0),
    this.cardDark = const Color(0xfffefefe),
    this.disabledColor = const Color(0xffdcc7ff),
    this.onDisabled = const Color(0xffffffff),
    this.colorWarning = const Color(0xffffc837),
    this.colorInfo = const Color(0xffff784b),
    this.colorSuccess = const Color(0xff3cd278),
    this.shadowColor = const Color(0xff1f1f1f),
    this.onInfo = const Color(0xffffffff),
    this.onWarning = const Color(0xffffffff),
    this.onSuccess = const Color(0xffffffff),
    this.colorError = const Color(0xfff0323c),
    this.onError = const Color(0xffffffff),
    this.shimmerBaseColor = const Color(0xFFF5F5F5),
    this.shimmerHighlightColor = const Color(0xFFE0E0E0),

    //Grocery color scheme
    this.groceryPrimary = const Color(0xff10bb6b),
    this.groceryOnPrimary = const Color(0xffffffff),

    //Cookify
    this.cookifyPrimary = const Color(0xffdf7463),
    this.cookifyOnPrimary = const Color(0xffffffff),

    //Color
    this.lightBlack = const Color(0xffa7a7a7),
    this.indigo = const Color(0xff4B0082),
    this.violet = const Color(0xff9400D3),

    //Medicare Color Scheme
    this.medicarePrimary = const Color(0xff6d65df),
    this.medicareOnPrimary = const Color(0xffffffff),

    //Estate Color Scheme
    this.estatePrimary = const Color(0xff1c8c8c),
    this.estateOnPrimary = const Color(0xffffffff),
    this.estateSecondary = const Color(0xfff15f5f),
    this.estateOnSecondary = const Color(0xffffffff),

    //Dating Color Scheme
    this.datingPrimary = const Color(0xffB428C3),
    this.datingOnPrimary = const Color(0xffffffff),
    this.datingSecondary = const Color(0xfff15f5f),
    this.datingOnSecondary = const Color(0xffffffff),

    //Homemade Color Scheme
    this.homemadePrimary = const Color(0xffc5558e),
    this.homemadeSecondary = const Color(0xffCC9D60),
    this.homemadeOnPrimary = const Color(0xffffffff),
    this.homemadeOnSecondary = const Color(0xffffffff),

    //Muvi Color Scheme
    this.muviPrimary = const Color(0xff4B97C5),
    this.muviOnPrimary = const Color(0xffffffff),

    //Learning Primary
    this.learningPrimary = const Color(0xff6874E8),
    this.learningOnPrimary = const Color(0xffFDF6ED),
    this.learningCategory1 = const Color(0xff46A4E4),
    this.learningCategory2 = const Color(0xffEC84B5),
    this.learningCategory3 = const Color(0xffD28638),
    this.learningCategory4 = const Color(0xff16a058),
    this.learningCategory5 = const Color(0xffe55d27),

    //Fitness Primary
    this.fitnessPrimary = const Color(0xff2D72F0),
    this.fitnessOnPrimary = const Color(0xffFAF9F9),
    this.magenta = const Color(0xff8B5587),
    this.oliveGreen = const Color(0xff4aa359),
    this.carolinaBlue = const Color(0xff069DEF),
  });

  //--------------------------------------  Custom App Theme ----------------------------------------//

  static final CustomTheme lightCustomTheme = CustomTheme(
      card: const Color(0xfff6f6f6),
      cardDark: const Color(0xfff0f0f0),
      disabledColor: const Color(0xff636363),
      onDisabled: const Color(0xffffffff),
      colorInfo: const Color(0xffff784b),
      colorWarning: const Color(0xffffc837),
      colorSuccess: const Color(0xff3cd278),
      shadowColor: const Color(0xffd9d9d9),
      onInfo: const Color(0xffffffff),
      onSuccess: const Color(0xffffffff),
      onWarning: const Color(0xffffffff),
      colorError: const Color(0xfff0323c),
      onError: const Color(0xffffffff),
      shimmerBaseColor: const Color(0xFFF5F5F5),
      shimmerHighlightColor: const Color(0xFFE0E0E0));

  static final CustomTheme darkCustomTheme = CustomTheme(
      card: const Color(0xff222327),
      cardDark: const Color(0xff101010),
      border: const Color(0xff303030),
      borderDark: const Color(0xff363636),
      disabledColor: const Color(0xffbababa),
      onDisabled: const Color(0xff000000),
      colorInfo: const Color(0xffff784b),
      colorWarning: const Color(0xffffc837),
      colorSuccess: const Color(0xff3cd278),
      shadowColor: const Color(0xff202020),
      onInfo: const Color(0xffffffff),
      onSuccess: const Color(0xffffffff),
      onWarning: const Color(0xffffffff),
      colorError: const Color(0xfff0323c),
      onError: const Color(0xffffffff),
      shimmerBaseColor: const Color(0xFF1a1a1a),
      shimmerHighlightColor: const Color(0xFF454545));
}
