import 'package:flutter/material.dart';
import '../design_system.dart';
import '../../models/MenuItem.dart';

/// Modern menu item widget following design system principles
///
/// Features:
/// - Proper touch targets (minimum 44x44dp)
/// - Material Design 3 styling
/// - Accessible interactions
/// - Consistent visual feedback
/// - Educational theme integration
class AppMenuItemWidget extends StatefulWidget {
  final MenuItem item;
  final bool isSelected;
  final double? width;
  final double? height;

  const AppMenuItemWidget({
    Key? key,
    required this.item,
    this.isSelected = false,
    this.width,
    this.height,
  }) : super(key: key);

  @override
  State<AppMenuItemWidget> createState() => _AppMenuItemWidgetState();
}

class _AppMenuItemWidgetState extends State<AppMenuItemWidget>
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

  void _onTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _animationController.forward();
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
    final defaultSize = MediaQuery.of(context).size.width / 4; // 2-column grid
    final itemWidth = widget.width ?? defaultSize;
    final itemHeight = widget.height ?? defaultSize;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            onTap: () => widget.item.f(),
            child: Container(
              width: itemWidth,
              height: itemHeight,
              constraints: BoxConstraints(
                minWidth: AppSpacing.minTouchTarget,
                minHeight: AppSpacing.minTouchTarget,
              ),
              child: Material(
                color: Colors.transparent,
                child: Card(
                  elevation: _isPressed
                      ? AppSpacing.elevationSM
                      : AppSpacing.elevationMD,
                  shadowColor: AppColors.primary.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: AppSpacing.borderRadiusLG,
                    side: BorderSide(
                      color: widget.isSelected
                          ? AppColors.primary
                          : AppColors.border,
                      width: widget.isSelected ? 2.0 : 1.0,
                    ),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: AppSpacing.borderRadiusLG,
                      gradient: widget.isSelected
                          ? LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.primary.withOpacity(0.1),
                                AppColors.primary.withOpacity(0.05),
                              ],
                            )
                          : null,
                    ),
                    padding: AppSpacing.allMD,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Icon container with consistent sizing
                        Container(
                          width: AppSpacing.iconXL,
                          height: AppSpacing.iconXL,
                          decoration: BoxDecoration(
                            color: widget.isSelected
                                ? AppColors.primary.withOpacity(0.1)
                                : AppColors.surfaceVariant,
                            borderRadius: AppSpacing.borderRadiusMD,
                          ),
                          child: ClipRRect(
                            borderRadius: AppSpacing.borderRadiusMD,
                            child: Image.asset(
                              'assets/icons/${widget.item.img}',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(
                                  Icons.apps,
                                  size: AppSpacing.iconLG,
                                  color: widget.isSelected
                                      ? AppColors.primary
                                      : AppColors.textSecondary,
                                );
                              },
                            ),
                          ),
                        ),

                        AppSpacing.gapSM,

                        // Title with proper typography
                        Text(
                          widget.item.title,
                          style: AppTypography.labelMedium.copyWith(
                            color: widget.isSelected
                                ? AppColors.primary
                                : AppColors.textPrimary,
                            fontWeight: widget.isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Grid widget for displaying menu items in a responsive 2-column layout
class AppMenuGrid extends StatelessWidget {
  final List<MenuItem> items;
  final int? selectedIndex;
  final EdgeInsetsGeometry? padding;
  final double? spacing;

  const AppMenuGrid({
    Key? key,
    required this.items,
    this.selectedIndex,
    this.padding,
    this.spacing,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final itemPadding = padding ?? AppSpacing.horizontalMD;
    final gridSpacing = spacing ?? AppSpacing.md;

    // Calculate item width for 2-column grid
    final availableWidth = screenWidth - itemPadding.horizontal - gridSpacing;
    final itemWidth = availableWidth / 2;

    return Padding(
      padding: itemPadding,
      child: Wrap(
        spacing: gridSpacing,
        runSpacing: gridSpacing,
        children: items.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return AppMenuItemWidget(
            item: item,
            isSelected: index == selectedIndex,
            width: itemWidth,
          );
        }).toList(),
      ),
    );
  }
}
