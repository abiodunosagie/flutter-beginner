# Passing Data Between Screens

Learn how to send information from one screen to another!

---

## Why Pass Data?

### Think of it Like This

Imagine you're at a restaurant:
- You ORDER food (Screen A sends data)
- The KITCHEN receives your order (Screen B receives data)
- After cooking, the kitchen RETURNS your food (Screen B sends data back)

```
┌─────────────────┐         order: "Pizza"        ┌─────────────────┐
│                 │ ─────────────────────────────>│                 │
│   CUSTOMER      │                               │    KITCHEN      │
│   (Screen A)    │<───────────────────────────── │   (Screen B)    │
│                 │         food: "🍕"            │                 │
└─────────────────┘                               └─────────────────┘
```

---

## Method 1: Constructor Parameters (Simplest)

### Passing Data FORWARD

```dart
// When navigating, pass data to the constructor
Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => DetailsScreen(
      productId: '123',        // Pass the ID
      productName: 'Widget',   // Pass the name
      price: 29.99,           // Pass the price
    ),
  ),
);
```

### Receiving Data

```dart
class DetailsScreen extends StatelessWidget {
  // Define parameters to receive
  final String productId;
  final String productName;
  final double price;

  // Constructor requires these parameters
  const DetailsScreen({
    required this.productId,
    required this.productName,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(productName)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Product ID: $productId'),
            Text('Name: $productName'),
            Text('Price: \$${price.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}
```

### Complete Example

```dart
import 'package:flutter/material.dart';

// Product model
class Product {
  final String id;
  final String name;
  final double price;
  final String emoji;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.emoji,
  });
}

// Sample products
final products = [
  Product(id: '1', name: 'Apple', price: 1.99, emoji: '🍎'),
  Product(id: '2', name: 'Pizza', price: 9.99, emoji: '🍕'),
  Product(id: '3', name: 'Coffee', price: 4.99, emoji: '☕'),
];

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Passing Data Demo',
      home: ProductListScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 1: Product List
// ═══════════════════════════════════════════════════════════════

class ProductListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Products')),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            leading: Text(product.emoji, style: TextStyle(fontSize: 40)),
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            trailing: Icon(Icons.chevron_right),
            onTap: () {
              // ─────────────────────────────────────────
              // PASS DATA: Send entire product object
              // ─────────────────────────────────────────
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN 2: Product Details
// ═══════════════════════════════════════════════════════════════

class ProductDetailScreen extends StatelessWidget {
  // Receive the product
  final Product product;

  const ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(product.emoji, style: TextStyle(fontSize: 100)),
            SizedBox(height: 20),
            Text(product.name, style: TextStyle(fontSize: 28)),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 24, color: Colors.green),
            ),
            SizedBox(height: 20),
            Text('Product ID: ${product.id}'),
          ],
        ),
      ),
    );
  }
}
```

---

## Method 2: Named Route Arguments

### Passing Data with Named Routes

```dart
// Navigate and pass arguments
Navigator.pushNamed(
  context,
  '/details',
  arguments: {
    'productId': '123',
    'productName': 'Widget',
    'price': 29.99,
  },
);

// OR pass an object
Navigator.pushNamed(
  context,
  '/details',
  arguments: product,  // Pass the whole Product object
);
```

### Receiving Arguments

```dart
class DetailsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ─────────────────────────────────────────
    // GET ARGUMENTS from the route
    // ─────────────────────────────────────────
    final args = ModalRoute.of(context)!.settings.arguments;

    // If you passed a Map:
    if (args is Map<String, dynamic>) {
      final productId = args['productId'];
      final productName = args['productName'];
      final price = args['price'];

      return Scaffold(
        appBar: AppBar(title: Text(productName)),
        body: Center(child: Text('Price: \$$price')),
      );
    }

    // If you passed a Product object:
    if (args is Product) {
      return Scaffold(
        appBar: AppBar(title: Text(args.name)),
        body: Center(child: Text('Price: \$${args.price}')),
      );
    }

    // Fallback if no arguments
    return Scaffold(
      appBar: AppBar(title: Text('Details')),
      body: Center(child: Text('No product data')),
    );
  }
}
```

