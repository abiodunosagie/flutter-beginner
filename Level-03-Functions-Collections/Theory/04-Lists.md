# Lists: One Variable That Holds Many Values

## The Big Idea In One Sentence

> A **List** is one variable that holds many values, lined up in order.

That is it. The rest of this page just shows you how to make one and use it.

---

## Why Lists Exist

So far, every variable held **one** value.

```dart
String name = 'Ada';   // one value
int age = 25;          // one value
```

But what if you want to store all the items in a shopping cart? You could write:

```dart
String item1 = 'Shirt';
String item2 = 'Jeans';
String item3 = 'Cap';
```

That is painful. What if there are 50 items? What if the items change at runtime? You cannot keep making new variables.

A **List** solves this. One variable. Many values.

```dart
List<String> cart = ['Shirt', 'Jeans', 'Cap'];
```

One variable named `cart`. It holds three values. You can add more, remove some, or loop through all of them.

---

## A Picture To Hold In Your Head

A list is a **row of numbered boxes**.

```
Index:    0          1         2
        ┌───────┐  ┌───────┐  ┌───────┐
        │ Shirt │  │ Jeans │  │ Cap   │
        └───────┘  └───────┘  └───────┘
```

Each box has a **number** above it. That number is called the **index**. You use the index to grab the value out of the box.

**The first box is at index 0, not index 1.** Yes, programmers count from zero. It feels weird at first. Just remember: the first item is `[0]`.

---

## Making A List

Quick way, with values inside:

```dart
List<String> fruits = ['apple', 'banana', 'cherry'];
```

Read it as: "a list of strings called fruits, holding three values."

The `<String>` part says **what kind of values are allowed inside**. A `List<int>` only holds whole numbers. A `List<String>` only holds text.

You can also let Dart guess the type:

```dart
var fruits = ['apple', 'banana'];   // Dart sees strings, infers List<String>
```

An empty list:

```dart
List<int> scores = [];
var names = <String>[];
```

---

## Reading A Value From A List

Use square brackets and the index number.

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits[0]);    // apple
print(fruits[1]);    // banana
print(fruits[2]);    // cherry
```

Lists also have two friendly helpers:

```dart
print(fruits.first);   // apple    (same as fruits[0])
print(fruits.last);    // cherry   (the last value)
```

### The Out-Of-Range Trap

```dart
var fruits = ['apple', 'banana', 'cherry'];   // 3 values, indexes 0, 1, 2

print(fruits[3]);   // ERROR: there is no box at index 3
```

**Memorise this:** the last valid index is `length minus 1`.

If a list has 3 values, the last valid index is 2. Reaching for `[3]` crashes.

---

## How Many Values?

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits.length);     // 3
print(fruits.isEmpty);    // false  (it has stuff)
print(fruits.isNotEmpty); // true   (it has stuff)
```

Use `isEmpty` and `isNotEmpty` instead of `length == 0`. They read better.

---

## Adding Values

```dart
var fruits = ['apple', 'banana'];

// Add one value to the end
fruits.add('cherry');
// fruits is now: [apple, banana, cherry]

// Add several at once
fruits.addAll(['date', 'elder']);
// fruits is now: [apple, banana, cherry, date, elder]

// Insert at a specific position
fruits.insert(0, 'avocado');
// fruits is now: [avocado, apple, banana, cherry, date, elder]
```

These methods change the list **in place**. They do not give back a new list. The original list itself changes.

---

## Removing Values

```dart
// Remove the first match by value
fruits.remove('banana');

// Remove the value at a specific index
fruits.removeAt(0);

// Remove the last value
fruits.removeLast();

// Remove everything
fruits.clear();
```

Same idea: these all change the list itself.

---

## Updating A Value

Just assign to the index.

```dart
var fruits = ['apple', 'banana', 'cherry'];

fruits[1] = 'blueberry';
print(fruits);   // [apple, blueberry, cherry]
```

---

## Searching In A List

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits.contains('banana'));   // true
print(fruits.contains('mango'));    // false

print(fruits.indexOf('cherry'));    // 2
print(fruits.indexOf('mango'));     // -1   (not found)
```

`indexOf` returns `-1` when the value is not in the list. Always check for `-1` before using the result as an index.

---

## Looping Through A List

You saw this in Level 2. Two clean ways.

```dart
var fruits = ['apple', 'banana', 'cherry'];

// Way 1: for-in loop (when you only need the value)
for (var fruit in fruits) {
  print(fruit);
}

