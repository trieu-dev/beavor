import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/transaction_controller.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../transaction_history/transaction_history_screen.dart';
import '../analysis/expense_analysis_screen.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final TransactionController controller = Get.put(TransactionController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('app_title'.tr),
        actions: [
          IconButton(
            icon: const Icon(Icons.analytics_outlined),
            onPressed: () => Get.to(() => ExpenseAnalysisScreen()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWealthCard(context),
            const SizedBox(height: 32),
            _buildQuickActions(),
            const SizedBox(height: 32),
            _buildRecentTransactionsHeader(),
            const SizedBox(height: 16),
            _buildRecentTransactionsList(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Get.to(() => AddTransactionScreen()),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildWealthCard(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: AppColors.wealthCardBackground,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.15),
          width: 0.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'net_worth'.tr,
            style: GoogleFonts.inter(
              color: AppColors.onSurfaceVariant,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              currencyFormatter.format(controller.totalBalance),
              style: GoogleFonts.manrope(
                color: AppColors.onSurface,
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTrendInfo(
                'income'.tr,
                '\$${controller.totalIncome.toStringAsFixed(2)}',
                AppColors.secondary,
              ),
              _buildTrendInfo(
                'expenses'.tr,
                '\$${controller.totalExpense.toStringAsFixed(2)}',
                AppColors.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendInfo(String label, String amount, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(
            color: AppColors.onSurfaceVariant,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          amount,
          style: GoogleFonts.manrope(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildActionItem(
          Icons.history,
          'history'.tr,
          () => Get.to(() => TransactionHistoryScreen()),
        ),
        _buildActionItem(
          Icons.pie_chart_outline,
          'analysis'.tr,
          () => Get.to(() => ExpenseAnalysisScreen()),
        ),
        _buildActionItem(
          Icons.account_balance_wallet_outlined,
          'wallets'.tr,
          () {},
        ),
      ],
    );
  }

  Widget _buildActionItem(IconData icon, String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHigh,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.primary, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              color: AppColors.onSurfaceVariant,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentTransactionsHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'recent_activity'.tr,
          style: GoogleFonts.manrope(
            color: AppColors.onSurface,
            fontSize: 22,
            fontWeight: FontWeight.w500,
          ),
        ),
        TextButton(
          onPressed: () => Get.to(() => TransactionHistoryScreen()),
          child: Text(
            'see_all'.tr,
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsList() {
    final currencyFormatter = NumberFormat.currency(
      symbol: '\$',
      decimalDigits: 2,
    );

    return Obx(() {
      if (controller.transactions.isEmpty) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Text(
              'no_recent_transactions'.tr,
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
            ),
          ),
        );
      }

      return Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLow,
          borderRadius: BorderRadius.circular(32), // large corner radius
        ),
        padding: const EdgeInsets.all(16),
        child: ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.transactions.length > 3
              ? 3
              : controller.transactions.length, // Show max 3
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final tx = controller.transactions[index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: tx.isIncome
                          ? AppColors.secondary.withValues(alpha: 0.1)
                          : AppColors.tertiary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      tx.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                      color: tx.isIncome
                          ? AppColors.secondary
                          : AppColors.tertiary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          tx.title,
                          style: GoogleFonts.manrope(
                            color: AppColors.onSurface,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          tx.category,
                          style: GoogleFonts.inter(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${tx.isIncome ? '+' : '-'}${currencyFormatter.format(tx.amount)}',
                    style: GoogleFonts.manrope(
                      color: tx.isIncome
                          ? AppColors.secondary
                          : AppColors.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    });
  }
}
