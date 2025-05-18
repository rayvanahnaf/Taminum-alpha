import 'package:flutter/material.dart';

import '../../models/product.dart';


class CheckoutScreen extends StatelessWidget {
  final Map<Product, int> orders;

  const CheckoutScreen({Key? key, required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double totalPrice = 0;
    orders.forEach((product, qty) {
      totalPrice += product.price * qty;
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Checkout'),
      ),
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: orders.isEmpty
            ? const Center(
          child: Text(
            'No orders to checkout.',
            style: TextStyle(color: Colors.white),
          ),
        )
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: orders.length,
                itemBuilder: (context, index) {
                  Product product = orders.keys.elementAt(index);
                  int qty = orders[product]!;
                  return ListTile(
                    title: Text(
                      '${product.name} (x$qty)',
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing: Text(
                      '\$${(product.price * qty).toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Total: \$${totalPrice.toStringAsFixed(2)}',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                // Implement payment logic
                Navigator.pop(context);
              },
              child: const Text('Confirm Payment'),
            )
          ],
        ),
      ),
    );
  }
}
