import 'package:hive/hive.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 0)
class WalletModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double balance;
  
  @HiveField(3)
  final int colorValue;
  
  @HiveField(4)
  final String icon;
  
  @HiveField(5)
  final String type; // e.g., 'Bank Account', 'Cash', 'Credit Card'

  WalletModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.colorValue,
    required this.icon,
    required this.type,
  });
}
