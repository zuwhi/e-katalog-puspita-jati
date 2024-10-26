import 'package:cached_network_image/cached_network_image.dart';
import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/about_controller.dart';
import 'package:e_katalog/controller/auth_controller.dart';
import 'package:e_katalog/controller/product_controller.dart';
import 'package:e_katalog/helper/format_rupiah.dart';
import 'package:e_katalog/model/product_model.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.put(ProductController());
    final AuthController authController = Get.find();
    productController.getListProduct();

    final AboutController aboutController = Get.put(AboutController());
    aboutController.getAboutDesc();

    return authController.isLoading.value ||
            authController.userAccount.value == null
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: () async {
              await productController.getListProduct();
            },
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const SizedBox(
                          width: 40.0,
                        ),
                        Column(
                          children: [
                            TextGelasio(
                                text: "PUSPITA",
                                fontSize: 18.0,
                                color: AppColors.secondary),
                            TextGelasio(
                                text: "JATI FURNITURE",
                                fontSize: 18.0,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primary),
                          ],
                        ),
                        authController.userAccount.value != null
                            ? SizedBox(
                                width: 40.0,
                                child: authController.userAccount.value!.role ==
                                        "admin"
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(right: 5.0),
                                        child: IconButton(
                                            onPressed: () {
                                              Get.toNamed(AppRoute.setProduct);
                                            },
                                            icon: const Icon(
                                              Icons.add,
                                              size: 28,
                                            )),
                                      )
                                    : null,
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(
                      height: 20.0,
                    ),
                    const CategoryWidget(),
                    const SizedBox(
                      height: 10.0,
                    ),
                    const GridCardProduct(),
                    const SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}

class GridCardProduct extends StatelessWidget {
  const GridCardProduct({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductController productController = Get.find();
    return Obx(
      () => productController.isLoading.value
          ? SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 1.5,
              child: const Center(child: CircularProgressIndicator()))
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 20.0,
                    mainAxisSpacing: 18.0,
                    childAspectRatio: 0.65),
                itemCount: productController.listProducts.length,
                itemBuilder: (context, index) {
                  ProductModel product = productController.listProducts[index];
                  return InkWell(
                    onTap: () {
                      Get.toNamed(AppRoute.detailProduct,
                          arguments: {"product": product});
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: CachedNetworkImage(
                              imageUrl: product.image1 ?? "",
                              imageBuilder: (context, imageProvider) => Image(
                                image: imageProvider,
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),
                              placeholder: (context, url) => const Center(
                                child: SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: Center(
                                        child: CircularProgressIndicator())),
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            ),
                          ),
                        ),
                        const SizedBox(height: 7),
                        TextPrimary(
                          maxLines: 1,
                          text: product.title,
                          fontSize: 14.0,
                        ),
                        TextPrimary(
                          text: formatRupiah(product.price),
                          color: AppColors.primary,
                          fontSize: 14.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}

class CategoryWidget extends StatelessWidget {
  const CategoryWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final ProductController controller = Get.find();
    return SizedBox(
      height: 90,
      child: Obx(
        () => ListView(
          scrollDirection: Axis.horizontal,
          children: [
            CardCategory(
              image: "assets/images/all.svg",
              title: "All",
              isActive: controller.categoryIndex.value == 1,
              index: 1,
              controller: controller,
            ),
            CardCategory(
              image: "assets/images/kursi.svg",
              title: "Kursi",
              isActive: controller.categoryIndex.value == 2,
              index: 2,
              controller: controller,
            ),
            CardCategory(
              image: "assets/images/meja.svg",
              title: "Meja",
              index: 3,
              isActive: controller.categoryIndex.value == 3,
              controller: controller,
            ),
            CardCategory(
              image: "assets/images/lemari.svg",
              title: "lemari",
              index: 4,
              isActive: controller.categoryIndex.value == 4,
              controller: controller,
            ),
            CardCategory(
              image: "assets/images/sofa.svg",
              title: "sofa",
              index: 5,
              isActive: controller.categoryIndex.value == 5,
              controller: controller,
            ),
            CardCategory(
              image: "assets/images/bed.svg",
              title: "bed",
              index: 6,
              isActive: controller.categoryIndex.value == 6,
              controller: controller,
            ),
          ],
        ),
      ),
    );
  }
}

class CardCategory extends StatelessWidget {
  final bool isActive;
  final String image;
  final String title;
  final int index;
  final ProductController? controller;
  const CardCategory(
      {super.key,
      this.controller,
      this.title = "Lemari",
      this.image = "assets/images/search.svg",
      this.isActive = false,
      this.index = 1});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: 57,
          height: 57,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : AppColors.disable,
            borderRadius: const BorderRadius.all(Radius.circular(12)),
          ),
          child: InkWell(
            onTap: () {
              print(index);
              if (index == 1) {
                controller!.categoryIndex.value = index;
                controller!.getListProduct();
              } else {
                controller!.categoryIndex.value = index;
                controller!.getListProductByCategory();
              }
            },
            child: Center(
              child: SvgPicture.asset(image,
                  colorFilter: ColorFilter.mode(
                      isActive ? AppColors.disable : AppColors.secondary,
                      BlendMode.srcIn)),
            ),
          ),
        ),
        const SizedBox(
          height: 6.0,
        ),
        TextPrimary(
          text: title,
          fontWeight: FontWeight.w200,
          color: isActive ? AppColors.primary : AppColors.tertiary,
        )
      ],
    );
  }
}
