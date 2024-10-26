import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/controller/set_product_controller.dart';
import 'package:e_katalog/helper/format_color.dart';
import 'package:e_katalog/helper/format_rupiah.dart';
import 'package:e_katalog/model/product_model.dart';
import 'package:e_katalog/view/global/button_favorite.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // import smooth page indicator
import 'package:url_launcher/url_launcher.dart';

class DetailProductController extends GetxController {
  RxInt currentIndex = 0.obs;
  final selectedColor = "".obs;
  final CarouselSliderController carouselSliderController =
      CarouselSliderController();
  void changeIndex() {
    carouselSliderController.animateToPage(currentIndex.value);
  }
}

class DetailProductView extends StatelessWidget {
  const DetailProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final DetailProductController controller =
        Get.put(DetailProductController());
    final arg = Get.arguments;
    final ProductModel product = arg['product'];

    final SetProductController setProductController =
        Get.put(SetProductController());

    final List<String?> images = [
      product.image1,
      product.image2,
      product.image3
    ];

    final AuthController authController = Get.find();

    List<String> stringColors = product.color!.split(",");

    List<Color> colors = stringColors
        .map((color) => getColorByName(color.trim().toLowerCase()))
        .toList();

    print(colors);

    return Obx(
      () => setProductController.isLoading.value
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height / 1.75,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 47,
                            child: CarouselSlider(
                              items: images
                                  .where((img) => img != null)
                                  .map((imgUrl) => ClipRRect(
                                        borderRadius: const BorderRadius.only(
                                            bottomLeft: Radius.circular(70)),
                                        child: CachedNetworkImage(
                                          imageUrl: imgUrl!,
                                          fit: BoxFit.cover,
                                          width: double.infinity,
                                          placeholder: (context, url) =>
                                              const Center(
                                            child: SizedBox(
                                                height: 40,
                                                width: 40,
                                                child:
                                                    CircularProgressIndicator()),
                                          ),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ))
                                  .toList(),
                              carouselController:
                                  controller.carouselSliderController,
                              options: CarouselOptions(
                                height:
                                    MediaQuery.of(context).size.height / 1.75,
                                viewportFraction: 1.0,
                                autoPlay: false,
                                initialPage: 0,
                                enableInfiniteScroll: false,
                                onPageChanged: (index, reason) {
                                  controller.currentIndex.value = index;
                                  controller.changeIndex();
                                },
                              ),
                            ),
                          ),
                          Positioned(
                            top: 50,
                            left: 20,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFa0a0a0)
                                        .withOpacity(0.5),
                                    offset: const Offset(1, 2),
                                    blurRadius: 4,
                                    spreadRadius: 0,
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: IconButton(
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () {
                                  Get.back();
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Obx(() => AnimatedSmoothIndicator(
                              activeIndex: controller.currentIndex.value,
                              count: images.where((img) => img != null).length,
                              effect: ExpandingDotsEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: AppColors.primary,
                                dotColor: Colors.grey.shade300,
                              ),
                              onDotClicked: (index) {
                                controller.currentIndex.value = index;
                                controller.changeIndex();
                              },
                            )),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextGelasio(
                            text: product.title,
                            fontSize: 26.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextPrimary(
                                text: "Harga :",
                                fontSize: 18.0,
                                color: AppColors.secondary,
                              ),
                              TextPrimary(
                                text: formatRupiah(product.price),
                                fontSize: 20.0,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextPrimary(
                                text: "Estimasi Waktu :",
                                fontSize: 18.0,
                                color: AppColors.secondary,
                              ),
                              TextPrimary(
                                text: product.estimate,
                                fontSize: 20.0,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextPrimary(
                                text: "Pilih warna :",
                                fontSize: 18.0,
                                color: AppColors.secondary,
                              ),
                              SizedBox(
                                height: 34,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: colors.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const ScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Obx(
                                      () => CircleColorWidget(
                                        onTap: () {
                                          controller.selectedColor.value =
                                              stringColors[index];
                                        },
                                        isActive: stringColors[index] ==
                                            controller.selectedColor.value,
                                        color: colors[index],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          TextPrimary(
                            text: "Deskripsi :",
                            fontSize: 18.0,
                            color: AppColors.secondary,
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          TextPrimary(
                            fontSize: 18.0,
                            textAlign: TextAlign.justify,
                            text: product.desc,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: authController.userAccount.value!.role !=
                      "guest"
                  ? Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Container(
                              margin: const EdgeInsets.only(right: 15),
                              height: 60,
                              width: 100,
                              child: ButtonDelete(onPressed: () async {
                                Get.dialog(Dialog(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(14.0),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const SizedBox(
                                          height: 10.0,
                                        ),
                                        const Text(
                                          "Konfirmasi",
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 16),
                                        const Text(
                                          "Apakah Anda yakin ingin menghapus item ini?",
                                        ),
                                        const SizedBox(height: 24),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              width: 100,
                                              child: TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: TextPrimary(
                                                  text: "Batal",
                                                  color: AppColors.primary,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 100,
                                              child: ButtonPrimary(
                                                text: "Hapus",
                                                onPressed: () async {
                                                  await setProductController
                                                      .deleteProduct(
                                                          product.id);
                                                  Get.back();
                                                  Get.back();
                                                },
                                                isActive: true,
                                                backgroundColor: Colors.red,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ));
                              })),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ButtonPrimary(
                                backgroundColor: AppColors.primary,
                                isActive: true,
                                text: "Edit Item",
                                onPressed: () async {
                                  Get.toNamed(AppRoute.editProduct,
                                      arguments: {"product": product});
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Row(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 15),
                            height: 60,
                            width: 100,
                            child: ButtonFavorite(
                              backgroundColor: AppColors.secoondarybuttton,
                              isActive: true,
                              onPressed: () {},
                            ),
                          ),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ButtonPrimary(
                                backgroundColor: AppColors.primary,
                                isActive: true,
                                text: "Pesan Sekarang",
                                onPressed: () async {
                                  String phone = "+62895415005347";
                                  final String url =
                                      "https://wa.me/$phone?text=halo, saya mau pesan ${product.title}";

                                  if (await canLaunchUrl(
                                      Uri.parse(Uri.encodeFull(url)))) {
                                    await launchUrl(
                                        Uri.parse(Uri.encodeFull(url)));
                                  } else {
                                    throw 'Could not launch $url';
                                  }
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
    );
  }
}

class CircleColorWidget extends StatelessWidget {
  const CircleColorWidget(
      {super.key, this.color, this.onTap, this.isActive = false});
  final void Function()? onTap;
  final Color? color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color, // Warna lingkaran bagian dalam
          // border: Border.all(
          //   color: Colors.white, // Border warna putih
          //   width: 4, // Lebar border
          // ),
          // boxShadow: [
          //   isActive
          //       ? BoxShadow(
          //           color: Colors.black.withOpacity(0.15),
          //           spreadRadius: 1,
          //           blurRadius: 3,
          //           offset: const Offset(0, 1),
          //         )
          //       : const BoxShadow(),
          // ],
        ),
        child: isActive
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 19,
              )
            : null,
      ),
    );
  }
}

class ButtonDelete extends StatelessWidget {
  const ButtonDelete(
      {super.key,
      required this.onPressed,
      this.backgroundColor,
      this.rounded,
      this.textColor = Colors.white,
      this.isActive = false});

  final void Function()? onPressed;
  final Color? backgroundColor;
  final double? rounded;
  final bool isActive;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: isActive
                ? backgroundColor ?? AppColors.disable
                : AppColors.disable,
            padding: const EdgeInsets.all(12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(rounded ?? 12),
            ),
          ),
          child: const Icon(Icons.delete, size: 28, color: AppColors.primary)),
    );
  }
}
