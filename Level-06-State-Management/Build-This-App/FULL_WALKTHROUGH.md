# ShopCart Full Walkthrough (Level 06)

This expands `Build-This-App/README.md` with a concrete file map and behavior contract.

## Create project

```bash
flutter create shop_cart_app
cd shop_cart_app
flutter pub add provider
```

## File map

```
lib/
  main.dart
  models/product.dart
  models/cart_item.dart
  providers/cart_provider.dart
  pages/catalog_page.dart
  pages/cart_page.dart
  widgets/product_card.dart
  widgets/cart_badge.dart
  data/sample_products.dart
```

## Behavior contract

| Action | Result |
|--------|--------|
| Tap Add on product | qty 1 or +1 if exists; badge updates |
| Open cart | lines show name, price, qty |
| Tap + / − | qty changes; remove at 0 |
| Total | sum(price * qty) |
| Empty cart | show CTA back to catalog |

## Product model

```dart
class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });
}
```

## CartItem

```dart
class CartItem {
  final Product product;
  int qty;
  CartItem({required this.product, this.qty = 1});
  double get subtotal => product.price * qty;
}
```

## CartProvider essentials

```dart
class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList();
  int get totalQty => _items.values.fold(0, (a, e) => a + e.qty);
  double get totalPrice =>
      _items.values.fold(0.0, (a, e) => a + e.subtotal);

  void add(Product p) {
    if (_items.containsKey(p.id)) {
      _items[p.id]!.qty += 1;
    } else {
      _items[p.id] = CartItem(product: p);
    }
    notifyListeners();
  }

  void setQty(String productId, int qty) {
    if (!_items.containsKey(productId)) return;
    if (qty <= 0) {
      _items.remove(productId);
    } else {
      _items[productId]!.qty = qty;
    }
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
```

## main.dart

```dart
void main() => runApp(
      ChangeNotifierProvider(
        create: (_) => CartProvider(),
        child: const MaterialApp(home: CatalogPage()),
      ),
    );
```

## Badge

Use `Consumer<CartProvider>` in AppBar actions; show a badge with `totalQty` if `> 0`.

## Rubric (self-grade)

- [ ] Badge updates without hot-restart hacks  
- [ ] Totals correct after random +/−  
- [ ] Empty state works  
- [ ] Code split into files (not one `main.dart` blob)  

When all pass, publish as `flutter-shop-cart` on GitHub.
