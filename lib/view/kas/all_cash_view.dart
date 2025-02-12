import 'package:e_katalog/constant/app_colors.dart';
import 'package:e_katalog/constant/app_route.dart';
import 'package:e_katalog/controller/cash_controller.dart';
import 'package:e_katalog/helper/format_rupiah.dart';
import 'package:e_katalog/model/cash_model.dart';
import 'package:e_katalog/view/global/text_primary.dart';
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

    TextEditingController searchController = TextEditingController();
    RxString searchQuery = ''.obs;

    return Obx(() {
      if (cashController.cash.isEmpty && cashController.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      } else {
        List<CashModel> data = cashController.cash;

        Map<String, List<CashModel>> groupedData =
            groupDataByMonthWithName(data);

        Map<String, int> monthlyBalance = calculateMonthlyBalance(groupedData);

        // Filter data berdasarkan query pencarian
        if (searchQuery.value.isNotEmpty) {
          groupedData = groupedData.map((monthName, transactions) {
            return MapEntry(
              monthName,
              transactions.where((item) {
                return monthName
                    .toLowerCase()
                    .contains(searchQuery.value.toLowerCase());
              }).toList(),
            );
          }).cast<String, List<CashModel>>();
        }
        return Scaffold(
          // key: scaffoldKey,
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Get.offAllNamed(AppRoute.nav),
            ),
            centerTitle: true,
            title: TextPrimary(
              text: "Buku Kas",
              fontSize: 22,
              fontWeight: FontWeight.w700,
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.menu_outlined,
                  size: 30,
                  color: AppColors.teal,
                ),
                onPressed: () {
                  Get.toNamed(AppRoute.category);
                },
              ),
              const SizedBox(width: 5.0),
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              await cashController.getAllCash();
            },
            child: SingleChildScrollView(
              child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const SizedBox(height: 18.0),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Focus(
                              onFocusChange: (hasFocus) {
                                cashController.showButton.value = hasFocus;
                              },
                              child: TextField(
                                controller: searchController,
                                onChanged: (value) {
                                  searchQuery.value =
                                      value.trim(); // Update query
                                },
                                decoration: InputDecoration(
                                  hintText:
                                      "Cari berdasarkan bulan (contoh: 2024-01)",
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  prefixIcon: const Icon(Icons.search),
                                ),
                              ),
                            ),
                          ),
                          cashController.showButton.value
                              ? const SizedBox()
                              : Container(
                                  margin: const EdgeInsets.only(left: 10),
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 10),
                                      elevation: 0,
                                      backgroundColor: AppColors.teal,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                    onPressed: () {
                                      Get.toNamed(AppRoute.addCash);
                                    },
                                    child: const Text(
                                      "+  Tambah Catatan",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                )
                        ],
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ListView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: groupedData.entries.length,
                      itemBuilder: (context, index) {
                        final entry = groupedData.entries.elementAt(index);
                        final String month = entry.key;
                        final List<CashModel> transactions = entry.value;

                        if (transactions.isEmpty) return const SizedBox();

                        final int totalDebet = transactions.fold(
                            0, (sum, item) => sum + (item.debet ?? 0));
                        final int totalKredit = transactions.fold(
                            0, (sum, item) => sum + (item.kredit ?? 0));
                        final int saldo = monthlyBalance[month]!;

                        return Card(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextPrimary(
                                  text: month,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18,
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    _buildInfoColumnWithFixedWidth(
                                        'Total Debet',
                                        formatRupiah(totalDebet)),
                                    _buildInfoColumnWithFixedWidth(
                                        'Total Kredit',
                                        formatRupiah(totalKredit)),
                                    _buildInfoColumnWithFixedWidth(
                                        'Saldo', formatRupiah(saldo)),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 2,
                                      backgroundColor: AppColors.teal,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                    ),
                                    onPressed: () {
                                      String bulan =
                                          transactions[0].tanggal ?? "";
                                      String bulanTahun = bulan.substring(0, 7);
                                      Get.to(() =>
                                          CashDetailScreen(bulan: bulanTahun));
                                    },
                                    child: const Text("Detail",
                                        style: TextStyle(color: Colors.white)),
                                  ),
                                ),
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
    });
  }
}

Map<String, List<CashModel>> groupDataByMonthWithName(List<CashModel> data) {
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
    String monthName =
        getNamaBulanDanTahun(month); // Mengubah ke format nama bulan

    if (groupedData[monthName] == null) {
      groupedData[monthName] = [];
    }
    groupedData[monthName]!.add(item);
  }
  return groupedData;
}

Widget _buildCustomListTile({
  required String title,
  required Color color,
  required VoidCallback onTap,
}) {
  return ListTile(
    title: TextPrimary(
      text: title,
      fontSize: 18,
      fontWeight: FontWeight.w700,
      overflow: TextOverflow.ellipsis,
    ),
    trailing: const Icon(
      Icons.arrow_forward_ios,
      color: Colors.grey,
      size: 20,
    ),
    onTap: onTap,
  );
}

Widget _buildInfoColumnWithFixedWidth(String title, String value) {
  return SizedBox(
    width: 100, // Atur lebar tetap untuk setiap kolom
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextPrimary(
          text: title,
          fontWeight: FontWeight.w400,
          color: AppColors.secondary,
          fontSize: 14,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        TextPrimary(
          text: value,
          fontWeight: FontWeight.w700,
          fontSize: 16,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
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
