# Level 02 Capstone: Business Logic & Validation

## What You're Building

In this level, you'll add **business logic** to ShopEase - discount calculations, validation, and conditional pricing.

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 02 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase App                                               │
│   ┌──────────────────────────────────────────────────────┐  │
│   │                                                      │  │
│   │   ┌────────────────────┐                            │  │
│   │   │  📦 Product Model  │  (from Level 01)           │  │
│   │   └─────────┬──────────┘                            │  │
│   │             │                                        │  │
│   │             ▼                                        │  │
│   │   ┌────────────────────┐                            │  │
│   │   │  🧮 Business Logic │ ◄── YOU ARE HERE!          │  │
│   │   │                    │                            │  │
│   │   │  • Discount rules  │                            │  │
│   │   │  • Price tiers     │                            │  │
│   │   │  • Stock alerts    │                            │  │
│   │   │  • Validation      │                            │  │
│   │   └────────────────────┘                            │  │
│   │                                                      │  │
│   └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Discount Calculator

Create a function that calculates discounts based on rules:

```dart
double calculateDiscount(Product product, String? couponCode) {
  // Rules:
  // 1. Products over $100 get 10% off
  // 2. Products in "Electronics" category get 5% off
  // 3. Coupon "SAVE20" gives 20% off
  // 4. Coupon "FIRST10" gives 10% off (first-time buyers)
  // 5. Discounts can stack (max 40% total)
}
```

### Task 2: Stock Status Checker

Create a function that returns stock status with warnings:

```dart
String getStockStatus(Product product) {
  // Rules:
  // stock == 0     → "Out of Stock"
  // stock <= 5     → "Only X left - Order soon!"
  // stock <= 20    → "Low Stock"
  // stock > 20     → "In Stock"
}
```

### Task 3: Price Tier Classifier

Create a function that classifies products by price:

```dart
String getPriceTier(double price) {
  // Rules:
  // price < 25     → "Budget"
  // price < 50     → "Mid-Range"
  // price < 100    → "Premium"
  // price >= 100   → "Luxury"
}
```

### Task 4: Order Validator

Create a function that validates an order:

```dart
ValidationResult validateOrder({
  required Product product,
  required int quantity,
  required String email,
}) {
  // Validate:
  // 1. Product is in stock
  // 2. Quantity <= available stock
  // 3. Quantity > 0 and <= 10 (max per order)
  // 4. Email is valid format
  // Return: { isValid: bool, errors: List<String> }
}
```

---

## Starter Code

```dart
// lib/utils/business_logic.dart

class ValidationResult {
  final bool isValid;
  final List<String> errors;

  ValidationResult({required this.isValid, required this.errors});
}

double calculateDiscount(Product product, String? couponCode) {
  double totalDiscount = 0;

  // TODO: Implement discount rules
  // Remember: max discount is 40%

  return totalDiscount;
}

String getStockStatus(Product product) {
  // TODO: Implement stock status logic

  return 'In Stock';
}

String getPriceTier(double price) {
  // TODO: Implement price tier logic

  return 'Unknown';
}

ValidationResult validateOrder({
  required Product product,
  required int quantity,
  required String email,
}) {
  List<String> errors = [];

  // TODO: Implement validation

  return ValidationResult(
    isValid: errors.isEmpty,
    errors: errors,
  );
}

// Test your logic:
void main() {
  final product = Product(
    id: 'prod_001',
    name: 'Laptop',
    price: 999.99,
    description: 'Powerful laptop',
    imageUrl: 'https://example.com/laptop.jpg',
    category: 'Electronics',
    stock: 3,
    rating: 4.8,
    reviewCount: 256,
  );

  print(calculateDiscount(product, 'SAVE20'));  // Should be 35% (10+5+20)
  print(getStockStatus(product));               // "Only 3 left - Order soon!"
  print(getPriceTier(product.price));           // "Luxury"

  final result = validateOrder(
    product: product,
    quantity: 2,
    email: 'user@example.com',
  );
  print(result.isValid);  // true
}
```

---

## Expected Output

```
0.35
Only 3 left - Order soon!
Luxury
true
```

---

## Success Criteria

- [ ] Discount calculator handles all rules correctly
- [ ] Discounts are capped at 40%
- [ ] Stock status shows correct warnings
- [ ] Price tiers are classified correctly
- [ ] Order validation catches all errors
- [ ] Email validation uses proper regex

---

## Bonus Challenge

- [ ] Add "holiday sale" rule (extra 15% in December)
- [ ] Add quantity-based discounts (buy 3+ get 5% off)
- [ ] Add shipping cost calculator based on location

---

## Files to Create

```
shopease/
└── lib/
    ├── models/
    │   └── product.dart       (from Level 01)
    └── utils/
        ├── business_logic.dart  ◄── Create this
        └── validators.dart      ◄── Create this
```

---

**Continue building ShopEase!**
