import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:luminous_ledger/models/expense.dart';
import 'package:luminous_ledger/screens/expense_splitter/split_expense_editor.dart';
import 'package:luminous_ledger/screens/expense_splitter/split_result_table.dart';
import 'package:luminous_ledger/screens/expense_splitter/swipeable_card.dart';
import 'package:luminous_ledger/services/expense_splitter.dart';
import 'package:luminous_ledger/services/local_storage_service.dart';
import '../members/members_list_screen.dart';

class SplitBillScreen extends StatefulWidget {
  const SplitBillScreen({super.key});

  @override
  State<SplitBillScreen> createState() => _SplitBillScreenState();
}

class _SplitBillScreenState extends State<SplitBillScreen> {
  final LocalStorageService _storageService = Get.put(LocalStorageService());
  Expense? newExpense;
  List<Expense> bills = [];
  Map<String, List<Expense>> get mShareId2Bilss {
    Map<String, List<Expense>> grouped = {};
    for (final item in bills) {
      grouped.putIfAbsent(item.shareId, () => []).add(item);
    }
    return grouped;
  }
  List<Expense> originalBills = [];
  SplitResult? result;
  bool isLinking = false;
  String? linkingId;

  @override
  void initState() {
    super.initState();
    _loadBills();
  }

  void _loadBills() {
    final savedBills = _storageService.getBills();
    setState(() {
      bills = savedBills;
      if (bills.isNotEmpty) {
        result = ExpenseSplitter.calculateSettlements(bills);
      }
    });
  }

  void _saveBills() {
    _storageService.saveBills(bills);
    setState(() {
      if (bills.isEmpty) {
        result = null;
      } else if (result != null) {
        result = ExpenseSplitter.calculateSettlements(bills);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101B),
      appBar: AppBar(
        title: Text('split_bill_title'.tr),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [_buildMembersButton()],
      ),
      body: PageView(
        children: [
          ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemBuilder:(context, index) {
                  final list = mShareId2Bilss.values.elementAt(index);
                  return ListView.separated(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder:(context, index) => _buildBillGroupCard(list[index]),
                    separatorBuilder:(context, index) => Icon(Icons.link, color: Color(0xFF9489FE)),
                    itemCount: list.length
                  );
                },
                separatorBuilder:(context, index) => SizedBox(height: 20),
                itemCount: mShareId2Bilss.length
              ),
              if (newExpense != null)
                SplitExpenseEditor(
                  onSave: (item) {
                    setState(() {
                      bills.add(item);
                      newExpense = null;
                    });
                    _saveBills();
                  },
                  onCancel: () {
                    setState(() {
                      newExpense = null;
                    });
                  },
                ),
            ],
          ),
          result == null
              ? Center(child: Text('split_bill_no_data'.tr))
              : SplitResultTable(result: result!),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: isLinking ? linkActions() : splitActions(),
        ),
      ),
    );
  }

  Widget splitActions() {
    return Row(
      children: [
        Expanded(
          child: AddGroupButton(
            onPressed: () {
              setState(() {
                newExpense = Expense.def();
              });
            }
          )
        ),
        SizedBox(width: 16),
        Expanded(
          child: SplitButton(
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
          ),
        ),
      ],
    );
  }

  void endLinking() {
    isLinking = false;
    linkingId = null;
  }

  Widget linkActions() {
    return Row(
      children: [
        Expanded(
          child: CancelButton(
            onPressed: () {
              bills = originalBills;
              endLinking();
              setState(() {});
            }
          )
        ),
        SizedBox(width: 16),
        Expanded(
          child: SaveButton(
            onPressed: () {
              _saveBills();
              endLinking();
              setState(() {});
            },
          ),
        ),
      ],
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
        child: Icon(Icons.people_rounded, color: Colors.white, size: 24),
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
              setState(() {});
              _saveBills();
            },
            onCancel: () {
              setState(() {
                edittingIds.remove(item.id);
              });
            },
            item: item.clone(),
          ).marginOnly(bottom: 20)
        : SwipeableCard(
            linkingId: linkingId,
            item: item,
            onDuplicate: () {
              int index = bills.indexWhere((o) => o.id == item.id);
              if (index < 0) return;

              final cloned = item.duplicate();
              bills.insert(index, cloned);
              setState(() {});
              _saveBills();
            },
            onEdit: () {
              edittingIds.add(item.id);
              setState(() {});
            },
            onStartLink: (value) {
              isLinking = true;
              item.linkId = value;
              linkingId = value;
              originalBills = bills.map((x) => x.clone()).toList();
              setState(() {});
            },
            onLink: () {
              item.linkId = item.linkId == null ? linkingId : null;
              setState(() {});
            },
            onRemove: () {
              bills.removeWhere((o) => o.id == item.id);
              setState(() {});
              _saveBills();
            },
          );
  }
}

class AddGroupButton extends StatelessWidget {
  final VoidCallback onPressed;
  const AddGroupButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: baseSecondaryButton(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.add, color: Color(0xFF9489FE)),
          SizedBox(width: 8),
          Text(
            'split_bill_group'.tr,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF9489FE),
            ),
          ),
        ],
      ),
    );
  }
}

class SplitButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SplitButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: basePrimaryButton(),
      child: Text(
        'split_bill_split'.tr,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CancelButton extends StatelessWidget {
  final VoidCallback onPressed;
  const CancelButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: baseSecondaryButton(),
      child: Text(
        'cancel'.tr,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF9489FE),
        ),
      )
    );
  }
}

class SaveButton extends StatelessWidget {
  final VoidCallback onPressed;
  const SaveButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: basePrimaryButton(),
      child: Text(
        'save'.tr,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

ButtonStyle basePrimaryButton() {
  return ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF9489FE),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
    ),
    elevation: 0,
  );
}

ButtonStyle baseSecondaryButton() {
  return ElevatedButton.styleFrom(
    backgroundColor: Colors.transparent,
    // backgroundColor: const Color(0xFF9489FE),
    foregroundColor: Colors.white,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(16),
      side: BorderSide(color: Color(0xFF9489FE)),
    ),
    elevation: 0,
  );
}
