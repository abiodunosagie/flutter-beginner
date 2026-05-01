# Maps: Looking Up Values By Name

## Why This Topic Exists

A list is great when you have a row of items and you only care about their order. But what if you have **named** data?

- A user profile: name, age, email, city.
- A product: id, title, price, in-stock.
- A score sheet: each subject gets a score.

You could try to use a list, but that would be weird. Index 0 is the name, index 1 is the age, index 2 is the email? Nobody can read that.

A **Map** solves this. It stores data as **key-value pairs**. You look up a value by its key.

```dart
Map<String, int> scores = {
  'Math': 95,
  'English': 87,
  'Science': 92,
};

print(scores['Math']);     // 95
```

You ask for the Math score and you get 95. Clean.

---

## The Mental Model

A map is a **phone book**.

- Each entry has a **name** (the key) and a **number** (the value).
- You look up by name, not by position.
- Each name is unique. You cannot have two entries with the same name.

That is the entire idea. The rest is syntax.

---

## Creating A Map

The shortest form:

```dart
Map<String, int> ages = {
  'Ada': 25,
  'Bola': 30,
  'Chidi': 28,
};
```

Read it as: "a map where keys are strings and values are ints."

`<String, int>` is the type. The first part is the key type, the second is the value type. They can be anything:

```dart
Map<int, String> idToName = {1: 'Ada', 2: 'Bola'};
Map<String, double> prices = {'shirt': 19.99, 'cap': 9.50};
```

An empty map:

```dart
Map<String, String> settings = {};
var scores = <String, int>{};
```

---

## Reading A Value By Key

Use square brackets, but with the key, not an index:

```dart
var ages = {'Ada': 25, 'Bola': 30};

print(ages['Ada']);     // 25
print(ages['Bola']);    // 30
print(ages['Zara']);    // null
```

Notice the last line. **Looking up a key that does not exist returns `null`**, not an error. This is the most important thing to remember about maps.

That means the result type of `ages[...]` is always nullable. If you want to use it as a real value, you must handle the null case:

```dart
int? age = ages['Ada'];

if (age != null) {
  print('Ada is $age');
}

// Or with a default
print(ages['Zara'] ?? 0);     // 0
```

---

## Adding And Updating

Both use the same square-bracket syntax:

```dart
var ages = {'Ada': 25};

// Add a new key
ages['Bola'] = 30;

// Update an existing key
ages['Ada'] = 26;

print(ages);    // {Ada: 26, Bola: 30}
```

Whether the key exists or not, `map[key] = value` does the right thing. New key, it gets added. Existing key, the value gets replaced.

---

## Removing Items

```dart
var ages = {'Ada': 25, 'Bola': 30, 'Chidi': 28};

ages.remove('Bola');
print(ages);    // {Ada: 25, Chidi: 28}

ages.clear();
print(ages);    // {}
```

`remove` returns the value that was removed, or null if the key was not there.

---

## Checking If A Key Or Value Exists

```dart
var ages = {'Ada': 25, 'Bola': 30};

print(ages.containsKey('Ada'));      // true
print(ages.containsKey('Zara'));     // false

print(ages.containsValue(25));       // true
print(ages.containsValue(99));       // false
```

`containsKey` is what you reach for most. Always use it before reading a key when you want to be sure the value exists.

---

## Useful Map Properties

```dart
var ages = {'Ada': 25, 'Bola': 30, 'Chidi': 28};

print(ages.length);       // 3
print(ages.isEmpty);      // false
print(ages.isNotEmpty);   // true

print(ages.keys);         // (Ada, Bola, Chidi)
print(ages.values);       // (25, 30, 28)
```

`keys` and `values` give you iterables of just the keys or just the values. You can convert them to lists with `.toList()`.

---

## Looping Through A Map

There are two common shapes.

### `forEach` with key and value

```dart
var ages = {'Ada': 25, 'Bola': 30};

ages.forEach((name, age) {
  print('$name is $age');
});
```

### `for-in` over entries

```dart
for (var entry in ages.entries) {
  print('${entry.key}: ${entry.value}');
}
```

`entries` gives you a list of `MapEntry` objects. Each entry has a `.key` and a `.value`.

If you only need the keys or only the values:

```dart
for (var name in ages.keys) {
  print(name);
}

for (var age in ages.values) {
  print(age);
}
```

---

## Maps Inside Maps (Real-World Data)

In real apps, your data is often nested. A user might be:

