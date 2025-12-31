# Level 3 Exercises: Functions & Collections

Welcome! These exercises teach you how to organize code with functions and work with collections. Each part builds on the previous one!

**How these exercises work:**
- Each PART focuses on ONE concept
- Within each part, exercises build on each other progressively
- Try each exercise BEFORE looking at the solution
- The final exercise in each part combines everything you learned
- Once you complete all parts, you'll master functions and collections!

---

## PART 1: Basic Functions

Learn to create and use functions.

### Exercise 1.1: Your First Function ⭐

**Goal:** Create a simple function that prints a greeting.

**Your Task:** Write a function and call it.

```dart
// TODO: Create a function called greet() that prints "Hello, World!"

void main() {
  // TODO: Call the greet() function
}
```

<details>
<summary>✅ Solution</summary>

```dart
void greet() {
  print('Hello, World!');
}

void main() {
  greet();
}
```
</details>

---

### Exercise 1.2: Function with Action ⭐

**Goal:** Create multiple simple functions.

**Your Task:** Create three functions that print different messages.

```dart
// TODO: Create function sayHello() - prints "Hello!"
// TODO: Create function sayGoodbye() - prints "Goodbye!"
// TODO: Create function sayThankYou() - prints "Thank you!"

void main() {
  // TODO: Call all three functions
}
```

<details>
<summary>✅ Solution</summary>

```dart
void sayHello() {
  print('Hello!');
}

void sayGoodbye() {
  print('Goodbye!');
}

void sayThankYou() {
  print('Thank you!');
}

void main() {
  sayHello();
  sayGoodbye();
  sayThankYou();
}
```
</details>

---

### Exercise 1.3: Reusable Function ⭐

**Goal:** Call the same function multiple times.

**Your Task:** Create a function and call it 3 times.

```dart
// TODO: Create function printStar() that prints "⭐"

void main() {
  // TODO: Call printStar() three times
}
```

<details>
<summary>✅ Solution</summary>

```dart
void printStar() {
  print('⭐');
}

void main() {
  printStar();
  printStar();
  printStar();
}
```
</details>

---

### Exercise 1.4: Function Challenge ⭐⭐

**Goal:** Create a function that draws a line - NO scaffolding!

**Requirements:**
Create a function `drawLine()` that prints 20 dashes: `--------------------`

Call it 3 times to create a simple box outline.

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void drawLine() {
  print('--------------------');
}

void main() {
  drawLine();
  drawLine();
  drawLine();
}
```
</details>

---

## PART 2: Parameters

Learn to pass data to functions.

### Exercise 2.1: Single Parameter ⭐

**Goal:** Pass a name to a greeting function.

**Your Task:** Create a function that greets by name.

```dart
// TODO: Create greetPerson(String name) that prints "Hello, [name]!"

void main() {
  // TODO: Call greetPerson with "Alice"
  // TODO: Call greetPerson with "Bob"
}
```

<details>
<summary>✅ Solution</summary>

```dart
void greetPerson(String name) {
  print('Hello, $name!');
}

void main() {
  greetPerson('Alice');
  greetPerson('Bob');
}
```
</details>

---

### Exercise 2.2: Multiple Parameters ⭐

**Goal:** Pass multiple values to a function.

**Your Task:** Create a function that introduces a person.

```dart
// TODO: Create introduce(String name, int age) that prints:
// "[name] is [age] years old"

void main() {
  // TODO: Call introduce('Alice', 25)
  // TODO: Call introduce('Bob', 30)
}
```

<details>
<summary>✅ Solution</summary>

```dart
void introduce(String name, int age) {
  print('$name is $age years old');
}

void main() {
  introduce('Alice', 25);
  introduce('Bob', 30);
}
```
</details>

---

### Exercise 2.3: Optional Parameters ⭐⭐

**Goal:** Use optional parameters with default values.

**Your Task:** Create a greeting with an optional greeting word.

```dart
// TODO: Create greet(String name, [String greeting = 'Hello'])
// Print "[greeting], [name]!"

void main() {
  // TODO: Call greet('Alice') - should print "Hello, Alice!"
  // TODO: Call greet('Bob', 'Hi') - should print "Hi, Bob!"
}
```

<details>
<summary>✅ Solution</summary>

```dart
void greet(String name, [String greeting = 'Hello']) {
  print('$greeting, $name!');
}

