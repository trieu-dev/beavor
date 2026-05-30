class Settlement {
  final String fromId; // who pays
  final String toId;   // who receives
  final double amount;

  Settlement({
    required this.fromId,
    required this.toId,
    required this.amount,
  });

  @override
  String toString() => '$fromId → $toId: ${amount.toStringAsFixed(2)}';
}