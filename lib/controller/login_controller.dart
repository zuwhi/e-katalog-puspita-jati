import 'package:e_katalog/model/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
// Sesuaikan dengan path routing

class LoginController extends GetxController {
  // Controllers for the login fields
  final emailC = TextEditingController();
  final passwordC = TextEditingController();

  // Observables to handle the state
  var obscurePassword = true.obs;
  var isFormValid = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Listeners for form validation
    emailC.addListener(_validateForm);
    passwordC.addListener(_validateForm);
  }

  @override
  void onClose() {
    emailC.dispose();
    passwordC.dispose();
    super.onClose();
  }

  // Function to toggle password visibility
  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  // Email validation function
  String? validateEmail(String email) {
    if (email.isEmpty) {
      return 'Email cannot be empty';
    } else if (!GetUtils.isEmail(email)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // Password validation function
  String? validatePassword(String password) {
    if (password.isEmpty) {
      return 'Password cannot be empty';
    } else if (password.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // General form validation function
  void _validateForm() {
    if (validateEmail(emailC.text) == null &&
        validatePassword(passwordC.text) == null) {
      isFormValid.value = true;
    } else {
      isFormValid.value = false;
    }
  }

  // Login function
  void login() async {
    if (isFormValid.value) {
      UserModel loggedInUser = UserModel(
        id: "1",
        name: "Sample User",
        email: emailC.text,
        password: passwordC.text,
        role: "user",
        telepon: "",
      );
      Logger().d(loggedInUser.toJson());

      // final AuthController authController = Get.find();
      // authController.login(emailC.text, passwordC.text);

      // Redirect after successful login
      // Get.offAllNamed(AppRoute.home); // Sesuaikan dengan route home
    }
  }
}