### Better Approach: onGenerateRoute

```dart
MaterialApp(
  onGenerateRoute: (settings) {
    if (settings.name == '/details') {
      // Extract the arguments
      final product = settings.arguments as Product;

      return MaterialPageRoute(
        builder: (context) => ProductDetailScreen(product: product),
      );
    }

    // Handle other routes...
    return MaterialPageRoute(builder: (context) => HomeScreen());
  },
);
```

---

## Method 3: Returning Data (Going Back with Results)

### The Scenario

```
Screen A: "Pick a color"
    │
    ▼ push()
Screen B: Shows color options
    │
    ▼ User picks red
    │
    ▼ pop(result: 'red')
Screen A: Receives 'red'
```

### Sending Data BACK

```dart
// SCREEN B: Return data when going back
Navigator.pop(context, 'red');  // Pass any data type
Navigator.pop(context, selectedProduct);
Navigator.pop(context, {'color': 'red', 'size': 'large'});
```

### Receiving Returned Data

```dart
// SCREEN A: Wait for result
ElevatedButton(
  onPressed: () async {
    // push returns a Future that completes when popped
    final result = await Navigator.push<String>(
      context,
      MaterialPageRoute(builder: (context) => ColorPickerScreen()),
    );

    // result is the value passed to pop()
    if (result != null) {
      print('Selected color: $result');
      setState(() {
        selectedColor = result;
      });
    }
  },
  child: Text('Pick a Color'),
)
```

### Complete Example: Color Picker

```dart
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Return Data Demo',
      home: HomeScreen(),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN A: Home (Receives returned data)
// ═══════════════════════════════════════════════════════════════

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Color? selectedColor;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show selected color
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: selectedColor ?? Colors.grey,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
            ),
            SizedBox(height: 20),
            Text(
              selectedColor == null
                  ? 'No color selected'
                  : 'Color selected!',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () async {
                // ─────────────────────────────────────────
                // WAIT FOR RESULT from picker screen
                // ─────────────────────────────────────────
                final Color? result = await Navigator.push<Color>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ColorPickerScreen(),
                  ),
                );

                // Update if a color was selected
                if (result != null) {
                  setState(() {
                    selectedColor = result;
                  });
                }
              },
              child: Text('Pick a Color'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// SCREEN B: Color Picker (Returns data)
// ═══════════════════════════════════════════════════════════════

class ColorPickerScreen extends StatelessWidget {
  final List<Color> colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.amber,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Pick a Color')),
      body: GridView.builder(
        padding: EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: colors.length,
        itemBuilder: (context, index) {
          final color = colors[index];
          return GestureDetector(
            onTap: () {
              // ─────────────────────────────────────────
              // RETURN DATA: Send color back to home
              // ─────────────────────────────────────────
              Navigator.pop(context, color);
            },
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.black),
              ),
            ),
          );
        },
      ),
    );
  }
}
```

---

## Data Passing Patterns Visual

```
┌─────────────────────────────────────────────────────────────┐
│                 DATA PASSING PATTERNS                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  PATTERN 1: Forward Only                                    │
│  ──────────────────────                                     │
│  Screen A ────[data]────> Screen B                          │
│  Example: Show product details                              │
│                                                             │
│  PATTERN 2: Round Trip                                      │
│  ─────────────────────                                      │
│  Screen A ────[push]────> Screen B                          │
│  Screen A <───[result]─── Screen B                          │
│  Example: Pick a color, select an item                      │
│                                                             │
│  PATTERN 3: Chain                                           │
│  ────────────────────                                       │
│  Screen A ──> Screen B ──> Screen C                         │
│      │           │            │                             │
│    data1       data2        data3                           │
│  Example: Wizard/multi-step form                            │
│                                                             │
│  PATTERN 4: Broadcast (State Management)                    │
│  ──────────────────────────────────────                     │
│       ┌─────────────────────┐                               │
│       │   Shared State      │                               │
│       │  (Provider/Bloc)    │                               │
│       └─────────────────────┘                               │
│         ↑       ↑       ↑                                   │
│        A       B       C                                    │
│  Example: Shopping cart, user auth                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Complete Example: Product Selection Flow

```dart
import 'package:flutter/material.dart';

