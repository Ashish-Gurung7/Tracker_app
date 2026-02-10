import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TextWidgets extends StatelessWidget {
  final String text;
  final Color color;
  final double? fontSized;
  final FontWeight? fontWeight;
  
  const TextWidgets({super.key, required this.text,
  this.color = Colors.white,
  this.fontSized,
  this.fontWeight});

  @override
  Widget build(BuildContext context) {
    return Text(text,style: GoogleFonts.inter(
      color: color,
      fontSize: fontSized,
      fontWeight: fontWeight
    ), );
  }
}