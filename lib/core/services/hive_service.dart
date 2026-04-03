import 'package:hive_flutter/hive_flutter.dart';
import '../../models/wallet_model.dart';
import '../../models/category_model.dart';
import '../../models/transaction_model.dart';
import '../../models/budget_model.dart';
import '../../models/goal_model.dart';

class HiveService {
  static const String transactionsBoxName = 'transactions';
  static const String walletsBoxName = 'wallets';
  static const String categoriesBoxName = 'categories';
  static const String budgetsBoxName = 'budgets';
  static const String goalsBoxName = 'goals';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(WalletModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(BudgetModelAdapter());
    Hive.registerAdapter(GoalModelAdapter());

    // Open Boxes
    await Hive.openBox<WalletModel>(walletsBoxName);
    await Hive.openBox<CategoryModel>(categoriesBoxName);
    await Hive.openBox<TransactionModel>(transactionsBoxName);
    await Hive.openBox<BudgetModel>(budgetsBoxName);
    await Hive.openBox<GoalModel>(goalsBoxName);

    // Initial Data if empty
    if (Hive.box<CategoryModel>(categoriesBoxName).isEmpty) {
      await _seedInitialData();
    }
  }

  static Future<void> _seedInitialData() async {
    final categoriesBox = Hive.box<CategoryModel>(categoriesBoxName);
    final walletsBox = Hive.box<WalletModel>(walletsBoxName);
    final transactionsBox = Hive.box<TransactionModel>(transactionsBoxName);

    // 1. Wallets (VND)
    final mainWallet = WalletModel(
      id: 'w1',
      name: 'Ví chính',
      balance: 15000000,
      colorValue: 0xFF6366F1,
      icon: 'wallet',
      type: 'Cash',
    );
    final bankWallet = WalletModel(
      id: 'w2',
      name: 'Ngân hàng',
      balance: 50000000,
      colorValue: 0xFF10B981,
      icon: 'account_balance',
      type: 'Bank',
    );
    await walletsBox.putAll({'w1': mainWallet, 'w2': bankWallet});

    // 2. Categories
    final categories = [
      CategoryModel(id: 'c1', name: 'Ăn uống', icon: 'restaurant', colorValue: 0xFFF59E0B, isIncome: false),
      CategoryModel(id: 'c2', name: 'Di chuyển', icon: 'directions_car', colorValue: 0xFF3B82F6, isIncome: false),
      CategoryModel(id: 'c3', name: 'Mua sắm', icon: 'shopping_bag', colorValue: 0xFFEC4899, isIncome: false),
      CategoryModel(id: 'c4', name: 'Giải trí', icon: 'sports_esports', colorValue: 0xFF8B5CF6, isIncome: false),
      CategoryModel(id: 'c5', name: 'Nhà cửa', icon: 'home', colorValue: 0xFF10B981, isIncome: false),
      CategoryModel(id: 'c6', name: 'Lương', icon: 'payments', colorValue: 0xFF10B981, isIncome: true),
      CategoryModel(id: 'c7', name: 'Thưởng', icon: 'redeem', colorValue: 0xFFF59E0B, isIncome: true),
    ];
    for (var cat in categories) {
      await categoriesBox.put(cat.id, cat);
    }

    // 3. Mock Data for a month (approx 30 days back from today)
    final now = DateTime.now();
    for (int i = 0; i < 40; i++) {
      final randomDay = now.subtract(Duration(days: i % 30));
      final isIncome = i % 8 == 0; // Occasionally income
      
      final String catId = isIncome 
          ? (i % 2 == 0 ? 'c6' : 'c7') 
          : 'c${(i % 5) + 1}';
          
      final amount = isIncome 
          ? (5000000 + (i * 100000)).toDouble() 
          : (50000 + (i * 25000)).toDouble();

      final tx = TransactionModel(
        id: 'tx_$i',
        title: isIncome ? 'Thu nhập tháng' : 'Chi tiêu ${categories[int.parse(catId.substring(1)) - 1].name}',
        amount: amount,
        date: randomDay,
        isIncome: isIncome,
        categoryId: catId,
        walletId: i % 2 == 0 ? 'w1' : 'w2',
        note: 'Giao dịch mẫu số $i',
      );
      await transactionsBox.put(tx.id, tx);
    }
  }
}
