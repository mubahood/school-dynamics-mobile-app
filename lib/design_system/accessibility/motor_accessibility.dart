import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';

/// Motor accessibility utilities for ensuring adequate touch targets,
/// gesture alternatives, and multiple input methods support
class MotorAccessibilitySystem {
  MotorAccessibilitySystem._();

  static const touchTargets = _TouchTargetManager();
  static const gestures = _GestureAlternatives();
  static const input = _InputMethodSupport();
  static const timing = _TimingControl();
}

/// Touch target management for motor accessibility
class _TouchTargetManager {
  const _TouchTargetManager();

  /// Minimum touch target sizes following accessibility guidelines
  static const double minTouchTarget = 44.0; // Apple HIG and Material Design
  static const double recommendedTouchTarget = 48.0; // WCAG recommendation
  static const double largeTouch = 56.0; // For users with motor difficulties

  /// Ensure adequate touch target size
  static Widget ensureTouchTarget({
    required Widget child,
    double minSize = recommendedTouchTarget,
    EdgeInsets? padding,
    VoidCallback? onTap,
    String? semanticLabel,
  }) {
    return Semantics(
      label: semanticLabel,
      button: onTap != null,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          constraints: BoxConstraints(
            minWidth: minSize,
            minHeight: minSize,
          ),
          padding: padding ?? const EdgeInsets.all(8.0),
          child: child,
        ),
      ),
    );
  }

  /// Create accessible button with adequate touch target
  static Widget accessibleButton({
    required Widget child,
    required VoidCallback onPressed,
    double minTouchSize = recommendedTouchTarget,
    ButtonStyle? style,
    String? tooltip,
    bool enabled = true,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        constraints: BoxConstraints(
          minWidth: minTouchSize,
          minHeight: minTouchSize,
        ),
        child: ElevatedButton(
          onPressed: enabled ? onPressed : null,
          style: style,
          child: child,
        ),
      ),
    );
  }

  /// Create accessible icon button
  static Widget accessibleIconButton({
    required IconData icon,
    required VoidCallback onPressed,
    double size = 24.0,
    double minTouchSize = recommendedTouchTarget,
    Color? color,
    String? tooltip,
    bool enabled = true,
  }) {
    return Tooltip(
      message: tooltip ?? '',
      child: Container(
        constraints: BoxConstraints(
          minWidth: minTouchSize,
          minHeight: minTouchSize,
        ),
        child: IconButton(
          icon: Icon(icon, size: size, color: color),
          onPressed: enabled ? onPressed : null,
          iconSize: size,
        ),
      ),
    );
  }

  /// Create accessible floating action button
  static Widget accessibleFAB({
    required Widget child,
    required VoidCallback onPressed,
    String? tooltip,
    Color? backgroundColor,
    bool mini = false,
  }) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      backgroundColor: backgroundColor,
      mini: mini,
      child: child,
    );
  }

  /// Add spacing between interactive elements
  static Widget addInteractiveSpacing({
    required List<Widget> children,
    double spacing = 8.0,
    Axis direction = Axis.horizontal,
  }) {
    if (direction == Axis.horizontal) {
      return Row(
        children: _addSpacingBetween(children, SizedBox(width: spacing)),
      );
    } else {
      return Column(
        children: _addSpacingBetween(children, SizedBox(height: spacing)),
      );
    }
  }

  static List<Widget> _addSpacingBetween(
      List<Widget> children, Widget spacing) {
    if (children.isEmpty) return children;

    final result = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      result.add(children[i]);
      if (i < children.length - 1) {
        result.add(spacing);
      }
    }
    return result;
  }

  /// Check if touch target is adequate
  static bool isTouchTargetAdequate(Size size,
      {double minSize = minTouchTarget}) {
    return size.width >= minSize && size.height >= minSize;
  }
}

/// Gesture alternatives for accessibility
class _GestureAlternatives {
  const _GestureAlternatives();

