# Lists: Storing Many Values In One Variable

## Why This Topic Exists

So far, every variable you wrote held **one** value. One name. One number. One bool.

What if you want to store all the products in a shopping cart? You could write:

```dart
String item1 = 'T-shirt';
String item2 = 'Jeans';
String item3 = 'Cap';
```

This breaks down fast. What if there are 50 items? What if items are added at runtime?

The answer is a **List**: one variable that holds many values, in order.

```dart
List<String> cart = ['T-shirt', 'Jeans', 'Cap'];
```

One variable. Three values. Easy to grow, easy to shrink, easy to loop over.

---

## The Mental Model

A list is a **row of numbered boxes**.

```
Index:    0          1         2
        ┌──────┐  ┌──────┐  ┌──────┐
        │T-shirt│  │ Jeans│  │ Cap  │
        └──────┘  └──────┘  └──────┘
```

You access each box by its **index**, which is just its position. The first box is at index `0`, not `1`. Yes, programmers count from zero. Get used to this now, you will see it forever.

---

## Creating A List

The shortest form, with values:

```dart
List<String> fruits = ['apple', 'banana', 'cherry'];
```

Read it as: "a list of strings, called fruits, containing three values."

The `<String>` part is the **type**. It tells Dart what is allowed inside. A `List<int>` only holds ints. A `List<String>` only holds strings.

You can let Dart figure out the type with `var`:

```dart
var fruits = ['apple', 'banana'];   // Dart sees strings, infers List<String>
```

An empty list:

```dart
List<int> scores = [];
var names = <String>[];
```

---

## Reading From A List

Use square brackets and the index:

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits[0]);    // apple
print(fruits[1]);    // banana
print(fruits[2]);    // cherry
```

You can also use the helpers `.first` and `.last`:

```dart
print(fruits.first);    // apple
print(fruits.last);     // cherry
```

### The Index-Out-Of-Range Trap

```dart
var fruits = ['apple', 'banana', 'cherry'];   // length is 3

print(fruits[3]);    // ERROR: RangeError
```

The list has 3 items, but their indexes are 0, 1, 2. There is **no** index 3. The last valid index is always `length - 1`.

Memorise this: **last index = length minus one.**

---

## Length

`length` tells you how many items the list holds:

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits.length);     // 3
print(fruits.isEmpty);    // false
print(fruits.isNotEmpty); // true
```

`isEmpty` and `isNotEmpty` are shortcuts for "is the list empty?" and "does it have anything?". Use them instead of `length == 0`. They read better.

---

## Adding And Removing Items

```dart
var fruits = ['apple', 'banana'];

// Add to the end
fruits.add('cherry');
// fruits is now: [apple, banana, cherry]

// Add several at once
fruits.addAll(['date', 'elder']);
// fruits is now: [apple, banana, cherry, date, elder]

// Insert at a specific position
fruits.insert(0, 'avocado');
// fruits is now: [avocado, apple, banana, cherry, date, elder]
```

```dart
// Remove the first match by value
fruits.remove('banana');

// Remove by index
fruits.removeAt(0);

// Remove the last item
fruits.removeLast();

// Remove all items
fruits.clear();
```

These methods modify the list **in place**. They do not return a new list. The change happens to the original.

---

## Updating An Item

Just assign to the index:

```dart
var fruits = ['apple', 'banana', 'cherry'];

fruits[1] = 'blueberry';
print(fruits);     // [apple, blueberry, cherry]
```

---

## Searching

```dart
var fruits = ['apple', 'banana', 'cherry'];

print(fruits.contains('banana'));    // true
print(fruits.contains('mango'));     // false

print(fruits.indexOf('cherry'));     // 2
print(fruits.indexOf('mango'));      // -1, meaning not found
```

`indexOf` returns `-1` when nothing matches. Always check before using the result as an index, or you will hit the range error from earlier.

---

## Looping Through A List

You already saw this in Level 2. Two clean ways:

