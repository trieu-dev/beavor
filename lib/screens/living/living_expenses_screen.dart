import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/living_expense_controller.dart';
import '../../core/theme/app_colors.dart';

class LivingExpensesScreen extends GetView<LivingExpenseController> {
  const LivingExpensesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101B),
      appBar: _buildAppBar(),
      body: Obx(() {
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
              _buildStatsFooter(exp, total),
              const SizedBox(height: 24),
              _buildSaveButton(),
              const SizedBox(height: 40),
            ],
          ),
        );
      }),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu_rounded, color: Colors.white),
        onPressed: () {},
      ),
      centerTitle: true,
      title: const Text(
        'Monthly Ledger',
        style: TextStyle(
          color: Color(0xFF9489FE),
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 16),
          child: CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.primary.withValues(alpha: 0.2),
            child: const Icon(
              Icons.person_outline,
              color: Colors.white,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(double total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFF161C2C),
        borderRadius: BorderRadius.circular(40),
      ),
      child: Column(
        children: [
          const Text(
            'TỔNG DỰ TOÁN THÁNG',
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
          const SizedBox(height: 16),
          _buildTrendChip(),
        ],
      ),
    );
  }

  Widget _buildTrendChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1A2135),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.trending_up, color: Color(0xFF00E676), size: 16),
          SizedBox(width: 4),
          Text(
            '+3.1% so với tháng trước',
            style: TextStyle(
              color: Color(0xFF00E676),
              fontSize: 12,
              fontWeight: FontWeight.bold,
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
        const Text(
          'Danh mục chi tiêu',
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
        child: const Row(
          children: [
            Icon(Icons.add_circle, color: Color(0xFF9489FE), size: 18),
            SizedBox(width: 4),
            Text(
              'Thêm mới',
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
                  decoration: const InputDecoration(
                    hintText: 'Chi phí mới',
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 13),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
                  decoration: const InputDecoration(
                    hintText: 'Nhập số tiền',
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 18),
                    suffixText: '₫',
                    suffixStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
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
            onPressed: () => controller.updateCustomExpense(index, amount: 0),
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
                    const Text(
                      'Tiền điện',
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
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF00E676,
                            ).withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'EVN + 10% VAT',
                            style: TextStyle(
                              color: Color(0xFF00E676),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
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
                  label: 'Chỉ số cũ',
                  value: exp.electricityPrevious,
                  onChanged: (v) => controller.updateElectricity(
                    _parseDouble(v),
                    exp.electricityCurrent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              const Icon(Icons.link_rounded, color: Colors.white12),
              const SizedBox(width: 12),
              Expanded(
                child: _buildInlineInput(
                  label: 'Chỉ số mới',
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
              const Text(
                'Hệ số (đ/kWh): 3.000',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
              Text(
                'Tiêu thụ: ${exp.electricityConsumed.toInt()} kWh',
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
              contentPadding: EdgeInsets.zero,
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

  Widget _buildStatsFooter(dynamic exp, double total) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Số mục đã nhập',
              style: TextStyle(color: Colors.white54, fontSize: 14),
            ),
            Text(
              '${exp.getFilledCount().toString().padLeft(2, '0')}/13',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Tổng cộng',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  '${NumberFormat('#,###').format(total)} ₫',
                  style: const TextStyle(
                    color: Color(0xFF00E676),
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'dự kiến chi tiêu',
                  style: TextStyle(color: Colors.white38, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
      ],
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
        child: const Text(
          'Lưu dự toán',
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
