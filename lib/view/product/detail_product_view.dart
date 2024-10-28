import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/about_controller.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/controller/cart_controller.dart';
import 'package:e_katalog/controller/set_product_controller.dart';
import 'package:e_katalog/helper/format_rupiah.dart';
import 'package:e_katalog/model/cart_model.dart';
import 'package:e_katalog/model/product_model.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:readmore/readmore.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:url_launcher/url_launcher.dart'; // import smooth page indicator

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
    final CartController cartController = Get.put(CartController());
    final AboutController aboutController = Get.find();
    final List<String?> images = [
      product.image1,
      product.image2,
      product.image3
    ];

    final AuthController authController = Get.find();

    List<String> stringColors = product.color!.split(",");

    List<Color> colors = stringColors
        .map((color) => Color(int.parse(color.replaceFirst('#', '0xff'))))
        .toList();

    String getWaktuKategori() {
      DateTime now = DateTime.now();
      DateFormat dateFormat = DateFormat('HH'); // Format jam 24 jam
      int hour = int.parse(dateFormat.format(now).toString());

      if (hour >= 4 && hour < 10) {
        return "Pagi";
      } else if (hour >= 10 && hour < 15) {
        return "Siang";
      } else if (hour >= 15 && hour < 18) {
        return "Sore";
      } else {
        return "Malam";
      }
    }

    controller.selectedColor.value = "";
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
                      height: MediaQuery.of(context).size.height / 2.05,
                      width: double.infinity,
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            right: 0,
                            left: 0,
                            child: CarouselSlider(
                              items: images
                                  .where((img) => img != null)
                                  .map((imgUrl) => ClipRRect(
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
                                    MediaQuery.of(context).size.height / 2.05,
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
                              padding: const EdgeInsets.all(1),
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
                                  Navigator.pop(context);
                                },
                              ),
                            ),
                          ),
                          Positioned(
                              top: MediaQuery.of(context).size.height / 2.17,
                              right: 0,
                              left: 0,
                              bottom: 0,
                              child: Container(
                                height: 20,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(60),
                                      topRight: Radius.circular(60)),
                                ),
                              )),
                          Positioned(
                            top: MediaQuery.of(context).size.height / 3,
                            right: 0,
                            left: 0,
                            bottom: 0,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(right: 15.0),
                                child: Obx(() => AnimatedSmoothIndicator(
                                      activeIndex:
                                          controller.currentIndex.value,
                                      count: images
                                          .where((img) => img != null)
                                          .length,
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
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextPrimary(
                            text: product.title,
                            fontSize: 23.0,
                            fontWeight: FontWeight.w400,
                            color: AppColors.primary,
                          ),
                          const SizedBox(
                            height: 4.0,
                          ),
                          TextPrimary(
                            text: formatRupiah(product.price),
                            fontSize: 22.0,
                            fontWeight: FontWeight.bold,
                            color: AppColors.old,
                          ),
                          const SizedBox(
                            height: 10.0,
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
                                fontSize: 18.0,
                                color: AppColors.secondary,
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 8.0,
                          ),
                          ReadMoreText(
                            product.desc,
                            trimMode: TrimMode.Line,
                            trimLines: 5,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 17.5,
                              color: AppColors.secondary,
                            ),
                            textAlign: TextAlign.justify,
                            colorClickableText: Colors.pink,
                            trimCollapsedText: 'lihat detail',
                            trimExpandedText: 'tampilkan lebih sedikit',
                            moreStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(
                            height: 10.0,
                          ),
                          SizedBox(
                            width: double.infinity,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextPrimary(
                                  text: "Pilih warna :",
                                  fontSize: 18.0,
                                  color: AppColors.secondary,
                                ),
                                const SizedBox(
                                  height: 14.0,
                                ),
                                SizedBox(
                                  height: 36,
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
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: 100.0,
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
                              decoration: BoxDecoration(
                                  color: AppColors.secoondarybuttton,
                                  borderRadius: BorderRadius.circular(12)),
                              child: InkWell(
                                onTap: () async {
                                  if (controller.selectedColor.value.isEmpty) {
                                    Get.snackbar(
                                        "Maaf", "Pilih warna terlebih dahulu");
                                    return;
                                  } else {
                                    String infoWaktu = getWaktuKategori();

                                    String phone = aboutController
                                            .aboutModelDesc.value!.telepon ??
                                        '+6281226965058';
                                    String infoAkun =
                                        "Selamat $infoWaktu, perkenalkan saya :\n \n*Nama : ${authController.userAccount.value?.name}* \n*Telepon : ${authController.userAccount.value?.telepon}* \n*Alamat : ${authController.userAccount.value?.alamat}* \n \n";
                                    final String url =
                                        "https://wa.me/$phone?text=$infoAkun"
                                        "Ingin Melakukan Finishing Pada produk : \n\n"
                                        'nama item : ${product.title} \n'
                                        'warna item : ${controller.selectedColor.value} \n'
                                        'biaya : ${formatRupiah(product.price)} \n';

                                    if (await canLaunchUrl(
                                        Uri.parse(Uri.encodeFull(url)))) {
                                      await launchUrl(
                                          Uri.parse(Uri.encodeFull(url)));
                                    } else {
                                      throw 'Could not launch $url';
                                    }
                                  }
                                },
                                child: Center(
                                    child: SvgPicture.asset(
                                  "assets/images/wa.svg",
                                  width: 40,
                                  height: 40,
                                )),
                              )),
                          Expanded(
                            child: SizedBox(
                              height: 60,
                              child: ButtonPrimary(
                                backgroundColor: AppColors.primary,
                                isActive: true,
                                text: "Tambah ke keranjang",
                                onPressed: () async {
                                  if (controller.selectedColor.value.isEmpty) {
                                    Get.snackbar(
                                        "Maaf", "Pilih warna terlebih dahulu");
                                    return;
                                  } else {
                                    CartModel cart = CartModel(
                                      userId: authController
                                          .userAccount.value!.id
                                          .toString(),
                                      color: controller.selectedColor.value,
                                      product: product,
                                    );

                                    cartController.addDataCart(cart);
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
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color, // Warna lingkaran bagian dalam
          border: Border.all(
            color: Colors.white, // Border warna putih
            width: 4, // Lebar border
          ),
          boxShadow: [
            isActive
                ? BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  )
                : BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    spreadRadius: 1,
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
          ],
        ),
        child: isActive
            ? Icon(
                Icons.check,
                color: color == Colors.white ? Colors.black : Colors.white,
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
