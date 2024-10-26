import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/model/cart_model.dart';
import 'package:e_katalog/model/result.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:get/get.dart';

class CartController extends GetxController {
  RxBool isloading = false.obs;
  final listCart = Rx<List<CartModel>>([]);
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  RxList<int> quantity = <int>[].obs;
  RxList<int> priceList = <int>[].obs;

  RxInt totalHarga = 0.obs;

  @override
  void onInit() {
    super.onInit();

    // Panggil getDataCart() terlebih dahulu
    getDataCart();

    // Tambahkan quantity dan priceList berdasarkan produk dalam listCart
    ever(listCart, (_) {
      quantity.clear();
      priceList.clear();
      for (var item in listCart.value) {
        quantity.add(1); // Set default quantity 1
        priceList
            .add(item.product!.price); // Tambahkan harga produk ke priceList
      }
    });
  }

  Future<void> getDataCart() async {
    isloading.value = true;
    AuthController authController = Get.find();
    final Result result = await _appwriteService
        .getDataCartByUserId(authController.userAccount.value!.id!);

    if (result.isSuccess) {
      listCart.value = result.resultValue;
    }
    isloading.value = false;
  }

  Future<void> addDataCart(CartModel cart) async {
    isloading.value = true;
    final Result result = await _appwriteService.addDataCart(cart);
    if (result.isSuccess) {
      Get.toNamed(AppRoute.nav);
    } else {
      Get.snackbar(
          "Error", result.errorMessage ?? 'gagal menambahkan ke keranjang');
    }

    isloading.value = false;
  }

  Future<void> deleteDataCart(String documentId) async {
    isloading.value = true;
    final Result result = await _appwriteService.deleteCart(documentId);
    if (result.isSuccess) {
      getDataCart();
      Get.snackbar("Berhasil", "berhasil menghapus item dari keranjang");
    } else {
      Get.snackbar(
          "Error", result.errorMessage ?? 'gagal mengapus item di keranjang');
    }
    isloading.value = false;
  }
}
