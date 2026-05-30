import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/transaction_controller.dart';
import '../transaction_history/transaction_history_screen.dart';
import '../add_transaction/add_transaction_screen.dart';
import '../living/living_expenses_screen.dart';
import '../expense_splitter/split_bill_screen.dart';
import '../analysis/expense_analysis_screen.dart';
import '../../controllers/living_expense_controller.dart';
import '../../widgets/empty_transaction_state.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({super.key});

  final TransactionController controller = Get.put(TransactionController());
  final LivingExpenseController livingController = Get.put(
    LivingExpenseController(),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: Text(
          'app_title'.tr,
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: TweenAnimationBuilder<double>(
        duration: const Duration(milliseconds: 800),
        tween: Tween(begin: 0.0, end: 1.0),
        curve: Curves.easeOutCubic,
        builder: (context, value, child) {
          return Opacity(
            opacity: value,
            child: Transform.translate(
              offset: Offset(0, 20 * (1 - value)),
              child: child,
            ),
          );
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWealthCard(context),
              const SizedBox(height: 24),
              _buildQuickShortcuts(context),
              const SizedBox(height: 32),
              _buildRecentTransactionsHeader(),
              const SizedBox(height: 16),
              _buildRecentTransactionsList(),
              const SizedBox(height: 100), // Space for bottom bar
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWealthCard(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(32),
      child: Stack(
        children: [
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(color: Color(0xFF0F172A)),
            ),
          ),
          ...AppColors.wealthCardMesh.map(
            (g) => Positioned.fill(
              child: Container(decoration: BoxDecoration(gradient: g)),
            ),
          ),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(32),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'expenses'.tr,
                  style: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 12),
                Obx(
                  () => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      currencyFormatter.format(controller.totalExpense),
                      style: GoogleFonts.manrope(
                        color: AppColors.onSurface,
                        fontSize: 40,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickShortcuts(BuildContext context) {
    final shortcuts = [
      _ShortcutItem(
        icon: Icons.add_rounded,
        label: 'shortcut_add_tx'.tr,
        onTap: () => Get.to(() => const AddTransactionScreen()),
      ),
      _ShortcutItem(
        icon: Icons.account_balance_wallet_rounded,
        label: 'shortcut_budget'.tr,
        onTap: () => Get.to(() => LivingExpensesScreen()),
      ),
      _ShortcutItem(
        icon: Icons.receipt_long_rounded,
        label: 'shortcut_split_bill'.tr,
        onTap: () => Get.to(() => const SplitBillScreen()),
      ),
      _ShortcutItem(
        icon: Icons.insert_chart_rounded,
        label: 'shortcut_reports'.tr,
        onTap: () => Get.to(() => ExpenseAnalysisScreen()),
      ),
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: shortcuts.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: _buildShortcutButton(item),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildShortcutButton(_ShortcutItem item) {
    return GestureDetector(
      onTap: item.onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.06),
                width: 0.5,
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0x33818CF8), // primary at 20%
                        Color(0x1A6366F1), // primaryDim at 10%
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    item.icon,
                    color: AppColors.primary,
                    size: 22,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  item.label,
                  style: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
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
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        TextButton(
          onPressed: () => Get.to(() => TransactionHistoryScreen()),
          child: Row(
            children: [
              Text(
                'see_all'.tr,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                size: 18,
                color: AppColors.primary,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactionsList() {
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Obx(() {
      if (controller.transactions.isEmpty) {
        return const EmptyTransactionState();
      }

      final recent = controller.transactions.take(5).toList();

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: recent.length,
        separatorBuilder: (context, index) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final tx = recent[index];
          final category = controller.getCategoryById(tx.categoryId);

          return GestureDetector(
            onTap: () =>
                Get.to(() => AddTransactionScreen(initialTransaction: tx)),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.03),
                  width: 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    height: 48,
                    width: 48,
                    decoration: BoxDecoration(
                      color: Color(
                        category?.colorValue ?? 0xFF6366F1,
                      ).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      tx.isIncome
                          ? Icons.keyboard_arrow_down_rounded
                          : Icons.keyboard_arrow_up_rounded,
                      color: Color(category?.colorValue ?? 0xFF6366F1),
                      size: 24,
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
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          category?.name ?? 'General',
                          style: GoogleFonts.inter(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        '${tx.isIncome ? '+' : '-'}${currencyFormatter.format(tx.amount)}',
                        style: GoogleFonts.manrope(
                          color: tx.isIncome
                              ? AppColors.secondary
                              : AppColors.onSurface,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        DateFormat('MMM dd').format(tx.date),
                        style: GoogleFonts.inter(
                          color: AppColors.onSurfaceVariant.withValues(
                            alpha: 0.5,
                          ),
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    });
  }
}

class _ShortcutItem {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ShortcutItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });
}
