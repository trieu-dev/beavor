import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_colors.dart';
import '../../models/transaction_model.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/utils/icon_mapper.dart';
import 'calendar_controller.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalendarController());
    final txController = Get.find<TransactionController>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    _buildCalendarCard(controller, txController),
                    const SizedBox(height: 24),
                    _buildAgendaSection(controller, txController),
                    const SizedBox(height: 120), // Space for bottom bar
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Text(
        'nav_calendar'.tr,
        style: GoogleFonts.manrope(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: AppColors.onSurface,
          letterSpacing: -1,
        ),
      ),
    );
  }

  Widget _buildCalendarCard(
    CalendarController controller,
    TransactionController txController,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Obx(
              () => TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: controller.focusedDay.value,
                selectedDayPredicate: (day) =>
                    controller.isSameDay(controller.selectedDay.value, day),
                onDaySelected: controller.onDaySelected,
                calendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(
                  formatButtonVisible: false,
                  titleCentered: true,
                  titleTextStyle: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                  leftChevronIcon: const Icon(
                    Icons.chevron_left_rounded,
                    color: AppColors.primary,
                  ),
                  rightChevronIcon: const Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.primary,
                  ),
                ),
                daysOfWeekStyle: DaysOfWeekStyle(
                  weekdayStyle: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                  ),
                  weekendStyle: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                calendarStyle: CalendarStyle(
                  defaultTextStyle: GoogleFonts.inter(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  weekendTextStyle: GoogleFonts.inter(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w500,
                  ),
                  outsideDaysVisible: false,
                  markersMaxCount: 1,
                ),
                calendarBuilders: CalendarBuilders(
                  selectedBuilder: (context, day, focusedDay) {
                    return Container(
                      margin: const EdgeInsets.all(6),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        gradient: AppColors.primaryGradient,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.4),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        '${day.day}',
                        style: GoogleFonts.inter(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    );
                  },
                  markerBuilder: (context, date, events) {
                    final transactions = txController.transactions
                        .where((t) => controller.isSameDay(t.date, date))
                        .toList();
                    if (transactions.isNotEmpty) {
                      final hasIncome = transactions.any((t) => t.isIncome);
                      final hasExpense = transactions.any((t) => !t.isIncome);

                      return Positioned(
                        bottom: 8,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (hasIncome)
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.secondary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            if (hasIncome && hasExpense)
                              const SizedBox(width: 2),
                            if (hasExpense)
                              Container(
                                width: 5,
                                height: 5,
                                decoration: const BoxDecoration(
                                  color: AppColors.tertiary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                          ],
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAgendaSection(
    CalendarController controller,
    TransactionController txController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => Text(
                  controller.isSameDay(
                        controller.selectedDay.value,
                        DateTime.now(),
                      )
                      ? 'calendar_agenda'.tr
                      : DateFormat(
                          'MMMM d, yyyy',
                        ).format(controller.selectedDay.value!),
                  style: GoogleFonts.manrope(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ),
              Text(
                'see_all'.tr,
                style: GoogleFonts.inter(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        Obx(() => _buildDailySummaryCard(controller)),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.dailyTransactions.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Text(
                  'calendar_no_transactions'.tr,
                  style: GoogleFonts.inter(
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
            );
          }
          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: controller.dailyTransactions.length,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemBuilder: (context, index) {
              final tx = controller.dailyTransactions[index];
              return _buildTransactionItem(tx, txController);
            },
          );
        }),
      ],
    );
  }

  Widget _buildDailySummaryCard(CalendarController controller) {
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          _buildSummaryBox(
            'income'.tr,
            currencyFormatter.format(controller.dailyIncome),
            AppColors.secondary,
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.white.withValues(alpha: 0.05),
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
          _buildSummaryBox(
            'expenses'.tr,
            currencyFormatter.format(controller.dailyExpense),
            AppColors.tertiary,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String label, String amount, Color color) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              amount,
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(
    TransactionModel tx,
    TransactionController txController,
  ) {
    final category = txController.getCategoryById(tx.categoryId);
    final currencyFormatter = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(
                category?.colorValue ?? 0xFF6366F1,
              ).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              IconMapper.getIconData(category?.icon ?? 'category'),
              color: Color(category?.colorValue ?? 0xFF6366F1),
              size: 20,
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
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  category?.name ?? 'General',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${tx.isIncome ? '+' : '-'}${currencyFormatter.format(tx.amount)}',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              color: tx.isIncome ? AppColors.secondary : AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
