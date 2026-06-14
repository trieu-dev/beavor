import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/living_expense_controller.dart';
import 'share_summary_screen.dart';

class LivingExpensesScreen extends GetView<LivingExpenseController> {
  const LivingExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101B),
      appBar: _buildAppBar(),
      body: Container(
        color: const Color(0xFF0B101B),
        child: Obx(() {
          if (controller.currentExpense.value == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final exp = controller.currentExpense.value!;
          final total = exp.calculateTotal();

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSummaryCard(total),
                const SizedBox(height: 32),
                _buildSectionHeader(),
                const SizedBox(height: 16),
                _buildExpenseList(exp),
                const SizedBox(height: 32),
                _buildSaveButton(),
                const SizedBox(height: 120),
              ],
            ),
          );
        }),
      ),
  );
}

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      title: Text(
        'living_monthly_ledger'.tr,
        style: const TextStyle(
          color: Color(0xFF9489FE),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () => Get.to(() => const ShareSummaryScreen()),
          icon: const Icon(Icons.ios_share_rounded, color: Color(0xFF9489FE)),
          tooltip: 'living_export'.tr,
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSummaryCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF161C2C),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          Text(
            'living_total_label'.tr,
            style: TextStyle(
              color: Colors.white54,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 12),
          FittedBox(
            child: Text(
              '${NumberFormat('#,###', 'vi_VN').format(total)} ₫',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 42,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'living_categories_header'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
        _buildAddNewButton(),
      ],
    );
  }

  Widget _buildAddNewButton() {
    return GestureDetector(
      onTap: () => controller.addCustomExpense(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFF9489FE).withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF9489FE).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Icon(Icons.add_circle, color: Color(0xFF9489FE), size: 18),
            SizedBox(width: 4),
            Text(
              'living_add_new'.tr,
              style: TextStyle(
                color: Color(0xFF9489FE),
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpenseList(dynamic exp) {
    return Column(
      children: [
        _buildElectricityItem(exp),
        // Custom Expenses
        ...exp.customExpenses.asMap().entries.map((entry) {
          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: _buildEditableItem(entry.key, entry.value),
          );
        }),
      ],
    );
  }

  Widget _buildEditableItem(int index, dynamic item) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161C2C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF9489FE).withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2D2F41),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.label_rounded,
              color: Color(0xFF9489FE),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                  decoration: InputDecoration(
                    hintText: 'living_new_exp_hint'.tr,
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(left: 8, right: 8),
                  ),
                  controller: TextEditingController(text: item.name)
                    ..selection = TextSelection.fromPosition(
                      TextPosition(offset: item.name.length),
                    ),
                  onChanged: (v) =>
                      controller.updateCustomExpense(index, name: v),
                ),
                const SizedBox(height: 4),
                TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'living_amount_hint'.tr,
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 18),
                    suffixText: '₫',
                    suffixStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.only(left: 8, right: 8),
                  ),
                  controller:
                      TextEditingController(
                          text: item.amount == 0
                              ? ''
                              : NumberFormat('#,###').format(item.amount),
                        )
                        ..selection = TextSelection.fromPosition(
                          TextPosition(
                            offset:
                                (item.amount == 0
                                        ? ''
                                        : NumberFormat(
                                            '#,###',
                                          ).format(item.amount))
                                    .length,
                          ),
                        ),
                  onChanged: (v) => controller.updateCustomExpense(
                    index,
                    amount: _parseDouble(v),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.delete_outline_rounded,
              color: Colors.redAccent,
              size: 20,
            ),
            onPressed: () => controller.removeCustomExpense(index),
          ),
        ],
      ),
    );
  }

  Widget _buildElectricityItem(dynamic exp) {
    final elecCost = exp.calculateElectricityCost();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF161C2C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFF00E676).withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF2D2F41),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.flash_on_rounded,
                  color: Color(0xFF00E676),
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'living_elec'.tr,
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          elecCost == 0
                              ? '0 ₫'
                              : '${NumberFormat('#,###').format(elecCost)} ₫',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInlineInput(
                  label: 'living_prev'.tr,
                  value: exp.electricityPrevious,
                  onChanged: (v) => controller.updateElectricity(
                    _parseDouble(v),
                    exp.electricityCurrent,
                  ),
                ),
              ),
              const SizedBox(width: 4),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                onPressed: () => controller.swapElectricityValues(),
                icon: Icon(
                  Icons.swap_horiz_rounded,
                  color: Colors.white.withValues(alpha: 0.2),
                  size: 20,
                ),
                tooltip: 'living_swap'.tr,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: _buildInlineInput(
                  label: 'living_curr'.tr,
                  value: exp.electricityCurrent,
                  onChanged: (v) => controller.updateElectricity(
                    exp.electricityPrevious,
                    _parseDouble(v),
                  ),
                  activeColor: const Color(0xFF00E676),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'living_factor_label'.tr,
                style: const TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                'living_consumed_label'.trParams({
                  'count': exp.electricityConsumed.toInt().toString(),
                }),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInlineInput({
    required String label,
    required double value,
    required Function(String) onChanged,
    Color? activeColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F1424),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.white38, fontSize: 10),
          ),
          const SizedBox(height: 4),
          TextField(
            keyboardType: TextInputType.number,
            style: TextStyle(
              color: activeColor ?? Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
            decoration: const InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 8),
              hintText: '0',
              hintStyle: TextStyle(color: Colors.white12),
            ),
            controller:
                TextEditingController(
                    text: value == 0 ? '' : value.toInt().toString(),
                  )
                  ..selection = TextSelection.fromPosition(
                    TextPosition(
                      offset:
                          (value == 0 ? '' : value.toInt().toString()).length,
                    ),
                  ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton() {
    return Container(
      width: double.infinity,
      height: 64,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          colors: [Color(0xFF9489FE), Color(0xFF7B66FF)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF9489FE).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: () => controller.saveCurrentExpense(),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        child: Text(
          'living_save_estimate'.tr,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  double _parseDouble(String v) {
    if (v.isEmpty) return 0.0;
    return double.tryParse(v.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }
}
