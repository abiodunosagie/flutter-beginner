# Futures Deep Dive: Understanding Async Operations

## The Big Idea In One Sentence

> A `Future` is a promise of a value that arrives later, `async` marks a function that can wait, and `await` pauses until the value is ready, so slow work does not freeze your app.

## The Simple Explanation

Imagine you order pizza:

```
SYNCHRONOUS (waiting in line):
┌─────────────────────────────────────────┐
│  1. You order pizza                     │
│  2. You STAND AND WAIT at the counter   │
│  3. Pizza takes 20 minutes              │
│  4. You wait... and wait... and wait... │
│  5. Finally get pizza                   │
│  6. NOW you can go home                 │
│                                         │
│  You wasted 20 minutes doing nothing!   │
└─────────────────────────────────────────┘

ASYNCHRONOUS (Futures):
┌─────────────────────────────────────────┐
│  1. You order pizza                     │
│  2. They give you a buzzer (Future)     │
│  3. You go sit down, check phone        │
│  4. Buzzer vibrates! (Future completes) │
│  5. You pick up your pizza              │
│                                         │
│  You did other things while waiting!    │
└─────────────────────────────────────────┘
```

**A Future is like a buzzer** - it's a promise that you'll get something later!

---

## What is a Future?

A Future represents a value that **doesn't exist yet** but will exist in the future.

```dart
// This returns IMMEDIATELY with a Future (the buzzer)
Future<String> orderPizza() {
  // But the pizza (the value) comes later
}

// Three possible states:
// 1. Uncompleted: Still waiting for pizza
// 2. Completed with value: Pizza is ready! 🍕
// 3. Completed with error: Sorry, we're out of dough! ❌
```

### Visual Timeline

```
Time →
─────────────────────────────────────────────────►

orderPizza() called          Future completes
      │                            │
      ▼                            ▼
      ╔════════════════════════════╗
      ║     Future is waiting...   ║
      ╚════════════════════════════╝
                  │
                  ▼
          Either gets a value: "Pepperoni pizza"
          Or gets an error: "Kitchen fire!"
```

---

## Creating Futures

### Way 1: Future Constructor

```dart
// Future that completes after 2 seconds
Future<String> fetchMessage() {
  return Future.delayed(
    Duration(seconds: 2),
    () => 'Hello from the future!',
  );
}
```

### Way 2: async Function

```dart
// async automatically returns a Future
Future<String> fetchMessage() async {
  await Future.delayed(Duration(seconds: 2));
  return 'Hello from the future!';
}
```

### Way 3: Future.value (Instant completion)

```dart
// Completes immediately with a value
Future<int> getNumber() {
  return Future.value(42);
}
```

### Way 4: Future.error (Instant error)

```dart
// Completes immediately with an error
Future<int> failingFunction() {
  return Future.error('Something went wrong!');
}
```

---

## Using Futures: await

The `await` keyword says "wait here until the Future completes":

```dart
void main() async {
  print('Ordering pizza...');

  // Wait here until orderPizza() completes
  String pizza = await orderPizza();

  print('Got my pizza: $pizza');
}
```

### What Happens Step by Step

```
print('Ordering pizza...');        ← Runs immediately
              │
              ▼
await orderPizza();                ← PAUSES here
              │
              │  (2 seconds pass)
              │
              ▼
String pizza = "Pepperoni"         ← Gets the result
              │
              ▼
print('Got my pizza: $pizza');     ← Continues
```

---

## Error Handling: try-catch

What if the pizza shop has a fire? Handle errors!

```dart
Future<String> orderPizza() async {
  await Future.delayed(Duration(seconds: 2));

  // Simulate a problem
  throw Exception('Kitchen fire! No pizza!');
}

void main() async {
  try {
    String pizza = await orderPizza();
    print('Got pizza: $pizza');
  } catch (error) {
    print('Error: $error');
    // Handle the error gracefully
  }
}
```

### Visual Flow

```
try {
    │
    ▼
  await orderPizza()
    │
    ├── Success? ───────► print('Got pizza')
    │                            │
    │                            ▼
    │                         continue...
    │
    └── Error? ─────────► } catch (error) {
                                 │
                                 ▼
                          print('Error')
                                 │
                                 ▼
                          continue...
```

---

## Running Multiple Futures

### One After Another (Sequential)

