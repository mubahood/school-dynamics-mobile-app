import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../typography/app_typography.dart';
import '../spacing/app_spacing.dart';
import 'app_card.dart';

/// Enhanced academic screen components for attendance and grade tracking
/// Features visual attendance indicators, calendar views, and grade visualizations
class AcademicScreenComponents {
  AcademicScreenComponents._();

  /// Creates a visual attendance indicator
  static Widget buildAttendanceIndicator({
    required AttendanceRecord record,
    VoidCallback? onTap,
    bool showDetails = true,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.zero,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: record.status.color.withOpacity(0.1),
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: record.status.color.withOpacity(0.3),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              record.status.icon,
              color: record.status.color,
              size: showDetails ? 24 : 16,
            ),
            if (showDetails) ...[
              AppSpacing.gapXS,
              Text(
                record.date,
                style: AppTypography.labelSmall.copyWith(
                  color: record.status.color,
                  fontWeight: FontWeight.w600,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }

  /// Creates a calendar view for attendance
  static Widget buildAttendanceCalendar({
    required Map<DateTime, AttendanceStatus> attendanceData,
    required DateTime currentMonth,
    VoidCallback? onPreviousMonth,
    VoidCallback? onNextMonth,
    Function(DateTime)? onDayTap,
  }) {
    return AppCard(
      child: Column(
        children: [
          // Calendar Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: onPreviousMonth,
                icon: Icon(Icons.chevron_left, color: AppColors.primary),
              ),
              Text(
                _formatMonthYear(currentMonth),
                style: AppTypography.headlineSmall.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              IconButton(
                onPressed: onNextMonth,
                icon: Icon(Icons.chevron_right, color: AppColors.primary),
              ),
            ],
          ),
          AppSpacing.gapMD,

          // Days of Week Header
          Row(
            children: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
                .map((day) => Expanded(
                      child: Text(
                        day,
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ))
                .toList(),
          ),
          AppSpacing.gapSM,

          // Calendar Grid
          _buildCalendarGrid(
            currentMonth,
            attendanceData,
            onDayTap,
          ),
        ],
      ),
    );
  }

  /// Creates a calendar grid for the attendance view
  static Widget _buildCalendarGrid(
    DateTime currentMonth,
    Map<DateTime, AttendanceStatus> attendanceData,
    Function(DateTime)? onDayTap,
  ) {
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final startDate =
        firstDayOfMonth.subtract(Duration(days: firstDayOfMonth.weekday % 7));

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        childAspectRatio: 1,
      ),
      itemCount: 42, // 6 weeks * 7 days
      itemBuilder: (context, index) {
        final date = startDate.add(Duration(days: index));
        final isCurrentMonth = date.month == currentMonth.month;
        final attendanceStatus = attendanceData[date];

        return GestureDetector(
          onTap: () => onDayTap?.call(date),
          child: Container(
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: attendanceStatus?.color.withOpacity(0.1),
              borderRadius: BorderRadius.zero,
              border: attendanceStatus != null
                  ? Border.all(
                      color: attendanceStatus.color.withOpacity(0.3),
                      width: 1,
                    )
                  : null,
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    '${date.day}',
                    style: AppTypography.bodySmall.copyWith(
                      color: isCurrentMonth
                          ? (attendanceStatus?.color ?? AppColors.textPrimary)
                          : AppColors.textSecondary,
                      fontWeight: attendanceStatus != null
                          ? FontWeight.w600
                          : FontWeight.normal,
                    ),
                  ),
                  if (attendanceStatus != null) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 4,
                      height: 4,
                      decoration: BoxDecoration(
                        color: attendanceStatus.color,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// Creates attendance statistics summary
  static Widget buildAttendanceStats({
    required AttendanceStats stats,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Attendance Statistics',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapMD,

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Present',
                  stats.presentDays,
                  stats.totalDays,
                  AppColors.success,
                  Icons.check_circle,
                ),
              ),
              AppSpacing.hGapMD,
              Expanded(
                child: _buildStatItem(
                  'Absent',
                  stats.absentDays,
                  stats.totalDays,
                  AppColors.error,
                  Icons.cancel,
                ),
              ),
            ],
          ),
          AppSpacing.gapMD,

          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'Late',
                  stats.lateDays,
                  stats.totalDays,
                  AppColors.warning,
                  Icons.access_time,
                ),
              ),
              AppSpacing.hGapMD,
              Expanded(
                child: _buildStatItem(
                  'Excused',
                  stats.excusedDays,
                  stats.totalDays,
                  AppColors.info,
                  Icons.event_note,
                ),
              ),
            ],
          ),
          AppSpacing.gapMD,

          // Overall Percentage
          Container(
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.zero,
            ),
            child: Row(
              children: [
                Icon(
                  Icons.trending_up,
                  color: AppColors.primary,
                ),
                AppSpacing.hGapSM,
                Text(
                  'Overall Attendance: ${stats.attendancePercentage.toStringAsFixed(1)}%',
                  style: AppTypography.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a stat item for attendance statistics
  static Widget _buildStatItem(
    String label,
    int count,
    int total,
    Color color,
    IconData icon,
  ) {
    final percentage = total > 0 ? (count / total * 100) : 0.0;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.zero,
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          AppSpacing.gapXS,
          Text(
            '$count',
            style: AppTypography.titleLarge.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: AppTypography.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '${percentage.toStringAsFixed(1)}%',
            style: AppTypography.labelSmall.copyWith(
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a grade visualization component
  static Widget buildGradeVisualization({
    required GradeItem grade,
    bool showTrend = true,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      grade.subject,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      grade.examType,
                      style: AppTypography.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              _buildGradeDisplay(grade),
            ],
          ),
          if (showTrend && grade.previousGrade != null) ...[
            AppSpacing.gapMD,
            _buildGradeTrend(grade.score, grade.previousGrade!),
          ],
          if (grade.comments != null) ...[
            AppSpacing.gapMD,
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.zero,
              ),
              child: Text(
                grade.comments!,
                style: AppTypography.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  /// Creates a grade display with color coding
  static Widget _buildGradeDisplay(GradeItem grade) {
    final gradeColor = _getGradeColor(grade.score, grade.maxScore);

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: gradeColor.withOpacity(0.1),
        borderRadius: BorderRadius.zero,
        border: Border.all(
          color: gradeColor.withOpacity(0.3),
          width: 2,
        ),
      ),
      child: Column(
        children: [
          Text(
            '${grade.score}',
            style: AppTypography.headlineMedium.copyWith(
              color: gradeColor,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '/ ${grade.maxScore}',
            style: AppTypography.bodyMedium.copyWith(
              color: gradeColor,
            ),
          ),
          Text(
            '${(grade.score / grade.maxScore * 100).toStringAsFixed(1)}%',
            style: AppTypography.labelMedium.copyWith(
              color: gradeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a grade trend indicator
  static Widget _buildGradeTrend(double currentScore, double previousScore) {
    final difference = currentScore - previousScore;
    final isImprovement = difference > 0;
    final color = isImprovement ? AppColors.success : AppColors.error;
    final icon = isImprovement ? Icons.trending_up : Icons.trending_down;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.zero,
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 16),
          AppSpacing.hGapXS,
          Text(
            '${difference.abs().toStringAsFixed(1)} points ${isImprovement ? 'improvement' : 'decrease'}',
            style: AppTypography.labelMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a progress tracking element
  static Widget buildProgressTracker({
    required List<ProgressItem> progressItems,
    String title = 'Academic Progress',
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapMD,
          ...progressItems.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: _buildProgressItem(item),
              )),
        ],
      ),
    );
  }

  /// Creates a single progress item
  static Widget _buildProgressItem(ProgressItem item) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              item.subject,
              style: AppTypography.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${(item.progress * 100).toStringAsFixed(0)}%',
              style: AppTypography.bodyMedium.copyWith(
                color: _getProgressColor(item.progress),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        AppSpacing.gapXS,
        LinearProgressIndicator(
          value: item.progress,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(
            _getProgressColor(item.progress),
          ),
        ),
      ],
    );
  }

  /// Gets color based on grade score
  static Color _getGradeColor(double score, double maxScore) {
    final percentage = score / maxScore;
    if (percentage >= 0.9) return AppColors.success;
    if (percentage >= 0.8) return AppColors.academic;
    if (percentage >= 0.7) return AppColors.warning;
    return AppColors.error;
  }

  /// Gets color based on progress percentage
  static Color _getProgressColor(double progress) {
    if (progress >= 0.8) return AppColors.success;
    if (progress >= 0.6) return AppColors.academic;
    if (progress >= 0.4) return AppColors.warning;
    return AppColors.error;
  }

  /// Formats month and year for calendar header
  static String _formatMonthYear(DateTime date) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }
}

// Data Models

class AttendanceRecord {
  final String id;
  final String date;
  final AttendanceStatus status;
  final String? notes;

  const AttendanceRecord({
    required this.id,
    required this.date,
    required this.status,
    this.notes,
  });
}

class AttendanceStatus {
  final String label;
  final IconData icon;
  final Color color;

  const AttendanceStatus({
    required this.label,
    required this.icon,
    required this.color,
  });

  static const present = AttendanceStatus(
    label: 'Present',
    icon: Icons.check_circle,
    color: AppColors.success,
  );

  static const absent = AttendanceStatus(
    label: 'Absent',
    icon: Icons.cancel,
    color: AppColors.error,
  );

  static const late = AttendanceStatus(
    label: 'Late',
    icon: Icons.access_time,
    color: AppColors.warning,
  );

  static const excused = AttendanceStatus(
    label: 'Excused',
    icon: Icons.event_note,
    color: AppColors.info,
  );
}

class AttendanceStats {
  final int presentDays;
  final int absentDays;
  final int lateDays;
  final int excusedDays;
  final int totalDays;

  const AttendanceStats({
    required this.presentDays,
    required this.absentDays,
    required this.lateDays,
    required this.excusedDays,
    required this.totalDays,
  });

  double get attendancePercentage {
    if (totalDays == 0) return 0.0;
    return (presentDays + lateDays) / totalDays * 100;
  }
}

class GradeItem {
  final String id;
  final String subject;
  final String examType;
  final double score;
  final double maxScore;
  final double? previousGrade;
  final String date;
  final String? comments;

  const GradeItem({
    required this.id,
    required this.subject,
    required this.examType,
    required this.score,
    required this.maxScore,
    this.previousGrade,
    required this.date,
    this.comments,
  });
}

class ProgressItem {
  final String subject;
  final double progress; // 0.0 to 1.0
  final Color? color;

  const ProgressItem({
    required this.subject,
    required this.progress,
    this.color,
  });
}
