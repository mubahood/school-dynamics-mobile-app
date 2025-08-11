import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

/// Widget refactoring utilities for improving code organization and maintainability
/// Addresses code quality issues identified in static analysis
class WidgetRefactoring {
  WidgetRefactoring._();

  static const componentExtractor = _ComponentExtractor();
  static const compositionHelper = _CompositionHelper();
  static const documentationHelper = _DocumentationHelper();
  static const namingHelper = _NamingHelper();
}

/// Component extraction utilities for creating reusable widgets
class _ComponentExtractor {
  const _ComponentExtractor();

  /// Extract common UI patterns into reusable components
  static Widget extractReusableComponent({
    required String componentName,
    required Widget Function(BuildContext context) builder,
    String? documentation,
  }) {
    return _ExtractedComponent(
      componentName: componentName,
      builder: builder,
      documentation: documentation,
    );
  }

  /// Create a configurable widget with customizable properties
  static Widget createConfigurableWidget({
    required String widgetName,
    required Widget Function(Map<String, dynamic> config) builder,
    Map<String, dynamic>? defaultConfig,
  }) {
    return _ConfigurableWidget(
      widgetName: widgetName,
      builder: builder,
      config: defaultConfig ?? {},
    );
  }

  /// Extract repeated layout patterns
  static Widget extractLayoutPattern({
    required String patternName,
    required List<Widget> children,
    EdgeInsetsGeometry? padding,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    bool isVertical = true,
  }) {
    return _LayoutPattern(
      patternName: patternName,
      children: children,
      padding: padding,
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      isVertical: isVertical,
    );
  }

  /// Extract form input patterns
  static Widget extractInputPattern({
    required String label,
    required TextEditingController controller,
    String? hint,
    String? error,
    IconData? prefixIcon,
    Widget? suffixIcon,
    bool isRequired = false,
    TextInputType? keyboardType,
    bool obscureText = false,
    String? Function(String?)? validator,
  }) {
    return _InputPattern(
      label: label,
      controller: controller,
      hint: hint,
      error: error,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isRequired: isRequired,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
    );
  }
}

/// Widget composition helpers for better separation of concerns
class _CompositionHelper {
  const _CompositionHelper();

  /// Compose widgets with proper separation of concerns
  static Widget composeWidget({
    required String widgetName,
    required Widget Function() buildUI,
    VoidCallback? onInitialize,
    VoidCallback? onDispose,
    Map<String, dynamic>? dependencies,
  }) {
    return _ComposedWidget(
      widgetName: widgetName,
      buildUI: buildUI,
      onInitialize: onInitialize,
      onDispose: onDispose,
      dependencies: dependencies,
    );
  }

  /// Create business logic separation
  static Widget separateBusinessLogic({
    required Widget child,
    required Map<String, Function> businessLogic,
    String? contextName,
  }) {
    return _BusinessLogicSeparator(
      child: child,
      businessLogic: businessLogic,
      contextName: contextName,
    );
  }

  /// Create presentation layer separation
  static Widget separatePresentationLayer({
    required Widget Function(Map<String, dynamic> data) builder,
    required Map<String, dynamic> presentationData,
    String? layerName,
  }) {
    return _PresentationLayer(
      builder: builder,
      presentationData: presentationData,
      layerName: layerName,
    );
  }
}

/// Documentation and commenting helpers
class _DocumentationHelper {
  const _DocumentationHelper();

  /// Add comprehensive documentation to widgets
  static Widget documentedWidget({
    required Widget child,
    required String purpose,
    List<String>? dependencies,
    List<String>? usageNotes,
    String? author,
    DateTime? created,
    DateTime? lastModified,
  }) {
    return _DocumentedWidget(
      child: child,
      purpose: purpose,
      dependencies: dependencies,
      usageNotes: usageNotes,
      author: author,
      created: created,
      lastModified: lastModified,
    );
  }

