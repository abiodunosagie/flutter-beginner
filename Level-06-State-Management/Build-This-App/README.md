# Build This App — ShopCart (Provider)

## How to use this folder

1. Finish Level 06 Theory + Examples + Exercises first.  
2. Create a **new** Flutter project: `flutter create shop_cart_app`.  
3. Follow **[FULL_WALKTHROUGH.md](FULL_WALKTHROUGH.md)** for file map + code.  
4. Tick every box below before Level 07.

---

> **This is the first multi-screen “real app” in the course.**  
> Shared cart state across pages is what state management is for.

**Time:** 8–12 hours  
**Why it matters:** Employers expect you to update a badge and a cart total without hacks.

## What you are building

A tiny shop:

- Catalog of products  
- Add to cart  
- Cart page with qty +/−  
- App bar badge that updates live  
- Correct totals  

## Acceptance checklist

- [ ] Product grid with Add buttons  
- [ ] Cart screen with qty +/−, remove, total  
- [ ] AppBar badge count updates live  
- [ ] `CartProvider` extends `ChangeNotifier`  
- [ ] Product model + seed data (5+ products)  
- [ ] Empty cart state with CTA  
- [ ] Code split into multiple files (not one giant `main.dart`)  

## Steps (summary)

1. `flutter pub add provider`  
2. Implement models + `CartProvider` (see walkthrough)  
3. Wire `ChangeNotifierProvider` in `main.dart`  
4. Build `CatalogPage` + `CartPage`  
5. Badge via `Consumer<CartProvider>`  
6. Manual test: add, change qty, total, empty  

## Definition of done

Cold start → add items → badge correct → cart totals correct → empty cart works. No hot-restart required for state to “fix.”

## After this

- Optional full apps: Expense Tracker, Ecommerce  
- Next level: Recipe browser navigation  

## Also available

Level Capstone continues **ShopEase** if you want one long multi-level shop. Prefer this **standalone ShopCart** for a clean portfolio repo.
