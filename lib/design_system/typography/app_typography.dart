import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Typography system for the School Dynamics app
///
/// Provides a consistent, scalable typography hierarchy following
/// Material Design 3 principles with educational app optimizations.
class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  // ========================================
  // FONT FAMILIES
  // ========================================

  /// Primary font family for the app (Inter)
  /// Modern, highly readable font optimized for digital interfaces
  static const String _primaryFontFamily = 'Inter';

  /// Secondary font family for emphasis (Roboto)
  /// Google's font designed for Android and educational content
  static const String _secondaryFontFamily = 'Roboto';

  // ========================================
  // DISPLAY TEXT STYLES
  // ========================================

  /// Display Large - For prominent headers and hero text
  static TextStyle get displayLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 57,
        fontWeight: FontWeight.w400,
        letterSpacing: -0.25,
        height: 1.12,
      );

  /// Display Medium - For section headers
  static TextStyle get displayMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 45,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.16,
      );

  /// Display Small - For subsection headers
  static TextStyle get displaySmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 36,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.22,
      );

  // ========================================
  // HEADLINE TEXT STYLES
  // ========================================

  /// Headline Large - For page titles
  static TextStyle get headlineLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 32,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.25,
      );

  /// Headline Medium - For screen titles
  static TextStyle get headlineMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 28,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.29,
      );

  /// Headline Small - For card titles and sections
  static TextStyle get headlineSmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 24,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.33,
      );

  // ========================================
  // TITLE TEXT STYLES
  // ========================================

  /// Title Large - For prominent titles
  static TextStyle get titleLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 22,
        fontWeight: FontWeight.w400,
        letterSpacing: 0,
        height: 1.27,
      );

  /// Title Medium - For standard titles
  static TextStyle get titleMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      );

  /// Title Small - For small titles and labels
  static TextStyle get titleSmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  // ========================================
  // BODY TEXT STYLES
  // ========================================

  /// Body Large - For prominent body text
  static TextStyle get bodyLarge => GoogleFonts.getFont(
        _secondaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.5,
        height: 1.50,
      );

  /// Body Medium - For standard body text
  static TextStyle get bodyMedium => GoogleFonts.getFont(
        _secondaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.25,
        height: 1.43,
      );

  /// Body Small - For secondary body text
  static TextStyle get bodySmall => GoogleFonts.getFont(
        _secondaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w400,
        letterSpacing: 0.4,
        height: 1.33,
      );

  // ========================================
  // LABEL TEXT STYLES
  // ========================================

  /// Label Large - For prominent labels and buttons
  static TextStyle get labelLarge => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  /// Label Medium - For standard labels
  static TextStyle get labelMedium => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 12,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.33,
      );

  /// Label Small - For small labels and captions
  static TextStyle get labelSmall => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 11,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.5,
        height: 1.45,
      );

  // ========================================
  // EDUCATIONAL SPECIFIC STYLES
  // ========================================

  /// Grade text style - For displaying grades and scores
  static TextStyle get gradeText => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.22,
      );

  /// Student name style - For student lists and cards
  static TextStyle get studentName => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.15,
        height: 1.50,
      );

  /// Subject text style - For academic subjects
  static TextStyle get subjectText => GoogleFonts.getFont(
        _secondaryFontFamily,
        fontSize: 14,
        fontWeight: FontWeight.w500,
        letterSpacing: 0.1,
        height: 1.43,
      );

  /// Amount text style - For financial amounts
  static TextStyle get amountText => GoogleFonts.getFont(
        _primaryFontFamily,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        letterSpacing: 0,
        height: 1.25,
      );

  // ========================================
  // UTILITY METHODS
  // ========================================

  /// Creates a responsive text style based on screen size
  static TextStyle responsive({
    required TextStyle baseStyle,
    required double scaleFactor,
  }) {
    return baseStyle.copyWith(
      fontSize: (baseStyle.fontSize ?? 14) * scaleFactor,
    );
  }

  /// Applies color to a text style
  static TextStyle colored(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Applies weight override to a text style
  static TextStyle weighted(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Creates a text style with custom letter spacing
  static TextStyle spaced(TextStyle style, double letterSpacing) {
    return style.copyWith(letterSpacing: letterSpacing);
  }

  // ========================================
  // THEME INTEGRATION
  // ========================================

  /// Creates a TextTheme for Material Theme integration
  static TextTheme get materialTextTheme => TextTheme(
        displayLarge: displayLarge,
        displayMedium: displayMedium,
        displaySmall: displaySmall,
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        headlineSmall: headlineSmall,
        titleLarge: titleLarge,
        titleMedium: titleMedium,
        titleSmall: titleSmall,
        bodyLarge: bodyLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
        labelLarge: labelLarge,
        labelMedium: labelMedium,
        labelSmall: labelSmall,
      );

  /// Creates a dark theme variant of the text theme
  static TextTheme get darkTextTheme => materialTextTheme.apply(
        bodyColor: Colors.white,
        displayColor: Colors.white,
      );
}

/// Extension for easy access to typography from BuildContext
extension TypographyExtension on BuildContext {
  AppTypography get typography => AppTypography._();
}
