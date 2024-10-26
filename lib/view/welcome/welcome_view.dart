// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/view/global/button_gelasio.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeView extends StatelessWidget {
  const WelcomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            "assets/images/welcome.png",
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
            top: 220,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextGelasio(
                      fontSize: 25.0,
                      text: "PUSPITA",
                      color: AppColors.primary,
                    ),
                    TextGelasio(
                      fontSize: 25.0,
                      text: "JATI FURNITURE",
                      color: AppColors.secondary,
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const Padding(
                      padding: EdgeInsets.only(left: 45),
                      child: SizedBox(
                        width: 300,
                        child: Text(
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                height: 2,
                                fontSize: 18.0,
                                color: AppColors.secondary),
                            "The best simple place where you discover most wonderful furnitures and make your home beautiful"),
                      ),
                    )
                  ]),
            )),
        Positioned(
            left: 0,
            right: 0,
            bottom: 100,
            child: Center(
              child: SizedBox(
                width: 130,
                height: 50,
                child: ButtonGelasio(
                  isActive: true,
                  text: "Get Started",
                  onPressed: () {
                    Get.toNamed(AppRoute.login);
                  },
                ),
              ),
            ))
      ],
    ));
  }
}
