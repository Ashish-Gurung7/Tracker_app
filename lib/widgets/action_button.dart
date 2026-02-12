import 'package:flutter/material.dart';
import 'package:tracker_app/widgets/text_widgets.dart';

class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Column(
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: Color(0xffEEF2F7),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.transparent),
            ),
            child: Icon(icon, color: Color(0xff2F7E79)),
          ),
          SizedBox(height: 8),
          TextWidgets(
            text: label,
            color: Color(0xff111827),
            fontSized: 13,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}
