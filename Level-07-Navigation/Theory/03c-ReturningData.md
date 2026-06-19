# Returning Data from Screens

## The Big Idea In One Sentence

> `Navigator.pop(context, value)` hands a value back, and the screen that pushed waits for it with `await Navigator.push(...)`.

Learn how to send data back when navigating backwards!

> **Async heads-up.** Getting a result back uses `await` (waiting for the second screen to close). You learn `Future`/`async`/`await` fully in Level 8. For now just read it as: "push the screen, wait, get the value the user picked."

---

## What is Returning Data?

### Think of it Like This

Imagine sending your friend to the store:
- You SEND them with a shopping list (passing data forward)
- They GO to the store
- They COME BACK with groceries (returning data)

```
Screen A: "Pick a color"
    │
    ▼ push()
Screen B: Shows color options
    │
    ▼ User picks red
    │
    ▼ pop(result: 'red')
Screen A: Receives 'red' ← Data returned!
```

---

## Method 3: Returning Data with pop()

### The Basics

```dart
// SCREEN B: Return data when going back
Navigator.pop(context, 'red');  // Pass any data type

// You can return:
Navigator.pop(context, selectedProduct);
Navigator.pop(context, {'color': 'red', 'size': 'large'});
Navigator.pop(context, true);  // Often used for "yes/no" results
```

### Receiving Returned Data

```dart
// SCREEN A: Wait for result using await
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

---

## Complete Example: Color Picker

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

## Real-World Example: Shopping Cart

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

## Data Passing Patterns

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

## Type Safety with Generics

### Specify Return Type

```dart
// Specify what type will be returned
final String? color = await Navigator.push<String>(
  context,
  MaterialPageRoute(builder: (context) => ColorPicker()),
);

final bool? confirmed = await Navigator.push<bool>(
  context,
  MaterialPageRoute(builder: (context) => ConfirmDialog()),
);

final Product? selected = await Navigator.push<Product>(
  context,
  MaterialPageRoute(builder: (context) => ProductPicker()),
);
```

---

## Common Use Cases

### 1. Form/Settings Changes

```dart
// Settings screen returns true if settings changed
final changed = await Navigator.push<bool>(
  context,
  MaterialPageRoute(builder: (context) => SettingsScreen()),
);

if (changed == true) {
  // Reload data with new settings
  _loadData();
}
```

### 2. Confirmation Dialogs

```dart
final confirmed = await Navigator.push<bool>(
  context,
  MaterialPageRoute(builder: (context) => DeleteConfirmation()),
);

if (confirmed == true) {
  _deleteItem();
}
```

### 3. Item Selection

```dart
final selected = await Navigator.push<Item>(
  context,
  MaterialPageRoute(builder: (context) => ItemPicker()),
);

if (selected != null) {
  setState(() {
    currentItem = selected;
  });
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│              RETURNING DATA CHEAT SHEET                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  SCREEN B: Return data                                      │
│  ──────────────────────                                     │
│  Navigator.pop(context, result);                            │
│                                                             │
│  Examples:                                                  │
│  Navigator.pop(context, selectedColor);                     │
│  Navigator.pop(context, true);                              │
│  Navigator.pop(context, {'action': 'save', 'data': data});  │
│                                                             │
│  SCREEN A: Receive data                                     │
│  ───────────────────────                                    │
│  final result = await Navigator.push<Type>(                 │
│    context,                                                 │
│    MaterialPageRoute(builder: (c) => ScreenB()),            │
│  );                                                         │
│                                                             │
│  if (result != null) {                                      │
│    // Use the returned data                                 │
│  }                                                          │
│                                                             │
│  TYPE SAFETY:                                               │
│  ────────────                                               │
│  Use generics to specify return type:                       │
│  await Navigator.push<String>(...)                          │
│  await Navigator.push<bool>(...)                            │
│  await Navigator.push<Product>(...)                         │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** How does Screen B send a value back to Screen A?

<details>
<summary>Answer</summary>
`Navigator.pop(context, value)` (the second argument is the value returned).
</details>

**Q2.** How does Screen A receive that value?

<details>
<summary>Answer</summary>
By awaiting the push: `final result = await Navigator.push(...)`.
</details>

**Q3.** Why check `if (result != null)` before using the value?

<details>
<summary>Answer</summary>
The user might press the system back button instead of choosing something, so no value is returned (it is null). Checking avoids using a missing value.
</details>

---

## Assignment

### Problem 1: Return a value

On a "Yes" button in a confirm screen, write the line that goes back and returns `true`.

### Problem 2: Receive a value

Write the `await Navigator.push<bool>(...)` call that opens `ConfirmScreen()` and stores the returned value in `confirmed`.

### Problem 3: Handle the cancel case

After getting `confirmed`, write the `if` that deletes only when the user said yes (and not when they backed out).

---

## Assignment Answers

### Problem 1: Return a value

```dart
Navigator.pop(context, true);
```

### Problem 2: Receive a value

```dart
final confirmed = await Navigator.push<bool>(
  context,
  MaterialPageRoute(builder: (context) => ConfirmScreen()),
);
```

### Problem 3: Handle the cancel case

```dart
if (confirmed == true) {
  deleteItem();
}
```

Using `== true` is safe: if the user backed out, `confirmed` is `null`, which is not equal to `true`, so nothing is deleted.

---

## Navigation

⬅️ **Previous:** [Route Arguments](03b-RouteArguments.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [GoRouter Setup](04a-GoRouterSetup.md)