```dart
Future<void> makeBreakfast() async {
  // One by one - SLOW!
  String eggs = await cookEggs();      // Wait 3 minutes
  String toast = await makeToast();     // Wait 2 minutes
  String coffee = await brewCoffee();   // Wait 4 minutes
  // Total: 9 minutes!
}
```

### All at Once (Parallel) - FASTER!

```dart
Future<void> makeBreakfast() async {
  // All at the same time!
  final results = await Future.wait([
    cookEggs(),      // 3 minutes
    makeToast(),     // 2 minutes
    brewCoffee(),    // 4 minutes
  ]);
  // Total: 4 minutes! (longest one)

  String eggs = results[0];
  String toast = results[1];
  String coffee = results[2];
}
```

### Visual Comparison

```
SEQUENTIAL (one by one):
┌────────────────────────────────────────────────┐
│ Time: 0    3    5         9                    │
│       ├────┼────┼─────────┤                    │
│ Eggs  ████████                                 │
│ Toast        ████                              │
│ Coffee           ████████████                  │
│                                                │
│ Total time: 9 minutes                          │
└────────────────────────────────────────────────┘

PARALLEL (all at once):
┌────────────────────────────────────────────────┐
│ Time: 0              4                         │
│       ├──────────────┤                         │
│ Eggs  ████████       │                         │
│ Toast ████           │                         │
│ Coffee████████████████                         │
│                                                │
│ Total time: 4 minutes!                         │
└────────────────────────────────────────────────┘
```

---

## FutureBuilder: Futures in Widgets

Use FutureBuilder to show Futures in your UI:

```dart
class DataScreen extends StatelessWidget {
  const DataScreen({super.key});

  Future<String> fetchData() async {
    await Future.delayed(const Duration(seconds: 2));
    return 'Hello from the server!';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<String>(
        future: fetchData(),
        builder: (context, snapshot) {
          // Check the state of the Future
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Still loading
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            // Something went wrong
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          // Success! Show the data
          return Center(
            child: Text(snapshot.data!),
          );
        },
      ),
    );
  }
}
```

### Snapshot States

```
ConnectionState:
┌─────────────────────────────────────────────────┐
│                                                 │
│  .waiting  ──► Future hasn't completed yet      │
│                Show loading spinner             │
│                                                 │
│  .done     ──► Future completed                 │
│                Check hasError or hasData        │
│                                                 │
│  .none     ──► No future                        │
│                                                 │
│  .active   ──► (Used with Streams)              │
│                                                 │
└─────────────────────────────────────────────────┘

Snapshot properties:
┌─────────────────────────────────────────────────┐
│                                                 │
│  hasData   ──► True if data is available        │
│  data      ──► The actual data (if available)   │
│                                                 │
│  hasError  ──► True if an error occurred        │
│  error     ──► The error (if any)               │
│                                                 │
└─────────────────────────────────────────────────┘
```

---

## Common Patterns

### Pattern 1: Load Data on Screen Open

```dart
class UserProfileScreen extends StatefulWidget {
  const UserProfileScreen({super.key});

  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  late Future<User> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _fetchUser();  // Start loading immediately
  }

  Future<User> _fetchUser() async {
    // Fetch from API
    await Future.delayed(const Duration(seconds: 2));
    return User(name: 'Alex', email: 'alex@email.com');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: FutureBuilder<User>(
        future: _userFuture,  // Use the stored Future
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Failed to load user'),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _userFuture = _fetchUser();  // Retry
                      });
                    },
                    child: const Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          final user = snapshot.data!;
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Name: ${user.name}'),
                Text('Email: ${user.email}'),
              ],
            ),
          );
        },
      ),
    );
  }
}
```

### Pattern 2: Button with Loading State

```dart
class SubmitButton extends StatefulWidget {
  const SubmitButton({super.key});

  @override
  State<SubmitButton> createState() => _SubmitButtonState();
}

class _SubmitButtonState extends State<SubmitButton> {
  bool _isLoading = false;

  Future<void> _submit() async {
    setState(() => _isLoading = true);

    try {
      await Future.delayed(const Duration(seconds: 2));
      // Success!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Success!')),
      );
    } catch (e) {
      // Error!
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: _isLoading ? null : _submit,
      child: _isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : const Text('Submit'),
    );
  }
}
```

---

## Chaining Futures: then()

Another way to use Futures (without await):

```dart
// Using then()
fetchUser()
    .then((user) => print('Got user: $user'))
    .catchError((error) => print('Error: $error'));

// Same as:
try {
  final user = await fetchUser();
  print('Got user: $user');
} catch (error) {
  print('Error: $error');
}
```

