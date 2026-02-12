import 'package:flutter/material.dart';
import 'package:tracker_app/widgets/text_widgets.dart';

class SmallStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const SmallStat({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextWidgets(
                text: label,
                color: Colors.grey.shade500,
                fontSized: 11,
                fontWeight: FontWeight.w600,
              ),
              SizedBox(height: 2),
              TextWidgets(
                text: value,
                color: Color(0xff111827),
                fontSized: 14,
                fontWeight: FontWeight.w700,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
