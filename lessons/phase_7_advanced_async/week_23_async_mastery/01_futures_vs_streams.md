# Futures vs Streams: Understanding Async Data

## 5-Year-Old Explanation

Imagine two different ways to get toys:

**Future (One-Time Delivery):**
You order a toy online. The delivery truck brings it to your house ONCE. You get the toy, and that's it - no more deliveries for that order.

**Stream (Ongoing Delivery):**
You subscribe to a "Toy of the Month" club. Every month, a new toy shows up at your door! The deliveries keep coming until you cancel.

In programming:
- **Future** = One single thing that will arrive later (like downloading one photo)
- **Stream** = Multiple things arriving over time (like watching a video - the data keeps coming!)

**Real examples:**
- Future: "Fetch user profile" → Gets it once, done
- Stream: "Listen to chat messages" → New messages keep arriving!

The key difference: Futures give you ONE result. Streams give you MANY results over time!

---

## What You'll Learn

In this comprehensive lesson, you'll master:
- What asynchronous programming is and why it's critical
- Understanding Futures in depth
- Understanding Streams in depth
- When to use Futures vs when to use Streams
- async/await patterns
- Future combinators (Future.wait, Future.any, etc.)
- Error handling in async code
- Real-world examples and best practices

By the end, you'll know exactly which async tool to use for any situation!

## Understanding Async Programming

### What is Asynchronous?

Imagine you're at a restaurant:

**Synchronous (Waiting in Line):**
```
You: "I want a burger" 🍔
Cook: "Okay, wait right here..."
You: *stands and waits for 10 minutes* 😴
Cook: "Here's your burger!"
You: *finally can do next thing*
```

**Asynchronous (Order and Go):**
```
You: "I want a burger" 🍔
Cook: "Sure! I'll call your name when it's ready"
You: *sits down, reads a book, plays games* 📖🎮
        ... 10 minutes later ...
Cook: "John! Your burger is ready!" 🔔
You: *picks up burger*
```

**In programming:**
- **Synchronous** = Wait for each task to finish before starting next one
- **Asynchronous** = Start a task, do other things, get notified when it's done

### Why We Need Async

```dart
// ❌ BAD: Synchronous (app freezes)
void loadData() {
  print('Start loading...');

  // This takes 5 seconds and FREEZES the app
  final data = downloadLargeFile();  // 😱 App frozen for 5 seconds!

  print('Done loading!');
  showData(data);
}

// User Experience:
// - Tap button
// - App FREEZES for 5 seconds (can't scroll, can't tap anything!)
// - Finally shows data
// ❌ BAD!


// ✅ GOOD: Asynchronous (app stays smooth)
Future<void> loadData() async {
  print('Start loading...');

  // This takes 5 seconds but doesn't freeze
  final data = await downloadLargeFile();  // ✅ App still responsive!

  print('Done loading!');
  showData(data);
}

// User Experience:
// - Tap button
// - Sees loading spinner
// - Can still scroll, tap other things
// - Data appears when ready
// ✅ GOOD!
```

## Part 1: Futures - The Complete Guide

### What is a Future?

A **Future** is like a promise: "I'll give you a value... in the future!"

Think of it like ordering a package online:
1. You order → **Future starts**
2. Package is being shipped → **Future is pending**
3. Package arrives! → **Future completes** with the package

```dart
Future<String> orderPackage() {
  // Returns a "promise" of a String
  return Future.delayed(
    Duration(seconds: 2),
    () => 'Your package!',
  );
}
```

### Future States

A Future has 3 possible states:

```dart
// 1. UNCOMPLETED (Pending)
final future = fetchData();  // Started, but not done yet

// 2. COMPLETED WITH VALUE (Success)
final result = await future;  // Got the data! ✅

// 3. COMPLETED WITH ERROR (Failure)
try {
  final result = await future;
} catch (e) {
  // Something went wrong! ❌
}
```

### Creating Futures

#### 1. Using async/await

```dart
// Mark function as 'async'
Future<String> fetchUsername() async {
  // Simulate network delay
  await Future.delayed(Duration(seconds: 2));

  // Return value
  return 'John Doe';
}

// Using it:
void main() async {
  print('Fetching username...');

  final name = await fetchUsername();  // Wait for result

  print('Username: $name');
}

// Output:
// Fetching username...
// (2 seconds pass)
// Username: John Doe
```

