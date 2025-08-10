import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../design_system.dart';

/// Skeleton loading components for the School Dynamics app
/// 
/// Provides consistent loading states with shimmer effects
/// following design system principles.
class AppSkeletonLoader extends StatelessWidget {
  final double? width;
  final double? height;
  final BorderRadius? borderRadius;
  final Color? baseColor;
  final Color? highlightColor;

  const AppSkeletonLoader({
    Key? key,
    this.width,
    this.height,
    this.borderRadius,
    this.baseColor,
    this.highlightColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: baseColor ?? AppColors.backgroundSecondary,
      highlightColor: highlightColor ?? AppColors.surface,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: AppColors.backgroundSecondary,
          borderRadius: borderRadius ?? AppSpacing.borderRadiusMD,
        ),
      ),
    );
  }
}

/// Pre-built skeleton loaders for common use cases
class SkeletonLoaders {
  // Private constructor to prevent instantiation
  SkeletonLoaders._();

  /// Skeleton for menu item cards
  static Widget menuItem() {
    return AppCard.outlined(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppSkeletonLoader(
            width: AppSpacing.iconXL,
            height: AppSpacing.iconXL,
            borderRadius: AppSpacing.borderRadiusMD,
          ),
          AppSpacing.gapSM,
          AppSkeletonLoader(
            width: 60,
            height: 12,
            borderRadius: AppSpacing.borderRadiusSM,
          ),
        ],
      ),
    );
  }

  /// Skeleton for student cards
  static Widget studentCard() {
    return AppCard.outlined(
      child: Row(
        children: [
          // Avatar skeleton
          AppSkeletonLoader(
            width: 48,
            height: 48,
            borderRadius: BorderRadius.circular(24),
          ),
          AppSpacing.hGapMD,
          // Content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeletonLoader(
                  width: double.infinity,
                  height: 16,
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
                AppSpacing.gapXS,
                AppSkeletonLoader(
                  width: 80,
                  height: 12,
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Skeleton for grade cards
  static Widget gradeCard() {
    return AppCard.filled(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppSkeletonLoader(
            width: double.infinity,
            height: 14,
            borderRadius: AppSpacing.borderRadiusSM,
          ),
          AppSpacing.gapSM,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              AppSkeletonLoader(
                width: 24,
                height: 18,
                borderRadius: AppSpacing.borderRadiusSM,
              ),
              AppSkeletonLoader(
                width: 40,
                height: 12,
                borderRadius: AppSpacing.borderRadiusSM,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Skeleton for transaction cards
  static Widget transactionCard() {
    return AppCard.outlined(
      child: Row(
        children: [
          // Icon skeleton
          AppSkeletonLoader(
            width: 40,
            height: 40,
            borderRadius: AppSpacing.borderRadiusMD,
          ),
          AppSpacing.hGapMD,
          // Content skeleton
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeletonLoader(
                  width: double.infinity,
                  height: 14,
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
                AppSpacing.gapXS,
                AppSkeletonLoader(
                  width: 60,
                  height: 12,
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
              ],
            ),
          ),
          // Amount skeleton
          AppSkeletonLoader(
            width: 60,
            height: 16,
            borderRadius: AppSpacing.borderRadiusSM,
          ),
        ],
      ),
    );
  }

  /// Skeleton for list items
  static Widget listItem() {
    return Padding(
      padding: AppSpacing.verticalSM,
      child: Row(
        children: [
          AppSkeletonLoader(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(20),
          ),
          AppSpacing.hGapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeletonLoader(
                  width: double.infinity,
                  height: 16,
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
                AppSpacing.gapXS,
                AppSkeletonLoader(
                  width: 120,
                  height: 12,
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Skeleton for dashboard header
  static Widget dashboardHeader() {
    return Padding(
      padding: AppSpacing.allMD,
      child: Row(
        children: [
          AppSkeletonLoader(
            width: 40,
            height: 40,
            borderRadius: BorderRadius.circular(20),
          ),
          AppSpacing.hGapMD,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppSkeletonLoader(
                  width: 120,
                  height: 16,
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
                AppSpacing.gapXS,
                AppSkeletonLoader(
                  width: 80,
                  height: 12,
                  borderRadius: AppSpacing.borderRadiusSM,
                ),
              ],
            ),
          ),
          AppSkeletonLoader(
            width: 24,
            height: 24,
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
    );
  }

  /// Skeleton for grid layout (dashboard menu)
  static Widget menuGrid({int itemCount = 6}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpacing.allMD,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 1.0,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) => menuItem(),
    );
  }

  /// Skeleton for list layout
  static Widget listLayout({int itemCount = 5}) {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: AppSpacing.allMD,
      itemCount: itemCount,
      itemBuilder: (context, index) => studentCard(),
    );
  }
}

/// Loading state wrapper widget
class LoadingStateWrapper extends StatelessWidget {
  final bool isLoading;
  final Widget child;
  final Widget? loadingSkeleton;
  final String? loadingText;

  const LoadingStateWrapper({
    Key? key,
    required this.isLoading,
    required this.child,
    this.loadingSkeleton,
    this.loadingText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return loadingSkeleton ?? _defaultLoadingSkeleton();
    }
    return child;
  }

  Widget _defaultLoadingSkeleton() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            color: AppColors.primary,
            strokeWidth: 3,
          ),
          if (loadingText != null) ...[
            AppSpacing.gapMD,
            Text(
              loadingText!,
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Progressive loading for lists
class ProgressiveListLoader extends StatelessWidget {
  final List<Widget> items;
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final Widget Function()? skeletonBuilder;

  const ProgressiveListLoader({
    Key? key,
    required this.items,
    this.isLoading = false,
    this.hasMore = true,
    this.onLoadMore,
    this.skeletonBuilder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: items.length + (isLoading || hasMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < items.length) {
          return items[index];
        }

        // Loading or load more indicator
        if (isLoading) {
          return Padding(
            padding: AppSpacing.allMD,
            child: skeletonBuilder?.call() ?? SkeletonLoaders.listItem(),
          );
        }

        if (hasMore && onLoadMore != null) {
          return Padding(
            padding: AppSpacing.allMD,
            child: Center(
              child: ElevatedButton(
                onPressed: onLoadMore,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.white,
                ),
                child: Text(
                  'Load More',
                  style: AppTypography.labelLarge,
                ),
              ),
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
