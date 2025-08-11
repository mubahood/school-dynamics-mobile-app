import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../typography/app_typography.dart';
import '../spacing/app_spacing.dart';
import 'app_card.dart';
import '../animations/list_animations.dart';

/// Enhanced list components for Students/Classes screens
/// Features modern layouts, filtering, search, and expandable detail views
class ListScreenComponents {
  ListScreenComponents._();

  /// Creates a modern list header with search and filters
  static Widget buildListHeader({
    required String title,
    String? searchHint,
    List<FilterOption>? filters,
    VoidCallback? onSearch,
    VoidCallback? onFilter,
    bool showBulkActions = false,
    List<BulkAction>? bulkActions,
  }) {
    return AppCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and Actions Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              Row(
                children: [
                  if (onFilter != null)
                    IconButton(
                      onPressed: onFilter,
                      icon: Icon(
                        Icons.filter_list,
                        color: AppColors.primary,
                      ),
                    ),
                  if (showBulkActions && bulkActions != null)
                    PopupMenuButton<BulkAction>(
                      icon: Icon(
                        Icons.more_vert,
                        color: AppColors.primary,
                      ),
                      itemBuilder: (context) => bulkActions
                          .map((action) => PopupMenuItem(
                                value: action,
                                child: Row(
                                  children: [
                                    Icon(action.icon, size: 20),
                                    AppSpacing.hGapSM,
                                    Text(action.label),
                                  ],
                                ),
                              ))
                          .toList(),
                      onSelected: (action) => action.onTap(),
                    ),
                ],
              ),
            ],
          ),

          if (searchHint != null) ...[
            AppSpacing.gapSM,
            // Search Field
            TextField(
              onChanged: (value) => onSearch?.call(),
              decoration: InputDecoration(
                hintText: searchHint,
                prefixIcon: Icon(
                  Icons.search,
                  color: AppColors.textSecondary,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                  borderSide: BorderSide(color: AppColors.primary),
                ),
                filled: true,
                fillColor: AppColors.surface,
              ),
            ),
          ],

          // Active Filters
          if (filters != null && filters.any((f) => f.isActive)) ...[
            AppSpacing.gapSM,
            Wrap(
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: filters
                  .where((f) => f.isActive)
                  .map((filter) => FilterChip(
                        label: Text(filter.label),
                        onSelected: (selected) {},
                        onDeleted: filter.onRemove,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        labelStyle: TextStyle(color: AppColors.primary),
                      ))
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates an expandable list item with modern design
  static Widget buildExpandableListItem({
    required Widget header,
    required Widget expandedContent,
    bool isExpanded = false,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
  }) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            child: Padding(
              padding: padding ?? const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Expanded(child: header),
                  Icon(
                    isExpanded ? Icons.expand_less : Icons.expand_more,
                    color: AppColors.textSecondary,
                  ),
                ],
              ),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: isExpanded ? null : 0,
            child: isExpanded
                ? Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: AppColors.border.withOpacity(0.5),
                          width: 1,
                        ),
                      ),
                    ),
                    child: expandedContent,
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Creates a student/class list item with avatar and details
  static Widget buildStudentListItem({
    required StudentItem student,
    bool isSelected = false,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    List<Widget>? trailingActions,
  }) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppSpacing.sm),
            border: isSelected
                ? Border.all(color: AppColors.primary, width: 2)
                : null,
            color: isSelected ? AppColors.primary.withOpacity(0.05) : null,
          ),
          child: Row(
            children: [
              // Avatar
              CircleAvatar(
                radius: 24,
                backgroundColor: student.avatarColor ?? AppColors.primary,
                backgroundImage: student.avatarUrl != null
                    ? NetworkImage(student.avatarUrl!)
                    : null,
                child: student.avatarUrl == null
                    ? Text(
                        student.initials,
                        style: AppTypography.titleMedium.copyWith(
                          color: AppColors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    : null,
              ),
              AppSpacing.hGapMD,

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      student.name,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (student.subtitle != null)
                      Text(
                        student.subtitle!,
                        style: AppTypography.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    if (student.details.isNotEmpty) ...[
                      AppSpacing.gapXS,
                      Wrap(
                        spacing: AppSpacing.sm,
                        children: student.details
                            .map((detail) => _buildDetailChip(detail))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Status and Actions
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (student.status != null) _buildStatusChip(student.status!),
                  if (trailingActions != null) ...[
                    AppSpacing.gapXS,
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: trailingActions,
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a detail chip for student information
  static Widget _buildDetailChip(DetailItem detail) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: detail.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (detail.icon != null) ...[
            Icon(
              detail.icon,
              size: 12,
              color: detail.color,
            ),
            const SizedBox(width: 2),
          ],
          Text(
            detail.text,
            style: AppTypography.labelSmall.copyWith(
              color: detail.color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a status chip
  static Widget _buildStatusChip(StatusItem status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Text(
        status.label,
        style: AppTypography.labelSmall.copyWith(
          color: status.color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// Creates an infinite scroll list view
  static Widget buildInfiniteScrollList({
    required List<Widget> items,
    required VoidCallback onLoadMore,
    bool hasMore = true,
    bool isLoading = false,
    Widget? loadingIndicator,
    Widget? emptyState,
  }) {
    if (items.isEmpty && !isLoading) {
      return emptyState ?? _buildDefaultEmptyState();
    }

    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scrollInfo) {
        if (!isLoading &&
            hasMore &&
            scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
          onLoadMore();
        }
        return false;
      },
      child: ListView.separated(
        itemCount: items.length + (hasMore ? 1 : 0),
        separatorBuilder: (context, index) => AppSpacing.gapSM,
        itemBuilder: (context, index) {
          if (index == items.length) {
            return loadingIndicator ??
                const Center(child: CircularProgressIndicator());
          }
          return items[index];
        },
      ),
    );
  }

  /// Default empty state widget
  static Widget _buildDefaultEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textSecondary,
          ),
          AppSpacing.gapMD,
          Text(
            'No items found',
            style: AppTypography.headlineSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          AppSpacing.gapSM,
          Text(
            'Try adjusting your search or filters',
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

/// Enhanced list view with animations and infinite scroll
class EnhancedListView extends StatefulWidget {
  final List<Widget> items;
  final VoidCallback? onLoadMore;
  final bool hasMore;
  final bool isLoading;
  final Widget? emptyState;
  final bool enableAnimations;

  const EnhancedListView({
    Key? key,
    required this.items,
    this.onLoadMore,
    this.hasMore = true,
    this.isLoading = false,
    this.emptyState,
    this.enableAnimations = true,
  }) : super(key: key);

  @override
  State<EnhancedListView> createState() => _EnhancedListViewState();
}

class _EnhancedListViewState extends State<EnhancedListView>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    if (widget.enableAnimations) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty && !widget.isLoading) {
      return widget.emptyState ??
          ListScreenComponents._buildDefaultEmptyState();
    }

    if (widget.enableAnimations) {
      return StaggeredAnimatedList(
        children: widget.items,
        staggerDelay: const Duration(milliseconds: 50),
      );
    }

    return ListScreenComponents.buildInfiniteScrollList(
      items: widget.items,
      onLoadMore: widget.onLoadMore ?? () {},
      hasMore: widget.hasMore,
      isLoading: widget.isLoading,
      emptyState: widget.emptyState,
    );
  }
}

// Data Models

class StudentItem {
  final String id;
  final String name;
  final String? subtitle;
  final String initials;
  final String? avatarUrl;
  final Color? avatarColor;
  final List<DetailItem> details;
  final StatusItem? status;

  const StudentItem({
    required this.id,
    required this.name,
    this.subtitle,
    required this.initials,
    this.avatarUrl,
    this.avatarColor,
    this.details = const [],
    this.status,
  });
}

class DetailItem {
  final String text;
  final IconData? icon;
  final Color color;

  const DetailItem({
    required this.text,
    this.icon,
    required this.color,
  });
}

class StatusItem {
  final String label;
  final Color color;

  const StatusItem({
    required this.label,
    required this.color,
  });
}

class FilterOption {
  final String label;
  final bool isActive;
  final VoidCallback? onRemove;

  const FilterOption({
    required this.label,
    this.isActive = false,
    this.onRemove,
  });
}

class BulkAction {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const BulkAction({
    required this.label,
    required this.icon,
    required this.onTap,
  });
}