// Models
class Product {
  final String id;
  final String name;
  final double price;

  Product({required this.id, required this.name, required this.price});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ShopScreen());
  }
}

// ═══════════════════════════════════════════════════════════════
// SHOP SCREEN
// ═══════════════════════════════════════════════════════════════

class ShopScreen extends StatefulWidget {
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  List<CartItem> cart = [];

  final products = [
    Product(id: '1', name: 'Laptop', price: 999.99),
    Product(id: '2', name: 'Phone', price: 699.99),
    Product(id: '3', name: 'Tablet', price: 499.99),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop'),
        actions: [
          // Cart button shows count
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.shopping_cart),
                onPressed: () async {
                  // Go to cart and wait for result
                  final result = await Navigator.push<String>(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CartScreen(cart: cart),
                    ),
                  );

                  // Handle checkout result
                  if (result == 'checkout_complete') {
                    setState(() {
                      cart.clear();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Order placed!')),
                    );
                  }
                },
              ),
              if (cart.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${cart.length}',
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ListTile(
            title: Text(product.name),
            subtitle: Text('\$${product.price}'),
            trailing: ElevatedButton(
              onPressed: () async {
                // Go to detail and wait for "add to cart"
                final added = await Navigator.push<bool>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailScreen(product: product),
                  ),
                );

                if (added == true) {
                  setState(() {
                    cart.add(CartItem(product: product));
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('${product.name} added to cart')),
                  );
                }
              },
              child: Text('View'),
            ),
          );
        },
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// PRODUCT DETAIL SCREEN
// ═══════════════════════════════════════════════════════════════

class ProductDetailScreen extends StatelessWidget {
  final Product product;

  const ProductDetailScreen({required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(product.name, style: TextStyle(fontSize: 24)),
            Text('\$${product.price}', style: TextStyle(fontSize: 20)),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Return true to indicate "added to cart"
                Navigator.pop(context, true);
              },
              child: Text('Add to Cart'),
            ),
            TextButton(
              onPressed: () {
                // Return null/false to indicate "cancelled"
                Navigator.pop(context, false);
              },
              child: Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// CART SCREEN
// ═══════════════════════════════════════════════════════════════

class CartScreen extends StatelessWidget {
  final List<CartItem> cart;

  const CartScreen({required this.cart});

  @override
  Widget build(BuildContext context) {
    final total = cart.fold<double>(
      0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );

    return Scaffold(
      appBar: AppBar(title: Text('Cart')),
      body: Column(
        children: [
          Expanded(
            child: cart.isEmpty
                ? Center(child: Text('Cart is empty'))
                : ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return ListTile(
                        title: Text(item.product.name),
                        subtitle: Text('Qty: ${item.quantity}'),
                        trailing: Text('\$${item.product.price}'),
                      );
                    },
                  ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Total: \$${total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: cart.isEmpty
                      ? null
                      : () {
                          // Return result to indicate checkout complete
                          Navigator.pop(context, 'checkout_complete');
                        },
                  child: Text('Checkout'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
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
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│                  PASSING DATA CHEAT SHEET                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SENDING DATA FORWARD:                                      │
│  ─────────────────────                                      │
│                                                             │
│  // Via constructor (recommended)                           │
│  Navigator.push(                                            │
│    context,                                                 │
│    MaterialPageRoute(                                       │
│      builder: (context) => DetailScreen(item: item),        │
│    ),                                                       │
│  );                                                         │
│                                                             │
│  // Via named route arguments                               │
│  Navigator.pushNamed(context, '/details', arguments: item); │
│                                                             │
│  RETURNING DATA:                                            │
│  ───────────────                                            │
│                                                             │
│  // Screen B: Return data                                   │
│  Navigator.pop(context, result);                            │
│                                                             │
│  // Screen A: Receive data                                  │
│  final result = await Navigator.push<Type>(...);            │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

[← Named Routes](./02-NamedRoutes.md) | [Next: GoRouter Basics →](./04-GoRouterBasics.md)
