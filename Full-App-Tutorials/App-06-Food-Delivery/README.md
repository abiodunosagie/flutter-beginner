# App 06: Food Delivery — Full Tutorial

> Multi-step commerce: restaurants → menu → cart → checkout → order tracking.

**Min level:** 06–11 · **Time:** 18–28 hours  

---

## Personas

| Role | MVP |
|------|-----|
| Customer | Browse, cart, place order, track status |
| (Stretch) Restaurant | Manage menu — skip until customer solid |

---

## Domain

```
Restaurant { id, name, rating, imageUrl, categories }
MenuItem { id, restaurantId, name, price, description }
CartLine { item, qty }
Order { id, lines, status: placed|preparing|onTheWay|delivered, total, address }
```

---

## Screens

1. Home restaurants list/grid  
2. Restaurant detail + menu  
3. Cart  
4. Checkout (address + payment mock)  
5. Order tracking (status timeline)  
6. Order history  

---

## State

- `CartController` (Provider/Riverpod)  
- `OrderRepository` (mock then Firebase)  
- Clear cart only after successful place order  

---

## Build order

1. Static restaurants JSON in assets  
2. Navigation flows  
3. Cart math (tax optional)  
4. Checkout validation  
5. Order status mock with `Stream.periodic` upgrades  
6. Firebase orders stretch  

## Portfolio line

> Food delivery customer app with cart domain logic, checkout flow, and order status tracking.
