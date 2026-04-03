import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 2)
class TransactionModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final double amount;
  
  @HiveField(3)
  final DateTime date;
  
  @HiveField(4)
  final bool isIncome;
  
  @HiveField(5)
  final String categoryId;
  
  @HiveField(6)
  final String walletId;
  
  @HiveField(7)
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
}
