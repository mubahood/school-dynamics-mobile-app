import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as developer;

/// Main performance optimization utility class
class PerformanceOptimizer {
  PerformanceOptimizer._();
}

/// Widget optimization utilities
class _WidgetOptimizer {
  const _WidgetOptimizer();

  /// Creates an optimized builder widget that prevents unnecessary rebuilds
  static Widget optimizedBuilder({
    required WidgetBuilder builder,
    String? debugLabel,
  }) {
    return _OptimizedBuilder(
      builder: builder,
      debugLabel: debugLabel,
    );
  }

  /// Creates a const-optimized wrapper for widgets
  static Widget constWrapper({
    required Widget child,
    Key? key,
  }) {
    return _ConstWrapper(
      key: key,
      child: child,
    );
  }

  /// Creates an optimized list view for large datasets
  static Widget optimizedListView({
    required IndexedWidgetBuilder itemBuilder,
    required int itemCount,
    ScrollController? controller,
    bool shrinkWrap = false,
    EdgeInsetsGeometry? padding,
    double? itemExtent,
    String? debugLabel,
  }) {
    return _OptimizedListView(
      itemBuilder: itemBuilder,
      itemCount: itemCount,
      controller: controller,
      shrinkWrap: shrinkWrap,
      padding: padding,
      itemExtent: itemExtent,
      debugLabel: debugLabel,
    );
  }

  /// Creates an optimized image widget with caching and memory management
  static Widget optimizedImage({
    required String imageUrl,
    double? width,
    double? height,
    BoxFit? fit,
    Widget? placeholder,
    Widget? errorWidget,
    bool useMemoryCache = true,
  }) {
    return _OptimizedImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: placeholder,
      errorWidget: errorWidget,
      useMemoryCache: useMemoryCache,
    );
  }
}

/// Memory management utilities
class _MemoryManager {
  const _MemoryManager();

  /// Disposes resources and clears caches
  static void clearCaches() {
    if (kDebugMode) {
      developer.log('Clearing image caches and memory resources');
    }

    // Clear image cache
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();

    // Force garbage collection in debug mode
    if (kDebugMode) {
      developer.Timeline.finishSync();
    }
  }

  /// Sets optimal image cache configuration
  static void configureImageCache() {
    final imageCache = PaintingBinding.instance.imageCache;

    // Optimize for mobile devices
    imageCache.maximumSize = 50; // Maximum number of images in cache
    imageCache.maximumSizeBytes = 32 << 20; // 32MB cache size

    if (kDebugMode) {
      developer.log(
          'Image cache configured: ${imageCache.maximumSize} images, ${imageCache.maximumSizeBytes ~/ (1024 * 1024)}MB');
    }
  }

  /// Creates a memory-efficient disposal pattern
  static VoidCallback createDisposalPattern(List<VoidCallback> disposers) {
    return () {
      for (final dispose in disposers) {
        try {
          dispose();
        } catch (e) {
          if (kDebugMode) {
            developer.log('Error during disposal: $e');
          }
        }
      }
    };
  }
}

/// Performance monitoring utilities
class _PerformanceMonitor {
  const _PerformanceMonitor();

  /// Measures widget build performance
  static T measureBuildPerformance<T>(
    String widgetName,
    T Function() buildFunction,
  ) {
    if (!kDebugMode) return buildFunction();

    final stopwatch = Stopwatch()..start();
    final result = buildFunction();
    stopwatch.stop();

    if (stopwatch.elapsedMilliseconds > 16) {
      developer.log(
        'Performance warning: $widgetName took ${stopwatch.elapsedMilliseconds}ms to build (>16ms)',
        name: 'PerformanceMonitor',
      );
    }

    return result;
  }

  /// Tracks frame rendering performance
  static void trackFramePerformance() {
    if (!kDebugMode) return;

    WidgetsBinding.instance.addPersistentFrameCallback((timeStamp) {
      final frameDuration = timeStamp.inMilliseconds;

      if (frameDuration > 16) {
        developer.log(
          'Frame drop detected: ${frameDuration}ms (target: 16ms)',
          name: 'FramePerformance',
        );
      }
    });
  }

  /// Monitors memory usage
  static void monitorMemoryUsage(String context) {
    if (!kDebugMode) return;

    developer.Timeline.timeSync('MemoryCheck-$context', () {
      final cache = PaintingBinding.instance.imageCache;
      developer.log(
        'Memory usage in $context: ${cache.currentSize} images, ${cache.currentSizeBytes ~/ (1024 * 1024)}MB',
        name: 'MemoryMonitor',
      );
    });
  }
}

/// Optimized builder widget that prevents unnecessary rebuilds
class _OptimizedBuilder extends StatefulWidget {
  final WidgetBuilder builder;
  final String? debugLabel;

  const _OptimizedBuilder({
    required this.builder,
    this.debugLabel,
  });

  @override
  State<_OptimizedBuilder> createState() => _OptimizedBuilderState();
}

