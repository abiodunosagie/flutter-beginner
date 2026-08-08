import 'package:flutter/foundation.dart';

import '../models/cart_item.dart';
import '../models/product.dart';

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};

  List<CartItem> get items => _items.values.toList(growable: false);

  int get totalQty => _items.values.fold(0, (sum, e) => sum + e.qty);

  double get totalPrice =>
      _items.values.fold(0.0, (sum, e) => sum + e.subtotal);

  bool get isEmpty => _items.isEmpty;

  void add(Product product) {
    final existing = _items[product.id];
    if (existing != null) {
      existing.qty += 1;
    } else {
      _items[product.id] = CartItem(product: product);
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

  void remove(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}
