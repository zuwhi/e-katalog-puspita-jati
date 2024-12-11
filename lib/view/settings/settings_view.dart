// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();

    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        backgroundColor: Colors.transparent,
        title: const Text("Settings"),
        actions: const [],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20.0,
            ),
            InkWell(
              onTap: () => Get.toNamed(AppRoute.profile),
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: const BoxDecoration(
                    color: AppColors.disable,
                    border: Border.symmetric(
                        horizontal: BorderSide(
                      color: AppColors.secondary,
                      width: 1,
                    ))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.person),
                        const SizedBox(
                          width: 10.0,
                        ),
                        TextPrimary(
                          text: "Profile",
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Obx(
              () => authController.userAccount.value?.role == "admin"
                  ? Column(
                      children: [
                        InkWell(
                          onTap: () => Get.toNamed(AppRoute.allCash),
                          child: Container(
                            width: double.infinity,
                            height: 60,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            decoration: const BoxDecoration(
                                color: AppColors.disable,
                                border: Border.symmetric(
                                    horizontal: BorderSide(
                                  color: AppColors.secondary,
                                  width: 1,
                                ))),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    const Icon(Icons.book),
                                    const SizedBox(
                                      width: 10.0,
                                    ),
                                    TextPrimary(
                                      text: "Buku Kas",
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ],
                                ),
                                const Icon(
                                  Icons.arrow_forward_ios,
                                )
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                      ],
                    )
                  : Container(),
            ),
            InkWell(
              onTap: () => Get.toNamed(AppRoute.about),
              child: Container(
                width: double.infinity,
                height: 60,
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                decoration: const BoxDecoration(
                    color: AppColors.disable,
                    border: Border.symmetric(
                        horizontal: BorderSide(
                      color: AppColors.secondary,
                      width: 1,
                    ))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info),
                        const SizedBox(
                          width: 10.0,
                        ),
                        TextPrimary(
                          text: "Tentang Perusahaan",
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
