import 'package:flutter/material.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:intl/intl.dart';

class OrderConfirmationPage extends StatelessWidget {
  final Map<Product, int> cart;
  final double total;
  final String customerName;
  final String table;

  const OrderConfirmationPage({
    Key? key,
    required this.cart,
    required this.total,
    required this.customerName,
    required this.table,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order Confirmation')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Thank you for your order!',
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text('Customer: $customerName', style: const TextStyle(fontSize: 16)),
            Text('Table: $table', style: const TextStyle(fontSize: 16)),
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
            // Header
            pw.Center(
              child: pw.Text('Taminum',
                  style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold,
                  )),
            ),
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text('123 Business Address, City',
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.SizedBox(height: 4),
            pw.Center(
              child: pw.Text('Tel: (123) 456-7890 | Tax ID: 123456789',
                  style: pw.TextStyle(fontSize: 10)),
            ),
            pw.SizedBox(height: 8),
            pw.Center(
              child: pw.Text('RECEIPT',
                  style: pw.TextStyle(
                    fontSize: 14,
                    fontWeight: pw.FontWeight.bold,
                  )),
            ),
            pw.SizedBox(height: 8),

            // Customer info
            pw.Text('Customer: $customerName', style: pw.TextStyle(fontSize: 10)),
            pw.Text('Table: $table', style: pw.TextStyle(fontSize: 10)),
            pw.SizedBox(height: 8),

            pw.Row(
              children: [
                pw.Text('Date: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                    style: pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.Divider(thickness: 1),

            // Items
            pw.Column(
              children: [
                // Header row
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Item', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Qty', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Price', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    pw.Text('Total', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  ],
                ),
                pw.Divider(thickness: 0.5),

                // Item rows
                ...cart.entries.map((entry) {
                  final product = entry.key;
                  final qty = entry.value;
                  final itemTotal = product.price * qty;

                  return pw.Padding(
                    padding: const pw.EdgeInsets.symmetric(vertical: 4),
                    child: pw.Row(
                      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                      children: [
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(product.name, style: const pw.TextStyle(fontSize: 10)),
                        ),
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text('x$qty', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.center),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text('\$${product.price.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
                        ),
                        pw.Expanded(
                          flex: 2,
                          child: pw.Text('\$${itemTotal.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 10), textAlign: pw.TextAlign.right),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),

            pw.Divider(thickness: 1),

            // Totals
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Subtotal:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('\$${total.toStringAsFixed(2)}', style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('Tax (0%):', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                pw.Text('\$0.00', style: const pw.TextStyle(fontSize: 10)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
                pw.Text('\$${total.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 12)),
              ],
            ),

            // Footer
            pw.SizedBox(height: 16),
            pw.Center(child: pw.Text('Thank you for your business!', style: pw.TextStyle(fontSize: 12))),
            pw.SizedBox(height: 8),
            pw.Center(child: pw.Text('Returns accepted within 14 days with receipt', style: const pw.TextStyle(fontSize: 8))),
            pw.Center(child: pw.Text('Page 1 of 1', style: const pw.TextStyle(fontSize: 8))),
          ],
        ),
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save());
  }
}
