class Member {
  final String id; // who pays
  final String name;   // who receives

  Member({
    required this.id,
    required this.name,
  });

  // @override
  // String toString() => '$fromId → $toId: ${amount.toStringAsFixed(2)}';
}