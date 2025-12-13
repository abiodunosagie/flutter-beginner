// Week 12, Exercise 3: Shopping Cart Persistence with Hive
// Difficulty: Intermediate
// Solution

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

// NOTE: In a real project, you would:
// 1. Create separate files for models
// 2. Add @HiveType annotations
// 3. Run: flutter pub run build_runner build
// 4. Import generated .g.dart files
//
// For this exercise, we'll use a simplified approach with JSON serialization

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Open cart box
  await Hive.openBox('cart');

  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

// Product model (simplified - in real app use @HiveType)
class Product {
  final String id;
  final String name;
  final double price;

  Product({
    required this.id,
    required this.name,
    required this.price,
  });

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'price': price};
  }

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: json['price'],
    );
  }
}

// CartItem model (simplified - in real app use @HiveType)
class CartItem {
  final Product product;
  final int quantity;

  CartItem({
    required this.product,
    required this.quantity,
  });

  Map<String, dynamic> toJson() {
    return {
      'product': product.toJson(),
      'quantity': quantity,
    };
  }

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      quantity: json['quantity'],
    );
  }
}

// CartNotifier with Hive
class CartNotifier extends StateNotifier<List<CartItem>> {
  final Box _cartBox;

  CartNotifier(this._cartBox) : super([]) {
    _loadCart();
  }

  void _loadCart() {
    final items = <CartItem>[];
    for (var key in _cartBox.keys) {
      final json = _cartBox.get(key);
      if (json != null) {
        items.add(CartItem.fromJson(Map<String, dynamic>.from(json)));
      }
    }
    state = items;
  }

  void addProduct(Product product) {
    final existingIndex = state.indexWhere(
      (item) => item.product.id == product.id,
    );

    if (existingIndex >= 0) {
      final updatedItem = CartItem(
        product: product,
        quantity: state[existingIndex].quantity + 1,
      );
      _cartBox.put(product.id, updatedItem.toJson());
    } else {
      final newItem = CartItem(product: product, quantity: 1);
      _cartBox.put(product.id, newItem.toJson());
    }

    _loadCart();
  }

  void removeProduct(String productId) {
    _cartBox.delete(productId);
    _loadCart();
  }

  void increaseQuantity(String productId) {
    final item = state.firstWhere((item) => item.product.id == productId);
    final updatedItem = CartItem(
      product: item.product,
      quantity: item.quantity + 1,
    );
    _cartBox.put(productId, updatedItem.toJson());
    _loadCart();
  }

  void decreaseQuantity(String productId) {
    final item = state.firstWhere((item) => item.product.id == productId);
    if (item.quantity > 1) {
      final updatedItem = CartItem(
        product: item.product,
        quantity: item.quantity - 1,
      );
      _cartBox.put(productId, updatedItem.toJson());
      _loadCart();
    }
  }

  void clear() {
    _cartBox.clear();
    state = [];
  }

  double get total {
    return state.fold(0, (sum, item) {
      return sum + (item.product.price * item.quantity);
    });
  }
}

// Providers
final cartProvider = StateNotifierProvider<CartNotifier, List<CartItem>>((ref) {
  final box = Hive.box('cart');
  return CartNotifier(box);
});

final productsProvider = Provider<List<Product>>((ref) {
  return [
    Product(id: '1', name: 'Laptop', price: 999.99),
    Product(id: '2', name: 'Mouse', price: 29.99),
    Product(id: '3', name: 'Keyboard', price: 79.99),
    Product(id: '4', name: 'Monitor', price: 299.99),
  ];
});

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cart Persistence',
      home: ProductsScreen(),
    );
  }
}

class ProductsScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(productsProvider);
    final cart = ref.watch(cartProvider);
    final itemCount = cart.fold<int>(0, (sum, item) => sum + item.quantity);

    return Scaffold(
      appBar: AppBar(
        title: Text('Products'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('$itemCount'),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.blue),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Cart persists with Hive! Try closing and reopening the app.',
                    style: TextStyle(fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Card(
                  margin: EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: ElevatedButton(
                      onPressed: () {
                        ref.read(cartProvider.notifier).addProduct(product);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} added to cart'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text('Add'),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class CartScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cart = ref.watch(cartProvider);
    final total = ref.read(cartProvider.notifier).total;

    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
        actions: [
          if (cart.isNotEmpty)
            TextButton(
              onPressed: () {
                ref.read(cartProvider.notifier).clear();
              },
              child: Text('Clear', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey),
                  SizedBox(height: 20),
                  Text(
                    'Cart is empty',
                    style: TextStyle(fontSize: 20, color: Colors.grey),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(item.product.name),
                          subtitle: Text(
                            '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.remove),
                                onPressed: () {
                                  ref.read(cartProvider.notifier)
                                      .decreaseQuantity(item.product.id);
                                },
                              ),
                              Text('${item.quantity}'),
                              IconButton(
                                icon: Icon(Icons.add),
                                onPressed: () {
                                  ref.read(cartProvider.notifier)
                                      .increaseQuantity(item.product.id);
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  ref.read(cartProvider.notifier)
                                      .removeProduct(item.product.id);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  color: Colors.grey[200],
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:',
                        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
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
