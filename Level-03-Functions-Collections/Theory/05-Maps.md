# Maps: Looking Up A Value By Its Name

## The Big Idea In One Sentence

> A **Map** stores pairs of **a name and a value**, so you can look up the value by its name.

That is it. The rest of this page just shows you how to make one and use it.

---

## Why Maps Exist

A list is great when your values are in a row and you only care about their order.

But what if you have **named** info? Like a person's profile:

- name: Ada
- age: 25
- email: ada@example.com
- city: Lagos

You could use a list, but that would be weird. Index 0 is the name, index 1 is the age? Nobody can read that.

A **Map** is the right tool. It stores **pairs**: a name (called the **key**) and a value. You look up by name.

```dart
Map<String, int> scores = {
  'Math': 95,
  'English': 87,
  'Science': 92,
};

print(scores['Math']);   // 95
```

You ask for the Math score. You get 95. Clean.

---

## A Picture To Hold In Your Head

A map is like a **phone book**.

- Each entry has a **name** (the key) and a **number** (the value).
- You look up by **name**, not by position.
- Each name is **unique**. You cannot have two entries for "Ada".

```
Phone book:
  Ada    →  555-1234
  Bola   →  555-5678
  Chidi  →  555-9999
```

You ask "what is Ada's number?" and you get back her number. That is what a map does.

---

## Two Words You Need

- **Key**: the name you look up by (like `'Ada'`).
- **Value**: what you get back (like `555-1234`).

A map stores **key-value pairs**. Each key is unique. Each key points to one value.

---

## Making A Map

Quick way:

```dart
Map<String, int> ages = {
  'Ada': 25,
  'Bola': 30,
  'Chidi': 28,
};
```

Read it as: "a map where keys are strings and values are ints."

The `<String, int>` part has two pieces:

- The first part (`String`) is the **key type**.
- The second part (`int`) is the **value type**.

They can be anything:

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

Use square brackets, but with the **key** instead of an index.

```dart
var ages = {'Ada': 25, 'Bola': 30};

print(ages['Ada']);    // 25
print(ages['Bola']);   // 30
print(ages['Zara']);   // null
```

Look at the last line. **Looking up a key that does not exist gives back `null`**, not an error. This is the most important thing to remember about maps.

That means the result of `ages[...]` is always **nullable** (it could be null). To use it as a real value, you must handle the null case.

```dart
int? age = ages['Ada'];

if (age != null) {
  print('Ada is $age');
}

// Or use ?? to give a default
print(ages['Zara'] ?? 0);   // 0
```

---

## Adding Or Changing A Value

Both use the same square-bracket syntax.

```dart
var ages = {'Ada': 25};

// Add a new key
ages['Bola'] = 30;

// Change an existing key
ages['Ada'] = 26;

print(ages);   // {Ada: 26, Bola: 30}
```

Whether the key exists or not, `map[key] = value` does the right thing. New key gets added. Existing key gets updated.

---

## Removing A Key

```dart
var ages = {'Ada': 25, 'Bola': 30, 'Chidi': 28};

ages.remove('Bola');
print(ages);   // {Ada: 25, Chidi: 28}

ages.clear();
print(ages);   // {}
```

`remove` gives back the value that was removed, or null if the key was not there.

---

## Checking If A Key Or Value Exists

```dart
var ages = {'Ada': 25, 'Bola': 30};

print(ages.containsKey('Ada'));     // true
print(ages.containsKey('Zara'));    // false

print(ages.containsValue(25));      // true
print(ages.containsValue(99));      // false
```

`containsKey` is the one you will use most. Always check before reading if you want to be sure.

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

`keys` gives you all the keys. `values` gives you all the values. Both can be turned into lists with `.toList()`.

---

## Looping Through A Map

Two common ways.

### Way 1: `forEach` with key and value

```dart
var ages = {'Ada': 25, 'Bola': 30};

ages.forEach((name, age) {
  print('$name is $age');
});
```

The function gets two values: first the key, then the value.

### Way 2: `for-in` over `entries`

```dart
for (var entry in ages.entries) {
  print('${entry.key}: ${entry.value}');
}
```

