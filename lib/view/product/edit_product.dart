// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/edit_product_controller.dart';
import 'package:e_katalog/model/product_model.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_form_primary.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:e_katalog/view/product/widget/empty_image_picker_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class EditProductView extends StatelessWidget {
  const EditProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final arg = Get.arguments;
    final ProductModel product = arg['product'];
    final EditProductController editProductController =
        Get.put(EditProductController());
    print(product.toJson());

    editProductController.fillControllers(product);

    return Obx(
      () => editProductController.isLoading.value
          ? const Scaffold(body: Center(child: CircularProgressIndicator()))
          : Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                backgroundColor: Colors.white,
                title: TextGelasio(text: "Edit Product"),
                centerTitle: true,
                actions: const [],
              ),
              body: SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20.0, vertical: 10),
                  child: Column(
                    children: [
                      CarouselProductImage(
                          editProductController: editProductController),
                      const SizedBox(
                        height: 20.0,
                      ),
                      TextFormPrimary(
                        controller: editProductController.productNameController,
                        title: "Nama Item",
                        hintText: "Ex : Meja",
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      TextFormPrimary(
                        controller:
                            editProductController.productDescriptionController,
                        title: "Deskripsi Item",
                        hintText: "Masukkan Keterangan",
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      TextFormPrimary(
                        keyboardType: TextInputType.number,
                        controller:
                            editProductController.productPriceController,
                        title: "Harga Item",
                        hintText: "Masukkan Harga",
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      TextFormPrimary(
                        controller:
                            editProductController.productEstimatedController,
                        title: "Estimasi Waktu",
                        hintText: "Masukkan waktu",
                      ),
                      const SizedBox(
                        height: 18.0,
                      ),
                      Obx(
                        () => Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(8))),
                          child: DropdownButton<String>(
                            underline: Container(),
                            value: editProductController.selectedCategory.value,
                            items: editProductController.categories
                                .map((String item) {
                              return DropdownMenuItem<String>(
                                value: item,
                                child: Text(item),
                              );
                            }).toList(),
                            onChanged: (String? value) {
                              editProductController.selectedCategory.value =
                                  value!;
                            },
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 40.0,
                      ),
                      SizedBox(
                        height: 58,
                        child: Obx(
                          () => ButtonPrimary(
                            isLoading: editProductController.isLoading.value,
                            text: "Simpan",
                            onPressed: () {
                              if (editProductController.imageFiles[0] != null) {
                                editProductController.editProduct();
                              } else {
                                Get.snackbar(
                                    "Gagal", "anda belum memasukkan gambar");
                              }
                            },
                            isActive: editProductController
                                        .productNameController.text !=
                                    "" &&
                                editProductController
                                        .productPriceController.text !=
                                    "" &&
                                editProductController
                                        .productEstimatedController.text !=
                                    "" &&
                                editProductController.imageFiles[0] != null,
                            backgroundColor: AppColors.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

class CarouselProductImage extends StatelessWidget {
  const CarouselProductImage({
    super.key,
    required this.editProductController,
  });

  final EditProductController editProductController;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        children: [
          CarouselSlider(
            options: CarouselOptions(
              height: 210.0,
              aspectRatio: 16 / 9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: false,
              autoPlay: false,
              enlargeCenterPage: true,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                editProductController.currentIndex.value = index;
              },
            ),
            items: List.generate(3, (index) {
              if (editProductController.imageFiles[index] == null) {
                return InkWell(
                    onTap: () {
                      editProductController.pickImage(index);
                    },
                    child: const EmptyImagePicker());
              } else {
                return Stack(
                  children: [
                    InkWell(
                      onTap: () {
                        editProductController.pickImage(index);
                      },
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(5),
                          child: editProductController.imageFiles[index]
                                  is String
                              ? CachedNetworkImage(
                                  imageUrl:
                                      editProductController.imageFiles[index]!,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  placeholder: (context, url) => const Center(
                                    child: SizedBox(
                                        height: 40,
                                        width: 40,
                                        child: CircularProgressIndicator()),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                )
                              : Image.file(
                                  editProductController.imageFiles[index]!,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(100)),
                        child: IconButton(
                            onPressed: () {
                              editProductController.removeImage(index);
                            },
                            icon: Icon(
                              Icons.delete,
                              color: Colors.red[700],
                            )),
                      ),
                    )
                  ],
                );
              }
            }).toList().cast<Widget>(),
          ),
          const SizedBox(height: 15),
          // Dot Indicator using SmoothPageIndicator
          Obx(() {
            return AnimatedSmoothIndicator(
              activeIndex: editProductController.currentIndex.value,
              count: 3, // Total number of images or placeholders
              effect: ExpandingDotsEffect(
                dotHeight: 5,
                dotWidth: 8,
                activeDotColor: AppColors.primary,
                dotColor: AppColors.tertiary.withOpacity(0.7),
              ),
            );
          }),
          const SizedBox(
            height: 15.0,
          ),
        ],
      );
    });
  }
}
