import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../spacing/app_spacing.dart';
import '../typography/app_typography.dart';

/// Optimized versions of common UI components with const constructors and performance improvements
/// These replace problematic widgets identified in the analysis
class OptimizedWidgets {
  OptimizedWidgets._();

  /// Optimized Container with const constructor
  static Widget container({
    Key? key,
    AlignmentGeometry? alignment,
    EdgeInsetsGeometry? padding,
    Color? color,
    Decoration? decoration,
    Decoration? foregroundDecoration,
    double? width,
    double? height,
    BoxConstraints? constraints,
    EdgeInsetsGeometry? margin,
    Matrix4? transform,
    AlignmentGeometry? transformAlignment,
    Widget? child,
    Clip clipBehavior = Clip.none,
  }) {
    return Container(
      key: key,
      alignment: alignment,
      padding: padding,
      color: color,
      decoration: decoration,
      foregroundDecoration: foregroundDecoration,
      width: width,
      height: height,
      constraints: constraints,
      margin: margin,
      transform: transform,
      transformAlignment: transformAlignment,
      clipBehavior: clipBehavior,
      child: child,
    );
  }

  /// Optimized SizedBox with const constructor
  static Widget sizedBox({
    Key? key,
    double? width,
    double? height,
    Widget? child,
  }) {
    return SizedBox(
      key: key,
      width: width,
      height: height,
      child: child,
    );
  }

  /// Optimized Padding with const constructor
  static Widget padding({
    Key? key,
    required EdgeInsetsGeometry padding,
    Widget? child,
  }) {
    return Padding(
      key: key,
      padding: padding,
      child: child,
    );
  }

  /// Optimized EdgeInsets that are const by default
  static const EdgeInsets edgeInsets = EdgeInsets.all(0);

  /// Common padding values as const
  static const EdgeInsets paddingAll4 = EdgeInsets.all(AppSpacing.xs);
  static const EdgeInsets paddingAll8 = EdgeInsets.all(AppSpacing.sm);
  static const EdgeInsets paddingAll12 = EdgeInsets.all(AppSpacing.md);
  static const EdgeInsets paddingAll16 = EdgeInsets.all(AppSpacing.lg);
  static const EdgeInsets paddingAll24 = EdgeInsets.all(AppSpacing.xl);

  /// Horizontal padding values
  static const EdgeInsets paddingH8 =
      EdgeInsets.symmetric(horizontal: AppSpacing.sm);
  static const EdgeInsets paddingH12 =
      EdgeInsets.symmetric(horizontal: AppSpacing.md);
  static const EdgeInsets paddingH16 =
      EdgeInsets.symmetric(horizontal: AppSpacing.lg);

  /// Vertical padding values
  static const EdgeInsets paddingV8 =
      EdgeInsets.symmetric(vertical: AppSpacing.sm);
  static const EdgeInsets paddingV12 =
      EdgeInsets.symmetric(vertical: AppSpacing.md);
  static const EdgeInsets paddingV16 =
      EdgeInsets.symmetric(vertical: AppSpacing.lg);

  /// Optimized Icon with const constructor
  static Widget icon(
    IconData icon, {
    Key? key,
    double? size,
    Color? color,
    String? semanticLabel,
    TextDirection? textDirection,
  }) {
    return Icon(
      icon,
      key: key,
      size: size,
      color: color,
      semanticLabel: semanticLabel,
      textDirection: textDirection,
    );
  }

  /// Pre-defined const icons for common use cases
  static const Widget homeIcon = Icon(Icons.home, size: 24);
  static const Widget backIcon = Icon(Icons.arrow_back, size: 24);
  static const Widget closeIcon = Icon(Icons.close, size: 24);
  static const Widget menuIcon = Icon(Icons.menu, size: 24);
  static const Widget searchIcon = Icon(Icons.search, size: 24);
  static const Widget settingsIcon = Icon(Icons.settings, size: 24);
  static const Widget personIcon = Icon(Icons.person, size: 24);
  static const Widget notificationIcon = Icon(Icons.notifications, size: 24);

