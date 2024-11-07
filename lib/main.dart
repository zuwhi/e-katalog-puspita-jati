import 'package:device_preview/device_preview.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:e_katalog/view/about/about_view.dart';
import 'package:e_katalog/view/auth/login_view.dart';
import 'package:e_katalog/view/auth/register_view.dart';
import 'package:e_katalog/view/cart/cart_view.dart';
import 'package:e_katalog/view/colors/colors_view.dart';
import 'package:e_katalog/view/home/home_view.dart';
import 'package:e_katalog/view/home/navigation_view.dart';
import 'package:e_katalog/view/loading.dart';
import 'package:e_katalog/view/product/detail_product_view.dart';
import 'package:e_katalog/view/product/edit_product.dart';
import 'package:e_katalog/view/product/set_product_view.dart';
import 'package:e_katalog/view/profile/profile_view.dart';
import 'package:e_katalog/view/welcome/welcome_view.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'utils/theme.dart';
import 'utils/util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => AppwriteService().init());
  runApp(DevicePreview(
    enabled: !kReleaseMode,
    builder: (context) => const MyApp(), // Wrap your app
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // final brightness = View.of(context).platformDispatcher.platformBrightness;

    TextTheme textTheme = createTextTheme(context, "Roboto", "Nunito Sans");

    MaterialTheme theme = MaterialTheme(textTheme);

    Get.put(AuthController());
    return GetMaterialApp(
        title: 'Puspita Jati',
        theme: theme.light(),
        debugShowCheckedModeBanner: false,
        initialRoute: AppRoute.loading,
        initialBinding: BindingsBuilder(() {
          Get.put(AuthController());
        }),
        getPages: [
          GetPage(
            name: AppRoute.welcome,
            page: () => const WelcomeView(),
          ),
          GetPage(
            name: AppRoute.login,
            page: () => const LoginView(),
          ),
          GetPage(
            name: AppRoute.register,
            page: () => const RegisterView(),
            // binding: AuthBinding(),
          ),
          GetPage(
            name: AppRoute.home,
            page: () => const HomeView(),
          ),
          GetPage(
            name: AppRoute.setProduct,
            page: () => const SetProductView(),
          ),
          GetPage(
            name: AppRoute.detailProduct,
            page: () => const DetailProductView(),
          ),
          GetPage(
            name: AppRoute.profile,
            page: () => const ProfileView(),
          ),
          GetPage(
            name: AppRoute.nav,
            page: () => const NavigationView(),
          ),
          GetPage(
            name: AppRoute.editProduct,
            page: () => const EditProductView(),
          ),
          GetPage(
            name: AppRoute.cart,
            page: () => const CartView(),
          ),
          GetPage(
            name: AppRoute.about,
            page: () => const AboutView(),
          ),
          GetPage(
            name: AppRoute.loading,
            page: () => const LoadingView(),
          ),
          GetPage(
            name: AppRoute.colors,
            page: () => const ColorsView(),
          ),
        ]);
  }
}
