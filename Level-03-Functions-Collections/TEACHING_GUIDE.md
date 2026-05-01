# Teaching Guide: Level 3 (Functions and Collections)

This guide is for **you, the teacher**. Read it once before each video. Teach from your own voice, not from this script.

Level 3 has two big themes:

1. **Functions** are reusable blocks of code (topics 1-3).
2. **Collections** are ways to hold multiple values in one variable (topics 4-6).

By the end, your students should be able to write functions that take inputs, return outputs, and operate on lists, maps, and sets.

---

## How To Teach Each Topic

### Topic 1: Function Basics (45 min)

**Open with the pain:**
Show three rectangles with three different sizes. Calculate the area of each, three separate times, by repeating the same code. Make it look ugly. Now wrap it in a function. Show the savings.

**The four parts to drill:**
1. Return type (what comes out)
2. Function name (what you call it)
3. Parameters (what goes in)
4. Body (what it does)

**Live demo this exact sequence:**

```dart
void sayHi() {
  print('Hi');
}

void main() {
  sayHi();
}
```

Then evolve it: add a parameter (`String name`), then add a return value. Three steps, three rebuilds, three runs. They will see how a function grows.

**Key clarification:**
- *Parameter* = the placeholder inside the function definition.
- *Argument* = the actual value you pass when calling.
- Saying "argument" and "parameter" interchangeably is fine in casual talk, but on a whiteboard, draw the distinction once.

**Flutter teaser:**
"Every Flutter widget you build is wrapped in a function. `build(BuildContext context)` is a function. You will write hundreds of these."

---

### Topic 2: Parameters (30 min)

This is the heaviest topic in Level 3. Take it slow.

Dart has four kinds of parameters. Teach them in this exact order:

1. **Required positional**: must pass, in order. `void greet(String name)`.
2. **Optional positional**: square brackets, can skip. `void greet(String name, [String? title])`.
3. **Named**: curly braces, pass with a label. `void greet({String? name})`. Order does not matter when calling.
4. **Required named**: named with the `required` keyword. `void greet({required String name})`.

**Most common student question:** "When do I use named vs positional?"

Answer: as soon as a function has 3 or more parameters, switch to named. It makes the call site readable. Show this side by side:

```dart
// Hard to read
createUser('Ada', 25, 'Lagos', true);

// Easy to read
createUser(name: 'Ada', age: 25, city: 'Lagos', verified: true);
```

**Flutter teaser:**
"Open any Flutter widget. They use named parameters everywhere. `Padding(padding: EdgeInsets.all(8))`. The colon is the named-parameter syntax. You are seeing it now for the first time, but you will see it 100 times a day soon."

---

### Topic 3: Return Values (25 min)

Quickest topic in Level 3. The students just need three things drilled:

1. The return type at the top must match what you actually return.
2. `return` immediately stops the function.
3. `void` means "returns nothing".

Demo by writing a function with the wrong return type. Show the compile error. Fix it. Show that it now works. Two minutes, lesson learned.

---

### Topic 4: Lists (50 min)

The most important topic in Level 3 for Flutter.

**Open with a real example:**
"How would you store all the products in your shopping cart?" Wait. They will say "many variables." Then show:

```dart
List<String> cart = ['T-shirt', 'Jeans', 'Cap'];
```

**The three things to drill:**
1. Indexing starts at 0. The first item is at `[0]`. Always.
2. `length` gives the count.
3. The last item is at `length - 1`. This is where off-by-one bugs come from.

**Live demo this:**
```dart
List<String> fruits = ['apple', 'banana', 'cherry'];
print(fruits[0]);            // apple
print(fruits.length);        // 3
print(fruits[fruits.length - 1]);  // cherry
fruits.add('mango');         // append
fruits.remove('banana');     // delete by value
print(fruits);
```

Run, then change, run again. They learn by watching it change.

**Flutter teaser:**
"In Flutter, every list of products, every chat message stream, every notification feed is a List. You will use these every day."

---

### Topic 5: Maps (35 min)

A map is a list, but instead of numeric indexes, you use **keys**.

**The right analogy is a phone book:**
- Names map to phone numbers.
- You look up by name, not by position.

```dart
Map<String, String> phoneBook = {
  'Ada': '0801',
  'Bola': '0802',
};

print(phoneBook['Ada']);  // 0801
```

**Drill these:**
1. Keys must be unique. Two values can be the same.
2. Looking up a key that does not exist returns `null`.
3. Use `containsKey` to check before reading.

**Flutter teaser:**
"When you read a JSON response from an API, you will get back a Map. Your work is to pull the right keys out of it."

---

### Topic 6: Sets (15 min)

The shortest topic. Sets are like lists, but:
1. No duplicates.
2. No order.

```dart
Set<int> ids = {1, 2, 3, 1};
print(ids);  // {1, 2, 3}
```

That is the whole topic. Use a set when uniqueness matters more than order. Tags on a blog post. Permissions a user has. The IDs of products already added to a cart.

---

## Total Lesson Plan (3 sessions, 90-120 min each)

### Session 1: Functions (90 min)
- 5 min: recap Level 2.
- 45 min: Function Basics video and live-code.
- 5 min: break.
- 30 min: Parameters video and live-code.
- 5 min: assign function exercises for homework.

### Session 2: Return Values + Lists (120 min)
- 25 min: Return Values video.
- 5 min: break.
- 50 min: Lists video and live-code.
- 40 min: in-class practice. Build a contact list with add, remove, search.

### Session 3: Maps and Sets (90 min)
- 35 min: Maps.
- 5 min: break.
- 15 min: Sets.
- 35 min: capstone project (todo list manager).

---

## What Students Always Get Wrong

1. **Forgetting the parentheses when calling a function.** They write `greet;` instead of `greet();`. The function does not run, and they get confused. Show this bug on purpose.
2. **Mixing up parameter and argument.** Use the labels every time you draw on the board.
3. **Index out of range.** They write `list[list.length]` and crash. Drill: "the last index is `length - 1`."
4. **Treating a Map like a List.** Trying to do `map[0]` when 0 is not a key. Map lookup is by key, not position.
5. **Expecting Set to keep order.** Sets are unordered. If they need order, they want a List.

---

## Cheat Sheet

```dart
// Functions
returnType name(params) { return value; }

// Parameter shapes
void f(String a)                         // required positional
void f(String a, [String? b])            // optional positional
void f({String? a})                      // named, optional
void f({required String a})              // named, required

// Lists
var xs = [1, 2, 3];
xs[0];        // first item
xs.length;    // count
xs.add(4);
xs.remove(2);

// Maps
var m = {'a': 1, 'b': 2};
m['a'];               // 1, or null if missing
m.containsKey('c');   // false
m['c'] = 3;

// Sets
var s = {1, 2, 3};
s.contains(2);
s.add(4);
```

If your student can read every line above and explain it, they have learned Level 3.
