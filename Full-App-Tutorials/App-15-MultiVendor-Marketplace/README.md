# App 15: Multi-Vendor Marketplace — Full Tutorial

> Advanced: buyers + sellers, shops, products, orders per vendor.

**Min level:** 11–16 · **Time:** 30–45 hours  

## Roles
| Role | Capabilities |
|------|----------------|
| Buyer | Browse all shops, cart, checkout, order tracking |
| Seller | Onboard shop, CRUD products, view orders, update status |

## Data
```
shops/{id} { ownerId, name, rating }
products/{id} { shopId, title, price, stock }
orders/{id} { buyerId, lines[{productId, shopId, qty}], status }
```

## Hard parts (teach fully)
1. Cart lines from multiple shops → split orders **or** single order multi-shop (pick one; document)  
2. Seller can only edit own products (rules)  
3. Stock decrement on order  
4. Order status: placed → confirmed → shipped → done  

## Recommended approach
- Firebase or Supabase  
- Separate navigation shells by role  
- Shared auth  

## Build phases
1. Buyer browse only  
2. Cart + checkout  
3. Seller product CRUD  
4. Seller order board  
5. Rules + two-role test  
6. Clean architecture refactor (L16)

## Portfolio
> Multi-vendor marketplace with role-based Flutter clients and secured product/order ownership.
