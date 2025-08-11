import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../typography/app_typography.dart';
import '../spacing/app_spacing.dart';

/// Enhanced navigation components implementing Material Design 3 principles
/// Features modern navigation bars, tab indicators, and smooth transitions
class NavigationComponents {
  NavigationComponents._();

  /// Creates a Material Design 3 Navigation Bar
  static Widget buildNavigationBar({
    required List<NavigationDestination> destinations,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    String? selectedLabel,
    Color? backgroundColor,
    double? height,
    bool showSelectedLabels = true,
    bool showUnselectedLabels = true,
  }) {
    return Material(
      elevation: 8,
      shadowColor: AppColors.textSecondary.withValues(alpha: 0.2),
      child: Container(
        height: height ?? 80,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.surface,
          border: Border(
            top: BorderSide(
              color: AppColors.border.withValues(alpha: 0.12),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(destinations.length, (index) {
              final destination = destinations[index];
              final isSelected = selectedIndex == index;

              return Expanded(
                child: _NavigationBarItem(
                  destination: destination,
                  isSelected: isSelected,
                  onTap: () => onDestinationSelected(index),
                  showLabel:
                      isSelected ? showSelectedLabels : showUnselectedLabels,
                ),
              );
            }),
          ),
        ),
      ),
    );
  }

  /// Creates enhanced tab indicators for TabBar
  static Widget buildTabIndicator({
    required TabController controller,
    required List<Tab> tabs,
    Color? indicatorColor,
    Color? labelColor,
    Color? unselectedLabelColor,
    EdgeInsetsGeometry? labelPadding,
    TabBarIndicatorSize? indicatorSize,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: TabBar(
        controller: controller,
        tabs: tabs,
        indicator: _ModernTabIndicator(
          color: indicatorColor ?? AppColors.primary,
          height: 3,
          borderRadius: BorderRadius.circular(1.5),
        ),
        labelColor: labelColor ?? AppColors.primary,
        unselectedLabelColor: unselectedLabelColor ?? AppColors.textSecondary,
        labelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: AppTypography.labelMedium.copyWith(
          fontWeight: FontWeight.w500,
        ),
        labelPadding: labelPadding ??
            const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),
        indicatorSize: indicatorSize ?? TabBarIndicatorSize.tab,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
      ),
    );
  }

  /// Creates a floating navigation button
  static Widget buildFloatingNavButton({
    required VoidCallback onPressed,
    required IconData icon,
    String? label,
    Color? backgroundColor,
    Color? foregroundColor,
    double? elevation,
    bool mini = false,
  }) {
    return FloatingActionButton.extended(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: foregroundColor ?? AppColors.white,
        size: mini ? 20 : 24,
      ),
      label: label != null
          ? Text(
              label,
              style: AppTypography.labelMedium.copyWith(
                color: foregroundColor ?? AppColors.white,
                fontWeight: FontWeight.w600,
              ),
            )
          : const SizedBox.shrink(),
      backgroundColor: backgroundColor ?? AppColors.primary,
      elevation: elevation ?? 6,
      highlightElevation: (elevation ?? 6) + 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(mini ? 12 : 16),
      ),
    );
  }

  /// Creates a navigation rail for larger screens
  static Widget buildNavigationRail({
    required List<NavigationRailDestination> destinations,
    required int selectedIndex,
    required ValueChanged<int> onDestinationSelected,
    bool extended = false,
    Widget? leading,
    Widget? trailing,
    double? minWidth,
    double? minExtendedWidth,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(
            color: AppColors.border.withValues(alpha: 0.12),
            width: 1,
          ),
        ),
      ),
      child: NavigationRail(
        destinations: destinations,
        selectedIndex: selectedIndex,
        onDestinationSelected: onDestinationSelected,
        extended: extended,
        leading: leading,
        trailing: trailing,
        minWidth: minWidth ?? 72,
        minExtendedWidth: minExtendedWidth ?? 256,
        backgroundColor: AppColors.surface,
        selectedIconTheme: IconThemeData(
          color: AppColors.primary,
          size: 24,
        ),
        unselectedIconTheme: IconThemeData(
          color: AppColors.textSecondary,
          size: 24,
        ),
        selectedLabelTextStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.primary,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelTextStyle: AppTypography.labelMedium.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w500,
        ),
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        indicatorShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      ),
    );
  }
}

/// Navigation bar item widget
class _NavigationBarItem extends StatelessWidget {
  final NavigationDestination destination;
  final bool isSelected;
  final VoidCallback onTap;
  final bool showLabel;

