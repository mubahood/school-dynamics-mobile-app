/*
* File : App Theme
* Version : 1.0.0
* */

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutx/flutx.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../theme/theme_type.dart';
import '../utils/Utils.dart';
import 'custom_theme.dart';

export 'custom_theme.dart';
export 'navigation_theme.dart';

class AppTheme {
  static InputDecoration InputDecorationTheme1(
      {bool isDense = true,
      String label = "",
      IconData iconData = Icons.edit,
      bool hasPadding = true,
      String hintText = ""}) {
    EdgeInsets padding =
        const EdgeInsets.only(left: 10, top: 10, bottom: 10, right: 15);
    if (!hasPadding) {
      padding = const EdgeInsets.only(left: 10, top: 0, bottom: 0, right: 15);
    }

    return InputDecoration(
      hintText: hintText.isEmpty ? null : hintText,
      contentPadding: padding,
      isDense: isDense,
      label: (label.isEmpty)
          ? null
          : Text(
              label,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: Colors.grey.shade900),
            ),

      /*prefixIcon: Icon(
        iconData,
        color: Colors.grey.shade800,
      ),*/
      hintStyle: const TextStyle(fontSize: 15, color: Color(0xaa495057)),
      focusedBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Colors.green),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Colors.black54),
      ),
      fillColor: Colors.grey.shade100,
      border: const OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(width: 1, color: Colors.black54)),
    );
  }

  static TextStyle getTextStyle(TextStyle? textStyle,
      {int fontWeight = 500,
      bool muted = false,
      bool xMuted = false,
      double letterSpacing = 0.15,
      Color? color,
      TextDecoration decoration = TextDecoration.none,
      double? height,
      double wordSpacing = 0,
      double? fontSize}) {
    double? finalFontSize = fontSize ?? textStyle!.fontSize;

    Color? finalColor;
    if (color == null) {
      finalColor = xMuted
          ? textStyle!.color!.withAlpha(160)
          : (muted ? textStyle!.color!.withAlpha(200) : textStyle!.color);
    } else {
      finalColor = xMuted
          ? color.withAlpha(160)
          : (muted ? color.withAlpha(200) : color);
    }

    return GoogleFonts.inter(
        fontSize: finalFontSize,
        letterSpacing: letterSpacing,
        color: finalColor,
        decoration: decoration,
        height: height,
        wordSpacing: wordSpacing);
  }

  static ThemeData shoppingManagerTheme = getShoppingManagerTheme();
  static ThemeData getShoppingManagerTheme() {
    return createThemeM3(themeType, CustomTheme.primary);
  }

  static ThemeData createThemeM3(ThemeType themeType, Color seedColor) {
    if (themeType == ThemeType.light) {
      return lightTheme.copyWith(
          colorScheme: ColorScheme.fromSeed(
              seedColor: seedColor, brightness: Brightness.light));
    }
    return darkTheme.copyWith(
        colorScheme: ColorScheme.fromSeed(
            seedColor: seedColor,
            brightness: Brightness.dark,
            onBackground: const Color(0xFFDAD9CA)));
  }

  static ThemeData createTheme(ColorScheme colorScheme) {
    if (themeType != ThemeType.light) {
      return darkTheme.copyWith(
        colorScheme: colorScheme,
      );
    }
    return lightTheme.copyWith(colorScheme: colorScheme);
  }

  static ThemeType themeType = ThemeType.light;
  static TextDirection textDirection = TextDirection.ltr;

  static CustomTheme customTheme = getCustomTheme();
  static ThemeData theme = getTheme();

  static ThemeData shoppingTheme = shoppingLightTheme;

  AppTheme._();

  static ThemeData shoppingLightTheme = createTheme(
    ColorScheme.fromSeed(
      seedColor: CustomTheme.primary,
      primaryContainer: const Color(0xffdafafa),
      secondary: const Color(0xfff15f5f),
      onSecondary: const Color(0xffffffff),
      secondaryContainer: const Color(0xfff8d6d6),
      onSecondaryContainer: const Color(0xff570202),
    ),
  );

  static init() {
    //   resetFont();
    //  FlutX.changeTheme(theme);
    AppTheme.resetFont();
    FxAppTheme.changeTheme(lightTheme);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: CustomTheme.primary,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: CustomTheme.primary));
  }

  /* static init() {
    //resetFont();
    FxAppTheme.changeLightTheme(lightTheme);
    //FxAppTheme.changeDarkTheme(darkTheme);
  }
*/
  static resetFont() {
    FxTextStyle.changeFontFamily(GoogleFonts.inter);
    FxTextStyle.changeDefaultFontWeight({
      100: FontWeight.w100,
      200: FontWeight.w200,
      300: FontWeight.w300,
      400: FontWeight.w400,
      500: FontWeight.w500,
      600: FontWeight.w600,
      700: FontWeight.w700,
      800: FontWeight.w800,
      900: FontWeight.w900,
    });
  }

  static ThemeData getTheme([ThemeType? themeType]) {
    return lightTheme;
    themeType = themeType ?? AppTheme.themeType;
    if (themeType == ThemeType.light) return lightTheme;
    return lightTheme;
  }

  static CustomTheme getCustomTheme([ThemeType? themeType]) {
    themeType = themeType ?? AppTheme.themeType;
    if (themeType == ThemeType.light) return CustomTheme.lightCustomTheme;
    return CustomTheme.darkCustomTheme;
  }

  /*static void changeFxTheme(ThemeType themeType) {
    if (themeType == ThemeType.light) {
      FxAppTheme.changeThemeType(FxAppThemeType.light);
    } else if (themeType == ThemeType.dark) {
      FxAppTheme.changeThemeType(FxAppThemeType.dark);
    }
  }
*/
  static void changeFxTheme() {
    FlutX.changeTheme(theme);
  }

  /// -------------------------- Light Theme  -------------------------------------------- ///
  static final ThemeData lightTheme = ThemeData(
    /// Brightness
    brightness: Brightness.light,

    /// Primary Color
    primaryColor: CustomTheme.primary,

    /// Scaffold and Background color
    scaffoldBackgroundColor: const Color(0xffffffff),
    canvasColor: Colors.transparent,

    /// AppBar Theme — flat, primary bg, no gradient
    appBarTheme: AppBarTheme(
      systemOverlayStyle: Utils.get_theme(),
      backgroundColor: CustomTheme.primary,
      elevation: 0,
      centerTitle: false,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      iconTheme: const IconThemeData(color: Colors.white),
      actionsIconTheme: const IconThemeData(color: Colors.white),
    ),

    /// Card Theme — white with border, no shadow
    cardTheme: const CardThemeData(
      color: Color(0xffffffff),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: Color(0xFFE0E0E0), width: 1),
      ),
    ),

    /// Text Theme
    textTheme: const TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: Color(0xFF212121),
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: Color(0xFF212121),
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: Color(0xFF757575),
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF212121),
      ),
      titleSmall: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF212121),
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: Color(0xFF212121),
      ),
      labelMedium: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: Color(0xFF757575),
      ),
      labelSmall: TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w500,
        color: Color(0xFF757575),
      ),
    ),

    /// Colorscheme
    colorScheme: ColorScheme.light(
      primary: CustomTheme.primary,
      onPrimary: Colors.white,
      secondary: CustomTheme.primary,
      onSecondary: Colors.white,
      surface: Colors.white,
      onSurface: const Color(0xFF212121),
    ),

    /// Input Decoration Theme — square corners
    inputDecorationTheme: InputDecorationTheme(
      filled: false,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      isDense: true,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1.5, color: CustomTheme.primary),
      ),
      enabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
      ),
      disabledBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
      ),
      errorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Color(0xFFD32F2F)),
      ),
      focusedErrorBorder: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1.5, color: Color(0xFFD32F2F)),
      ),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Color(0xFFE0E0E0)),
      ),
    ),

    /// Floating Action Button — square, primary, minimal elevation
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: CustomTheme.primary,
      splashColor: Colors.white.withAlpha(80),
      highlightElevation: 4,
      elevation: 2,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
      ),
      focusColor: CustomTheme.primary,
      hoverColor: CustomTheme.primary,
      foregroundColor: Colors.white,
    ),

    /// Divider Theme
    dividerTheme:
        const DividerThemeData(color: Color(0xFFE0E0E0), thickness: 1),
    dividerColor: const Color(0xFFE0E0E0),

    /// Bottom AppBar Theme — white, no elevation
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Colors.white, elevation: 0),

    /// Tab bar Theme
    tabBarTheme: TabBarThemeData(
      unselectedLabelColor: const Color(0xFF757575),
      labelColor: CustomTheme.primary,
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: CustomTheme.primary, width: 2.0),
      ),
    ),

    /// CheckBox theme
    checkboxTheme: CheckboxThemeData(
      checkColor: WidgetStateProperty.all(Colors.white),
      fillColor: WidgetStateProperty.all(CustomTheme.primary),
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
    ),

    /// Radio theme
    radioTheme: RadioThemeData(
      fillColor: WidgetStateProperty.all(CustomTheme.primary),
    ),

    /// Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((state) {
        if (state.contains(WidgetState.selected)) {
          return CustomTheme.primary.withAlpha(140);
        }
        return const Color(0xFFE0E0E0);
      }),
      thumbColor: WidgetStateProperty.resolveWith((state) {
        if (state.contains(WidgetState.selected)) {
          return CustomTheme.primary;
        }
        return const Color(0xFF757575);
      }),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: CustomTheme.primary,
      inactiveTrackColor: CustomTheme.primary.withAlpha(60),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: CustomTheme.primary,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      tickMarkShape: const RoundSliderTickMarkShape(),
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
      ),
    ),

    /// Other Colors
    splashColor: Colors.white.withAlpha(100),
    indicatorColor: Colors.white,
    highlightColor: Colors.white.withAlpha(50),
  );

  /// -------------------------- Dark Theme  -------------------------------------------- ///
  static final ThemeData darkTheme = ThemeData(
    /// Brightness
    brightness: Brightness.dark,

    /// Primary Color
    primaryColor: const Color(0xff069DEF),

    /// Scaffold and Background color
    scaffoldBackgroundColor: const Color(0xff161616),
    canvasColor: Colors.transparent,

    /// AppBar Theme
    appBarTheme: const AppBarTheme(backgroundColor: Color(0xff161616)),

    /// Card Theme
    cardTheme: const CardThemeData(color: Color(0xff222327)),

    /// Colorscheme
    colorScheme: const ColorScheme.dark(
      primary: Color(0xff069DEF),
      secondary: Color(0xff069DEF),
      onPrimary: Colors.white,
      onSurface: Color(0xfff3f3f3),
      onSecondary: Colors.white,
      surface: Color(0xff585e63),
    ),

    /// Input (Text-Field) Theme
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Color(0xff069DEF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.zero,
        borderSide: BorderSide(width: 1, color: Colors.white70),
      ),
      border: OutlineInputBorder(
          borderRadius: BorderRadius.zero,
          borderSide: BorderSide(width: 1, color: Colors.white70)),
    ),

    /// Divider Color
    dividerTheme:
        const DividerThemeData(color: Color(0xff363636), thickness: 1),
    dividerColor: const Color(0xff363636),

    /// Floating Action Theme
    floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: const Color(0xff069DEF),
        splashColor: Colors.white.withAlpha(100),
        highlightElevation: 8,
        elevation: 4,
        focusColor: const Color(0xff069DEF),
        hoverColor: const Color(0xff069DEF),
        foregroundColor: Colors.white),

    /// Bottom AppBar Theme
    bottomAppBarTheme:
        const BottomAppBarTheme(color: Color(0xff464c52), elevation: 2),

    /// Tab bar Theme
    tabBarTheme: const TabBarThemeData(
      unselectedLabelColor: Color(0xff495057),
      labelColor: Color(0xff069DEF),
      indicatorSize: TabBarIndicatorSize.label,
      indicator: UnderlineTabIndicator(
        borderSide: BorderSide(color: Color(0xff069DEF), width: 2.0),
      ),
    ),

    ///Switch Theme
    switchTheme: SwitchThemeData(
      trackColor: WidgetStateProperty.resolveWith((state) {
        const Set<WidgetState> interactiveStates = <WidgetState>{
          WidgetState.pressed,
          WidgetState.hovered,
          WidgetState.focused,
          WidgetState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return const Color(0xffabb3ea);
        }
        return null;
      }),
      thumbColor: WidgetStateProperty.resolveWith((state) {
        const Set<WidgetState> interactiveStates = <WidgetState>{
          WidgetState.pressed,
          WidgetState.hovered,
          WidgetState.focused,
          WidgetState.selected,
        };
        if (state.any(interactiveStates.contains)) {
          return CustomTheme.primary;
        }
        return null;
      }),
    ),

    /// Slider Theme
    sliderTheme: SliderThemeData(
      activeTrackColor: const Color(0xff069DEF),
      inactiveTrackColor: const Color(0xff069DEF).withAlpha(100),
      trackShape: const RoundedRectSliderTrackShape(),
      trackHeight: 4.0,
      thumbColor: const Color(0xff069DEF),
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10.0),
      overlayShape: const RoundSliderOverlayShape(overlayRadius: 24.0),
      tickMarkShape: const RoundSliderTickMarkShape(),
      inactiveTickMarkColor: Colors.red[100],
      valueIndicatorShape: const PaddleSliderValueIndicatorShape(),
      valueIndicatorTextStyle: const TextStyle(
        color: Colors.white,
      ),
    ),

    ///Other Color
    indicatorColor: Colors.white,
    disabledColor: const Color(0xffa3a3a3),
    highlightColor: Colors.white.withAlpha(28),
    cardColor: const Color(0xff282a2b),
    splashColor: Colors.white.withAlpha(56),
  );
}
