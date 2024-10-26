// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/about_controller.dart';
import 'package:e_katalog/model/about_model.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_form_primary.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AboutAdminSection extends StatelessWidget {
  final AboutController controller;
  const AboutAdminSection({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final AboutModel? aboutModel = controller.aboutModelDesc.value;

    final TextEditingController titleController =
        TextEditingController(text: aboutModel?.title ?? '');
    final TextEditingController teleponController =
        TextEditingController(text: aboutModel?.telepon ?? '');
    final TextEditingController emailController =
        TextEditingController(text: aboutModel?.email ?? '');
    final TextEditingController websiteController =
        TextEditingController(text: aboutModel?.website ?? '');
    final TextEditingController alamatController =
        TextEditingController(text: aboutModel?.alamat ?? '');
    final TextEditingController descController =
        TextEditingController(text: aboutModel?.desc ?? '');
    final TextEditingController koordinatController =
        TextEditingController(text: aboutModel?.koordinat ?? '');

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Center(
              child: TextGelasio(
                text: "Ubah Profile",
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            Center(
              child: TextGelasio(
                text: "Perusahaan",
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextFormPrimary(
                      title: "Judul",
                      controller: titleController,
                      hintText: "masukkan judul"),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormPrimary(
                      title: "Telepon",
                      controller: teleponController,
                      hintText: "masukkan nomor telepon di awali dengan +62"),
                  const SizedBox(
                    height: 5.0,
                  ),
                  const Text(
                    "* nomor telepon ini yang akan dihubungi oleh costumer",
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontSize: 10.0,
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormPrimary(
                      title: "Email",
                      controller: emailController,
                      hintText: "masukkan nomor email"),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormPrimary(
                      title: "Website",
                      controller: websiteController,
                      hintText: "masukkan nomor website"),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormPrimary(
                      title: "Alamat",
                      controller: alamatController,
                      hintText: "masukkan nomor alamat"),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormPrimary(
                      title: "Url Google maps",
                      controller: koordinatController,
                      hintText: "masukkan nomor koordinat"),
                  const SizedBox(
                    height: 20.0,
                  ),
                  TextFormPrimary(
                      title: "Deskripsi",
                      controller: descController,
                      hintText: "masukkan deskripsi"),
                  const SizedBox(
                    height: 25.0,
                  ),
                  Obx(
                    () => ButtonPrimary(
                        text: "Ubah Profile",
                        isActive: true,
                        isLoading: controller.isLoading.value,
                        backgroundColor: AppColors.primary,
                        onPressed: () {
                          AboutModel aboutModelEdited = AboutModel(
                            id: aboutModel?.id,
                            title: titleController.text,
                            telepon: teleponController.text,
                            email: emailController.text,
                            website: websiteController.text,
                            alamat: alamatController.text,
                            desc: descController.text,
                            koordinat: koordinatController.text,
                          );

                          controller.updateAboutDesc(aboutModelEdited);
                        }),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
