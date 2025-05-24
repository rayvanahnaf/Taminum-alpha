import 'package:flutter/material.dart';
import '../../models/product.dart';

class ProductSelection extends StatelessWidget {
  final Function(Product) onProductSelected;

  const ProductSelection({Key? key, required this.onProductSelected}) : super(key: key);

  final List<Product> products = const [
    Product(name: 'Burger', price: 5.0),
    Product(name: 'Pizza', price: 8.0),
    Product(name: 'Fries', price: 3.0),
    Product(name: 'Hotdog', price: 4.0),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Products', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => onProductSelected(products[index]),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    margin: const EdgeInsets.only(bottom: 10),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${products[index].name} - \$${products[index].price.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}
