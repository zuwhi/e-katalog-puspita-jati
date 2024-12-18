// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/about_controller.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/controller/cart_controller.dart';
import 'package:e_katalog/helper/format_rupiah.dart';
import 'package:e_katalog/model/cart_model.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    CartController cartController = Get.put(CartController());
    cartController.getDataCart();

    final AboutController aboutController = Get.find();

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

    final AuthController authController = Get.find();

    return Obx(
      () => cartController.isloading.value
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: const Text("Keranjang"),
                leading: Container(),
                centerTitle: true,
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(18.0),
                  child: Column(
                    children: [
                      // List Produk dalam cart
                      Obx(
                        () => cartController.listCart.value.isEmpty
                            ? Center(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          3),
                                  child: Column(
                                    children: [
                                      TextPrimary(
                                        text: "Keranjang Masih Kosong :(",
                                        fontSize: 22.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      const SizedBox(
                                        height: 10.0,
                                      ),
                                      TextPrimary(
                                        text: "dapatkan item di halaman utama",
                                        fontSize: 18.0,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  ListView.builder(
                                    itemCount:
                                        cartController.listCart.value.length,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      CartModel product =
                                          cartController.listCart.value[index];

                                      return CardProductOnCartWidget(
                                          controller: cartController,
                                          product: product,
                                          index: index);
                                    },
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      TextPrimary(
                                        text: "Total Harga: ",
                                        fontWeight: FontWeight.w500,
                                        fontSize: 16.0,
                                      ),
                                      Obx(
                                        () {
                                          int totalPrice =
                                              cartController.priceList.fold(
                                                  0, (sum, item) => sum + item);
                                          return TextPrimary(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 17.0,
                                            text: formatRupiah(totalPrice),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 60.0,
                                  ),
                                ],
                              ),
                      ),
                      // Total Harga
                    ],
                  ),
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              floatingActionButton: Obx(
                () => cartController.listCart.value.isEmpty
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: ButtonPrimary(
                          backgroundColor: AppColors.primary,
                          text: "Checkout",
                          onPressed: () async {
                            String infoWaktu = getWaktuKategori();
                            String phone =
                                aboutController.aboutModelDesc.value!.telepon ??
                                    '+6281226965058';
                            String infoAkun =
                                "Selamat $infoWaktu, perkenalkan saya :\n \n*Nama : ${authController.userAccount.value?.name}* \n*Telepon : ${authController.userAccount.value?.telepon}* \n*Alamat : ${authController.userAccount.value?.alamat}* \n \n";

                            // Membuat pesan untuk setiap item di keranjang
                            String productDetails = cartController
                                .listCart.value
                                .asMap()
                                .entries
                                .map((e) {
                              int index = e.key;
                              var product = e.value.product!;
                              int quantity = cartController.quantity[index];
                              List<dynamic> colors = e.value.colors!;

                              // Mendapatkan semua nama warna dan menggabungkannya dengan koma
                              String colorNames = colors
                                  .map((color) => color["name"])
                                  .join(", ");

                              return '*${index + 1}. ${product.title}* \n'
                                  'jumlah : $quantity item\n'
                                  'warna item : $colorNames \n'
                                  'biaya : ${formatRupiah(cartController.priceList[index])} \n';
                            }).join("\n");

                            // Menggabungkan info akun dan detail produk ke dalam satu pesan
                            String message = "$infoAkun"
                                "Ingin Melakukan Finishing Pada produk : \n\n"
                                "$productDetails \n\n"
                                "total biaya : ${formatRupiah(cartController.priceList.fold(0, (sum, item) => sum + item))}";

                            final String url =
                                "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";

                            if (await canLaunchUrl(Uri.parse(url))) {
                              await launchUrl(Uri.parse(url));
                            } else {
                              Get.snackbar("Terjadi kesalahan",
                                  "tidak ditemukan whatsapp, Mohon install WhatsApp terlebih dahulu untuk melakukan pemesanan");
                            }
                          },
                          isActive: true,
                        ),
                      ),
              ),
            ),
    );
  }
}

class CardProductOnCartWidget extends StatelessWidget {
  const CardProductOnCartWidget(
      {super.key,
      required this.product,
      required this.index,
      required this.controller});
  final int index;
  final CartModel product;
  final CartController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: CustomCachedImageNetwork(
                    url: product.product!.image1 ?? '',
                  ),
                ),
                const SizedBox(
                  width: 15.0,
                ),
                SizedBox(
                  height: 110,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 200,
                            child: TextPrimary(
                              text: product.product!.title,
                              overflow: TextOverflow.ellipsis,
                              fontSize: 18,
                              maxLines: 1,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Row(
                            children: [
                              TextPrimary(
                                text: "warna : ",
                                fontSize: 15,
                                overflow: TextOverflow.ellipsis,
                              ),
                              SizedBox(
                                height: 15,
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: product.colors!.length,
                                  scrollDirection: Axis.horizontal,
                                  physics: const ScrollPhysics(),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return CircleColorWidgetOnCart(
                                      color: Color(int.parse(product
                                          .colors![index]["color"]
                                          .replaceFirst('#', '0xff'))),
                                    );
                                  },
                                ),
                              )
                            ],
                          ),
                          Obx(
                            () => TextPrimary(
                              text: formatRupiah(controller.priceList[index]),
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Obx(
                        () => Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            InkWell(
                              onTap: () {
                                controller.quantity[index] += 1;
                                controller.priceList[index] =
                                    product.product!.price *
                                        controller.quantity[index];
                              },
                              child: Container(
                                height: 27,
                                width: 27,
                                decoration: BoxDecoration(
                                  color: AppColors.stroke,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Icon(Icons.add),
                                ),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            Container(
                              height: 27,
                              width: 27,
                              decoration: BoxDecoration(
                                  color: AppColors.stroke,
                                  borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: TextPrimary(
                                    text:
                                        controller.quantity[index].toString()),
                              ),
                            ),
                            const SizedBox(
                              width: 8.0,
                            ),
                            InkWell(
                              onTap: () {
                                if (controller.quantity[index] > 1) {
                                  controller.quantity[index] -= 1;
                                  controller.priceList[index] =
                                      product.product!.price *
                                          controller.quantity[index];
                                }
                              },
                              child: Container(
                                height: 27,
                                width: 27,
                                decoration: BoxDecoration(
                                  color: AppColors.stroke,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: const Center(
                                  child: Icon(Icons.remove),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            InkWell(
                onTap: () {
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
                            mainAxisAlignment: MainAxisAlignment.end,
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
                                    controller.deleteDataCart(product.id!);
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
                },
                child: const Icon(Icons.delete))
          ],
        ),
        const SizedBox(
          height: 15.0,
        ),
        const Divider(),
        const SizedBox(
          height: 15.0,
        ),
      ],
    );
  }
}

class CircleColorWidgetOnCart extends StatelessWidget {
  const CircleColorWidgetOnCart(
      {super.key, this.color, this.onTap, this.isActive = false});
  final void Function()? onTap;
  final Color? color;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          width: 20,
          height: 20,
          decoration:
              BoxDecoration(shape: BoxShape.circle, color: color, boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(0, 1),
            )
          ]),
          child: Container()),
    );
  }
}

class CustomCachedImageNetwork extends StatelessWidget {
  const CustomCachedImageNetwork({super.key, required this.url});

  final String url;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: (context, imageProvider) => Container(
        height: 110,
        width: 110,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
          ),
        ),
      ),
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
