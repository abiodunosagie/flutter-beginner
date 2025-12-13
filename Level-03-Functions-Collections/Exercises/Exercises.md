# Level 3 Exercises: Functions & Collections

Test your understanding of functions, lists, maps, and sets!

---

## Exercise 1: Temperature Converter

**Difficulty:** ⭐ Easy

Create functions to convert temperatures between Celsius, Fahrenheit, and Kelvin.

```dart
void main() {
  // TODO: Create these functions:
  // - celsiusToFahrenheit(double c)
  // - fahrenheitToCelsius(double f)
  // - celsiusToKelvin(double c)
  // - kelvinToCelsius(double k)

  // Test with:
  // 0°C = 32°F = 273.15K
  // 100°C = 212°F = 373.15K
}
```

<details>
<summary>💡 Hint</summary>

- F = C × 9/5 + 32
- C = (F - 32) × 5/9
- K = C + 273.15

</details>

<details>
<summary>✅ Solution</summary>

```dart
double celsiusToFahrenheit(double c) => c * 9 / 5 + 32;
double fahrenheitToCelsius(double f) => (f - 32) * 5 / 9;
double celsiusToKelvin(double c) => c + 273.15;
double kelvinToCelsius(double k) => k - 273.15;

void main() {
  print('0°C = ${celsiusToFahrenheit(0)}°F');
  print('0°C = ${celsiusToKelvin(0)}K');
  print('100°C = ${celsiusToFahrenheit(100)}°F');
  print('32°F = ${fahrenheitToCelsius(32)}°C');
}
```

</details>

---

## Exercise 2: List Statistics

**Difficulty:** ⭐ Easy

Create functions to calculate statistics for a list of numbers.

```dart
void main() {
  var numbers = [23, 45, 12, 67, 34, 89, 21, 56, 78, 43];

  // TODO: Create these functions:
  // - findSum(List<int> nums)
  // - findAverage(List<int> nums)
  // - findMax(List<int> nums)
  // - findMin(List<int> nums)
  // - countAbove(List<int> nums, int threshold)
}
```

<details>
<summary>💡 Hint</summary>

Use `reduce()` for sum, max, min. Average = sum / length.

</details>

<details>
<summary>✅ Solution</summary>

```dart
int findSum(List<int> nums) => nums.reduce((a, b) => a + b);
double findAverage(List<int> nums) => findSum(nums) / nums.length;
int findMax(List<int> nums) => nums.reduce((a, b) => a > b ? a : b);
int findMin(List<int> nums) => nums.reduce((a, b) => a < b ? a : b);
int countAbove(List<int> nums, int threshold) =>
    nums.where((n) => n > threshold).length;

void main() {
  var numbers = [23, 45, 12, 67, 34, 89, 21, 56, 78, 43];

  print('Sum: ${findSum(numbers)}');
  print('Average: ${findAverage(numbers).toStringAsFixed(1)}');
  print('Max: ${findMax(numbers)}');
  print('Min: ${findMin(numbers)}');
  print('Count above 50: ${countAbove(numbers, 50)}');
}
```

</details>

---

## Exercise 3: Password Validator

**Difficulty:** ⭐⭐ Medium

Create a function that validates passwords with named parameters for rules.

```dart
void main() {
  // TODO: Create validatePassword function with these named parameters:
  // - password (required)
  // - minLength (default: 8)
  // - requireUppercase (default: true)
  // - requireLowercase (default: true)
  // - requireDigit (default: true)
  // - requireSpecial (default: false)

  // Return a Map with 'valid' (bool) and 'errors' (List<String>)

  var result = validatePassword(
    password: 'MyPass123',
    requireSpecial: true,
  );

  print('Valid: ${result['valid']}');
  print('Errors: ${result['errors']}');
}
```

<details>
<summary>💡 Hint</summary>

Check each requirement and add error messages to a list. Valid if errors list is empty.

</details>

<details>
<summary>✅ Solution</summary>