```dart
var fruits = ['apple', 'banana', 'cherry'];

// for-in: when you only need each item
for (var fruit in fruits) {
  print(fruit);
}

// classic for: when you need the index too
for (int i = 0; i < fruits.length; i++) {
  print('$i: ${fruits[i]}');
}
```

If you do not need the index, prefer `for-in`. It is shorter and clearer.

There is also `forEach`, which takes an anonymous function:

```dart
fruits.forEach((fruit) {
  print(fruit);
});

// or, one line
fruits.forEach((fruit) => print(fruit));
```

All three forms do the same thing. Pick the one that reads best for your code.

---

## Two Powerful Methods: `map` And `where`

These are everywhere in real Dart code. Once you understand them, you write less code and fewer bugs.

### `map`: Transform Every Item

`map` takes a function and applies it to each item, returning a new list:

```dart
var nums = [1, 2, 3, 4, 5];

var doubled = nums.map((n) => n * 2).toList();
print(doubled);     // [2, 4, 6, 8, 10]
```

Read it as: "for every `n` in `nums`, give me `n * 2`."

The `.toList()` at the end is required because `map` returns an `Iterable`, which is a kind of "list-in-progress". Calling `.toList()` finalises it.

### `where`: Keep Only The Items That Match

`where` filters a list. It returns a new list with only the items where your function returns true:

```dart
var nums = [1, 2, 3, 4, 5, 6];

var evens = nums.where((n) => n % 2 == 0).toList();
print(evens);      // [2, 4, 6]
```

Read it as: "give me the `n` values where `n % 2 == 0`."

### Chaining

You can chain them. This is one of the cleanest patterns in Dart:

```dart
var nums = [1, 2, 3, 4, 5, 6];

var result = nums
    .where((n) => n.isOdd)
    .map((n) => n * 10)
    .toList();

print(result);     // [10, 30, 50]
```

In English: "take the odd numbers, multiply each by 10, give me the result as a list."

---

## Why This Matters In Flutter

Every product list, every chat history, every notification feed in your phone is a `List` under the hood.

Tiny preview, do not run yet:

```dart
List<String> products = ['T-shirt', 'Shoes', 'Cap'];

return Column(
  children: products.map((p) => Text(p)).toList(),
);
```

That code transforms a list of product names into a list of `Text` widgets, which Flutter then displays vertically. Every shopping app in the world uses this pattern. It is the same `map` you just learned.

---

## Common Mistakes

### 1. Off-by-one indexing

```dart
var nums = [10, 20, 30];
print(nums[3]);     // ERROR
print(nums[nums.length - 1]);   // 30, correct
```

### 2. Mixing types

```dart
List<int> nums = [1, 2, 'three'];   // ERROR: string in a list of ints
```

### 3. Modifying a list while looping over it

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

### 4. Forgetting `.toList()` after `map` or `where`

```dart
var doubled = nums.map((n) => n * 2);    // returns Iterable, not List
print(doubled.toList());                  // converts to a List
```

---

## Recap In One Minute

- A `List` holds many values in order, accessed by index starting at 0.
- Last valid index is `length - 1`.
- `add`, `remove`, `insert`, `removeAt`, `clear` modify the list in place.
- `contains`, `indexOf` for searching.
- Loop with `for-in` when you do not need the index, classic `for` when you do.
- `map` transforms every item; `where` filters; both return iterables, finish with `.toList()`.

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
`[2, 3, 4]`. Add appends 4 to the end, then removeAt(0) removes the first item (1).
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
There is no index 3. The list has 3 items at indexes 0, 1, 2. The fix is `nums[2]` or `nums.last`.
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

### Problem 2: Custom helpers

Write each of these without using `map`, `where`, or `forEach`. Use only basic for loops, if statements, and basic List methods (`add`, `length`, indexing).