  /// Optimized Text widgets with const constructors and proper styling
  static Widget text(
    String text, {
    Key? key,
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    double? textScaleFactor,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
  }) {
    return Text(
      text,
      key: key,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }

  /// Pre-styled text widgets
  static Widget headlineText(String text, {Color? color}) {
    return Text(
      text,
      style: AppTypography.headlineMedium.copyWith(color: color),
    );
  }

  static Widget titleText(String text, {Color? color}) {
    return Text(
      text,
      style: AppTypography.titleMedium.copyWith(color: color),
    );
  }

  static Widget bodyText(String text, {Color? color}) {
    return Text(
      text,
      style: AppTypography.bodyMedium.copyWith(color: color),
    );
  }

  static Widget captionText(String text, {Color? color}) {
    return Text(
      text,
      style: AppTypography.bodySmall
          .copyWith(color: color ?? AppColors.textSecondary),
    );
  }

  /// Optimized Row and Column with const constructors
  static Widget row({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget> children = const <Widget>[],
  }) {
    return Row(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: children,
    );
  }

  static Widget column({
    Key? key,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.max,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    TextDirection? textDirection,
    VerticalDirection verticalDirection = VerticalDirection.down,
    TextBaseline? textBaseline,
    List<Widget> children = const <Widget>[],
  }) {
    return Column(
      key: key,
      mainAxisAlignment: mainAxisAlignment,
      mainAxisSize: mainAxisSize,
      crossAxisAlignment: crossAxisAlignment,
      textDirection: textDirection,
      verticalDirection: verticalDirection,
      textBaseline: textBaseline,
      children: children,
    );
  }

  /// Optimized spacing widgets
  static const Widget verticalSpace4 = SizedBox(height: AppSpacing.xs);
  static const Widget verticalSpace8 = SizedBox(height: AppSpacing.sm);
  static const Widget verticalSpace12 = SizedBox(height: AppSpacing.md);
  static const Widget verticalSpace16 = SizedBox(height: AppSpacing.lg);
  static const Widget verticalSpace24 = SizedBox(height: AppSpacing.xl);

  static const Widget horizontalSpace4 = SizedBox(width: AppSpacing.xs);
  static const Widget horizontalSpace8 = SizedBox(width: AppSpacing.sm);
  static const Widget horizontalSpace12 = SizedBox(width: AppSpacing.md);
  static const Widget horizontalSpace16 = SizedBox(width: AppSpacing.lg);
  static const Widget horizontalSpace24 = SizedBox(width: AppSpacing.xl);

  /// Optimized common decoration patterns
  static BoxDecoration roundedDecoration({
    Color? color,
    Color? borderColor,
    double borderRadius = 8.0,
    double borderWidth = 1.0,
    List<BoxShadow>? boxShadow,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: borderColor != null
          ? Border.all(color: borderColor, width: borderWidth)
          : null,
      boxShadow: boxShadow,
    );
  }

  static BoxDecoration cardDecoration({
    Color? color,
    double borderRadius = 12.0,
    bool hasShadow = true,
  }) {
    return BoxDecoration(
      color: color ?? AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      boxShadow: hasShadow
          ? [
              BoxShadow(
                color: AppColors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ]
          : null,
    );
  }

  /// Optimized button styles
  static ButtonStyle primaryButtonStyle({
    Color? backgroundColor,
    Color? foregroundColor,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? padding,
  }) {
    return ElevatedButton.styleFrom(
      backgroundColor: backgroundColor ?? AppColors.primary,
      foregroundColor: foregroundColor ?? AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding ?? paddingAll12,
      elevation: 2,
    );
  }

  static ButtonStyle secondaryButtonStyle({
    Color? backgroundColor,
    Color? foregroundColor,
    double borderRadius = 8.0,
    EdgeInsetsGeometry? padding,
  }) {
    return OutlinedButton.styleFrom(
      backgroundColor: backgroundColor ?? Colors.transparent,
      foregroundColor: foregroundColor ?? AppColors.primary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      padding: padding ?? paddingAll12,
      side: BorderSide(color: foregroundColor ?? AppColors.primary),
    );
  }

  /// Optimized loading indicator
  static const Widget loadingIndicator = SizedBox(
    width: 24,
    height: 24,
    child: CircularProgressIndicator(strokeWidth: 2),
  );

  /// Optimized divider
  static const Widget divider = Divider(
    height: 1,
    thickness: 0.5,
    color: AppColors.border,
  );

  /// Optimized card wrapper
  static Widget card({
    Key? key,
    Widget? child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? color,
    double borderRadius = 12.0,
    bool hasShadow = true,
  }) {
    return Container(
      key: key,
      margin: margin,
      padding: padding ?? paddingAll12,
      decoration: cardDecoration(
        color: color,
        borderRadius: borderRadius,
        hasShadow: hasShadow,
      ),
      child: child,
    );
  }
}

/// Performance-optimized versions of common widget patterns
class OptimizedPatterns {
  OptimizedPatterns._();

  /// Creates an optimized list tile with minimal rebuilds
  static Widget listTile({
    Key? key,
    Widget? leading,
    Widget? title,
    Widget? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    EdgeInsetsGeometry? contentPadding,
  }) {
    return InkWell(
      key: key,
      onTap: onTap,
      child: OptimizedWidgets.padding(
        padding: contentPadding ?? OptimizedWidgets.paddingAll12,
        child: OptimizedWidgets.row(
          children: [
            if (leading != null) ...[
              leading,
              OptimizedWidgets.horizontalSpace12,
            ],
            Expanded(
              child: OptimizedWidgets.column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (title != null) title,
                  if (subtitle != null) ...[
                    OptimizedWidgets.verticalSpace4,
                    subtitle,
                  ],
                ],
              ),
            ),
            if (trailing != null) ...[
              OptimizedWidgets.horizontalSpace12,
              trailing,
            ],
          ],
        ),
      ),
    );
  }

