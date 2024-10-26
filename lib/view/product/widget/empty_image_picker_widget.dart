import 'package:dotted_border/dotted_border.dart';
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EmptyImagePicker extends StatelessWidget {
  const EmptyImagePicker({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      dashPattern: const [8, 5],
      color: Colors.grey,
      borderType: BorderType.RRect,
      radius: const Radius.circular(12),
      padding: const EdgeInsets.all(6),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(12)),
        child: SizedBox(
          height: 180,
          width: double.infinity,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/images/upload.svg"),
                const SizedBox(
                  height: 10.0,
                ),
                TextPrimary(
                  text: "Upload Image",
                  fontSize: 17.0,
                  color: AppColors.secondary,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
