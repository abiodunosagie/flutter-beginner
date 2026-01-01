# Level 06 Capstone: Cart & User State

## What You're Building

In this level, you'll add **state management** so your cart updates in real-time across the entire app!

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 06 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase State Management                                  │
│                                                              │
│   ┌───────────────────────────────────────────────────────┐ │
│   │                    Providers                          │ │
│   │  ┌──────────┐  ┌──────────┐  ┌──────────┐           │ │
│   │  │  Cart    │  │  User    │  │ Products │           │ │
│   │  │ Provider │  │ Provider │  │ Provider │           │ │
│   │  └────┬─────┘  └────┬─────┘  └────┬─────┘           │ │
│   │       │             │             │                   │ │
│   └───────┼─────────────┼─────────────┼───────────────────┘ │
│           │             │             │                     │
│   ┌───────┼─────────────┼─────────────┼───────────────────┐ │
│   │       ▼             ▼             ▼                   │ │
│   │  ┌─────────┐   ┌─────────┐   ┌─────────┐             │ │
│   │  │  Cart   │   │ Profile │   │  Home   │             │ │
│   │  │ Screen  │   │ Screen  │   │ Screen  │             │ │
│   │  └─────────┘   └─────────┘   └─────────┘             │ │
│   │                                                       │ │
│   │  All screens react to state changes instantly!        │ │
│   └───────────────────────────────────────────────────────┘ │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: CartProvider

```dart
class CartProvider extends ChangeNotifier {
  final Cart _cart = Cart();

  // Expose read-only cart
  Cart get cart => _cart;
  List<CartItem> get items => _cart.items;
  int get itemCount => _cart.totalQuantity;
  double get total => _cart.total;
  bool get isEmpty => _cart.isEmpty;

  // Cart badge count (for app bar)
  String get badgeCount => itemCount > 99 ? '99+' : itemCount.toString();

  // Actions
  void addToCart(Product product, [int quantity = 1]) {
    _cart.addItem(product, quantity);
    notifyListeners();  // Tell widgets to rebuild!
  }

  void removeFromCart(String productId) {
    _cart.removeItem(productId);
    notifyListeners();
  }

  void updateQuantity(String productId, int quantity) {
    _cart.updateQuantity(productId, quantity);
    notifyListeners();
  }

  void clearCart() {
    _cart.clear();
    notifyListeners();
  }

  // Check if product is in cart
  bool isInCart(String productId) => _cart.containsProduct(productId);
}
```

### Task 2: UserProvider

```dart
class UserProvider extends ChangeNotifier {
  Customer? _user;
  bool _isLoading = false;

  Customer? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  // Wishlist
  List<Product> get wishlist => _user?.wishlist ?? [];

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    _user = Customer(/* ... */);
    _isLoading = false;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }

  void toggleWishlist(Product product) {
    if (_user == null) return;

    if (_user!.wishlist.contains(product)) {
      _user!.wishlist.remove(product);
    } else {
      _user!.wishlist.add(product);
    }
    notifyListeners();
  }

  bool isInWishlist(String productId) {
    return _user?.wishlist.any((p) => p.id == productId) ?? false;
  }
}
```

### Task 3: ProductsProvider

```dart
class ProductsProvider extends ChangeNotifier {
  List<Product> _products = [];
  List<Product> _filteredProducts = [];
  String _selectedCategory = 'All';
  String _searchQuery = '';
  bool _isLoading = false;

  List<Product> get products => _filteredProducts;
  List<String> get categories => ['All', ...uniqueCategories];
  String get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;

  Future<void> loadProducts() async {
    _isLoading = true;
    notifyListeners();

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));
    _products = /* mock data */;
    _applyFilters();

    _isLoading = false;
    notifyListeners();
  }

  void selectCategory(String category) {
    _selectedCategory = category;
    _applyFilters();
    notifyListeners();
  }

  void search(String query) {
    _searchQuery = query;
    _applyFilters();
    notifyListeners();
  }

  void _applyFilters() {
    _filteredProducts = _products.where((product) {
      final matchesCategory = _selectedCategory == 'All' ||
          product.category == _selectedCategory;
      final matchesSearch = product.name
          .toLowerCase()
          .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }
}
```

### Task 4: Provide and Consume

```dart
// main.dart - Provide state
void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
      ],
      child: const ShopEaseApp(),
    ),
  );
}

// In widgets - Consume state
class CartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Only rebuilds when cart changes
    final itemCount = context.watch<CartProvider>().itemCount;

    return Badge(
      label: Text(itemCount.toString()),
      child: IconButton(
        icon: const Icon(Icons.shopping_cart),
        onPressed: () => /* navigate to cart */,
      ),
    );
  }
}

class AddToCartButton extends StatelessWidget {
  final Product product;

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final isInCart = cart.isInCart(product.id);

    return ElevatedButton.icon(
      onPressed: () {
        if (isInCart) {
          cart.removeFromCart(product.id);
        } else {
          cart.addToCart(product);
        }
      },
      icon: Icon(isInCart ? Icons.check : Icons.add_shopping_cart),
      label: Text(isInCart ? 'In Cart' : 'Add to Cart'),
    );
  }
}
```

---

## Visual: State Flow

```
User taps "Add to Cart"
         │
         ▼
┌─────────────────────┐
│  CartProvider       │
│  addToCart(product) │
│  notifyListeners()  │
└─────────┬───────────┘
          │
          ▼ (Widgets rebuild)
┌─────────────────────────────────────────────────┐
│                                                 │
│  ┌─────────┐  ┌─────────┐  ┌─────────────────┐ │
│  │ Cart    │  │ Product │  │    AppBar       │ │
│  │ Screen  │  │  Card   │  │ Cart Badge: 3   │ │
│  │ Item +1 │  │ "In     │  │                 │ │
│  │         │  │  Cart"  │  │                 │ │
│  └─────────┘  └─────────┘  └─────────────────┘ │
│                                                 │
│  All update instantly! No manual refresh!       │
└─────────────────────────────────────────────────┘
```

---

## Success Criteria

- [ ] Cart updates reflect across all screens
- [ ] Cart badge shows correct count
- [ ] Add/remove buttons show correct state
- [ ] User login/logout works
- [ ] Wishlist toggles correctly
- [ ] Product filtering works
- [ ] Search updates in real-time
- [ ] No unnecessary rebuilds (use `context.select`)

---

## Bonus Challenge

- [ ] Add `ThemeProvider` for dark/light mode
- [ ] Persist cart to local storage
- [ ] Add "Recently Viewed" provider
- [ ] Implement Riverpod version

---

## Files to Create

```
shopease/
└── lib/
    ├── providers/          ◄── Create folder
    │   ├── cart_provider.dart
    │   ├── user_provider.dart
    │   ├── products_provider.dart
    │   └── theme_provider.dart
    │
    ├── screens/
    │   ├── home/
    │   │   └── home_screen.dart    (update)
    │   └── cart/
    │       └── cart_screen.dart    ◄── Create
    │
    └── main.dart                   (update with providers)
```

---

**Your ShopEase app is now reactive!**