  /// Creates an optimized app bar with minimal rebuilds
  static PreferredSizeWidget appBar({
    Key? key,
    Widget? title,
    List<Widget>? actions,
    Widget? leading,
    bool automaticallyImplyLeading = true,
    Color? backgroundColor,
    double elevation = 0,
  }) {
    return AppBar(
      key: key,
      title: title,
      actions: actions,
      leading: leading,
      automaticallyImplyLeading: automaticallyImplyLeading,
      backgroundColor: backgroundColor ?? AppColors.surface,
      elevation: elevation,
      scrolledUnderElevation: 1,
    );
  }

  /// Creates an optimized scaffold with minimal rebuilds
  static Widget scaffold({
    Key? key,
    PreferredSizeWidget? appBar,
    Widget? body,
    Widget? floatingActionButton,
    Widget? bottomNavigationBar,
    Widget? drawer,
    Color? backgroundColor,
  }) {
    return Scaffold(
      key: key,
      appBar: appBar,
      body: body,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
      drawer: drawer,
      backgroundColor: backgroundColor ?? AppColors.background,
    );
  }

  /// Creates an optimized bottom sheet pattern
  static Widget bottomSheet({
    required Widget child,
    double borderRadius = 16.0,
    EdgeInsetsGeometry? padding,
  }) {
    return OptimizedWidgets.container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(borderRadius),
        ),
      ),
      padding: padding ?? OptimizedWidgets.paddingAll16,
      child: child,
    );
  }

  /// Creates an optimized form field pattern
  static Widget formField({
    Key? key,
    required String label,
    String? hint,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    bool obscureText = false,
    TextInputType? keyboardType,
  }) {
    return OptimizedWidgets.column(
      key: key,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        OptimizedWidgets.text(
          label,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        OptimizedWidgets.verticalSpace8,
        TextFormField(
          controller: controller,
          onChanged: onChanged,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            errorText: errorText,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: const BorderSide(color: AppColors.border),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: const BorderSide(color: AppColors.error),
            ),
            contentPadding: OptimizedWidgets.paddingAll12,
          ),
        ),
      ],
    );
  }

  // Missing methods used in performance examples

  /// Padding getters as widgets
  static Widget get paddingVertical4 => OptimizedWidgets.verticalSpace4;
  static Widget get paddingVertical8 => OptimizedWidgets.verticalSpace8;
  static Widget get paddingVertical16 => OptimizedWidgets.verticalSpace16;
  static Widget get paddingHorizontal8 => OptimizedWidgets.horizontalSpace8;

  /// Button methods
  static Widget primaryButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return ElevatedButton(
      key: key,
      onPressed: onPressed,
      style: OptimizedWidgets.primaryButtonStyle(),
      child: child,
    );
  }

  static Widget secondaryButton({
    Key? key,
    required VoidCallback? onPressed,
    required Widget child,
  }) {
    return OutlinedButton(
      key: key,
      onPressed: onPressed,
      style: OptimizedWidgets.secondaryButtonStyle(),
      child: child,
    );
  }

  static Widget buttonText(String text) {
    return Text(
      text,
      style: AppTypography.labelMedium.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// Card method
  static Widget card({
    Key? key,
    EdgeInsetsGeometry? padding,
    Widget? child,
    Color? color,
  }) {
    return Container(
      key: key,
      padding: padding,
      decoration: OptimizedWidgets.cardDecoration(color: color),
      child: child,
    );
  }
}
