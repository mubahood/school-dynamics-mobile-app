import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/semantics.dart';

/// Accessibility utilities for implementing comprehensive screen reader support
/// Ensures the app is inclusive and accessible to users with disabilities
class AccessibilitySystem {
  AccessibilitySystem._();

  static const screenReader = _ScreenReaderSupport();
  static const semantics = _SemanticHelpers();
  static const navigation = _AccessibleNavigation();
  static const announcements = _StateAnnouncements();
}

/// Screen reader support implementation
class _ScreenReaderSupport {
  const _ScreenReaderSupport();

  /// Add semantic labels to interactive elements
  static Widget addSemanticLabel({
    required Widget child,
    required String label,
    String? hint,
    String? value,
    bool excludeSemantics = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    bool isButton = false,
    bool isLink = false,
    bool isHeader = false,
    bool isTextField = false,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      value: value,
      excludeSemantics: excludeSemantics,
      onTap: onTap,
      onLongPress: onLongPress,
      button: isButton,
      link: isLink,
      header: isHeader,
      textField: isTextField,
      child: child,
    );
  }

  /// Create accessible button with proper semantics
  static Widget accessibleButton({
    required Widget child,
    required VoidCallback onPressed,
    required String semanticLabel,
    String? tooltip,
    bool enabled = true,
  }) {
    return Semantics(
      label: semanticLabel,
      hint: tooltip,
      button: true,
      enabled: enabled,
      excludeSemantics: true,
      child: Tooltip(
        message: tooltip ?? semanticLabel,
        child: child,
      ),
    );
  }

  /// Create accessible text field with proper labeling
  static Widget accessibleTextField({
    required TextEditingController controller,
    required String label,
    String? hint,
    String? errorText,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLines,
    Function(String)? onChanged,
  }) {
    final semanticLabel = isRequired ? '$label (required)' : label;

    return Semantics(
      label: semanticLabel,
      hint: hint,
      textField: true,
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          errorText: errorText,
          suffixText: isRequired ? '*' : null,
        ),
        keyboardType: keyboardType,
        obscureText: obscureText,
        maxLines: maxLines,
        onChanged: onChanged,
      ),
    );
  }

  /// Create accessible image with content description
  static Widget accessibleImage({
    required ImageProvider image,
    required String semanticLabel,
    String? description,
    double? width,
    double? height,
    BoxFit? fit,
    bool isDecorative = false,
  }) {
    if (isDecorative) {
      return ExcludeSemantics(
        child: Image(
          image: image,
          width: width,
          height: height,
          fit: fit,
        ),
      );
    }

    return Semantics(
      label: semanticLabel,
      hint: description,
      image: true,
      child: Image(
        image: image,
        width: width,
        height: height,
        fit: fit,
      ),
    );
  }

  /// Create accessible list with proper item semantics
  static Widget accessibleListView({
    required int itemCount,
    required Widget Function(BuildContext context, int index) itemBuilder,
    required String Function(int index) semanticIndexLabel,
    ScrollController? controller,
    bool shrinkWrap = false,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      controller: controller,
      shrinkWrap: shrinkWrap,
      itemBuilder: (context, index) {
        return Semantics(
          label: semanticIndexLabel(index),
          child: itemBuilder(context, index),
        );
      },
    );
  }
}

/// Semantic helpers for proper accessibility structure
class _SemanticHelpers {
  const _SemanticHelpers();

  /// Create proper heading hierarchy
  static Widget createHeading({
    required Widget child,
    required int level,
    String? semanticLabel,
  }) {
    return Semantics(
      header: true,
      label: semanticLabel,
      sortKey: OrdinalSortKey(level.toDouble()),
      child: child,
    );
  }

