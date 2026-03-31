import 'package:get/get.dart';
import '../models/transaction_model.dart';

class TransactionController extends GetxController {
  // Observable list of transactions
  var transactions = <TransactionModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void _loadDummyData() {
    transactions.assignAll([
      TransactionModel(
        id: '1',
        title: 'Salary Deposit',
        amount: 5200.0,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isIncome: true,
        category: 'Income',
      ),
      TransactionModel(
        id: '2',
        title: 'Whole Foods Market',
        amount: 145.50,
        date: DateTime.now().subtract(const Duration(days: 1)),
        isIncome: false,
        category: 'Groceries',
      ),
      TransactionModel(
        id: '3',
        title: 'Netflix Subscription',
        amount: 15.99,
        date: DateTime.now().subtract(const Duration(days: 2)),
        isIncome: false,
        category: 'Entertainment',
      ),
      TransactionModel(
        id: '4',
        title: 'Freelance Design Work',
        amount: 850.0,
        date: DateTime.now().subtract(const Duration(days: 3)),
        isIncome: true,
        category: 'Income',
      ),
      TransactionModel(
        id: '5',
        title: 'Uber Ride',
        amount: 24.0,
        date: DateTime.now().subtract(const Duration(days: 3)),
        isIncome: false,
        category: 'Transport',
      ),
    ]);
  }

  // Computed property: Total Balance
  double get totalBalance {
    return transactions.fold(0.0, (sum, item) {
      if (item.isIncome) {
        return sum + item.amount;
      } else {
        return sum - item.amount;
      }
    });
  }

  // Computed property: Total Income
  double get totalIncome {
    return transactions
        .where((t) => t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  // Computed property: Total Expenses
  double get totalExpense {
    return transactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  void addTransaction(TransactionModel transaction) {
    transactions.add(transaction);
    // Sort logic could go here, e.g., by date descending
    transactions.sort((a, b) => b.date.compareTo(a.date));
  }
}
