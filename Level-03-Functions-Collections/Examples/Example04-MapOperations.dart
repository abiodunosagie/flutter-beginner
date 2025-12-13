// ===========================================
// Example 04: Map Operations
// Working with Maps (Key-Value Pairs)
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Creating Maps
  // -----------------------------------------

  print('--- Creating Maps ---');

  // Empty map
  var emptyMap = <String, int>{};
  print('Empty map: $emptyMap');

  // Map with initial values
  var ages = {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 35,
  };
  print('Ages: $ages');

  // Different types
  Map<String, dynamic> person = {
    'name': 'Alice',
    'age': 25,
    'isStudent': true,
    'gpa': 3.8,
  };
  print('Person: $person');

  // -----------------------------------------
  // PART 2: Accessing Values
  // -----------------------------------------

  print('\n--- Accessing Values ---');

  var scores = {'math': 95, 'science': 87, 'english': 92};

  print('Math score: ${scores['math']}');
  print('Science score: ${scores['science']}');
  print('History score: ${scores['history']}');  // null - doesn't exist

  // Safe access with default
  print('History (with default): ${scores['history'] ?? 0}');

  // -----------------------------------------
  // PART 3: Adding and Updating
  // -----------------------------------------

  print('\n--- Adding and Updating ---');

  var inventory = <String, int>{};
  print('Initial: $inventory');

  // Add items
  inventory['apples'] = 50;
  inventory['bananas'] = 30;
  inventory['oranges'] = 25;
  print('After adding: $inventory');

  // Update item
  inventory['apples'] = 45;  // Sold some
  print('After update: $inventory');

  // Add multiple
  inventory.addAll({'grapes': 40, 'pears': 20});
  print('After addAll: $inventory');

  // Add only if doesn't exist
  inventory.putIfAbsent('apples', () => 100);  // Won't change
  inventory.putIfAbsent('mangoes', () => 15);  // Will add
  print('After putIfAbsent: $inventory');

  // -----------------------------------------
  // PART 4: Removing
  // -----------------------------------------

  print('\n--- Removing ---');

  var data = {'a': 1, 'b': 2, 'c': 3, 'd': 4, 'e': 5};
  print('Initial: $data');

  // Remove by key
  data.remove('c');
  print('After remove(c): $data');

  // Remove by condition
  data.removeWhere((key, value) => value > 3);
  print('After removeWhere(>3): $data');

  // -----------------------------------------
  // PART 5: Checking Keys and Values
  // -----------------------------------------

  print('\n--- Checking ---');

  var settings = {'theme': 'dark', 'fontSize': 16, 'language': 'en'};

  print('Has theme: ${settings.containsKey('theme')}');
  print('Has color: ${settings.containsKey('color')}');
  print('Has dark value: ${settings.containsValue('dark')}');

  // -----------------------------------------
  // PART 6: Properties
  // -----------------------------------------

  print('\n--- Properties ---');

  var config = {'host': 'localhost', 'port': 3000, 'debug': true};

  print('Length: ${config.length}');
  print('isEmpty: ${config.isEmpty}');
  print('isNotEmpty: ${config.isNotEmpty}');
  print('Keys: ${config.keys.toList()}');
  print('Values: ${config.values.toList()}');

  // -----------------------------------------
  // PART 7: Iterating
  // -----------------------------------------

  print('\n--- Iterating ---');

  var prices = {'coffee': 3.50, 'tea': 2.50, 'juice': 4.00};

  // forEach
  print('Using forEach:');
  prices.forEach((item, price) {
    print('  $item: \$${price.toStringAsFixed(2)}');
  });

  // for-in with entries
  print('Using entries:');
  for (var entry in prices.entries) {
    print('  ${entry.key}: \$${entry.value.toStringAsFixed(2)}');
  }

  // Iterate keys only
  print('Keys only:');
  for (var key in prices.keys) {
    print('  $key');
  }

  // -----------------------------------------
  // PART 8: Transforming
  // -----------------------------------------

  print('\n--- Transforming ---');

  var original = {'a': 1, 'b': 2, 'c': 3};
  print('Original: $original');

  // Transform values (double them)
  var doubled = original.map((key, value) => MapEntry(key, value * 2));
  print('Doubled values: $doubled');

  // Transform keys (uppercase)
  var upperKeys = original.map((key, value) => MapEntry(key.toUpperCase(), value));
  print('Uppercase keys: $upperKeys');

  // Convert to list
  var entries = original.entries.map((e) => '${e.key}=${e.value}').toList();
  print('As list: $entries');

  // -----------------------------------------
  // PART 9: Filtering
  // -----------------------------------------

  print('\n--- Filtering ---');

  var products = {
    'laptop': 999.99,
    'mouse': 29.99,
    'keyboard': 79.99,
    'monitor': 299.99,
    'webcam': 49.99,
  };
  print('All products: $products');

  // Filter by value
  var expensive = Map.fromEntries(
      products.entries.where((e) => e.value > 100)
  );
  print('Expensive (>100): $expensive');

  // Filter by key
  var shortNames = Map.fromEntries(
      products.entries.where((e) => e.key.length <= 5)
  );
  print('Short names: $shortNames');

  // -----------------------------------------
  // PART 10: Nested Maps
  // -----------------------------------------

  print('\n--- Nested Maps ---');

  var users = {
    'user1': {
      'name': 'Alice',
      'age': 25,
      'address': {'city': 'NYC', 'country': 'USA'},
    },
    'user2': {
      'name': 'Bob',
      'age': 30,
      'address': {'city': 'London', 'country': 'UK'},
    },
  };

  // Access nested data
  print('User1 name: ${users['user1']?['name']}');
  print('User1 city: ${users['user1']?['address']?['city']}');

  // Iterate nested
  print('All users:');
  users.forEach((id, userData) {
    print('  $id: ${userData['name']} from ${userData['address']?['city']}');
  });

  // -----------------------------------------
  // PART 11: Common Patterns
  // -----------------------------------------

  print('\n--- Common Patterns ---');

  // Word frequency counter
  var text = 'the quick brown fox jumps over the lazy dog the fox';
  var words = text.split(' ');
  var frequency = <String, int>{};

  for (var word in words) {
    frequency[word] = (frequency[word] ?? 0) + 1;
  }
  print('Word frequency: $frequency');

  // Grouping
  var people = ['Alice', 'Bob', 'Anna', 'Charlie', 'Amy', 'Brian'];
  var byFirstLetter = <String, List<String>>{};

  for (var name in people) {
    var letter = name[0];
    byFirstLetter.putIfAbsent(letter, () => []);
    byFirstLetter[letter]!.add(name);
  }
  print('Grouped by letter: $byFirstLetter');

  // -----------------------------------------
  // PART 12: Practical Example - User Settings
  // -----------------------------------------

  print('\n--- User Settings Example ---');

  var defaultSettings = {
    'theme': 'light',
    'fontSize': 14,
    'notifications': true,
    'language': 'en',
  };

  var userSettings = {
    'theme': 'dark',
    'fontSize': 16,
  };

  // Merge: user settings override defaults
  var finalSettings = {...defaultSettings, ...userSettings};
  print('Default: $defaultSettings');
  print('User: $userSettings');
  print('Final: $finalSettings');

  // -----------------------------------------
  // PART 13: Practical Example - Grade Book
  // -----------------------------------------

  print('\n--- Grade Book Example ---');

  var gradeBook = <String, List<int>>{
    'Alice': [85, 90, 92],
    'Bob': [78, 82, 80],
    'Charlie': [95, 98, 96],
  };

  // Calculate averages
  gradeBook.forEach((student, grades) {
    var average = grades.reduce((a, b) => a + b) / grades.length;
    print('$student: grades=$grades, average=${average.toStringAsFixed(1)}');
  });

  // Find top student
  var topStudent = gradeBook.entries.reduce((a, b) {
    var avgA = a.value.reduce((x, y) => x + y) / a.value.length;
    var avgB = b.value.reduce((x, y) => x + y) / b.value.length;
    return avgA > avgB ? a : b;
  });
  print('Top student: ${topStudent.key}');
}

// ===========================================
// Try it yourself:
// 1. Create an inventory system that tracks item quantities
// 2. Build a contact book with name -> phone number
// 3. Create a function that merges two maps
// ===========================================