### When to Use What?

```
await/async:
✅ Easier to read
✅ Better for sequential operations
✅ Better for try/catch

then():
✅ Good for simple callbacks
✅ Can chain many operations
✅ Don't need async function
```

---

## Common Mistakes

### Mistake 1: Forgetting await

```dart
// ❌ WRONG: Not awaiting
void loadData() {
  fetchData();  // Returns immediately! Data not loaded yet!
  print('Data is ready!');  // LIES! It's not ready!
}

// ✅ CORRECT: Awaiting
Future<void> loadData() async {
  await fetchData();  // Waits for completion
  print('Data is ready!');  // True! It's ready now!
}
```

### Mistake 2: Calling Future in build()

```dart
// ❌ WRONG: Creates new Future every rebuild
Widget build(BuildContext context) {
  return FutureBuilder(
    future: fetchData(),  // BAD! Called on every rebuild!
    builder: (context, snapshot) { ... },
  );
}

// ✅ CORRECT: Store the Future
late Future<Data> _dataFuture;

@override
void initState() {
  super.initState();
  _dataFuture = fetchData();  // Called once
}

Widget build(BuildContext context) {
  return FutureBuilder(
    future: _dataFuture,  // GOOD! Same Future
    builder: (context, snapshot) { ... },
  );
}
```

### Mistake 3: Not Handling Errors

```dart
// ❌ WRONG: No error handling
Future<void> loadData() async {
  final data = await fetchData();  // What if this fails?
  // App crashes!
}

// ✅ CORRECT: Handle errors
Future<void> loadData() async {
  try {
    final data = await fetchData();
    // Use data
  } catch (e) {
    // Handle error
    print('Failed to load: $e');
  }
}
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│                   FUTURES SUMMARY                        │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: A value that will be available in the future      │
│        (like a buzzer at a restaurant)                   │
│                                                          │
│  STATES:                                                 │
│  • Uncompleted - Still waiting                           │
│  • Completed with value - Got the data!                  │
│  • Completed with error - Something went wrong           │
│                                                          │
│  KEY KEYWORDS:                                           │
│  • async - Marks function as asynchronous                │
│  • await - Wait for Future to complete                   │
│  • Future<T> - Return type for async functions           │
│                                                          │
│  ERROR HANDLING:                                         │
│  • try/catch for await                                   │
│  • .catchError() for then()                              │
│                                                          │
│  IN WIDGETS:                                             │
│  • FutureBuilder handles loading, error, and success     │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What is a Future?

<details>
<summary>Answer</summary>

A Future is a value that **doesn't exist yet** but will exist in the future. It's like a buzzer at a restaurant - you get it immediately, but the actual food (value) comes later.

</details>

**Q2:** What's the difference between sequential and parallel Futures?

<details>
<summary>Answer</summary>

**Sequential (one by one):**
```dart
await taskA();  // Wait for A
await taskB();  // Then wait for B
await taskC();  // Then wait for C
// Total time = A + B + C
```

**Parallel (all at once):**
```dart
await Future.wait([taskA(), taskB(), taskC()]);
// Total time = longest task only
```

Parallel is faster when tasks don't depend on each other!

</details>

**Q3:** Why should you NOT call fetchData() directly in FutureBuilder?

<details>
<summary>Answer</summary>

Because `build()` can be called many times (when widget rebuilds). If you put `fetchData()` there, it creates a new Future every time, making unnecessary network calls!

**Instead:** Store the Future in `initState()` and reuse it.

</details>

---

## Assignment

### Problem 1: Mark it async

This function uses `await`, so it must be marked something and return something. Fix the signature:

```dart
Future<String> loadName() {
  final name = await fetchName();
  return name;
}
```

### Problem 2: Wait for it

Write a line that calls `await fetchUser()` and stores the result in `user`.

### Problem 3: What is a Future?

In one sentence, what does a `Future<int>` represent?

---

## Assignment Answers

### Problem 1: Mark it async

```dart
Future<String> loadName() async {
  final name = await fetchName();
  return name;
}
```

It needs `async` to use `await` (the return type `Future<String>` was already correct).

### Problem 2: Wait for it

```dart
final user = await fetchUser();
```

### Problem 3: What is a Future?

A `Future<int>` is a promise that an `int` value will be available later (once the slow work finishes).

---

**Next:** Let's learn about Streams - for real-time data!

---

**Continue to:** `07-StreamsExplained.md`
