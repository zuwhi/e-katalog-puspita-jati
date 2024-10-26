// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/set_product_controller.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:e_katalog/view/product/widget/empty_image_picker_widget.dart';
import 'package:e_katalog/view/global/text_form_primary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class SetProductView extends StatelessWidget {
  const SetProductView({super.key});

  @override
  Widget build(BuildContext context) {
    final SetProductController setProductController =
        Get.put(SetProductController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: TextGelasio(text: "Tambah Item"),
        centerTitle: true,
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
          child: Column(
            children: [
              Obx(() {
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
                          setProductController.currentIndex.value = index;
                        },
                      ),
                      items: List.generate(3, (index) {
                        if (setProductController.imageFiles[index] == null) {
                          return InkWell(
                              onTap: () {
                                setProductController.pickImage(index);
                              },
                              child: const EmptyImagePicker());
                        } else {
                          return Stack(
                            children: [
                              InkWell(
                                onTap: () {
                                  setProductController.pickImage(index);
                                },
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(5),
                                    child: Image.file(
                                      setProductController.imageFiles[index]!,
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
                                        setProductController.removeImage(index);
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
                        activeIndex: setProductController.currentIndex.value,
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
                    ColorPickerWidget(
                        setProductController: setProductController),
                  ],
                );
              }),
              const SizedBox(
                height: 20.0,
              ),
              TextFormPrimary(
                controller: setProductController.productNameController,
                title: "Nama Item",
                hintText: "Ex : Meja",
                maxLines: 1,
              ),
              const SizedBox(
                height: 18.0,
              ),
              Stack(
                children: [
                  TextFormPrimary(
                    controller:
                        setProductController.productDescriptionController,
                    title: "Deskripsi Item",
                    hintText: "Masukkan Keterangan",
                  ),
                  Obx(
                    () => Positioned(
                      top: 0,
                      right: 5,
                      child: setProductController.isLoadingOnDesc.value
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator())
                          : IconButton(
                              onPressed: () {
                                if (setProductController
                                    .productNameController.text.isEmpty) {
                                  Get.snackbar("Gagal",
                                      "masukkan nama item terlebih dahulu");
                                } else {
                                  setProductController.descWithAI();
                                }
                              },
                              icon: const Icon(Icons.rocket_launch_rounded)),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 18.0,
              ),
              TextFormPrimary(
                keyboardType: TextInputType.number,
                controller: setProductController.productPriceController,
                title: "Harga Item",
                maxLines: 1,
                hintText: "Masukkan Harga",
              ),
              const SizedBox(
                height: 18.0,
              ),
              TextFormPrimary(
                maxLines: 1,
                controller: setProductController.productEstimatedController,
                title: "Estimasi Waktu",
                hintText: "Masukkan waktu",
              ),
              const SizedBox(
                height: 18.0,
              ),
              Obx(
                () => Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: const BorderRadius.all(Radius.circular(8))),
                  child: DropdownButton<String>(
                    underline: Container(),
                    value: setProductController.selectedCategory.value,
                    items: setProductController.categories.map((String item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (String? value) {
                      setProductController.selectedCategory.value = value!;
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
                    isLoading: setProductController.isLoading.value,
                    text: "Simpan",
                    onPressed: () {
                      if (setProductController.imageFiles[0] != null) {
                        setProductController.addProduct();
                      } else {
                        Get.snackbar("Gagal", "anda belum memasukkan gambar");
                      }
                    },
                    isActive: setProductController.productNameController.text !=
                            "" &&
                        setProductController.productPriceController.text !=
                            "" &&
                        setProductController.productEstimatedController.text !=
                            "" &&
                        setProductController.selectedColors.isNotEmpty &&
                        setProductController.imageFiles[0] != null &&
                        setProductController.imageFiles[1] != null &&
                        setProductController.imageFiles[2] != null,
                    backgroundColor: AppColors.primary,
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

class ColorPickerWidget extends StatelessWidget {
  const ColorPickerWidget({
    super.key,
    required this.setProductController,
  });

  final SetProductController setProductController;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: const BorderRadius.all(Radius.circular(8))),
      child: MultiSelectDialogField(
        items: setProductController.colors
            .map((color) => MultiSelectItem<String>(color, color))
            .toList(),
        title: const Text("Colors"),
        dialogWidth: MediaQuery.of(context).size.width,
        confirmText:
            const Text("Simpan", style: TextStyle(color: AppColors.primary)),
        cancelText:
            const Text("Batal", style: TextStyle(color: AppColors.primary)),
        checkColor: Colors.white,
        selectedColor: AppColors.primary,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white),
        ),
        buttonIcon: const Icon(
          Icons.arrow_drop_down,
          color: AppColors.primary,
        ),
        buttonText: const Text(
          "Pilih Warna",
          style: TextStyle(
            color: AppColors.primary,
            fontSize: 16,
          ),
        ),
        onConfirm: (results) {
          setProductController.selectedColors.value = results.cast<String>();
        },
        chipDisplay: MultiSelectChipDisplay(
          chipColor: AppColors.disable,
          textStyle: const TextStyle(color: AppColors.primary),
          onTap: (value) {
            setProductController.selectedColors.remove(value);
          },
        ),
      ),
    );
  }
}
