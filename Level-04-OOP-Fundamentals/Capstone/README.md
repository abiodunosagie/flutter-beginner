# Level 04 Capstone: User & Order System

## What You're Building

In this level, you'll complete the data layer with **User**, **Order**, and **Payment** classes using OOP principles.

```
┌─────────────────────────────────────────────────────────────┐
│                   LEVEL 04 CONTRIBUTION                      │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ShopEase Data Layer (Complete!)                            │
│   ┌──────────────────────────────────────────────────────┐  │
│   │                                                      │  │
│   │   ┌──────────┐     ┌──────────┐     ┌──────────┐    │  │
│   │   │ Product  │     │   Cart   │     │  ORDER   │    │  │
│   │   │ Level 01 │────▶│ Level 03 │────▶│  HERE!   │    │  │
│   │   └──────────┘     └──────────┘     └──────────┘    │  │
│   │                                           │          │  │
│   │                                           ▼          │  │
│   │   ┌──────────┐     ┌──────────┐     ┌──────────┐    │  │
│   │   │   USER   │────▶│ Address  │     │ Payment  │    │  │
│   │   │  HERE!   │     │  HERE!   │     │  HERE!   │    │  │
│   │   └──────────┘     └──────────┘     └──────────┘    │  │
│   │                                                      │  │
│   └──────────────────────────────────────────────────────┘  │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Your Tasks

### Task 1: Address Class

```dart
class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  String get fullAddress => '$street, $city, $state $zipCode, $country';
  bool get isValid => /* all fields non-empty */;
}
```

### Task 2: User Class with Inheritance

```dart
// Base user
abstract class AppUser {
  final String id;
  final String email;
  final String name;
  final DateTime createdAt;
}

// Regular customer
class Customer extends AppUser {
  final List<Address> addresses;
  final List<Order> orderHistory;
  final List<Product> wishlist;

  Address? get defaultAddress => /* find default */;
  int get totalOrders => orderHistory.length;
  double get totalSpent => /* sum of all orders */;
}

// Premium member (inheritance example)
class PremiumCustomer extends Customer {
  final DateTime membershipExpiry;
  final double discountRate; // e.g., 0.15 for 15%

  bool get isMembershipActive => /* check expiry */;
  double get discount => isMembershipActive ? discountRate : 0;
}
```

### Task 3: Order Class with Status

```dart
enum OrderStatus {
  pending,
  confirmed,
  processing,
  shipped,
  delivered,
  cancelled,
  refunded,
}

class Order {
  final String id;
  final String customerId;
  final List<CartItem> items;
  final Address shippingAddress;
  final Payment payment;
  final DateTime createdAt;
  OrderStatus status;

  // Getters
  double get subtotal;
  double get tax;
  double get shipping;
  double get total;
  bool get canCancel => status == OrderStatus.pending;
  bool get isComplete => status == OrderStatus.delivered;

  // Methods
  void updateStatus(OrderStatus newStatus);
  String get statusMessage;
}
```

### Task 4: Payment Class (Polymorphism)

```dart
abstract class Payment {
  final double amount;
  final DateTime timestamp;

  bool process();
  String get paymentMethod;
  String get maskedDetails;
}

class CreditCardPayment extends Payment {
  final String cardNumber;
  final String cardHolder;
  final String expiry;

  @override
  String get paymentMethod => 'Credit Card';

  @override
  String get maskedDetails => '**** **** **** ${cardNumber.substring(12)}';
}

class PayPalPayment extends Payment {
  final String email;

  @override
  String get paymentMethod => 'PayPal';

  @override
  String get maskedDetails => email.replaceRange(2, email.indexOf('@'), '***');
}

class ApplePayPayment extends Payment {
  @override
  String get paymentMethod => 'Apple Pay';

  @override
  String get maskedDetails => 'Apple Pay';
}
```

---

## Starter Code

```dart
// lib/models/address.dart
class Address {
  final String street;
  final String city;
  final String state;
  final String zipCode;
  final String country;
  final bool isDefault;

  const Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.country,
    this.isDefault = false,
  });

  // TODO: Add getters and methods
}

// lib/models/user.dart
abstract class AppUser {
  // TODO: Implement base class
}

class Customer extends AppUser {
  // TODO: Implement customer
}

class PremiumCustomer extends Customer {
  // TODO: Implement premium customer
}

// lib/models/order.dart
enum OrderStatus { pending, confirmed, processing, shipped, delivered, cancelled, refunded }

class Order {
  // TODO: Implement order
}

// lib/models/payment.dart
abstract class Payment {
  // TODO: Implement payment base and subclasses
}

// Test your models:
void main() {
  // Create address
  final address = Address(
    street: '123 Main St',
    city: 'San Francisco',
    state: 'CA',
    zipCode: '94102',
    country: 'USA',
    isDefault: true,
  );

  // Create customer
  final customer = Customer(
    id: 'user_001',
    email: 'john@example.com',
    name: 'John Doe',
    addresses: [address],
    orderHistory: [],
    wishlist: [],
  );

  // Create payment
  final payment = CreditCardPayment(
    amount: 299.99,
    cardNumber: '4111111111111234',
    cardHolder: 'John Doe',
    expiry: '12/25',
  );

  print(address.fullAddress);        // 123 Main St, San Francisco, CA 94102, USA
  print(customer.defaultAddress);     // Address object
  print(payment.maskedDetails);       // **** **** **** 1234
  print(payment.paymentMethod);       // Credit Card
}
```

---

## OOP Concepts Used

| Concept | Where Used |
|---------|------------|
| **Encapsulation** | Private lists in Cart, User |
| **Inheritance** | Customer → PremiumCustomer |
| **Polymorphism** | Payment methods |
| **Abstraction** | AppUser, Payment base classes |

---

## Success Criteria

- [ ] Address validates correctly
- [ ] User inheritance works (Customer, PremiumCustomer)
- [ ] Order tracks status transitions
- [ ] Payment polymorphism works for all types
- [ ] All getters return correct values
- [ ] Premium discount applies correctly

---

## Bonus Challenge

- [ ] Add `GuestUser` class (can checkout without account)
- [ ] Add `Refund` class that links to Order
- [ ] Add order tracking with status history
- [ ] Implement `Comparable` for sorting orders by date

---

## Files to Create

```
shopease/
└── lib/
    └── models/
        ├── product.dart        (from Level 01)
        ├── cart_item.dart      (from Level 03)
        ├── cart.dart           (from Level 03)
        ├── address.dart        ◄── Create this
        ├── user.dart           ◄── Create this
        ├── order.dart          ◄── Create this
        └── payment.dart        ◄── Create this
```

---

## Data Layer Complete!

You now have ALL the data models for ShopEase:
- ✅ Product
- ✅ Cart & CartItem
- ✅ User & PremiumCustomer
- ✅ Address
- ✅ Order & OrderStatus
- ✅ Payment types

**Next Level:** Time to build the UI with Flutter!
