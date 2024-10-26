import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class LaunchUrl extends GetxController{

  
  void launchURL(String link) async {
    try {
      final Uri url = Uri.parse(link);
      if (await canLaunchUrl(url)) {
        await launchUrl(url);
      } else {
        throw 'Could not launch $url';
      }
    } catch (e) {
      Get.snackbar("gagal", "terjadi kesalahan saat menghubungkan");
    }
    
  }
}