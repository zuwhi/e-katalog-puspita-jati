// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/model/cash_category_model.dart';
import 'package:e_katalog/service/appwrite_service.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CashCategoryContoller extends GetxController {
  final AppwriteService _appwriteService = Get.find<AppwriteService>();
  RxList<CashCategoryModel> listCategory = <CashCategoryModel>[].obs;
  RxBool isLoading = false.obs;

  Future<void> getAllCategory() async {
    isLoading.value = true;
    final result = await _appwriteService.getCashCategory();
    if (result.isSuccess) {
      listCategory.value = result.resultValue!;
    }
    isLoading.value = false;
  }

  Future<void> addCategory(CashCategoryModel category) async {
    isLoading.value = true;
    final result = await _appwriteService.addCashCategory(category);
    if (result.isSuccess) {
      await getAllCategory();
    }
    isLoading.value = false;
  }

  Future<void> updateCategory(CashCategoryModel category) async {
    isLoading.value = true;
    final result = await _appwriteService.updateCashCategory(category);
    if (result.isSuccess) {
      await getAllCategory();
    }
    isLoading.value = false;
  }

  Future<void> deleteCategory(CashCategoryModel category) async {
    isLoading.value = true;
    final result = await _appwriteService.deleteCashCategory(category.id);
    if (result.isSuccess) {
      await getAllCategory();
    }
    isLoading.value = false;
  }
}

class AddCashCategoryView extends StatelessWidget {
  const AddCashCategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    CashCategoryContoller controller = Get.put(CashCategoryContoller());
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Kategori Kas"),
        actions: const [],
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            // side: const BorderSide(color: Colors.black38),
                            backgroundColor: AppColors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            TextEditingController categoryController =
                                TextEditingController();
                            Get.defaultDialog(
                                title: "Tambah Kategori",
                                content: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      TextField(
                                        controller: categoryController,
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            labelText: 'Kategori'),
                                      ),
                                      const SizedBox(
                                        height: 20.0,
                                      ),
                                    ],
                                  ),
                                ),
                                confirm: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    elevation: 0,
                                    // side: const BorderSide(color: Colors.black38),
                                    backgroundColor: AppColors.teal,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  child: const Text(
                                    "Tambah",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                  onPressed: () {
                                    CashCategoryModel category =
                                        CashCategoryModel(
                                            id: "",
                                            category: categoryController.text);
                                    controller.addCategory(category);
                                    Get.back();
                                  },
                                ),
                                cancel: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      side: const BorderSide(
                                          color: Colors.black38),
                                      backgroundColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    child: const Text("Batal"),
                                    onPressed: () {
                                      Get.back();
                                    }));
                          },
                          child: const Text(
                            "Tambah Kategori",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      ListView.builder(
                        itemCount: controller.listCategory.length,
                        physics: const ScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          CashCategoryModel category =
                              controller.listCategory[index];
                          return Card(
                            child: ListTile(
                              leading: const Icon(Icons.category),
                              title: Text(category.category),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.delete),
                                    color: Colors.red,
                                    onPressed: () {
                                      Get.dialog(Dialog(
                                        backgroundColor: Colors.white,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(14.0),
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
                                                "Apakah Anda yakin ingin menghapus catatan ini?",
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
                                                        color:
                                                            AppColors.primary,
                                                        fontSize: 18.0,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 100,
                                                    child: ButtonPrimary(
                                                      text: "Iya",
                                                      onPressed: () async {
                                                        controller
                                                            .deleteCategory(
                                                                category);
                                                        Navigator.pop(context);
                                                      },
                                                      isActive: true,
                                                      backgroundColor:
                                                          Colors.red,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ));
                                    },
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
