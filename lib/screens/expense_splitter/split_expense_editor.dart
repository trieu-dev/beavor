import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:luminous_ledger/models/expense.dart';
import 'package:luminous_ledger/models/member.dart';
import 'package:luminous_ledger/screens/members/members_list_screen.dart';

class SplitExpenseEditor extends StatefulWidget {
  final Function(Expense) onSave;
  final Function() onCancel;
  final Expense? item;
  const SplitExpenseEditor({super.key, required this.onSave, required this.onCancel, this.item});

  @override
  State<SplitExpenseEditor> createState() => _SplitExpenseEditorState();
}

class _SplitExpenseEditorState extends State<SplitExpenseEditor> {
  final TextEditingController titleCtrl = TextEditingController();
  double amount = 0;
  String payerId = '';
  List<String> participantIds = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.item != null) {
      amount = widget.item!.amount;
      payerId = widget.item!.payerId;
      participantIds = widget.item!.participantIds;
      titleCtrl.text = widget.item!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tạo nhóm mới',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Group Name Input
          TextField(
            controller: titleCtrl,
            style: const TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: 'Tên nhóm (Vd: Du lịch Đà Lạt)',
              hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.3)),
              filled: true,
              fillColor: const Color(0xFF0B101B),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(
                Icons.groups_rounded,
                color: Color(0xFF9489FE),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextField(
                  keyboardType: TextInputType.number,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration(
                    hintText: 'living_amount_hint'.tr,
                    hintStyle: TextStyle(color: Colors.white24, fontSize: 18),
                    suffixText: '₫',
                    suffixStyle: TextStyle(color: Colors.white54, fontSize: 14),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  controller:
                      TextEditingController(
                          text: amount == 0
                              ? ''
                              : NumberFormat('#,###').format(amount),
                        )
                        ..selection = TextSelection.fromPosition(
                          TextPosition(
                            offset:
                                (amount == 0
                                        ? ''
                                        : NumberFormat(
                                            '#,###',
                                          ).format(amount))
                                    .length,
                          ),
                        ),
                  onChanged: (v) {
                    setState(() {
                      amount = _parseDouble(v);
                    });
                  },
                ),
              ),
              SizedBox(width: 8),
              TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  foregroundColor: const Color(0xFF9489FE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                onPressed: () async {
                  final ids = await Get.to<dynamic>(() => MembersListScreen(selectedIds: payerId.isEmpty ? [] : [payerId]));
                  if (ids is List<String> && ids.isNotEmpty){
                    payerId = ids[0];
                    setState(() { });
                  }
                },
                child: Text("Người trả"),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...payerId == ''
            ? []
            : [
                Text(allMembers.firstWhereOrNull((x) => x.id == payerId)?.name ?? ""),
                const SizedBox(height: 16)
              ],
          // Member Selection Button
          participants(),
          const SizedBox(height: 32),
          // Create Button
          Row(children: [
            Expanded(child: cancelBtn()),
            const SizedBox(width: 16),
            Expanded(child: saveBtn()),
          ]),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget participants() {
    return Column(
      children: [
        GestureDetector(
          onTap: () async {
            final ids = await Get.to<List<String>>(() => MembersListScreen(selectedIds: participantIds));
            if (ids == null) return;
            setState(() {
              participantIds = ids;
            });
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF0B101B),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.05),
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9489FE).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.person_add_rounded,
                    color: Color(0xFF9489FE),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Text(
                    'Thêm thành viên',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.white54,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
        if (participantIds.isNotEmpty) Wrap(
          spacing: 4,
          children: [
            ...participantIds.map((id) => allMembers.firstWhereOrNull((o) => o.id == id)).toList().where((x) => x != null).map(participantChip)
          ],
        ).marginOnly(top: 8)
      ],
    );
  }

  Widget participantChip(Member? item) {
    return Chip(
      // shape: RoundedRectangleBorder(borderRadius: BorderRadiusGeometry.circular(8)),
      onDeleted: () {
        setState(() {
          participantIds.remove(item?.id);
        });
      },
      label: Text(item?.name ?? ""),
      padding: EdgeInsets.all(0),
      visualDensity: VisualDensity(
        horizontal: VisualDensity.minimumDensity,
        vertical: VisualDensity.minimumDensity
      )
    );
  }

  Widget cancelBtn() {
    return ElevatedButton(
      onPressed: widget.onCancel,
      style: ElevatedButton.styleFrom(
        // backgroundColor: const Color(0xFF9489FE),
        
        backgroundColor: Colors.transparent,
        // foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Color(0xFF9489FE))
        ),
        elevation: 0,
      ),
      child: const Text(
        'Hủy',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF9489FE)),
      ),
    );
  }

  Widget saveBtn() {
    return ElevatedButton(
      onPressed: () {
        widget.onSave(Expense(
          id: widget.item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
          title: titleCtrl.text,
          amount: amount,
          payerId: payerId,
          participantIds: participantIds
        ));
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
        'Lưu',
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    );
  }
}

double _parseDouble(String v) {
  if (v.isEmpty) return 0;
  return double.parse(v.replaceAll(',', ''));
}