```dart
Map<String, dynamic> validatePassword({
  required String password,
  int minLength = 8,
  bool requireUppercase = true,
  bool requireLowercase = true,
  bool requireDigit = true,
  bool requireSpecial = false,
}) {
  List<String> errors = [];

  if (password.length < minLength) {
    errors.add('Must be at least $minLength characters');
  }

  if (requireUppercase && !password.contains(RegExp(r'[A-Z]'))) {
    errors.add('Must contain uppercase letter');
  }

  if (requireLowercase && !password.contains(RegExp(r'[a-z]'))) {
    errors.add('Must contain lowercase letter');
  }

  if (requireDigit && !password.contains(RegExp(r'[0-9]'))) {
    errors.add('Must contain digit');
  }

  if (requireSpecial && !password.contains(RegExp(r'[!@#$%^&*]'))) {
    errors.add('Must contain special character (!@#\$%^&*)');
  }

  return {
    'valid': errors.isEmpty,
    'errors': errors,
  };
}

void main() {
  var result1 = validatePassword(password: 'MyPass123');
  print('MyPass123: ${result1['valid']} - ${result1['errors']}');

  var result2 = validatePassword(
    password: 'MyPass123!',
    requireSpecial: true,
  );
  print('MyPass123!: ${result2['valid']} - ${result2['errors']}');

  var result3 = validatePassword(password: 'weak');
  print('weak: ${result3['valid']} - ${result3['errors']}');
}
```

</details>

---

## Exercise 4: Word Counter

**Difficulty:** ⭐⭐ Medium

Create a function that analyzes text and returns word statistics.

```dart
void main() {
  var text = '''
  The quick brown fox jumps over the lazy dog.
  The dog was not amused. The fox ran away quickly.
  ''';

  // TODO: Create analyzeWords(String text) that returns a Map with:
  // - 'wordCount': total words
  // - 'uniqueWords': count of unique words
  // - 'frequency': Map of word -> count
  // - 'longestWord': the longest word
  // - 'shortestWord': the shortest word (length > 0)
}
```

<details>
<summary>💡 Hint</summary>

Split text into words, convert to lowercase, remove punctuation. Use a Map to count frequency.

</details>

<details>
<summary>✅ Solution</summary>

```dart
Map<String, dynamic> analyzeWords(String text) {
  // Clean and split
  var words = text
      .toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '')
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();

  // Count frequency
  var frequency = <String, int>{};
  for (var word in words) {
    frequency[word] = (frequency[word] ?? 0) + 1;
  }

  // Find longest and shortest
  var longest = words.reduce((a, b) => a.length > b.length ? a : b);
  var shortest = words.reduce((a, b) => a.length < b.length ? a : b);

  return {
    'wordCount': words.length,
    'uniqueWords': frequency.length,
    'frequency': frequency,
    'longestWord': longest,
    'shortestWord': shortest,
  };
}

void main() {
  var text = '''
  The quick brown fox jumps over the lazy dog.
  The dog was not amused. The fox ran away quickly.
  ''';

  var result = analyzeWords(text);

  print('Total words: ${result['wordCount']}');
  print('Unique words: ${result['uniqueWords']}');
  print('Longest: ${result['longestWord']}');
  print('Shortest: ${result['shortestWord']}');
  print('\nFrequency:');
  (result['frequency'] as Map).forEach((word, count) {
    if (count > 1) print('  $word: $count');
  });
}
```

</details>

---

## Exercise 5: Shopping List Manager

**Difficulty:** ⭐⭐ Medium

Create a shopping list manager using functions and collections.

```dart
void main() {
  // TODO: Create these functions:
  // - addItem(list, name, quantity, [category])
  // - removeItem(list, name)
  // - updateQuantity(list, name, newQuantity)
  // - getByCategory(list, category)
  // - getTotalItems(list)
  // - printList(list)

  var shoppingList = <Map<String, dynamic>>[];

  addItem(shoppingList, 'Milk', 2, 'Dairy');
  addItem(shoppingList, 'Bread', 1, 'Bakery');
  addItem(shoppingList, 'Eggs', 12, 'Dairy');
  addItem(shoppingList, 'Apples', 6, 'Produce');

  printList(shoppingList);
}
```

<details>
<summary>💡 Hint</summary>

Each item is a Map with keys: name, quantity, category. Use List methods to find and modify items.

</details>

<details>
<summary>✅ Solution</summary>

