class BudgetModel {
  final String id;
  final String categoryId;
  final double limitAmount;
  final double spentAmount;
  final String period; // e.g., 'Monthly', 'Weekly'

  BudgetModel({
    required this.id,
    required this.categoryId,
    required this.limitAmount,
    this.spentAmount = 0.0,
    required this.period,
  });

  factory BudgetModel.fromMap(Map<String, dynamic> map) {
    return BudgetModel(
      id: map['id'],
      categoryId: map['category_id'],
      limitAmount: (map['limit_amount'] as num).toDouble(),
      spentAmount: (map['spent_amount'] as num).toDouble(),
      period: map['period'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'category_id': categoryId,
      'limit_amount': limitAmount,
      'spent_amount': spentAmount,
      'period': period,
    };
  }
}
