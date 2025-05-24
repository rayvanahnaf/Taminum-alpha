import 'package:flutter/material.dart';
import 'package:flutter_pos/models/product.dart';
import 'package:flutter_pos/screens/pos/order_confirmation_page.dart';
import 'package:flutter_pos/widgets/auth/pages/login_page.dart';


class PosScreen extends StatefulWidget {
  const PosScreen({Key? key}) : super(key: key);

  @override
  State<PosScreen> createState() => _PosScreenState();
}

class _PosScreenState extends State<PosScreen> {
  String selectedCategory = 'Coffee';
  final Map<Product, int> cart = {};

  final customerNameController = TextEditingController();
  final tableController = TextEditingController();

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
  void dispose() {
    customerNameController.dispose();
    tableController.dispose();
    super.dispose();
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
                    IconButton(
                      icon: const Icon(Icons.logout),
                      tooltip: 'Logout',
                      onPressed: () {
                        Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => const LoginPage()),
                              (route) => false,
                        );
                      },
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
                        children: [
                          Expanded(
                            child: TextField(
                              controller: customerNameController,
                              decoration: const InputDecoration(labelText: 'Customer name'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: tableController,
                              decoration: const InputDecoration(labelText: 'Table'),
                            ),
                          ),
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
                                        Text('\$${product.price.toStringAsFixed(2)}'),
                                      ],
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                        onPressed: () => _changeQuantity(product, -1),
                                      ),
                                      Text('$qty'),
                                      IconButton(
                                        icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                                        onPressed: () => _changeQuantity(product, 1),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Total: \$${total.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: cart.isEmpty
                            ? null
                            : () {
                          final customerName = customerNameController.text.trim();
                          final table = tableController.text.trim();

                          if (customerName.isEmpty || table.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Please fill customer name and table'),
                                backgroundColor: Colors.red,
                              ),
                            );
                            return;
                          }

                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => OrderConfirmationPage(
                                cart: Map<Product, int>.from(cart),
                                total: total, // <== ini harus kamu hitung dulu
                                customerName: customerName,
                                table: table,
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size.fromHeight(48),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                        ),
                        child: const Text('Place Order'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
