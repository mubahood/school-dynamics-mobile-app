import 'package:flutter/material.dart';

/// Spacing and sizing constants for the School Dynamics app
///
/// Provides a consistent spacing system based on 8px grid
/// following Material Design 3 principles with educational optimizations.
class AppSpacing {
  // Private constructor to prevent instantiation
  AppSpacing._();

  // ========================================
  // BASE SPACING UNIT (8px grid)
  // ========================================

  /// Base spacing unit - all spacing should be multiples of this
  static const double _baseUnit = 8.0;

  // ========================================
  // SPACING VALUES
  // ========================================

  /// Extra small spacing - 4px
  static const double xs = _baseUnit * 0.5;

  /// Small spacing - 8px
  static const double sm = _baseUnit * 1;

  /// Medium spacing - 16px
  static const double md = _baseUnit * 2;

  /// Large spacing - 24px
  static const double lg = _baseUnit * 3;

  /// Extra large spacing - 32px
  static const double xl = _baseUnit * 4;

  /// Extra extra large spacing - 48px
  static const double xxl = _baseUnit * 6;

  /// Extra extra extra large spacing - 64px
  static const double xxxl = _baseUnit * 8;

  // ========================================
  // COMPONENT SPECIFIC SPACING
  // ========================================

  /// Card padding
  static const double cardPadding = md;

  /// Button padding horizontal
  static const double buttonPaddingHorizontal = lg;

  /// Button padding vertical
  static const double buttonPaddingVertical = sm;

  /// Input field padding
  static const double inputPadding = md;

  /// List item padding
  static const double listItemPadding = md;

  /// Screen edge padding
  static const double screenPadding = md;

  /// Section spacing
  static const double sectionSpacing = xl;

  /// Grid item spacing
  static const double gridSpacing = sm;

  // ========================================
  // EDUCATIONAL SPECIFIC SPACING
  // ========================================

  /// Dashboard grid spacing
  static const double dashboardSpacing = md;

  /// Menu item spacing
  static const double menuItemSpacing = sm;

  /// Grade display spacing
  static const double gradeSpacing = xs;

  /// Student card spacing
  static const double studentCardSpacing = md;

  // ========================================
  // EDGE INSETS
  // ========================================

  /// All sides extra small
  static const EdgeInsets allXS = EdgeInsets.all(xs);

  /// All sides small
  static const EdgeInsets allSM = EdgeInsets.all(sm);

  /// All sides medium
  static const EdgeInsets allMD = EdgeInsets.all(md);

  /// All sides large
  static const EdgeInsets allLG = EdgeInsets.all(lg);

  /// All sides extra large
  static const EdgeInsets allXL = EdgeInsets.all(xl);

  /// All sides extra extra large
  static const EdgeInsets allXXL = EdgeInsets.all(xxl);

  // ========================================
  // HORIZONTAL EDGE INSETS
  // ========================================

  /// Horizontal extra small
  static const EdgeInsets horizontalXS = EdgeInsets.symmetric(horizontal: xs);

  /// Horizontal small
  static const EdgeInsets horizontalSM = EdgeInsets.symmetric(horizontal: sm);

  /// Horizontal medium
  static const EdgeInsets horizontalMD = EdgeInsets.symmetric(horizontal: md);

  /// Horizontal large
  static const EdgeInsets horizontalLG = EdgeInsets.symmetric(horizontal: lg);

  /// Horizontal extra large
  static const EdgeInsets horizontalXL = EdgeInsets.symmetric(horizontal: xl);

  // ========================================
  // VERTICAL EDGE INSETS
  // ========================================

  /// Vertical extra small
  static const EdgeInsets verticalXS = EdgeInsets.symmetric(vertical: xs);

  /// Vertical small
  static const EdgeInsets verticalSM = EdgeInsets.symmetric(vertical: sm);

  /// Vertical medium
  static const EdgeInsets verticalMD = EdgeInsets.symmetric(vertical: md);

  /// Vertical large
  static const EdgeInsets verticalLG = EdgeInsets.symmetric(vertical: lg);

  /// Vertical extra large
  static const EdgeInsets verticalXL = EdgeInsets.symmetric(vertical: xl);

  // ========================================
  // COMPONENT SPECIFIC EDGE INSETS
  // ========================================

  /// Screen edge padding
  static const EdgeInsets screen = EdgeInsets.all(screenPadding);

  /// Card padding
  static const EdgeInsets card = EdgeInsets.all(cardPadding);

  /// Button padding
  static const EdgeInsets button = EdgeInsets.symmetric(
    horizontal: buttonPaddingHorizontal,
    vertical: buttonPaddingVertical,
  );

  /// Input field padding
  static const EdgeInsets input = EdgeInsets.all(inputPadding);