- `int sumOfList(List<int> nums)` returns the sum of all values.
- `int countMatching(List<String> words, String target)` returns the number of times `target` appears in `words`.
- `List<int> doubledValues(List<int> nums)` returns a new list where each value is doubled.

Then rewrite all three using `map`, `where`, `reduce`, `forEach`, or any combination. Compare the two versions in your answer.

### Problem 3: Find largest and smallest

Without using any built-in `min` or `max`, write a function `({int min, int max}) minMax(List<int> nums)` that returns both the smallest and largest values in one pass over the list. The return type uses a Dart record. If the list is empty, the function should throw an `ArgumentError` with a clear message.

Test on `[5, 2, 9, 1, 7, 3]`. Expected: `min: 1, max: 9`.

### Problem 4: Filter, transform, collect

Given:

```dart
List<int> prices = [1500, 800, 2400, 600, 9999, 1200, 250, 3500];
```

Use a chain of `where`, `map`, and `toList` to:

1. Keep only prices between 500 and 2000 inclusive.
2. Apply a 10% discount to each.
3. Convert to a list of ints (rounded down).

Show your code, predict the output, then verify.

### Problem 5: Build a contact-list manager

Build a small program that simulates a contact list. The list holds `String` names. Implement these as functions, then call them in `main` to demonstrate.

- `void add(List<String> contacts, String name)` adds a name unless it is already in the list.
- `bool removeContact(List<String> contacts, String name)` removes the first matching name and returns true. If the name is not found, return false.
- `int findIndexOf(List<String> contacts, String name)` returns the index, or -1 if not found.
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
[100, 40, 99, 50, 60]
5
```

Trace step by step:

| Step | Action | List after |
|------|--------|------------|
| Start | --- | [10, 20, 30, 40, 50] |
| 1 | removeAt(0) | [20, 30, 40, 50] |
| 2 | add(60) | [20, 30, 40, 50, 60] |
| 3 | insert(2, 99) | [20, 30, 99, 40, 50, 60] |
| 4 | nums[0] = 100 | [100, 30, 99, 40, 50, 60] |

Wait, that gives a length of 6, not 5. Let me retrace more carefully.

- After removeAt(0): we removed the first element (10). List is `[20, 30, 40, 50]`. Length 4.
- After add(60): appended 60. List is `[20, 30, 40, 50, 60]`. Length 5.
- After insert(2, 99): inserted 99 at index 2. List is `[20, 30, 99, 40, 50, 60]`. Length 6.
- After nums[0] = 100: replaced first item. List is `[100, 30, 99, 40, 50, 60]`. Length 6.

So the actual output is:

```
[100, 30, 99, 40, 50, 60]
6
```

The lesson here: each list method changes the list and may change the length. You must mentally update both the contents and the length after every call. When in doubt, write each step out on paper.

### Problem 2: Custom helpers

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

**Idiomatic versions using `map`, `where`, `reduce`:**

```dart
int sumOfList(List<int> nums) =>
    nums.isEmpty ? 0 : nums.reduce((a, b) => a + b);

int countMatching(List<String> words, String target) =>
    words.where((w) => w == target).length;

List<int> doubledValues(List<int> nums) =>
    nums.map((n) => n * 2).toList();
