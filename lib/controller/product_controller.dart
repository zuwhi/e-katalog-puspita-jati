import 'package:e_katalog/model/product_model.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class ProductController extends GetxController {
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  final RxList<ProductModel> listProducts = <ProductModel>[].obs;
  RxInt categoryIndex = 1.obs;
  RxBool isLoading = false.obs;

  Future<void> getListProduct() async {
    try {
      isLoading.value = true;
      final data = await _appwriteService.getProduct();
      if (data != null) {
        listProducts.value = data;
      }
    } catch (e) {
      Logger().d(e);
      Get.snackbar('terjadi kesalahan', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getListProductByCategory() async {
    try {
      isLoading.value = true;
      String category = getCategoryName(categoryIndex.value);

      final data = await _appwriteService.getProductByCategory(category);
      if (data != null) {
        listProducts.value = data;
      }
    } catch (e) {
      Logger().d(e);
      Get.snackbar('terjadi kesalahan', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  String getCategoryName(int index) {
    switch (index) {
      case 2:
        return "kursi";
      case 3:
        return "meja";
      case 4:
        return "lemari";
      case 5:
        return "sofa";
      case 6:
        return "bed";

      default:
        return "All";
    }
  }
}
