import 'package:flutter/material.dart';
import '../design_system.dart';

/// Unified input decoration system for the School Dynamics app
///
/// Provides consistent input styling following Material Design 3
/// principles with educational app optimizations.
class AppInputDecorations {
  // Private constructor to prevent instantiation
  AppInputDecorations._();

  // ========================================
  // BORDER STYLES
  // ========================================

  /// Standard outline border for enabled state
  static OutlineInputBorder get _enabledBorder => OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.border,
          width: 1.0,
        ),
        borderRadius: AppSpacing.borderRadiusMD,
      );

  /// Focused outline border
  static OutlineInputBorder get _focusedBorder => OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 2.0,
        ),
        borderRadius: AppSpacing.borderRadiusMD,
      );

  /// Error outline border
  static OutlineInputBorder get _errorBorder => OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.error,
          width: 1.0,
        ),
        borderRadius: AppSpacing.borderRadiusMD,
      );

  /// Focused error outline border
  static OutlineInputBorder get _focusedErrorBorder => OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.error,
          width: 2.0,
        ),
        borderRadius: AppSpacing.borderRadiusMD,
      );

  /// Disabled outline border
  static OutlineInputBorder get _disabledBorder => OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.textDisabled,
          width: 1.0,
        ),
        borderRadius: AppSpacing.borderRadiusMD,
      );

  // ========================================
  // TEXT STYLES
  // ========================================

  /// Hint text style
  static TextStyle get _hintStyle => AppTypography.bodyMedium.copyWith(
        color: AppColors.textSecondary,
      );

  /// Label text style
  static TextStyle get _labelStyle => AppTypography.labelLarge.copyWith(
        color: AppColors.textSecondary,
      );

  /// Floating label text style
  static TextStyle get _floatingLabelStyle => AppTypography.labelSmall.copyWith(
        color: AppColors.primary,
      );

  /// Error text style
  static TextStyle get _errorStyle => AppTypography.labelSmall.copyWith(
        color: AppColors.error,
      );

  /// Helper text style
  static TextStyle get _helperStyle => AppTypography.labelSmall.copyWith(
        color: AppColors.textSecondary,
      );

  // ========================================
  // STANDARD INPUT DECORATIONS
  // ========================================

  /// Standard input decoration with outline border
  static InputDecoration standard({
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool isDense = false,
    bool enabled = true,
  }) {
    return InputDecoration(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: isDense,
      enabled: enabled,
      contentPadding: AppSpacing.input,
      filled: true,
      fillColor: enabled ? AppColors.surface : AppColors.backgroundSecondary,

      // Border styles
      border: _enabledBorder,
      enabledBorder: _enabledBorder,
      focusedBorder: _focusedBorder,
      errorBorder: _errorBorder,
      focusedErrorBorder: _focusedErrorBorder,
      disabledBorder: _disabledBorder,

      // Text styles
      hintStyle: _hintStyle,
      labelStyle: _labelStyle,
      floatingLabelStyle: _floatingLabelStyle,
      errorStyle: _errorStyle,
      helperStyle: _helperStyle,
    );
  }

  /// Dense input decoration for compact layouts
  static InputDecoration dense({
    String? labelText,
    String? hintText,
    String? helperText,
    String? errorText,
    Widget? prefixIcon,
    Widget? suffixIcon,
    bool enabled = true,
  }) {
    return standard(
      labelText: labelText,
      hintText: hintText,
      helperText: helperText,
      errorText: errorText,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      isDense: true,
      enabled: enabled,
    ).copyWith(
      contentPadding: AppSpacing.custom(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
    );
  }

  /// Search input decoration with search icon
  static InputDecoration search({
    String? hintText = 'Search...',
    Widget? suffixIcon,
    bool enabled = true,
  }) {
    return standard(
      hintText: hintText,
      prefixIcon: Icon(
        Icons.search,
        color: AppColors.textSecondary,
        size: AppSpacing.iconMD,
      ),
      suffixIcon: suffixIcon,
      enabled: enabled,
    ).copyWith(
      border: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.border,
          width: 1.0,
        ),
        borderRadius: AppSpacing.borderRadiusRound,
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.border,
          width: 1.0,
        ),
        borderRadius: AppSpacing.borderRadiusRound,
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: AppColors.primary,
          width: 2.0,
        ),
        borderRadius: AppSpacing.borderRadiusRound,
      ),
    );
  }

  // ========================================
  // EDUCATIONAL SPECIFIC DECORATIONS
  // ========================================

  /// Grade input decoration with academic styling
  static InputDecoration grade({
    String? labelText,
    String? hintText,
    String? errorText,
    bool enabled = true,
  }) {
    return standard(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
    ).copyWith(
      prefixIcon: Icon(
        Icons.grade,
        color: AppColors.academic,
        size: AppSpacing.iconMD,
      ),
      floatingLabelStyle: _floatingLabelStyle.copyWith(
        color: AppColors.academic,
      ),
    );
  }

  /// Amount input decoration for financial fields
  static InputDecoration amount({
    String? labelText,
    String? hintText,
    String? errorText,
    String? currencySymbol = '\$',
    bool enabled = true,
  }) {
    return standard(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
    ).copyWith(
      prefixIcon: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: Text(
          currencySymbol ?? '\$',
          style: AppTypography.labelLarge.copyWith(
            color: AppColors.finance,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      floatingLabelStyle: _floatingLabelStyle.copyWith(
        color: AppColors.finance,
      ),
    );
  }

  /// Student ID input decoration
  static InputDecoration studentId({
    String? labelText = 'Student ID',
    String? hintText,
    String? errorText,
    bool enabled = true,
  }) {
    return standard(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
    ).copyWith(
      prefixIcon: Icon(
        Icons.person,
        color: AppColors.student,
        size: AppSpacing.iconMD,
      ),
      floatingLabelStyle: _floatingLabelStyle.copyWith(
        color: AppColors.student,
      ),
    );
  }

  // ========================================
  // SPECIALIZED DECORATIONS
  // ========================================

  /// Password input decoration with visibility toggle
  static InputDecoration password({
    String? labelText = 'Password',
    String? hintText,
    String? errorText,
    bool obscureText = true,
    VoidCallback? onVisibilityToggle,
    bool enabled = true,
  }) {
    return standard(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
    ).copyWith(
      prefixIcon: Icon(
        Icons.lock_outline,
        color: AppColors.textSecondary,
        size: AppSpacing.iconMD,
      ),
      suffixIcon: onVisibilityToggle != null
          ? IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: AppColors.textSecondary,
              ),
              onPressed: onVisibilityToggle,
            )
          : null,
    );
  }

  /// Email input decoration
  static InputDecoration email({
    String? labelText = 'Email',
    String? hintText,
    String? errorText,
    bool enabled = true,
  }) {
    return standard(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
    ).copyWith(
      prefixIcon: Icon(
        Icons.email_outlined,
        color: AppColors.textSecondary,
        size: AppSpacing.iconMD,
      ),
    );
  }

  /// Phone input decoration
  static InputDecoration phone({
    String? labelText = 'Phone',
    String? hintText,
    String? errorText,
    bool enabled = true,
  }) {
    return standard(
      labelText: labelText,
      hintText: hintText,
      errorText: errorText,
      enabled: enabled,
    ).copyWith(
      prefixIcon: Icon(
        Icons.phone_outlined,
        color: AppColors.textSecondary,
        size: AppSpacing.iconMD,
      ),
    );
  }

  // ========================================
  // THEME INTEGRATION
  // ========================================

  /// Creates an InputDecorationTheme for Material Theme
  static InputDecorationTheme get theme => InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: AppSpacing.input,

        // Border styles
        border: _enabledBorder,
        enabledBorder: _enabledBorder,
        focusedBorder: _focusedBorder,
        errorBorder: _errorBorder,
        focusedErrorBorder: _focusedErrorBorder,
        disabledBorder: _disabledBorder,

        // Text styles
        hintStyle: _hintStyle,
        labelStyle: _labelStyle,
        floatingLabelStyle: _floatingLabelStyle,
        errorStyle: _errorStyle,
        helperStyle: _helperStyle,
      );
}
