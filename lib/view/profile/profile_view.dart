// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/model/user_model.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find();
    TextEditingController nameController = TextEditingController();
    TextEditingController alamatController = TextEditingController();
    TextEditingController phoneController = TextEditingController();
    if (authController.isLoggedIn.value == AuthStatus.loggedIn) {
      nameController.text = authController.userAccount.value!.name ?? "";
      alamatController.text = authController.userAccount.value!.alamat ?? "";
      phoneController.text = authController.userAccount.value!.telepon ?? "";
    }

    return Obx(
      () => authController.isLoading.value
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : authController.isLoggedIn.value == AuthStatus.loggedIn
              ? Scaffold(
                  appBar: AppBar(
                    title: TextGelasio(text: "Profile"),
                    centerTitle: true,
                    backgroundColor: Colors.white,
                    actions: [
                      IconButton(
                          onPressed: () {
                            Get.dialog(Dialog(
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.0),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const SizedBox(
                                      height: 10.0,
                                    ),
                                    const Text(
                                      "Konfirmasi",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    const Text(
                                      "Apakah Anda yakin ingin logout?",
                                    ),
                                    const SizedBox(height: 24),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        SizedBox(
                                          width: 100,
                                          child: TextButton(
                                            onPressed: () {
                                              Navigator.pop(context);
                                            },
                                            child: TextPrimary(
                                              text: "Batal",
                                              color: AppColors.primary,
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 100,
                                          child: ButtonPrimary(
                                            text: "Iya",
                                            onPressed: () async {
                                              authController.logout();
                                            },
                                            isActive: true,
                                            backgroundColor: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ));
                          },
                          icon: const Icon(
                            Icons.logout,
                            color: AppColors.primary,
                          )),
                      const SizedBox(
                        width: 5.0,
                      ),
                    ],
                  ),
                  body: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.all(18.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Container(
                              height: 140,
                              width: 140,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              child: InkWell(
                                onTap: () {
                                  authController.pickImage();
                                },
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: authController.imageProfile.value !=
                                            null
                                        ? Image.file(
                                            authController.imageProfile.value!,
                                            fit: BoxFit.cover,
                                          )
                                        : authController
                                                    .userAccount.value!.image !=
                                                null
                                            ? CachedNetworkImage(
                                                imageUrl: authController
                                                        .userAccount
                                                        .value!
                                                        .image ??
                                                    "",
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                placeholder: (context, url) =>
                                                    const Center(
                                                  child: SizedBox(
                                                      height: 40,
                                                      width: 40,
                                                      child:
                                                          CircularProgressIndicator()),
                                                ),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              )
                                            : Image.asset(
                                                "assets/images/empty.jpg",
                                                fit: BoxFit.cover,
                                              )),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 30.0,
                          ),
                          TextPrimary(
                            text: "Nama ",
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                                hintText: "Nama",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                )),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextPrimary(
                            text: "Alamat ",
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          TextFormField(
                            controller: alamatController,
                            decoration: InputDecoration(
                                hintText: "Alamat",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                )),
                          ),
                          const SizedBox(
                            height: 20.0,
                          ),
                          TextPrimary(
                            text: "Telepon ",
                            fontSize: 17.0,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          TextFormField(
                            controller: phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                                hintText: "Telepon",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      const BorderSide(color: Colors.black),
                                )),
                          ),
                          const SizedBox(
                            height: 60.0,
                          ),
                          SizedBox(
                            height: 50,
                            child: ButtonPrimary(
                                rounded: 10,
                                isActive: true,
                                backgroundColor: AppColors.primary,
                                isLoading: authController.isLoading.value,
                                text: "Edit Profile",
                                onPressed: () async {
                                  UserModel updatedAccount = UserModel(
                                    id: authController.userAccount.value!.id,
                                    name: nameController.text,
                                    role:
                                        authController.userAccount.value!.role,
                                    telepon: phoneController.text,
                                    alamat: alamatController.text,
                                  );

                                  await authController
                                      .updateAccount(updatedAccount);
                                }),
                          )
                        ],
                      ),
                    ),
                  ),
                )
              : Scaffold(
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextPrimary(
                          text: "Anda Belum Login ",
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.primary,
                        ),
                        TextPrimary(
                          text: "Silahkan Login terlebih dahulu ",
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: AppColors.secondary,
                        ),
                        const SizedBox(
                          height: 20.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 28, vertical: 15),
                            side: const BorderSide(color: Colors.black38),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(AppRoute.login);
                          },
                          child: const Text("LOGIN"),
                        )
                      ],
                    ),
                  ),
                ),
    );
  }
}