// Way 2: classic for loop (when you also need the index)
for (int i = 0; i < fruits.length; i++) {
  print('$i: ${fruits[i]}');
}
```

If you do not need the index number, use `for-in`. It is shorter and clearer.

There is also `forEach`:

```dart
fruits.forEach((fruit) {
  print(fruit);
});

// or one line
fruits.forEach((fruit) => print(fruit));
```

All three forms do the same thing. Pick whichever reads best to you.

---

## Two Powerful Tools: `map` And `where`

These two are everywhere in real Dart code. Once you understand them, you write less code and fewer bugs.

### `map`: Change Every Value

`map` takes a function and applies it to **every** value in the list. It gives back a new list with the changed values.

```dart
var nums = [1, 2, 3, 4, 5];

var doubled = nums.map((n) => n * 2).toList();
print(doubled);   // [2, 4, 6, 8, 10]
```

Read it as: "for every n in nums, give me n times 2."

The `.toList()` at the end is important. `map` gives back something called an `Iterable`, which is like a list-in-progress. `.toList()` finalises it into a real list.

### `where`: Keep Only Some Values

`where` filters a list. It keeps only the values where your function returns `true`.

```dart
var nums = [1, 2, 3, 4, 5, 6];

var evens = nums.where((n) => n % 2 == 0).toList();
print(evens);   // [2, 4, 6]
```

Read it as: "give me the n values where n is even."

### Chaining Them Together

You can stack them. This is one of the cleanest patterns in Dart.

```dart
var nums = [1, 2, 3, 4, 5, 6];

var result = nums
    .where((n) => n.isOdd)
    .map((n) => n * 10)
    .toList();

print(result);   // [10, 30, 50]
```

In English: "take the odd numbers, multiply each by 10, give me the result as a list."

---

## Why This Matters In Flutter

Every product list, every chat message history, every notification feed in your phone is a `List` under the hood.

Tiny preview, do not run yet:

```dart
List<String> products = ['Shirt', 'Shoes', 'Cap'];

