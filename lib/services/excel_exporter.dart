import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/product.dart';

class ExcelExporter {
  Future<void> exportSales(Map<Product, int> orders) async {
    // Minta izin akses storage
    var status = await Permission.storage.request();
    if (!status.isGranted) return;

    final excel = Excel.createExcel();
    final sheet = excel['Sales'];

    // Header
    sheet.appendRow(['Product', 'Quantity', 'Price', 'Subtotal']);

    // Data rows
    for (var entry in orders.entries) {
      final product = entry.key;
      final qty = entry.value;
      final subtotal = qty * product.price;

      sheet.appendRow([
        product.name,
        qty,
        product.price,
        subtotal,
      ]);
    }

    // Total
    double total = orders.entries.fold(0, (sum, e) => sum + e.key.price * e.value);
    sheet.appendRow([]);
    sheet.appendRow(['', '', 'Total', total]);

    // Simpan file
    final directory = await getExternalStorageDirectory();
    final path = '${directory!.path}/sales_report.xlsx';
    final fileBytes = excel.encode();
    final file = File(path)
      ..createSync(recursive: true)
      ..writeAsBytesSync(fileBytes!);

    print('Excel exported: $path');
  }
}
