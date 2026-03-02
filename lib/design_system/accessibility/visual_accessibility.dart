import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Visual accessibility utilities for ensuring proper contrast, focus indicators, and scalable text
/// Implements WCAG 2.1 AA compliance standards for visual accessibility
class VisualAccessibilitySystem {
  VisualAccessibilitySystem._();

  static const contrast = _ContrastManager();
  static const focus = _FocusIndicators();
  static const scaling = _TextScaling();
  static const highContrast = _HighContrastMode();
}

/// Contrast management for WCAG compliance
class _ContrastManager {
  const _ContrastManager();

  /// WCAG contrast ratio standards
  static const double _wcagAANormal = 4.5;
  static const double _wcagAALarge = 3.0;
  static const double _wcagAAANormal = 7.0;
  static const double _wcagAAALarge = 4.5;

  /// Ensure sufficient color contrast ratios
  static Color ensureContrast({
    required Color foreground,
    required Color background,
    double minRatio = _wcagAANormal,
    bool preferDarker = true,
  }) {
    final currentRatio = calculateContrastRatio(foreground, background);

    if (currentRatio >= minRatio) {
      return foreground;
    }

    return _adjustColorForContrast(
      foreground: foreground,
      background: background,
      targetRatio: minRatio,
      preferDarker: preferDarker,
    );
  }

  /// Calculate contrast ratio between two colors
  static double calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = _calculateLuminance(color1);
    final luminance2 = _calculateLuminance(color2);

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Calculate relative luminance of a color
  static double _calculateLuminance(Color color) {
    final r = _linearizeColorComponent(color.red / 255.0);
    final g = _linearizeColorComponent(color.green / 255.0);
    final b = _linearizeColorComponent(color.blue / 255.0);

    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Linearize color component for luminance calculation
  static double _linearizeColorComponent(double component) {
    if (component <= 0.03928) {
      return component / 12.92;
    } else {
      return ((component + 0.055) / 1.055).pow(2.4);
    }
  }

  /// Adjust color to meet contrast requirements
  static Color _adjustColorForContrast({
    required Color foreground,
    required Color background,
    required double targetRatio,
    required bool preferDarker,
  }) {
    final hsl = HSLColor.fromColor(foreground);
    final backgroundLuminance = _calculateLuminance(background);

    // Determine if we should make the color lighter or darker
    double lightness = hsl.lightness;
    final step = 0.01;

    if (preferDarker) {
      // Try making darker first
      while (lightness > 0) {
        lightness -= step;
        final testColor =
            hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
        if (calculateContrastRatio(testColor, background) >= targetRatio) {
          return testColor;
        }
      }

      // If darkening doesn't work, try lightening
      lightness = hsl.lightness;
      while (lightness < 1) {
        lightness += step;
        final testColor =
            hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
        if (calculateContrastRatio(testColor, background) >= targetRatio) {
          return testColor;
        }
      }
    } else {
      // Try making lighter first
      while (lightness < 1) {
        lightness += step;
        final testColor =
            hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
        if (calculateContrastRatio(testColor, background) >= targetRatio) {
          return testColor;
        }
      }

      // If lightening doesn't work, try darkening
      lightness = hsl.lightness;
      while (lightness > 0) {
        lightness -= step;
        final testColor =
            hsl.withLightness(lightness.clamp(0.0, 1.0)).toColor();
        if (calculateContrastRatio(testColor, background) >= targetRatio) {
          return testColor;
        }
      }
    }

    // Fallback to high contrast colors
    return backgroundLuminance > 0.5 ? Colors.black : Colors.white;
  }

  /// Create accessible color palette
  static Map<String, Color> createAccessiblePalette({
    required Color primary,
    required Color background,
  }) {
    return {
      'primary': ensureContrast(
        foreground: primary,
        background: background,
        minRatio: _wcagAANormal,
      ),
      'secondary': ensureContrast(
        foreground: primary.withOpacity(0.7),
        background: background,
        minRatio: _wcagAANormal,
      ),
      'success': ensureContrast(
        foreground: Colors.green,
        background: background,
        minRatio: _wcagAANormal,
      ),
      'warning': ensureContrast(
        foreground: Colors.orange,
        background: background,
        minRatio: _wcagAANormal,
      ),
      'error': ensureContrast(
        foreground: Colors.red,
        background: background,
        minRatio: _wcagAANormal,
      ),
      'info': ensureContrast(
        foreground: Colors.blue,
        background: background,
        minRatio: _wcagAANormal,
      ),
    };
  }

  /// Validate color combination accessibility
  static AccessibilityReport validateColorCombination({
    required Color foreground,
    required Color background,
    required double fontSize,
  }) {
    final ratio = calculateContrastRatio(foreground, background);
    final isLargeText = fontSize >= 18 || (fontSize >= 14 && _isBoldText());

    final aaMinRatio = isLargeText ? _wcagAALarge : _wcagAANormal;
    final aaaMinRatio = isLargeText ? _wcagAAALarge : _wcagAAANormal;

    return AccessibilityReport(
      contrastRatio: ratio,
      passesWcagAA: ratio >= aaMinRatio,
      passesWcagAAA: ratio >= aaaMinRatio,
      recommendedForeground: ratio < aaMinRatio
          ? ensureContrast(
              foreground: foreground,
              background: background,
              minRatio: aaMinRatio,
            )
          : null,
    );
  }

  static bool _isBoldText() {
    // In a real implementation, this would check the actual font weight
    return false;
  }
}

/// Focus indicators for keyboard navigation
class _FocusIndicators {
  const _FocusIndicators();

