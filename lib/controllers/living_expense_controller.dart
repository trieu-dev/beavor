import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/living_expense_model.dart';
import '../core/services/hive_service.dart';

class LivingExpenseController extends GetxController {
  late Box<LivingExpenseModel> _livingExpenseBox;

  var livingExpenses = <LivingExpenseModel>[].obs;
  var currentExpense = Rxn<LivingExpenseModel>();

  @override
  void onInit() {
    super.onInit();
    _initBox();
  }

  Future<void> _initBox() async {
    _livingExpenseBox = Hive.box<LivingExpenseModel>(
      HiveService.livingExpensesBoxName,
    );
    loadExpenses();

    // Initialize current expense for this month if not exists
    final now = DateTime.now();
    final thisMonthExp = livingExpenses.firstWhereOrNull(
      (e) => e.month.year == now.year && e.month.month == now.month,
    );

    if (thisMonthExp != null) {
      currentExpense.value = thisMonthExp;
    } else {
      // Create a default one for current month
      final newExp = LivingExpenseModel(
        id: const Uuid().v4(),
        month: DateTime(now.year, now.month),
        rent: 0.0,
        electricityPrevious: 0.0,
        electricityCurrent: 0.0,
        water: 0.0,
        serviceFee: 0.0,
        food: 0,
        transport: 0,
        customExpenses: [],
      );
      currentExpense.value = newExp;
    }
  }

  void loadExpenses() {
    livingExpenses.assignAll(
      _livingExpenseBox.values.toList()
        ..sort((a, b) => b.month.compareTo(a.month)),
    );
  }

  Future<void> saveCurrentExpense() async {
    if (currentExpense.value != null) {
      await _livingExpenseBox.put(
        currentExpense.value!.id,
        currentExpense.value!,
      );
      loadExpenses();
    }
  }

  void _updateCurrent(LivingExpenseModel Function(LivingExpenseModel) updater) {
    if (currentExpense.value != null) {
      currentExpense.value = updater(currentExpense.value!);
      currentExpense.refresh();
    }
  }

  void updateRent(double value) {
    _updateCurrent((e) => e..rent = value);
  }

  void updateElectricity(double prev, double curr) {
    _updateCurrent(
      (e) => e
        ..electricityPrevious = prev
        ..electricityCurrent = curr,
    );
  }

  void updateWater(double value) {
    _updateCurrent((e) => e..water = value);
  }

  void updateServiceFee(double value) {
    _updateCurrent((e) => e..serviceFee = value);
  }

  void updateFood(double value) {
    _updateCurrent((e) => e..food = value);
  }

  void updateTransport(double value) {
    _updateCurrent((e) => e..transport = value);
  }

  // --- Custom Expenses ---

  void addCustomExpense() {
    _updateCurrent((e) {
      final newItem = CustomExpenseItem(
        id: const Uuid().v4(),
        name: 'Chi phí mới',
        amount: 0.0,
      );
      // Ensure we have a mutable list
      final newList = List<CustomExpenseItem>.from(e.customExpenses);
      newList.add(newItem);
      return e..customExpenses = newList;
    });
  }

  void updateCustomExpense(int index, {String? name, double? amount}) {
    _updateCurrent((e) {
      final newList = List<CustomExpenseItem>.from(e.customExpenses);
      if (index >= 0 && index < newList.length) {
        if (name != null) newList[index].name = name;
        if (amount != null) newList[index].amount = amount;
      }
      return e..customExpenses = newList;
    });
  }

  void removeCustomExpense(int index) {
    _updateCurrent((e) {
      final newList = List<CustomExpenseItem>.from(e.customExpenses);
      if (index >= 0 && index < newList.length) {
        newList.removeAt(index);
      }
      return e..customExpenses = newList;
    });
  }
}
