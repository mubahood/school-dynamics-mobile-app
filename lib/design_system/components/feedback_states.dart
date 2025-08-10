import 'package:flutter/material.dart';
import '../design_system.dart';

/// Error state components for the School Dynamics app
/// 
/// Provides consistent error handling UI with retry mechanisms
/// and contextual messaging.
class AppErrorState extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final AppErrorType type;

  const AppErrorState({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.type = AppErrorType.general,
  }) : super(key: key);

  /// Network error state
  const AppErrorState.network({
    Key? key,
    String title = 'Connection Problem',
    String message = 'Please check your internet connection and try again.',
    String? actionLabel = 'Retry',
    VoidCallback? onAction,
  }) : this(
          key: key,
          title: title,
          message: message,
          icon: Icons.wifi_off,
          actionLabel: actionLabel,
          onAction: onAction,
          type: AppErrorType.network,
        );

  /// Server error state
  const AppErrorState.server({
    Key? key,
    String title = 'Server Error',
    String message = 'Something went wrong on our end. Please try again later.',
    String? actionLabel = 'Retry',
    VoidCallback? onAction,
  }) : this(
          key: key,
          title: title,
          message: message,
          icon: Icons.error_outline,
          actionLabel: actionLabel,
          onAction: onAction,
          type: AppErrorType.server,
        );

  /// Not found error state
  const AppErrorState.notFound({
    Key? key,
    String title = 'Not Found',
    String message = 'The content you are looking for could not be found.',
    String? actionLabel = 'Go Back',
    VoidCallback? onAction,
  }) : this(
          key: key,
          title: title,
          message: message,
          icon: Icons.search_off,
          actionLabel: actionLabel,
          onAction: onAction,
          type: AppErrorType.notFound,
        );

  /// Permission error state
  const AppErrorState.permission({
    Key? key,
    String title = 'Access Denied',
    String message = 'You do not have permission to access this content.',
    String? actionLabel = 'Contact Admin',
    VoidCallback? onAction,
  }) : this(
          key: key,
          title: title,
          message: message,
          icon: Icons.lock_outline,
          actionLabel: actionLabel,
          onAction: onAction,
          type: AppErrorType.permission,
        );

  @override
  Widget build(BuildContext context) {
    final errorColor = _getErrorColor();
    final errorIcon = icon ?? _getDefaultIcon();

    return Center(
      child: Padding(
        padding: AppSpacing.allXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Error icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: errorColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                errorIcon,
                size: 40,
                color: errorColor,
              ),
            ),

            AppSpacing.gapLG,

            // Error title
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.gapMD,

            // Error message
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapXL,
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: AppColors.white,
                  padding: AppSpacing.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMD,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTypography.labelLarge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getErrorColor() {
    switch (type) {
      case AppErrorType.network:
        return AppColors.warning;
      case AppErrorType.server:
        return AppColors.error;
      case AppErrorType.notFound:
        return AppColors.info;
      case AppErrorType.permission:
        return AppColors.error;
      case AppErrorType.general:
        return AppColors.error;
    }
  }

  IconData _getDefaultIcon() {
    switch (type) {
      case AppErrorType.network:
        return Icons.wifi_off;
      case AppErrorType.server:
        return Icons.error_outline;
      case AppErrorType.notFound:
        return Icons.search_off;
      case AppErrorType.permission:
        return Icons.lock_outline;
      case AppErrorType.general:
        return Icons.error_outline;
    }
  }
}

/// Empty state component
class AppEmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Widget? illustration;

  const AppEmptyState({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
    this.illustration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.allXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Illustration or icon
            if (illustration != null)
              illustration!
            else
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.surfaceVariant,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  icon ?? Icons.inbox_outlined,
                  size: 40,
                  color: AppColors.textSecondary,
                ),
              ),

            AppSpacing.gapLG,

            // Title
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.gapMD,

            // Message
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapXL,
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                  padding: AppSpacing.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMD,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTypography.labelLarge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Success feedback component
class AppSuccessState extends StatelessWidget {
  final String title;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  const AppSuccessState({
    Key? key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.allXL,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Success icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Icon(
                icon ?? Icons.check_circle_outline,
                size: 40,
                color: AppColors.success,
              ),
            ),

            AppSpacing.gapLG,

            // Success title
            Text(
              title,
              style: AppTypography.headlineSmall.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),

            AppSpacing.gapMD,

            // Success message
            Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            // Action button
            if (actionLabel != null && onAction != null) ...[
              AppSpacing.gapXL,
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: AppColors.white,
                  padding: AppSpacing.button,
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusMD,
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: AppTypography.labelLarge,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Toast notification service
class AppToast {
  static void show(
    BuildContext context, {
    required String message,
    AppToastType type = AppToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(
            _getToastIcon(type),
            color: AppColors.white,
            size: AppSpacing.iconMD,
          ),
          AppSpacing.hGapSM,
          Expanded(
            child: Text(
              message,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.white,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: _getToastColor(type),
      duration: duration,
      shape: RoundedRectangleBorder(
        borderRadius: AppSpacing.borderRadiusMD,
      ),
      behavior: SnackBarBehavior.floating,
      margin: AppSpacing.allMD,
      action: actionLabel != null && onAction != null
          ? SnackBarAction(
              label: actionLabel,
              textColor: AppColors.white,
              onPressed: onAction,
            )
          : null,
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static Color _getToastColor(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return AppColors.success;
      case AppToastType.error:
        return AppColors.error;
      case AppToastType.warning:
        return AppColors.warning;
      case AppToastType.info:
        return AppColors.info;
    }
  }

  static IconData _getToastIcon(AppToastType type) {
    switch (type) {
      case AppToastType.success:
        return Icons.check_circle;
      case AppToastType.error:
        return Icons.error;
      case AppToastType.warning:
        return Icons.warning;
      case AppToastType.info:
        return Icons.info;
    }
  }
}

/// Error types for different error scenarios
enum AppErrorType {
  general,
  network,
  server,
  notFound,
  permission,
}

/// Toast types for different message types
enum AppToastType {
  info,
  success,
  warning,
  error,
}