```dart
Map<String, dynamic> user = {
  'name': 'Ada',
  'age': 25,
  'address': {
    'city': 'Lagos',
    'country': 'Nigeria',
  },
  'hobbies': ['reading', 'coding'],
};

print(user['name']);                  // Ada
print(user['address']['city']);       // Lagos
print(user['hobbies'][0]);            // reading
```

The type `dynamic` means "could be anything". This is what you get when JSON arrives from an API. We will cover this fully in Level 8.

---

## Why This Matters In Flutter

Every API response in your future app will arrive as a `Map<String, dynamic>` (the JSON shape). Reading user info, product details, weather data, all of it is map lookup.

Tiny preview, do not run yet:

```dart
Map<String, dynamic> response = {
  'temperature': 28,
  'condition': 'Sunny',
};

return Text('It is ${response['temperature']}° and ${response['condition']}');
```

That is what every weather app, every news app, every social app does. Maps are the gateway between the network and your UI.

---

## Common Mistakes

### 1. Treating a map like a list

```dart
var m = {'Ada': 25};
print(m[0]);     // returns null, NOT the first entry
```

Maps are looked up by key, not by position. `m[0]` is "the value at key 0", which probably does not exist.

### 2. Forgetting that lookups can be null

```dart
var m = {'Ada': 25};
int age = m['Bola'];      // ERROR: m['Bola'] is int? not int
```

The return type is always nullable. Use `??` to give a default, or check for null first.

### 3. Adding duplicate keys

```dart
var m = {'a': 1, 'a': 2};    // a warning, only the last wins
print(m);                    // {a: 2}
```

Each key is unique. Re-adding a key replaces the value.

### 4. Confusing keys with values

`containsKey` checks the keys. `containsValue` checks the values. Use the right one for what you need.

---

## Recap In One Minute

- A `Map` stores key-value pairs.
- Look up with `map[key]`. Returns `null` if the key is missing.
- Add or update with `map[key] = value`.
- Remove with `map.remove(key)`.
- Check existence with `containsKey` or `containsValue`.
- Loop with `forEach`, `entries`, `keys`, or `values`.
- API responses arrive as maps in Flutter.

---

## Quick Quiz

**Q1.** What does this print?
```dart
var m = {'a': 1, 'b': 2};
print(m['c']);
```

<details>
<summary>Answer</summary>
`null`. The key 'c' is not in the map.
</details>

**Q2.** Add a key 'c' with value 3, then print the map.

<details>
<summary>Answer</summary>

```dart
m['c'] = 3;
print(m);    // {a: 1, b: 2, c: 3}
```
</details>

**Q3.** What is wrong here?
```dart
Map<String, int> scores = {'math': 95};
int x = scores['english'];
```

<details>
<summary>Answer</summary>
`scores['english']` returns `int?`, not `int`. The key may not exist. Either change the type to `int? x` or use `int x = scores['english'] ?? 0;`.
</details>

**Q4.** How do you check if a map has a particular key?

<details>
<summary>Answer</summary>
`map.containsKey('the-key')`. Returns true or false.
</details>

---

## Assignment

### Problem 1: Predict the output

What does this print?

```dart
void main() {
  Map<String, int> ages = {'Ada': 25, 'Bola': 30};
  ages['Chidi'] = 28;
  ages['Ada'] = 26;
  ages.remove('Bola');

  print(ages);
  print(ages['Ada']);
  print(ages['Bola']);
  print(ages.containsKey('Chidi'));
  print(ages.length);
}
```

### Problem 2: Word frequency counter

Write a function `Map<String, int> wordCount(List<String> words)` that takes a list of words and returns a map from each unique word to the number of times it appears.

Test on `['cat', 'dog', 'cat', 'bird', 'dog', 'cat']`. Expected:
```
{cat: 3, dog: 2, bird: 1}
```

The trick: for each word, you must check if it is already a key in the map. If yes, increment. If no, set to 1.

### Problem 3: Safe lookup

Given:

```dart
Map<String, int> stockLevels = {
  'shirt': 25,
  'shoe': 0,
  'cap': 12,
};
```

Write a function `String stockMessage(String product)` that returns:

- `'In stock: 25'` if there are 5 or more.
- `'Low stock: 3'` if there are 1 to 4.
- `'Out of stock'` if there are exactly 0.
- `'Product not found'` if the product is not in the map.

Test with: `'shirt'`, `'cap'`, `'shoe'`, `'phone'`.