return Column(
  children: products.map((p) => Text(p)).toList(),
);
```

That code turns a list of names into a list of `Text` widgets. Flutter then displays them stacked vertically. Every shopping app does this.

---

## The Top Mistakes Beginners Make

### Mistake 1: Off-by-one indexes

```dart
var nums = [10, 20, 30];
print(nums[3]);                  // ERROR
print(nums[nums.length - 1]);    // GOOD: 30
```

Remember: last valid index = length minus one.

### Mistake 2: Mixing types

```dart
List<int> nums = [1, 2, 'three'];   // ERROR: 'three' is not an int
```

If the type says `<int>`, every value must be an int.

### Mistake 3: Changing a list while looping over it

```dart
var nums = [1, 2, 3];
for (var n in nums) {
  if (n == 2) nums.remove(n);   // crashes
}
```

If you need to remove items, use `removeWhere`:

```dart
nums.removeWhere((n) => n == 2);
```

### Mistake 4: Forgetting `.toList()`

```dart
var doubled = nums.map((n) => n * 2);   // this is an Iterable, not a List
print(doubled.toList());                 // now it is a List
```

After `map` or `where`, end the chain with `.toList()` if you want a real list.

---

## One-Minute Recap

- A `List` holds many values, lined up in order.
- Index starts at 0. Last valid index is `length - 1`.
- `add`, `remove`, `insert`, `removeAt`, `clear` change the list itself.
- `contains`, `indexOf` for searching.
- Loop with `for-in` (no index needed) or classic `for` (index needed).
- `map` changes every value. `where` filters values. End with `.toList()`.

---

## Quick Quiz

**Q1.** What is the last valid index of `[10, 20, 30, 40]`?

<details>
<summary>Answer</summary>
3. The list has 4 items, indexes 0, 1, 2, 3.
</details>

**Q2.** What does this print?

```dart
var nums = [1, 2, 3];
nums.add(4);
nums.removeAt(0);
print(nums);
```

<details>
<summary>Answer</summary>
`[2, 3, 4]`. Add appends 4 to the end. Then removeAt(0) removes the first item (1).
</details>

**Q3.** Convert this loop to use `where`:

```dart
List<int> nums = [1, 2, 3, 4, 5];
List<int> result = [];
for (var n in nums) {
  if (n > 2) result.add(n);
}
```

<details>
<summary>Answer</summary>

```dart
var result = nums.where((n) => n > 2).toList();
```
</details>

**Q4.** What is wrong here?

```dart
var nums = [1, 2, 3];
print(nums[3]);
```

<details>
<summary>Answer</summary>
There is no index 3. The list has 3 items at indexes 0, 1, 2. Use `nums[2]` or `nums.last`.
</details>

---

## Assignment

### Problem 1: Predict the output

What does this print at the end?

```dart
void main() {
  List<int> nums = [10, 20, 30, 40, 50];
  nums.removeAt(0);
  nums.add(60);
  nums.insert(2, 99);
  nums[0] = 100;
  print(nums);
  print(nums.length);
}
```

### Problem 2: Custom helpers (twice)

Write each of these **without** using `map`, `where`, or `forEach`. Use only basic for loops, if statements, and basic List methods.

- `int sumOfList(List<int> nums)` gives back the sum of all values.
- `int countMatching(List<String> words, String target)` gives back the number of times `target` appears.
- `List<int> doubledValues(List<int> nums)` gives back a new list where each value is doubled.

Then write each one again using `map`, `where`, `reduce`, or `forEach`. Compare both versions.

### Problem 3: Find smallest and largest

Without using any built-in `min` or `max`, write a function `List<int> minMax(List<int> nums)` that gives back a list of exactly two values: `[min, max]`. The smallest value at index 0, the largest at index 1. Find both in one walk through the input.

If the list is empty, throw an `ArgumentError` with a clear message.

Test on `[5, 2, 9, 1, 7, 3]`. Expected: `[1, 9]`.

### Problem 4: Filter, transform, collect

Given:

```dart
List<int> prices = [1500, 800, 2400, 600, 9999, 1200, 250, 3500];
```

Use a chain of `where`, `map`, and `toList` to:

1. Keep only prices between 500 and 2000 (inclusive).
2. Apply a 10% discount to each.
3. Convert to a list of ints (rounded down).

Show your code, predict the output, then check.

### Problem 5: Build a contact list

Build a small program that simulates a contact list. The list holds `String` names. Implement these as functions, then call them in `main`.

- `void add(List<String> contacts, String name)` adds a name unless it is already there.
- `bool removeContact(List<String> contacts, String name)` removes the first match and gives back true. Gives back false if not found.
- `int findIndexOf(List<String> contacts, String name)` gives back the index, or -1.
- `void printAll(List<String> contacts)` prints each name on its own line, prefixed with its index.

Demonstrate by:
1. Starting with `['Ada', 'Bola']`.
2. Adding `'Chidi'` (should add).
3. Adding `'Ada'` (should not add, duplicate).
4. Removing `'Bola'` (should succeed).
5. Removing `'Zara'` (should fail).
6. Printing the final state.

---

## Assignment Answers

### Problem 1: Predict the output

```
[100, 30, 99, 40, 50, 60]
6
```

Trace step by step:

| Step | Action | List after |
|------|--------|------------|
| Start | --- | [10, 20, 30, 40, 50] |
| 1 | removeAt(0) | [20, 30, 40, 50] |
| 2 | add(60) | [20, 30, 40, 50, 60] |
| 3 | insert(2, 99) | [20, 30, 99, 40, 50, 60] |
| 4 | nums[0] = 100 | [100, 30, 99, 40, 50, 60] |

Length is 6.

The lesson: each list method changes both the contents and (sometimes) the length. When tracing, update both.

### Problem 2: Custom helpers (twice)

**Manual versions:**

```dart
int sumOfList(List<int> nums) {
  int total = 0;
  for (int n in nums) {
    total += n;
  }
  return total;
}

int countMatching(List<String> words, String target) {
  int count = 0;
  for (String w in words) {
    if (w == target) count++;
  }
  return count;
}

List<int> doubledValues(List<int> nums) {
  List<int> result = [];
  for (int n in nums) {
    result.add(n * 2);
  }
  return result;
}
```

**Idiomatic versions:**

```dart
int sumOfList(List<int> nums) =>
    nums.isEmpty ? 0 : nums.reduce((a, b) => a + b);

int countMatching(List<String> words, String target) =>
    words.where((w) => w == target).length;

List<int> doubledValues(List<int> nums) =>
    nums.map((n) => n * 2).toList();
