import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/transaction_controller.dart';
import '../../core/utils/icon_mapper.dart';

class ExpenseAnalysisScreen extends StatelessWidget {
  ExpenseAnalysisScreen({super.key});

  final TransactionController controller = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(currencyFormatter),
          SliverToBoxAdapter(
            child: Obx(() {
              final transactions = controller.filteredTransactions;
              if (transactions.isEmpty) {
                return _buildEmptyState();
              }

              final Map<String, double> categoryExpenses = {};
              for (var tx in transactions) {
                if (!tx.isIncome) {
                  categoryExpenses[tx.categoryId] = (categoryExpenses[tx.categoryId] ?? 0) + tx.amount;
                }
              }

              if (categoryExpenses.isEmpty) {
                return _buildEmptyState();
              }

              final double totalExpense = controller.filteredTotalExpense;
              // Sort by amount descending
              final sortedEntries = categoryExpenses.entries.toList()..sort((a, b) => b.value.compareTo(a.value));

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildTimeframeSelector(),
                    const SizedBox(height: 32),
                    _buildDonutChartSection(sortedEntries, totalExpense),
                    const SizedBox(height: 40),
                    _buildTrendChartSection(),
                    const SizedBox(height: 40),
                    _buildCategoryList(sortedEntries, totalExpense, currencyFormatter),
                    const SizedBox(height: 120), // Bottom padding for Nav Bar
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(NumberFormat currencyFormatter) {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.3),
                    AppColors.background,
                  ],
                ),
              ),
            ),
            Positioned(
              top: -50,
              right: -50,
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'analysis_title'.tr,
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      currencyFormatter.format(controller.filteredTotalExpense),
                      style: GoogleFonts.manrope(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -1,
                      ),
                    ),
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeframeSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: {
          'Weekly': 'analysis_weekly'.tr,
          'Monthly': 'analysis_monthly'.tr,
        }.entries.map((entry) {
          final timeframe = entry.key;
          final label = entry.value;
          final isSelected = controller.selectedTimeframe.value == timeframe;
          return GestureDetector(
            onTap: () => controller.setTimeframe(timeframe),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surface : Colors.transparent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  )
                ] : [],
              ),
              child: Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDonutChartSection(List<MapEntry<String, double>> sortedEntries, double total) {
    final topCategory = controller.getCategoryById(sortedEntries.first.key);
    
    return Container(
      height: 280,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow.withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Stack(
        children: [
          PieChart(
            PieChartData(
              sectionsSpace: 6,
              centerSpaceRadius: 75,
              sections: _generateSections(sortedEntries, total),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'analysis_top_category'.tr,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  topCategory?.name ?? 'General',
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'analysis_trend'.tr,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          height: 180,
          width: double.infinity,
          padding: const EdgeInsets.only(right: 20, top: 10),
          child: LineChart(
            LineChartData(
              gridData: FlGridData(show: false),
              titlesData: FlTitlesData(show: false),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: [
                    const FlSpot(0, 30),
                    const FlSpot(1, 15),
                    const FlSpot(2, 45),
                    const FlSpot(3, 20),
                    const FlSpot(4, 55),
                    const FlSpot(5, 35),
                    const FlSpot(6, 40),
                  ],
                  isCurved: true,
                  gradient: const LinearGradient(
                    colors: [AppColors.primary, AppColors.tertiary],
                  ),
                  barWidth: 4,
                  isStrokeCapRound: true,
                  dotData: FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primary.withValues(alpha: 0.2),
                        AppColors.primary.withValues(alpha: 0.0),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryList(List<MapEntry<String, double>> sortedEntries, double total, NumberFormat currencyFormatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'analysis_breakdown'.tr,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ...sortedEntries.map((entry) {
          final category = controller.getCategoryById(entry.key);
          final percentage = (entry.value / total) * 100;
          final color = Color(category?.colorValue ?? 0xFF6366F1);

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        IconMapper.getIconData(category?.icon ?? 'category'),
                        color: color,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      category?.name ?? 'General',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      currencyFormatter.format(entry.value),
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentage / 100,
                    backgroundColor: Colors.white.withValues(alpha: 0.05),
                    color: color,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  List<PieChartSectionData> _generateSections(List<MapEntry<String, double>> sortedEntries, double total) {
    return sortedEntries.map((entry) {
      final category = controller.getCategoryById(entry.key);
      final color = Color(category?.colorValue ?? 0xFF6366F1);
      
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '',
        radius: 20,
        badgeWidget: null,
      );
    }).toList();
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 100),
        child: Column(
          children: [
            Icon(Icons.analytics_outlined, size: 64, color: AppColors.onSurfaceVariant.withValues(alpha: 0.2)),
            const SizedBox(height: 16),
            Text(
              'empty_data'.tr,
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
