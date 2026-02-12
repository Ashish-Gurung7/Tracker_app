import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// reusable text widget so we dont have to write Text() with style everywhere
class TextWidgets extends StatelessWidget {
  final String text;
  final Color color;
  final double? fontSized;
  final FontWeight? fontWeight;

  // constructor with default white color
  const TextWidgets({
    super.key,
    required this.text,
    this.color = Colors.white,
    this.fontSized,
    this.fontWeight,
  });

  @override
  Widget build(BuildContext context) {
    // using google fonts inter for nice looking text
    return Text(
      text,
      style: GoogleFonts.inter(
        color: color,
        fontSize: fontSized,
        fontWeight: fontWeight,
      ),
    );
  }
}