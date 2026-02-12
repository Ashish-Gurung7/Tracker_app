import 'package:flutter/material.dart';
import 'package:tracker_app/models/transaction_model.dart';
import 'package:tracker_app/widgets/text_widgets.dart';

// this widget shows a single transaction item in a list
class TransactionTile extends StatelessWidget {
  final TransactionModel transaction;
  final VoidCallback? onTap;

  const TransactionTile({
    super.key,
    required this.transaction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // check if this is income or expense
    bool isIncome = transaction.type == TransactionType.income;

    // set color based on type
    Color color;
    if (isIncome) {
      color = Colors.green;
    } else {
      color = Colors.red;
    }

    // set icon based on type  
    IconData icon;
    if (isIncome) {
      icon = Icons.arrow_downward; // arrow down for income (money coming in)
    } else {
      icon = Icons.arrow_upward; // arrow up for expense (money going out)
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
          // icon container on the left
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 16),
          // description and date in the middle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextWidgets(
                  text: transaction.description,
                  color: Color(0xff111827),
                  fontSized: 16,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: 4),
                TextWidgets(
                  text: "${transaction.date.day}/${transaction.date.month}/${transaction.date.year}",
                  color: Color(0xff9CA3AF),
                  fontSized: 13,
                  fontWeight: FontWeight.w500,
                ),
              ],
            ),
          ),
          // amount and label on the right side
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              TextWidgets(
                text: "${isIncome ? '+' : '-'}Rs ${transaction.amount.toStringAsFixed(0)}",
                color: color,
                fontSized: 16,
                fontWeight: FontWeight.w800,
              ),
              SizedBox(height: 4),
              // show "Income" or "Expense" label
              if (isIncome)
                TextWidgets(
                  text: "Income",
                  color: Colors.grey.shade400,
                  fontSized: 11,
                  fontWeight: FontWeight.w500,
                )
              else
                TextWidgets(
                  text: "Expense",
                  color: Colors.grey.shade400,
                  fontSized: 11,
                  fontWeight: FontWeight.w500,
                )
            ],
          ),
        ],
      ),
    );
  }
}