  /// Generate widget documentation
  static Map<String, dynamic> generateDocumentation({
    required String widgetName,
    required String description,
    required List<String> properties,
    List<String>? methods,
    List<String>? examples,
  }) {
    return {
      'widgetName': widgetName,
      'description': description,
      'properties': properties,
      'methods': methods ?? [],
      'examples': examples ?? [],
      'generatedAt': DateTime.now().toIso8601String(),
    };
  }
}

/// Consistent naming convention helpers
class _NamingHelper {
  const _NamingHelper();

  /// Validate widget naming conventions
  static bool isValidWidgetName(String name) {
    // Widget names should be PascalCase
    final regex = RegExp(r'^[A-Z][a-zA-Z0-9]*$');
    return regex.hasMatch(name);
  }

  /// Validate variable naming conventions
  static bool isValidVariableName(String name) {
    // Variable names should be camelCase
    final regex = RegExp(r'^[a-z][a-zA-Z0-9]*$');
    return regex.hasMatch(name);
  }

  /// Validate file naming conventions
  static bool isValidFileName(String name) {
    // File names should be snake_case
    final regex = RegExp(r'^[a-z][a-z0-9_]*\.dart$');
    return regex.hasMatch(name);
  }

  /// Convert string to PascalCase
  static String toPascalCase(String input) {
    if (input.isEmpty) return input;

    final words = input.split(RegExp(r'[_\s-]+'));
    return words.map((word) {
      if (word.isEmpty) return word;
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join();
  }

  /// Convert string to camelCase
  static String toCamelCase(String input) {
    final pascalCase = toPascalCase(input);
    if (pascalCase.isEmpty) return pascalCase;
    return pascalCase[0].toLowerCase() + pascalCase.substring(1);
  }

  /// Convert string to snake_case
  static String toSnakeCase(String input) {
    return input
        .replaceAllMapped(
            RegExp(r'[A-Z]'), (match) => '_${match.group(0)!.toLowerCase()}')
        .replaceAll(RegExp(r'^_'), '')
        .replaceAll(RegExp(r'[_\s-]+'), '_')
        .toLowerCase();
  }
}

// Implementation classes for the extracted patterns

class _ExtractedComponent extends StatelessWidget {
  final String componentName;
  final Widget Function(BuildContext context) builder;
  final String? documentation;

  const _ExtractedComponent({
    required this.componentName,
    required this.builder,
    this.documentation,
  });

  @override
  Widget build(BuildContext context) {
    if (kDebugMode && documentation != null) {
      debugPrint('Building component: $componentName - $documentation');
    }
    return builder(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('componentName', componentName));
    properties.add(StringProperty('documentation', documentation));
  }
}

class _ConfigurableWidget extends StatelessWidget {
  final String widgetName;
  final Widget Function(Map<String, dynamic> config) builder;
  final Map<String, dynamic> config;

  const _ConfigurableWidget({
    required this.widgetName,
    required this.builder,
    required this.config,
  });

  @override
  Widget build(BuildContext context) {
    return builder(config);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('widgetName', widgetName));
    properties.add(DiagnosticsProperty('config', config));
  }
}

class _LayoutPattern extends StatelessWidget {
  final String patternName;
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final MainAxisAlignment mainAxisAlignment;
  final CrossAxisAlignment crossAxisAlignment;
  final bool isVertical;

  const _LayoutPattern({
    required this.patternName,
    required this.children,
    this.padding,
    required this.mainAxisAlignment,
    required this.crossAxisAlignment,
    required this.isVertical,
  });

  @override
  Widget build(BuildContext context) {
    Widget child = isVertical
        ? Column(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          )
        : Row(
            mainAxisAlignment: mainAxisAlignment,
            crossAxisAlignment: crossAxisAlignment,
            children: children,
          );

    if (padding != null) {
      child = Padding(padding: padding!, child: child);
    }

    return child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('patternName', patternName));
    properties.add(FlagProperty('isVertical', value: isVertical));
  }
}