  /// Add focus indicators for keyboard navigation
  static Widget addFocusIndicator({
    required Widget child,
    Color? focusColor,
    double borderWidth = 2.0,
    BorderRadius? borderRadius,
    bool showFocusRing = true,
  }) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;

          if (!showFocusRing || !hasFocus) {
            return child;
          }

          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                color: focusColor ?? Theme.of(context).focusColor,
                width: borderWidth,
              ),
              borderRadius: borderRadius ?? BorderRadius.zero,
            ),
            child: child,
          );
        },
      ),
    );
  }

  /// Create accessible button with focus indicator
  static Widget accessibleFocusButton({
    required Widget child,
    required VoidCallback onPressed,
    Color? focusColor,
    String? tooltip,
  }) {
    return addFocusIndicator(
      focusColor: focusColor,
      child: Tooltip(
        message: tooltip ?? '',
        child: TextButton(
          onPressed: onPressed,
          child: child,
        ),
      ),
    );
  }

  /// Create accessible text field with focus indicator
  static Widget accessibleFocusTextField({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    Color? focusColor,
    bool enabled = true,
  }) {
    return Focus(
      child: Builder(
        builder: (context) {
          final hasFocus = Focus.of(context).hasFocus;

          return TextFormField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              labelText: labelText,
              hintText: hintText,
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: focusColor ?? Theme.of(context).primaryColor,
                  width: 2.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
              disabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey),
              ),
            ),
          );
        },
      ),
    );
  }

  /// Create accessible focus scope for grouped elements
  static Widget createFocusScope({
    required List<Widget> children,
    String? scopeLabel,
  }) {
    return FocusScope(
      child: Semantics(
        label: scopeLabel,
        child: Column(children: children),
      ),
    );
  }
}

/// Text scaling implementation
class _TextScaling {
  const _TextScaling();

  /// Implement scalable text support
  static Widget scalableText(
    String text, {
    TextStyle? style,
    double? maxScaleFactor,
    double? minScaleFactor,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        var scaleFactor = mediaQuery.textScaleFactor;

        // Apply constraints
        if (maxScaleFactor != null) {
          scaleFactor = scaleFactor.clamp(0.0, maxScaleFactor);
        }
        if (minScaleFactor != null) {
          scaleFactor = scaleFactor.clamp(minScaleFactor, double.infinity);
        }

        return MediaQuery(
          data: mediaQuery.copyWith(textScaleFactor: scaleFactor),
          child: Text(
            text,
            style: style,
            textAlign: textAlign,
            maxLines: maxLines,
            overflow: overflow,
          ),
        );
      },
    );
  }

  /// Create responsive text that adapts to screen size
  static Widget responsiveText(
    String text, {
    required double baseFontSize,
    TextStyle? baseStyle,
    double minFontSize = 12,
    double maxFontSize = 32,
  }) {
    return Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final scaleFactor = MediaQuery.of(context).textScaleFactor;

        // Calculate responsive font size
        double fontSize = baseFontSize;
        if (screenWidth < 360) {
          fontSize = baseFontSize * 0.9;
        } else if (screenWidth > 600) {
          fontSize = baseFontSize * 1.1;
        }

        // Apply text scale factor with limits
        fontSize *= scaleFactor;
        fontSize = fontSize.clamp(minFontSize, maxFontSize);

        return Text(
          text,
          style: (baseStyle ?? const TextStyle()).copyWith(fontSize: fontSize),
        );
      },
    );
  }

  /// Check if large text is enabled
  static bool isLargeTextEnabled(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor > 1.3;
  }

  /// Get appropriate font size for accessibility
  static double getAccessibleFontSize({
    required double baseFontSize,
    required double textScaleFactor,
    double maxSize = 28,
  }) {
    return (baseFontSize * textScaleFactor).clamp(baseFontSize, maxSize);
  }
}

/// High contrast mode support
class _HighContrastMode {
  const _HighContrastMode();

  /// Add high contrast mode support
  static Widget withHighContrastSupport({
    required Widget child,
    Widget? highContrastChild,
  }) {
    return Builder(
      builder: (context) {
        final isHighContrast = MediaQuery.of(context).highContrast;

        if (isHighContrast && highContrastChild != null) {
          return highContrastChild;
        }

        return child;
      },
    );
  }

