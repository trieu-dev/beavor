class CategoryModel {
  final String id;
  final String name;
  final String icon;
  final int colorValue;
  final bool isIncome;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.isIncome,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'],
      name: map['name'],
      icon: map['icon'],
      colorValue: map['color_value'],
      isIncome: map['is_income'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'color_value': colorValue,
      'is_income': isIncome,
    };
  }
}
