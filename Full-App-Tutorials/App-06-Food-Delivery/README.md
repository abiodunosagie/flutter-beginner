# App 06: Food Delivery — Complete Tutorial

> Customer app: restaurants → menu → cart → checkout → order status. Mirrors real delivery products.

**Time:** 18–28 hours  
**Minimum level:** 06–08 (11 if you add Firebase orders)  
**State:** Provider or Riverpod (one only)

---

## 1. What you are building

A **customer** food ordering flow:

1. See restaurants  
2. Open a restaurant menu  
3. Add items to cart  
4. Checkout with address  
5. Place order  
6. Watch status: Placed → Preparing → On the way → Delivered  

Seller/admin apps are stretch only.

---

## 2. Features

- [ ] Restaurant list (image, name, rating, eta)  
- [ ] Menu list with prices  
- [ ] Cart with qty +/− and line totals  
- [ ] Cart badge in app bar  
- [ ] Checkout: address + phone validation  
- [ ] Order confirmation screen  
- [ ] Order tracking screen with status timeline  
- [ ] Order history  
- [ ] Empty cart state  
- [ ] Clear cart only after successful place order  

**Data phase 1:** `assets/restaurants.json`  
**Data phase 2:** Firebase `orders` collection  

---

## 3. Domain models

```dart
class Restaurant {
  final String id, name, imageUrl;
  final double rating;
  final int etaMinutes;
  final List<MenuItem> menu;
}

class MenuItem {
  final String id, restaurantId, name, description;
  final double price;
}

class CartLine {
  final MenuItem item;
  int qty;
  double get subtotal => item.price * qty;
}

enum OrderStatus { placed, preparing, onTheWay, delivered, cancelled }

class Order {
  final String id;
  final List<CartLine> lines;
  final String address;
  final double total;
  final OrderStatus status;
  final DateTime createdAt;
}
```

**Business rule:** Cart may only contain items from **one restaurant** (simplest MVP). If user adds from another restaurant, ask to clear cart.

---

## 4. Folders

```
lib/
  data/sample_restaurants.dart   # or load json
  models/...
  providers/cart_provider.dart
  providers/order_provider.dart
  pages/
    restaurant_list_page.dart
    restaurant_menu_page.dart
    cart_page.dart
    checkout_page.dart
    order_tracking_page.dart
    order_history_page.dart
  widgets/cart_badge.dart
  widgets/status_timeline.dart
```

---

## 5. Cart rules (implement exactly)

```dart
void add(MenuItem item) {
  if (_restaurantId != null && _restaurantId != item.restaurantId) {
    throw StateError('Cart has items from another restaurant');
  }
  _restaurantId = item.restaurantId;
  // merge qty...
  notifyListeners();
}
```

UI catches that and shows a dialog: “Start a new cart?”

---

## 6. Checkout validation

| Field | Rule |
|-------|------|
| Address | min 8 characters |
| Phone | min 10 digits |
| Cart | not empty |

Total = sum(subtotals) + optional deliveryFee (constant 2.99).

---

## 7. Order status simulation (MVP without backend)

After place order:

```dart
// OrderProvider
Timer.periodic(const Duration(seconds: 8), (t) {
  // advance status one step until delivered, then cancel timer
});
```

Later replace with Firestore stream on `orders/{id}`.

---

## 8. Build order

1. Static restaurants + menu navigation  
2. Cart provider + badge  
3. Single-restaurant enforcement dialog  
4. Checkout form  
5. Place order → tracking  
6. History list  
7. (Optional) Firebase auth + save orders  

---

## 9. Test script

1. Add 2 items from Restaurant A  
2. Try item from B → dialog appears  
3. Checkout with short address → validation error  
4. Place order → tracking moves over time  
5. History shows order  

---

## 10. Common mistakes

- Clearing cart before order save succeeds  
- Allowing mixed restaurants silently  
- No delivery fee clarity in UI  
- Status timer leaks (cancel on dispose)  

---

## 11. Portfolio blurb

> Food delivery customer app with single-restaurant cart rules, checkout validation, and order status tracking.

## Done when

Full path restaurant → delivered works without console errors.