`entries` gives you each pair as a `MapEntry` object with `.key` and `.value`.

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

print(user['name']);              // Ada
print(user['address']['city']);   // Lagos
print(user['hobbies'][0]);        // reading
```

The type `dynamic` means "could be anything." This is what you get when JSON data arrives from an API. Level 8 covers this fully.

---

## Why This Matters In Flutter

Every API response in your future Flutter app will arrive as a `Map<String, dynamic>` (the JSON shape). Reading user info, product details, weather data, all of it is map lookup.

Tiny preview, do not run yet:

```dart
Map<String, dynamic> response = {
  'temperature': 28,
  'condition': 'Sunny',
};

return Text('It is ${response['temperature']}° and ${response['condition']}');
```

This is what every weather app, every news app, every social app does. Maps are the bridge between the network and your UI.

---

## The Top Mistakes Beginners Make

### Mistake 1: Treating a map like a list

```dart
var m = {'Ada': 25};
print(m[0]);    // null, NOT the first entry
```

Maps are looked up by key, not by position. `m[0]` means "the value at key 0", which probably does not exist.

### Mistake 2: Forgetting that lookups can be null

```dart
var m = {'Ada': 25};
int age = m['Bola'];   // ERROR: m['Bola'] is int? not int
```

The result is always nullable. Use `??` to give a default, or check for null first.

### Mistake 3: Adding the same key twice

```dart
var m = {'a': 1, 'a': 2};   // warning, only the last wins
print(m);                    // {a: 2}
```

Each key is unique. Re-adding a key replaces the value.

### Mistake 4: Confusing keys with values

`containsKey` checks the **keys**. `containsValue` checks the **values**. Use the right one for what you need.

---

## One-Minute Recap

- A `Map` stores pairs of `key: value`.
- Look up with `map[key]`. Returns `null` if the key is missing.
- Add or change with `map[key] = value`.
- Remove with `map.remove(key)`.
- Check with `containsKey` or `containsValue`.
- Loop with `forEach`, `entries`, `keys`, or `values`.
- API data arrives as maps in Flutter.

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
print(m);   // {a: 1, b: 2, c: 3}
```
</details>

**Q3.** What is wrong here?

```dart
Map<String, int> scores = {'math': 95};
int x = scores['english'];
```

<details>
<summary>Answer</summary>
`scores['english']` gives back `int?`, not `int`. The key may not exist. Either use `int? x` or `int x = scores['english'] ?? 0;`.
</details>

**Q4.** How do you check if a map has a particular key?

<details>
<summary>Answer</summary>
`map.containsKey('the-key')`. Gives back true or false.
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

Write a function `Map<String, int> wordCount(List<String> words)` that gives back a map. Each key is a unique word. Each value is the number of times it appeared.

Test on `['cat', 'dog', 'cat', 'bird', 'dog', 'cat']`. Expected:
```
{cat: 3, dog: 2, bird: 1}
```

The trick: for each word, check if it is already a key. If yes, add 1 to the count. If no, set the count to 1.

### Problem 3: Safe lookup

Given:

```dart
Map<String, int> stockLevels = {
  'shirt': 25,
  'shoe': 0,
  'cap': 12,
};
```

Write a function `String stockMessage(String product)` that gives back:

- `'In stock: 25'` if there are 5 or more.
- `'Low stock: 3'` if there are 1 to 4.
- `'Out of stock'` if there are exactly 0.
- `'Product not found'` if the product is not in the map.

Test with: `'shirt'`, `'cap'`, `'shoe'`, `'phone'`.

### Problem 4: Merge two maps with a rule

Write a function `Map<String, int> mergeStocks(Map<String, int> a, Map<String, int> b)` that gives back a new map with all the keys from both. If the same key appears in both, keep the **larger** value.

Example:
```dart
mergeStocks(
  {'shirt': 5, 'cap': 10},
  {'shirt': 8, 'shoe': 3},
);
// Expected: {shirt: 8, cap: 10, shoe: 3}
```

Do not change the input maps.

### Problem 5: Mini grade book

Build a small program with these functions, all working on a `Map<String, List<int>>` where the key is a student name and the value is a list of their scores.

