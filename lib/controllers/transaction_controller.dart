import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';
import '../models/category_model.dart';
import '../core/services/hive_service.dart';

class TransactionController extends GetxController {
  late Box<TransactionModel> _transactionBox;
  late Box<WalletModel> _walletBox;
  late Box<CategoryModel> _categoryBox;

  // Observables
  var transactions = <TransactionModel>[].obs;
  var wallets = <WalletModel>[].obs;
  var categories = <CategoryModel>[].obs;
  
  // Selected Timeframe for Analysis
  var selectedTimeframe = 'Weekly'.obs;

  @override
  void onInit() {
    super.onInit();
    _initBoxes();
  }

  Future<void> _initBoxes() async {
    _transactionBox = Hive.box<TransactionModel>(HiveService.transactionsBoxName);
    _walletBox = Hive.box<WalletModel>(HiveService.walletsBoxName);
    _categoryBox = Hive.box<CategoryModel>(HiveService.categoriesBoxName);
    
    loadData();
  }

  void loadData() {
    // Load Transactions sorted by date
    final allTransactions = _transactionBox.values.toList()
      ..sort((a, b) => b.date.compareTo(a.date));
    transactions.assignAll(allTransactions);

    // Load Wallets and Categories
    wallets.assignAll(_walletBox.values.toList());
    categories.assignAll(_categoryBox.values.toList());
  }

  void setTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
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

  // Computed property: Total Balance (Across all wallets)
  double get totalBalance {
    return wallets.fold(0.0, (sum, wallet) => sum + wallet.balance);
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

  Future<void> addTransaction(TransactionModel transaction) async {
    await _transactionBox.put(transaction.id, transaction);
    
    // Update Wallet Balance
    final wallet = _walletBox.get(transaction.walletId);
    if (wallet != null) {
      final newBalance = transaction.isIncome 
          ? wallet.balance + transaction.amount 
          : wallet.balance - transaction.amount;
      
      final updatedWallet = WalletModel(
        id: wallet.id,
        name: wallet.name,
        balance: newBalance,
        colorValue: wallet.colorValue,
        icon: wallet.icon,
        type: wallet.type,
      );
      await _walletBox.put(wallet.id, updatedWallet);
    }

    loadData(); // Refresh UI observables
  }

  CategoryModel? getCategoryById(String id) {
    return _categoryBox.get(id);
  }

  WalletModel? getWalletById(String id) {
    return _walletBox.get(id);
  }
}
