import 'package:flutter/material.dart';
import '../colors/app_colors.dart';
import '../typography/app_typography.dart';
import '../spacing/app_spacing.dart';
import 'app_card.dart';

/// Enhanced financial screen components for transaction lists and balance indicators
/// Features modern transaction layouts, payment status indicators, and period grouping
class FinancialScreenComponents {
  FinancialScreenComponents._();

  /// Creates a transaction list item with visual balance indicators
  static Widget buildTransactionListItem({
    required TransactionItem transaction,
    VoidCallback? onTap,
    bool showBalance = true,
  }) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Row(
            children: [
              // Transaction Type Icon
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: transaction.type.color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  transaction.type.icon,
                  color: transaction.type.color,
                  size: 24,
                ),
              ),
              AppSpacing.hGapMD,

              // Transaction Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            transaction.description,
                            style: AppTypography.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Text(
                          _formatAmount(
                              transaction.amount, transaction.isCredit),
                          style: AppTypography.titleMedium.copyWith(
                            fontWeight: FontWeight.w700,
                            color: transaction.isCredit
                                ? AppColors.success
                                : AppColors.error,
                          ),
                        ),
                      ],
                    ),
                    AppSpacing.gapXS,
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            transaction.category,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ),
                        if (showBalance)
                          Text(
                            'Balance: ${_formatAmount(transaction.balance, true)}',
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                      ],
                    ),
                    AppSpacing.gapXS,
                    Row(
                      children: [
                        Text(
                          transaction.date,
                          style: AppTypography.labelSmall.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const Spacer(),
                        _buildPaymentStatusChip(transaction.status),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Creates a payment status indicator chip
  static Widget _buildPaymentStatusChip(PaymentStatus status) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: status.color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(
          color: status.color.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            status.icon,
            size: 12,
            color: status.color,
          ),
          const SizedBox(width: 4),
          Text(
            status.label,
            style: AppTypography.labelSmall.copyWith(
              color: status.color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a balance summary card
  static Widget buildBalanceSummary({
    required double totalBalance,
    required double monthlyIncome,
    required double monthlyExpenses,
    String currency = '\$',
  }) {
    final netChange = monthlyIncome - monthlyExpenses;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Account Balance',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapSM,

          // Total Balance
          Text(
            _formatAmount(totalBalance, true, currency),
            style: AppTypography.headlineLarge.copyWith(
              fontWeight: FontWeight.bold,
              color: totalBalance >= 0 ? AppColors.success : AppColors.error,
            ),
          ),
          AppSpacing.gapMD,

          // Monthly Summary
          Row(
            children: [
              Expanded(
                child: _buildBalanceItem(
                  'Income',
                  monthlyIncome,
                  AppColors.success,
                  Icons.arrow_upward,
                  currency,
                ),
              ),
              AppSpacing.hGapMD,
              Expanded(
                child: _buildBalanceItem(
                  'Expenses',
                  monthlyExpenses,
                  AppColors.error,
                  Icons.arrow_downward,
                  currency,
                ),
              ),
            ],
          ),
          AppSpacing.gapMD,

          // Net Change
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: (netChange >= 0 ? AppColors.success : AppColors.error)
                  .withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSpacing.sm),
            ),
            child: Row(
              children: [
                Icon(
                  netChange >= 0 ? Icons.trending_up : Icons.trending_down,
                  color: netChange >= 0 ? AppColors.success : AppColors.error,
                  size: 20,
                ),
                AppSpacing.hGapSM,
                Text(
                  'Net Change: ${_formatAmount(netChange.abs(), netChange >= 0, currency)}',
                  style: AppTypography.bodyMedium.copyWith(
                    color: netChange >= 0 ? AppColors.success : AppColors.error,
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

  /// Creates a balance item for income/expenses
  static Widget _buildBalanceItem(
    String label,
    double amount,
    Color color,
    IconData icon,
    String currency,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppSpacing.sm),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 16),
              AppSpacing.hGapXS,
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          AppSpacing.gapXS,
          Text(
            _formatAmount(amount, true, currency),
            style: AppTypography.titleMedium.copyWith(
              color: color,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  /// Creates a period-based transaction grouping
  static Widget buildPeriodGroup({
    required String period,
    required List<Widget> transactions,
    required double periodTotal,
    bool isExpanded = true,
    VoidCallback? onToggle,
  }) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(AppSpacing.sm),
            ),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(AppSpacing.sm),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      period,
                      style: AppTypography.titleMedium.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    _formatAmount(periodTotal.abs(), periodTotal >= 0),
                    style: AppTypography.titleMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: periodTotal >= 0
                          ? AppColors.success
                          : AppColors.error,
                    ),
                  ),
                  AppSpacing.hGapSM,
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
                ? Column(
                    children: transactions
                        .map((transaction) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.md,
                                vertical: AppSpacing.xs,
                              ),
                              child: transaction,
                            ))
                        .toList(),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  /// Creates a quick payment actions row
  static Widget buildQuickPaymentActions({
    required List<PaymentAction> actions,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quick Actions',
            style: AppTypography.headlineSmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          AppSpacing.gapMD,
          Row(
            children: actions
                .map((action) => Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(
                          right: action == actions.last ? 0 : AppSpacing.sm,
                        ),
                        child: _buildPaymentActionButton(action),
                      ),
                    ))
                .toList(),
          ),
        ],
      ),
    );
  }

  /// Creates a payment action button
  static Widget _buildPaymentActionButton(PaymentAction action) {
    return InkWell(
      onTap: action.onTap,
      borderRadius: BorderRadius.circular(AppSpacing.sm),
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: action.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppSpacing.sm),
          border: Border.all(
            color: action.color.withOpacity(0.3),
            width: 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              action.icon,
              color: action.color,
              size: 32,
            ),
            AppSpacing.gapSM,
            Text(
              action.label,
              style: AppTypography.labelMedium.copyWith(
                color: action.color,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  /// Formats amount with proper currency display
  static String _formatAmount(double amount, bool isPositive,
      [String currency = '\$']) {
    final sign = isPositive ? '+' : '-';
    final formattedAmount = amount.toStringAsFixed(2);
    return '$sign$currency$formattedAmount';
  }
}

// Data Models

class TransactionItem {
  final String id;
  final String description;
  final String category;
  final double amount;
  final bool isCredit;
  final double balance;
  final String date;
  final PaymentStatus status;
  final TransactionType type;

  const TransactionItem({
    required this.id,
    required this.description,
    required this.category,
    required this.amount,
    required this.isCredit,
    required this.balance,
    required this.date,
    required this.status,
    required this.type,
  });
}

class TransactionType {
  final String name;
  final IconData icon;
  final Color color;

  const TransactionType({
    required this.name,
    required this.icon,
    required this.color,
  });

  static const payment = TransactionType(
    name: 'Payment',
    icon: Icons.payment,
    color: AppColors.success,
  );

  static const fee = TransactionType(
    name: 'Fee',
    icon: Icons.school,
    color: AppColors.academic,
  );

  static const refund = TransactionType(
    name: 'Refund',
    icon: Icons.money_off,
    color: AppColors.info,
  );

  static const adjustment = TransactionType(
    name: 'Adjustment',
    icon: Icons.edit,
    color: AppColors.warning,
  );
}

class PaymentStatus {
  final String label;
  final IconData icon;
  final Color color;

  const PaymentStatus({
    required this.label,
    required this.icon,
    required this.color,
  });

  static const completed = PaymentStatus(
    label: 'Completed',
    icon: Icons.check_circle,
    color: AppColors.success,
  );

  static const pending = PaymentStatus(
    label: 'Pending',
    icon: Icons.schedule,
    color: AppColors.warning,
  );

  static const failed = PaymentStatus(
    label: 'Failed',
    icon: Icons.error,
    color: AppColors.error,
  );

  static const processing = PaymentStatus(
    label: 'Processing',
    icon: Icons.hourglass_empty,
    color: AppColors.info,
  );
}

class PaymentAction {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const PaymentAction({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}
