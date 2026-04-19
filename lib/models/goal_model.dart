class GoalModel {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime? deadline;
  final String icon;

  GoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0.0,
    this.deadline,
    required this.icon,
  });

  factory GoalModel.fromMap(Map<String, dynamic> map) {
    return GoalModel(
      id: map['id'],
      name: map['name'],
      targetAmount: (map['target_amount'] as num).toDouble(),
      currentAmount: (map['current_amount'] as num).toDouble(),
      deadline: map['deadline'] != null ? DateTime.parse(map['deadline']) : null,
      icon: map['icon'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'target_amount': targetAmount,
      'current_amount': currentAmount,
      'deadline': deadline?.toIso8601String(),
      'icon': icon,
    };
  }
}
