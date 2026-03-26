import 'package:flutter/material.dart';

// Ham Text() kullanma — her zaman bu widget'ı kullan
class ArabicText extends StatelessWidget {
  const ArabicText(
    this.text, {
    super.key,
    this.fontSize = 26.0,
    this.color,
    this.textAlign = TextAlign.right,
  });

  final String text;
  final double fontSize;
  final Color? color;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textDirection: TextDirection.rtl,
      textAlign: textAlign,
      style: TextStyle(
        fontSize: fontSize,
        height: 1.8, // hareke için kritik — 1.7 minimum
        color: color,
      ),
    );
  }
}