void main() {
  greet('Alice');
  greet('Bob', 'Hi');
}
```
</details>

---

### Exercise 2.4: Named Parameters Challenge ⭐⭐

**Goal:** Use named parameters - NO scaffolding!

**Requirements:**
Create function `createProfile({required String name, required int age, String city = 'Unknown'})`

Print:
```
Name: [name]
Age: [age]
City: [city]
```

Call it twice:
1. With name and age only
2. With name, age, and city

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void createProfile({required String name, required int age, String city = 'Unknown'}) {
  print('Name: $name');
  print('Age: $age');
  print('City: $city');
  print('---');
}

void main() {
  createProfile(name: 'Alice', age: 25);
  createProfile(name: 'Bob', age: 30, city: 'New York');
}
```
</details>

---

## PART 3: Return Values

Learn to get data back from functions.

### Exercise 3.1: Simple Return ⭐

**Goal:** Return a value from a function.

**Your Task:** Create a function that returns a doubled number.

```dart
// TODO: Create int double(int number) that returns number * 2

void main() {
  // TODO: Call double(5) and print the result
  // TODO: Call double(10) and print the result
}
```

<details>
<summary>✅ Solution</summary>

```dart
int double(int number) {
  return number * 2;
}

void main() {
  print(double(5));   // 10
  print(double(10));  // 20
}
```
</details>

---

### Exercise 3.2: String Return ⭐

**Goal:** Return a formatted string.

**Your Task:** Create a function that creates a full name.

```dart
// TODO: Create String getFullName(String first, String last)
// Return "[first] [last]"

void main() {
  // TODO: Print getFullName('John', 'Doe')
  // TODO: Print getFullName('Jane', 'Smith')
}
```

<details>
<summary>✅ Solution</summary>

```dart
String getFullName(String first, String last) {
  return '$first $last';
}

void main() {
  print(getFullName('John', 'Doe'));
  print(getFullName('Jane', 'Smith'));
}
```
</details>

---

### Exercise 3.3: Boolean Return ⭐⭐

**Goal:** Return true/false from a function.

**Your Task:** Create a function that checks if someone is an adult.

```dart
// TODO: Create bool isAdult(int age) that returns age >= 18

void main() {
  // TODO: Print isAdult(20)
  // TODO: Print isAdult(15)
}
```

<details>
<summary>✅ Solution</summary>

```dart
bool isAdult(int age) {
  return age >= 18;
}

void main() {
  print(isAdult(20));  // true
  print(isAdult(15));  // false
}
```
</details>

---

### Exercise 3.4: Temperature Converter Challenge ⭐⭐

**Goal:** Create conversion functions - NO scaffolding!

**Requirements:**
1. Create `double celsiusToFahrenheit(double celsius)`
   - Formula: (celsius * 9/5) + 32
2. Create `double fahrenheitToCelsius(double fahrenheit)`
   - Formula: (fahrenheit - 32) * 5/9

Test with:
- 0°C → should be 32°F
- 100°F → should be 37.78°C

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
double celsiusToFahrenheit(double celsius) {
  return (celsius * 9/5) + 32;
}

double fahrenheitToCelsius(double fahrenheit) {
  return (fahrenheit - 32) * 5/9;
}