**What's happening:**
1. `async` = This function returns a Future
2. `await` = Pause here and wait for result
3. Code looks synchronous but runs asynchronously!

#### 2. Using Future.delayed()

```dart
Future<int> calculateSlowly() {
  return Future.delayed(
    Duration(seconds: 3),
    () => 42,  // Return value after delay
  );
}
```

#### 3. Using Future.value() for Immediate Values

```dart
Future<String> getName() {
  return Future.value('Alice');  // Completes immediately
}
```

#### 4. Using Future.error() for Immediate Errors

```dart
Future<int> failImmediately() {
  return Future.error('Something went wrong!');
}
```

### Error Handling with Futures

#### Using try-catch

```dart
Future<void> loadData() async {
  try {
    final data = await fetchData();
    print('Success: $data');
  } catch (e) {
    print('Error: $e');
  }
}
```

#### Using .catchError()

```dart
fetchData()
  .then((data) {
    print('Success: $data');
  })
  .catchError((error) {
    print('Error: $error');
  });
```

#### Using .whenComplete() (like 'finally')

```dart
fetchData()
  .then((data) => print('Success: $data'))
  .catchError((error) => print('Error: $error'))
  .whenComplete(() => print('Cleanup!'));  // Always runs
```

### Future Combinators

#### 1. Future.wait() - Wait for All

Wait for multiple Futures to complete:

```dart
Future<void> loadMultipleThings() async {
  print('Loading...');

  final results = await Future.wait([
    fetchUser(),      // Takes 2 seconds
    fetchProducts(),  // Takes 3 seconds
    fetchOrders(),    // Takes 1 second
  ]);

  // All done after 3 seconds (not 6!)
  final user = results[0];
  final products = results[1];
  final orders = results[2];

  print('All loaded!');
}
```

**Think of it like:**
- Washing dishes while laundry runs
- Both finish when the slower one (laundry) is done
- Total time = max(dish time, laundry time), not sum!

#### 2. Future.any() - First to Complete

Get the result from whichever Future finishes first:

```dart
Future<String> getDataFast() async {
  final result = await Future.any([
    fetchFromServer1(),  // Might be slow
    fetchFromServer2(),  // Might be slow
    fetchFromCache(),    // Usually fast!
  ]);

  // Returns whichever completes first
  return result;
}
```

#### 3. Future.forEach() - Process Sequentially

```dart
Future<void> processUsers(List<String> userIds) async {
  await Future.forEach(userIds, (String id) async {
    final user = await fetchUser(id);
    await saveUser(user);
    print('Processed: $id');
  });

  print('All users processed!');
}
```

#### 4. Future.timeout() - Give Up After Time

```dart
Future<String> fetchWithTimeout() async {
  try {
    final data = await fetchData().timeout(
      Duration(seconds: 5),
      onTimeout: () => throw TimeoutException('Took too long!'),
    );
    return data;
  } catch (e) {
    print('Timeout or error: $e');
    return 'default data';
  }
}
```

### Complete Future Example

```dart
class UserService {
  // Simulate fetching user from API
  Future<User> fetchUser(String id) async {
    print('Fetching user $id...');

    // Simulate network delay
    await Future.delayed(Duration(seconds: 2));

    // Simulate random failures
    if (Random().nextBool()) {
      throw Exception('Network error!');
    }

    return User(id: id, name: 'John Doe', age: 30);
  }

  // Fetch multiple users in parallel
  Future<List<User>> fetchMultipleUsers(List<String> ids) async {
    try {
      final users = await Future.wait(
        ids.map((id) => fetchUser(id)),
      );
      return users;
    } catch (e) {
      print('Failed to fetch some users: $e');
      return [];
    }
  }

  // Fetch with timeout and retry
  Future<User> fetchUserWithRetry(String id, {int retries = 3}) async {
    for (int attempt = 1; attempt <= retries; attempt++) {
      try {
        print('Attempt $attempt of $retries');

        final user = await fetchUser(id).timeout(
          Duration(seconds: 5),
        );

        return user;  // Success!

      } catch (e) {
        print('Attempt $attempt failed: $e');

        if (attempt == retries) {
          throw Exception('Failed after $retries attempts');
        }

        // Wait before retrying
        await Future.delayed(Duration(seconds: 2));
      }
    }

    throw Exception('Should never reach here');
  }
}

class User {
  final String id;
  final String name;
  final int age;

  User({required this.id, required this.name, required this.age});
}
```

