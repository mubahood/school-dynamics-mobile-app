import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Global error handling and crash reporting system
/// Provides comprehensive error boundaries and recovery mechanisms
class ErrorBoundarySystem {
  ErrorBoundarySystem._();

  static const globalHandler = _GlobalErrorHandler();
  static const errorBoundary = _ErrorBoundary();
  static const crashReporting = _CrashReporting();
  static const debugging = _DebuggingUtils();
}

/// Global error handling implementation
class _GlobalErrorHandler {
  const _GlobalErrorHandler();

  static bool _isInitialized = false;
  static final List<ErrorInfo> _errorHistory = [];
  static const int _maxErrorHistory = 100;

  /// Initialize global error handling
  static void initialize({
    bool enableCrashReporting = true,
    bool enableErrorLogging = true,
    Function(FlutterErrorDetails)? onError,
  }) {
    if (_isInitialized) return;

    // Set up Flutter error handling
    FlutterError.onError = (FlutterErrorDetails details) {
      _handleFlutterError(details);
      onError?.call(details);
    };

    // Set up platform dispatcher error handling
    PlatformDispatcher.instance.onError = (error, stack) {
      _handlePlatformError(error, stack);
      return true;
    };

    // Set up zone error handling
    runZonedGuarded(() {
      // Application initialization happens here
    }, (error, stackTrace) {
      _handleZoneError(error, stackTrace);
    });

    _isInitialized = true;
    debugPrint('GlobalErrorHandler: Initialized error handling system');
  }

  /// Handle Flutter framework errors
  static void _handleFlutterError(FlutterErrorDetails details) {
    final errorInfo = ErrorInfo(
      error: details.exception,
      stackTrace: details.stack,
      context: details.context?.toString(),
      library: details.library,
      timestamp: DateTime.now(),
      type: ErrorType.flutter,
    );

    _addToErrorHistory(errorInfo);
    _logError(errorInfo);

    if (kDebugMode) {
      FlutterError.presentError(details);
    }
  }

  /// Handle platform-specific errors
  static void _handlePlatformError(Object error, StackTrace stackTrace) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      type: ErrorType.platform,
    );

    _addToErrorHistory(errorInfo);
    _logError(errorInfo);
  }

  /// Handle zone errors (async errors)
  static void _handleZoneError(Object error, StackTrace stackTrace) {
    final errorInfo = ErrorInfo(
      error: error,
      stackTrace: stackTrace,
      timestamp: DateTime.now(),
      type: ErrorType.zone,
    );

    _addToErrorHistory(errorInfo);
    _logError(errorInfo);
  }

  /// Add error to history with rotation
  static void _addToErrorHistory(ErrorInfo errorInfo) {
    _errorHistory.add(errorInfo);

    // Rotate error history to prevent memory issues
    if (_errorHistory.length > _maxErrorHistory) {
      _errorHistory.removeAt(0);
    }
  }

  /// Log error with appropriate formatting
  static void _logError(ErrorInfo errorInfo) {
    debugPrint(
        '🚨 Error [${errorInfo.type.name.toUpperCase()}]: ${errorInfo.error}');
    debugPrint('📍 Context: ${errorInfo.context ?? 'Unknown'}');
    debugPrint('📚 Library: ${errorInfo.library ?? 'Unknown'}');
    debugPrint('🕐 Timestamp: ${errorInfo.timestamp.toIso8601String()}');

    if (kDebugMode && errorInfo.stackTrace != null) {
      debugPrint('📋 Stack Trace:\n${errorInfo.stackTrace}');
    }
  }

  /// Get error history
  static List<ErrorInfo> get errorHistory => List.unmodifiable(_errorHistory);

  /// Clear error history
  static void clearErrorHistory() {
    _errorHistory.clear();
    debugPrint('GlobalErrorHandler: Cleared error history');
  }

  /// Get error statistics
  static Map<String, int> getErrorStatistics() {
    final stats = <String, int>{};

    for (final errorInfo in _errorHistory) {
      final key = errorInfo.type.name;
      stats[key] = (stats[key] ?? 0) + 1;
    }

    return stats;
  }
}

/// Error boundary widgets for containing and recovering from errors
class _ErrorBoundary {
  const _ErrorBoundary();

  /// Create a global error boundary for the entire app
  static Widget createGlobalBoundary({
    required Widget child,
    Widget Function(ErrorInfo errorInfo)? errorBuilder,
    Function(ErrorInfo errorInfo)? onError,
  }) {
    return _GlobalErrorBoundaryWidget(
      child: child,
      errorBuilder: errorBuilder,
      onError: onError,
    );
  }

