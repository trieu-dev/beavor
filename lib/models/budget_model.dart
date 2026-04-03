import 'package:hive/hive.dart';

part 'budget_model.g.dart';

@HiveType(typeId: 3)
class BudgetModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String categoryId;
  
  @HiveField(2)
  final double limitAmount;
  
  @HiveField(3)
  final double spentAmount;
  
  @HiveField(4)
  final String period; // e.g., 'Monthly', 'Weekly'

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    this.spentAmount = 0.0,
    required this.period,
  });
}
