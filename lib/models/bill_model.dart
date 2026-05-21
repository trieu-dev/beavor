class BillModel {
  final int id;
  final String name;
  double amount;
  final List<int> userIds;
  int whoPaid;

  BillModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.userIds,
    required this.whoPaid,
  });

  factory BillModel.def() =>
      BillModel(id: 0, name: '', amount: 0, userIds: [], whoPaid: 0);

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'],
      name: map['name'],
      amount: (map['amount'] as num).toDouble(),
      userIds: map['userIds'] != null
          ? map['userIds'].map((x) => x).toList()
          : [],
      whoPaid: map['whoPaid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'userIds': userIds,
      'whoPaid': whoPaid,
    };
  }
}
