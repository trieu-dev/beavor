import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:luminous_ledger/core/theme/app_colors.dart';
import 'package:luminous_ledger/models/expense.dart';
import 'package:luminous_ledger/models/member.dart';

class SwipeableCard extends StatelessWidget {
  final String? linkingId;
  final VoidCallback onLink;
  final Function(String) onStartLink;

  final Expense item;
  final VoidCallback onDuplicate;
  final VoidCallback onEdit;
  final VoidCallback onRemove;

  const SwipeableCard({
    super.key,
    this.linkingId,
    required this.item,
    required this.onDuplicate,
    required this.onEdit,
    required this.onLink,
    required this.onStartLink,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: ValueKey(item.id),

      // Swipe from RIGHT → shows actions on the right side
      endActionPane: ActionPane(
        motion: const BehindMotion(), // or DrawerMotion, ScrollMotion, StretchMotion
        extentRatio: 0.75, // how much of the card the actions take up
        children: [
          // Duplicate
          SlidableAction(
            onPressed: (_) => onDuplicate(),
            backgroundColor: const Color(0xFF4A90D9),
            foregroundColor: Colors.white,
            icon: Icons.copy_rounded,
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(20)),
          ),
          // Edit
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: const Color(0xFF7B61FF),
            foregroundColor: Colors.white,
            icon: Icons.edit_rounded,
          ),
          SlidableAction(
            onPressed: (_) => onEdit(),
            backgroundColor: const Color(0xFFFF9E00),
            foregroundColor: Colors.white,
            icon: Icons.link,
          ),
          // Remove
          SlidableAction(
            onPressed: (_) => onRemove(),
            backgroundColor: const Color(0xFFE05C5C),
            foregroundColor: Colors.white,
            icon: Icons.delete_rounded,
            borderRadius: const BorderRadius.horizontal(right: Radius.circular(20)),
          ),
        ],
      ),

      // The card itself
      child: _CardContent(item: item, linkingId: linkingId, onStartLink: onStartLink, onLink: onLink),
    );
  }
}

class _CardContent extends StatelessWidget {
  final String? linkingId;
  final Expense item;
  final VoidCallback onLink;
  final Function(String) onStartLink;

  const _CardContent({
    required this.item,
    required this.onLink,
    required this.onStartLink,
    this.linkingId
  });

  @override
  Widget build(BuildContext context) {
    return _buildBillGroupCardViewer(item);
  }

  Widget _buildBillGroupCardViewer(Expense item) {
    bool isLinking = linkingId != null;
    bool isSelected = (isLinking && linkingId == item.linkId);
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
        GestureDetector(
          onLongPress: () {
            onStartLink(item.linkId ?? item.id);
          },
          onTap: onLink,
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF9489FE) : const Color(0xFF161C2C),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Color(0xFF9489FE))
            ),
            child: Icon(
              isLinking ? Icons.link : Icons.receipt_long_rounded,
              color: isSelected ? Color(0xFFFFFFFF) : Color(0xFF9489FE),
              size: 20,
            ),
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
        // const SizedBox(width: 12),
        // IconButton(
        //   onPressed: () {
        //     setState(() {
        //       edittingIds.add(item.id);
        //     });
        //   },
        //   icon: const Icon(
        //     Icons.edit_rounded,
        //     color: Colors.white54,
        //     size: 20,
        //   ),
        //   style: IconButton.styleFrom(
        //     backgroundColor: Colors.white.withValues(alpha: 0.05),
        //     padding: const EdgeInsets.all(8),
        //   ),
        // ),
      ],
    )
    );
  }
}

final currencyFormatter = NumberFormat.currency(
  locale: 'vi_VN',
  symbol: '₫',
  decimalDigits: 0,
);