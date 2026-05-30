import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luminous_ledger/core/theme/app_colors.dart';
import 'package:luminous_ledger/models/expense.dart';
import 'package:luminous_ledger/screens/expense_splitter/new_expense_section.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B101B),
      appBar: AppBar(
        title: const Text('Chia hóa đơn nhóm'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          // _buildBillGroupCard(
          //   title: 'Tiền xe (3 xe)',
          //   subtitle: 'Minh Tú, Lan Anh, Hoàng Long đã trả',
          //   onEdit: () {
          //     // TODO: Implement edit logic
          //   },
          // ),
          // const SizedBox(height: 16),
          _buildMembersButton(),
          ...bills.map(_buildBillGroupCard),
          const SizedBox(height: 16),
          if (newExpense != null) NewExpenseSection(
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
                  backgroundColor: const Color(0xFF9489FE),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tạo nhóm mới',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  final currencyFormatter = NumberFormat.currency(
    locale: 'vi_VN',
    symbol: '₫',
    decimalDigits: 0,
  );

  Widget _buildMembersButton() {
    return GestureDetector(
      onTap: () => Get.to(() => MembersListScreen(selectedIds: [])),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: const Color(0xFF161C2C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: const Color(0xFF9489FE).withValues(alpha: 0.15),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF9489FE), Color(0xFF7B66FF)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.people_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danh sách thành viên',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Quản lý thành viên trong nhóm',
                    style: TextStyle(color: Colors.white54, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              color: Color(0xFF9489FE),
              size: 24,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBillGroupCard(Expense item) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF161C2C),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0B101B),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.receipt_long_rounded,
              color: Color(0xFF9489FE),
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: Text(
                      item.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )),
                    SizedBox(width: 8,),
                    Text(
                      currencyFormatter.format(item.amount),
                      style: GoogleFonts.manrope(
                        color: AppColors.onSurface,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -1.0,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  getNames([item.payerId]).join(', '),
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
                Divider(color: const Color(0xFF9489FE)),
                Text(
                  getNames(item.participantIds).join(', '),
                  style: const TextStyle(color: Colors.white54, fontSize: 13),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.edit_rounded,
              color: Colors.white54,
              size: 20,
            ),
            style: IconButton.styleFrom(
              backgroundColor: Colors.white.withValues(alpha: 0.05),
              padding: const EdgeInsets.all(8),
            ),
          ),
        ],
      ),
    ).marginOnly(top: 20);
  }
}