void main() {
  print('0°C = ${celsiusToFahrenheit(0)}°F');
  print('100°F = ${fahrenheitToCelsius(100).toStringAsFixed(2)}°C');
}
```
</details>

---

## PART 4: Lists

Learn to work with collections of items.

### Exercise 4.1: Create a List ⭐

**Goal:** Create and print a list.

**Your Task:** Create a list of fruits and print it.

```dart
void main() {
  // TODO: Create List<String> fruits with: 'apple', 'banana', 'orange'
  // TODO: Print the list
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  List<String> fruits = ['apple', 'banana', 'orange'];
  print(fruits);
}
```
</details>

---

### Exercise 4.2: Access Elements ⭐

**Goal:** Access individual list elements.

**Your Task:** Print specific fruits from the list.

```dart
void main() {
  List<String> fruits = ['apple', 'banana', 'orange'];

  // TODO: Print the first fruit
  // TODO: Print the last fruit
  // TODO: Print the length of the list
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  List<String> fruits = ['apple', 'banana', 'orange'];

  print('First: ${fruits[0]}');
  print('Last: ${fruits[fruits.length - 1]}');
  print('Length: ${fruits.length}');
}
```
</details>

---

### Exercise 4.3: Add and Remove ⭐

**Goal:** Modify a list.

**Your Task:** Add and remove items from a list.

```dart
void main() {
  List<String> fruits = ['apple', 'banana'];

  // TODO: Add 'orange' to the list
  // TODO: Print the list
  // TODO: Remove 'banana'
  // TODO: Print the list again
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  List<String> fruits = ['apple', 'banana'];

  fruits.add('orange');
  print(fruits);  // [apple, banana, orange]

  fruits.remove('banana');
  print(fruits);  // [apple, orange]
}
```
</details>

---

### Exercise 4.4: Loop Through List ⭐⭐

**Goal:** Loop through all items in a list.

**Your Task:** Print each fruit with its number.

```dart
void main() {
  List<String> fruits = ['apple', 'banana', 'orange'];

  // TODO: Use a for loop to print each fruit like:
  // 1. apple
  // 2. banana
  // 3. orange
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  List<String> fruits = ['apple', 'banana', 'orange'];

  for (int i = 0; i < fruits.length; i++) {
    print('${i + 1}. ${fruits[i]}');
  }
}
```
</details>

---

### Exercise 4.5: List Statistics Challenge ⭐⭐⭐

**Goal:** Calculate statistics from a list - NO scaffolding!

**Requirements:**
Given a list of numbers, create functions to:
1. `int sum(List<int> numbers)` - return total
2. `double average(List<int> numbers)` - return average
3. `int max(List<int> numbers)` - return largest
4. `int min(List<int> numbers)` - return smallest

Test with: `[5, 12, 3, 9, 7]`

Expected output:
```
Sum: 36
Average: 7.2
Max: 12
Min: 3
```

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
int sum(List<int> numbers) {
  int total = 0;
  for (int num in numbers) {
    total += num;
  }
  return total;
}

double average(List<int> numbers) {
  return sum(numbers) / numbers.length;
}

int max(List<int> numbers) {
  int maximum = numbers[0];
  for (int num in numbers) {
    if (num > maximum) maximum = num;
  }
  return maximum;
}

int min(List<int> numbers) {
  int minimum = numbers[0];
  for (int num in numbers) {
    if (num < minimum) minimum = num;
  }
  return minimum;
}

void main() {
  List<int> numbers = [5, 12, 3, 9, 7];

  print('Sum: ${sum(numbers)}');
  print('Average: ${average(numbers)}');
  print('Max: ${max(numbers)}');
  print('Min: ${min(numbers)}');
}
```
</details>

---

## PART 5: Maps

Learn to work with key-value pairs.

### Exercise 5.1: Create a Map ⭐

**Goal:** Create and print a map.

**Your Task:** Create a map of ages.

```dart
void main() {
  // TODO: Create Map<String, int> ages with:
  // 'Alice': 25, 'Bob': 30, 'Charlie': 28
  // TODO: Print the map
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  Map<String, int> ages = {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 28,
  };
  print(ages);
}
```
</details>

---

### Exercise 5.2: Access Values ⭐

**Goal:** Get values from a map.

**Your Task:** Access specific ages.

```dart
void main() {
  Map<String, int> ages = {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 28,
  };

  // TODO: Print Alice's age
  // TODO: Print Bob's age
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  Map<String, int> ages = {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 28,
  };

  print('Alice is ${ages['Alice']} years old');
  print('Bob is ${ages['Bob']} years old');
}
```
</details>

---

### Exercise 5.3: Add and Update ⭐

**Goal:** Modify a map.

**Your Task:** Add new entries and update existing ones.

```dart
void main() {
  Map<String, int> ages = {'Alice': 25};

  // TODO: Add 'Bob' with age 30
  // TODO: Update Alice's age to 26
  // TODO: Print the map
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  Map<String, int> ages = {'Alice': 25};

  ages['Bob'] = 30;
  ages['Alice'] = 26;

  print(ages);  // {Alice: 26, Bob: 30}
}
```
</details>

---

### Exercise 5.4: Loop Through Map ⭐⭐

**Goal:** Loop through all key-value pairs.

