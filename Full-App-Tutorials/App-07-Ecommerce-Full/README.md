# App 07: E-Commerce Full — ShopEase Complete

> End-to-end store: catalog, detail, cart, checkout, orders. Aligns with course ShopEase capstones — **finish as one app**.

**Min level:** 06–11 · **Time:** 20–30 hours  

---

## Must-have features

- Product list + category filter + search  
- Product detail (images, price, variants size/color simple)  
- Cart with qty update  
- Wishlist (local)  
- Checkout form (address)  
- Order confirmation + history  
- Auth (Firebase or mock)  

---

## Architecture

```
features/catalog | cart | checkout | orders | auth | profile
core/network | theme | router
data/repositories
```

Use one state approach end-to-end (Provider **or** Riverpod — pick one).

---

## Data sources

| Phase | Source |
|-------|--------|
| 1 | FakeStore API https://fakestoreapi.com |
| 2 | Firebase products + orders |
| 3 | Own Supabase/Stripe later |

---

## Checkout pipeline

```
Cart valid → Address form → Payment mock → Create order → Clear cart → Success
```

Never clear cart if order create fails.

---

## Checklist

- [ ] Responsive product grid  
- [ ] Cart badge in app bar  
- [ ] Stock/qty rules  
- [ ] Empty cart CTA  
- [ ] Order detail  
- [ ] Logout  

## Portfolio line

> Full Flutter e-commerce client with catalog, cart domain, checkout, and order history.