```dart
void addItem(List<Map<String, dynamic>> list, String name, int quantity,
    [String category = 'General']) {
  list.add({
    'name': name,
    'quantity': quantity,
    'category': category,
  });
}

void removeItem(List<Map<String, dynamic>> list, String name) {
  list.removeWhere((item) => item['name'] == name);
}

void updateQuantity(List<Map<String, dynamic>> list, String name, int newQty) {
  for (var item in list) {
    if (item['name'] == name) {
      item['quantity'] = newQty;
      break;
    }
  }
}

List<Map<String, dynamic>> getByCategory(
    List<Map<String, dynamic>> list, String category) {
  return list.where((item) => item['category'] == category).toList();
}

int getTotalItems(List<Map<String, dynamic>> list) {
  return list.fold(0, (sum, item) => sum + (item['quantity'] as int));
}

void printList(List<Map<String, dynamic>> list) {
  print('Shopping List:');
  print('-' * 40);

  // Group by category
  var categories = list.map((i) => i['category']).toSet();

  for (var category in categories) {
    print('\n[$category]');
    var items = getByCategory(list, category as String);
    for (var item in items) {
      print('  ${item['name']}: ${item['quantity']}');
    }
  }

  print('\n${'-' * 40}');
  print('Total items: ${getTotalItems(list)}');
}

void main() {
  var shoppingList = <Map<String, dynamic>>[];

  addItem(shoppingList, 'Milk', 2, 'Dairy');
  addItem(shoppingList, 'Bread', 1, 'Bakery');
  addItem(shoppingList, 'Eggs', 12, 'Dairy');
  addItem(shoppingList, 'Apples', 6, 'Produce');
  addItem(shoppingList, 'Cheese', 1, 'Dairy');
  addItem(shoppingList, 'Croissants', 4, 'Bakery');

  printList(shoppingList);

  print('\nUpdating Milk quantity to 3...');
  updateQuantity(shoppingList, 'Milk', 3);

  print('Removing Bread...\n');
  removeItem(shoppingList, 'Bread');

  printList(shoppingList);
}
```

</details>

---

## Exercise 6: Set Operations - Friend Finder

**Difficulty:** ⭐⭐ Medium

Use sets to find common and unique friends between people.

```dart
void main() {
  var aliceFriends = {'Bob', 'Charlie', 'Diana', 'Eve', 'Frank'};
  var bobFriends = {'Alice', 'Charlie', 'George', 'Eve', 'Hannah'};
  var charlieFriends = {'Alice', 'Bob', 'Diana', 'Ivan', 'Julia'};

  // TODO: Create functions:
  // - mutualFriends(set1, set2) - friends in both
  // - uniqueFriends(set1, set2) - friends in first but not second
  // - allFriends(sets...) - all unique friends across all sets
  // - popularFriends(sets..., minCount) - friends appearing in at least minCount sets
}
```

<details>
<summary>💡 Hint</summary>

Use `intersection()` for mutual, `difference()` for unique, `union()` for all.
For popular friends, count how many sets each friend appears in.

</details>

<details>
<summary>✅ Solution</summary>

```dart
Set<String> mutualFriends(Set<String> set1, Set<String> set2) {
  return set1.intersection(set2);
}

Set<String> uniqueFriends(Set<String> set1, Set<String> set2) {
  return set1.difference(set2);
}

Set<String> allFriends(List<Set<String>> sets) {
  return sets.reduce((all, set) => all.union(set));
}

Set<String> popularFriends(List<Set<String>> sets, int minCount) {
  var allNames = allFriends(sets);
  var popular = <String>{};

  for (var name in allNames) {
    int count = sets.where((set) => set.contains(name)).length;
    if (count >= minCount) {
      popular.add(name);
    }
  }

  return popular;
}

void main() {
  var aliceFriends = {'Bob', 'Charlie', 'Diana', 'Eve', 'Frank'};
  var bobFriends = {'Alice', 'Charlie', 'George', 'Eve', 'Hannah'};
  var charlieFriends = {'Alice', 'Bob', 'Diana', 'Ivan', 'Julia'};

  print('Alice\'s friends: $aliceFriends');
  print('Bob\'s friends: $bobFriends');
  print('Charlie\'s friends: $charlieFriends');

  print('\nMutual friends (Alice & Bob): ${mutualFriends(aliceFriends, bobFriends)}');
  print('Unique to Alice (vs Bob): ${uniqueFriends(aliceFriends, bobFriends)}');

  var allSets = [aliceFriends, bobFriends, charlieFriends];
  print('\nAll friends: ${allFriends(allSets)}');
  print('Popular (in 2+ lists): ${popularFriends(allSets, 2)}');
}
```

