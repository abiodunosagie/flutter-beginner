// ===========================================
// Example 03: List Operations
// Working with Lists
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Creating Lists
  // -----------------------------------------

  print('--- Creating Lists ---');

  // Empty list
  var emptyList = <int>[];
  print('Empty list: $emptyList');

  // List with initial values
  var numbers = [1, 2, 3, 4, 5];
  print('Numbers: $numbers');

  var fruits = ['apple', 'banana', 'cherry'];
  print('Fruits: $fruits');

  // Generated list
  var zeros = List.filled(5, 0);
  print('Zeros: $zeros');

  var squares = List.generate(5, (i) => (i + 1) * (i + 1));
  print('Squares: $squares');

  // -----------------------------------------
  // PART 2: Accessing Elements
  // -----------------------------------------

  print('\n--- Accessing Elements ---');

  var colors = ['red', 'green', 'blue', 'yellow', 'purple'];

  print('First: ${colors.first}');
  print('Last: ${colors.last}');
  print('Index 0: ${colors[0]}');
  print('Index 2: ${colors[2]}');
  print('Length: ${colors.length}');

  // -----------------------------------------
  // PART 3: Adding Elements
  // -----------------------------------------

  print('\n--- Adding Elements ---');

  var items = ['a', 'b'];
  print('Initial: $items');

  items.add('c');
  print('After add: $items');

  items.addAll(['d', 'e', 'f']);
  print('After addAll: $items');

  items.insert(0, 'START');
  print('After insert at 0: $items');

  items.insert(3, 'MIDDLE');
  print('After insert at 3: $items');

  // -----------------------------------------
  // PART 4: Removing Elements
  // -----------------------------------------

  print('\n--- Removing Elements ---');

  var nums = [1, 2, 3, 4, 5, 4, 3, 2, 1];
  print('Initial: $nums');

  nums.remove(3);  // Removes first 3
  print('After remove(3): $nums');

  nums.removeAt(0);
  print('After removeAt(0): $nums');

  nums.removeLast();
  print('After removeLast(): $nums');

  nums.removeWhere((n) => n > 3);
  print('After removeWhere(>3): $nums');

  // -----------------------------------------
  // PART 5: Modifying Elements
  // -----------------------------------------

  print('\n--- Modifying Elements ---');

  var letters = ['a', 'b', 'c', 'd', 'e'];
  print('Initial: $letters');

  letters[0] = 'A';
  print('After [0]=A: $letters');

  letters.replaceRange(2, 4, ['X', 'Y', 'Z']);
  print('After replaceRange: $letters');

  // -----------------------------------------
  // PART 6: Searching
  // -----------------------------------------

  print('\n--- Searching ---');

  var data = [10, 20, 30, 40, 50, 30, 20, 10];

  print('Contains 30: ${data.contains(30)}');
  print('Contains 99: ${data.contains(99)}');
  print('indexOf 30: ${data.indexOf(30)}');
  print('lastIndexOf 30: ${data.lastIndexOf(30)}');

  // -----------------------------------------
  // PART 7: Iterating
  // -----------------------------------------

  print('\n--- Iterating ---');

  var pets = ['dog', 'cat', 'bird', 'fish'];

  // For loop with index
  print('With index:');
  for (int i = 0; i < pets.length; i++) {
    print('  $i: ${pets[i]}');
  }

  // For-in loop
  print('For-in:');
  for (var pet in pets) {
    print('  $pet');
  }

  // forEach
  print('forEach:');
  pets.forEach((pet) => print('  $pet'));

  // With index using asMap
  print('With asMap:');
  pets.asMap().forEach((index, pet) {
    print('  $index: $pet');
  });

  // -----------------------------------------
  // PART 8: Transforming with map()
  // -----------------------------------------

  print('\n--- Transforming ---');

  var prices = [10.0, 25.0, 50.0, 100.0];
  print('Original prices: $prices');

  // Add 10% tax
  var withTax = prices.map((p) => p * 1.1).toList();
  print('With 10% tax: $withTax');

  // Format as currency
  var formatted = prices.map((p) => '\$${p.toStringAsFixed(2)}').toList();
  print('Formatted: $formatted');

  // -----------------------------------------
  // PART 9: Filtering with where()
  // -----------------------------------------

  print('\n--- Filtering ---');

  var scores = [45, 78, 92, 56, 88, 34, 95, 67];
  print('All scores: $scores');

  var passing = scores.where((s) => s >= 60).toList();
  print('Passing (>=60): $passing');

  var excellent = scores.where((s) => s >= 90).toList();
  print('Excellent (>=90): $excellent');

  var failing = scores.where((s) => s < 60).toList();
  print('Failing (<60): $failing');

  // -----------------------------------------
  // PART 10: Reducing
  // -----------------------------------------

  print('\n--- Reducing ---');

  var values = [1, 2, 3, 4, 5];

  var sum = values.reduce((a, b) => a + b);
  print('Sum: $sum');

  var product = values.reduce((a, b) => a * b);
  print('Product: $product');

  var max = values.reduce((a, b) => a > b ? a : b);
  print('Max: $max');

  var min = values.reduce((a, b) => a < b ? a : b);
  print('Min: $min');

  // fold with initial value
  var sumFrom100 = values.fold(100, (prev, curr) => prev + curr);
  print('Sum starting from 100: $sumFrom100');

  // -----------------------------------------
  // PART 11: Sorting
  // -----------------------------------------

  print('\n--- Sorting ---');

  var unsorted = [3, 1, 4, 1, 5, 9, 2, 6];
  print('Unsorted: $unsorted');

  var sorted = [...unsorted]..sort();
  print('Sorted (ascending): $sorted');

  var descending = [...unsorted]..sort((a, b) => b.compareTo(a));
  print('Sorted (descending): $descending');

  // Sort strings
  var words = ['banana', 'apple', 'cherry', 'date'];
  words.sort();
  print('Sorted words: $words');

  // Sort by length
  words.sort((a, b) => a.length.compareTo(b.length));
  print('Sorted by length: $words');

  // -----------------------------------------
  // PART 12: Chaining Operations
  // -----------------------------------------

  print('\n--- Chaining ---');

  var rawData = [5, -3, 8, -1, 10, -7, 3, 6];
  print('Raw data: $rawData');

  var processed = rawData
      .where((n) => n > 0)       // Keep positive
      .map((n) => n * 2)         // Double
      .where((n) => n > 5)       // Keep > 5
      .toList()
    ..sort();                    // Sort

  print('Processed: $processed');

  // -----------------------------------------
  // PART 13: List Spread
  // -----------------------------------------

  print('\n--- Spread Operator ---');

  var list1 = [1, 2, 3];
  var list2 = [4, 5, 6];
  var combined = [...list1, ...list2];
  print('Combined: $combined');

  var withExtra = [0, ...list1, 100, ...list2, 1000];
  print('With extras: $withExtra');

  // -----------------------------------------
  // PART 14: Practical Example
  // -----------------------------------------

  print('\n--- Shopping Cart Example ---');

  var cart = [
    {'name': 'Apple', 'price': 1.50, 'qty': 3},
    {'name': 'Bread', 'price': 2.50, 'qty': 2},
    {'name': 'Milk', 'price': 3.00, 'qty': 1},
    {'name': 'Eggs', 'price': 4.00, 'qty': 2},
  ];

  // Print cart
  print('Cart items:');
  for (var item in cart) {
    double subtotal = (item['price'] as double) * (item['qty'] as int);
    print('  ${item['name']}: ${item['qty']} x \$${item['price']} = \$${subtotal.toStringAsFixed(2)}');
  }

  // Calculate total
  double total = cart.fold(0.0, (sum, item) {
    return sum + (item['price'] as double) * (item['qty'] as int);
  });
  print('Total: \$${total.toStringAsFixed(2)}');

  // Items over $5 total
  var expensiveItems = cart.where((item) {
    return (item['price'] as double) * (item['qty'] as int) > 5;
  }).toList();
  print('Items over \$5: ${expensiveItems.map((i) => i['name']).toList()}');
}

// ===========================================
// Try it yourself:
// 1. Create a list of student objects and sort by grade
// 2. Filter a list to keep only unique items
// 3. Calculate the average of a list of numbers
// ===========================================