- `void addScore(Map<String, List<int>> book, String student, int score)` adds one score. If the student is not in the map yet, create an entry.
- `double averageOf(Map<String, List<int>> book, String student)` gives back the average for one student. Return -1 if the student does not exist or has no scores.
- `String topStudent(Map<String, List<int>> book)` gives back the name of the student with the highest average.

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
- `ages['Ada']` is 26.
- `ages['Bola']` is null (key removed).
- `containsKey('Chidi')` is true.
- `length` is 2.

This problem reinforces three behaviours: assignment can both add and update, remove returns the value, and lookup gives null for missing keys.

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

How it works:

1. **Start with an empty map.**
2. **For each word, check if it is already a key.** If yes, add 1. If no, set to 1.
3. **The `!` in `counts[w]!`** tells Dart "I know this is not null right now." Safe here, because we just checked.

Trace on `['cat', 'dog', 'cat', 'bird', 'dog', 'cat']`:

| Word | Key exists? | Action | Map after |
|------|-------------|--------|-----------|
| cat | no | set to 1 | {cat: 1} |
| dog | no | set to 1 | {cat: 1, dog: 1} |
| cat | yes (1) | set to 2 | {cat: 2, dog: 1} |
| bird | no | set to 1 | {cat: 2, dog: 1, bird: 1} |
| dog | yes (1) | set to 2 | {cat: 2, dog: 2, bird: 1} |
| cat | yes (2) | set to 3 | {cat: 3, dog: 2, bird: 1} |

A shorter version with `??`:

```dart
counts[w] = (counts[w] ?? 0) + 1;
```

This says "take the current value, or 0 if missing, add 1, store back." One line replaces the if-else.

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

How it handles each case:

1. **First, check if the product exists.** If not, return early.
2. **Then read the level safely** (the `!` is okay because we just checked).
3. **Check most specific first.** Zero, then 1-4, then 5+.

Test results:

- `stockMessage('shirt')` → `'In stock: 25'`.
- `stockMessage('cap')` → `'In stock: 12'`.
- `stockMessage('shoe')` → `'Out of stock'`.
- `stockMessage('phone')` → `'Product not found'`.

### Problem 4: Merge two maps

```dart
Map<String, int> mergeStocks(Map<String, int> a, Map<String, int> b) {
  Map<String, int> result = {};

  // Copy everything from a
  for (var entry in a.entries) {
    result[entry.key] = entry.value;
  }

  // Now go through b
  for (var entry in b.entries) {
    if (result.containsKey(entry.key)) {
      // Both maps have this key, keep the larger
      if (entry.value > result[entry.key]!) {
        result[entry.key] = entry.value;
      }
    } else {
      result[entry.key] = entry.value;
    }
  }

  return result;
}
```

How it works:

1. **Build a brand new map.** We do not touch the inputs.
2. **First pass: copy everything from `a`.**
3. **Second pass: walk every entry of `b`.** If the key is already there, keep the larger value. Otherwise add.

Trace on the example:

- After first pass: `{shirt: 5, cap: 10}`.
- Process b:
  - `shirt: 8` (already there with 5). 8 > 5, update. → `{shirt: 8, cap: 10}`.
  - `shoe: 3` (not there). Add. → `{shirt: 8, cap: 10, shoe: 3}`.

A shorter version using spread `...`:

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

`{...a}` spreads `a` into a new map. Cleaner once you are comfortable.

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

How each function works:

1. **`addScore`** ensures the student has an entry, then appends the score.
2. **`averageOf`** has two failure cases: student missing, or student exists with no scores. Both return -1 with early return.
3. **`topStudent`** walks every entry, computing the average for each, keeping the highest.

A cleaner version of `addScore` using `putIfAbsent`:

```dart
void addScore(Map<String, List<int>> book, String student, int score) {
  book.putIfAbsent(student, () => []).add(score);
}
```

`putIfAbsent` gives back the existing list, or runs the function to make a new one. Either way you get a list to append to.

---

**Next:** `06-Sets.md` for the third and last collection type, used when uniqueness matters.
