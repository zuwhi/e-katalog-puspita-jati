import 'dart:io';

import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/model/product_image_model.dart';
import 'package:e_katalog/model/product_model.dart';
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

class EditProductController extends GetxController {
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  TextEditingController productNameController = TextEditingController();
  TextEditingController productPriceController = TextEditingController();
  TextEditingController productEstimatedController = TextEditingController();
  TextEditingController productDescriptionController = TextEditingController();
  var imageFiles = List<dynamic>.filled(3, null).obs;
  var currentIndex = 0.obs;
  RxBool isLoading = false.obs;
  RxString productId = "".obs;
  RxString bucket1 = "".obs;
  RxString bucket2 = "".obs;
  RxString bucket3 = "".obs;

  
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

  void fillControllers(ProductModel product) {
    productId.value = product.id;
    productNameController.text = product.title;
    productPriceController.text = product.price.toString();
    productEstimatedController.text = product.estimate;
    productDescriptionController.text = product.desc;
    imageFiles[0] = product.image1;
    imageFiles[1] = product.image2;
    imageFiles[2] = product.image3;
    selectedColors.value = product.color!.split(", ");
    selectedCategory.value = product.category;
    bucket1.value = product.bucket1 ?? "";
    bucket2.value = product.bucket2 ?? "";
    bucket3.value = product.bucket3 ?? "";
  }

  @override
  void onClose() {
    productNameController.dispose();
    productPriceController.dispose();
    productEstimatedController.dispose();
    productDescriptionController.dispose();
    super.onClose();
  }

  Future<void> editProduct() async {
    try {
      isLoading.value = true;
      ProductModel productModel = ProductModel(
        id: productId.value,
        title: productNameController.text,
        desc: productDescriptionController.text,
        price: int.parse(productPriceController.text),
        date: DateFormat('yyyy-MM-dd').format(DateTime.now()),
        category: selectedCategory.value,
        color: selectedColors.join(", "),
        estimate: productEstimatedController.text,
        bucket1: bucket1.value,
        bucket2: bucket2.value,
        bucket3: bucket3.value,
      );
      ProductImageModel productImageModel = ProductImageModel(
        image1: imageFiles[0] is File ? imageFiles[0] : null,
        image2: imageFiles[1] is File ? imageFiles[1] : null,
        image3: imageFiles[2] is File ? imageFiles[2] : null,
      );

      final bool result =
          await _appwriteService.updateProduct(productModel, productImageModel);

      if (result) {
        Get.snackbar("berhasil", "berhasil mengubah data product");
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
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  void removeImage(int index) {
    imageFiles[index] = null;
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