**Your Task:** Print each person and their age.

```dart
void main() {
  Map<String, int> ages = {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 28,
  };

  // TODO: Loop through and print "[name] is [age] years old"
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  Map<String, int> ages = {
    'Alice': 25,
    'Bob': 30,
    'Charlie': 28,
  };

  ages.forEach((name, age) {
    print('$name is $age years old');
  });
}
```
</details>

---

### Exercise 5.5: Shopping Cart Challenge ⭐⭐⭐

**Goal:** Build a shopping cart system - NO scaffolding!

**Requirements:**
Create a map representing a shopping cart: `Map<String, double>` (item → price)

Create functions:
1. `void addItem(Map cart, String item, double price)` - add item to cart
2. `double getTotal(Map cart)` - return total price
3. `void printReceipt(Map cart)` - print all items and total

Test by adding 3 items and printing receipt.

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void addItem(Map<String, double> cart, String item, double price) {
  cart[item] = price;
}

double getTotal(Map<String, double> cart) {
  double total = 0;
  cart.forEach((item, price) {
    total += price;
  });
  return total;
}

void printReceipt(Map<String, double> cart) {
  print('===== RECEIPT =====');
  cart.forEach((item, price) {
    print('$item: \$${price.toStringAsFixed(2)}');
  });
  print('-------------------');
  print('TOTAL: \$${getTotal(cart).toStringAsFixed(2)}');
  print('===================');
}

void main() {
  Map<String, double> cart = {};

  addItem(cart, 'Apple', 1.99);
  addItem(cart, 'Bread', 2.50);
  addItem(cart, 'Milk', 3.99);

  printReceipt(cart);
}
```
</details>

---

## PART 6: Sets

Learn to work with unique collections.

### Exercise 6.1: Create a Set ⭐

**Goal:** Create a set of unique items.

**Your Task:** Create a set of colors.

```dart
void main() {
  // TODO: Create Set<String> colors with: 'red', 'blue', 'green'
  // TODO: Try adding 'red' again
  // TODO: Print the set (notice 'red' only appears once)
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  Set<String> colors = {'red', 'blue', 'green'};
  colors.add('red');  // Won't duplicate
  print(colors);  // {red, blue, green}
}
```
</details>

---

### Exercise 6.2: Set Operations ⭐⭐

**Goal:** Use set operations.

**Your Task:** Find common elements between two sets.

```dart
void main() {
  Set<int> set1 = {1, 2, 3, 4, 5};
  Set<int> set2 = {4, 5, 6, 7, 8};

  // TODO: Find intersection (common elements)
  // TODO: Find union (all elements)
  // TODO: Find difference (in set1 but not set2)
}
```

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  Set<int> set1 = {1, 2, 3, 4, 5};
  Set<int> set2 = {4, 5, 6, 7, 8};

  print('Intersection: ${set1.intersection(set2)}');  // {4, 5}
  print('Union: ${set1.union(set2)}');  // {1, 2, 3, 4, 5, 6, 7, 8}
  print('Difference: ${set1.difference(set2)}');  // {1, 2, 3}
}
```
</details>

---

### Exercise 6.3: Friend Finder Challenge ⭐⭐⭐

**Goal:** Find mutual friends - NO scaffolding!

**Requirements:**
Create two sets representing friends:
- Alice's friends: {'Bob', 'Charlie', 'David', 'Eve'}
- Bob's friends: {'Alice', 'Charlie', 'Frank', 'Grace'}

Find and print:
1. Mutual friends (people both know)
2. All unique people
3. Friends Alice has that Bob doesn't

Try this on your own!

<details>
<summary>✅ Solution</summary>

```dart
void main() {
  Set<String> aliceFriends = {'Bob', 'Charlie', 'David', 'Eve'};
  Set<String> bobFriends = {'Alice', 'Charlie', 'Frank', 'Grace'};

  Set<String> mutualFriends = aliceFriends.intersection(bobFriends);
  Set<String> allPeople = aliceFriends.union(bobFriends);
  Set<String> aliceOnly = aliceFriends.difference(bobFriends);

  print('Mutual friends: $mutualFriends');
  print('All people: $allPeople');
  print('Alice\'s unique friends: $aliceOnly');
}
```
</details>

---

## FINAL PROJECT: Contact Manager ⭐⭐⭐

