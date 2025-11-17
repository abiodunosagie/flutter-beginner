// Exercise 3: E-Commerce Product System (Intermediate)
// Topic: Polymorphism and Abstract Classes
//
// Create an e-commerce product system using abstract classes and polymorphism:
// 1. Create an abstract Product class with:
//    - Properties: id (String), name (String), basePrice (double)
//    - Constructor that initializes all properties
//    - Abstract method: calculateFinalPrice() returns double
//    - Abstract method: getProductType() returns String
//    - Method: displayInfo() prints basic product information
//
// 2. Create PhysicalProduct that extends Product:
//    - Additional properties: weight (double), shippingCost (double)
//    - Override calculateFinalPrice() to return basePrice + shippingCost
//    - Override getProductType() to return "Physical"
//    - Override displayInfo() to include weight and shipping cost
//
// 3. Create DigitalProduct that extends Product:
//    - Additional properties: fileSize (double in MB), downloadLink (String)
//    - Override calculateFinalPrice() to return basePrice (no shipping)
//    - Override getProductType() to return "Digital"
//    - Override displayInfo() to include file size
//
// 4. Create SubscriptionProduct that extends Product:
//    - Additional properties: durationMonths (int), monthlyPrice (double)
//    - Override calculateFinalPrice() to return monthlyPrice * durationMonths
//      Apply 10% discount if duration >= 12 months
//    - Override getProductType() to return "Subscription"
//    - Override displayInfo() to include duration and monthly price
//
// 5. Create a ShoppingCart class with:
//    - Property: items (List<Product>)
//    - Method: addProduct(Product product)
//    - Method: removeProduct(String productId)
//    - Method: calculateTotal() returns total of all products
//    - Method: displayCart() shows all items with details
//    - Method: getProductsByType(String type) returns products of specific type
//
// Test with a shopping cart containing different product types.

void main() {
  // TODO: Create instances of different product types
  // TODO: Add them to a shopping cart
  // TODO: Display cart and calculate total

}

// TODO: Implement abstract Product class


// TODO: Implement PhysicalProduct class


// TODO: Implement DigitalProduct class


// TODO: Implement SubscriptionProduct class


// TODO: Implement ShoppingCart class
