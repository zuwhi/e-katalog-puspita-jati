import 'package:e_katalog/constant/app_colors.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TextFormPrimary extends StatelessWidget {
  TextFormPrimary({
    super.key,
    this.focusNode,
    this.onChanged,
    this.controller,
    required this.title,
    required this.hintText,
    this.keyboardType,
    this.minLines = 1, // Tambahkan minLines
    this.maxLines, // Tambahkan maxLines
  });

  final TextEditingController? controller;
  final String title;
  final String hintText;
  final TextInputType? keyboardType;
  final int? minLines;
  final int? maxLines; // Tambahkan maxLines
  void Function(String)? onChanged;
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: AppColors.disable,
        borderRadius: BorderRadius.all(Radius.circular(4)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 3),
      child: TextFormField(
        onChanged: onChanged,
        keyboardType: keyboardType,
        focusNode: focusNode,
        controller: controller,
        minLines: minLines,
        maxLines: maxLines,
   
        decoration: InputDecoration(
          labelText: title,
          labelStyle: TextStyle(
            color: Colors.grey[700],
            fontSize: 16.0,
          ),
          hintText: hintText,
          hintStyle: const TextStyle(
            color: Colors.grey,
            fontStyle: FontStyle.italic,
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 10),
        ),
      ),
    );
  }
}