  /// Provide alternatives to complex gestures
  static Widget accessibleGestureDetector({
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onDoubleTap,
    VoidCallback? onLongPress,
    Function(DragUpdateDetails)? onPanUpdate,
    Function(DragEndDetails)? onPanEnd,
    String? semanticLabel,
    bool provideTapAlternative = true,
    bool provideLongPressAlternative = true,
  }) {
    return Semantics(
      label: semanticLabel,
      child: GestureDetector(
        onTap: onTap,
        onDoubleTap: onDoubleTap,
        onLongPress: onLongPress,
        onPanUpdate: onPanUpdate,
        onPanEnd: onPanEnd,
        child: child,
      ),
    );
  }

  /// Create swipe alternative with buttons
  static Widget swipeAlternative({
    required Widget child,
    VoidCallback? onSwipeLeft,
    VoidCallback? onSwipeRight,
    VoidCallback? onSwipeUp,
    VoidCallback? onSwipeDown,
    bool showButtons = true,
    String? leftButtonLabel,
    String? rightButtonLabel,
    String? upButtonLabel,
    String? downButtonLabel,
  }) {
    return Column(
      children: [
        if (showButtons && onSwipeUp != null)
          _TouchTargetManager.accessibleButton(
            child: Text(upButtonLabel ?? 'Up'),
            onPressed: onSwipeUp,
          ),
        Row(
          children: [
            if (showButtons && onSwipeLeft != null)
              _TouchTargetManager.accessibleButton(
                child: Text(leftButtonLabel ?? 'Left'),
                onPressed: onSwipeLeft,
              ),
            Expanded(
              child: GestureDetector(
                onPanEnd: (details) {
                  final velocity = details.velocity.pixelsPerSecond;
                  final dx = velocity.dx;
                  final dy = velocity.dy;

                  if (dx.abs() > dy.abs()) {
                    if (dx > 0 && onSwipeRight != null) {
                      onSwipeRight();
                    } else if (dx < 0 && onSwipeLeft != null) {
                      onSwipeLeft();
                    }
                  } else {
                    if (dy > 0 && onSwipeDown != null) {
                      onSwipeDown();
                    } else if (dy < 0 && onSwipeUp != null) {
                      onSwipeUp();
                    }
                  }
                },
                child: child,
              ),
            ),
            if (showButtons && onSwipeRight != null)
              _TouchTargetManager.accessibleButton(
                child: Text(rightButtonLabel ?? 'Right'),
                onPressed: onSwipeRight,
              ),
          ],
        ),
        if (showButtons && onSwipeDown != null)
          _TouchTargetManager.accessibleButton(
            child: Text(downButtonLabel ?? 'Down'),
            onPressed: onSwipeDown,
          ),
      ],
    );
  }

  /// Create drag and drop alternative
  static Widget dragDropAlternative({
    required Widget child,
    required Function(dynamic data) onAccept,
    dynamic data,
    bool showMoveButtons = true,
    String? moveUpLabel,
    String? moveDownLabel,
    String? moveLeftLabel,
    String? moveRightLabel,
  }) {
    return Column(
      children: [
        if (showMoveButtons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (moveLeftLabel != null)
                _TouchTargetManager.accessibleButton(
                  child: Text(moveLeftLabel),
                  onPressed: () => onAccept('move_left'),
                ),
              if (moveUpLabel != null)
                _TouchTargetManager.accessibleButton(
                  child: Text(moveUpLabel),
                  onPressed: () => onAccept('move_up'),
                ),
              if (moveDownLabel != null)
                _TouchTargetManager.accessibleButton(
                  child: Text(moveDownLabel),
                  onPressed: () => onAccept('move_down'),
                ),
              if (moveRightLabel != null)
                _TouchTargetManager.accessibleButton(
                  child: Text(moveRightLabel),
                  onPressed: () => onAccept('move_right'),
                ),
            ],
          ),
        Draggable(
          data: data,
          child: child,
          feedback: Material(
            elevation: 4,
            child: child,
          ),
          childWhenDragging: Opacity(
            opacity: 0.5,
            child: child,
          ),
        ),
      ],
    );
  }

  /// Create pinch zoom alternative
  static Widget pinchZoomAlternative({
    required Widget child,
    VoidCallback? onZoomIn,
    VoidCallback? onZoomOut,
    bool showZoomButtons = true,
    double scaleFactor = 1.0,
  }) {
    return Column(
      children: [
        if (showZoomButtons)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _TouchTargetManager.accessibleIconButton(
                icon: Icons.zoom_out,
                onPressed: onZoomOut ?? () {},
                tooltip: 'Zoom Out',
              ),
              _TouchTargetManager.accessibleIconButton(
                icon: Icons.zoom_in,
                onPressed: onZoomIn ?? () {},
                tooltip: 'Zoom In',
              ),
            ],
          ),
        Expanded(
          child: InteractiveViewer(
            panEnabled: true,
            scaleEnabled: true,
            minScale: 0.5,
            maxScale: 3.0,
            child: child,
          ),
        ),
      ],
    );
  }
}

