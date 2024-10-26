import 'dart:io' as io;

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/model/user_model.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

enum AuthStatus { loggedIn, notLoggedIn, loading, error }

class AuthController extends GetxController {
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  RxBool isLoading = false.obs;
  RxBool loginButtonActive = false.obs;
  RxBool signUpButtonActive = false.obs;
  final userAccount = Rx<UserModel?>(null);
  final imageProfile = Rx<io.File?>(null);
  RxString nomorAdmin = ''.obs;

  // RxBool isLoggedIn = false.obs;
  final isLoggedIn = Rx<AuthStatus>(AuthStatus.loading);

  @override
  void onInit() {
    super.onInit();
    checkLoginStatus();
  }

  Future<void> checkLoginStatus() async {
    try {
      isLoading.value = true;
      final User account = await _appwriteService.account.get();

      if (account.email.isEmpty) {
        isLoggedIn.value = AuthStatus.notLoggedIn;
      } else {
        await getUserData(account.$id);
        isLoggedIn.value = AuthStatus.loggedIn;
      }
    } on AppwriteException catch (e) {
      if (e.code == 401) {
        isLoggedIn.value = AuthStatus.notLoggedIn;
      } else {
        Get.snackbar("Gagal memuat account", "Periksa koneksi internet anda");
      }
    } catch (e) {
      Get.snackbar("Gagal memuat account", "Periksa koneksi internet anda");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getUserData(String userId) async {
    try {
      final UserModel data = await _appwriteService.getUserDocument(userId);

      userAccount.value = data;
    } catch (e) {
      print('Error getting user data: $e');
    }
  }

  Future<void> login(String email, String password) async {
    isLoading.value = true;
    try {
      final Session session = await _appwriteService.createSession(
          email: email, password: password);
      isLoggedIn.value = AuthStatus.loggedIn;
      await getUserData(session.userId);
      Get.snackbar('Success', 'Logged in successfully');

      Get.offAllNamed(AppRoute.nav);
    } catch (e) {
      Logger().d(e);
      Get.snackbar('Terjadi kesalahan', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> register(UserModel createdAccount) async {
    isLoading.value = true;

    try {
      final account = await _appwriteService.createAccount(
          email: createdAccount.email!, password: createdAccount.password!);
      Logger().d(account);

      await _appwriteService.createUserDocument(account.$id, createdAccount);

      Get.snackbar('Berhasil', 'Akun berhasil dibuat silahkan login');
      Get.offNamedUntil(
        AppRoute.login,
        (route) => false,
      );
    } catch (e) {
      Logger().d(e);
      Get.snackbar('Terjadi kesalahan', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> logout() async {
    try {
      isLoading.value = true;
      await _appwriteService.logout();
      isLoggedIn.value = AuthStatus.notLoggedIn;
      userAccount.value = null;
      Get.offAllNamed(AppRoute.login);
    } catch (e) {
      Get.snackbar('Error', 'Failed to logout: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateAccount(UserModel updatedAccount) async {
    try {
      isLoading.value = true;
      await _appwriteService.updateUserDocument(
          updatedAccount, imageProfile.value);
      getUserData(updatedAccount.id!);
      Get.snackbar('Success', 'Account updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update account: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage() async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageProfile.value = io.File(pickedFile.path);
      }
    } catch (e) {
      imageProfile.value = null;
    }
  }
}
