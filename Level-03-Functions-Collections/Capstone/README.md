# Level 03 Capstone: Shopping Cart System

## What You're Building

In this level, you'll create the **Shopping Cart** - the heart of any e-commerce app!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 03 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase App                                               │
│   ┌──────────────────────────────────────────────────────┐  │
│   │                                                      │  │
│   │   📦 Product    →    🧮 Logic    →    🛒 CART        │  │
│   │   (Level 01)         (Level 02)       ◄── HERE!      │  │
│   │                                                      │  │
│   │   ┌────────────────────────────────────────────┐    │  │
│   │   │             Shopping Cart                   │    │  │
│   │   │                                            │    │  │
│   │   │  ┌──────────────────────────────────────┐  │    │  │
│   │   │  │ 👕 T-Shirt         x2      $59.98   │  │    │  │
│   │   │  │ 👖 Jeans           x1      $79.99   │  │    │  │
│   │   │  │ 👟 Sneakers        x1      $129.99  │  │    │  │
│   │   │  └──────────────────────────────────────┘  │    │  │
│   │   │                                            │    │  │
│   │   │  Subtotal:                    $269.96      │    │  │
│   │   │  Tax (8%):                     $21.60      │    │  │
│   │   │  ─────────────────────────────────────     │    │  │
│   │   │  Total:                       $291.56      │    │  │
│   │   │                                            │    │  │
│   │   └────────────────────────────────────────────┘    │  │
│   │                                                      │  │
│   └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: CartItem Class

```dart
class CartItem {
  final Product product;
  int quantity;

  // Getters
  double get totalPrice => product.price * quantity;
  String get formattedTotal => '\$${totalPrice.toStringAsFixed(2)}';
}
```

### Task 2: Cart Class with Full Functionality

```dart
class Cart {
  final List<CartItem> _items = [];

  // Properties
  List<CartItem> get items => List.unmodifiable(_items);
  int get itemCount => _items.length;
  int get totalQuantity => /* sum of all quantities */;
  bool get isEmpty => _items.isEmpty;

  // Price calculations
  double get subtotal => /* sum of all item totals */;
  double get tax => subtotal * 0.08;
  double get shipping => subtotal > 50 ? 0 : 5.99;
  double get total => subtotal + tax + shipping;

  // Actions
  void addItem(Product product, [int quantity = 1]);
  void removeItem(String productId);
  void updateQuantity(String productId, int quantity);
  void clear();

  // Search & Filter
  CartItem? findItem(String productId);
  List<CartItem> getItemsByCategory(String category);
  bool containsProduct(String productId);
}
```

### Task 3: Cart Helper Functions

```dart
// Calculate best discount for cart
double calculateCartDiscount(Cart cart, List<String> coupons);

// Get cart summary as formatted string
String getCartSummary(Cart cart);

// Check if cart qualifies for free shipping
bool qualifiesForFreeShipping(Cart cart);

// Get recommended products based on cart (simple version)
List<String> getRecommendedCategories(Cart cart);
```

---

## Starter Code

```dart
// lib/models/cart_item.dart
class CartItem {
  final Product product;
  int quantity;

  CartItem({required this.product, this.quantity = 1});

  double get totalPrice => // TODO

  void increment() => // TODO
  void decrement() => // TODO
}

// lib/models/cart.dart
class Cart {
  final List<CartItem> _items = [];

  // TODO: Implement all methods

  void addItem(Product product, [int quantity = 1]) {
    // Check if product already in cart
    // If yes, increase quantity
    // If no, add new CartItem
  }

  void removeItem(String productId) {
    // Remove item with matching product id
  }

  void updateQuantity(String productId, int quantity) {
    // Find item and update quantity
    // If quantity <= 0, remove item
  }
}

// Test your cart:
void main() {
  final cart = Cart();

  final tshirt = Product(
    id: 'prod_001',
    name: 'T-Shirt',
    price: 29.99,
    // ... other properties
  );

  final jeans = Product(
    id: 'prod_002',
    name: 'Jeans',
    price: 79.99,
    // ... other properties
  );

  // Add items
  cart.addItem(tshirt, 2);
  cart.addItem(jeans);

  print('Items: ${cart.itemCount}');        // 2
  print('Total Qty: ${cart.totalQuantity}'); // 3
  print('Subtotal: ${cart.subtotal}');       // 139.97
  print('Tax: ${cart.tax}');                 // 11.20
  print('Total: ${cart.total}');             // 151.17

  // Update quantity
  cart.updateQuantity('prod_001', 3);
  print('New Subtotal: ${cart.subtotal}');   // 169.96

  // Remove item
  cart.removeItem('prod_002');
  print('Items after remove: ${cart.itemCount}'); // 1
}
```

---

## Expected Output

```
Items: 2
Total Qty: 3
Subtotal: 139.97
Tax: 11.20
Total: 151.17
New Subtotal: 169.96
Items after remove: 1
```

---

## Success Criteria

- [ ] CartItem calculates total correctly
- [ ] Cart.addItem adds new or updates existing
- [ ] Cart.removeItem removes the correct item
- [ ] Cart.updateQuantity works correctly
- [ ] Subtotal sums all items correctly
- [ ] Tax is calculated at 8%
- [ ] Free shipping over $50 works
- [ ] Cart.clear empties the cart

---

## Bonus Challenge

- [ ] Add `maxQuantityPerItem` limit (10)
- [ ] Add `saveForLater` functionality
- [ ] Add `getCartAsJson()` for persistence
- [ ] Add undo functionality for last action

---

## Files to Create

```
shopease/
└── lib/
    ├── models/
    │   ├── product.dart       (from Level 01)
    │   ├── cart_item.dart     ◄── Create this
    │   └── cart.dart          ◄── Create this
    └── utils/
        ├── business_logic.dart (from Level 02)
        └── cart_helpers.dart   ◄── Create this
```

---

**Your ShopEase cart is taking shape!**
