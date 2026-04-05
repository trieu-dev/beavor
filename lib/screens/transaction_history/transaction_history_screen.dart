import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/transaction_controller.dart';
import '../add_transaction/add_transaction_screen.dart';

class TransactionHistoryScreen extends StatelessWidget {
  TransactionHistoryScreen({super.key});

  final TransactionController controller = Get.find<TransactionController>();

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'restaurant': return Icons.restaurant_rounded;
      case 'directions_car': return Icons.directions_car_rounded;
      case 'shopping_bag': return Icons.shopping_bag_rounded;
      case 'sports_esports': return Icons.sports_esports_rounded;
      case 'home': return Icons.home_rounded;
      case 'payments': return Icons.payments_rounded;
      case 'redeem': return Icons.redeem_rounded;
      case 'wallet': return Icons.account_balance_wallet_rounded;
      case 'account_balance': return Icons.account_balance_rounded;
      default: return Icons.category_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          'history_title'.tr,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.receipt_long_rounded,
                  size: 64,
                  color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
                ),
                const SizedBox(height: 16),
                Text(
                  'history_empty'.tr,
                  style: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        }

        final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          itemCount: controller.transactions.length,
          physics: const BouncingScrollPhysics(),
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final tx = controller.transactions[index];
            final category = controller.getCategoryById(tx.categoryId);
            final wallet = controller.getWalletById(tx.walletId);
            
            return GestureDetector(
              onTap: () => Get.to(() => AddTransactionScreen(initialTransaction: tx)),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Color(category?.colorValue ?? 0xFF6366F1).withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        _getIconData(category?.icon ?? 'category'),
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
                          const SizedBox(height: 4),
                          Text(
                            '${category?.name ?? 'General'} • ${wallet?.name ?? 'Wallet'} • ${DateFormat('dd/MM/yyyy').format(tx.date)}',
                            style: GoogleFonts.inter(
                              color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${tx.isIncome ? '+' : '-'}${currencyFormatter.format(tx.amount)}',
                      style: GoogleFonts.manrope(
                        color: tx.isIncome ? AppColors.secondary : AppColors.onSurface,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
