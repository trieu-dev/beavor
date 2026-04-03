import 'package:hive/hive.dart';

part 'goal_model.g.dart';

@HiveType(typeId: 4)
class GoalModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final double targetAmount;
  
  @HiveField(3)
  final double currentAmount;
  
  @HiveField(4)
  final DateTime? deadline;
  
  @HiveField(5)
  final String icon;

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.deadline,
    required this.icon,
  });
}
