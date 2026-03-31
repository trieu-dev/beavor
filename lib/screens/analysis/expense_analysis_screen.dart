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
      appBar: AppBar(title: const Text('Expense Analysis')),
      body: Obx(() {
        if (controller.transactions.isEmpty) {
          return Center(
            child: Text(
              'No data to analyze.',
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
            ),
          );
        }

        // Calculate expenses by category
        final Map<String, double> categoryExpenses = {};
        for (var tx in controller.transactions) {
          if (!tx.isIncome) {
            categoryExpenses[tx.category] =
                (categoryExpenses[tx.category] ?? 0) + tx.amount;
          }
        }

        if (categoryExpenses.isEmpty) {
          return Center(
            child: Text(
              'No expense data available.',
              style: GoogleFonts.inter(color: AppColors.onSurfaceVariant),
            ),
          );
        }

        final double totalExpense = controller.totalExpense;

        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          child: Column(
            children: [
              SizedBox(
                height: 300,
                child: Stack(
                  children: [
                    PieChart(
                      PieChartData(
                        sectionsSpace: 4,
                        centerSpaceRadius: 80,
                        sections: _generateSections(
                          categoryExpenses,
                          totalExpense,
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Total',
                            style: GoogleFonts.inter(
                              color: AppColors.onSurfaceVariant,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            '\$${totalExpense.toStringAsFixed(2)}',
                            style: GoogleFonts.manrope(
                              color: AppColors.tertiary,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 48),
              _buildLegend(categoryExpenses),
            ],
          ),
        );
      }),
    );
  }

  List<PieChartSectionData> _generateSections(
    Map<String, double> data,
    double total,
  ) {
    List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.blueAccent,
    ];

    int i = 0;
    return data.entries.map((entry) {
      final color = colors[i % colors.length];
      i++;
      final double percentage = (entry.value / total) * 100;
      return PieChartSectionData(
        color: color,
        value: entry.value,
        title: '${percentage.toStringAsFixed(1)}%',
        radius: 30, // Donut thickness
        titleStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();
  }

  Widget _buildLegend(Map<String, double> data) {
    List<Color> colors = [
      AppColors.primary,
      AppColors.secondary,
      AppColors.tertiary,
      Colors.orangeAccent,
      Colors.pinkAccent,
      Colors.blueAccent,
    ];

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: data.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final entry = data.entries.elementAt(index);
        final color = colors[index % colors.length];

        return Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 12),
            Text(
              entry.key,
              style: GoogleFonts.inter(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Spacer(),
            Text(
              '\$${entry.value.toStringAsFixed(2)}',
              style: GoogleFonts.manrope(
                color: AppColors.onSurface,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        );
      },
    );
  }
}
