import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

import '../../core/theme/app_colors.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction_model.dart';
import '../../core/utils/icon_mapper.dart';
import '../add_category/add_category_screen.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionModel? initialTransaction;
  const AddTransactionScreen({super.key, this.initialTransaction});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final TransactionController controller = Get.find<TransactionController>();
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();

  bool _isIncome = false;
  DateTime _selectedDate = DateTime.now();
  String? _selectedCategoryId;
  String? _selectedWalletId;
  double? _amount;

  bool get _isEditing => widget.initialTransaction != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final tx = widget.initialTransaction!;
      _titleController.text = tx.title;
      _amountController.text = tx.amount.toInt().toString();
      _isIncome = tx.isIncome;
      _selectedDate = tx.date;
      _selectedCategoryId = tx.categoryId;
      _selectedWalletId = tx.walletId;
    } else {
      // Default selections for new transaction
      _setDefaultSelections();

      // Listen for data loading if it was empty initially
      controller.categories.listen((_) {
        if (mounted && _selectedCategoryId == null) {
          setState(() {
            _setDefaultSelections();
          });
        }
      });

      controller.wallets.listen((_) {
        if (mounted && _selectedWalletId == null) {
          setState(() {
            _setDefaultSelections();
          });
        }
      });
    }
  }

  void _setDefaultSelections() {
    if (controller.categories.isNotEmpty && _selectedCategoryId == null) {
      final matched = controller.categories
          .where((c) => c.isIncome == _isIncome)
          .toList();
      if (matched.isNotEmpty) {
        _selectedCategoryId = matched.first.id;
      } else {
        _selectedCategoryId = controller.categories.first.id;
      }
    }
    if (controller.wallets.isNotEmpty && _selectedWalletId == null) {
      _selectedWalletId = controller.wallets.first.id;
    }
  }

  String generateId() {
    return const Uuid().v4();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (_selectedCategoryId == null || _selectedWalletId == null) {
        Get.snackbar(
          'Error',
          'Please select a category and a wallet',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      final double amount = double.tryParse(_amountController.text) ?? 0.0;

      final transaction = TransactionModel(
        id: _isEditing ? widget.initialTransaction!.id : generateId(),
        title: _titleController.text,
        amount: amount,
        date: _selectedDate,
        isIncome: _isIncome,
        categoryId: _selectedCategoryId!,
        walletId: _selectedWalletId!,
        note: '',
      );

      if (_isEditing) {
        controller.updateTransaction(widget.initialTransaction!, transaction);
      } else {
        controller.addTransaction(transaction);
      }

      Get.back();

      Get.snackbar(
        'success'.tr,
        _isEditing ? 'update_tx_success'.tr : 'add_tx_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColors.surfaceContainerHigh.withValues(alpha: 0.8),
        colorText: AppColors.onSurface,
        margin: const EdgeInsets.all(16),
        borderRadius: 16,
      );
    }
  }

  void _onDelete() {
    Get.dialog(
      AlertDialog(
        backgroundColor: AppColors.surfaceContainerHigh,
        title: Text(
          'delete_tx_confirm'.tr,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        content: Text('delete_tx_desc'.tr, style: GoogleFonts.inter()),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('cancel'.tr)),
          TextButton(
            onPressed: () {
              controller.deleteTransaction(widget.initialTransaction!);
              Get.back(); // Back from dialog
              Get.back(); // Back from Edit Screen
              Get.snackbar('deleted'.tr, 'transaction_deleted'.tr);
            },
            child: Text(
              'delete'.tr,
              style: const TextStyle(color: AppColors.tertiary),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          _isEditing ? 'edit_tx_title'.tr : 'add_tx_title'.tr,
          style: GoogleFonts.manrope(fontWeight: FontWeight.w700),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.tertiary,
              ),
              onPressed: _onDelete,
            ),
          const SizedBox(width: 8),
        ],
      ),
      body: Stack(
        children: [
          // Background Glows
          Positioned(
            top: -100,
            right: -50,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 80, sigmaY: 80),
                child: Container(color: Colors.transparent),
              ),
            ),
          ),

          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              physics: const BouncingScrollPhysics(),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildGlassInput(
                      controller: _titleController,
                      label: 'form_title'.tr,
                      icon: Icons.title_rounded,
                      validator: (val) => (val == null || val.isEmpty)
                          ? 'form_error_title'.tr
                          : null,
                    ),
                    const SizedBox(height: 20),

                    _buildGlassInput(
                      controller:
                          TextEditingController(
                              text: (_amount == 0 || _amount == null)
                                  ? ''
                                  : NumberFormat('#,###').format(_amount),
                            )
                            ..selection = TextSelection.fromPosition(
                              TextPosition(
                                offset:
                                    ((_amount == 0 || _amount == null)
                                            ? ''
                                            : NumberFormat(
                                                '#,###',
                                              ).format(_amount))
                                        .length,
                              ),
                            ),
                      label: '${'form_amount'.tr} (₫)',
                      icon: Icons.payments_rounded,
                      keyboardType: TextInputType.number,
                      validator: (val) {
                        if (val == null || val.isEmpty) {
                          return 'form_error_amount'.tr;
                        }
                        if (double.tryParse(val) == null) {
                          return 'form_error_format'.tr;
                        }
                        return null;
                      },
                      onChanged: (v) {
                        final valueDoub = _parseDouble(v);
                        setState(() {
                          _amount = valueDoub;
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    _buildSectionLabel('form_category'.tr),
                    const SizedBox(height: 12),
                    _buildCategoryPicker(),
                    const SizedBox(height: 24),

                    _buildDatePickerTile(),

                    const SizedBox(height: 48),

                    _buildSubmitButton(),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
        ),
      ),
    );
  }

  Widget _buildGlassInput({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Function(String)? onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel(label),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLow.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: TextFormField(
                controller: controller,
                keyboardType: keyboardType,
                validator: validator,
                style: GoogleFonts.inter(
                  color: AppColors.onSurface,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  prefixIcon: Icon(
                    icon,
                    color: AppColors.primary.withValues(alpha: 0.7),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 18,
                  ),
                  errorStyle: const TextStyle(height: 0),
                ),
                onChanged: onChanged,
              ),
            ),
          ),
        ),
      ],
    );
  }

  double _parseDouble(String v) {
    if (v.isEmpty) return 0.0;
    return double.tryParse(v.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  }

  Widget _buildCategoryPicker() {
    return Obx(() {
      final filteredCategories = controller.categories
          .where((c) => c.isIncome == _isIncome)
          .toList();

      // +1 for the "Add New" button at the end
      final itemCount = filteredCategories.length + 1;

      return SizedBox(
        height: 100,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: itemCount,
          separatorBuilder: (context, index) => const SizedBox(width: 12),
          itemBuilder: (context, index) {
            // Last item is the "Add New" button
            if (index == filteredCategories.length) {
              return _buildAddCategoryButton();
            }

            final cat = filteredCategories[index];
            final isSelected = _selectedCategoryId == cat.id;

            return GestureDetector(
              onTap: () => setState(() => _selectedCategoryId = cat.id),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 80,
                decoration: BoxDecoration(
                  color: isSelected
                      ? Color(cat.colorValue).withValues(alpha: 0.2)
                      : AppColors.surfaceContainerLow.withValues(alpha: 0.4),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? Color(cat.colorValue)
                        : Colors.white.withValues(alpha: 0.05),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      IconMapper.getIconData(cat.icon),
                      color: isSelected
                          ? Color(cat.colorValue)
                          : AppColors.onSurfaceVariant,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      cat.name.tr,
                      style: GoogleFonts.inter(
                        fontSize: 11,
                        fontWeight: isSelected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.onSurface
                            : AppColors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildAddCategoryButton() {
    return GestureDetector(
      onTap: () async {
        await Get.to(() => const AddCategoryScreen());
        // Reload categories when returning from AddCategoryScreen
        setState(() {
          controller.loadData();
        });
      },
      child: Container(
        width: 80,
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerHigh.withValues(alpha: 0.5),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
            width: 1.5,
            strokeAlign: BorderSide.strokeAlignInside,
          ),
        ),
        child: CustomPaint(
          painter: _DashedBorderPainter(
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.3),
            borderRadius: 20,
            strokeWidth: 1.5,
            dashWidth: 6,
            dashSpace: 4,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.add_rounded,
                color: AppColors.onSurfaceVariant,
                size: 24,
              ),
              const SizedBox(height: 6),
              Text(
                'add_cat_short'.tr,
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: AppColors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatePickerTile() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('form_date'.tr),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final picked = await showDatePicker(
              context: context,
              initialDate: _selectedDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (picked != null) setState(() => _selectedDate = picked);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLow.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_rounded,
                  color: AppColors.primary.withValues(alpha: 0.7),
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('dd/MM/yyyy').format(_selectedDate),
                  style: GoogleFonts.inter(
                    color: AppColors.onSurface,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return Container(
      height: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: AppColors.primaryGradient,
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: _submit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        child: Text(
          'add_tx_save'.tr,
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double borderRadius;
  final double strokeWidth;
  final double dashWidth;
  final double dashSpace;

  _DashedBorderPainter({
    required this.color,
    required this.borderRadius,
    required this.strokeWidth,
    required this.dashWidth,
    required this.dashSpace,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(borderRadius),
        ),
      );

    // Create dashed path
    final dashPath = Path();
    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final end = (distance + dashWidth).clamp(0, metric.length);
        dashPath.addPath(
          metric.extractPath(distance, end.toDouble()),
          Offset.zero,
        );
        distance += dashWidth + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedBorderPainter oldDelegate) =>
      color != oldDelegate.color ||
      borderRadius != oldDelegate.borderRadius ||
      strokeWidth != oldDelegate.strokeWidth;
}
