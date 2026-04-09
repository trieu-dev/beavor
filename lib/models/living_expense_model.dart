import 'package:hive/hive.dart';

part 'living_expense_model.g.dart';

@HiveType(typeId: 6)
class CustomExpenseItem extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double amount;

  CustomExpenseItem({
    required this.id,
    this.name = '',
    this.amount = 0.0,
  });
}

@HiveType(typeId: 5)
class LivingExpenseModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final DateTime month;

  @HiveField(2)
  double rent;

  @HiveField(3)
  double electricityPrevious;

  @HiveField(4)
  double electricityCurrent;

  @HiveField(5)
  double water;

  @HiveField(6)
  double serviceFee;

  @HiveField(7)
  double otherFees;

  @HiveField(8)
  String? note;

  @HiveField(9)
  double food;

  @HiveField(10)
  double transport;

  @HiveField(11)
  List<CustomExpenseItem> customExpenses;

  LivingExpenseModel({
    required this.id,
    required this.month,
    this.rent = 0.0,
    this.electricityPrevious = 0.0,
    this.electricityCurrent = 0.0,
    this.water = 0.0,
    this.serviceFee = 0.0,
    this.otherFees = 0.0,
    this.note,
    this.food = 0.0,
    this.transport = 0.0,
    this.customExpenses = const [],
  });

  double get electricityConsumed => electricityCurrent - electricityPrevious;

  double calculateElectricityCost() {
    double consumed = electricityConsumed;
    if (consumed <= 0) return 0.0;

    return consumed * 3500;
  }

  double calculateTotal() {
    double customTotal = customExpenses.fold(0, (sum, item) => sum + item.amount);
    return rent + calculateElectricityCost() + water + serviceFee + otherFees + food + transport + customTotal;
  }

  int getFilledCount() {
    int count = 0;
    if (rent > 0) count++;
    if (calculateElectricityCost() > 0) count++;
    if (water > 0) count++;
    if (serviceFee > 0) count++;
    if (food > 0) count++;
    if (transport > 0) count++;
    
    count += customExpenses.where((e) => e.amount > 0).length;
    return count;
  }
}
