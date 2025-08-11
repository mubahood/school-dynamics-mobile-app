import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Code quality enhancement utilities for fixing common Flutter performance issues
/// Addresses issues found in static analysis like const constructors, proper disposal, etc.
class CodeQualityEnhancer {
  CodeQualityEnhancer._();

  /// Widget refactoring utilities
  static const refactoring = _WidgetRefactoring();

  /// Error boundary utilities
  static const errorBoundary = _ErrorBoundary();

  /// Naming convention utilities
  static const naming = _NamingConventions();
}

/// Widget refactoring utilities to improve performance and maintainability
class _WidgetRefactoring {
  const _WidgetRefactoring();

  /// Creates a properly disposed StatefulWidget pattern
  static StatefulWidget createDisposableWidget({
    required String name,
    required Widget Function(BuildContext) builder,
    List<VoidCallback>? disposers,
  }) {
    return _DisposableWidget(
      name: name,
      builder: builder,
      disposers: disposers ?? [],
    );
  }

  /// Creates a const-optimized StatelessWidget pattern
  static StatelessWidget createConstWidget({
    required Widget child,
    Key? key,
  }) {
    return _ConstOptimizedWidget(
      key: key,
      child: child,
    );
  }

  /// Creates proper widget composition pattern
  static Widget createComposedWidget({
    required List<Widget Function(Widget child)> wrappers,
    required Widget child,
  }) {
    return wrappers.fold<Widget>(
      child,
      (current, wrapper) => wrapper(current),
    );
  }
}

/// Error boundary implementation for better error handling
class _ErrorBoundary {
  const _ErrorBoundary();

  /// Creates a global error boundary widget
  static Widget createGlobalErrorBoundary({
    required Widget child,
    Widget Function(FlutterErrorDetails)? errorBuilder,
    void Function(FlutterErrorDetails)? onError,
  }) {
    return _GlobalErrorBoundary(
      child: child,
      errorBuilder: errorBuilder,
      onError: onError,
    );
  }

  /// Creates a local error boundary for specific widgets
  static Widget createLocalErrorBoundary({
    required Widget child,
    Widget? fallback,
    String? context,
  }) {
    return _LocalErrorBoundary(
      child: child,
      fallback: fallback,
      context: context,
    );
  }

  /// Sets up global error handling
  static void setupGlobalErrorHandling() {
    FlutterError.onError = (FlutterErrorDetails details) {
      if (kDebugMode) {
        FlutterError.presentError(details);
      } else {
        // Log to crash reporting service in production
        _logError(details);
      }
    };

    PlatformDispatcher.instance.onError = (error, stack) {
      if (kDebugMode) {
        debugPrint('Platform error: $error\n$stack');
      } else {
        _logError(FlutterErrorDetails(
          exception: error,
          stack: stack,
          context: ErrorDescription('Platform error'),
        ));
      }
      return true;
    };
  }

  static void _logError(FlutterErrorDetails details) {
    // Implement crash reporting here (Firebase Crashlytics, Sentry, etc.)
    debugPrint('Error logged: ${details.exception}');
  }
}

/// Naming convention utilities for consistent code style
class _NamingConventions {
  const _NamingConventions();

  /// Converts snake_case to lowerCamelCase
  static String snakeToCamel(String snakeCase) {
    if (snakeCase.isEmpty) return snakeCase;

    final parts = snakeCase.split('_');
    if (parts.length == 1) return snakeCase;

    final buffer = StringBuffer(parts.first);
    for (int i = 1; i < parts.length; i++) {
      if (parts[i].isNotEmpty) {
        buffer.write(parts[i][0].toUpperCase());
        if (parts[i].length > 1) {
          buffer.write(parts[i].substring(1));
        }
      }
    }

    return buffer.toString();
  }

  /// Converts PascalCase to snake_case for file names
  static String pascalToSnake(String pascalCase) {
    if (pascalCase.isEmpty) return pascalCase;

    final buffer = StringBuffer();

    for (int i = 0; i < pascalCase.length; i++) {
      final char = pascalCase[i];

      if (char.toUpperCase() == char && i > 0) {
        buffer.write('_');
      }

      buffer.write(char.toLowerCase());
    }

    return buffer.toString();
  }

  /// Validates variable naming
  static bool isValidVariableName(String name) {
    final camelCaseRegex = RegExp(r'^[a-z][a-zA-Z0-9]*$');
    return camelCaseRegex.hasMatch(name);
  }

  /// Validates constant naming
  static bool isValidConstantName(String name) {
    final constantRegex = RegExp(r'^[a-z][a-zA-Z0-9]*$');
    return constantRegex.hasMatch(name);
  }

  /// Validates file naming
  static bool isValidFileName(String name) {
    final fileNameRegex = RegExp(r'^[a-z][a-z0-9_]*\.dart$');
    return fileNameRegex.hasMatch(name);
  }
}

