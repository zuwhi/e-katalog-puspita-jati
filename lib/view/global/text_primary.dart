// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class TextPrimary extends StatelessWidget {
  double? fontSize;
  FontWeight? fontWeight;
  Color? color;
  String text;
  TextAlign? textAlign;
  TextOverflow? overflow;
  int? maxLines;
  TextPrimary(
      {super.key,
      this.textAlign,
      required this.text,
      this.color,
      this.fontSize,
      this.fontWeight = FontWeight.normal,
      this.overflow,
      this.maxLines});

  @override
  Widget build(BuildContext context) {
    return Text(
      maxLines: maxLines,
      overflow: overflow,
      text,
      textAlign: textAlign,
      style: GoogleFonts.nunitoSans(
          fontSize: fontSize, fontWeight: fontWeight, color: color),
    );
  }
}
