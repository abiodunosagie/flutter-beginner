# Build This App — ShopCart — Multi-Screen Cart (Provider)

> **Level app project** (not a toy snippet). Complete this after the level theory/exercises.

**Time:** 8–12 hours  
**Why it matters:** First employer-shaped state app: shared cart across routes.

---

## Product

You are building: **ShopCart — Multi-Screen Cart (Provider)**

## Acceptance checklist

- [ ] Product grid with Add buttons
- [ ] Cart screen with qty +/-, remove, total
- [ ] AppBar badge count that updates live
- [ ] CartProvider ChangeNotifier
- [ ] Product model + seed data
- [ ] Empty cart state

## Steps

1. flutter create shop_cart_app; add provider
2. Implement models/product.dart and models/cart_item.dart
3. Implement providers/cart_provider.dart with notifyListeners
4. Wire MultiProvider in main.dart
5. Build CatalogPage + CartPage + ProductTile
6. Navigate with Navigator; badge via Consumer
7. OPTIONAL: rebuild same app with Riverpod in a branch

### Starter sketch

```dart
class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  int get count => _items.values.fold(0, (a, i) => a + i.qty);
  double get total => _items.values.fold(0.0, (a, i) => a + i.subtotal);
  void add(Product p) { /* merge qty */ notifyListeners(); }
  void setQty(String id, int q) { /* remove if 0 */ notifyListeners(); }
}
```

## Definition of done

Add item on catalog, see badge, change qty on cart, total correct

## After this

Full-App-Tutorials/App-02-Expense-Tracker-Provider or App-07 Ecommerce

## Link to mega tutorials

See also [`Full-App-Tutorials/README.md`](../../Full-App-Tutorials/README.md) for larger employer-grade apps (chat, ride-hailing, delivery, marketplace, …).

---

## ShopEase note

If this level’s `Capstone/` continues the **ShopEase** multi-level shop, you may do **either**:

1. This standalone **Build-This-App**, or  
2. The ShopEase Capstone for the level  

**Recommendation:** Standalone app first (cleaner portfolio repo), ShopEase if you want one long continuous project.
