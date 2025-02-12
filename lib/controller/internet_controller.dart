import 'package:get/get.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class InternetController extends GetxController {
  var isConnected = false.obs;

  @override
  void onInit() {
    super.onInit();
    _checkConnection();
  }

  void _checkConnection() async {
    // Cek koneksi awal
    isConnected.value = await InternetConnection().hasInternetAccess;

    InternetConnection().onStatusChange.listen((InternetStatus status) {
      switch (status) {
        case InternetStatus.connected:
          isConnected.value = true;
          break;
        case InternetStatus.disconnected:
          isConnected.value = false;
          break;
      }
    });
  }
}
