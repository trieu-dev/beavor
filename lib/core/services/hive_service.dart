import 'package:hive_flutter/hive_flutter.dart';
import '../../models/wallet_model.dart';
import '../../models/category_model.dart';
import '../../models/transaction_model.dart';
import '../../models/budget_model.dart';
import '../../models/goal_model.dart';
import '../../models/living_expense_model.dart';

class HiveService {
  static const String transactionsBoxName = 'transactions';
  static const String walletsBoxName = 'wallets';
  static const String categoriesBoxName = 'categories';
  static const String budgetsBoxName = 'budgets';
  static const String goalsBoxName = 'goals';
  static const String livingExpensesBoxName = 'living_expenses';

  static Future<void> init() async {
    await Hive.initFlutter();

    // Register Adapters
    Hive.registerAdapter(WalletModelAdapter());
    Hive.registerAdapter(CategoryModelAdapter());
    Hive.registerAdapter(TransactionModelAdapter());
    Hive.registerAdapter(BudgetModelAdapter());
    Hive.registerAdapter(GoalModelAdapter());
    Hive.registerAdapter(CustomExpenseItemAdapter());
    Hive.registerAdapter(LivingExpenseModelAdapter());

    // Open Boxes
    await Hive.openBox<WalletModel>(walletsBoxName);
    await Hive.openBox<CategoryModel>(categoriesBoxName);
    await Hive.openBox<TransactionModel>(transactionsBoxName);
    await Hive.openBox<BudgetModel>(budgetsBoxName);
    await Hive.openBox<GoalModel>(goalsBoxName);
    await Hive.openBox<LivingExpenseModel>(livingExpensesBoxName);

    // Initial Data if empty
    if (Hive.box<CategoryModel>(categoriesBoxName).isEmpty) {
      await _seedInitialData();
    }
  }

  static Future<void> _seedInitialData() async {
    final categoriesBox = Hive.box<CategoryModel>(categoriesBoxName);
    final walletsBox = Hive.box<WalletModel>(walletsBoxName);

    // 1. Wallets (VND) - Starting with 0 balance
    final mainWallet = WalletModel(
      id: 'w1',
      name: 'Ví chính',
      balance: 0,
      colorValue: 0xFF6366F1,
      icon: 'wallet',
      type: 'Cash',
    );
    final bankWallet = WalletModel(
      id: 'w2',
      name: 'Ngân hàng',
      balance: 0,
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
  }
}
