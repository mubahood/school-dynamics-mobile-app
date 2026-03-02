import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../typography/app_typography.dart';
import '../spacing/app_spacing.dart';

/// Simple Skeleton Loader Widget
class SimpleSkeletonLoader extends StatefulWidget {
  const SimpleSkeletonLoader({super.key});

  @override
  State<SimpleSkeletonLoader> createState() => _SimpleSkeletonLoaderState();
}

class _SimpleSkeletonLoaderState extends State<SimpleSkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Column(
          children: [
            _buildSkeletonLine(width: double.infinity, height: 20),
            SizedBox(height: AppSpacing.sm),
            _buildSkeletonLine(width: double.infinity * 0.8, height: 16),
            SizedBox(height: AppSpacing.sm),
            _buildSkeletonLine(width: double.infinity * 0.6, height: 16),
          ],
        );
      },
    );
  }

  Widget _buildSkeletonLine({required double width, required double height}) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.zero,
        color: AppColors.border.withOpacity(0.3 + (_animation.value * 0.4)),
      ),
    );
  }
}
