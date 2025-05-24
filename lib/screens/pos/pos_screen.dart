import 'package:flutter/material.dart';

class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String category;

  Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.category,
  });
}

class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  String selectedCategory = 'Coffee';
  final Map<Product, int> cart = {};

  final List<Product> allProducts = [
    Product(name: 'Espresso', price: 4.2, imageUrl: 'assets/coffee.png', category: 'Coffee'),
    Product(name: 'Latte', price: 4.0, imageUrl: 'assets/coffee 1.png', category: 'Coffee'),
    Product(name: 'Green Jasmine Tea', price: 4.0, imageUrl: 'assets/tea.png', category: 'Tea'),
    Product(name: 'Chamomile', price: 4.0, imageUrl: 'assets/tea 1.png', category: 'Tea'),
    Product(name: 'Avocado Toast', price: 4.0, imageUrl: 'assets/snacks.png', category: 'Snack'),
    Product(name: 'Acai Bowl', price: 3.0, imageUrl: 'assets/snacks 1.png', category: 'Snack'),
  ];

  List<Product> get filteredProducts =>
      allProducts.where((p) => p.category == selectedCategory).toList();

  void _addToCart(Product product) {
    setState(() {
      cart[product] = (cart[product] ?? 0) + 1;
    });
  }

  void _changeQuantity(Product product, int delta) {
    setState(() {
      final currentQty = cart[product] ?? 0;
      final newQty = currentQty + delta;
      if (newQty <= 0) {
        cart.remove(product);
      } else {
        cart[product] = newQty;
      }
    });
  }

  double get total =>
      cart.entries.fold(0.0, (sum, item) => sum + item.key.price * item.value);

  Widget buildCategoryCards() {
    final categories = [
      {'name': 'Coffee', 'count': 50, 'status': 'Available', 'color': Colors.green},
      {'name': 'Tea', 'count': 20, 'status': 'Available', 'color': Colors.grey},
      {'name': 'Snack', 'count': 10, 'status': 'Need to re-stock', 'color': Colors.red},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: categories.map((cat) {
          final isSelected = cat['name'] == selectedCategory;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  selectedCategory = cat['name'] as String;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: isSelected ? Colors.green : Colors.grey.shade300,
                    width: 2,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: (cat['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        cat['status']?.toString() ?? '',
                        style: TextStyle(
                          color: cat['color'] as Color,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      cat['name']?.toString() ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('${cat['count']} items'),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFEDE4),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 32, 16, 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('assets/logo.png', height: 40),
                    const SizedBox(width: 12),
                    Column(crossAxisAlignment: CrossAxisAlignment.start),
                  ],
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.qr_code_scanner),
                          onPressed: () {},
                        ),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(24)),
                        contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: [
                    Text('Total : ${cart.length} Orders',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      ),
                      child: const Text('Report', style: TextStyle(color: Colors.green)),
                    ),
                    const SizedBox(width: 16),
                    Stack(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.notifications_none),
                          onPressed: () {},
                        ),
                        Positioned(
                          right: 4,
                          top: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const CircleAvatar(
                      backgroundImage: AssetImage('assets/user.png'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              children: [
                // LEFT
                Expanded(
                  flex: 3,
                  child: Column(
                    children: [
                      buildCategoryCards(),
                      const SizedBox(height: 16),
                      Expanded(
                        child: GridView.count(
                          padding: const EdgeInsets.all(16),
                          crossAxisCount: 4,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                          childAspectRatio: 0.7,
                          children: filteredProducts.map((product) {
                            return GestureDetector(
                              onTap: () => _addToCart(product),
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  border: Border.all(color: Colors.green, width: 1),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 120,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Image.asset(
                                          product.imageUrl,
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Text('\$${product.price.toStringAsFixed(2)}'),
                                  ],
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ],
                  ),
                ),
                // RIGHT
                Container(
                  width: 320,
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: const [
                          Expanded(child: TextField(decoration: InputDecoration(labelText: 'Customer name'))),
                          SizedBox(width: 8),
                          Expanded(child: TextField(decoration: InputDecoration(labelText: 'Table'))),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Order list', style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView(
                          children: cart.entries.map((entry) {
                            final product = entry.key;
                            final qty = entry.value;
                            return Container(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.green),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: Image.asset(
                                      product.imageUrl,
                                      width: 50,
                                      height: 50,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(product.name,
                                            style: const TextStyle(fontWeight: FontWeight.bold)),
                                        Text('\$${product.price.toStringAsFixed(2)} x$qty'),
                                        const Text('Medium • Less Sugar',
                                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove, size: 20),
                                        onPressed: () => _changeQuantity(product, -1),
                                      ),
                                      Text('$qty'),
                                      IconButton(
                                        icon: const Icon(Icons.add, size: 20),
                                        onPressed: () => _changeQuantity(product, 1),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text('Subtotal: \$${total.toStringAsFixed(2)}'),
                      Text('Tax: \$${(total * 0.1).toStringAsFixed(2)}'),
                      Text('Total: \$${(total * 1.1).toStringAsFixed(2)}',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        icon: const Icon(Icons.check_circle),
                        label: Text('Place Order   \$${(total * 1.1).toStringAsFixed(2)}'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(double.infinity, 50),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