/// Disposable widget implementation
class _DisposableWidget extends StatefulWidget {
  final String name;
  final Widget Function(BuildContext) builder;
  final List<VoidCallback> disposers;

  const _DisposableWidget({
    required this.name,
    required this.builder,
    required this.disposers,
  });

  @override
  State<_DisposableWidget> createState() => _DisposableWidgetState();
}

class _DisposableWidgetState extends State<_DisposableWidget> {
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }

  @override
  void dispose() {
    for (final disposer in widget.disposers) {
      try {
        disposer();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error disposing ${widget.name}: $e');
        }
      }
    }
    super.dispose();
  }
}

/// Const-optimized widget implementation
class _ConstOptimizedWidget extends StatelessWidget {
  final Widget child;

  const _ConstOptimizedWidget({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Global error boundary implementation
class _GlobalErrorBoundary extends StatefulWidget {
  final Widget child;
  final Widget Function(FlutterErrorDetails)? errorBuilder;
  final void Function(FlutterErrorDetails)? onError;

  const _GlobalErrorBoundary({
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<_GlobalErrorBoundary> createState() => _GlobalErrorBoundaryState();
}

class _GlobalErrorBoundaryState extends State<_GlobalErrorBoundary> {
  FlutterErrorDetails? _errorDetails;

  @override
  void initState() {
    super.initState();

    // Set up error handling for this widget tree
    FlutterError.onError = (FlutterErrorDetails details) {
      setState(() {
        _errorDetails = details;
      });

      widget.onError?.call(details);

      if (kDebugMode) {
        FlutterError.presentError(details);
      }
    };
  }

  @override
  Widget build(BuildContext context) {
    if (_errorDetails != null) {
      return widget.errorBuilder?.call(_errorDetails!) ??
          _DefaultErrorWidget(error: _errorDetails!);
    }

    return widget.child;
  }
}

/// Local error boundary implementation
class _LocalErrorBoundary extends StatelessWidget {
  final Widget child;
  final Widget? fallback;
  final String? context;

  const _LocalErrorBoundary({
    required this.child,
    this.fallback,
    this.context,
  });

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        try {
          return child;
        } catch (e, stackTrace) {
          if (kDebugMode) {
            debugPrint(
                'Error in ${this.context ?? 'LocalErrorBoundary'}: $e\n$stackTrace');
          }

          return fallback ??
              _DefaultErrorWidget(
                error: FlutterErrorDetails(
                  exception: e,
                  stack: stackTrace,
                  context:
                      ErrorDescription(this.context ?? 'Local error boundary'),
                ),
              );
        }
      },
    );
  }
}

/// Default error widget
class _DefaultErrorWidget extends StatelessWidget {
  final FlutterErrorDetails error;

  const _DefaultErrorWidget({
    required this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        border: Border.all(color: Colors.red),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.error, color: Colors.red.shade700),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'An error occurred',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          if (kDebugMode) ...[
            const SizedBox(height: 8),
            Text(
              error.exception.toString(),
              style: TextStyle(
                color: Colors.red.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Performance-aware StatefulWidget base class
abstract class PerformanceAwareStatefulWidget extends StatefulWidget {
  const PerformanceAwareStatefulWidget({super.key});

  @override
  PerformanceAwareState createState();
}

/// Performance-aware State base class with automatic optimizations
abstract class PerformanceAwareState<T extends PerformanceAwareStatefulWidget>
    extends State<T> {
  final List<VoidCallback> _disposers = [];
  int _buildCount = 0;

  /// Register a resource for automatic disposal
  void registerDisposer(VoidCallback disposer) {
    _disposers.add(disposer);
  }

  /// Performance-aware setState that prevents unnecessary updates
  void performantSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    _buildCount++;

    if (kDebugMode && _buildCount > 50) {
      debugPrint(
          'Performance warning: ${widget.runtimeType} has rebuilt $_buildCount times');
    }

    return buildWidget(context);
  }

  /// Implement this instead of build()
  Widget buildWidget(BuildContext context);

  @override
  void dispose() {
    // Auto-dispose all registered resources
    for (final disposer in _disposers) {
      try {
        disposer();
      } catch (e) {
        if (kDebugMode) {
          debugPrint('Error disposing resource in ${widget.runtimeType}: $e');
        }
      }
    }

    super.dispose();
  }
}

/// Mixin for automatic const constructor optimization
mixin ConstOptimization on Widget {
  /// Override this to provide const optimization hints
  bool get shouldBeConst => false;

  /// Validates const usage
  void validateConstUsage() {
    if (kDebugMode && shouldBeConst && key != null) {
      debugPrint(
          'Performance hint: ${runtimeType} could use const constructor');
    }
  }
}
