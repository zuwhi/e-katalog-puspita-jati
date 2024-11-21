import 'package:e_katalog/model/colors_model.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ColorsController extends GetxController {
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  final colorsModel = Rx<List<ColorsModel?>>([]);
  var selectedColors = <String>[].obs;
  RxBool isLoading = false.obs;

  void addColor(Color color) {
    selectedColors.add(colorToHex(color));
  }

  void removeColor(int index) {
    selectedColors.removeAt(index);
  }

  String colorToHex(Color color) {
    return '#${color.value.toRadixString(16).padLeft(8, '0').toUpperCase()}';
  }

  Future<void> getColorsList() async {
    isLoading.value = true;

    final result = await _appwriteService.getColorsList();
    if (result.isSuccess) {
      colorsModel.value = result.resultValue;
    } else {
      Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    }
    isLoading.value = false;
  }

  Future<void> addColorToList(ColorsModel colors) async {
    isLoading.value = true;
    final result = await _appwriteService.addColors(colors);
    if (result.isSuccess) {
      await getColorsList();
      Get.snackbar("Success", "Berhasil menambahkan warna");
    } else {
      Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    }
    isLoading.value = false;
  }

  Future<void> deleteColor(ColorsModel colors) async {
    isLoading.value = true;
    final result = await _appwriteService.deleteColor(colors.id ?? "");
    if (result.isSuccess) {
      await getColorsList();
      Get.snackbar("Success", "Berhasil menghapus warna");
    } else {
      Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    }
    isLoading.value = false;
  }

  Future<void> updateColor() async {
    isLoading.value = true;
    print(selectedColors);
    Logger().d(selectedColors);
    // final result = await _appwriteService.updateColors(
    //     colorsModel.value!.id ?? "", selectedColors.join(", "));
    // if (result.isSuccess) {
    //   await getColorsList();
    //   Get.snackbar("Success", "Berhasil mengubah warna");
    // } else {
    //   Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    // }
    isLoading.value = false;
  }
}