### Problem 4: Merge two maps with a rule

Write a function `Map<String, int> mergeStocks(Map<String, int> a, Map<String, int> b)` that returns a new map with all the keys from both. If the same key appears in both, the result should hold the **larger** of the two values.

Example:
```dart
mergeStocks(
  {'shirt': 5, 'cap': 10},
  {'shirt': 8, 'shoe': 3},
);
// Expected: {shirt: 8, cap: 10, shoe: 3}
```

Do not modify the input maps.

### Problem 5: Mini grade book

Build a small program with these functions, all working on a `Map<String, List<int>>` where the key is a student name and the value is a list of their scores.

- `void addScore(Map<String, List<int>> book, String student, int score)` adds one score to that student's list. If the student is not in the map yet, create an entry.
- `double averageOf(Map<String, List<int>> book, String student)` returns the average score for one student. Return -1 if the student does not exist or has no scores.
- `String topStudent(Map<String, List<int>> book)` returns the name of the student with the highest average. Tiebreaks go to whichever student appears first in the iteration.

Test with three students adding several scores each.

---

## Assignment Answers

### Problem 1: Predict the output

```
{Ada: 26, Chidi: 28}
26
null
true
2
```

Trace:

| Step | Action | Map after |
|------|--------|-----------|
| Start | --- | {Ada: 25, Bola: 30} |
| 1 | ages['Chidi'] = 28 | {Ada: 25, Bola: 30, Chidi: 28} |
| 2 | ages['Ada'] = 26 | {Ada: 26, Bola: 30, Chidi: 28} |
| 3 | ages.remove('Bola') | {Ada: 26, Chidi: 28} |

Then:

- `print(ages)` shows the final map.
- `ages['Ada']` is 26 (the value we just updated).
- `ages['Bola']` is null (the key was removed).
- `containsKey('Chidi')` is true.
- `length` is 2 because we have two entries left.

This problem reinforces three behaviours: assignment can both add and update, remove returns the value (we ignored it here), and lookup returns null if missing.

### Problem 2: Word frequency counter

```dart
Map<String, int> wordCount(List<String> words) {
  Map<String, int> counts = {};

  for (String w in words) {
    if (counts.containsKey(w)) {
      counts[w] = counts[w]! + 1;
    } else {
      counts[w] = 1;
    }
  }

  return counts;
}
```

How the logic works:

1. **Start with an empty map.**
2. **For each word, check if it is already a key.** If yes, increment its count. If no, set its count to 1.
3. **The `!` in `counts[w]!`** tells Dart "I know this is not null right now, trust me". This is safe because we just confirmed the key exists in the line above.

Trace on `['cat', 'dog', 'cat', 'bird', 'dog', 'cat']`:

| Word | Key exists? | Action | Map after |
|------|-------------|--------|-----------|
| cat | no | set to 1 | {cat: 1} |
| dog | no | set to 1 | {cat: 1, dog: 1} |
| cat | yes (1) | set to 2 | {cat: 2, dog: 1} |
| bird | no | set to 1 | {cat: 2, dog: 1, bird: 1} |
| dog | yes (1) | set to 2 | {cat: 2, dog: 2, bird: 1} |
| cat | yes (2) | set to 3 | {cat: 3, dog: 2, bird: 1} |

A more compact alternative using the null-aware operator:

```dart
counts[w] = (counts[w] ?? 0) + 1;
```

This says "take the current value or 0 if missing, add 1, store back". One line replaces the `if-else`. Both versions are equally correct.

### Problem 3: Safe lookup

```dart
String stockMessage(String product) {
  Map<String, int> stockLevels = {
    'shirt': 25,
    'shoe': 0,
    'cap': 12,
  };

  if (!stockLevels.containsKey(product)) {
    return 'Product not found';
  }

  int level = stockLevels[product]!;

  if (level == 0) return 'Out of stock';
  if (level < 5) return 'Low stock: $level';
  return 'In stock: $level';
}
```

How the design handles each case:

1. **First, check if the product exists.** If not, return early. This is the guard pattern we have used before.
2. **Then read the level** safely. The `!` is okay because we just confirmed the key exists.
3. **Check the level in order from most specific to least.** Zero first, then 1-4, then 5+.

Test results:

- `stockMessage('shirt')` returns `'In stock: 25'`.
- `stockMessage('cap')` returns `'In stock: 12'`.
- `stockMessage('shoe')` returns `'Out of stock'`.
- `stockMessage('phone')` returns `'Product not found'`.

