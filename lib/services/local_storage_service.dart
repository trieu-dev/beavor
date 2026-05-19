import 'package:get_storage/get_storage.dart';
import '../models/bill_model.dart';
import '../models/shared_bill_user_model.dart';

class LocalStorageService {
  final _box = GetStorage();
  
  static const String _billsKey = 'bills';
  static const String _usersKey = 'shared_bill_users';

  // --- Bills ---
  
  List<BillModel> getBills() {
    final List<dynamic>? data = _box.read(_billsKey);
    if (data == null) return [];
    return data.map((item) => BillModel.fromMap(Map<String, dynamic>.from(item))).toList();
  }

  Future<void> saveBills(List<BillModel> bills) async {
    final data = bills.map((bill) => bill.toMap()).toList();
    await _box.write(_billsKey, data);
  }

  Future<void> addBill(BillModel bill) async {
    final bills = getBills();
    bills.add(bill);
    await saveBills(bills);
  }

  // --- Users ---
  
  List<SharedBillUserModel> getUsers() {
    final List<dynamic>? data = _box.read(_usersKey);
    if (data == null) return [];
    return data.map((item) => SharedBillUserModel.fromJson(Map<String, dynamic>.from(item))).toList();
  }

  Future<void> saveUsers(List<SharedBillUserModel> users) async {
    final data = users.map((user) => user.toJson()).toList();
    await _box.write(_usersKey, data);
  }

  Future<void> addUser(SharedBillUserModel user) async {
    final users = getUsers();
    users.add(user);
    await saveUsers(users);
  }
}
