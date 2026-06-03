import 'package:get_storage/get_storage.dart';
import 'package:luminous_ledger/models/member.dart';
import '../models/expense.dart';

class LocalStorageService {
  final _box = GetStorage();
  
  static const String _billsKey = 'bills';
  static const String _usersKey = 'shared_bill_users';

  // --- Bills ---
  
  List<Expense> getBills() {
    final List<dynamic>? data = _box.read(_billsKey);
    if (data == null) return [];
    return data.map((item) => Expense.fromMap(Map<String, dynamic>.from(item))).toList();
  }

  Future<void> saveBills(List<Expense> bills) async {
    final data = bills.map((bill) => bill.toMap()).toList();
    await _box.write(_billsKey, data);
  }

  Future<void> addBill(Expense bill) async {
    final bills = getBills();
    bills.add(bill);
    await saveBills(bills);
  }

  // --- Users ---
  
  List<Member> getUsers() {
    final List<dynamic>? data = _box.read(_usersKey);
    if (data == null) return [];
    return data.map((item) => Member.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  Future<void> saveUsers(List<Member> users) async {
    final data = users.map((user) => user.toJson()).toList();
    await _box.write(_usersKey, data);
  }

  Future<void> addUser(Member user) async {
    final users = getUsers();
    users.add(user);
    await saveUsers(users);
  }
}
