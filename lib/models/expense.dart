class Expense {
  final String id;
  String payerId;
  final String title;
  double amount;
  final List<String> participantIds; // who shares this expense

  Expense({
    required this.id,
    required this.payerId,
    required this.title,
    required this.amount,
    required this.participantIds,
  });

  factory Expense.def() =>
      Expense(id: "", payerId: '', amount: 0, participantIds: [], title: '');

  double get sharePerPerson => amount / participantIds.length;

  Expense clone() => Expense.fromMap(toMap());

  @override
  String toString() => '$payerId → $title - $amount - ${participantIds.join(', ')}';

  factory Expense.fromMap(Map<String, dynamic> map) {
    return Expense(
      id: map['id'],
      title: map['title'],
      amount: (map['amount'] as num).toDouble(),
      participantIds: map['participantIds'] != null
          ? List<String>.from(map['participantIds'].map((x) => x))
          : [],
      payerId: map['payerId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'amount': amount,
      'participantIds': participantIds,
      'payerId': payerId,
    };
  }
}