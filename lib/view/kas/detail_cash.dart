import 'dart:io';

import 'package:e_katalog/controller/cash_controller.dart';
import 'package:e_katalog/model/cash_model.dart';
import 'package:e_katalog/view/kas/image_preview.dart';
import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

class CashDetailScreen extends StatelessWidget {
  final String bulan;

  CashDetailScreen({super.key, required this.bulan});

  final CashController controller = Get.find<CashController>();

  Future<void> exportToExcel(
      List<CashModel> data,
      Map<String, int> biayaPerKategori,
      int totalDebet,
      int totalBiaya,
      int labaRugi) async {
    // Meminta izin akses penyimpanan
    if (await Permission.storage.request().isGranted) {
      // Membuat workbook Excel
      var excel = Excel.createExcel();

      // Sheet 1: Buku Kas Harian
      Sheet sheetKas = excel['Buku Kas Harian'];
      sheetKas.appendRow([
        'No',
        'Tanggal',
        'Transaksi',
        'Kategori',
        'Debet',
        'Kredit',
        'Saldo',
      ]);

      int saldo = 0;
      for (int i = 0; i < data.length; i++) {
        final item = data[i];
        saldo += (item.debet ?? 0) - (item.kredit ?? 0);
        sheetKas.appendRow([
          (i + 1).toString(),
          item.tanggal ?? '-',
          item.title ?? '-',
          item.kategori ?? '-',
          item.debet?.toString() ?? '0',
          item.kredit?.toString() ?? '0',
          saldo.toString(),
        ]);
      }

      // Sheet 2: Laporan Laba Rugi
      Sheet sheetLabaRugi = excel['Laporan Laba Rugi'];
      sheetLabaRugi.appendRow(['Pendapatan', totalDebet.toString()]);
      sheetLabaRugi.appendRow(['Total Pendapatan', '', totalDebet.toString()]);
      sheetLabaRugi.appendRow(['Harga Pokok Produksi']);

      for (var entry in biayaPerKategori.entries) {
        sheetLabaRugi.appendRow([entry.key, entry.value.toString()]);
      }
      sheetLabaRugi.appendRow(['Total Biaya', '', totalBiaya.toString()]);
      sheetLabaRugi.appendRow(['Laba/Rugi', '', labaRugi.toString()]);

      // Mendapatkan direktori Downloads
      final directory = Directory('/storage/emulated/0/Download');
      if (!directory.existsSync()) {
        directory.createSync(recursive: true);
      }

      // Menyimpan file di folder Download
      final filePath =
          "${directory.path}/cash_data_${DateTime.now().toString().split(" ")[0]}.xlsx";

      // Simpan file
      File(filePath)
        ..createSync(recursive: true)
        ..writeAsBytesSync(excel.encode()!);

      Get.snackbar('Success', 'File berhasil disimpan di: $filePath');
    } else {
      Get.snackbar('Error', 'Izin penyimpanan tidak diberikan.');
    }
  }