## Part 2: Streams - The Complete Guide

### What is a Stream?

A **Stream** is like a conveyor belt or water pipe - values keep coming over time.

**Future vs Stream:**

```dart
// FUTURE: One-time thing (like a package delivery)
Future<String> getPackage() async {
  await Future.delayed(Duration(seconds: 2));
  return 'One package';  // Returns ONCE
}

// STREAM: Ongoing thing (like a video stream or live sports)
Stream<String> getMessages() async* {
  yield 'Message 1';
  await Future.delayed(Duration(seconds: 1));

  yield 'Message 2';
  await Future.delayed(Duration(seconds: 1));

  yield 'Message 3';
  // Can keep going forever!
}
```

**Real-life examples:**
- **Future**: Download a file (happens once)
- **Stream**: Live chat messages (keep coming)
- **Future**: Check temperature (snapshot)
- **Stream**: Monitor temperature (continuous updates)

### Creating Streams

#### 1. Using async* and yield

```dart
Stream<int> countStream(int max) async* {
  for (int i = 1; i <= max; i++) {
    yield i;  // Send value to stream
    await Future.delayed(Duration(seconds: 1));
  }
}

// Using it:
void main() async {
  await for (final number in countStream(5)) {
    print(number);
  }
}

// Output (one per second):
// 1
// 2
// 3
// 4
// 5
```

#### 2. Using Stream.periodic()

```dart
// Emit value every second
Stream<int> timerStream() {
  return Stream.periodic(
    Duration(seconds: 1),
    (count) => count,  // 0, 1, 2, 3, ...
  );
}
```

#### 3. Using Stream.fromIterable()

```dart
Stream<String> namesStream() {
  return Stream.fromIterable(['Alice', 'Bob', 'Charlie']);
}
```

#### 4. Using Stream.fromFuture()

```dart
Stream<String> dataStream() {
  return Stream.fromFuture(fetchData());
}
```

### Listening to Streams

#### 1. Using await for

```dart
void listenToStream() async {
  final stream = countStream(3);

  await for (final value in stream) {
    print('Received: $value');
  }

  print('Stream done!');
}
```

#### 2. Using listen()

```dart
void listenToStream() {
  final stream = countStream(3);

  stream.listen(
    (value) {
      print('Received: $value');
    },
    onError: (error) {
      print('Error: $error');
    },
    onDone: () {
      print('Stream done!');
    },
  );
}
```

### Stream Types

#### Single-Subscription Stream

Can only be listened to ONCE:

```dart
final stream = Stream.fromIterable([1, 2, 3]);

stream.listen((value) => print('Listener 1: $value'));

// ❌ ERROR! Can't listen again
// stream.listen((value) => print('Listener 2: $value'));
```

#### Broadcast Stream

Can be listened to MULTIPLE times:

```dart
final controller = StreamController<int>.broadcast();

controller.stream.listen((value) => print('Listener 1: $value'));
controller.stream.listen((value) => print('Listener 2: $value'));

controller.add(1);  // Both listeners receive it
controller.add(2);

// Output:
// Listener 1: 1
// Listener 2: 1
// Listener 1: 2
// Listener 2: 2
```

### Stream Transformations

#### 1. map() - Transform Values

```dart
final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

final doubled = numbers.map((n) => n * 2);

await for (final value in doubled) {
  print(value);  // 2, 4, 6, 8, 10
}
```

#### 2. where() - Filter Values

```dart
final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

final evenNumbers = numbers.where((n) => n % 2 == 0);

await for (final value in evenNumbers) {
  print(value);  // 2, 4
}
```

#### 3. take() - Limit Number of Values

```dart
final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

final firstThree = numbers.take(3);

await for (final value in firstThree) {
  print(value);  // 1, 2, 3
}
```

