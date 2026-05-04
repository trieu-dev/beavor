import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../../controllers/living_expense_controller.dart';
import '../../controllers/transaction_controller.dart';
import '../../models/transaction_model.dart';

class ShareSummaryScreen extends StatefulWidget {
  const ShareSummaryScreen({super.key});

  @override
  State<ShareSummaryScreen> createState() => _ShareSummaryScreenState();
}

class _ShareSummaryScreenState extends State<ShareSummaryScreen> {
  final GlobalKey _boundaryKey = GlobalKey();
  final LivingExpenseController controller =
      Get.find<LivingExpenseController>();
  bool _isCapturing = false;

  Future<void> _captureAndShare() async {
    setState(() => _isCapturing = true);
    try {
      await Future.delayed(const Duration(milliseconds: 100));

      final RenderRepaintBoundary? boundary =
          _boundaryKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary?;

      if (boundary == null) return;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData = await image.toByteData(
        format: ui.ImageByteFormat.png,
      );

      if (byteData != null) {
        final Uint8List pngBytes = byteData.buffer.asUint8List();
        final directory = await getTemporaryDirectory();
        final imagePath =
            '${directory.path}/living_summary_${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = File(imagePath);
        await imageFile.writeAsBytes(pngBytes);

        await SharePlus.instance.share(ShareParams(files: [XFile(imagePath)]));

        await _saveAsTransaction();
      }
    } catch (e) {
      Get.printError(info: 'Error capturing and sharing: $e');
      Get.snackbar(
        'error'.tr,
        'Error sharing summary',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      setState(() => _isCapturing = false);
    }
  }

  Future<void> _saveAsTransaction() async {
    try {
      final transactionController = Get.find<TransactionController>();
      final exp = controller.currentExpense.value;
      if (exp == null) return;

      final total = exp.calculateTotal();
      final now = DateTime.now();
      final monthYear = DateFormat('MM/yyyy').format(now);

      final category = transactionController.categories.firstWhereOrNull(
        (c) => c.name == 'Nhà cửa',
      );

      final wallet =
          transactionController.wallets.firstWhereOrNull(
            (w) => w.name == 'Ví chính',
          ) ??
          transactionController.wallets.firstOrNull;

      if (category == null || wallet == null) {
        Get.printError(info: 'Category or Wallet not found for auto-saving');
        return;
      }

      final transaction = TransactionModel(
        id: const Uuid().v4(),
        title: 'Tiền nhà - $monthYear',
        amount: total,
        date: now,
        isIncome: false,
        categoryId: category.id,
        walletId: wallet.id,
        note: 'Auto-generated from Living Expense Export',
      );

      await transactionController.addTransaction(transaction);

      Get.snackbar(
        'success'.tr,
        'living_tx_save_success'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF10B981).withValues(alpha: 0.1),
        colorText: Colors.white,
      );
    } catch (e) {
      Get.printError(info: 'Error auto-saving transaction: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101B),
      appBar: AppBar(
        title: Text('living_summary_preview'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: RepaintBoundary(
                key: _boundaryKey,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0B101B),
                    borderRadius: BorderRadius.circular(32),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.05),
                      width: 1,
                    ),
                  ),
                  child: Obx(() {
                    final exp = controller.currentExpense.value;
                    if (exp == null) return const SizedBox();

                    final total = exp.calculateTotal();
                    final customExpenses = exp.customExpenses;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'living_total_label'.tr.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${NumberFormat('#,###', 'vi_VN').format(total)} ₫',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        const Divider(color: Colors.white12),
                        const SizedBox(height: 20),
                        _buildSummaryItem(
                          'living_elec'.tr,
                          '(${NumberFormat('#,###').format(exp.electricityCurrent)} - ${NumberFormat('#,###').format(exp.electricityPrevious)}) x 3,500',
                          exp.calculateElectricityCost(),
                          Icons.flash_on_rounded,
                          iconColor: const Color(0xFF00E676),
                        ),
                        ...customExpenses.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: _buildSummaryItem(
                              item.name,
                              "",
                              item.amount,
                              Icons.label_rounded,
                            ),
                          );
                        }),
                      ],
                    );
                  }),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: SizedBox(
              width: double.infinity,
              height: 60,
              child: ElevatedButton(
                onPressed: _isCapturing ? null : _captureAndShare,
                child: _isCapturing
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text('living_confirm_share'.tr),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(
    String title,
    String subtitle,
    double amount,
    IconData icon, {
    Color iconColor = const Color(0xFF9489FE),
  }) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF161C2C),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Icon(icon, color: iconColor, size: 24),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.white38, fontSize: 12),
                ),
            ],
          ),
        ),
        Text(
          '${NumberFormat('#,###').format(amount)} ₫',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
