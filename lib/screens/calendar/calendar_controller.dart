import 'package:get/get.dart';
import '../../models/transaction_model.dart';
import '../../controllers/transaction_controller.dart';

class CalendarController extends GetxController {
  final TransactionController transactionController = Get.find<TransactionController>();

  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = DateTime.now().obs;
  
  // Real transactions from the main controller
  final RxList<TransactionModel> dailyTransactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Listen to changes in the main transactions list
    ever(transactionController.transactions, (_) => _fetchTransactionsForDay(selectedDay.value ?? DateTime.now()));
    _fetchTransactionsForDay(DateTime.now());
  }

  void onDaySelected(DateTime selected, DateTime focused) {
    if (!isSameDay(selectedDay.value, selected)) {
      selectedDay.value = selected;
      focusedDay.value = focused;
      _fetchTransactionsForDay(selected);
    }
  }

  void _fetchTransactionsForDay(DateTime date) {
    final dayTransactions = transactionController.transactions.where((t) => isSameDay(t.date, date)).toList();
    dailyTransactions.assignAll(dayTransactions);
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
  
  double get dailyIncome => dailyTransactions
      .where((t) => t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);

  double get dailyExpense => dailyTransactions
      .where((t) => !t.isIncome)
      .fold(0, (sum, t) => sum + t.amount);
}