/// Input method support for accessibility
class _InputMethodSupport {
  const _InputMethodSupport();

  /// Support multiple input methods
  static Widget multiInputSupport({
    required Widget child,
    bool supportKeyboard = true,
    bool supportMouse = true,
    bool supportTouch = true,
    bool supportAssistiveDevices = true,
  }) {
    Widget result = child;

    if (supportKeyboard) {
      result = _addKeyboardSupport(result);
    }

    if (supportMouse) {
      result = _addMouseSupport(result);
    }

    if (supportAssistiveDevices) {
      result = _addAssistiveDeviceSupport(result);
    }

    return result;
  }

  static Widget _addKeyboardSupport(Widget child) {
    return Focus(
      autofocus: false,
      child: Builder(
        builder: (context) {
          return RawKeyboardListener(
            focusNode: FocusNode(),
            onKey: (RawKeyEvent event) {
              if (event is RawKeyDownEvent) {
                // Handle keyboard navigation
                if (event.logicalKey == LogicalKeyboardKey.enter ||
                    event.logicalKey == LogicalKeyboardKey.space) {
                  // Trigger tap action
                }
              }
            },
            child: child,
          );
        },
      ),
    );
  }

  static Widget _addMouseSupport(Widget child) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: child,
    );
  }

  static Widget _addAssistiveDeviceSupport(Widget child) {
    return Semantics(
      button: true,
      enabled: true,
      child: child,
    );
  }

  /// Create accessible text input
  static Widget accessibleTextInput({
    required TextEditingController controller,
    String? labelText,
    String? hintText,
    TextInputType? keyboardType,
    bool obscureText = false,
    int? maxLength,
    Function(String)? onChanged,
    Function(String)? onSubmitted,
    bool enabled = true,
    String? helpText,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: obscureText,
          maxLength: maxLength,
          onChanged: onChanged,
          onFieldSubmitted: onSubmitted,
          enabled: enabled,
          decoration: InputDecoration(
            labelText: labelText,
            hintText: hintText,
            helperText: helpText,
            border: const OutlineInputBorder(),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: enabled ? Colors.blue : Colors.grey,
                width: 2.0,
              ),
            ),
          ),
        ),
        if (helpText != null)
          Padding(
            padding: const EdgeInsets.only(top: 4.0),
            child: Text(
              helpText,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ),
      ],
    );
  }

  /// Create accessible dropdown
  static Widget accessibleDropdown<T>({
    required T? value,
    required List<DropdownMenuItem<T>> items,
    required Function(T?) onChanged,
    String? labelText,
    String? hintText,
    bool enabled = true,
  }) {
    return DropdownButtonFormField<T>(
      value: value,
      items: items,
      onChanged: enabled ? onChanged : null,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        border: const OutlineInputBorder(),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blue, width: 2.0),
        ),
      ),
    );
  }

  /// Create accessible slider
  static Widget accessibleSlider({
    required double value,
    required Function(double) onChanged,
    double min = 0.0,
    double max = 1.0,
    int? divisions,
    String? label,
    String? semanticFormatterCallback,
    bool enabled = true,
  }) {
    return Semantics(
      slider: true,
      child: Slider(
        value: value,
        onChanged: enabled ? onChanged : null,
        min: min,
        max: max,
        divisions: divisions,
        label: label,
      ),
    );
  }
}

