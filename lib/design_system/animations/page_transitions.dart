import 'package:flutter/material.dart';

/// Custom page transition animations for the School Dynamics app
/// Provides consistent and smooth transitions between screens
class AppPageTransitions {
  AppPageTransitions._();

  /// Slide transition from right to left (default iOS style)
  static Route<T> slideFromRight<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Slide transition from bottom to top (Material style)
  static Route<T> slideFromBottom<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 350),
    RouteSettings? settings,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(0.0, 1.0);
        const end = Offset.zero;
        const curve = Curves.easeOutQuart;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// Fade transition with optional scale animation
  static Route<T> fadeScale<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 250),
    RouteSettings? settings,
    bool includeScale = true,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        var fadeAnimation = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        if (includeScale) {
          var scaleAnimation = Tween(begin: 0.9, end: 1.0).chain(
            CurveTween(curve: curve),
          );

          return FadeTransition(
            opacity: animation.drive(fadeAnimation),
            child: ScaleTransition(
              scale: animation.drive(scaleAnimation),
              child: child,
            ),
          );
        }

        return FadeTransition(
          opacity: animation.drive(fadeAnimation),
          child: child,
        );
      },
    );
  }

  /// Hero transition for image galleries or detailed views
  static Route<T> heroTransition<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 400),
    RouteSettings? settings,
    String? heroTag,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOutQuart;

        var fadeAnimation = Tween(begin: 0.0, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        var scaleAnimation = Tween(begin: 0.95, end: 1.0).chain(
          CurveTween(curve: curve),
        );

        return FadeTransition(
          opacity: animation.drive(fadeAnimation),
          child: ScaleTransition(
            scale: animation.drive(scaleAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// Shared axis transition (Material Design 3 style)
  static Route<T> sharedAxis<T extends Object?>(
    Widget page, {
    Duration duration = const Duration(milliseconds: 300),
    RouteSettings? settings,
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
  }) {
    return PageRouteBuilder<T>(
      settings: settings,
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const curve = Curves.easeInOut;

        switch (type) {
          case SharedAxisTransitionType.horizontal:
            var primarySlide = Tween(
              begin: const Offset(0.3, 0.0),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve));

            var secondarySlide = Tween(
              begin: Offset.zero,
              end: const Offset(-0.3, 0.0),
            ).chain(CurveTween(curve: curve));

            var fadeAnimation = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(primarySlide),
              child: SlideTransition(
                position: secondaryAnimation.drive(secondarySlide),
                child: FadeTransition(
                  opacity: animation.drive(fadeAnimation),
                  child: child,
                ),
              ),
            );

          case SharedAxisTransitionType.vertical:
            var primarySlide = Tween(
              begin: const Offset(0.0, 0.3),
              end: Offset.zero,
            ).chain(CurveTween(curve: curve));

            var fadeAnimation = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            return SlideTransition(
              position: animation.drive(primarySlide),
              child: FadeTransition(
                opacity: animation.drive(fadeAnimation),
                child: child,
              ),
            );

          case SharedAxisTransitionType.scaled:
            var scaleAnimation = Tween(begin: 0.8, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            var fadeAnimation = Tween(begin: 0.0, end: 1.0).chain(
              CurveTween(curve: curve),
            );

            return ScaleTransition(
              scale: animation.drive(scaleAnimation),
              child: FadeTransition(
                opacity: animation.drive(fadeAnimation),
                child: child,
              ),
            );
        }
      },
    );
  }

  /// Tab transition animation for switching between tabs
  static Widget tabTransition({
    required Widget child,
    required Animation<double> animation,
    TabTransitionType type = TabTransitionType.fade,
  }) {
    switch (type) {
      case TabTransitionType.fade:
        return FadeTransition(
          opacity: animation,
          child: child,
        );

      case TabTransitionType.slide:
        var slideAnimation = Tween(
          begin: const Offset(0.3, 0.0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));

        return SlideTransition(
          position: animation.drive(slideAnimation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );

      case TabTransitionType.scale:
        var scaleAnimation = Tween(begin: 0.95, end: 1.0).chain(
          CurveTween(curve: Curves.easeInOut),
        );

        return ScaleTransition(
          scale: animation.drive(scaleAnimation),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
    }
  }
}

/// Shared axis transition types for Material Design 3
enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

/// Tab transition types
enum TabTransitionType {
  fade,
  slide,
  scale,
}

/// Custom navigation extension for easy use of transitions
extension AppNavigationExtension on BuildContext {
  /// Navigate to a new page with slide from right transition
  Future<T?> pushSlideFromRight<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
      AppPageTransitions.slideFromRight<T>(page),
    );
  }

  /// Navigate to a new page with slide from bottom transition
  Future<T?> pushSlideFromBottom<T extends Object?>(Widget page) {
    return Navigator.of(this).push<T>(
      AppPageTransitions.slideFromBottom<T>(page),
    );
  }

  /// Navigate to a new page with fade scale transition
  Future<T?> pushFadeScale<T extends Object?>(Widget page,
      {bool includeScale = true}) {
    return Navigator.of(this).push<T>(
      AppPageTransitions.fadeScale<T>(page, includeScale: includeScale),
    );
  }

  /// Navigate to a new page with hero transition
  Future<T?> pushHero<T extends Object?>(Widget page, {String? heroTag}) {
    return Navigator.of(this).push<T>(
      AppPageTransitions.heroTransition<T>(page, heroTag: heroTag),
    );
  }

  /// Navigate to a new page with shared axis transition
  Future<T?> pushSharedAxis<T extends Object?>(
    Widget page, {
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
  }) {
    return Navigator.of(this).push<T>(
      AppPageTransitions.sharedAxis<T>(page, type: type),
    );
  }

  /// Replace current page with transition
  Future<T?> pushReplacementSlide<T extends Object?, TO extends Object?>(
    Widget page,
  ) {
    return Navigator.of(this).pushReplacement<T, TO>(
      AppPageTransitions.slideFromRight<T>(page),
    );
  }
}

/// Animated tab controller for custom tab implementations
class AnimatedTabController extends StatefulWidget {
  final List<Widget> tabs;
  final List<Widget> children;
  final int initialIndex;
  final void Function(int index)? onTabChanged;
  final TabTransitionType transitionType;
  final Duration duration;

  const AnimatedTabController({
    Key? key,
    required this.tabs,
    required this.children,
    this.initialIndex = 0,
    this.onTabChanged,
    this.transitionType = TabTransitionType.fade,
    this.duration = const Duration(milliseconds: 250),
  }) : super(key: key);

  @override
  State<AnimatedTabController> createState() => _AnimatedTabControllerState();
}

class _AnimatedTabControllerState extends State<AnimatedTabController>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _animationController = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _changeTab(int index) {
    if (index != _currentIndex) {
      _animationController.reverse().then((_) {
        setState(() {
          _currentIndex = index;
        });
        _animationController.forward();
        widget.onTabChanged?.call(index);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Tab Bar
        Row(
          children: widget.tabs.asMap().entries.map((entry) {
            final index = entry.key;
            final tab = entry.value;

            return Expanded(
              child: GestureDetector(
                onTap: () => _changeTab(index),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(
                        color: index == _currentIndex
                            ? Theme.of(context).primaryColor
                            : Colors.transparent,
                        width: 2,
                      ),
                    ),
                  ),
                  child: tab,
                ),
              ),
            );
          }).toList(),
        ),
        // Tab View
        Expanded(
          child: AppPageTransitions.tabTransition(
            animation: _animation,
            type: widget.transitionType,
            child: widget.children[_currentIndex],
          ),
        ),
      ],
    );
  }
}
