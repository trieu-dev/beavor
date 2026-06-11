import 'dart:math';

import 'package:get/get.dart';
import 'package:luminous_ledger/models/expense.dart';
import 'package:luminous_ledger/models/settlement.dart';

class SplitResult {
  final String? primaryPayer;
  final List<Settlement> nonPayerSettlements; // a3,a4,a5 → a1
  final List<Settlement> payerSettlements;    // a1 → a2

  SplitResult({
    this.primaryPayer,
    required this.nonPayerSettlements,
    required this.payerSettlements,
  });
}

class ExpenseSplitter {
  /// Settlements where non-payers only pay ONE person (the primary payer),
  /// and payers settle among themselves separately.
  static SplitResult calculateSettlements(List<Expense> expenses) {
    if (expenses.isEmpty) return SplitResult(nonPayerSettlements: [], payerSettlements: []);

    // --- Step 1: Identify payers and non-payers ---
    final allParticipants = expenses
        .expand((e) => e.participantIds)
        .toSet();

    final payers = expenses.map((e) => e.payerId).toSet();
    final nonPayers = allParticipants.difference(payers);

    List<Expense> refinedExpenses = [];
    List<String> shareIds = expenses.map((x) => x.shareId).toSet().toList();
    for (final id in shareIds) {
      final bills = expenses.where((x) => x.shareId == id).toList();
      final item = Expense(
        id: id,
        payerId: "",
        title: "",
        amount: bills.map((x) => x.amount).reduce((a, b) => a + b),
        participantIds: bills.mapMany((x) => x.participantIds).toList()
      );
      refinedExpenses.add(item);
    }

    // --- Step 2: Calculate each person's fair share across ALL expenses ---
    final Map<String, double> totalOwed = {}; // how much each person should pay
    for (final expense in refinedExpenses) {
      final share = expense.sharePerPerson;
      for (final p in expense.participantIds) {
        totalOwed[p] = (totalOwed[p] ?? 0) + share;
      }
    }

    // --- Step 3: Pick the primary payer (highest total paid) ---
    // Non-payers will send their money here
    final Map<String, double> totalPaid = {};
    for (final expense in expenses) {
      totalPaid[expense.payerId] = (totalPaid[expense.payerId] ?? 0) + expense.amount;
    }
    final primaryPayer = payers.reduce(
      (a, b) => (totalPaid[a] ?? 0) >= (totalPaid[b] ?? 0) ? a : b,
    );

    // --- Step 4: Non-payers → primary payer ---
    final nonPayerSettlements = nonPayers
        .where((p) => (totalOwed[p] ?? 0) > 0.005)
        .map((p) => Settlement(
              fromId: p,
              toId: primaryPayer,
              amount: double.parse((totalOwed[p]!).toStringAsFixed(2)),
            ))
        .toList();

    // --- Step 5: Payers settle among themselves ---
    // Each payer's net = what they paid - their own fair share
    // Then: primary payer now also holds all non-payer money,
    // so we factor that into the payer-to-payer settlement.
    //
    // Effective balance for each payer:
    //   = totalPaid - ownShare + (nonPayerMoney collected if primaryPayer)
    //
    // Simpler: just recalculate balances among payers only,
    // treating non-payer shares as already delivered to primaryPayer.

    final double nonPayerTotal = nonPayers.fold(
      0.0, (sum, p) => sum + (totalOwed[p] ?? 0),
    );

    final Map<String, double> payerBalances = {};
    for (final p in payers) {
      // What they paid out of pocket
      final paid = totalPaid[p] ?? 0;
      // Their own fair share
      final owed = totalOwed[p] ?? 0;
      payerBalances[p] = paid - owed;
    }
    // Primary payer "received" all the non-payer money
    payerBalances[primaryPayer] = (payerBalances[primaryPayer] ?? 0) - nonPayerTotal;

    // Now settle payer balances with simple two-pointer
    final payerSettlements = _settleBalances(payerBalances);

    return SplitResult(
      primaryPayer: primaryPayer,
      nonPayerSettlements: nonPayerSettlements,
      payerSettlements: payerSettlements,
    );
  }

  static List<Settlement> _settleBalances(Map<String, double> balances) {
    final creditors = <MapEntry<String, double>>[];
    final debtors = <MapEntry<String, double>>[];

    balances.forEach((id, balance) {
      if (balance > 0.005) creditors.add(MapEntry(id, balance));
      if (balance < -0.005) debtors.add(MapEntry(id, balance.abs()));
    });

    creditors.sort((a, b) => b.value.compareTo(a.value));
    debtors.sort((a, b) => b.value.compareTo(a.value));

    final settlements = <Settlement>[];

    while (creditors.isNotEmpty && debtors.isNotEmpty) {
      final creditor = creditors.first;
      final debtor = debtors.first;
      final transfer = min(creditor.value, debtor.value);

      settlements.add(Settlement(
        fromId: debtor.key,
        toId: creditor.key,
        amount: double.parse(transfer.toStringAsFixed(2)),
      ));

      creditors.removeAt(0);
      debtors.removeAt(0);

      final rc = creditor.value - transfer;
      final rd = debtor.value - transfer;
      if (rc > 0.005) {
        creditors.insert(0, MapEntry(creditor.key, rc));
        creditors.sort((a, b) => b.value.compareTo(a.value));
      }
      if (rd > 0.005) {
        debtors.insert(0, MapEntry(debtor.key, rd));
        debtors.sort((a, b) => b.value.compareTo(a.value));
      }
    }

    return settlements;
  }
}