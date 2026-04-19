class TransactionModel {
  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final bool isIncome;
  final String categoryId;
  final String walletId;
  final String? note;

  TransactionModel({
    required this.id,
    required this.title,
    required this.amount,
    required this.date,
    required this.isIncome,
    required this.categoryId,
    required this.walletId,
    this.note,
  });

  factory TransactionModel.fromMap(Map<String, dynamic> map) {
    return TransactionModel(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      date: DateTime.parse(map['date']),
      isIncome: map['is_income'],
      categoryId: map['category_id'],
      walletId: map['wallet_id'],
      note: map['note'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'date': date.toIso8601String(),
      'is_income': isIncome,
      'category_id': categoryId,
      'wallet_id': walletId,
      'note': note,
    };
  }
}