</details>

---

## Exercise 7: Higher-Order Functions

**Difficulty:** ⭐⭐⭐ Hard

Create a function that applies multiple transformations to a list.

```dart
void main() {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  // TODO: Create transform() that takes:
  // - A list
  // - A list of transformation functions
  // Returns the list after applying all transformations in order

  var result = transform(numbers, [
    (list) => list.where((n) => n % 2 == 0).toList(),  // Keep even
    (list) => list.map((n) => n * 2).toList(),         // Double
    (list) => list.where((n) => n > 10).toList(),      // Keep > 10
  ]);

  print(result);  // [12, 16, 20]
}
```

<details>
<summary>💡 Hint</summary>

Use `fold()` to apply each function in sequence, passing the result to the next function.

</details>

<details>
<summary>✅ Solution</summary>

```dart
List<int> transform(
  List<int> list,
  List<List<int> Function(List<int>)> transformations,
) {
  return transformations.fold(list, (current, fn) => fn(current));
}

void main() {
  var numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];

  print('Original: $numbers');

  var result = transform(numbers, [
    (list) => list.where((n) => n % 2 == 0).toList(),  // Keep even
    (list) => list.map((n) => n * 2).toList(),         // Double
    (list) => list.where((n) => n > 10).toList(),      // Keep > 10
  ]);

  print('After transformations: $result');

  // Another example
  var result2 = transform(numbers, [
    (list) => list.map((n) => n * n).toList(),        // Square
    (list) => list.where((n) => n < 50).toList(),     // Keep < 50
    (list) => [...list]..sort((a, b) => b.compareTo(a)), // Sort descending
  ]);

  print('Squares < 50 (desc): $result2');
}
```

</details>

---

## Exercise 8: Memoization

**Difficulty:** ⭐⭐⭐ Hard

Create a function that caches results of expensive calculations.

```dart
void main() {
  // TODO: Create a memoize() function that:
  // - Takes a function
  // - Returns a new function that caches results
  // - If called with same arguments, returns cached result

  // Example:
  int expensiveCalculation(int n) {
    print('Calculating for $n...');
    return n * n;
  }

  var memoized = memoize(expensiveCalculation);

  print(memoized(5));  // Prints "Calculating..." then 25
  print(memoized(5));  // Just prints 25 (cached)
  print(memoized(10)); // Prints "Calculating..." then 100
  print(memoized(5));  // Just prints 25 (still cached)
}
```

<details>
<summary>💡 Hint</summary>

Return a closure that has access to a cache Map. Check cache before calling the original function.

</details>

<details>
<summary>✅ Solution</summary>

```dart
Function memoize(int Function(int) fn) {
  var cache = <int, int>{};

  return (int n) {
    if (cache.containsKey(n)) {
      return cache[n]!;
    }
    var result = fn(n);
    cache[n] = result;
    return result;
  };
}

void main() {
  int expensiveCalculation(int n) {
    print('Calculating for $n...');
    // Simulate expensive work
    var result = 0;
    for (var i = 0; i < n; i++) {
      result += i;
    }
    return result;
  }

  var memoized = memoize(expensiveCalculation);

  print('First call with 5:');
  print('Result: ${memoized(5)}');

  print('\nSecond call with 5 (cached):');
  print('Result: ${memoized(5)}');

  print('\nFirst call with 10:');
  print('Result: ${memoized(10)}');

  print('\nThird call with 5 (still cached):');
  print('Result: ${memoized(5)}');
}
```

</details>

---

## Exercise 9: Data Pipeline

**Difficulty:** ⭐⭐⭐ Hard

Create a data processing pipeline for user data.

