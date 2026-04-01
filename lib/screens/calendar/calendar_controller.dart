import 'package:get/get.dart';
import '../../models/transaction_model.dart';

class CalendarController extends GetxController {
  final Rx<DateTime> focusedDay = DateTime.now().obs;
  final Rx<DateTime?> selectedDay = DateTime.now().obs;
  
  // Mock data for transactions
  final RxList<TransactionModel> dailyTransactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
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
    // Mocking transaction fetch based on date
    final mockData = [
      TransactionModel(
        id: '1',
        title: 'Coffee',
        amount: 4.50,
        date: date,
        category: 'Food',
        isIncome: false,
      ),
      TransactionModel(
        id: '2',
        title: 'Salary Deposit',
        amount: 2500.00,
        date: date,
        category: 'Income',
        isIncome: true,
      ),
      if (date.day % 2 == 0)
        TransactionModel(
          id: '3',
          title: 'Internet Bill',
          amount: 60.00,
          date: date,
          category: 'Bills',
          isIncome: false,
        ),
    ];
    
    dailyTransactions.value = mockData;
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