  /// List item padding
  static const EdgeInsets listItem = EdgeInsets.all(listItemPadding);

  // ========================================
  // SIZED BOXES (for spacing between widgets)
  // ========================================

  /// Vertical gap extra small
  static const Widget gapXS = SizedBox(height: xs);

  /// Vertical gap small
  static const Widget gapSM = SizedBox(height: sm);

  /// Vertical gap medium
  static const Widget gapMD = SizedBox(height: md);

  /// Vertical gap large
  static const Widget gapLG = SizedBox(height: lg);

  /// Vertical gap extra large
  static const Widget gapXL = SizedBox(height: xl);

  /// Vertical gap extra extra large
  static const Widget gapXXL = SizedBox(height: xxl);

  // ========================================
  // HORIZONTAL SIZED BOXES
  // ========================================

  /// Horizontal gap extra small
  static const Widget hGapXS = SizedBox(width: xs);

  /// Horizontal gap small
  static const Widget hGapSM = SizedBox(width: sm);

  /// Horizontal gap medium
  static const Widget hGapMD = SizedBox(width: md);

  /// Horizontal gap large
  static const Widget hGapLG = SizedBox(width: lg);

  /// Horizontal gap extra large
  static const Widget hGapXL = SizedBox(width: xl);

  // ========================================
  // BORDER RADIUS VALUES
  // ========================================

  /// No border radius
  static const double radiusNone = 0.0;

  /// Small border radius - 4px
  static const double radiusSM = 4.0;

  /// Medium border radius - 8px
  static const double radiusMD = 8.0;

  /// Large border radius - 12px
  static const double radiusLG = 12.0;

  /// Extra large border radius - 16px
  static const double radiusXL = 16.0;

  /// Round border radius - 1000px (for fully rounded elements)
  static const double radiusRound = 1000.0;

  // ========================================
  // BORDER RADIUS OBJECTS
  // ========================================

  /// Small border radius
  static const BorderRadius borderRadiusSM =
      BorderRadius.all(Radius.circular(radiusSM));

  /// Medium border radius
  static const BorderRadius borderRadiusMD =
      BorderRadius.all(Radius.circular(radiusMD));

  /// Large border radius
  static const BorderRadius borderRadiusLG =
      BorderRadius.all(Radius.circular(radiusLG));

  /// Extra large border radius
  static const BorderRadius borderRadiusXL =
      BorderRadius.all(Radius.circular(radiusXL));

  /// Round border radius
  static const BorderRadius borderRadiusRound =
      BorderRadius.all(Radius.circular(radiusRound));

  // ========================================
  // ELEVATION VALUES
  // ========================================

  /// No elevation
  static const double elevationNone = 0.0;

  /// Small elevation - 2dp
  static const double elevationSM = 2.0;

  /// Medium elevation - 4dp
  static const double elevationMD = 4.0;

  /// Large elevation - 8dp
  static const double elevationLG = 8.0;

  /// Extra large elevation - 16dp
  static const double elevationXL = 16.0;

  // ========================================
  // TOUCH TARGET SIZES
  // ========================================

  /// Minimum touch target size (44x44dp for accessibility)
  static const double minTouchTarget = 44.0;

  /// Standard touch target size (48x48dp)
  static const double standardTouchTarget = 48.0;

  /// Large touch target size (56x56dp)
  static const double largeTouchTarget = 56.0;

  // ========================================
  // ICON SIZES
  // ========================================

  /// Small icon size - 16px
  static const double iconSM = 16.0;

  /// Medium icon size - 24px
  static const double iconMD = 24.0;

  /// Large icon size - 32px
  static const double iconLG = 32.0;

  /// Extra large icon size - 48px
  static const double iconXL = 48.0;

  // ========================================
  // UTILITY METHODS
  // ========================================

  /// Creates custom EdgeInsets with specified values
  static EdgeInsets custom({
    double? all,
    double? horizontal,
    double? vertical,
    double? top,
    double? bottom,
    double? left,
    double? right,
  }) {
    if (all != null) {
      return EdgeInsets.all(all);
    } else if (horizontal != null || vertical != null) {
      return EdgeInsets.symmetric(
        horizontal: horizontal ?? 0,
        vertical: vertical ?? 0,
      );
    } else {
      return EdgeInsets.only(
        top: top ?? 0,
        bottom: bottom ?? 0,
        left: left ?? 0,
        right: right ?? 0,
      );
    }
  }

  /// Creates a vertical gap with custom height
  static Widget gap(double height) => SizedBox(height: height);

  /// Creates a horizontal gap with custom width
  static Widget hGap(double width) => SizedBox(width: width);

  /// Creates custom border radius
  static BorderRadius borderRadius(double radius) =>
      BorderRadius.all(Radius.circular(radius));
}