The order of checks matters. If you put `level >= 5` first, you would never reach the "out of stock" branch for level 0.

### Problem 4: Merge two maps with a rule

```dart
Map<String, int> mergeStocks(Map<String, int> a, Map<String, int> b) {
  Map<String, int> result = {};

  // Copy everything from a
  for (var entry in a.entries) {
    result[entry.key] = entry.value;
  }

  // Now consider b
  for (var entry in b.entries) {
    if (result.containsKey(entry.key)) {
      // Both maps have this key, keep the larger value
      if (entry.value > result[entry.key]!) {
        result[entry.key] = entry.value;
      }
    } else {
      // Only b has this key
      result[entry.key] = entry.value;
    }
  }

  return result;
}
```

How the algorithm works:

1. **Build a new map.** We do not touch the input maps. This is important when callers pass shared references.
2. **First pass: copy everything from `a`.** The result now has every key from `a` with its value.
3. **Second pass: walk every entry of `b`.** For each one:
   - If the result already has this key (it came from a), compare the two values and keep the larger.
   - If the result does not have this key, just add it.

Trace on the example:

- After first pass: `{shirt: 5, cap: 10}` (from a).
- Now process b:
  - `shirt: 8`. Result has shirt with 5. 8 > 5, update. Result: `{shirt: 8, cap: 10}`.
  - `shoe: 3`. Result does not have shoe. Add. Result: `{shirt: 8, cap: 10, shoe: 3}`.

Final result matches the expected output.

A more compact version using `forEach`:

```dart
Map<String, int> mergeStocks(Map<String, int> a, Map<String, int> b) {
  final result = {...a};
  b.forEach((k, v) {
    final existing = result[k];
    if (existing == null || v > existing) {
      result[k] = v;
    }
  });
  return result;
}
```

The `{...a}` spreads `a` into a new map. Modern Dart supports this. Cleaner than the manual loop, but the manual version is easier to debug when learning.

### Problem 5: Mini grade book

```dart
void addScore(Map<String, List<int>> book, String student, int score) {
  if (!book.containsKey(student)) {
    book[student] = [];
  }
  book[student]!.add(score);
}

double averageOf(Map<String, List<int>> book, String student) {
  if (!book.containsKey(student)) return -1;

  List<int> scores = book[student]!;
  if (scores.isEmpty) return -1;

  int sum = 0;
  for (int s in scores) sum += s;
  return sum / scores.length;
}

String topStudent(Map<String, List<int>> book) {
  String? best;
  double bestAvg = -1;

  for (var entry in book.entries) {
    double avg = averageOf(book, entry.key);
    if (avg > bestAvg) {
      bestAvg = avg;
      best = entry.key;
    }
  }

  return best ?? 'No students';
}

void main() {
  Map<String, List<int>> book = {};

  addScore(book, 'Ada', 80);
  addScore(book, 'Ada', 90);
  addScore(book, 'Bola', 70);
  addScore(book, 'Bola', 75);
  addScore(book, 'Bola', 80);
  addScore(book, 'Chidi', 100);

  print('Ada avg: ${averageOf(book, 'Ada')}');     // 85.0
  print('Bola avg: ${averageOf(book, 'Bola')}');   // 75.0
  print('Chidi avg: ${averageOf(book, 'Chidi')}'); // 100.0
  print('Zara avg: ${averageOf(book, 'Zara')}');   // -1.0
  print('Top: ${topStudent(book)}');               // Chidi
}
```

How each function was designed:

1. **`addScore` first ensures the student has an entry.** If not, create an empty list. Then append the score. The `!` is safe because we either created the list or it was already there.
2. **`averageOf` has two failure cases.** Student missing returns -1. Student exists but has no scores returns -1. Both cases use early return.
3. **`topStudent` walks every entry,** computing each student's average and tracking the highest seen so far. Tiebreak goes to whichever student appears first because we only update on strict `>`, not `>=`.

The pattern "if key missing, initialise; then append" is common. You can simplify with `putIfAbsent`:

```dart
void addScore(Map<String, List<int>> book, String student, int score) {
  book.putIfAbsent(student, () => []).add(score);
}
```

`putIfAbsent` returns the existing list if the key was there, or runs the function to create a new one. Either way, you get a list to append to. Cleaner once you are comfortable with maps.

---

**Next:** `06-Sets.md` for the third and last collection type, used when uniqueness matters.
