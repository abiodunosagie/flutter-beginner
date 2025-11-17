// Exercise 3: E-Commerce Product System (Intermediate)
// Topic: Polymorphism and Abstract Classes

// Abstract Product class
abstract class Product {
  String id;
  String name;
  double basePrice;

  Product(this.id, this.name, this.basePrice);

  // Abstract methods
  double calculateFinalPrice();
  String getProductType();

  void displayInfo() {
    print('ID: $id');
    print('Name: $name');
    print('Type: ${getProductType()}');
    print('Price: \$${calculateFinalPrice().toStringAsFixed(2)}');
  }
}

// PhysicalProduct class
class PhysicalProduct extends Product {
  double weight;
  double shippingCost;

  PhysicalProduct(
    String id,
    String name,
    double basePrice,
    this.weight,
    this.shippingCost,
  ) : super(id, name, basePrice);

  @override
  double calculateFinalPrice() {
    return basePrice + shippingCost;
  }

  @override
  String getProductType() {
    return 'Physical';
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Weight: ${weight}kg');
    print('Shipping: \$${shippingCost.toStringAsFixed(2)}');
  }
}

// DigitalProduct class
class DigitalProduct extends Product {
  double fileSize; // in MB
  String downloadLink;

  DigitalProduct(
    String id,
    String name,
    double basePrice,
    this.fileSize,
    this.downloadLink,
  ) : super(id, name, basePrice);

  @override
  double calculateFinalPrice() {
    return basePrice; // No shipping for digital products
  }

  @override
  String getProductType() {
    return 'Digital';
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('File Size: ${fileSize}MB');
    print('Download: $downloadLink');
  }
}

// SubscriptionProduct class
class SubscriptionProduct extends Product {
  int durationMonths;
  double monthlyPrice;

  SubscriptionProduct(
    String id,
    String name,
    double basePrice,
    this.durationMonths,
    this.monthlyPrice,
  ) : super(id, name, basePrice);

  @override
  double calculateFinalPrice() {
    double total = monthlyPrice * durationMonths;
    // 10% discount for 12+ months
    if (durationMonths >= 12) {
      total *= 0.9;
    }
    return total;
  }

  @override
  String getProductType() {
    return 'Subscription';
  }

  @override
  void displayInfo() {
    super.displayInfo();
    print('Duration: $durationMonths months');
    print('Monthly Price: \$${monthlyPrice.toStringAsFixed(2)}');
    if (durationMonths >= 12) {
      print('Discount: 10% applied!');
    }
  }
}

// ShoppingCart class
class ShoppingCart {
  List<Product> items = [];

  void addProduct(Product product) {
    items.add(product);
    print('Added: ${product.name}');
  }

  bool removeProduct(String productId) {
    int initialLength = items.length;
    items.removeWhere((product) => product.id == productId);

    if (items.length < initialLength) {
      print('Removed product with ID: $productId');
      return true;
    } else {
      print('Product not found: $productId');
      return false;
    }
  }

  double calculateTotal() {
    double total = 0;
    for (Product product in items) {
      total += product.calculateFinalPrice();
    }
    return total;
  }

  void displayCart() {
    if (items.isEmpty) {
      print('Cart is empty!');
      return;
    }

    print('\n========== SHOPPING CART ==========');
    for (int i = 0; i < items.length; i++) {
      print('\nItem ${i + 1}:');
      items[i].displayInfo();
      print('---');
    }
    print('\nTOTAL: \$${calculateTotal().toStringAsFixed(2)}');
    print('===================================\n');
  }

  List<Product> getProductsByType(String type) {
    return items.where((product) => product.getProductType() == type).toList();
  }

  int get itemCount => items.length;
}

void main() {
  // Create shopping cart
  ShoppingCart cart = ShoppingCart();

  // Create different product types
  PhysicalProduct laptop = PhysicalProduct(
    'P001',
    'Gaming Laptop',
    999.99,
    2.5,
    15.99,
  );

  PhysicalProduct keyboard = PhysicalProduct(
    'P002',
    'Mechanical Keyboard',
    79.99,
    0.8,
    5.99,
  );

  DigitalProduct ebook = DigitalProduct(
    'D001',
    'Dart Programming Guide',
    29.99,
    15.5,
    'https://download.example.com/dart-guide',
  );

  DigitalProduct course = DigitalProduct(
    'D002',
    'Flutter Masterclass',
    49.99,
    2500.0,
    'https://download.example.com/flutter-course',
  );

  SubscriptionProduct monthlyPlan = SubscriptionProduct(
    'S001',
    'Premium Monthly',
    0,
    6,
    9.99,
  );

  SubscriptionProduct yearlyPlan = SubscriptionProduct(
    'S002',
    'Premium Yearly',
    0,
    12,
    9.99,
  );

  // Add products to cart
  print('=== ADDING PRODUCTS ===');
  cart.addProduct(laptop);
  cart.addProduct(keyboard);
  cart.addProduct(ebook);
  cart.addProduct(course);
  cart.addProduct(monthlyPlan);
  cart.addProduct(yearlyPlan);

  // Display cart
  cart.displayCart();

  // Get products by type
  print('=== PHYSICAL PRODUCTS ===');
  List<Product> physicalProducts = cart.getProductsByType('Physical');
  print('Found ${physicalProducts.length} physical products');
  for (Product product in physicalProducts) {
    print('- ${product.name}');
  }

  print('\n=== DIGITAL PRODUCTS ===');
  List<Product> digitalProducts = cart.getProductsByType('Digital');
  print('Found ${digitalProducts.length} digital products');
  for (Product product in digitalProducts) {
    print('- ${product.name}');
  }

  print('\n=== SUBSCRIPTIONS ===');
  List<Product> subscriptions = cart.getProductsByType('Subscription');
  print('Found ${subscriptions.length} subscriptions');
  for (Product product in subscriptions) {
    print('- ${product.name}');
  }

  // Remove a product
  print('\n=== REMOVING PRODUCT ===');
  cart.removeProduct('D001');
  cart.displayCart();

  // Polymorphism example
  print('=== POLYMORPHISM DEMO ===');
  for (Product product in cart.items) {
    print('${product.name} [${product.getProductType()}]: \$${product.calculateFinalPrice().toStringAsFixed(2)}');
  }
}
