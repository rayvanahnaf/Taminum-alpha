import 'package:flutter/material.dart';

import '../dashboard/dashboard_screen.dart';

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
            const Text('Thank you for your order!', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: cart.entries.map((entry) {
                  final product = entry.key;
                  final qty = entry.value;
                  return ListTile(
                    leading: Image.asset(product.imageUrl, width: 50, height: 50),
                    title: Text(product.name),
                    trailing: Text('x$qty'),
                  );
                }).toList(),
              ),
            ),
            Text('Total: \$${total.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Back to POS'),
            ),
          ],
        ),
      ),
    );
  }
}
