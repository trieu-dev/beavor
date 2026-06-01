import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luminous_ledger/models/member.dart';
import 'package:luminous_ledger/models/settlement.dart';
import 'package:luminous_ledger/services/expense_splitter.dart';

final currencyFormatter = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: '₫',
  decimalDigits: 0,
);

class SplitResultTable extends StatelessWidget {
  final SplitResult result;
  const SplitResultTable({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          children: [
            if (result.payerSettlements.isNotEmpty) _resultTable(result.payerSettlements).marginOnly(bottom: 20),
            if (result.nonPayerSettlements.isNotEmpty) _resultTable(result.nonPayerSettlements)
          ],
        )
      )
    );
  }

  Widget _resultTable(List<Settlement> items) {
    int itemCount = items.length;
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
      child: ListView.separated(
        shrinkWrap: true,                          // 👈 key
        physics: NeverScrollableScrollPhysics(),   // 👈 key
        itemBuilder:(context, index) {
          final item = index == itemCount ? null : items[index];
          return item == null
            ? Row(
                children: [
                  Expanded(child: Text("Tổng")),
                  Text(currencyFormatter.format(items.map((e) => e.amount).reduce((a,b) => a + b))),
                ],
              )
            : Row(
                children: [
                  Text(getNames([item.fromId]).join('')),
                  Icon(Icons.arrow_right_alt).marginOnly(left: 8, right: 8),
                  Expanded(child: Text(getNames([item.toId]).join(''))),
                  Text(currencyFormatter.format(item.amount)),
                ],
              );
        },
        separatorBuilder: (context, index) =>  Divider(color: const Color(0xFF9489FE)),
        itemCount: itemCount + 1
      )
    );
  }
}