```

Comparison:

- The manual versions are explicit. You can see every step. Great for learning.
- The short versions are clean and tight, but you have to know what `map`, `where`, and `reduce` do.
- `reduce` crashes on an empty list, so we add a guard.
- `where(...).length` is a common pattern for counting matches.

In real code, prefer the short versions. While learning, write the manual version first.

### Problem 3: Smallest and largest

```dart
List<int> minMax(List<int> nums) {
  if (nums.isEmpty) {
    throw ArgumentError('Cannot find min/max of an empty list');
  }

  int currentMin = nums[0];
  int currentMax = nums[0];

  for (int i = 1; i < nums.length; i++) {
    if (nums[i] < currentMin) currentMin = nums[i];
    if (nums[i] > currentMax) currentMax = nums[i];
  }

  return [currentMin, currentMax];
}

void main() {
  List<int> result = minMax([5, 2, 9, 1, 7, 3]);
  print('min: ${result[0]}, max: ${result[1]}');   // min: 1, max: 9
}
```

How it works:

1. **Empty list guard.** Throwing is correct here. There is no sensible "min" of nothing.
2. **Seed both with the first value.** We cannot start at 0 (what if all values are negative?). The first item is always a valid starting point.
3. **Loop from index 1.** We already used index 0 as the seed.
4. **Two checks per round.** Update min if smaller, update max if larger.
5. **Return a list of two values:** `[min, max]`. The caller reads `result[0]` for the min and `result[1]` for the max.

Trace on `[5, 2, 9, 1, 7, 3]`:

| i | num | min | max |
|---|-----|-----|-----|
| start | 5 | 5 | 5 |
| 1 | 2 | 2 | 5 |
| 2 | 9 | 2 | 9 |
| 3 | 1 | 1 | 9 |
| 4 | 7 | 1 | 9 |
| 5 | 3 | 1 | 9 |

Final: `[1, 9]`.

This is "one pass" because we walk the list exactly once, even though we compute two answers.

### Problem 4: Filter, transform, collect

```dart
List<int> prices = [1500, 800, 2400, 600, 9999, 1200, 250, 3500];

List<int> result = prices
    .where((p) => p >= 500 && p <= 2000)
    .map((p) => (p * 0.9).floor())
    .toList();

print(result);
```

Walk through each step:

After `where`:
- 1500 ok, 800 ok, 2400 too big, 600 ok, 9999 too big, 1200 ok, 250 too small, 3500 too big.
- Remaining: `[1500, 800, 600, 1200]`.

After `map` (each times 0.9, then floor):
- 1500 * 0.9 = 1350.
- 800 * 0.9 = 720.
- 600 * 0.9 = 540.
- 1200 * 0.9 = 1080.

Final: `[1350, 720, 540, 1080]`.

Notes:
- `.floor()` rounds a double down to the nearest int.
- `floor()` returns an `int`, so the result list type is `List<int>`.

### Problem 5: Contact list

```dart
void add(List<String> contacts, String name) {
  if (!contacts.contains(name)) {
    contacts.add(name);
  }
}

bool removeContact(List<String> contacts, String name) {
  int index = contacts.indexOf(name);
  if (index == -1) return false;
  contacts.removeAt(index);
  return true;
}

int findIndexOf(List<String> contacts, String name) {
  return contacts.indexOf(name);
}

void printAll(List<String> contacts) {
  for (int i = 0; i < contacts.length; i++) {
    print('$i: ${contacts[i]}');
  }
}

void main() {
  List<String> contacts = ['Ada', 'Bola'];

  add(contacts, 'Chidi');
  print('Added Chidi -> $contacts');

  add(contacts, 'Ada');
  print('Tried Ada (duplicate) -> $contacts');

  bool ok1 = removeContact(contacts, 'Bola');
  print('Removed Bola? $ok1 -> $contacts');

  bool ok2 = removeContact(contacts, 'Zara');
  print('Removed Zara? $ok2 -> $contacts');

  print('Final state:');
  printAll(contacts);
}
```

Expected output:

```
Added Chidi -> [Ada, Bola, Chidi]
Tried Ada (duplicate) -> [Ada, Bola, Chidi]
Removed Bola? true -> [Ada, Chidi]
Removed Zara? false -> [Ada, Chidi]
Final state:
0: Ada
1: Chidi
```

How each function works:

1. **`add` checks `contains` first.** If the name is already there, do nothing. Otherwise append.
2. **`removeContact` uses `indexOf` to find the position.** If not found (-1), return false. Otherwise remove and return true.
3. **`findIndexOf` is a thin wrapper** around `indexOf`.
4. **`printAll` uses a classic for loop** because we need the index for the prefix.

Notice how we wrap a List in functions that enforce rules (no duplicates, return success). This is the seed of Object-Oriented Programming, which you will learn in Level 4.

---

**Next:** `05-Maps.md` to learn how to look up values by name instead of by position.
