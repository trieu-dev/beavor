import 'package:get/get.dart';
import '../models/transaction_model.dart';

class TransactionController extends GetxController {
  // Observable list of transactions
  var transactions = <TransactionModel>[].obs;
  
  // Selected Timeframe for Analysis
  var selectedTimeframe = 'Weekly'.obs;

  @override
  void onInit() {
    super.onInit();
    _loadDummyData();
  }

  void setTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
  }

  void _loadDummyData() {
    final now = DateTime.now();
    transactions.assignAll([
      TransactionModel(
        id: '1',
        title: 'Salary Deposit',
        amount: 5200.0,
        date: now.subtract(const Duration(days: 1)),
        isIncome: true,
        category: 'Income',
      ),
      TransactionModel(
        id: '2',
        title: 'Whole Foods Market',
        amount: 145.50,
        date: now.subtract(const Duration(days: 1)),
        isIncome: false,
        category: 'Groceries',
      ),
      TransactionModel(
        id: '3',
        title: 'Netflix Subscription',
        amount: 15.99,
        date: now.subtract(const Duration(days: 2)),
        isIncome: false,
        category: 'Entertainment',
      ),
      TransactionModel(
        id: '4',
        title: 'Freelance Design',
        amount: 850.0,
        date: now.subtract(const Duration(days: 3)),
        isIncome: true,
        category: 'Income',
      ),
      TransactionModel(
        id: '5',
        title: 'Uber Ride',
        amount: 24.0,
        date: now.subtract(const Duration(days: 3)),
        isIncome: false,
        category: 'Transport',
      ),
      TransactionModel(
        id: '6',
        title: 'Amazon Shopping',
        amount: 320.0,
        date: now.subtract(const Duration(days: 4)),
        isIncome: false,
        category: 'Shopping',
      ),
      TransactionModel(
        id: '7',
        title: 'Starbucks',
        amount: 6.50,
        date: now.subtract(const Duration(days: 5)),
        isIncome: false,
        category: 'Food',
      ),
      TransactionModel(
        id: '8',
        title: 'Rent Payment',
        amount: 1800.0,
        date: now.subtract(const Duration(days: 10)),
        isIncome: false,
        category: 'Bills',
      ),
      TransactionModel(
        id: '9',
        title: 'Gym Membership',
        amount: 50.0,
        date: now.subtract(const Duration(days: 12)),
        isIncome: false,
        category: 'Health',
      ),
    ]);
  }

  List<TransactionModel> get filteredTransactions {
    final now = DateTime.now();
    if (selectedTimeframe.value == 'Weekly') {
      return transactions.where((t) => t.date.isAfter(now.subtract(const Duration(days: 7)))).toList();
    } else if (selectedTimeframe.value == 'Monthly') {
      return transactions.where((t) => t.date.isAfter(now.subtract(const Duration(days: 30)))).toList();
    }
    return transactions;
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
  
  double get filteredTotalExpense {
    return filteredTransactions
        .where((t) => !t.isIncome)
        .fold(0.0, (sum, item) => sum + item.amount);
  }

  void addTransaction(TransactionModel transaction) {
    transactions.add(transaction);
    transactions.sort((a, b) => b.date.compareTo(a.date));
  }
}
