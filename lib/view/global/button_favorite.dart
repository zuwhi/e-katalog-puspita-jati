import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class ButtonFavoriteController extends GetxController {
  RxBool isActive = false.obs;
}

class ButtonFavorite extends StatelessWidget {
  const ButtonFavorite(
      {super.key,
      required this.onPressed,
      this.backgroundColor,
      this.rounded,
      this.textColor = Colors.white,
      this.isActive = false});

  final void Function()? onPressed;
  final Color? backgroundColor;
  final double? rounded;

  final bool isActive;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    final ButtonFavoriteController controller =
        Get.put(ButtonFavoriteController());
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: () {
            controller.isActive.value = !controller.isActive.value;
          },
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isActive
                ? backgroundColor ?? Colors.grey[400]
                : Colors.grey[400],
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(rounded ?? 12),
            ),
          ),
          child: Obx(
            () => SvgPicture.asset(
              controller.isActive.value
                  ? "assets/images/favorite_active.svg"
                  : "assets/images/favorite_unactive.svg",
              height: 28,
            ),
          )),
    );
  }
}
