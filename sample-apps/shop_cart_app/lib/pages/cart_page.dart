import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart_provider.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
        actions: [
          if (!cart.isEmpty)
            TextButton(
              onPressed: () => context.read<CartProvider>().clear(),
              child: const Text('Clear'),
            ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Cart is empty'),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Browse products'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    itemCount: cart.items.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final line = cart.items[index];
                      return ListTile(
                        leading: Text(line.product.emoji, style: const TextStyle(fontSize: 28)),
                        title: Text(line.product.name),
                        subtitle: Text('\$${line.subtotal.toStringAsFixed(2)}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () => context
                                  .read<CartProvider>()
                                  .setQty(line.product.id, line.qty - 1),
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${line.qty}'),
                            IconButton(
                              onPressed: () => context
                                  .read<CartProvider>()
                                  .setQty(line.product.id, line.qty + 1),
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Text(
                          'Total \$${cart.totalPrice.toStringAsFixed(2)}',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Checkout is a stretch goal — cart math works!')),
                            );
                          },
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
