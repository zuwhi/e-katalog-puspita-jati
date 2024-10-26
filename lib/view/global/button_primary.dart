import 'package:e_katalog/constant/app_colors.dart';
import 'package:flutter/material.dart';

class ButtonPrimary extends StatelessWidget {
  const ButtonPrimary(
      {super.key,
      required this.text,
      required this.onPressed,
      this.backgroundColor,
      this.rounded,
      this.isLoading = false,
      this.textColor = Colors.white,
      this.isActive = false});

  final void Function()? onPressed;
  final Color? backgroundColor;
  final double? rounded;
  final String text;
  final bool isActive;
  final Color? textColor;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isActive ? onPressed : null,
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor:
              isActive ? backgroundColor ?? Colors.grey[400] : Colors.grey[400],
          padding: const EdgeInsets.all(12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(rounded ?? 12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 25,
                width: 25,
                child: CircularProgressIndicator(
                  color: AppColors.tertiary,
                ))
            : Text(
                text,
                style: TextStyle(
                  fontSize: 16.0,
                  color: textColor,
                ),
              ),
      ),
    );
  }
}
