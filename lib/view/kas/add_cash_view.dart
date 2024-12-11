import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/cash_controller.dart';
import 'package:e_katalog/model/cash_category_model.dart';
import 'package:e_katalog/model/cash_model.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:e_katalog/view/kas/add_cash_category_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class AddCashView extends StatelessWidget {
  const AddCashView({super.key});

  @override
  Widget build(BuildContext context) {
    CashCategoryContoller categoryController = Get.put(CashCategoryContoller());
    List<CashCategoryModel> cashCategory =
        categoryController.listCategory.value;
    var selectedDate = DateTime.now();
    String today = DateFormat('yyyy-MM-dd').format(selectedDate);
    final CashController controller = Get.put(CashController());
    TextEditingController titleC = TextEditingController();
    TextEditingController debetC = TextEditingController(text: "0");
    TextEditingController kreditC = TextEditingController(text: "0");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Catatan"),
        actions: const [],
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Text(
                  "Tanggal : $today",
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              TextPrimary(
                text: "Nota",
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 8.0,
              ),
              Obx(() {
                // Jika ada gambar yang dipilih, tampilkan di dalam container
                return InkWell(
                  onTap: () {
                    // Menampilkan pilihan kamera/galeri
                    Get.bottomSheet(
                      Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(20),
                        child: Wrap(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.camera_alt),
                              title: const Text('Kamera'),
                              onTap: () {
                                controller.pickImage(ImageSource.camera);
                                Get.back();
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.image),
                              title: const Text('Galeri'),
                              onTap: () {
                                controller.pickImage(ImageSource.gallery);
                                Get.back();
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 50),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: AppColors.disable,
                      image: controller.selectedImage.value != null
                          ? DecorationImage(
                              image: FileImage(controller.selectedImage.value!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    child: controller.selectedImage.value == null
                        ? const Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.upload),
                              Text("Upload Gambar Nota"),
                            ],
                          )
                        : null,
                  ),
                );
              }),
              const SizedBox(
                height: 25.0,
              ),
              TextPrimary(
                text: "Transaksi ",
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: titleC,
                decoration: InputDecoration(
                  hintText: "Transaksi",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextPrimary(
                text: "Debet ",
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: debetC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Debet",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 15.0,
              ),
              TextPrimary(
                text: "Kredit ",
                fontSize: 17.0,
                fontWeight: FontWeight.bold,
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextFormField(
                controller: kreditC,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: "Kredit",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: const BorderSide(color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(
                height: 20.0,
              ),
              Obx(
                () => DropdownButton<String>(
                  value: controller.selectedCategory.value ??
                      cashCategory.first.category,
                  hint: const Text("Pilih Kategori"),
                  isExpanded: true,
                  items: cashCategory.map((CashCategoryModel model) {
                    return DropdownMenuItem<String>(
                      value: model.category, // Set value to id
                      child: Text(model.category), // Display category
                    );
                  }).toList(),
                  onChanged: (value) {
                    controller.selectedCategory.value = value;
                  },
                ),
              ),
              const SizedBox(
                height: 35.0,
              ),
              SizedBox(
                height: 60,
                child: Obx(
                  () => ButtonPrimary(
                      text: "Simpan Catatan",
                      isLoading: controller.isLoading.value,
                      isActive: controller.isLoading.value ? false : true,
                      backgroundColor: AppColors.primary,
                      onPressed: () {
                        if (titleC.text.isEmpty) return;
                        CashModel cashModel = CashModel(
                          title: titleC.text,
                          debet:
                              debetC.text.isEmpty ? 0 : int.parse(debetC.text),
                          kredit: kreditC.text.isEmpty
                              ? 0
                              : int.parse(kreditC.text),
                          tanggal: today,
                          kategori: controller.selectedCategory.value,
                        );
                        controller.addCash(cashModel);
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
