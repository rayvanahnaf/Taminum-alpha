import 'package:flutter/material.dart';
import '../../models/product.dart';

class KitchenOrders extends StatefulWidget {
  final Map<Product, int> orders;
  final Function(Product) onIncrease;
  final Function(Product) onDecrease;
  final Function(Product) onRemoveOrder;

  const KitchenOrders({
    Key? key,
    required this.orders,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemoveOrder,
  }) : super(key: key);

  @override
  State<KitchenOrders> createState() => _KitchenOrdersState();
}

class _KitchenOrdersState extends State<KitchenOrders> with TickerProviderStateMixin {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();

  @override
  Widget build(BuildContext context) {
    final items = widget.orders.entries.toList();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey[850],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Kitchen Orders',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: AnimatedList(
              key: _listKey,
              initialItemCount: items.length,
              itemBuilder: (context, index, animation) {
                final entry = items[index];
                return ScaleTransition(
                  scale: animation,
                  child: _buildOrderItem(entry.key, entry.value),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderItem(Product product, int qty) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '${product.name} (x$qty)',
            style: const TextStyle(color: Colors.white),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove, color: Colors.white),
                onPressed: () => widget.onDecrease(product),
              ),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.white),
                onPressed: () => widget.onIncrease(product),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => widget.onRemoveOrder(product),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