  /// Create semantic group for related content
  static Widget createGroup({
    required List<Widget> children,
    required String groupLabel,
    String? description,
  }) {
    return Semantics(
      label: groupLabel,
      hint: description,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// Create landmark for major page sections
  static Widget createLandmark({
    required Widget child,
    required String landmarkType,
    String? label,
  }) {
    return Semantics(
      container: true,
      label: label ?? landmarkType,
      child: child,
    );
  }

  /// Add reading order to widgets
  static Widget withReadingOrder({
    required Widget child,
    required double order,
  }) {
    return Semantics(
      sortKey: OrdinalSortKey(order),
      child: child,
    );
  }

  /// Create accessible expansion tile
  static Widget accessibleExpansionTile({
    required String title,
    required List<Widget> children,
    bool initiallyExpanded = false,
    String? subtitle,
  }) {
    return Semantics(
      button: true,
      hint: initiallyExpanded
          ? 'Expanded, double tap to collapse'
          : 'Collapsed, double tap to expand',
      child: ExpansionTile(
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle) : null,
        initiallyExpanded: initiallyExpanded,
        children: children
            .map((child) => Semantics(
                  excludeSemantics: false,
                  child: child,
                ))
            .toList(),
      ),
    );
  }

  /// Create accessible tab bar
  static Widget accessibleTabBar({
    required List<String> tabLabels,
    required TabController controller,
    Function(int)? onTap,
  }) {
    return Semantics(
      label: 'Tab bar with ${tabLabels.length} tabs',
      child: TabBar(
        controller: controller,
        onTap: onTap,
        tabs: tabLabels.asMap().entries.map((entry) {
          final index = entry.key;
          final label = entry.value;
          return Semantics(
            label: 'Tab ${index + 1} of ${tabLabels.length}, $label',
            button: true,
            selected: controller.index == index,
            child: Tab(text: label),
          );
        }).toList(),
      ),
    );
  }
}

/// Accessible navigation implementation
class _AccessibleNavigation {
  const _AccessibleNavigation();

  /// Create logical navigation order
  static Widget createNavigationOrder({
    required List<Widget> children,
    List<String>? navigationLabels,
  }) {
    return Column(
      children: children.asMap().entries.map((entry) {
        final index = entry.key;
        final child = entry.value;
        final label = navigationLabels?[index];

        return Semantics(
          sortKey: OrdinalSortKey(index.toDouble()),
          label: label,
          child: child,
        );
      }).toList(),
    );
  }

  /// Create accessible bottom navigation
  static Widget accessibleBottomNavigation({
    required List<BottomNavigationBarItem> items,
    required int currentIndex,
    required Function(int) onTap,
  }) {
    return Semantics(
      label: 'Bottom navigation with ${items.length} items',
      child: BottomNavigationBar(
        items: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return BottomNavigationBarItem(
            icon: Semantics(
              label: '${item.label}, tab ${index + 1} of ${items.length}',
              button: true,
              selected: currentIndex == index,
              child: item.icon,
            ),
            label: item.label,
          );
        }).toList(),
        currentIndex: currentIndex,
        onTap: onTap,
      ),
    );
  }

  /// Create accessible drawer
  static Widget accessibleDrawer({
    required List<Widget> children,
    String? drawerLabel,
  }) {
    return Semantics(
      label: drawerLabel ?? 'Navigation drawer',
      container: true,
      child: Drawer(
        child: Column(
          children: children.asMap().entries.map((entry) {
            final index = entry.key;
            final child = entry.value;

            return Semantics(
              sortKey: OrdinalSortKey(index.toDouble()),
              child: child,
            );
          }).toList(),
        ),
      ),
    );
  }

  /// Skip to main content link
  static Widget skipToMainContent({
    required GlobalKey mainContentKey,
    String label = 'Skip to main content',
  }) {
    return Semantics(
      label: label,
      button: true,
      child: TextButton(
        onPressed: () {
          final context = mainContentKey.currentContext;
          if (context != null) {
            Scrollable.ensureVisible(context);
          }
        },
        child: Text(label),
      ),
    );
  }
}

/// State announcements for dynamic content
class _StateAnnouncements {
  const _StateAnnouncements();

  /// Announce loading state
  static void announceLoading([String? message]) {
    SemanticsService.announce(
      message ?? 'Loading content',
      TextDirection.ltr,
    );
  }

  /// Announce completion state
  static void announceComplete([String? message]) {
    SemanticsService.announce(
      message ?? 'Content loaded',
      TextDirection.ltr,
    );
  }

  /// Announce error state
  static void announceError(String error) {
    SemanticsService.announce(
      'Error: $error',
      TextDirection.ltr,
    );
  }

  /// Announce success state
  static void announceSuccess([String? message]) {
    SemanticsService.announce(
      message ?? 'Action completed successfully',
      TextDirection.ltr,
    );
  }

  /// Announce navigation change
  static void announceNavigation(String destination) {
    SemanticsService.announce(
      'Navigated to $destination',
      TextDirection.ltr,
    );
  }

  /// Announce data change
  static void announceDataChange(String change) {
    SemanticsService.announce(
      change,
      TextDirection.ltr,
    );
  }