**Goal:** Build a complete contact management system!

**Your Task:** Create a contact manager - NO scaffolding!

### Requirements:

**Data Structure:**
Use a `Map<String, Map<String, String>>` where:
- Key: contact name
- Value: map with 'phone' and 'email'

**Functions to Create:**
1. `void addContact(Map contacts, String name, String phone, String email)`
2. `void displayContact(Map contacts, String name)`
3. `void displayAllContacts(Map contacts)`
4. `List<String> searchByPhone(Map contacts, String phone)`
5. `void deleteContact(Map contacts, String name)`

**Test Your System:**
- Add 3 contacts
- Display all contacts
- Search for a contact by phone
- Delete a contact
- Display all again to confirm deletion

**Example:**
```dart
Contact: Alice
Phone: 555-1234
Email: alice@email.com
---
```

**Build this completely on your own!**

<details>
<summary>✅ Solution</summary>

```dart
void addContact(Map<String, Map<String, String>> contacts, String name, String phone, String email) {
  contacts[name] = {
    'phone': phone,
    'email': email,
  };
}

void displayContact(Map<String, Map<String, String>> contacts, String name) {
  if (contacts.containsKey(name)) {
    print('Contact: $name');
    print('Phone: ${contacts[name]!['phone']}');
    print('Email: ${contacts[name]!['email']}');
    print('---');
  } else {
    print('Contact not found: $name');
  }
}

void displayAllContacts(Map<String, Map<String, String>> contacts) {
  print('===== ALL CONTACTS =====');
  contacts.forEach((name, info) {
    print('Contact: $name');
    print('Phone: ${info['phone']}');
    print('Email: ${info['email']}');
    print('---');
  });
}

List<String> searchByPhone(Map<String, Map<String, String>> contacts, String phone) {
  List<String> results = [];
  contacts.forEach((name, info) {
    if (info['phone'] == phone) {
      results.add(name);
    }
  });
  return results;
}

void deleteContact(Map<String, Map<String, String>> contacts, String name) {
  if (contacts.remove(name) != null) {
    print('Deleted: $name');
  } else {
    print('Contact not found: $name');
  }
}

void main() {
  Map<String, Map<String, String>> contacts = {};

  // Add contacts
  addContact(contacts, 'Alice', '555-1234', 'alice@email.com');
  addContact(contacts, 'Bob', '555-5678', 'bob@email.com');
  addContact(contacts, 'Charlie', '555-9012', 'charlie@email.com');

  // Display all
  displayAllContacts(contacts);

  // Search by phone
  print('Search for 555-1234: ${searchByPhone(contacts, '555-1234')}');

  // Delete contact
  deleteContact(contacts, 'Bob');

  // Display all again
  displayAllContacts(contacts);
}
```
</details>

---

## Submission Checklist

Before moving to Level 4, make sure you can:

- [ ] Create and call functions
- [ ] Use parameters (positional, optional, named)
- [ ] Return values from functions
- [ ] Create and modify lists
- [ ] Loop through lists
- [ ] Create and modify maps
- [ ] Loop through maps
- [ ] Use sets and set operations
- [ ] Choose the right collection type for a problem
- [ ] Combine functions and collections

---

## Bonus Challenge: Word Counter ⭐⭐⭐

Build a word frequency counter:
- Given a sentence, count how many times each word appears
- Use a Map to store word counts
- Ignore case (convert to lowercase)
- Print words and their counts

Example Input: `"Hello world hello Dart world"`
Expected Output:
```
hello: 2
world: 2
dart: 1
```

<details>
<summary>✅ Solution</summary>

```dart
Map<String, int> countWords(String sentence) {
  Map<String, int> counts = {};
  List<String> words = sentence.toLowerCase().split(' ');

  for (String word in words) {
    counts[word] = (counts[word] ?? 0) + 1;
  }

  return counts;
}

void main() {
  String sentence = 'Hello world hello Dart world';
  Map<String, int> wordCounts = countWords(sentence);

  wordCounts.forEach((word, count) {
    print('$word: $count');
  });
}
```
</details>

---

**Congratulations!** You've completed Level 3!

You now understand functions and collections. Time to learn object-oriented programming!

---

**Continue to:** `../../Level-04-OOP-Basics/README.md`
