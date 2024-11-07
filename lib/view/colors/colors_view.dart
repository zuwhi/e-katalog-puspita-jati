// ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables

import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/controller/colors_controller.dart';
import 'package:e_katalog/view/global/button_primary.dart';
import 'package:e_katalog/view/global/text_gelasio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:get/get.dart';

class ColorsView extends StatelessWidget {
  const ColorsView({super.key});

  @override
  Widget build(BuildContext context) {
    final ColorsController controller = Get.find();
    controller.selectedColors.value =
        controller.colorsModel.value?.colors.split(",") ?? [];

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
                                      title: const Text('Pilih Warna'),
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: pickerColor,
                                          onColorChanged: (Color color) {
                                            pickerColor = color;
                                          },
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          child: const Text('Pilih'),
                                          onPressed: () {
                                            controller.addColor(pickerColor);
                                            Navigator.of(context).pop();
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
                      child: Obx(() => Column(
                            children: List.generate(
                              controller.selectedColors.length,
                              (index) {
                                final colorHex =
                                    controller.selectedColors[index];
                                final color = Color(int.parse(
                                    colorHex.replaceFirst('#', '0xff')));

                                final textColor = color == Colors.white
                                    ? Colors.grey
                                    : Colors.white;

                                return Card(
                                  color: color,
                                  child: ListTile(
                                    title: Text(
                                      colorHex,
                                      style: TextStyle(
                                        color: textColor,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(
                                        Icons.close,
                                        color: Colors.red,
                                      ),
                                      onPressed: () =>
                                          controller.removeColor(index),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )),
                    ),
                    const SizedBox(
                      height: 60.0,
                    ),
                  ],
                ),
              ),
            )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
          padding: const EdgeInsets.symmetric(vertical: 18.0, horizontal: 30),
          child: ButtonPrimary(
              isActive: true,
              backgroundColor: AppColors.primary,
              text: "Simpan Perubahan",
              onPressed: () async {
                controller.updateColor();
              })),
    );
  }
}
