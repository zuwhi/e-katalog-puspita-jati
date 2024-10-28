import 'dart:io';

import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/model/product_image_model.dart';
import 'package:e_katalog/model/product_model.dart';
import 'package:e_katalog/service/ai_service.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PickedColor {
  final int id;
  final String name;

  PickedColor({
    required this.id,
    required this.name,
  });
}

class SetProductController extends GetxController {
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productEstimatedController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  var imageFiles = List<File?>.filled(3, null).obs;
  var currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxBool isLoadingOnDesc = false.obs;

  @override
  void onClose() {
    // Dispose of controllers to prevent memory leaks
    productNameController.dispose();
    productPriceController.dispose();
    productEstimatedController.dispose();
    productDescriptionController.dispose();
    super.onClose();
  }

  Future<void> addProduct() async {
    try {
      isLoading.value = true;
      ProductModel productModel = ProductModel(
        id: "",
        title: productNameController.text,
        desc: productDescriptionController.text,
        price: int.parse(productPriceController.text),
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        category: selectedCategory.value,
        color: selectedColors.join(", "),
        estimate: productEstimatedController.text,
      );
      ProductImageModel productImageModel = ProductImageModel(
        image1: imageFiles[0],
        image2: imageFiles[1],
        image3: imageFiles[2],
      );
      bool result =
          await _appwriteService.addProduct(productModel, productImageModel);
      if (result) {
        Get.snackbar("success", "product berhasil ditambahkan :)");
        dispose();
        Get.offAllNamed(AppRoute.nav);
      }
    } catch (e) {
      Get.snackbar("terjadi kesalahan", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteProduct(String documentId) async {
    try {
      isLoading.value = true;
      await _appwriteService.deleteProduct(documentId);
      Get.offAllNamed(AppRoute.nav);
    } catch (e) {
      rethrow;
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> pickImage(int index) async {
    try {
      final pickedFile =
          await ImagePicker().pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        imageFiles[index] = File(pickedFile.path);
      }
    } catch (e) {}
  }

  Future<void> descWithAI() async {
    try {
      isLoadingOnDesc.value = true;
      String prompt =
          "saya punya jasa finishing furniture, tolong buatkan saya satu pargraf saja yang akan tampilkan di akun online shop jasa saya untuk finishing tentang produk saya yaitu ${productNameController.text}, tolong jawab langsung pargrafnya dan jangn sertakan simbol apapun pada pargraf ";
      AIService aiService = AIService();
      String? result = await aiService.sendRequest(prompt);
      productDescriptionController.text = result ?? '';
    } catch (e) {
      Get.snackbar("gagal", "Maaf terjadi kesalahan");
    } finally {
      isLoadingOnDesc.value = false;
    }
  }

  void removeImage(int index) {
    imageFiles[index] = null;
  }

  var selectedColors = <String>[].obs;

  var availableColors = <String>[].obs;

  // Fungsi untuk menambahkan atau menghapus warna dari daftar pilihan
  void toggleColor(String color) {
    if (selectedColors.contains(color)) {
      selectedColors.remove(color);
    } else {
      selectedColors.add(color);
   
    }
  }

  final List<String> colors = [
    "coklat",
    "silver",
    "emas",
    "hitam",
    "putih",
  ];

  final List<String> categories = [
    "all",
    "kursi",
    "meja",
    "sofa",
    "lemari",
    "bed"
  ];
  RxString selectedCategory = "all".obs;
}