  /// Announce form validation
  static void announceValidation(String message, {bool isError = false}) {
    final prefix = isError ? 'Error: ' : 'Notice: ';
    SemanticsService.announce(
      '$prefix$message',
      TextDirection.ltr,
    );
  }
}

/// Accessibility configuration and settings
class AccessibilityConfig {
  /// Check if screen reader is enabled
  static bool get isScreenReaderEnabled {
    return WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.accessibleNavigation;
  }

  /// Check if reduce motion is enabled
  static bool get isReduceMotionEnabled {
    return WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.reduceMotion;
  }

  /// Check if high contrast is enabled
  static bool get isHighContrastEnabled {
    return WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.highContrast;
  }

  /// Check if large text is enabled
  static bool get isLargeTextEnabled {
    return WidgetsBinding
        .instance.platformDispatcher.accessibilityFeatures.boldText;
  }

  /// Get text scale factor
  static double getTextScaleFactor(BuildContext context) {
    return MediaQuery.of(context).textScaleFactor;
  }

  /// Create accessible theme data
  static ThemeData createAccessibleTheme(ThemeData baseTheme) {
    return baseTheme.copyWith(
      // Ensure sufficient contrast
      primaryColor: _ensureContrastRatio(baseTheme.primaryColor, Colors.white),

      // Increase touch targets
      materialTapTargetSize: MaterialTapTargetSize.padded,

      // Improve focus indicators
      focusColor: baseTheme.primaryColor.withOpacity(0.3),

      // Accessible text themes
      textTheme: baseTheme.textTheme.copyWith(
        bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
          fontSize: 16, // Minimum readable size
        ),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
          fontSize: 14, // Minimum readable size
        ),
      ),
    );
  }

  /// Ensure color contrast ratio meets WCAG standards
  static Color _ensureContrastRatio(Color foreground, Color background) {
    final contrastRatio = _calculateContrastRatio(foreground, background);

    if (contrastRatio >= 4.5) {
      return foreground; // Already meets WCAG AA standard
    }

    // Adjust color to meet contrast requirements
    return _adjustColorContrast(foreground, background);
  }

  /// Calculate contrast ratio between two colors
  static double _calculateContrastRatio(Color color1, Color color2) {
    final luminance1 = color1.computeLuminance();
    final luminance2 = color2.computeLuminance();

    final lighter = luminance1 > luminance2 ? luminance1 : luminance2;
    final darker = luminance1 > luminance2 ? luminance2 : luminance1;

    return (lighter + 0.05) / (darker + 0.05);
  }

  /// Adjust color to meet contrast requirements
  static Color _adjustColorContrast(Color foreground, Color background) {
    // Simple implementation - in practice, you'd want more sophisticated color adjustment
    final hsl = HSLColor.fromColor(foreground);

    // Adjust lightness to improve contrast
    final adjustedLightness = background.computeLuminance() > 0.5
        ? (hsl.lightness * 0.7) // Darken for light backgrounds
        : (hsl.lightness * 1.3).clamp(0.0, 1.0); // Lighten for dark backgrounds

    return hsl.withLightness(adjustedLightness).toColor();
  }
}

/// Common accessibility patterns and widgets
class AccessibilityPatterns {
  /// Create an accessible card with proper semantics
  static Widget accessibleCard({
    required Widget child,
    required String contentDescription,
    VoidCallback? onTap,
    String? actionHint,
  }) {
    return Semantics(
      label: contentDescription,
      hint: actionHint,
      button: onTap != null,
      child: Card(
        child: InkWell(
          onTap: onTap,
          child: child,
        ),
      ),
    );
  }

  /// Create accessible form with proper field grouping
  static Widget accessibleForm({
    required String formTitle,
    required List<Widget> fields,
    GlobalKey<FormState>? formKey,
  }) {
    return Semantics(
      label: formTitle,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _SemanticHelpers.createHeading(
              level: 2,
              semanticLabel: formTitle,
              child: Text(
                formTitle,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),
            ...fields,
          ],
        ),
      ),
    );
  }

  /// Create accessible dialog
  static Widget accessibleDialog({
    required String title,
    required Widget content,
    List<Widget>? actions,
  }) {
    return Semantics(
      label: 'Dialog: $title',
      child: AlertDialog(
        title: _SemanticHelpers.createHeading(
          level: 1,
          semanticLabel: title,
          child: Text(title),
        ),
        content: content,
        actions: actions,
      ),
    );
  }
}
