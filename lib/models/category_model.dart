import 'package:hive/hive.dart';

part 'category_model.g.dart';

@HiveType(typeId: 1)
class CategoryModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String icon;
  
  @HiveField(3)
  final int colorValue;
  
  @HiveField(4)
  final bool isIncome;

  CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.colorValue,
    required this.isIncome,
  });
}
