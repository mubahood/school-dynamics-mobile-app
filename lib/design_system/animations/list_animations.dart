import 'package:flutter/material.dart';

/// Provides smooth animations for list interactions in the School Dynamics app
/// Includes staggered animations, pull-to-refresh, and item insertion/removal
class AppListAnimations {
  AppListAnimations._();

  /// Creates a staggered animation for list items
  static Widget staggeredListItem({
    required Widget child,
    required int index,
    required AnimationController controller,
    Duration delay = const Duration(milliseconds: 50),
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOutQuart,
  }) {
    final itemDelay = delay * index;
    final animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: controller,
        curve: Interval(
          (itemDelay.inMilliseconds /
                  (itemDelay.inMilliseconds + duration.inMilliseconds))
              .clamp(0.0, 1.0),
          1.0,
          curve: curve,
        ),
      ),
    );

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 20 * (1 - animation.value)),
          child: Opacity(
            opacity: animation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Creates a slide-in animation for list items
  static Widget slideInListItem({
    required Widget child,
    required Animation<double> animation,
    SlideDirection direction = SlideDirection.fromBottom,
    double distance = 50.0,
  }) {
    Offset getOffset() {
      switch (direction) {
        case SlideDirection.fromLeft:
          return Offset(-distance, 0);
        case SlideDirection.fromRight:
          return Offset(distance, 0);
        case SlideDirection.fromTop:
          return Offset(0, -distance);
        case SlideDirection.fromBottom:
          return Offset(0, distance);
        case SlideDirection.toLeft:
        case SlideDirection.toRight:
        case SlideDirection.toTop:
        case SlideDirection.toBottom:
          return Offset(0, distance); // Default for slide-in
      }
    }

    final slideAnimation = Tween<Offset>(
      begin: getOffset(),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutQuart,
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: slideAnimation.value,
          child: Opacity(
            opacity: fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Creates a scale animation for item insertion
  static Widget scaleInListItem({
    required Widget child,
    required Animation<double> animation,
    Alignment alignment = Alignment.center,
  }) {
    final scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.elasticOut,
    ));

    final fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.scale(
          scale: scaleAnimation.value,
          alignment: alignment,
          child: Opacity(
            opacity: fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  /// Creates a slide-out animation for item removal
  static Widget slideOutListItem({
    required Widget child,
    required Animation<double> animation,
    SlideDirection direction = SlideDirection.toRight,
    double distance = 100.0,
  }) {
    Offset getOffset() {
      switch (direction) {
        case SlideDirection.fromLeft:
        case SlideDirection.toLeft:
          return Offset(-distance, 0);
        case SlideDirection.fromRight:
        case SlideDirection.toRight:
          return Offset(distance, 0);
        case SlideDirection.fromTop:
        case SlideDirection.toTop:
          return Offset(0, -distance);
        case SlideDirection.fromBottom:
        case SlideDirection.toBottom:
          return Offset(0, distance);
      }
    }

    final slideAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: getOffset(),
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInQuart,
    ));

    final fadeAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: animation,
      curve: Curves.easeInOut,
    ));

    return AnimatedBuilder(
      animation: animation,
      builder: (context, child) {
        return Transform.translate(
          offset: slideAnimation.value,
          child: Opacity(
            opacity: fadeAnimation.value,
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// Slide directions for animations
enum SlideDirection {
  fromLeft,
  fromRight,
  fromTop,
  fromBottom,
  toLeft,
  toRight,
  toTop,
  toBottom,
}

/// Animated list widget with built-in staggered animations
class StaggeredAnimatedList extends StatefulWidget {
  final List<Widget> children;
  final Duration staggerDelay;
  final Duration itemDuration;
  final Curve curve;
  final ScrollPhysics? physics;
  final EdgeInsetsGeometry? padding;
  final bool shrinkWrap;

  const StaggeredAnimatedList({
    Key? key,
    required this.children,
    this.staggerDelay = const Duration(milliseconds: 50),
    this.itemDuration = const Duration(milliseconds: 300),
    this.curve = Curves.easeOutQuart,
    this.physics,
    this.padding,
    this.shrinkWrap = false,
  }) : super(key: key);

  @override
  State<StaggeredAnimatedList> createState() => _StaggeredAnimatedListState();
}

class _StaggeredAnimatedListState extends State<StaggeredAnimatedList>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration:
          widget.itemDuration + (widget.staggerDelay * widget.children.length),
      vsync: this,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      physics: widget.physics,
      padding: widget.padding,
      shrinkWrap: widget.shrinkWrap,
      itemCount: widget.children.length,
      itemBuilder: (context, index) {
        return AppListAnimations.staggeredListItem(
          index: index,
          controller: _controller,
          delay: widget.staggerDelay,
          duration: widget.itemDuration,
          curve: widget.curve,
          child: widget.children[index],
        );
      },
    );
  }
}

/// Animated refresh indicator with custom animations
class AppRefreshIndicator extends StatefulWidget {
  final Widget child;
  final Future<void> Function() onRefresh;
  final Color? color;
  final Color? backgroundColor;
  final double displacement;

  const AppRefreshIndicator({
    Key? key,
    required this.child,
    required this.onRefresh,
    this.color,
    this.backgroundColor,
    this.displacement = 40.0,
  }) : super(key: key);

  @override
  State<AppRefreshIndicator> createState() => _AppRefreshIndicatorState();
}

class _AppRefreshIndicatorState extends State<AppRefreshIndicator>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _rotationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rotationController.dispose();
    super.dispose();
  }

  Future<void> _handleRefresh() async {
    _scaleController.forward();
    _rotationController.repeat();

    try {
      await widget.onRefresh();
    } finally {
      _rotationController.stop();
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      color: widget.color ?? Theme.of(context).primaryColor,
      backgroundColor: widget.backgroundColor,
      displacement: widget.displacement,
      child: widget.child,
    );
  }
}

/// Animated search results list
class AnimatedSearchResults extends StatefulWidget {
  final List<Widget> results;
  final String query;
  final Duration animationDuration;
  final Widget? emptyState;

  const AnimatedSearchResults({
    Key? key,
    required this.results,
    required this.query,
    this.animationDuration = const Duration(milliseconds: 300),
    this.emptyState,
  }) : super(key: key);

  @override
  State<AnimatedSearchResults> createState() => _AnimatedSearchResultsState();
}

class _AnimatedSearchResultsState extends State<AnimatedSearchResults>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  String _lastQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _lastQuery = widget.query;
    _controller.forward();
  }

  @override
  void didUpdateWidget(AnimatedSearchResults oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.query != _lastQuery) {
      _lastQuery = widget.query;
      _controller.reset();
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.results.isEmpty && widget.emptyState != null) {
      return FadeTransition(
        opacity: _controller,
        child: widget.emptyState!,
      );
    }

    return ListView.builder(
      itemCount: widget.results.length,
      itemBuilder: (context, index) {
        return AppListAnimations.staggeredListItem(
          index: index,
          controller: _controller,
          delay: const Duration(milliseconds: 30),
          duration: widget.animationDuration,
          child: widget.results[index],
        );
      },
    );
  }
}