  /// Create a local error boundary for specific sections
  static Widget createLocalBoundary({
    required Widget child,
    Widget? fallback,
    String? context,
    Function(Object error, StackTrace? stackTrace)? onError,
  }) {
    return _LocalErrorBoundaryWidget(
      child: child,
      fallback: fallback,
      context: context,
      onError: onError,
    );
  }

  /// Create an error boundary with retry capability
  static Widget createRetryableBoundary({
    required Widget Function() childBuilder,
    Widget Function(Object error, VoidCallback retry)? errorBuilder,
    int maxRetries = 3,
    Duration retryDelay = const Duration(seconds: 1),
  }) {
    return _RetryableErrorBoundaryWidget(
      childBuilder: childBuilder,
      errorBuilder: errorBuilder,
      maxRetries: maxRetries,
      retryDelay: retryDelay,
    );
  }
}

/// Crash reporting and analytics
class _CrashReporting {
  const _CrashReporting();

  static final List<CrashReport> _crashReports = [];
  static const int _maxCrashReports = 50;

  /// Report a crash with context
  static void reportCrash({
    required Object error,
    StackTrace? stackTrace,
    Map<String, dynamic>? metadata,
    String? userId,
    String? sessionId,
  }) {
    final crashReport = CrashReport(
      error: error,
      stackTrace: stackTrace,
      metadata: metadata,
      userId: userId,
      sessionId: sessionId,
      timestamp: DateTime.now(),
    );

    _addCrashReport(crashReport);
    _sendCrashReport(crashReport);
  }

  /// Add crash report to local storage
  static void _addCrashReport(CrashReport report) {
    _crashReports.add(report);

    // Rotate crash reports
    if (_crashReports.length > _maxCrashReports) {
      _crashReports.removeAt(0);
    }
  }

  /// Send crash report to analytics service
  static void _sendCrashReport(CrashReport report) {
    // In a real implementation, this would send to a crash reporting service
    debugPrint('📊 Crash Report: ${report.error}');
    debugPrint('🔍 Metadata: ${report.metadata}');
    debugPrint('👤 User: ${report.userId ?? 'Anonymous'}');
    debugPrint('🆔 Session: ${report.sessionId ?? 'Unknown'}');
  }

  /// Get crash reports
  static List<CrashReport> get crashReports => List.unmodifiable(_crashReports);

  /// Clear crash reports
  static void clearCrashReports() {
    _crashReports.clear();
    debugPrint('CrashReporting: Cleared crash reports');
  }
}

/// Debugging utilities and information
class _DebuggingUtils {
  const _DebuggingUtils();

  /// Collect debugging information
  static Map<String, dynamic> collectDebugInfo() {
    return {
      'platform': defaultTargetPlatform.name,
      'isDebugMode': kDebugMode,
      'isReleaseMode': kReleaseMode,
      'timestamp': DateTime.now().toIso8601String(),
      'errorHistory': _GlobalErrorHandler.errorHistory.length,
      'crashReports': _CrashReporting.crashReports.length,
    };
  }

  /// Create debug overlay widget
  static Widget createDebugOverlay({
    required Widget child,
    bool showErrorCount = true,
    bool showPerformanceInfo = false,
  }) {
    return _DebugOverlayWidget(
      child: child,
      showErrorCount: showErrorCount,
      showPerformanceInfo: showPerformanceInfo,
    );
  }

  /// Enable graceful degradation mode
  static Widget enableGracefulDegradation({
    required Widget child,
    Widget? fallbackWidget,
    String? degradationMessage,
  }) {
    return _GracefulDegradationWidget(
      child: child,
      fallbackWidget: fallbackWidget,
      degradationMessage: degradationMessage,
    );
  }
}

// Data classes for error handling

/// Error information container
class ErrorInfo {
  final Object error;
  final StackTrace? stackTrace;
  final String? context;
  final String? library;
  final DateTime timestamp;
  final ErrorType type;

  const ErrorInfo({
    required this.error,
    this.stackTrace,
    this.context,
    this.library,
    required this.timestamp,
    required this.type,
  });

  @override
  String toString() {
    return 'ErrorInfo(error: $error, context: $context, library: $library, timestamp: $timestamp, type: $type)';
  }
}

/// Crash report container
class CrashReport {
  final Object error;
  final StackTrace? stackTrace;
  final Map<String, dynamic>? metadata;
  final String? userId;
  final String? sessionId;
  final DateTime timestamp;

  const CrashReport({
    required this.error,
    this.stackTrace,
    this.metadata,
    this.userId,
    this.sessionId,
    required this.timestamp,
  });

  @override
  String toString() {
    return 'CrashReport(error: $error, userId: $userId, sessionId: $sessionId, timestamp: $timestamp)';
  }
}

/// Error type enumeration
enum ErrorType {
  flutter,
  platform,
  zone,
  network,
  custom,
}