/// Timing control for accessibility
class _TimingControl {
  const _TimingControl();

  /// Add timing controls for time-based content
  static Widget timingControl({
    required Widget child,
    Duration? timeout,
    VoidCallback? onTimeout,
    bool showTimeRemaining = false,
    String? timeoutMessage,
  }) {
    return _TimingControlWidget(
      timeout: timeout,
      onTimeout: onTimeout,
      showTimeRemaining: showTimeRemaining,
      timeoutMessage: timeoutMessage,
      child: child,
    );
  }

  /// Create pauseable content
  static Widget pauseableContent({
    required Widget child,
    bool autoPlay = true,
    VoidCallback? onPlay,
    VoidCallback? onPause,
    VoidCallback? onStop,
  }) {
    return _PauseableContentWidget(
      autoPlay: autoPlay,
      onPlay: onPlay,
      onPause: onPause,
      onStop: onStop,
      child: child,
    );
  }

  /// Add timeout extension
  static Widget timeoutExtension({
    required Widget child,
    Duration initialTimeout = const Duration(minutes: 20),
    Duration extensionAmount = const Duration(minutes: 10),
    Function(Duration)? onExtensionRequested,
  }) {
    return _TimeoutExtensionWidget(
      initialTimeout: initialTimeout,
      extensionAmount: extensionAmount,
      onExtensionRequested: onExtensionRequested,
      child: child,
    );
  }
}

/// Widget implementations for timing control
class _TimingControlWidget extends StatefulWidget {
  final Widget child;
  final Duration? timeout;
  final VoidCallback? onTimeout;
  final bool showTimeRemaining;
  final String? timeoutMessage;

  const _TimingControlWidget({
    required this.child,
    this.timeout,
    this.onTimeout,
    this.showTimeRemaining = false,
    this.timeoutMessage,
  });

  @override
  State<_TimingControlWidget> createState() => _TimingControlWidgetState();
}

class _TimingControlWidgetState extends State<_TimingControlWidget>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  Duration? _remainingTime;

  @override
  void initState() {
    super.initState();
    if (widget.timeout != null) {
      _controller = AnimationController(
        duration: widget.timeout,
        vsync: this,
      );
      _remainingTime = widget.timeout;
      _controller.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onTimeout?.call();
        }
      });
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
    return Column(
      children: [
        if (widget.showTimeRemaining && _remainingTime != null)
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.orange.withOpacity(0.1),
            child: Text(
              'Time remaining: ${_formatDuration(_remainingTime!)}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        Expanded(child: widget.child),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }
}

class _PauseableContentWidget extends StatefulWidget {
  final Widget child;
  final bool autoPlay;
  final VoidCallback? onPlay;
  final VoidCallback? onPause;
  final VoidCallback? onStop;

  const _PauseableContentWidget({
    required this.child,
    this.autoPlay = true,
    this.onPlay,
    this.onPause,
    this.onStop,
  });

  @override
  State<_PauseableContentWidget> createState() =>
      _PauseableContentWidgetState();
}

class _PauseableContentWidgetState extends State<_PauseableContentWidget> {
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _isPlaying = widget.autoPlay;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TouchTargetManager.accessibleIconButton(
              icon: _isPlaying ? Icons.pause : Icons.play_arrow,
              onPressed: () {
                setState(() {
                  _isPlaying = !_isPlaying;
                });
                if (_isPlaying) {
                  widget.onPlay?.call();
                } else {
                  widget.onPause?.call();
                }
              },
              tooltip: _isPlaying ? 'Pause' : 'Play',
            ),
            _TouchTargetManager.accessibleIconButton(
              icon: Icons.stop,
              onPressed: () {
                setState(() {
                  _isPlaying = false;
                });
                widget.onStop?.call();
              },
              tooltip: 'Stop',
            ),
          ],
        ),
        Expanded(child: widget.child),
      ],
    );
  }
}