class _InputPattern extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final String? hint;
  final String? error;
  final IconData? prefixIcon;
  final Widget? suffixIcon;
  final bool isRequired;
  final TextInputType? keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;

  const _InputPattern({
    required this.label,
    required this.controller,
    this.hint,
    this.error,
    this.prefixIcon,
    this.suffixIcon,
    required this.isRequired,
    this.keyboardType,
    required this.obscureText,
    this.validator,
  });

  @override
  State<_InputPattern> createState() => _InputPatternState();
}

class _InputPatternState extends State<_InputPattern> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.label,
            style: Theme.of(context).textTheme.labelLarge,
            children: widget.isRequired
                ? [
                    TextSpan(
                      text: ' *',
                      style:
                          TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  ]
                : null,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: widget.controller,
          decoration: InputDecoration(
            hintText: widget.hint,
            prefixIcon:
                widget.prefixIcon != null ? Icon(widget.prefixIcon) : null,
            suffixIcon: widget.suffixIcon,
            errorText: widget.error,
            border: const OutlineInputBorder(),
          ),
          keyboardType: widget.keyboardType,
          obscureText: widget.obscureText,
          validator: widget.validator,
        ),
      ],
    );
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('label', widget.label));
    properties.add(FlagProperty('isRequired', value: widget.isRequired));
    properties.add(FlagProperty('obscureText', value: widget.obscureText));
  }
}

class _ComposedWidget extends StatefulWidget {
  final String widgetName;
  final Widget Function() buildUI;
  final VoidCallback? onInitialize;
  final VoidCallback? onDispose;
  final Map<String, dynamic>? dependencies;

  const _ComposedWidget({
    required this.widgetName,
    required this.buildUI,
    this.onInitialize,
    this.onDispose,
    this.dependencies,
  });

  @override
  State<_ComposedWidget> createState() => _ComposedWidgetState();
}

class _ComposedWidgetState extends State<_ComposedWidget> {
  @override
  void initState() {
    super.initState();
    widget.onInitialize?.call();
  }

  @override
  void dispose() {
    widget.onDispose?.call();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.buildUI();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('widgetName', widget.widgetName));
    properties.add(DiagnosticsProperty('dependencies', widget.dependencies));
  }
}

class _BusinessLogicSeparator extends StatelessWidget {
  final Widget child;
  final Map<String, Function> businessLogic;
  final String? contextName;

  const _BusinessLogicSeparator({
    required this.child,
    required this.businessLogic,
    this.contextName,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('contextName', contextName));
    properties
        .add(DiagnosticsProperty('businessLogic', businessLogic.keys.toList()));
  }
}

class _PresentationLayer extends StatelessWidget {
  final Widget Function(Map<String, dynamic> data) builder;
  final Map<String, dynamic> presentationData;
  final String? layerName;

  const _PresentationLayer({
    required this.builder,
    required this.presentationData,
    this.layerName,
  });

  @override
  Widget build(BuildContext context) {
    return builder(presentationData);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('layerName', layerName));
    properties.add(DiagnosticsProperty('presentationData', presentationData));
  }
}

class _DocumentedWidget extends StatelessWidget {
  final Widget child;
  final String purpose;
  final List<String>? dependencies;
  final List<String>? usageNotes;
  final String? author;
  final DateTime? created;
  final DateTime? lastModified;

  const _DocumentedWidget({
    required this.child,
    required this.purpose,
    this.dependencies,
    this.usageNotes,
    this.author,
    this.created,
    this.lastModified,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(StringProperty('purpose', purpose));
    properties.add(StringProperty('author', author));
    properties.add(DiagnosticsProperty('created', created));
    properties.add(DiagnosticsProperty('lastModified', lastModified));
    properties.add(IterableProperty('dependencies', dependencies));
    properties.add(IterableProperty('usageNotes', usageNotes));
  }
}
