import 'package:flutter/material.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Text Editing Controllers
  final TextEditingController nameC = TextEditingController();
  final TextEditingController emailC = TextEditingController();
  final TextEditingController teleponC = TextEditingController();
  final TextEditingController alamatC = TextEditingController();
  final TextEditingController passwordC = TextEditingController();
  final TextEditingController confirmPasswordC = TextEditingController();

  // Observable variables for form validation and obscure text toggle
  var isNameValid = false.obs;
  var isEmailValid = false.obs;
  var isPasswordValid = false.obs;
  var isConfirmPasswordValid = false.obs;
  var isPasswordMatch = true.obs;
  var isFormValid = false.obs;

  var obscurePassword = true.obs; // Password obscure toggle
  var obscureConfirmPassword = true.obs; // Confirm password obscure toggle

  // Function to toggle obscure text
  void toggleObscurePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  void toggleObscureConfirmPassword() {
    obscureConfirmPassword.value = !obscureConfirmPassword.value;
  }

  // Function to validate individual fields
  void validateName(String value) {
    isNameValid.value = value.isNotEmpty;
    validateForm();
  }

  void validateEmail(String value) {
    isEmailValid.value = value.isNotEmpty && value.contains('@');
    validateForm();
  }

  void validatePassword(String value) {
    isPasswordValid.value = value.isNotEmpty && value.length >= 8;
    checkPasswordMatch();
    validateForm();
  }

  void validateConfirmPassword(String value) {
    isConfirmPasswordValid.value = value.isNotEmpty;
    checkPasswordMatch();
    validateForm();
  }

  // Function to check if password and confirm password match
  void checkPasswordMatch() {
    isPasswordMatch.value = passwordC.text == confirmPasswordC.text;
  }

  // Function to validate the entire form
  void validateForm() {
    isFormValid.value = isNameValid.value &&
        isEmailValid.value &&
        isPasswordValid.value &&
        isConfirmPasswordValid.value &&
        isPasswordMatch.value;
  }
}