```

Comparison:

- The manual versions are explicit. You can see every step. They are great for learning.
- The idiomatic versions are short, but require knowing what `map`, `where`, and `reduce` do. They become natural after some practice.
- `reduce` requires a non-empty list, so we add a guard. Otherwise it throws.
- `where(...).length` is a common idiom for counting matches. It builds the matching list and asks for its length.

In real code, prefer the idiomatic versions for clarity. In a teaching context, write the manual version first, then show the shortcut.

### Problem 3: Find largest and smallest

```dart
({int min, int max}) minMax(List<int> nums) {
  if (nums.isEmpty) {
    throw ArgumentError('Cannot find min/max of an empty list');
  }

  int currentMin = nums[0];
  int currentMax = nums[0];

  for (int i = 1; i < nums.length; i++) {
    if (nums[i] < currentMin) currentMin = nums[i];
    if (nums[i] > currentMax) currentMax = nums[i];
  }

  return (min: currentMin, max: currentMax);
}
```

How the algorithm works:

1. **Empty list guard.** Throwing is the right choice here. There is no sensible "min" of nothing. We refuse to make up an answer.
2. **Seed with the first element.** Both `currentMin` and `currentMax` start as `nums[0]`. We cannot start them at 0 (what if all values are negative?) or at "infinity" (Dart has no easy literal for that). Using the first element guarantees a valid starting comparison.
3. **Loop from index 1 onward.** We already used index 0 as the seed. Starting at 1 avoids comparing it to itself.
4. **Two independent comparisons per round.** Update min if smaller, update max if larger. Both checks happen even if one matched. (A value cannot be both smaller than current min and larger than current max at the same time, but writing it as two `if`s is clearer than nested logic.)

Trace on `[5, 2, 9, 1, 7, 3]`:

| i | num | currentMin | currentMax |
|---|-----|------------|------------|
| start | 5 | 5 | 5 |
| 1 | 2 | 2 | 5 |
| 2 | 9 | 2 | 9 |
| 3 | 1 | 1 | 9 |
| 4 | 7 | 1 | 9 |
| 5 | 3 | 1 | 9 |

Final: min 1, max 9. Correct.

This is "one-pass" because we go through the list exactly once, even though we compute two answers.

### Problem 4: Filter, transform, collect

```dart
List<int> prices = [1500, 800, 2400, 600, 9999, 1200, 250, 3500];

List<int> result = prices
    .where((p) => p >= 500 && p <= 2000)
    .map((p) => (p * 0.9).floor())
    .toList();

print(result);
```

Predicted output:

Let us trace each step carefully.

After `where((p) => p >= 500 && p <= 2000)`:
- 1500 passes, 800 passes, 2400 fails, 600 passes, 9999 fails, 1200 passes, 250 fails, 3500 fails.
- Remaining: `[1500, 800, 600, 1200]`.

After `map((p) => (p * 0.9).floor())`:
- 1500 * 0.9 = 1350, floor 1350.
- 800 * 0.9 = 720, floor 720.
- 600 * 0.9 = 540, floor 540.
- 1200 * 0.9 = 1080, floor 1080.

After `.toList()`:
- `[1350, 720, 540, 1080]`.

So the output is:
```
[1350, 720, 540, 1080]
```

Notes:
- `.floor()` rounds down to the nearest int. We use it because `0.9 * price` is a `double` and we want `int` results.
- `floor()` returns `int` when called on `double`, so the resulting list type is `List<int>`. Match the requirement.

### Problem 5: Build a contact-list manager

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
  print('Tried to add Ada (duplicate) -> $contacts');

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
Tried to add Ada (duplicate) -> [Ada, Bola, Chidi]
Removed Bola? true -> [Ada, Chidi]
Removed Zara? false -> [Ada, Chidi]
Final state:
0: Ada
1: Chidi
```

How each function was designed:

1. **`add` uses `contains` to check for duplicates.** If the name is already there, we do nothing. Otherwise we append.
2. **`removeContact` uses `indexOf` to find the position, then `removeAt`.** This avoids the issue with `remove(name)` returning a bool but only telling us whether something happened. Using indexOf gives us the same info plus we can confirm by checking for -1.
3. **`findIndexOf` is a thin wrapper.** In a real library you might add additional checks, but here it just delegates.
4. **`printAll` uses a classic for loop with the index.** We need `i` for the prefix, so for-in is not enough.

This whole pattern of "wrap a List in functions that enforce rules" is the seed of Object-Oriented Programming. In Level 4 you will learn how to bundle the list and the functions together into a single `ContactList` class. Same idea, cleaner package.

---

**Next:** `05-Maps.md` to learn how to look up values by name instead of by position.
