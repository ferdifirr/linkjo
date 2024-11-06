import 'package:flutter/material.dart';
import 'package:linkjo/config/routes.dart';
import 'package:linkjo/screen/vendor_screen.dart';

class OrderSummary extends StatelessWidget {
  final List<Product> products;

  const OrderSummary({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    final orderedProducts = products.where((product) => product.orderCount > 0).toList();
    final double totalPrice = orderedProducts.fold(0, (sum, item) => sum + (item.price * item.orderCount));

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: orderedProducts.length,
              itemBuilder: (context, index) {
                final product = orderedProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Jumlah: ${product.orderCount} x ${product.price}'),
                  trailing: Text('Rp ${product.price * product.orderCount}'),
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Rp $totalPrice',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamed(context, Routes.chat);
            },
            child: const Text('Confirm Order'),
          ),
        ],
      ),
    );
  }
}