```dart
void main() {
  var users = [
    {'name': 'Alice', 'age': 25, 'city': 'NYC', 'active': true},
    {'name': 'Bob', 'age': 17, 'city': 'LA', 'active': false},
    {'name': 'Charlie', 'age': 30, 'city': 'NYC', 'active': true},
    {'name': 'Diana', 'age': 22, 'city': 'Chicago', 'active': true},
    {'name': 'Eve', 'age': 35, 'city': 'NYC', 'active': false},
    {'name': 'Frank', 'age': 19, 'city': 'LA', 'active': true},
  ];

  // TODO: Create functions to:
  // 1. filterAdults(users) - age >= 18
  // 2. filterActive(users) - active == true
  // 3. filterByCity(users, city)
  // 4. sortByAge(users) - ascending
  // 5. extractNames(users) - return just names
  // 6. groupByCity(users) - return Map<city, List<users>>
  // 7. getAverageAge(users)

  // Chain them together to find:
  // "Names of active adults in NYC, sorted by age"
}
```

<details>
<summary>💡 Hint</summary>

Each function takes and returns a List (except extractNames and getAverageAge).
Chain them: filterAdults -> filterActive -> filterByCity -> sortByAge -> extractNames

</details>

<details>
<summary>✅ Solution</summary>

```dart
typedef UserList = List<Map<String, dynamic>>;

UserList filterAdults(UserList users) =>
    users.where((u) => (u['age'] as int) >= 18).toList();

UserList filterActive(UserList users) =>
    users.where((u) => u['active'] == true).toList();

UserList filterByCity(UserList users, String city) =>
    users.where((u) => u['city'] == city).toList();

UserList sortByAge(UserList users) =>
    [...users]..sort((a, b) => (a['age'] as int).compareTo(b['age'] as int));

List<String> extractNames(UserList users) =>
    users.map((u) => u['name'] as String).toList();

Map<String, UserList> groupByCity(UserList users) {
  var result = <String, UserList>{};
  for (var user in users) {
    var city = user['city'] as String;
    result.putIfAbsent(city, () => []);
    result[city]!.add(user);
  }
  return result;
}

double getAverageAge(UserList users) {
  if (users.isEmpty) return 0;
  var totalAge = users.fold(0, (sum, u) => sum + (u['age'] as int));
  return totalAge / users.length;
}

void main() {
  var users = [
    {'name': 'Alice', 'age': 25, 'city': 'NYC', 'active': true},
    {'name': 'Bob', 'age': 17, 'city': 'LA', 'active': false},
    {'name': 'Charlie', 'age': 30, 'city': 'NYC', 'active': true},
    {'name': 'Diana', 'age': 22, 'city': 'Chicago', 'active': true},
    {'name': 'Eve', 'age': 35, 'city': 'NYC', 'active': false},
    {'name': 'Frank', 'age': 19, 'city': 'LA', 'active': true},
  ];

  print('All users:');
  for (var u in users) {
    print('  ${u['name']}, ${u['age']}, ${u['city']}, active: ${u['active']}');
  }

  // Pipeline: Active adults in NYC, sorted by age
  var pipeline = extractNames(
    sortByAge(
      filterByCity(
        filterActive(
          filterAdults(users)
        ),
        'NYC'
      )
    )
  );

  print('\nActive adults in NYC (by age): $pipeline');

  // Group by city
  print('\nGrouped by city:');
  var grouped = groupByCity(users);
  grouped.forEach((city, cityUsers) {
    print('  $city: ${extractNames(cityUsers)}');
  });

  // Average ages
  print('\nAverage age of all: ${getAverageAge(users).toStringAsFixed(1)}');
  print('Average age of adults: ${getAverageAge(filterAdults(users)).toStringAsFixed(1)}');
}
```

</details>

---

## Exercise 10: Mini Database

**Difficulty:** ⭐⭐⭐⭐ Expert

Create a simple in-memory database with CRUD operations.

```dart
void main() {
  // TODO: Create a Database class with:
  // - insert(table, record) - auto-generate ID
  // - find(table, id) - get by ID
  // - findAll(table) - get all records
  // - update(table, id, updates) - partial update
  // - delete(table, id)
  // - query(table, condition) - find matching records

  var db = Database();

  // Insert users
  db.insert('users', {'name': 'Alice', 'email': 'alice@email.com'});
  db.insert('users', {'name': 'Bob', 'email': 'bob@email.com'});

  // Query
  var user = db.find('users', 1);
  var allUsers = db.findAll('users');
  var bobs = db.query('users', (r) => r['name'] == 'Bob');

  // Update
  db.update('users', 1, {'email': 'alice.new@email.com'});

  // Delete
  db.delete('users', 2);
}
```

