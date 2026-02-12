import 'package:flutter/material.dart';
import 'package:tracker_app/models/lend_borrow_model.dart';
import 'package:tracker_app/widgets/text_widgets.dart';

// this widget shows a single lend/borrow record in a list
class LendBorrowTile extends StatelessWidget {
  final LendBorrowModel record;
  final VoidCallback? onTap;

  const LendBorrowTile({
    super.key,
    required this.record,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // check if this record is a lend type
    bool isLend = record.type == DebtType.lend;

    // set the color - green for lend, red for borrow
    Color color;
    if (isLend) {
      color = Colors.green;
    } else {
      color = Colors.red;
    }

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 24,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          // person icon on the left
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.indigo.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(Icons.person, color: Colors.indigo, size: 24),
          ),
          SizedBox(width: 16),
          // person name and date
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets(
                  text: record.personName,
                  color: Color(0xff111827),
                  fontSized: 16,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 4),
                TextWidgets(
                  text: "${record.date.day}/${record.date.month}/${record.date.year}",
                  color: Color(0xff9CA3AF),
                  fontSized: 13,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          // amount and type label on the right
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextWidgets(
                text: "Rs ${record.amount.toStringAsFixed(0)}",
                color: color,
                fontSized: 16,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 4),
              // show "You lent" or "You borrowed"
              if (isLend)
                TextWidgets(
                  text: "You lent",
                  color: Colors.green.withOpacity(0.7),
                  fontSized: 11,
                  fontWeight: FontWeight.w600,
                )
              else
                TextWidgets(
                  text: "You borrowed",
                  color: Colors.red.withOpacity(0.7),
                  fontSized: 11,
                  fontWeight: FontWeight.w600,
                ),
            ],
          ),
        ],
      ),
    );
  }
}
