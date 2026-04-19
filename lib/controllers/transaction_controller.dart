import 'package:get/get.dart';
import '../models/transaction_model.dart';
import '../models/wallet_model.dart';
import '../models/category_model.dart';
import '../core/services/supabase_service.dart';

class TransactionController extends GetxController {
  final _client = SupabaseService().supabase;

  // Observables
  var transactions = <TransactionModel>[].obs;
  var wallets = <WalletModel>[].obs;
  var categories = <CategoryModel>[].obs;
  var isLoading = false.obs;

  // Selected Timeframe for Analysis
  var selectedTimeframe = 'Weekly'.obs;

  @override
  void onInit() {
    super.onInit();
    loadData();
  }

  Future<void> loadData() async {
    isLoading.value = true;
    try {
      // 1. Fetch Categories
      final categoryData = await _client.from('categories').select();
      if (categoryData.isEmpty) {
        await _seedInitialData();
        return loadData(); // Reload after seeding
      }
      categories.assignAll(
        categoryData.map((e) => CategoryModel.fromMap(e)).toList(),
      );

      // 2. Fetch Wallets
      final walletData = await _client.from('wallets').select();
      wallets.assignAll(walletData.map((e) => WalletModel.fromMap(e)).toList());

      // 3. Fetch Transactions
      final transactionData = await _client
          .from('transactions')
          .select()
          .order('date', ascending: false);
      transactions.assignAll(
        transactionData.map((e) => TransactionModel.fromMap(e)).toList(),
      );
    } catch (e) {
      Get.printError(info: 'Error loading data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _seedInitialData() async {
    // 1. Wallets
    final walletsToSeed = [
      {
        'id': 'w1',
        'name': 'Ví chính',
        'balance': 0,
        'color_value': 0xFF6366F1,
        'icon': 'wallet',
        'type': 'Cash',
      },
      {
        'id': 'w2',
        'name': 'Ngân hàng',
        'balance': 0,
        'color_value': 0xFF10B981,
        'icon': 'account_balance',
        'type': 'Bank',
      },
    ];
    await _client.from('wallets').insert(walletsToSeed);

    // 2. Categories
    final categoriesToSeed = [
      {
        'id': 'c1',
        'name': 'Ăn uống',
        'icon': 'restaurant',
        'color_value': 0xFFF59E0B,
        'is_income': false,
      },
      {
        'id': 'c2',
        'name': 'Di chuyển',
        'icon': 'directions_car',
        'color_value': 0xFF3B82F6,
        'is_income': false,
      },
      {
        'id': 'c3',
        'name': 'Mua sắm',
        'icon': 'shopping_bag',
        'color_value': 0xFFEC4899,
        'is_income': false,
      },
      {
        'id': 'c4',
        'name': 'Giải trí',
        'icon': 'sports_esports',
        'color_value': 0xFF8B5CF6,
        'is_income': false,
      },
      {
        'id': 'c5',
        'name': 'Nhà cửa',
        'icon': 'home',
        'color_value': 0xFF10B981,
        'is_income': false,
      },
      {
        'id': 'c6',
        'name': 'Lương',
        'icon': 'payments',
        'color_value': 0xFF10B981,
        'is_income': true,
      },
      {
        'id': 'c7',
        'name': 'Thưởng',
        'icon': 'redeem',
        'color_value': 0xFFF59E0B,
        'is_income': true,
      },
    ];
    await _client.from('categories').insert(categoriesToSeed);
  }

  void setTimeframe(String timeframe) {
    selectedTimeframe.value = timeframe;
  }

  List<TransactionModel> get filteredTransactions {
    final now = DateTime.now();
    if (selectedTimeframe.value == 'Weekly') {
      return transactions
          .where((t) => t.date.isAfter(now.subtract(const Duration(days: 7))))
          .toList();
    } else if (selectedTimeframe.value == 'Monthly') {
      return transactions
          .where((t) => t.date.isAfter(now.subtract(const Duration(days: 30))))
          .toList();
    }
    return transactions;
  }

  double get totalBalance =>
      wallets.fold(0.0, (sum, wallet) => sum + wallet.balance);
  double get totalIncome => transactions
      .where((t) => t.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);
  double get totalExpense => transactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);
  double get filteredTotalExpense => filteredTransactions
      .where((t) => !t.isIncome)
      .fold(0.0, (sum, item) => sum + item.amount);

  Future<void> addTransaction(TransactionModel transaction) async {
    await _client.from('transactions').insert(transaction.toMap());
    await _updateWalletBalance(
      transaction.walletId,
      transaction.amount,
      transaction.isIncome,
    );
    await loadData();
  }

  Future<void> updateTransaction(
    TransactionModel oldTx,
    TransactionModel newTx,
  ) async {
    // 1. Revert Old Impact
    await _updateWalletBalance(oldTx.walletId, -oldTx.amount, oldTx.isIncome);

    // 2. Apply New Impact
    await _client.from('transactions').update(newTx.toMap()).eq('id', newTx.id);
    await _updateWalletBalance(newTx.walletId, newTx.amount, newTx.isIncome);

    await loadData();
  }

  Future<void> deleteTransaction(TransactionModel transaction) async {
    await _client.from('transactions').delete().eq('id', transaction.id);
    await _updateWalletBalance(
      transaction.walletId,
      -transaction.amount,
      transaction.isIncome,
    );
    await loadData();
  }

  Future<void> _updateWalletBalance(
    String walletId,
    double amount,
    bool isIncome,
  ) async {
    final wallet = wallets.firstWhereOrNull((w) => w.id == walletId);
    if (wallet != null) {
      final double adjustment = isIncome ? amount : -amount;
      final newBalance = wallet.balance + adjustment;
      await _client
          .from('wallets')
          .update({'balance': newBalance})
          .eq('id', walletId);
    }
  }

  Future<void> addCategory(CategoryModel category) async {
    await _client.from('categories').insert(category.toMap());
    await loadData();
  }

  CategoryModel? getCategoryById(String id) {
    return categories.firstWhereOrNull((c) => c.id == id);
  }

  WalletModel? getWalletById(String id) {
    return wallets.firstWhereOrNull((w) => w.id == id);
  }
}
