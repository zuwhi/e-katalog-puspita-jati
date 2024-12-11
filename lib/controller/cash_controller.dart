import 'dart:io';

import 'package:e_katalog/model/cash_model.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class CashController extends GetxController {
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  RxList<CashModel> cash = <CashModel>[].obs;
  RxBool isLoading = false.obs;
  final selectedCategory = RxnString();

  Future<void> getAllCash() async {
    isLoading.value = true;
    final result = await _appwriteService.getAllCash();
    if (result.isSuccess) {
      cash.value = result.resultValue;
    } else {
      Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    }
    isLoading.value = false;
  }

  var selectedImage = Rx<File?>(null);
  Future<void> pickImage(ImageSource source) async {
    try {
      final picker = ImagePicker();
      final pickedFile =
          await picker.pickImage(source: source, imageQuality: 90);

      if (pickedFile != null) {
        selectedImage.value = File(pickedFile.path);
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Gagal mengambil gambar: $e');
    }
  }

  Future<void> addCash(CashModel cash) async {
    isLoading.value = true;

    final result = await _appwriteService.addCash(cash, selectedImage.value);
    if (result.isSuccess) {
      getAllCash();
      selectedImage.value = null;
      Get.snackbar("Success", "Berhasil menambahkan catatan kas");
      Navigator.pop(Get.context!);
      //  String bulan = cash.tanggal!.substring(0, 7);
      // Get.offAll(() => CashDetailScreen(bulan: bulan));
    } else {
      Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    }
    isLoading.value = false;
  }

  Future<void> deleteCash(CashModel cash) async {
    isLoading.value = true;
    final result =
        await _appwriteService.deleteCash(cash.id ?? "", cash.bucket);
    if (result.isSuccess) {
      getAllCash();
      Get.back();
      Get.snackbar("Success", "Berhasil menghapus catatan kas");
    } else {
      Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    }
    isLoading.value = false;
  }
}
