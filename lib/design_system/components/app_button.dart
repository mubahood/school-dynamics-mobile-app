import 'package:flutter/material.dart';
import '../design_system.dart';

/// Modern button component with loading states and animations
///
/// Features:
/// - Material Design 3 styling
/// - Loading states with animations
/// - Ripple effects and visual feedback
/// - Multiple button variants
/// - Accessibility compliant
class AppButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final double? width;
  final double? height;

  const AppButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isEnabled = true,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.borderRadius,
    this.padding,
    this.width,
    this.height,
  }) : super(key: key);

  /// Primary filled button
  const AppButton.primary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    double? width,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          isEnabled: isEnabled,
          variant: AppButtonVariant.filled,
          size: size,
          icon: icon,
          width: width,
        );

  /// Secondary outlined button
  const AppButton.secondary({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    double? width,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          isEnabled: isEnabled,
          variant: AppButtonVariant.outlined,
          size: size,
          icon: icon,
          width: width,
        );

  /// Text button
  const AppButton.text({
    Key? key,
    required String text,
    VoidCallback? onPressed,
    bool isLoading = false,
    bool isEnabled = true,
    AppButtonSize size = AppButtonSize.medium,
    IconData? icon,
    double? width,
  }) : this(
          key: key,
          text: text,
          onPressed: onPressed,
          isLoading: isLoading,
          isEnabled: isEnabled,
          variant: AppButtonVariant.text,
          size: size,
          icon: icon,
          width: width,
        );

  @override
  State<AppButton> createState() => _AppButtonState();
}

class _AppButtonState extends State<AppButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  bool get _isInteractive =>
      widget.onPressed != null && widget.isEnabled && !widget.isLoading;

  void _onTapDown(TapDownDetails details) {
    if (_isInteractive) {
      setState(() => _isPressed = true);
      _animationController.forward();
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
    _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final buttonStyle = _getButtonStyle();
    final textStyle = _getTextStyle();
    final buttonHeight = _getButtonHeight();

    Widget buttonChild = _buildButtonContent(textStyle);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.width,
            height: buttonHeight,
            constraints: BoxConstraints(
              minWidth: AppSpacing.minTouchTarget,
              minHeight: AppSpacing.minTouchTarget,
            ),
            child: GestureDetector(
              onTapDown: _onTapDown,
              onTapUp: _onTapUp,
              onTapCancel: _onTapCancel,
              child: widget.variant == AppButtonVariant.filled
                  ? ElevatedButton(
                      onPressed: _isInteractive ? widget.onPressed : null,
                      style: buttonStyle,
                      child: buttonChild,
                    )
                  : widget.variant == AppButtonVariant.outlined
                      ? OutlinedButton(
                          onPressed: _isInteractive ? widget.onPressed : null,
                          style: buttonStyle,
                          child: buttonChild,
                        )
                      : TextButton(
                          onPressed: _isInteractive ? widget.onPressed : null,
                          style: buttonStyle,
                          child: buttonChild,
                        ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildButtonContent(TextStyle textStyle) {
    if (widget.isLoading) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 16,
            height: 16,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                textStyle.color ?? AppColors.white,
              ),
            ),
          ),
          AppSpacing.hGapSM,
          Text('Loading...', style: textStyle),
        ],
      );
    }

    if (widget.icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.icon,
            size: _getIconSize(),
            color: textStyle.color,
          ),
          AppSpacing.hGapSM,
          Text(widget.text, style: textStyle),
        ],
      );
    }

    return Text(widget.text, style: textStyle);
  }

  ButtonStyle _getButtonStyle() {
    final borderRadius = widget.borderRadius ?? AppSpacing.borderRadiusMD;
    final padding = widget.padding ?? _getButtonPadding();

    switch (widget.variant) {
      case AppButtonVariant.filled:
        return ElevatedButton.styleFrom(
          backgroundColor: widget.backgroundColor ?? AppColors.primary,
          foregroundColor: widget.foregroundColor ?? AppColors.white,
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation:
              _isPressed ? AppSpacing.elevationSM : AppSpacing.elevationMD,
        );

      case AppButtonVariant.outlined:
        return OutlinedButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? AppColors.primary,
          backgroundColor: widget.backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          side: BorderSide(
            color: AppColors.primary,
            width: 1.0,
          ),
        );

      case AppButtonVariant.text:
        return TextButton.styleFrom(
          foregroundColor: widget.foregroundColor ?? AppColors.primary,
          backgroundColor: widget.backgroundColor,
          padding: padding,
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
        );
    }
  }

  TextStyle _getTextStyle() {
    final baseStyle = _getBaseTextStyle();
    return baseStyle.copyWith(
      color: widget.foregroundColor ?? _getDefaultTextColor(),
    );
  }

  TextStyle _getBaseTextStyle() {
    switch (widget.size) {
      case AppButtonSize.small:
        return AppTypography.labelSmall;
      case AppButtonSize.medium:
        return AppTypography.labelLarge;
      case AppButtonSize.large:
        return AppTypography.titleMedium;
    }
  }

  Color _getDefaultTextColor() {
    switch (widget.variant) {
      case AppButtonVariant.filled:
        return AppColors.white;
      case AppButtonVariant.outlined:
      case AppButtonVariant.text:
        return AppColors.primary;
    }
  }

  EdgeInsetsGeometry _getButtonPadding() {
    switch (widget.size) {
      case AppButtonSize.small:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.xs,
        );
      case AppButtonSize.medium:
        return AppSpacing.button;
      case AppButtonSize.large:
        return EdgeInsets.symmetric(
          horizontal: AppSpacing.xl,
          vertical: AppSpacing.md,
        );
    }
  }

  double _getButtonHeight() {
    switch (widget.size) {
      case AppButtonSize.small:
        return 36;
      case AppButtonSize.medium:
        return AppSpacing.standardTouchTarget;
      case AppButtonSize.large:
        return AppSpacing.largeTouchTarget;
    }
  }

  double _getIconSize() {
    switch (widget.size) {
      case AppButtonSize.small:
        return AppSpacing.iconSM;
      case AppButtonSize.medium:
        return AppSpacing.iconMD;
      case AppButtonSize.large:
        return AppSpacing.iconLG;
    }
  }
}

/// Educational specific buttons
class StudentActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const StudentActionButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      variant: AppButtonVariant.filled,
      backgroundColor: AppColors.student,
      foregroundColor: AppColors.white,
    );
  }
}

class GradeActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const GradeActionButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      variant: AppButtonVariant.filled,
      backgroundColor: AppColors.academic,
      foregroundColor: AppColors.white,
    );
  }
}

class FinanceActionButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final IconData? icon;

  const FinanceActionButton({
    Key? key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.icon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppButton(
      text: text,
      onPressed: onPressed,
      isLoading: isLoading,
      icon: icon,
      variant: AppButtonVariant.filled,
      backgroundColor: AppColors.finance,
      foregroundColor: AppColors.white,
    );
  }
}

/// Button variants
enum AppButtonVariant {
  filled,
  outlined,
  text,
}

/// Button sizes
enum AppButtonSize {
  small,
  medium,
  large,
}