/// Scroll behavior with smooth animations
class AppScrollBehavior extends ScrollBehavior {
  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
  }

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return Scrollbar(
      controller: details.controller,
      thumbVisibility: false,
      trackVisibility: false,
      child: child,
    );
  }
}

/// Extension for easy list animations
extension ListAnimationExtensions on Widget {
  /// Wrap widget with staggered animation
  Widget withStaggeredAnimation({
    required int index,
    required AnimationController controller,
    Duration delay = const Duration(milliseconds: 50),
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return AppListAnimations.staggeredListItem(
      index: index,
      controller: controller,
      delay: delay,
      duration: duration,
      child: this,
    );
  }

  /// Wrap widget with slide in animation
  Widget withSlideInAnimation({
    required Animation<double> animation,
    SlideDirection direction = SlideDirection.fromBottom,
    double distance = 50.0,
  }) {
    return AppListAnimations.slideInListItem(
      animation: animation,
      direction: direction,
      distance: distance,
      child: this,
    );
  }

  /// Wrap widget with scale in animation
  Widget withScaleInAnimation({
    required Animation<double> animation,
    Alignment alignment = Alignment.center,
  }) {
    return AppListAnimations.scaleInListItem(
      animation: animation,
      alignment: alignment,
      child: this,
    );
  }
}
