import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction_model.dart';

class AddTransactionScreen extends StatefulWidget {
  const AddTransactionScreen({super.key});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TransactionController controller = Get.find<TransactionController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _categoryController = TextEditingController();

  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now();

  // A simple UUID generator mock since we didn't add uuid package to pubspec yet,
  // wait we didn't. Let's just use a timestamp for ID to save time.
  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    _categoryController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final double amount = double.tryParse(_amountController.text) ?? 0.0;

      final transaction = TransactionModel(
        id: generateId(),
        title: _titleController.text,
        amount: amount,
        date: _selectedDate,
        isIncome: _isIncome,
        category: _categoryController.text.isEmpty
            ? 'General'
            : _categoryController.text,
      );

      controller.addTransaction(transaction);
      Get.back();
      // Show snackbar
      Get.snackbar(
        'success'.tr,
        'add_tx_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surfaceContainerHigh,
        colorText: AppColors.onSurface,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('add_tx_title'.tr)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildTypeToggle(),
              const SizedBox(height: 32),

              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'form_title'.tr,
                  prefixIcon: const Icon(Icons.title),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) return 'form_error_title'.tr;
                  return null;
                },
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _amountController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: InputDecoration(
                  labelText: '${'form_amount'.tr} (\$)',
                  prefixIcon: const Icon(Icons.attach_money),
                ),
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return 'form_error_amount'.tr;
                  }
                  if (double.tryParse(val) == null) {
                    return 'form_error_format'.tr;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _categoryController,
                decoration: InputDecoration(
                  labelText: 'form_category'.tr,
                  prefixIcon: const Icon(Icons.category_outlined),
                ),
              ),
              const SizedBox(height: 24),

              GestureDetector(
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                  );
                  if (picked != null) {
                    setState(() {
                      _selectedDate = picked;
                    });
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 16,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.15),
                      width: 0.5,
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 16),
                      Text(
                        '${_selectedDate.toLocal()}'.split(' ')[0],
                        style: GoogleFonts.inter(
                          color: AppColors.onSurface,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 48),

              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: AppColors.primaryGradient,
                ),
                child: ElevatedButton(
                  onPressed: _submit,
                  child: Text('add_tx_save'.tr),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeToggle() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(30),
      ),
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isIncome = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: !_isIncome
                      ? AppColors.tertiary.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'add_tx_expense'.tr,
                    style: GoogleFonts.inter(
                      color: !_isIncome
                          ? AppColors.tertiary
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () => setState(() => _isIncome = true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  color: _isIncome
                      ? AppColors.secondary.withValues(alpha: 0.2)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Text(
                    'add_tx_income'.tr,
                    style: GoogleFonts.inter(
                      color: _isIncome
                          ? AppColors.secondary
                          : AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
