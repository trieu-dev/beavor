import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import '../models/living_expense_model.dart';
import '../core/services/supabase_service.dart';

class LivingExpenseController extends GetxController {
  final _client = SupabaseService().supabase;

  var livingExpenses = <LivingExpenseModel>[].obs;
  var currentExpense = Rxn<LivingExpenseModel>();
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadExpenses();
  }

  Future<void> loadExpenses() async {
    isLoading.value = true;
    try {
      // 1. Fetch Living Expenses
      final expenseData = await _client
          .from('living_expenses')
          .select()
          .order('month', ascending: false);

      List<LivingExpenseModel> loadedExpenses = [];

      for (var map in expenseData) {
        // 2. Fetch Custom Items for each expense
        final customItemData = await _client
            .from('custom_expense_items')
            .select()
            .eq('living_expense_id', map['id']);

        final customItems = customItemData
            .map((e) => CustomExpenseItem.fromMap(e))
            .toList();

        loadedExpenses.add(
          LivingExpenseModel.fromMap(map, customExpenses: customItems),
        );
      }

      livingExpenses.assignAll(loadedExpenses);

      // Initialize current expense for this month if not exists in the loaded list
      final now = DateTime.now();
      final thisMonthExp = livingExpenses.firstWhereOrNull(
        (e) => e.month.year == now.year && e.month.month == now.month,
      );

      if (thisMonthExp != null) {
        currentExpense.value = thisMonthExp;
      } else if (currentExpense.value == null) {
        // Only create new if it's not already set
        currentExpense.value = LivingExpenseModel(
          id: const Uuid().v4(),
          month: DateTime(now.year, now.month),
        );
      }
    } catch (e) {
      Get.printError(info: 'Error loading expenses: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveCurrentExpense() async {
    if (currentExpense.value != null) {
      try {
        final expense = currentExpense.value!;

        // 1. Upsert Living Expense
        await _client.from('living_expenses').upsert(expense.toMap());

        // 2. Handle Custom Expenses
        // Delete old items first (simplest way to handle updates/removals)
        await _client
            .from('custom_expense_items')
            .delete()
            .eq('living_expense_id', expense.id);

        // Insert new items
        if (expense.customExpenses.isNotEmpty) {
          final itemsToInsert = expense.customExpenses.map((item) {
            item.livingExpenseId = expense.id;
            return item.toMap();
          }).toList();
          await _client.from('custom_expense_items').insert(itemsToInsert);
        }

        await loadExpenses();

        Get.snackbar(
          'success'.tr,
          'living_save_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF00E676).withValues(alpha: 0.1),
          colorText: const Color(0xFF00E676),
          icon: const Icon(
            Icons.check_circle_outline,
            color: Color(0xFF00E676),
          ),
          margin: const EdgeInsets.all(20),
          duration: const Duration(seconds: 2),
        );
      } catch (e) {
        Get.snackbar(
          'error'.tr,
          'living_save_error'.trParams({'error': e.toString()}),
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent.withValues(alpha: 0.1),
          colorText: Colors.redAccent,
          icon: const Icon(Icons.error_outline, color: Colors.redAccent),
          margin: const EdgeInsets.all(20),
        );
      }
    }
  }


  void _updateCurrent(LivingExpenseModel Function(LivingExpenseModel) updater) {
    if (currentExpense.value != null) {
      currentExpense.value = updater(currentExpense.value!);
      currentExpense.refresh();
    }
  }

  void updateRent(double value) => _updateCurrent((e) => e..rent = value);
  void updateElectricity(double prev, double curr) => _updateCurrent(
    (e) => e
      ..electricityPrevious = prev
      ..electricityCurrent = curr,
  );
  void swapElectricityValues() => _updateCurrent((e) {
    final temp = e.electricityPrevious;
    e.electricityPrevious = e.electricityCurrent;
    e.electricityCurrent = temp;
    return e;
  });
  void updateWater(double value) => _updateCurrent((e) => e..water = value);
  void updateServiceFee(double value) =>
      _updateCurrent((e) => e..serviceFee = value);
  void updateFood(double value) => _updateCurrent((e) => e..food = value);
  void updateTransport(double value) =>
      _updateCurrent((e) => e..transport = value);

  void addCustomExpense() {
    _updateCurrent((e) {
      final newItem = CustomExpenseItem(
        id: const Uuid().v4(),
        name: '',
        amount: 0.0,
      );
      final newList = List<CustomExpenseItem>.from(e.customExpenses);
      newList.add(newItem);
      e.customExpenses = newList;
      return e;
    });
  }

  void updateCustomExpense(int index, {String? name, double? amount}) {
    _updateCurrent((e) {
      final newList = List<CustomExpenseItem>.from(e.customExpenses);
      if (index >= 0 && index < newList.length) {
        if (name != null) newList[index].name = name;
        if (amount != null) newList[index].amount = amount;
      }
      e.customExpenses = newList;
      return e;
    });
  }

  void removeCustomExpense(int index) {
    _updateCurrent((e) {
      final newList = List<CustomExpenseItem>.from(e.customExpenses);
      if (index >= 0 && index < newList.length) {
        newList.removeAt(index);
      }
      e.customExpenses = newList;
      return e;
    });
  }
}
