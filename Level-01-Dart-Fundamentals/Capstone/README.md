# Level 01 Capstone: Product Data Model

## What You're Building

In this level, you'll create the **Product** model for ShopEase - the foundation of your e-commerce app.

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 01 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase App                                               │
│   ┌──────────────────────────────────────────────────────┐  │
│   │                                                      │  │
│   │   ┌────────────────────┐                            │  │
│   │   │  📦 Product Model  │ ◄── YOU ARE HERE!          │  │
│   │   │                    │                            │  │
│   │   │  • id              │                            │  │
│   │   │  • name            │                            │  │
│   │   │  • price           │                            │  │
│   │   │  • description     │                            │  │
│   │   │  • imageUrl        │                            │  │
│   │   │  • category        │                            │  │
│   │   └────────────────────┘                            │  │
│   │                                                      │  │
│   └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Task

Create a `Product` class with the following:

### Required Properties
```dart
String id          // Unique identifier (e.g., "prod_001")
String name        // Product name (e.g., "Classic T-Shirt")
double price       // Price in dollars (e.g., 29.99)
String description // Product description
String imageUrl    // URL to product image
String category    // Category name (e.g., "Clothing")
int stock          // Available quantity
double rating      // Average rating (0.0 - 5.0)
int reviewCount    // Number of reviews
```

### Computed Properties (Getters)
```dart
bool get isInStock        // true if stock > 0
bool get isOnSale         // true if price < 50 (for now)
String get formattedPrice // "$29.99" format
String get stockStatus    // "In Stock", "Low Stock", "Out of Stock"
```

---

## Starter Code

```dart
// lib/models/product.dart

class Product {
  // TODO: Add properties

  // TODO: Add constructor

  // TODO: Add getters

  // TODO: Add toString() for debugging
}

// Test your model:
void main() {
  final product = Product(
    id: 'prod_001',
    name: 'Classic T-Shirt',
    price: 29.99,
    description: 'A comfortable cotton t-shirt',
    imageUrl: 'https://example.com/tshirt.jpg',
    category: 'Clothing',
    stock: 50,
    rating: 4.5,
    reviewCount: 128,
  );

  print(product.name);           // Classic T-Shirt
  print(product.formattedPrice); // $29.99
  print(product.isInStock);      // true
  print(product.stockStatus);    // In Stock
}
```

---

## Expected Output

When you run your code, you should see:
```
Classic T-Shirt
$29.99
true
In Stock
```

---

## Success Criteria

- [ ] All properties are defined with correct types
- [ ] Constructor accepts all required properties
- [ ] `isInStock` returns correct boolean
- [ ] `formattedPrice` returns price with $ symbol
- [ ] `stockStatus` returns appropriate status message
- [ ] Code runs without errors

---

## Bonus Challenge

Add these extra features:
- [ ] `discountedPrice` getter (10% off)
- [ ] `hasGoodRating` getter (rating >= 4.0)
- [ ] Validation in constructor (price can't be negative)

---

## Next Level Preview

In Level 02, you'll add **business logic** to your Product model:
- Discount calculations
- Stock validation
- Category filtering

---

## Files to Create

```
shopease/
└── lib/
    └── models/
        └── product.dart   ◄── Create this file
```

---

**Ready?** Open DartPad or your IDE and start coding!
