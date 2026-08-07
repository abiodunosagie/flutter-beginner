# App 15: Multi-Vendor Marketplace — Complete Tutorial

> Advanced portfolio piece: buyers and sellers, shops, products, orders, ownership rules.

**Time:** 30–45 hours  
**Minimum level:** 11–16  
**Backend:** Firebase or Supabase recommended  

---

## 1. What you are building

**Buyer**

- Browse products across shops  
- Product detail  
- Cart  
- Checkout  
- Order history + status  

**Seller**

- Create shop (once)  
- Add/edit/delete own products  
- See orders containing their products  
- Update order line status (packed/shipped)  

---

## 2. Critical product decision (choose and document)

**MVP recommendation:** Cart is single-shop only (like food app).  
Simpler orders: one order → one shop.

(Multi-shop cart that splits into multiple orders is a stretch.)

---

## 3. Data model

```
users/{uid} { role: buyer|seller|both, displayName }
shops/{shopId} { ownerId, name, description }
products/{productId} { shopId, title, price, stock, imageUrl }
orders/{orderId} {
  buyerId, shopId, status,
  lines: [{productId, title, price, qty}],
  total, createdAt
}
```

---

## 4. Security rules (must)

- Anyone signed-in can read active products  
- Only `ownerId` can write shop/products  
- Buyer creates order with their uid  
- Seller updates order only if `shopId` theirs  

Write rules before demo day; test with two accounts.

---

## 5. Features checklist

### Buyer
- [ ] Product catalog  
- [ ] Cart + checkout  
- [ ] Stock cannot go negative  
- [ ] Orders list  

### Seller
- [ ] Shop onboarding  
- [ ] Product CRUD  
- [ ] Orders board  
- [ ] Status updates  

### Shared
- [ ] Auth  
- [ ] Role switch or dual menus  
- [ ] Empty states  
- [ ] Error handling  

---

## 6. Build phases (do not skip)

1. Auth + role field  
2. Seller product CRUD against Firestore  
3. Buyer catalog reads products  
4. Cart + place order (transaction: decrement stock)  
5. Seller order board  
6. Rules hardening + two-user tests  
7. Clean architecture pass (Level 16)  

### Stock transaction sketch

```dart
await db.runTransaction((tx) async {
  final fresh = await tx.get(productRef);
  final stock = fresh['stock'] as int;
  if (stock < qty) throw Exception('Out of stock');
  tx.update(productRef, {'stock': stock - qty});
  tx.set(orderRef, orderMap);
});
```

---

## 7. Test script (two users)

1. Seller S creates shop + product stock 5  
2. Buyer B orders qty 2 → stock 3  
3. B orders qty 10 → fails  
4. S sees order; marks shipped  
5. B cannot edit S products  

---

## 8. Common mistakes

- Client-only stock checks  
- Seller id taken from client body without rules  
- Clearing cart before transaction succeeds  

---

## 9. Portfolio blurb

> Multi-vendor marketplace with buyer/seller roles, secured product ownership, and stock-safe checkout transactions.

## Done when

Two-user script passes with security rules enabled (not test mode).
