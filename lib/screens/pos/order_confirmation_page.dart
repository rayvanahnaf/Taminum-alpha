import 'package:flutter/material.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class OrderConfirmationPage extends StatelessWidget {
  final Map<Product, int> cart;
  final double total;

  const OrderConfirmationPage({
    Key? key,
    required this.cart,
    required this.total,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const Text(
              'Thank you for your order!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: cart.entries.map((entry) {
                  final product = entry.key;
                  final qty = entry.value;
                  return ListTile(
                    leading: product.imageUrl.isNotEmpty
                        ? Image.asset(product.imageUrl, width: 50, height: 50)
                        : const Icon(Icons.image_not_supported),
                    title: Text(product.name),
                    trailing: Text('x$qty'),
                  );
                }).toList(),
              ),
            ),
            Text(
              'Total: \$${total.toStringAsFixed(2)}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Back to POS'),
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => _printReceipt(),
              child: const Text('Print Receipt'),
            ),
          ],
        ),
      ),
    );
  }

  void _printReceipt() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.roll80,
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text('Order Receipt',
                style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),
            ...cart.entries.map((entry) {
              final product = entry.key;
              final qty = entry.value;
              return pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${product.name} x$qty'),
                  pw.Text('\$${(product.price * qty).toStringAsFixed(2)}'),
                ],
              );
            }).toList(),
            pw.Divider(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Total',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('\$${total.toStringAsFixed(2)}',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ],
            ),
            pw.SizedBox(height: 10),
            pw.Text('Thank you!', style: pw.TextStyle(fontSize: 14)),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
