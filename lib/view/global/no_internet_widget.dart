import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';

class NoInternetWidget extends StatelessWidget {
  const NoInternetWidget({super.key, required this.onPressed});
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextPrimary(
          text: "Terjadi Kesalahan",
          fontSize: 20.0,
        ),
        TextPrimary(
          text: "Periksa Koneksi Anda",
          fontSize: 20.0,
        ),
        const SizedBox(
          height: 10.0,
        ),
        IconButton(
            onPressed: onPressed,
            icon: const Icon(
              Icons.refresh,
              size: 50,
              color: AppColors.teal,
            )),
        const SizedBox(
          height: 10.0,
        ),
      ],
    );
  }
}
