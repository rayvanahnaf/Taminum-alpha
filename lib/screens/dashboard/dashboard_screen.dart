import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../widgets/dashboard/product_selection.dart';
import '../../widgets/dashboard/kitchen_orders.dart';
import '../../widgets/dashboard/order_summary.dart';
import '../checkout/checkout_screen.dart'; // Pastikan path ini benar

class DashboardScreen extends StatefulWidget {
  final VoidCallback onToggleTheme;

  const DashboardScreen({Key? key, required this.onToggleTheme}) : super(key: key);

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  Map<Product, int> orders = {};

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void addOrder(Product product) {
    setState(() {
      orders.update(product, (qty) => qty + 1, ifAbsent: () => 1);
    });
    showSnackbar('${product.name} ditambahkan ke dapur');
  }

  void removeOrder(Product product) {
    setState(() {
      orders.remove(product);
    });
    showSnackbar('${product.name} dihapus dari dapur');
  }

  void increaseQty(Product product) {
    setState(() {
      orders[product] = orders[product]! + 1;
    });
    showSnackbar('${product.name} +1');
  }

  void decreaseQty(Product product) {
    setState(() {
      if (orders[product]! > 1) {
        orders[product] = orders[product]! - 1;
        showSnackbar('${product.name} -1');
      } else {
        orders.remove(product);
        showSnackbar('${product.name} dihapus dari dapur');
      }
    });
  }

  void goToCheckout() {
    if (orders.isEmpty) {
      showSnackbar("Tidak ada pesanan untuk checkout!");
      return;
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CheckoutScreen(orders: orders),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Product Selection (Kiri)
            Expanded(
              flex: 2,
              child: ProductSelection(onProductSelected: addOrder),
            ),
            const SizedBox(width: 20),

            /// Kitchen Orders (Tengah)
            Expanded(
              flex: 3,
              child: KitchenOrders(
                orders: orders,
                onIncrease: increaseQty,
                onDecrease: decreaseQty,
                onRemoveOrder: removeOrder,
              ),
            ),
            const SizedBox(width: 20),

            /// Order Summary (Kanan)
            Expanded(
              flex: 2,
              child: OrderSummary(
                totalOrders: orders.length,
                onCheckout: goToCheckout,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
