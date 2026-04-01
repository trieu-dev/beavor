import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/transaction_controller.dart';

class ExpenseAnalysisScreen extends StatelessWidget {
  ExpenseAnalysisScreen({super.key});

  final TransactionController controller = Get.find<TransactionController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          _buildSliverAppBar(),
          SliverToBoxAdapter(
            child: Obx(() {
              final transactions = controller.filteredTransactions;
              if (transactions.isEmpty) {
                return _buildEmptyState();
              }

              final Map<String, double> categoryExpenses = {};
              for (var tx in transactions) {
                if (!tx.isIncome) {
                  categoryExpenses[tx.category] = (categoryExpenses[tx.category] ?? 0) + tx.amount;
                }
              }

              final double totalExpense = controller.filteredTotalExpense;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 24),
                    _buildTimeframeSelector(),
                    const SizedBox(height: 32),
                    _buildDonutChartSection(categoryExpenses, totalExpense),
                    const SizedBox(height: 40),
                    _buildTrendChartSection(),
                    const SizedBox(height: 40),
                    _buildCategoryList(categoryExpenses, totalExpense),
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

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      expandedHeight: 180,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.background,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            // Mesh Gradient Background
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
            // Header Content
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Spending Analysis',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Obx(() => Text(
                    '\$${controller.filteredTotalExpense.toStringAsFixed(2)}',
                    style: GoogleFonts.manrope(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: -1,
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
        children: ['Weekly', 'Monthly'].map((timeframe) {
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
                timeframe,
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

  Widget _buildDonutChartSection(Map<String, double> data, double total) {
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
              sections: _generateSections(data, total),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Top Category',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ),
                Text(
                  data.entries.first.key,
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
          'Spending Trend',
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
                    const FlSpot(0, 3),
                    const FlSpot(1, 1),
                    const FlSpot(2, 4),
                    const FlSpot(3, 2),
                    const FlSpot(4, 5),
                    const FlSpot(5, 3),
                    const FlSpot(6, 4),
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

  Widget _buildCategoryList(Map<String, double> data, double total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detailed Breakdown',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: AppColors.onSurface,
          ),
        ),
        const SizedBox(height: 16),
        ...data.entries.map((entry) {
          final percentage = (entry.value / total) * 100;
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
                      width: 12,
                      height: 12,
                      decoration: const BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      entry.key,
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '\$${entry.value.toStringAsFixed(2)}',
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
                    color: AppColors.primary,
                    minHeight: 6,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
      ],
    );
  }

  List<PieChartSectionData> _generateSections(Map<String, double> data, double total) {
    final colors = [AppColors.primary, AppColors.secondary, AppColors.tertiary, Colors.orangeAccent, Colors.pinkAccent];
    int i = 0;
    return data.entries.map((entry) {
      final color = colors[i % colors.length];
      i++;
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
              'No data for the selected period',
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
