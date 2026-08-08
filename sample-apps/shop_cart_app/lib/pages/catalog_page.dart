import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../data/sample_products.dart';
import '../providers/cart_provider.dart';
import 'cart_page.dart';

class CatalogPage extends StatelessWidget {
  const CatalogPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('ShopCart'),
        actions: [
          IconButton(
            tooltip: 'Open cart',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => const CartPage()),
              );
            },
            icon: Badge(
              isLabelVisible: cart.totalQty > 0,
              label: Text('${cart.totalQty}'),
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(12),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 0.85,
        ),
        itemCount: sampleProducts.length,
        itemBuilder: (context, index) {
          final product = sampleProducts[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: Center(
                      child: Text(product.emoji, style: const TextStyle(fontSize: 42)),
                    ),
                  ),
                  Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
                  const SizedBox(height: 4),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  FilledButton(
                    onPressed: () => context.read<CartProvider>().add(product),
                    child: const Text('Add'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