#### 4. skip() - Skip Values

```dart
final numbers = Stream.fromIterable([1, 2, 3, 4, 5]);

final skipTwo = numbers.skip(2);

await for (final value in skipTwo) {
  print(value);  // 3, 4, 5
}
```

#### 5. distinct() - Remove Duplicates

```dart
final numbers = Stream.fromIterable([1, 2, 2, 3, 3, 3, 4]);

final unique = numbers.distinct();

await for (final value in unique) {
  print(value);  // 1, 2, 3, 4
}
```

## Part 3: Future vs Stream - When to Use Which?

### Use Future When:

✅ One-time operation
✅ Single value expected
✅ Like a question with one answer

```dart
// ✅ PERFECT for Future
Future<User> login(String email, String password) async { ... }
Future<List<Product>> getProducts() async { ... }
Future<bool> saveData(String data) async { ... }
```

### Use Stream When:

✅ Multiple values over time
✅ Continuous updates
✅ Like a subscription or live feed

```dart
// ✅ PERFECT for Stream
Stream<Message> chatMessages() { ... }
Stream<Location> locationUpdates() { ... }
Stream<int> timerTicks() { ... }
Stream<SearchResult> searchAsYouType(String query) { ... }
```

### Comparison Table

| Feature | Future | Stream |
|---------|--------|--------|
| **Values** | One | Many |
| **When** | Once | Over time |
| **Example** | Download file | Live chat |
| **Syntax** | `async/await` | `async*/yield` |
| **Listen** | `.then()` or `await` | `.listen()` or `await for` |
| **Error** | try-catch | onError callback |

### Real-World Examples

```dart
// ❌ BAD: Using Future for continuous data
Future<List<Message>> getMessages() async {
  // Returns snapshot, but new messages won't appear!
  return await fetchMessages();
}

// ✅ GOOD: Using Stream for continuous data
Stream<Message> getMessages() {
  // New messages appear as they arrive!
  return firestore.collection('messages').snapshots();
}


// ❌ BAD: Using Stream for one-time data
Stream<User> login(String email, String password) async* {
  // Overkill! We only need one result
  yield await authService.login(email, password);
}

// ✅ GOOD: Using Future for one-time data
Future<User> login(String email, String password) async {
  return await authService.login(email, password);
}
```

## Part 4: Converting Between Future and Stream

### Stream → Future

Get first value from Stream:

```dart
final stream = Stream.fromIterable([1, 2, 3]);
final firstValue = await stream.first;  // 1
```

Get last value:

```dart
final lastValue = await stream.last;  // 3
```

Convert to List:

```dart
final allValues = await stream.toList();  // [1, 2, 3]
```

### Future → Stream

```dart
final future = fetchData();
final stream = Stream.fromFuture(future);

await for (final value in stream) {
  print(value);  // Receives once when Future completes
}
```

## Exercises

### Exercise 1: Multiple API Calls
Fetch 3 different endpoints in parallel:
- Users
- Products
- Orders

Print when each finishes, and print when all finish.

### Exercise 2: Retry Logic
Create a function that retries a failed API call up to 3 times with exponential backoff (1s, 2s, 4s).

### Exercise 3: Timeout Handler
Create a function that fetches data but gives up after 5 seconds and returns cached data.

### Exercise 4: Stream Counter
Create a Stream that emits a countdown from 10 to 0, one number per second.

### Exercise 5: Stream Filtering
Create a Stream of random numbers (0-100) and filter out all numbers less than 50.

## What You've Learned

✅ What asynchronous programming is and why it's critical
✅ Understanding Futures in depth
✅ Understanding Streams in depth
✅ When to use Futures vs Streams
✅ async/await patterns
✅ Future combinators (wait, any, forEach, timeout)
✅ Stream transformations (map, where, take, skip)
✅ Error handling in async code
✅ Converting between Futures and Streams

## Next Steps

In the next lesson, we'll dive deeper into:
- **StreamControllers** - Creating your own streams
- **Broadcast vs Single-Subscription streams**
- **Stream manipulation**
- **Building a real-time chat app**

You're becoming an async master! 🚀