  /// Create high contrast color scheme
  static ColorScheme createHighContrastColorScheme({
    Brightness brightness = Brightness.light,
  }) {
    if (brightness == Brightness.dark) {
      return const ColorScheme.dark(
        primary: Colors.white,
        secondary: Colors.white,
        surface: Colors.black,
        background: Colors.black,
        error: Colors.red,
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        onSurface: Colors.white,
        onBackground: Colors.white,
        onError: Colors.white,
      );
    } else {
      return const ColorScheme.light(
        primary: Colors.black,
        secondary: Colors.black,
        surface: Colors.white,
        background: Colors.white,
        error: Colors.red,
        onPrimary: Colors.white,
        onSecondary: Colors.white,
        onSurface: Colors.black,
        onBackground: Colors.black,
        onError: Colors.white,
      );
    }
  }

  /// Create clear visual hierarchies
  static Widget createVisualHierarchy({
    required Widget title,
    required Widget content,
    List<Widget>? actions,
    bool useHighContrast = false,
  }) {
    return Builder(
      builder: (context) {
        final theme = Theme.of(context);
        final isHighContrast =
            useHighContrast || MediaQuery.of(context).highContrast;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isHighContrast
                    ? (theme.brightness == Brightness.light
                        ? Colors.black
                        : Colors.white)
                    : theme.primaryColor,
                border: isHighContrast ? Border.all(width: 2) : null,
              ),
              child: DefaultTextStyle(
                style: TextStyle(
                  color: isHighContrast
                      ? (theme.brightness == Brightness.light
                          ? Colors.white
                          : Colors.black)
                      : theme.colorScheme.onPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                child: title,
              ),
            ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                border: isHighContrast ? Border.all(width: 1) : null,
              ),
              child: content,
            ),
            if (actions != null)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  border: isHighContrast ? Border.all(width: 1) : null,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: actions,
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Extension for double to add power function
extension DoubleExtensions on double {
  double pow(double exponent) {
    return this < 0 ? -(-this).pow(exponent) : this.pow(exponent);
  }
}

/// Data classes for accessibility reporting
class AccessibilityReport {
  final double contrastRatio;
  final bool passesWcagAA;
  final bool passesWcagAAA;
  final Color? recommendedForeground;

  const AccessibilityReport({
    required this.contrastRatio,
    required this.passesWcagAA,
    required this.passesWcagAAA,
    this.recommendedForeground,
  });

  @override
  String toString() {
    return 'AccessibilityReport(ratio: ${contrastRatio.toStringAsFixed(2)}, '
        'WCAG AA: $passesWcagAA, WCAG AAA: $passesWcagAAA)';
  }
}

/// Accessibility utilities and helpers
class VisualAccessibilityUtils {
  /// Create accessible theme with proper contrast
  static ThemeData createAccessibleTheme({
    required ColorScheme colorScheme,
    bool highContrast = false,
  }) {
    if (highContrast) {
      colorScheme = _HighContrastMode.createHighContrastColorScheme(
        brightness: colorScheme.brightness,
      );
    }

    return ThemeData(
      colorScheme: colorScheme,
      useMaterial3: true,

      // Ensure adequate touch targets
      materialTapTargetSize: MaterialTapTargetSize.padded,

      // Improve focus visibility
      focusColor: colorScheme.primary.withOpacity(0.3),

      // Accessible text theme
      textTheme: TextTheme(
        displayLarge: TextStyle(
          color: _ContrastManager.ensureContrast(
            foreground: colorScheme.onBackground,
            background: colorScheme.background,
          ),
        ),
        headlineLarge: TextStyle(
          color: _ContrastManager.ensureContrast(
            foreground: colorScheme.onBackground,
            background: colorScheme.background,
          ),
        ),
        bodyLarge: TextStyle(
          color: _ContrastManager.ensureContrast(
            foreground: colorScheme.onBackground,
            background: colorScheme.background,
          ),
          fontSize: 16, // Minimum readable size
        ),
        bodyMedium: TextStyle(
          color: _ContrastManager.ensureContrast(
            foreground: colorScheme.onBackground,
            background: colorScheme.background,
          ),
          fontSize: 14, // Minimum readable size
        ),
      ),
    );
  }

  /// Validate accessibility compliance
  static Map<String, dynamic> validateAccessibility({
    required BuildContext context,
    required Widget widget,
  }) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);

    return {
      'textScale': mediaQuery.textScaleFactor,
      'highContrast': mediaQuery.highContrast,
      'reduceMotion': mediaQuery.disableAnimations,
      'contrastRatio': _ContrastManager.calculateContrastRatio(
        theme.colorScheme.onBackground,
        theme.colorScheme.background,
      ),
      'wcagCompliant': _ContrastManager.calculateContrastRatio(
            theme.colorScheme.onBackground,
            theme.colorScheme.background,
          ) >=
          4.5,
    };
  }
}
