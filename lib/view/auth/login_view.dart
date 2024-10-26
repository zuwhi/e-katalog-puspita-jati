import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/controller/login_controller.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class LoginView extends StatelessWidget {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());
    final AuthController authController = Get.put(AuthController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50.0),
              Center(
                child: SvgPicture.asset(
                  "assets/images/border.svg",
                  height: 70,
                  width: MediaQuery.of(context).size.width,
                  fit: BoxFit.fill,
                ),
              ),
              const SizedBox(height: 15.0),
              TextGelasio(
                fontSize: 27.0,
                text: "Hello !",
                color: AppColors.secondary,
              ),
              TextGelasio(
                fontSize: 27.0,
                text: "WELCOME BACK",
                color: AppColors.primary,
              ),
              const SizedBox(height: 35.0),
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(3),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFa0a0a0).withOpacity(0.35),
                      offset: const Offset(1, 2),
                      blurRadius: 4,
                      spreadRadius: 0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: controller.emailC,
                      onChanged: (value) => controller.validateEmail(value),
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Color(0xFFa0a0a0)),
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.tertiary)),
                        enabledBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: AppColors.tertiary)),
                      ),
                    ),
                    const SizedBox(height: 30.0),
                    Obx(() => TextFormField(
                          controller: controller.passwordC,
                          obscureText: controller.obscurePassword.value,
                          onChanged: (value) =>
                              controller.validatePassword(value),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                const TextStyle(color: Color(0xFFa0a0a0)),
                            focusedBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.tertiary)),
                            enabledBorder: const UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: AppColors.tertiary)),
                            suffixIcon: IconButton(
                              icon: Icon(
                                controller.obscurePassword.value
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: controller.toggleObscurePassword,
                            ),
                          ),
                        )),
                    const SizedBox(height: 30.0),
                    const SizedBox(height: 80.0),
                    Obx(() => SizedBox(
                          height: 48,
                          child: ButtonPrimary(
                            isLoading: authController.isLoading.value,
                            onPressed: () {
                              authController.login(controller.emailC.text,
                                  controller.passwordC.text);
                            },
                            isActive: controller.isFormValid.value,
                            text: "Log In",
                            textColor: Colors.white,
                            backgroundColor: controller.isFormValid.value
                                ? AppColors.primary
                                : Colors.grey,
                            rounded: 8,
                          ),
                        )),
                    const SizedBox(height: 20.0),
                    InkWell(
                      onTap: () {
                        Get.offAllNamed(AppRoute.register);
                      },
                      child: TextPrimary(
                        text: "SIGN UP",
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 7.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
