import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/cash_controller.dart';
import 'package:e_katalog/model/cash_model.dart';
import 'package:e_katalog/view/kas/add_cash_category_view.dart';
import 'package:e_katalog/view/kas/detail_cash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AllCashView extends StatelessWidget {
  const AllCashView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    CashController cashController = Get.put(CashController());
    cashController.getAllCash();

    CashCategoryContoller categoryController = Get.put(CashCategoryContoller());
    categoryController.getAllCategory();

    Map<String, List<CashModel>> groupDataByMonth(List<CashModel> data) {
      // Urutkan data berdasarkan tanggal secara descending
      data.sort((a, b) {
        DateTime dateA = DateTime.parse(a.tanggal ?? "1970-01-01");
        DateTime dateB = DateTime.parse(b.tanggal ?? "1970-01-01");
        return dateB.compareTo(dateA); // Descending order
      });

      Map<String, List<CashModel>> groupedData = {};

      for (var item in data) {
        // Format bulan (contoh: "2024-01")
        String month = item.tanggal?.substring(0, 7) ?? "Unknown";

        if (groupedData[month] == null) {
          groupedData[month] = [];
        }
        groupedData[month]!.add(item);
      }
      return groupedData;
    }

    Map<String, int> calculateMonthlyBalance(
        Map<String, List<CashModel>> groupedData) {
      Map<String, int> monthlyBalance = {};

      groupedData.forEach((month, transactions) {
        int totalDebet =
            transactions.fold(0, (sum, item) => sum + (item.debet ?? 0));
        int totalKredit =
            transactions.fold(0, (sum, item) => sum + (item.kredit ?? 0));
        monthlyBalance[month] = totalDebet - totalKredit;
      });

      return monthlyBalance;
    }

    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Get.offAllNamed(AppRoute.nav),
          ),
          title: const Text("Monthly Cash Flow")),
      body: Obx(() {
        if (cashController.cash.isEmpty && cashController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          List<CashModel> data = cashController.cash;
          Map<String, List<CashModel>> groupedData = groupDataByMonth(data);
          Map<String, int> monthlyBalance =
              calculateMonthlyBalance(groupedData);
          return RefreshIndicator(
            onRefresh: () async {
              await cashController.getAllCash();
            },
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    height: 5.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            // side: const BorderSide(color: Colors.black38),
                            backgroundColor: AppColors.teal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(AppRoute.addCash);
                          },
                          child: const Text(
                            "Tambah Catatan",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 2.0,
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            elevation: 0,
                            side: const BorderSide(color: Colors.black38),
                            backgroundColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onPressed: () {
                            Get.toNamed(AppRoute.category);
                          },
                          child: const Text("  Lihat Kategori  "),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      columnSpacing: 10,
                      columns: const [
                        DataColumn(
                            label: Text(
                          'Bulan',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                        DataColumn(
                            label: Column(
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Debet',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        DataColumn(
                            label: Column(
                          children: [
                            Text(
                              'Total',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Kredit',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        DataColumn(
                            label: Column(
                          children: [
                            Text(
                              'Jumlah',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Saldo',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        )),
                        DataColumn(
                            label: Text(
                          'Detail',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
                      ],
                      rows: groupedData.entries.map((entry) {
                        String month = entry.key;
                        List<CashModel> transactions = entry.value;

                        int totalDebet = transactions.fold(
                            0, (sum, item) => sum + (item.debet ?? 0));
                        int totalKredit = transactions.fold(
                            0, (sum, item) => sum + (item.kredit ?? 0));
                        int saldo = monthlyBalance[month]!;

                        return DataRow(cells: [
                          DataCell(Text(getNamaBulanDanTahun(month))),
                          DataCell(Text(totalDebet.toString())),
                          DataCell(Text(totalKredit.toString())),
                          DataCell(Text(saldo.toString())),
                          DataCell(
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                side: const BorderSide(color: Colors.black38),
                                backgroundColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              onPressed: () {
                                String bulan = month.substring(0, 7);
                                Get.to(() => CashDetailScreen(bulan: bulan));
                              },
                              child: const Text("Detail"),
                            ),
                          ),
                        ]);
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}

String getNamaBulanDanTahun(String input) {
  // Memastikan input memiliki format yang benar
  if (input.isEmpty || !RegExp(r'^\d{4}-\d{2}$').hasMatch(input)) {
    return 'Format tidak valid';
  }

  // Ekstrak tahun dan bulan dari input
  String tahun = input.split('-')[0];
  String bulan = input.split('-')[1];

  // Nama bulan berdasarkan kode bulan
  String namaBulan;
  switch (bulan) {
    case '01':
      namaBulan = 'Januari';
      break;
    case '02':
      namaBulan = 'Februari';
      break;
    case '03':
      namaBulan = 'Maret';
      break;
    case '04':
      namaBulan = 'April';
      break;
    case '05':
      namaBulan = 'Mei';
      break;
    case '06':
      namaBulan = 'Juni';
      break;
    case '07':
      namaBulan = 'Juli';
      break;
    case '08':
      namaBulan = 'Agustus';
      break;
    case '09':
      namaBulan = 'September';
      break;
    case '10':
      namaBulan = 'Oktober';
      break;
    case '11':
      namaBulan = 'November';
      break;
    case '12':
      namaBulan = 'Desember';
      break;
    default:
      return 'Bulan tidak valid';
  }

  // Gabungkan nama bulan dan tahun
  return '$namaBulan $tahun';
}