  @override
  Widget build(BuildContext context) {
    // Filter data berdasarkan bulan
    final List<CashModel> filteredCash = controller.cash
        .where((cash) => cash.tanggal?.startsWith(bulan) ?? false)
        .toList();

    // Hitung total debet, kredit, dan saldo
    int totalDebet =
        filteredCash.fold(0, (sum, item) => sum + (item.debet ?? 0));
    int totalKredit =
        filteredCash.fold(0, (sum, item) => sum + (item.kredit ?? 0));
    int saldoAkhir = totalDebet - totalKredit;

    // Mengkategorikan biaya secara dinamis
    Map<String, int> biayaPerKategori = {};
    for (var cash in filteredCash) {
      if (cash.kategori != null && cash.kredit != null) {
        biayaPerKategori.update(
          cash.kategori!,
          (value) => value + cash.kredit!,
          ifAbsent: () => cash.kredit!,
        );
      }
    }

    // Hitung total biaya dari semua kategori
    int totalBiaya =
        biayaPerKategori.values.fold(0, (sum, biaya) => sum + biaya);

    // Hitung laba/rugi
    int labaRugi = totalDebet - totalBiaya;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Kas - Bulan $bulan',
          style: const TextStyle(
            fontSize: 17.0,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const Text(
                        'Buku Kas Harian',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Bulan $bulan',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.black,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      exportToExcel(filteredCash, biayaPerKategori, totalDebet,
                          totalBiaya, labaRugi);
                    },
                    child: const Icon(Icons.download, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 5),
            // DataTable Kas
            TabelHarianKas(
                filteredCash: filteredCash,
                controller: controller,
                totalDebet: totalDebet,
                totalKredit: totalKredit,
                saldoAkhir: saldoAkhir),
            const SizedBox(height: 30),
            // Tabel Laporan Laba Rugi
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Laporan Laba Rugi',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Table(
                    border: TableBorder.all(color: Colors.black54),
                    columnWidths: const {
                      0: FixedColumnWidth(200),
                      1: FixedColumnWidth(100),
                      2: FixedColumnWidth(100),
                    },
                    children: [
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Pendapatan',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(totalDebet.toString()),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(""),
                        ),
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.only(
                              left: 20.0, top: 8.0, bottom: 8.0),
                          child: Text('Total Pendapatan'),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(""),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(totalDebet.toString()),
                        ),
                      ]),
                      const TableRow(children: [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Harga Pokok Produksi',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(""),
                        ),
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(""),
                        ),
                      ]),
                      ...biayaPerKategori.entries.map(
                        (entry) => TableRow(children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 8.0, bottom: 8.0),
                            child: Text(entry.key),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(entry.value.toString()),
                          ),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(""),
                          ),
                        ]),
                      ),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Total Biaya',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(""),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(totalBiaya.toString()),
                        ),
                      ]),
                      TableRow(children: [
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Laba/Rugi',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(""),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            labaRugi.toString(),
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: labaRugi >= 0 ? Colors.green : Colors.red,
                            ),
                          ),
                        ),
                      ]),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TabelHarianKas extends StatelessWidget {
  const TabelHarianKas({
    super.key,
    required this.filteredCash,
    required this.controller,
    required this.totalDebet,
    required this.totalKredit,
    required this.saldoAkhir,
  });

  final List<CashModel> filteredCash;
  final CashController controller;
  final int totalDebet;
  final int totalKredit;
  final int saldoAkhir;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        columnSpacing: 20,
        columns: const [
          DataColumn(label: Text('No')),
          DataColumn(label: Text('Tanggal')),
          DataColumn(label: Text('Transaksi')),
          DataColumn(label: Text('Kategori')),
          DataColumn(label: Text('Debet')),
          DataColumn(label: Text('Kredit')),
          DataColumn(label: Text('Saldo')),
          DataColumn(label: Text('Nota')),
          DataColumn(label: Text('Perintah')),
        ],
        rows: filteredCash.map((item) {
          int index = filteredCash.indexOf(item);
          int saldo = filteredCash.sublist(0, index + 1).fold(
                0,
                (sum, i) => sum + (i.debet ?? 0) - (i.kredit ?? 0),
              );
          return DataRow(cells: [
            DataCell(Text((index + 1).toString())),
            DataCell(Text(item.tanggal ?? '-')),
            DataCell(Text(item.title ?? '-')),
            DataCell(Text(item.kategori ?? '-')),
            DataCell(Text(item.debet?.toString() ?? '-')),
            DataCell(Text(item.kredit?.toString() ?? '-')),
            DataCell(Text(saldo.toString())),
            DataCell(IconButton(
                icon: const Icon(Icons.remove_red_eye),
                onPressed: () =>
                    Get.to(() => ImagePreviewPage(), arguments: item.image))),
            DataCell(IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () {
                  // Dialog konfirmasi hapus
                  Get.dialog(AlertDialog(
                    title: const Text('Konfirmasi'),
                    content: const Text(
                        'Apakah Anda yakin ingin menghapus catatan ini?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.deleteCash(item);
                          Navigator.pop(context);
                        },
                        child: const Text('Hapus'),
                      ),
                    ],
                  ));
                })),
          ]);
        }).toList()
          ..add(
            DataRow(cells: [
              const DataCell(Text('')),
              const DataCell(Text('Saldo akhir',
                  style: TextStyle(fontWeight: FontWeight.bold))),
              const DataCell(Text('')),
              const DataCell(Text('')),
              DataCell(Text(totalDebet.toString())),
              DataCell(Text(totalKredit.toString())),
              DataCell(Text(
                saldoAkhir.toString(),
                style: const TextStyle(
                    color: Colors.red, fontWeight: FontWeight.bold),
              )),
              const DataCell(Text('')),
              const DataCell(Text('')),
            ]),
          ),
      ),
    );
  }
}
