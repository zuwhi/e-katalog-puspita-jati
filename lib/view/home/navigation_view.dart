// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/controller/navigation_controller.dart';
import 'package:e_katalog/view/about/about_view.dart';
import 'package:e_katalog/view/cart/cart_view.dart';
import 'package:e_katalog/view/colors/colors_view.dart';
import 'package:e_katalog/view/home/home_view.dart';
import 'package:e_katalog/view/profile/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NavigationView extends StatelessWidget {
  const NavigationView({super.key});

  @override
  Widget build(BuildContext context) {
    final NavigationController controller = Get.put(NavigationController());
    // final NavigationController controller = Get.find();
    final AuthController authController = Get.find();
    final arg = Get.arguments;

    if (arg != null) {
      final int pageIndex = arg["page"];
      controller.currentView.value = pageIndex;
    }

    return Container(
      color: Colors.white,
      child: Obx(
        () => SafeArea(
          child: authController.isLoading.value ||
                  authController.userAccount.value == null
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Obx(() {
                    switch (controller.currentView.value) {
                      case 0:
                        return const HomeView();
                      case 1:
                        return authController.userAccount.value!.role == "admin"
                            ? const ColorsView()
                            : const CartView();
                      case 2:
                        return const AboutView();
                      case 3:
                        return const ProfileView();

                      default:
                        return const ProfileView();
                    }
                  }),
                  bottomNavigationBar: Obx(
                      () => authController.userAccount.value!.role == "admin"
                          ? BottomNavigationBar(
                              backgroundColor: Colors.white,
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.home),
                                  label: 'Home',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.color_lens),
                                  label: 'Colors',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.store),
                                  label: 'about',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.person),
                                  label: 'Profile',
                                ),
                              ],
                              currentIndex: controller.currentView.value,
                              unselectedIconTheme: const IconThemeData(
                                color: AppColors.tertiary,
                              ),
                              selectedItemColor: AppColors.primary,
                              onTap: (index) {
                                controller.currentView.value = index;
                              },
                            )
                          : BottomNavigationBar(
                              unselectedIconTheme: const IconThemeData(
                                color: AppColors.stroke,
                              ),
                              backgroundColor: Colors.white,
                              items: const <BottomNavigationBarItem>[
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.home),
                                  label: 'Home',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.shopping_cart),
                                  label: 'Keranjang',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.store),
                                  label: 'about',
                                ),
                                BottomNavigationBarItem(
                                  icon: Icon(Icons.person),
                                  label: 'Profile',
                                ),
                              ],
                              currentIndex: controller.currentView.value,
                              selectedItemColor: AppColors.primary,
                              onTap: (index) {
                                controller.currentView.value = index;
                              },
                            )),
                ),
        ),
      ),
    );
  }
}
