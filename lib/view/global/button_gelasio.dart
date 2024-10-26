import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:flutter/material.dart';

class ButtonGelasio extends StatelessWidget {
  const ButtonGelasio(
      {super.key,
      required this.text,
      required this.onPressed,
      this.backgroundColor = AppColors.primary,
      this.rounded,
      this.textColor = Colors.white,
      this.isActive = false});

  final void Function()? onPressed;
  final Color? backgroundColor;
  final double? rounded;
  final String text;
  final bool isActive;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: isActive
              ? backgroundColor ?? AppColors.primary
              : AppColors.primary,
          padding: const EdgeInsets.all(15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rounded ?? 3),
          ),
        ),
        child: TextGelasio(
          fontSize: 16.0,
          text: text,
          color: textColor,
        ),
      ),
    );
  }
}