// Widget implementations for error boundaries

class _GlobalErrorBoundaryWidget extends StatefulWidget {
  final Widget child;
  final Widget Function(ErrorInfo errorInfo)? errorBuilder;
  final Function(ErrorInfo errorInfo)? onError;

  const _GlobalErrorBoundaryWidget({
    required this.child,
    this.errorBuilder,
    this.onError,
  });

  @override
  State<_GlobalErrorBoundaryWidget> createState() =>
      _GlobalErrorBoundaryWidgetState();
}

class _GlobalErrorBoundaryWidgetState
    extends State<_GlobalErrorBoundaryWidget> {
  ErrorInfo? _currentError;

  @override
  Widget build(BuildContext context) {
    if (_currentError != null && widget.errorBuilder != null) {
      return widget.errorBuilder!(_currentError!);
    }

    return widget.child;
  }

  void _handleError(ErrorInfo errorInfo) {
    setState(() {
      _currentError = errorInfo;
    });
    widget.onError?.call(errorInfo);
  }
}

class _LocalErrorBoundaryWidget extends StatefulWidget {
  final Widget child;
  final Widget? fallback;
  final String? context;
  final Function(Object error, StackTrace? stackTrace)? onError;

  const _LocalErrorBoundaryWidget({
    required this.child,
    this.fallback,
    this.context,
    this.onError,
  });

  @override
  State<_LocalErrorBoundaryWidget> createState() =>
      _LocalErrorBoundaryWidgetState();
}

class _LocalErrorBoundaryWidgetState extends State<_LocalErrorBoundaryWidget> {
  bool _hasError = false;

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return widget.fallback ?? _buildDefaultErrorWidget();
    }

    return widget.child;
  }

  Widget _buildDefaultErrorWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline,
            size: 48,
            color: Theme.of(context).colorScheme.error,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            widget.context ?? 'An error occurred in this section.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _RetryableErrorBoundaryWidget extends StatefulWidget {
  final Widget Function() childBuilder;
  final Widget Function(Object error, VoidCallback retry)? errorBuilder;
  final int maxRetries;
  final Duration retryDelay;

  const _RetryableErrorBoundaryWidget({
    required this.childBuilder,
    this.errorBuilder,
    required this.maxRetries,
    required this.retryDelay,
  });

  @override
  State<_RetryableErrorBoundaryWidget> createState() =>
      _RetryableErrorBoundaryWidgetState();
}

class _RetryableErrorBoundaryWidgetState
    extends State<_RetryableErrorBoundaryWidget> {
  Object? _currentError;
  int _retryCount = 0;

  @override
  Widget build(BuildContext context) {
    if (_currentError != null) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(_currentError!, _retry);
      } else {
        return _buildDefaultRetryWidget();
      }
    }

    return widget.childBuilder();
  }

  Widget _buildDefaultRetryWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.refresh,
            size: 48,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Something went wrong',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Retry ${_retryCount + 1}/${widget.maxRetries}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _retry,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  void _retry() {
    if (_retryCount < widget.maxRetries) {
      setState(() {
        _currentError = null;
        _retryCount++;
      });
    }
  }
}

class _DebugOverlayWidget extends StatelessWidget {
  final Widget child;
  final bool showErrorCount;
  final bool showPerformanceInfo;

  const _DebugOverlayWidget({
    required this.child,
    required this.showErrorCount,
    required this.showPerformanceInfo,
  });

  @override
  Widget build(BuildContext context) {
    if (!kDebugMode) return child;

    return Stack(
      children: [
        child,
        Positioned(
          top: 50,
          right: 16,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black54,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (showErrorCount)
                  Text(
                    'Errors: ${_GlobalErrorHandler.errorHistory.length}',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                if (showPerformanceInfo)
                  const Text(
                    'Debug Mode',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GracefulDegradationWidget extends StatefulWidget {
  final Widget child;
  final Widget? fallbackWidget;
  final String? degradationMessage;

  const _GracefulDegradationWidget({
    required this.child,
    this.fallbackWidget,
    this.degradationMessage,
  });

  @override
  State<_GracefulDegradationWidget> createState() =>
      _GracefulDegradationWidgetState();
}

class _GracefulDegradationWidgetState
    extends State<_GracefulDegradationWidget> {
  bool _useFallback = false;

  @override
  Widget build(BuildContext context) {
    if (_useFallback) {
      return widget.fallbackWidget ?? _buildDefaultFallback();
    }

    return widget.child;
  }

  Widget _buildDefaultFallback() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning_amber,
            size: 48,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            'Limited functionality',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          Text(
            widget.degradationMessage ?? 'Some features may not be available.',
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _enableFallback() {
    setState(() {
      _useFallback = true;
    });
  }
}
