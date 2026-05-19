import 'package:luminous_ledger/models/shared_bill_user_model.dart';

class BillModel {
  final int id;
  final String name;
  double amount;
  final List<SharedBillUserModel> users;
  final int whoPaid;

  BillModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.users,
    required this.whoPaid,
  });

  factory BillModel.def() =>
      BillModel(id: 0, name: '', amount: 0, users: [], whoPaid: 0);

  factory BillModel.fromMap(Map<String, dynamic> map) {
    return BillModel(
      id: map['id'],
      name: map['name'],
      amount: (map['amount'] as num).toDouble(),
      users: map['users'] != null
          ? map['users'].map((x) => SharedBillUserModel.fromJson(x)).toList()
          : [],
      whoPaid: map['whoPaid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'amount': amount,
      'users': users,
      'whoPaid': whoPaid,
    };
  }
}
