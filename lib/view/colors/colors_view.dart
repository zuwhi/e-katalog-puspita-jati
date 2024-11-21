// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/colors_controller.dart';
import 'package:e_katalog/model/colors_model.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:e_katalog/view/global/text_primary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class ColorsView extends StatelessWidget {
  const ColorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorsController controller = Get.find();

    TextEditingController nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Center(
          child: TextGelasio(
            text: "Ubah Warna",
            fontSize: 20.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [],
      ),
      body: Obx(() => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                            width: 180,
                            child:
                                Text("Pilih Warna Untuk Semua Item Product")),
                        Expanded(
                          child: Align(
                            alignment: Alignment.topRight,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                side: const BorderSide(color: Colors.black38),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    Color pickerColor = Colors.blue;
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextPrimary(
                                              text: "Nama warna",
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.bold,
                                            ),
                                            const SizedBox(
                                              height: 4.0,
                                            ),
                                            TextFormField(
                                              controller: nameController,
                                              keyboardType: TextInputType.text,
                                              decoration: InputDecoration(
                                                hintText: "contoh : coklat tua",
                                                hintStyle: const TextStyle(
                                                    color: AppColors.secondary),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  borderSide: const BorderSide(
                                                      color: Colors.black),
                                                ),
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 15.0,
                                            ),
                                            ColorPicker(
                                              pickerColor: pickerColor,
                                              onColorChanged: (Color color) {
                                                pickerColor = color;
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Tambah warna'),
                                          onPressed: () {
                                            if (nameController.text.isEmpty) {
                                              // Menampilkan pesan peringatan jika `nameController` kosong
                                              Get.snackbar("Gagal menambahkan",
                                                  "nama warna tidak boleh kosong");
                                            } else {
                                              final colorsModel = ColorsModel(
                                                name: nameController.text,
                                                color: controller
                                                    .colorToHex(pickerColor),
                                              );

                                              controller
                                                  .addColorToList(colorsModel);
                                              Navigator.of(context).pop();
                                            }
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text("Tambah Warna"),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(10),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: AppColors.disable),
                      child: Obx(
                        () => ListView.builder(
                          itemCount: controller.colorsModel.value.length,
                          shrinkWrap: true,
                          physics: const ScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            List<ColorsModel?> colors =
                                controller.colorsModel.value;

                            final colorHex = colors[index];
                            final color = Color(int.parse(
                                colorHex!.color!.replaceFirst('#', '0xff')));

                            final textColor = color == Colors.white
                                ? Colors.grey
                                : Colors.white;
                            return Card(
                              color: color,
                              child: ListTile(
                                title: Text(
                                  colorHex.name!,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                subtitle: Text(
                                  colorHex.color!,
                                  style: TextStyle(
                                    color: textColor,
                                    fontWeight: FontWeight.w500,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: Icon(
                                    Icons.delete,
                                    color: textColor,
                                  ),
                                  onPressed: () =>
                                      controller.deleteColor(colors[index]!),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
              ),
            )),
    );
  }
}
