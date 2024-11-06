import 'package:flutter/material.dart';
import 'package:linkjo/config/routes.dart';
import 'package:linkjo/util/asset.dart';
import 'package:linkjo/widget/order_summary.dart';

class VendorScreen extends StatefulWidget {
  const VendorScreen({super.key});

  @override
  State<VendorScreen> createState() => _VendorScreenState();
}

class _VendorScreenState extends State<VendorScreen> {
  final List<Product> _products = products;
  int _totalOrderCount = 0;

  void _incrementOrder(Product product) {
    setState(() {
      if (product.orderCount < product.stock) {
        product.orderCount++;
        _totalOrderCount++;
      }
    });
  }

  void _decrementOrder(Product product) {
    setState(() {
      if (product.orderCount > 0) {
        product.orderCount--;
        _totalOrderCount--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Info'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushNamed(
                context,
                Routes.home,
              );
            },
            icon: const Icon(Icons.map_rounded),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Vendor Info
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: AssetImage(Asset.logo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Cak Maman',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Cak Maman adalah penjual nasi goreng dan mie goreng yang sudah berpengalaman.',
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 16),
              child: const Divider(
                color: Colors.grey,
              ),
            ),
            Expanded(
              // Product List
              child: ListView.builder(
                itemCount: _products.length,
                itemBuilder: (context, index) {
                  final product = _products[index];
                  return ListTile(
                    leading: const Icon(Icons.fastfood_rounded),
                    title: Text(product.name),
                    subtitle: Text('Stok: ${product.stock}'),
                    trailing: product.orderCount == 0
                        ? IconButton(
                            onPressed: product.stock > 0
                                ? () => _incrementOrder(product)
                                : null,
                            icon: const Icon(Icons.add),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                onPressed: product.orderCount > 0
                                    ? () => _decrementOrder(product)
                                    : null,
                                icon: const Icon(Icons.remove),
                              ),
                              Text(
                                product.orderCount.toString(),
                              ),
                              IconButton(
                                onPressed: product.stock > product.orderCount
                                    ? () => _incrementOrder(product)
                                    : null,
                                icon: const Icon(Icons.add),
                              ),
                            ],
                          ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_totalOrderCount == 0) {
            ScaffoldMessenger.of(context).removeCurrentSnackBar();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Anda belum memesan apapun.'),
              ),
            );
            return;
          }
          showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
              return OrderSummary(
                products: _products,
              );
            },
          );
        },
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            const Icon(Icons.shopping_cart_rounded),
            if (_totalOrderCount > 0)
              Positioned(
                right: -4,
                top: -8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Text(
                    _totalOrderCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

List<Product> products = [
  Product(
    id: 1,
    name: 'Nasi Goreng',
    stock: 10,
    orderCount: 0,
  ),
  Product(
    id: 2,
    name: 'Mie Goreng',
    stock: 10,
    orderCount: 0,
  ),
];

class Product {
  final int id;
  final String name;
  final int stock;
  final int price;
  int orderCount;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    this.price = 10000,
    this.orderCount = 0,
  });
}