class _TimeoutExtensionWidget extends StatefulWidget {
  final Widget child;
  final Duration initialTimeout;
  final Duration extensionAmount;
  final Function(Duration)? onExtensionRequested;

  const _TimeoutExtensionWidget({
    required this.child,
    this.initialTimeout = const Duration(minutes: 20),
    this.extensionAmount = const Duration(minutes: 10),
    this.onExtensionRequested,
  });

  @override
  State<_TimeoutExtensionWidget> createState() =>
      _TimeoutExtensionWidgetState();
}

class _TimeoutExtensionWidgetState extends State<_TimeoutExtensionWidget> {
  late Duration _currentTimeout;
  bool _showExtensionOption = false;

  @override
  void initState() {
    super.initState();
    _currentTimeout = widget.initialTimeout;

    // Show extension option when 80% of time has passed
    Future.delayed(
      Duration(milliseconds: (_currentTimeout.inMilliseconds * 0.8).round()),
      () {
        if (mounted) {
          setState(() {
            _showExtensionOption = true;
          });
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (_showExtensionOption)
          Positioned(
            top: 50,
            left: 20,
            right: 20,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Session will expire soon. Extend time?',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _TouchTargetManager.accessibleButton(
                          child: const Text('Extend'),
                          onPressed: () {
                            setState(() {
                              _currentTimeout += widget.extensionAmount;
                              _showExtensionOption = false;
                            });
                            widget.onExtensionRequested?.call(_currentTimeout);
                          },
                        ),
                        _TouchTargetManager.accessibleButton(
                          child: const Text('Continue'),
                          onPressed: () {
                            setState(() {
                              _showExtensionOption = false;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Motor accessibility utilities and helpers
class MotorAccessibilityUtils {
  /// Check if device has motor accessibility needs
  static bool hasMotorAccessibilityNeeds(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    return mediaQuery.disableAnimations ||
        mediaQuery.boldText ||
        mediaQuery.textScaleFactor > 1.5;
  }

  /// Get recommended touch target size
  static double getRecommendedTouchSize(BuildContext context) {
    if (hasMotorAccessibilityNeeds(context)) {
      return _TouchTargetManager.largeTouch;
    }
    return _TouchTargetManager.recommendedTouchTarget;
  }

  /// Create motor-friendly layout
  static Widget createMotorFriendlyLayout({
    required List<Widget> children,
    double spacing = 16.0,
    bool largeButtons = false,
    Axis direction = Axis.vertical,
  }) {
    final spacingWidget = SizedBox(
      width: direction == Axis.horizontal ? spacing : 0,
      height: direction == Axis.vertical ? spacing : 0,
    );

    final spacedChildren = <Widget>[];
    for (int i = 0; i < children.length; i++) {
      spacedChildren.add(children[i]);
      if (i < children.length - 1) {
        spacedChildren.add(spacingWidget);
      }
    }

    if (direction == Axis.horizontal) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: spacedChildren,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: spacedChildren,
      );
    }
  }

  /// Validate motor accessibility
  static Map<String, dynamic> validateMotorAccessibility({
    required BuildContext context,
    required Widget widget,
  }) {
    return {
      'touchTargetSize': getRecommendedTouchSize(context),
      'hasMotorNeeds': hasMotorAccessibilityNeeds(context),
      'disableAnimations': MediaQuery.of(context).disableAnimations,
      'recommendedSpacing': hasMotorAccessibilityNeeds(context) ? 16.0 : 8.0,
    };
  }
}