  const _NavigationBarItem({
    required this.destination,
    required this.isSelected,
    required this.onTap,
    required this.showLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: AppColors.primary.withValues(alpha: 0.12),
        highlightColor: AppColors.primary.withValues(alpha: 0.08),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.sm,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeInOut,
                padding: const EdgeInsets.all(AppSpacing.xs),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary.withValues(alpha: 0.12)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: IconTheme(
                  data: IconThemeData(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    size: 24,
                  ),
                  child: isSelected && destination.selectedIcon != null
                      ? destination.selectedIcon!
                      : destination.icon,
                ),
              ),
              if (showLabel) ...[
                const SizedBox(height: 4),
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: AppTypography.labelSmall.copyWith(
                    color: isSelected
                        ? AppColors.primary
                        : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  ),
                  child: Text(
                    destination.label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Modern tab indicator
class _ModernTabIndicator extends Decoration {
  final Color color;
  final double height;
  final BorderRadius borderRadius;

  const _ModernTabIndicator({
    required this.color,
    required this.height,
    required this.borderRadius,
  });

  @override
  BoxPainter createBoxPainter([VoidCallback? onChanged]) {
    return _ModernTabIndicatorPainter(
      color: color,
      height: height,
      borderRadius: borderRadius,
    );
  }
}

class _ModernTabIndicatorPainter extends BoxPainter {
  final Color color;
  final double height;
  final BorderRadius borderRadius;

  _ModernTabIndicatorPainter({
    required this.color,
    required this.height,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    final rect = Rect.fromLTWH(
      offset.dx + (configuration.size!.width * 0.2),
      offset.dy + configuration.size!.height - height,
      configuration.size!.width * 0.6,
      height,
    );

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      borderRadius.toRRect(rect),
      paint,
    );
  }
}

/// Navigation destination data model
class NavigationItem {
  final String label;
  final IconData icon;
  final IconData? selectedIcon;
  final Widget? badge;
  final String? tooltip;

  const NavigationItem({
    required this.label,
    required this.icon,
    this.selectedIcon,
    this.badge,
    this.tooltip,
  });

  NavigationDestination toDestination() {
    return NavigationDestination(
      icon: Icon(icon),
      selectedIcon: selectedIcon != null ? Icon(selectedIcon!) : null,
      label: label,
      tooltip: tooltip,
    );
  }

  NavigationRailDestination toRailDestination() {
    return NavigationRailDestination(
      icon: Icon(icon),
      selectedIcon: selectedIcon != null ? Icon(selectedIcon!) : null,
      label: Text(label),
    );
  }

  Tab toTab() {
    return Tab(
      icon: Icon(icon),
      text: label,
    );
  }
}

/// Enhanced navigation controller
class EnhancedNavigationController extends ChangeNotifier {
  int _selectedIndex = 0;
  List<NavigationItem> _items = [];

  int get selectedIndex => _selectedIndex;
  List<NavigationItem> get items => _items;

  void setItems(List<NavigationItem> items) {
    _items = items;
    notifyListeners();
  }

  void selectIndex(int index) {
    if (index >= 0 && index < _items.length && index != _selectedIndex) {
      _selectedIndex = index;
      notifyListeners();
    }
  }

  void selectNext() {
    if (_selectedIndex < _items.length - 1) {
      selectIndex(_selectedIndex + 1);
    }
  }

  void selectPrevious() {
    if (_selectedIndex > 0) {
      selectIndex(_selectedIndex - 1);
    }
  }
}

/// Navigation wrapper that adapts to screen size
class AdaptiveNavigation extends StatelessWidget {
  final List<NavigationItem> items;
  final int selectedIndex;
  final ValueChanged<int> onIndexChanged;
  final Widget child;
  final double breakpoint;

  const AdaptiveNavigation({
    Key? key,
    required this.items,
    required this.selectedIndex,
    required this.onIndexChanged,
    required this.child,
    this.breakpoint = 840.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final useNavigationRail = constraints.maxWidth >= breakpoint;

        if (useNavigationRail) {
          return Row(
            children: [
              NavigationComponents.buildNavigationRail(
                destinations:
                    items.map((item) => item.toRailDestination()).toList(),
                selectedIndex: selectedIndex,
                onDestinationSelected: onIndexChanged,
                extended: constraints.maxWidth >= 1200,
              ),
              Expanded(child: child),
            ],
          );
        } else {
          return Scaffold(
            body: child,
            bottomNavigationBar: NavigationComponents.buildNavigationBar(
              destinations: items.map((item) => item.toDestination()).toList(),
              selectedIndex: selectedIndex,
              onDestinationSelected: onIndexChanged,
            ),
          );
        }
      },
    );
  }
}
