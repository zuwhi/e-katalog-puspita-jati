// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/about_controller.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/controller/launch_url.dart';
import 'package:e_katalog/model/about_model.dart';
import 'package:e_katalog/view/about/about_admin_section.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class AboutView extends StatelessWidget {
  const AboutView({super.key});

  @override
  Widget build(BuildContext context) {
    final AboutController controller = Get.put(AboutController());
    controller.getAboutDesc();

    final AboutModel? about = controller.aboutModelDesc.value;

    final LaunchUrl urlController = Get.put(LaunchUrl());
    final AuthController authController = Get.find();
    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : authController.userAccount.value?.role == "admin"
                ? AboutAdminSection(
                    controller: controller,
                  )
                : SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20.0,
                          ),
                          Center(
                            child: TextGelasio(
                              text: about?.title ?? "",
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          Center(
                            child: TextGelasio(
                              text: "Deskripsi :",
                              fontSize: 17.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width - 20,
                            child: TextPrimary(
                              textAlign: TextAlign.justify,
                              text: about?.desc ?? "",
                              fontSize: 16.0,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Column(
                              children: [
                                TextGelasio(
                                  text: "Contact Kami :",
                                  fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      color: AppColors.secondary,
                                      Icons.phone,
                                      size: 32,
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Clipboard.setData(ClipboardData(
                                                text: about?.telepon ?? ""));
                                            Get.snackbar("Berhasil",
                                                "Nomor Telepon berhasil disalin");
                                          },
                                          child: SizedBox(
                                            child: TextPrimary(
                                              text: about?.telepon ?? "",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        TextPrimary(
                                          text: "telepon",
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      color: AppColors.secondary,
                                      Icons.email,
                                      size: 32,
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Clipboard.setData(ClipboardData(
                                                text: about?.email ?? ""));
                                            Get.snackbar("Berhasil",
                                                "Alamat Email berhasil disalin");
                                          },
                                          child: SizedBox(
                                            child: TextPrimary(
                                              text: about?.email ?? "",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        TextPrimary(
                                          text: "email",
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      color: AppColors.secondary,
                                      Icons.location_on,
                                      size: 32,
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Clipboard.setData(ClipboardData(
                                                text: about?.alamat ?? ""));
                                            Get.snackbar("Berhasil",
                                                "Alamat berhasil disalin");
                                          },
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: TextPrimary(
                                              text: about?.alamat ?? "",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        TextPrimary(
                                          text: "alamat",
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                                Row(
                                  children: [
                                    const Icon(
                                      color: AppColors.secondary,
                                      Icons.link,
                                      size: 32,
                                    ),
                                    const SizedBox(
                                      width: 15.0,
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            Clipboard.setData(ClipboardData(
                                                text: about?.website ?? ""));
                                            Get.snackbar("Berhasil",
                                                "Alamat Website berhasil disalin");
                                          },
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                100,
                                            child: TextPrimary(
                                              text: about?.website ?? "",
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                        TextPrimary(
                                          text: "website",
                                          fontSize: 16.0,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 20.0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}
