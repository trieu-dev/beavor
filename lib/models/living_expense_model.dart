class CustomExpenseItem {
  String id;
  String name;
  double amount;
  String? livingExpenseId;

  CustomExpenseItem({
    required this.id,
    this.name = '',
    this.amount = 0.0,
    this.livingExpenseId,
  });

  factory CustomExpenseItem.fromMap(Map<String, dynamic> map) {
    return CustomExpenseItem(
      id: map['id'],
      name: map['name'],
      amount: (map['amount'] as num).toDouble(),
      livingExpenseId: map['living_expense_id'],
    );
  }

  Map<String, dynamic> toMap() {
    final map = {
      'id': id,
      'name': name,
      'amount': amount,
    };
    if (livingExpenseId != null) {
      map['living_expense_id'] = livingExpenseId!;
    }
    return map;
  }
}

class LivingExpenseModel {
  final String id;
  final DateTime month;
  double rent;
  double electricityPrevious;
  double electricityCurrent;
  double water;
  double serviceFee;
  double otherFees;
  String? note;
  double food;
  double transport;
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

  factory LivingExpenseModel.fromMap(Map<String, dynamic> map, {List<CustomExpenseItem> customExpenses = const []}) {
    return LivingExpenseModel(
      id: map['id'],
      month: DateTime.parse(map['month']),
      rent: (map['rent'] as num?)?.toDouble() ?? 0.0,
      electricityPrevious: (map['electricity_previous'] as num?)?.toDouble() ?? 0.0,
      electricityCurrent: (map['electricity_current'] as num?)?.toDouble() ?? 0.0,
      water: (map['water'] as num?)?.toDouble() ?? 0.0,
      serviceFee: (map['service_fee'] as num?)?.toDouble() ?? 0.0,
      otherFees: (map['other_fees'] as num?)?.toDouble() ?? 0.0,
      note: map['note'],
      food: (map['food'] as num?)?.toDouble() ?? 0.0,
      transport: (map['transport'] as num?)?.toDouble() ?? 0.0,
      customExpenses: customExpenses,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'month': month.toIso8601String(),
      'rent': rent,
      'electricity_previous': electricityPrevious,
      'electricity_current': electricityCurrent,
      'water': water,
      'service_fee': serviceFee,
      'other_fees': otherFees,
      'note': note,
      'food': food,
      'transport': transport,
    };
  }
}
