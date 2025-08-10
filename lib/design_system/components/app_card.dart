import 'package:flutter/material.dart';
import '../design_system.dart';

/// Unified card component following design system principles
///
/// Features:
/// - Consistent elevation and shadows
/// - Material Design 3 styling
/// - Multiple card variants
/// - Proper interaction states
/// - Educational theme integration
class AppCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final double? elevation;
  final BorderRadius? borderRadius;
  final Border? border;
  final AppCardVariant variant;
  final bool isEnabled;

  const AppCard({
    Key? key,
    required this.child,
    this.onTap,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.elevation,
    this.borderRadius,
    this.border,
    this.variant = AppCardVariant.elevated,
    this.isEnabled = true,
  }) : super(key: key);

  /// Standard elevated card
  const AppCard.elevated({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    bool isEnabled = true,
  }) : this(
          key: key,
          child: child,
          onTap: onTap,
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          variant: AppCardVariant.elevated,
          isEnabled: isEnabled,
        );

  /// Outlined card with border
  const AppCard.outlined({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    bool isEnabled = true,
  }) : this(
          key: key,
          child: child,
          onTap: onTap,
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          variant: AppCardVariant.outlined,
          isEnabled: isEnabled,
        );

  /// Filled card with background color
  const AppCard.filled({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    Color? backgroundColor,
    bool isEnabled = true,
  }) : this(
          key: key,
          child: child,
          onTap: onTap,
          padding: padding,
          margin: margin,
          backgroundColor: backgroundColor,
          variant: AppCardVariant.filled,
          isEnabled: isEnabled,
        );

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _isPressed = false;

  void _onTapDown(TapDownDetails details) {
    if (widget.onTap != null && widget.isEnabled) {
      setState(() => _isPressed = true);
    }
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
  }

  void _onTapCancel() {
    setState(() => _isPressed = false);
  }

  @override
  Widget build(BuildContext context) {
    final cardBorderRadius = widget.borderRadius ?? AppSpacing.borderRadiusLG;
    final cardPadding = widget.padding ?? AppSpacing.allMD;
    final cardMargin = widget.margin ?? EdgeInsets.zero;

    final cardBackground = widget.backgroundColor ??
        (widget.variant == AppCardVariant.filled
            ? AppColors.surfaceVariant
            : AppColors.surface);

    final cardElevation = widget.elevation ??
        (widget.variant == AppCardVariant.outlined
            ? AppSpacing.elevationNone
            : _isPressed
                ? AppSpacing.elevationSM
                : AppSpacing.elevationMD);

    final cardBorder = widget.border ??
        (widget.variant == AppCardVariant.outlined
            ? Border.all(
                color: AppColors.border,
                width: 1.0,
              )
            : null);

    Widget cardContent = Container(
      padding: cardPadding,
      decoration: BoxDecoration(
        borderRadius: cardBorderRadius,
        border: cardBorder,
      ),
      child: widget.child,
    );

    if (widget.onTap != null && widget.isEnabled) {
      cardContent = GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: cardContent,
      );
    }

    return Container(
      margin: cardMargin,
      child: Material(
        color: cardBackground,
        elevation: cardElevation,
        shadowColor: AppColors.textPrimary.withValues(alpha: 0.1),
        borderRadius: cardBorderRadius,
        child: cardContent,
      ),
    );
  }
}

/// Card variants for different use cases
enum AppCardVariant {
  /// Elevated card with shadow
  elevated,

  /// Outlined card with border
  outlined,

  /// Filled card with background color
  filled,
}

/// Educational specific card components
class StudentCard extends StatelessWidget {
  final String studentName;
  final String studentId;
  final String? avatarUrl;
  final Widget? trailing;
  final VoidCallback? onTap;

  const StudentCard({
    Key? key,
    required this.studentName,
    required this.studentId,
    this.avatarUrl,
    this.trailing,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppCard.outlined(
      onTap: onTap,
      child: Row(
        children: [
          // Student avatar
          CircleAvatar(
            radius: 24,
            backgroundColor: AppColors.student.withValues(alpha: 0.1),
            backgroundImage:
                avatarUrl != null ? NetworkImage(avatarUrl!) : null,
            child: avatarUrl == null
                ? Text(
                    studentName.isNotEmpty ? studentName[0].toUpperCase() : 'S',
                    style: AppTypography.titleMedium.copyWith(
                      color: AppColors.student,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),

          AppSpacing.hGapMD,

          // Student info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  studentName,
                  style: AppTypography.studentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.gapXS,
                Text(
                  'ID: $studentId',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Trailing widget
          if (trailing != null) ...[
            AppSpacing.hGapSM,
            trailing!,
          ],
        ],
      ),
    );
  }
}

/// Grade card for displaying academic results
class GradeCard extends StatelessWidget {
  final String subject;
  final String grade;
  final double? percentage;
  final VoidCallback? onTap;

  const GradeCard({
    Key? key,
    required this.subject,
    required this.grade,
    this.percentage,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final gradeColor = _getGradeColor(grade);

    return AppCard.filled(
      backgroundColor: gradeColor.withValues(alpha: 0.1),
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            subject,
            style: AppTypography.subjectText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          AppSpacing.gapSM,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                grade,
                style: AppTypography.gradeText.copyWith(
                  color: gradeColor,
                ),
              ),
              if (percentage != null)
                Text(
                  '${percentage!.toStringAsFixed(1)}%',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getGradeColor(String grade) {
    switch (grade.toUpperCase()) {
      case 'A':
      case 'A+':
        return AppColors.success;
      case 'B':
      case 'B+':
        return AppColors.info;
      case 'C':
      case 'C+':
        return AppColors.warning;
      case 'D':
      case 'F':
        return AppColors.error;
      default:
        return AppColors.textPrimary;
    }
  }
}

/// Financial transaction card
class TransactionCard extends StatelessWidget {
  final String description;
  final double amount;
  final DateTime date;
  final bool isCredit;
  final VoidCallback? onTap;

  const TransactionCard({
    Key? key,
    required this.description,
    required this.amount,
    required this.date,
    this.isCredit = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final amountColor = isCredit ? AppColors.success : AppColors.error;
    final amountPrefix = isCredit ? '+' : '-';

    return AppCard.outlined(
      onTap: onTap,
      child: Row(
        children: [
          // Transaction icon
          Container(
            padding: AppSpacing.allSM,
            decoration: BoxDecoration(
              color: amountColor.withValues(alpha: 0.1),
              borderRadius: AppSpacing.borderRadiusMD,
            ),
            child: Icon(
              isCredit ? Icons.add : Icons.remove,
              color: amountColor,
              size: AppSpacing.iconMD,
            ),
          ),

          AppSpacing.hGapMD,

          // Transaction details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: AppTypography.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                AppSpacing.gapXS,
                Text(
                  '${date.day}/${date.month}/${date.year}',
                  style: AppTypography.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // Amount
          Text(
            '$amountPrefix\$${amount.toStringAsFixed(2)}',
            style: AppTypography.amountText.copyWith(
              color: amountColor,
            ),
          ),
        ],
      ),
    );
  }
}
