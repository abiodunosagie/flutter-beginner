# App 07: E-Commerce Full (ShopEase Complete) — Complete Tutorial

> End-to-end store: catalog, detail, cart, checkout, orders. The portfolio “shop app.”

**Time:** 20–30 hours  
**Minimum level:** 06–08; Firebase auth/orders at 11  

---

## 1. What you are building

A shopping app with:

- Product catalog (grid)  
- Search + category filter  
- Product detail  
- Cart + badge  
- Checkout  
- Order success + history  
- (Optional) login  

Use [FakeStore API](https://fakestoreapi.com) for products first.

---

## 2. Features

- [ ] Fetch products from API  
- [ ] Category filter from product.category  
- [ ] Search by title  
- [ ] Detail page (image, price, description)  
- [ ] Add to cart  
- [ ] Cart qty update / remove  
- [ ] Checkout address form  
- [ ] Create order object  
- [ ] Order history (local or cloud)  
- [ ] Loading / error / empty  

---

## 3. Architecture

```
features/
  catalog/
  cart/
  checkout/
  orders/
  auth/          # optional
data/
  product_api.dart
  product_repository.dart
  order_repository.dart
```

One state library end-to-end.

---

## 4. Cart math

```dart
double get subtotal => lines.fold(0, (a, l) => a + l.price * l.qty);
double get shipping => subtotal > 50 ? 0 : 5.99;
double get total => subtotal + shipping;
```

Show free shipping callout when close to $50.

---

## 5. Checkout pipeline (exact)

```
Validate cart not empty
 → Validate address
 → Create order {id, items copy, totals, createdAt, status: placed}
 → Persist order
 → Clear cart
 → Navigate to success (order id)
```

If persist fails, **do not** clear cart.

---

## 6. Build order

1. Product API + list  
2. Detail  
3. Cart  
4. Checkout  
5. Orders storage  
6. Polish empty states  
7. Optional Firebase auth  

---

## 7. Test script

1. Load products online  
2. Add 2 products different prices  
3. Change qty  
4. Checkout  
5. Cart empty; history has 1 order  
6. Airplane mode on catalog → error + retry  

---

## 8. Common mistakes

- Holding product references that change  
- Not copying cart lines into order  
- Shipping logic only on UI not in domain  

---

## 9. Portfolio blurb

> Full Flutter e-commerce client with catalog API, cart domain logic, checkout, and order history.

## Done when

Cold start → browse → purchase → history works.
