import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminous_ledger/models/expense.dart';
import 'package:luminous_ledger/screens/expense_splitter/split_expense_editor.dart';
import 'package:luminous_ledger/screens/expense_splitter/split_result_table.dart';
import 'package:luminous_ledger/screens/expense_splitter/swipeable_card.dart';
import 'package:luminous_ledger/services/expense_splitter.dart';
import '../members/members_list_screen.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  Expense? newExpense;
  List<Expense> bills = [];
  SplitResult? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101B),
      appBar: AppBar(
        title: const Text('Chia hóa đơn nhóm'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          _buildMembersButton()
        ],
      ),
      body: PageView(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ...bills.map(_buildBillGroupCard),
              if (newExpense != null) SplitExpenseEditor(
                onSave: (item) {
                  setState(() {
                    bills.add(item);
                  });
                },
                onCancel: () {
                  setState(() {
                    newExpense = null;
                  });
                },
              ),
            ],
          ),
          result == null ? Center(child: Text("No data")) : SplitResultTable(result: result!)
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Expanded(child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    newExpense = Expense.def();
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  // backgroundColor: const Color(0xFF9489FE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide(
                      color: Color(0xFF9489FE)
                    )
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Color(0xFF9489FE)),
                    SizedBox(width: 8),
                    Text(
                      'Nhóm',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF9489FE)),
                    )
                  ],
                ),
              )),
              SizedBox(width: 16,),
              Expanded(child: ElevatedButton(
                onPressed: () {
                  final result = ExpenseSplitter.calculateSettlements(bills);

                  print('=== Non-payers pay ${result.primaryPayer} ===');
                  for (final s in result.nonPayerSettlements) print(s);

                  print('\n=== Payers settle among themselves ===');
                  for (final s in result.payerSettlements) print(s);

                  setState(() {
                    this.result = result;
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF9489FE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Chia',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ))
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMembersButton() {
    return GestureDetector(
      onTap: () => Get.to(() => MembersListScreen(selectedIds: [])),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFF161C2C),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: const Color(0xFF9489FE).withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Icon(
          Icons.people_rounded,
          color: Colors.white,
          size: 24,
        )
      ),
    ).marginOnly(right: 20);
  }

  List<String> edittingIds = [];

  Widget _buildBillGroupCard(Expense item) {
    return edittingIds.contains(item.id)
          ? SplitExpenseEditor(
              onSave: (item) {
                int index = bills.indexWhere((o) => o.id == item.id);
                if (index >= 0) {
                  bills[index] = item;
                }
                edittingIds.remove(item.id);
                setState(() { });
              },
              onCancel: () {
                setState(() {
                  edittingIds.remove(item.id);
                });
              },
              item: item.clone(),
            ).marginOnly(bottom: 20)
          : SwipeableCard(
              item: item,
              onDuplicate: () {
            
              },
              onEdit: () {
                setState(() {
                  edittingIds.add(item.id);
                });
              },
              onRemove: () {
                
              },
            ).marginOnly(bottom: 20);

  }
}

