import 'package:e_katalog/model/about_model.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:get/get.dart';

class AboutController extends GetxController {
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  final aboutModelDesc = Rx<AboutModel?>(null);
  RxBool isLoading = false.obs;

  Future<void> getAboutDesc() async {
    isLoading.value = true;
    if (aboutModelDesc.value != null) {
      isLoading.value = false;
      return;
    }
    final result = await _appwriteService.getAboutDesc();
    if (result.isSuccess) {
      aboutModelDesc.value = AboutModel.fromMap(result.resultValue);
    } else {
      Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    }
    isLoading.value = false;
  }

  Future<void> updateAboutDesc(AboutModel aboutModel) async {
    isLoading.value = true;
    final result = await _appwriteService.updateAboutDesc(aboutModel);
    if (result.isSuccess) {
      getAboutDesc(); 
      Get.snackbar("Success", "Berhasil mengubah profile");
    } else {
      Get.snackbar("Terjadi kesalahan", "periksa koneksi anda");
    }
    isLoading.value = false;
  }
}
