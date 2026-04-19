class WalletModel {
  final String id;
  final String name;
  final double balance;
  final int colorValue;
  final String icon;
  final String type; // e.g., 'Bank Account', 'Cash', 'Credit Card'

  WalletModel({
    required this.id,
    required this.name,
    required this.balance,
    required this.colorValue,
    required this.icon,
    required this.type,
  });

  factory WalletModel.fromMap(Map<String, dynamic> map) {
    return WalletModel(
      id: map['id'],
      name: map['name'],
      balance: (map['balance'] as num).toDouble(),
      colorValue: map['color_value'],
      icon: map['icon'],
      type: map['type'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'balance': balance,
      'color_value': colorValue,
      'icon': icon,
      'type': type,
    };
  }
}
