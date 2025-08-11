import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Unified color palette for the School Dynamics app
///
/// This class provides a centralized color system that supports
/// dynamic primary colors based on school branding while maintaining
/// consistent semantic colors and accessibility standards.
///
/// Note: Primary colors are dynamic and depend on school branding configuration
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ========================================
  // DYNAMIC PRIMARY COLORS (School Branding)
  // ========================================

  /// Dynamic primary color - changes based on school branding
  /// Default: Professional Blue
  static Color primary = const Color.fromRGBO(25, 131, 192, 1.0);

  /// Dynamic primary dark variant
  static Color primaryDark = const Color.fromRGBO(8, 79, 124, 1.0);

  /// Dynamic primary light variant
  static Color primaryLight = const Color.fromRGBO(77, 166, 215, 1.0);

  /// Color to use on top of primary color
  static const Color onPrimary = Color(0xFFFFFFFF);

  /// Primary surface color for backgrounds
  static Color primarySurface = const Color.fromRGBO(239, 248, 255, 1.0);

  // ========================================
  // SEMANTIC COLORS (Fixed for consistency)
  // ========================================

  /// Success color for positive actions and states
  static const Color success = Color(0xFF068425);
  static const Color successLight = Color(0xFFE8F5E8);

  /// Warning color for cautionary states
  static const Color warning = Color(0xFFFF9800);
  static const Color warningLight = Color(0xFFFFF3E0);

  /// Error color for destructive actions and errors
  static const Color error = Color(0xFFF44336);
  static const Color errorLight = Color(0xFFFFEBEE);

  /// Info color for informational content
  static const Color info = Color(0xFF2196F3);
  static const Color infoLight = Color(0xFFE3F2FD);

  // ========================================
  // NEUTRAL COLORS (Grayscale)
  // ========================================

  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);

  /// Text colors
  static const Color textPrimary = Color(0xFF212121);
  static const Color textSecondary = Color(0xFF757575);
  static const Color textDisabled = Color(0xFFBDBDBD);

  /// Background colors
  static const Color background = Color(0xFFFFFFFF);
  static const Color backgroundSecondary = Color(0xFFF5F5F5);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF3F3F3);

  /// Border colors
  static const Color border = Color(0xFFE0E0E0);
  static const Color borderStrong = Color(0xFFBDBDBD);
  static const Color divider = Color(0xFFE0E0E0);

  // ========================================
  // EDUCATIONAL THEME COLORS
  // ========================================

  /// Academic achievement colors
  static const Color academic = Color(0xFF6A1B9A);
  static const Color academicLight = Color(0xFFF3E5F5);

  /// Student activity colors
  static const Color student = Color(0xFF388E3C);
  static const Color studentLight = Color(0xFFE8F5E8);

  /// Administrative colors
  static const Color admin = Color(0xFF1976D2);
  static const Color adminLight = Color(0xFFE3F2FD);

  /// Financial colors
  static const Color finance = Color(0xFFE65100);
  static const Color financeLight = Color(0xFFFFF3E0);

  // ========================================
  // DARK MODE COLORS
  // ========================================

  /// Dark mode text colors
  static const Color darkTextPrimary = Color(0xFFFFFFFF);
  static const Color darkTextSecondary = Color(0xFFB3B3B3);
  static const Color darkTextDisabled = Color(0xFF666666);

  /// Dark mode background colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkBackgroundSecondary = Color(0xFF1E1E1E);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceVariant = Color(0xFF2C2C2C);

  /// Dark mode border colors
  static const Color darkBorder = Color(0xFF333333);
  static const Color darkBorderStrong = Color(0xFF555555);
  static const Color darkDivider = Color(0xFF333333);

  // ========================================
  // UTILITY METHODS
  // ========================================

  /// Updates the primary color system based on school branding
  /// This method should be called when school configuration changes
  static void updatePrimaryColors({
    required Color newPrimary,
    Color? newPrimaryDark,
    Color? newPrimaryLight,
    Color? newPrimarySurface,
  }) {
    primary = newPrimary;
    primaryDark = newPrimaryDark ?? _generateDarkVariant(newPrimary);
    primaryLight = newPrimaryLight ?? _generateLightVariant(newPrimary);
    primarySurface = newPrimarySurface ?? _generateSurfaceVariant(newPrimary);
  }

  /// Generates a darker variant of the given color
  static Color _generateDarkVariant(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.2).clamp(0.0, 1.0)).toColor();
  }

  /// Generates a lighter variant of the given color
  static Color _generateLightVariant(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + 0.2).clamp(0.0, 1.0)).toColor();
  }

  /// Generates a surface variant of the given color
  static Color _generateSurfaceVariant(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness(0.95).withSaturation(0.3).toColor();
  }

  /// Checks if a color meets WCAG 2.1 AA contrast requirements
  static bool isAccessibleContrast(Color foreground, Color background) {
    final double contrastRatio =
        _calculateContrastRatio(foreground, background);
    return contrastRatio >= 4.5; // WCAG AA standard
  }

  /// Calculates the contrast ratio between two colors
  static double _calculateContrastRatio(Color color1, Color color2) {
    final double luminance1 = _calculateLuminance(color1);
    final double luminance2 = _calculateLuminance(color2);

    final double lightest = luminance1 > luminance2 ? luminance1 : luminance2;
    final double darkest = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lightest + 0.05) / (darkest + 0.05);
  }

  /// Calculates the relative luminance of a color
  static double _calculateLuminance(Color color) {
    final double r = _linearizeColorComponent(color.r / 255.0);
    final double g = _linearizeColorComponent(color.g / 255.0);
    final double b = _linearizeColorComponent(color.b / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearizes a color component for luminance calculation
  static double _linearizeColorComponent(double component) {
    return component <= 0.03928
        ? component / 12.92
        : math.pow((component + 0.055) / 1.055, 2.4).toDouble();
  }
}