<details>
<summary>💡 Hint</summary>

Use a Map<String, List<Map>> for tables. Each record has an 'id' field auto-incremented.
Track the next ID for each table.

</details>

<details>
<summary>✅ Solution</summary>

```dart
class Database {
  final Map<String, List<Map<String, dynamic>>> _tables = {};
  final Map<String, int> _nextId = {};

  int insert(String table, Map<String, dynamic> record) {
    _tables.putIfAbsent(table, () => []);
    _nextId.putIfAbsent(table, () => 1);

    var id = _nextId[table]!;
    var newRecord = {'id': id, ...record};
    _tables[table]!.add(newRecord);
    _nextId[table] = id + 1;

    print('Inserted into $table: $newRecord');
    return id;
  }

  Map<String, dynamic>? find(String table, int id) {
    var records = _tables[table];
    if (records == null) return null;

    try {
      return records.firstWhere((r) => r['id'] == id);
    } catch (e) {
      return null;
    }
  }

  List<Map<String, dynamic>> findAll(String table) {
    return _tables[table] ?? [];
  }

  bool update(String table, int id, Map<String, dynamic> updates) {
    var record = find(table, id);
    if (record == null) return false;

    updates.forEach((key, value) {
      if (key != 'id') {  // Don't allow ID change
        record[key] = value;
      }
    });

    print('Updated $table[$id]: $record');
    return true;
  }

  bool delete(String table, int id) {
    var records = _tables[table];
    if (records == null) return false;

    var initialLength = records.length;
    records.removeWhere((r) => r['id'] == id);

    var deleted = records.length < initialLength;
    if (deleted) print('Deleted from $table: id=$id');
    return deleted;
  }

  List<Map<String, dynamic>> query(
    String table,
    bool Function(Map<String, dynamic>) condition
  ) {
    return findAll(table).where(condition).toList();
  }

  void printTable(String table) {
    print('\n=== $table ===');
    var records = findAll(table);
    if (records.isEmpty) {
      print('(empty)');
    } else {
      for (var record in records) {
        print(record);
      }
    }
  }
}

void main() {
  var db = Database();

  // Insert users
  db.insert('users', {'name': 'Alice', 'email': 'alice@email.com', 'age': 25});
  db.insert('users', {'name': 'Bob', 'email': 'bob@email.com', 'age': 30});
  db.insert('users', {'name': 'Charlie', 'email': 'charlie@email.com', 'age': 25});

  // Insert posts
  db.insert('posts', {'userId': 1, 'title': 'Hello World'});
  db.insert('posts', {'userId': 1, 'title': 'Dart is awesome'});
  db.insert('posts', {'userId': 2, 'title': 'My first post'});

  db.printTable('users');
  db.printTable('posts');

  // Find specific user
  print('\nFind user 1:');
  print(db.find('users', 1));

  // Query users age 25
  print('\nUsers age 25:');
  var age25 = db.query('users', (r) => r['age'] == 25);
  for (var u in age25) print(u);

  // Update user
  print('\nUpdating user 1...');
  db.update('users', 1, {'email': 'alice.new@email.com', 'age': 26});
  print(db.find('users', 1));

  // Delete user
  print('\nDeleting user 2...');
  db.delete('users', 2);
  db.printTable('users');

  // Query posts by user 1
  print('\nPosts by user 1:');
  var user1Posts = db.query('posts', (r) => r['userId'] == 1);
  for (var p in user1Posts) print(p);
}
```

</details>

---

## Self-Assessment

After completing these exercises, you should be able to:

- [ ] Create functions with various parameter types
- [ ] Use arrow syntax for simple functions
- [ ] Work with Lists (add, remove, search, transform)
- [ ] Work with Maps (CRUD operations, iteration)
- [ ] Work with Sets (uniqueness, set operations)
- [ ] Use higher-order functions (map, where, reduce, fold)
- [ ] Chain collection operations
- [ ] Pass functions as parameters
- [ ] Use closures for state

---

**Congratulations!** You've completed Level 3!

---

**Next Level:** `../../Level-04-OOP-Fundamentals/README.md`
