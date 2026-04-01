import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/theme/app_colors.dart';
import 'calendar_controller.dart';

class CalendarScreen extends StatelessWidget {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CalendarController());

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
                    _buildCalendarCard(controller),
                    const SizedBox(height: 24),
                    _buildAgendaSection(controller),
                    const SizedBox(height: 100), // Space for bottom bar
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
      padding: const EdgeInsets.all(24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Financial Calendar',
            style: GoogleFonts.manrope(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: AppColors.onSurface,
              letterSpacing: -1,
            ),
          ),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: const Icon(Icons.notifications_none_rounded, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarCard(CalendarController controller) {
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
            child: Obx(() => TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: controller.focusedDay.value,
              selectedDayPredicate: (day) => controller.isSameDay(controller.selectedDay.value, day),
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
                leftChevronIcon: const Icon(Icons.chevron_left_rounded, color: AppColors.primary),
                rightChevronIcon: const Icon(Icons.chevron_right_rounded, color: AppColors.primary),
              ),
              daysOfWeekStyle: DaysOfWeekStyle(
                weekdayStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontWeight: FontWeight.w600),
                weekendStyle: GoogleFonts.inter(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5), fontWeight: FontWeight.w600),
              ),
              calendarStyle: CalendarStyle(
                defaultTextStyle: GoogleFonts.inter(color: AppColors.onSurface, fontWeight: FontWeight.w500),
                weekendTextStyle: GoogleFonts.inter(color: AppColors.onSurface, fontWeight: FontWeight.w500),
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
                      style: GoogleFonts.inter(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  );
                },
                todayBuilder: (context, day, focusedDay) {
                  return Container(
                    margin: const EdgeInsets.all(6),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.5), width: 1),
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${day.day}',
                      style: GoogleFonts.inter(color: AppColors.primary, fontWeight: FontWeight.bold),
                    ),
                  );
                },
                markerBuilder: (context, date, events) {
                  // Premium marker: pulsing dots for transactions
                  if (date.day % 3 == 0) { // Selective mock markers
                    return Positioned(
                      bottom: 8,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.secondary,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 2),
                          Container(
                            width: 5,
                            height: 5,
                            decoration: const BoxDecoration(
                              color: AppColors.error,
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
            )),
          ),
        ),
      ),
    );
  }

  Widget _buildAgendaSection(CalendarController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(() => Text(
                controller.isSameDay(controller.selectedDay.value, DateTime.now()) 
                  ? 'Today\'s Agenda' 
                  : DateFormat('MMMM d, yyyy').format(controller.selectedDay.value!),
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
              )),
              Text(
                'See all',
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
                  'No records for this day',
                  style: GoogleFonts.inter(color: AppColors.onSurfaceVariant.withValues(alpha: 0.5)),
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
              return _buildTransactionItem(tx);
            },
          );
        }),
      ],
    );
  }

  Widget _buildDailySummaryCard(CalendarController controller) {
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
          _buildSummaryBox('Income', controller.dailyIncome, AppColors.secondary),
          Container(width: 1, height: 40, color: Colors.white.withValues(alpha: 0.05), margin: const EdgeInsets.symmetric(horizontal: 20)),
          _buildSummaryBox('Expense', controller.dailyExpense, AppColors.error),
        ],
      ),
    );
  }

  Widget _buildSummaryBox(String label, double amount, Color color) {
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
          Text(
            '\$${amount.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionItem(dynamic tx) {
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
              color: !tx.isIncome 
                  ? AppColors.error.withValues(alpha: 0.1) 
                  : AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              !tx.isIncome ? Icons.arrow_outward_rounded : Icons.south_west_rounded,
              color: !tx.isIncome ? AppColors.error : AppColors.secondary,
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
                  tx.category,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${!tx.isIncome ? '-' : '+'}\$${tx.amount.toStringAsFixed(2)}',
            style: GoogleFonts.manrope(
              fontWeight: FontWeight.w800,
              color: !tx.isIncome ? AppColors.error : AppColors.secondary,
            ),
          ),
        ],
      ),
    );
  }
}