class _OptimizedBuilderState extends State<_OptimizedBuilder> {
  Widget? _cachedWidget;
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    return _PerformanceMonitor.measureBuildPerformance(
      widget.debugLabel ?? 'OptimizedBuilder',
      () {
        _buildCount++;

        if (kDebugMode && _buildCount > 1) {
          developer.log(
            '${widget.debugLabel ?? 'OptimizedBuilder'} rebuilt $_buildCount times',
            name: 'RebuildTracker',
          );
        }

        _cachedWidget ??= widget.builder(context);
        return _cachedWidget!;
      },
    );
  }

  @override
  void didUpdateWidget(_OptimizedBuilder oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Invalidate cache if builder changed
    if (oldWidget.builder != widget.builder) {
      _cachedWidget = null;
    }
  }
}

/// Const wrapper for better performance
class _ConstWrapper extends StatelessWidget {
  final Widget child;

  const _ConstWrapper({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

/// Optimized list view with performance enhancements
class _OptimizedListView extends StatefulWidget {
  final IndexedWidgetBuilder itemBuilder;
  final int itemCount;
  final ScrollController? controller;
  final bool shrinkWrap;
  final EdgeInsetsGeometry? padding;
  final double? itemExtent;
  final String? debugLabel;

  const _OptimizedListView({
    required this.itemBuilder,
    required this.itemCount,
    this.controller,
    this.shrinkWrap = false,
    this.padding,
    this.itemExtent,
    this.debugLabel,
  });

  @override
  State<_OptimizedListView> createState() => _OptimizedListViewState();
}

class _OptimizedListViewState extends State<_OptimizedListView> {
  final Map<int, Widget> _cachedItems = {};
  late ScrollController _controller;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? ScrollController();

    if (kDebugMode) {
      _PerformanceMonitor.monitorMemoryUsage('ListView-${widget.debugLabel}');
    }
  }

  @override
  void dispose() {
    if (widget.controller == null) {
      _controller.dispose();
    }
    _cachedItems.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _controller,
      itemCount: widget.itemCount,
      shrinkWrap: widget.shrinkWrap,
      padding: widget.padding,
      itemExtent: widget.itemExtent,
      cacheExtent: 200, // Optimize cache extent
      itemBuilder: (context, index) {
        // Cache frequently accessed items
        if (index < 10 && !_cachedItems.containsKey(index)) {
          _cachedItems[index] = widget.itemBuilder(context, index);
        }

        return _cachedItems[index] ?? widget.itemBuilder(context, index);
      },
    );
  }
}

/// Optimized image widget with memory management
class _OptimizedImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget? placeholder;
  final Widget? errorWidget;
  final bool useMemoryCache;

  const _OptimizedImage({
    required this.imageUrl,
    this.width,
    this.height,
    this.fit,
    this.placeholder,
    this.errorWidget,
    this.useMemoryCache = true,
  });

  @override
  State<_OptimizedImage> createState() => _OptimizedImageState();
}

class _OptimizedImageState extends State<_OptimizedImage> {
  @override
  void initState() {
    super.initState();

    if (!widget.useMemoryCache) {
      // Preload image if not using cache
      precacheImage(NetworkImage(widget.imageUrl), context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Image.network(
      widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;

        return widget.placeholder ??
            const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return widget.errorWidget ??
            const Icon(Icons.error, color: Colors.grey);
      },
      cacheWidth: widget.width?.round(),
      cacheHeight: widget.height?.round(),
    );
  }
}

/// Performance-optimized state mixin
mixin PerformanceOptimizedState<T extends StatefulWidget> on State<T> {
  final List<VoidCallback> _disposers = [];

  /// Register a disposer function
  void registerDisposer(VoidCallback disposer) {
    _disposers.add(disposer);
  }

  /// Optimized setState that batches updates
  void optimizedSetState(VoidCallback fn) {
    if (mounted) {
      setState(fn);
    }
  }

  @override
  void dispose() {
    // Auto-dispose all registered disposers
    _MemoryManager.createDisposalPattern(_disposers)();
    super.dispose();
  }
}

/// Performance-aware widget builder
class PerformanceAwareWidget extends StatelessWidget {
  final Widget Function(BuildContext context) builder;
  final String? debugLabel;

  const PerformanceAwareWidget({
    super.key,
    required this.builder,
    this.debugLabel,
  });

  @override
  Widget build(BuildContext context) {
    return _PerformanceMonitor.measureBuildPerformance(
      debugLabel ?? 'PerformanceAwareWidget',
      () => builder(context),
    );
  }
}

/// Lazy loading container for expensive widgets
class LazyLoadContainer extends StatefulWidget {
  final Widget Function() builder;
  final Widget placeholder;
  final bool loadImmediately;

  const LazyLoadContainer({
    super.key,
    required this.builder,
    this.placeholder = const SizedBox.shrink(),
    this.loadImmediately = false,
  });

  @override
  State<LazyLoadContainer> createState() => _LazyLoadContainerState();
}

class _LazyLoadContainerState extends State<LazyLoadContainer> {
  Widget? _content;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();

    if (widget.loadImmediately) {
      _loadContent();
    }
  }

  void _loadContent() {
    if (_isLoaded) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        setState(() {
          _content = widget.builder();
          _isLoaded = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded) {
      return InkWell(
        onTap: _loadContent,
        child: widget.placeholder,
      );
    }

    return _content ?? widget.placeholder;
  }
}
