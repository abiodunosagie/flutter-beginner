# SharedPreferences: Your App's Sticky Notes

## The Big Idea In One Sentence

> SharedPreferences saves small bits of data by a key (`setString('name', 'Alex')`) and reads them back by the same key (`getString('name')`), perfect for simple settings.

## The Simple Explanation

Imagine you have a sticky note on your refrigerator. You write:
- "Buy milk"
- "Call grandma"
- "Feed the cat"

Every time you walk by, you can read it. Even the next day, it's still there!

**SharedPreferences is like sticky notes for your app!**

```
┌─────────────────────────────────────────┐
│     🧊 YOUR PHONE (the fridge)          │
│                                         │
│     📝 SharedPreferences (sticky note)  │
│     ┌─────────────────────────────┐     │
│     │ userName = "Alex"           │     │
│     │ isDarkMode = true           │     │
│     │ volume = 80                 │     │
│     │ isLoggedIn = true           │     │
│     └─────────────────────────────┘     │
│                                         │
└─────────────────────────────────────────┘
```

---

## What Can You Store?

SharedPreferences stores simple things:

### Yes ✅ (Good for SharedPreferences)
```
• Strings (text):     "Alex", "Hello World"
• Numbers (int):      42, 100, -5
• Decimals (double):  3.14, 99.99
• True/False (bool):  true, false
• Lists of strings:   ["apple", "banana", "cherry"]
```

### No ❌ (NOT good for SharedPreferences)
```
• Images
• Complex objects (like a User class)
• Lists of numbers
• Thousands of items
```

Think of it this way:
```
If it fits on a sticky note → Use SharedPreferences ✅
If you need a filing cabinet → Use SQLite instead ❌
```

---

## How It Works: Keys and Values

Every piece of data has a **key** (the label) and a **value** (what you're saving).

```
KEY (label)          VALUE (what you save)
─────────────        ────────────────────
"user_name"     →    "Alex"
"is_dark_mode"  →    true
"volume"        →    80
"last_login"    →    "2024-01-15"
```

It's like a dictionary or a phonebook:
- Look up "John" → Get his phone number
- Look up "user_name" → Get "Alex"

---

## Setting Up SharedPreferences

### Step 1: Add the Package

In your `pubspec.yaml` file:
```yaml
dependencies:
  flutter:
    sdk: flutter
  shared_preferences: ^2.2.2
```

Then run:
```bash
flutter pub get
```

### Step 2: Import It

At the top of your Dart file:
```dart
import 'package:shared_preferences/shared_preferences.dart';
```

---

## Saving Data (Writing Sticky Notes)

### Saving Different Types

```dart
// First, get access to SharedPreferences
final prefs = await SharedPreferences.getInstance();

// Save a String (text)
await prefs.setString('user_name', 'Alex');

// Save an int (whole number)
await prefs.setInt('age', 25);

// Save a double (decimal number)
await prefs.setDouble('height', 5.9);

// Save a bool (true/false)
await prefs.setBool('is_dark_mode', true);

// Save a list of strings
await prefs.setStringList('fruits', ['apple', 'banana', 'cherry']);
```

### Visual Explanation

```
YOUR CODE:
prefs.setString('user_name', 'Alex');

WHAT HAPPENS:

┌───────────────────────────────────────────┐
│         SharedPreferences Box              │
│                                            │
│   Before:                                  │
│   ┌────────────────────────────────┐      │
│   │      (empty)                   │      │
│   └────────────────────────────────┘      │
│                                            │
│   After setString('user_name', 'Alex'):   │
│   ┌────────────────────────────────┐      │
│   │   user_name: "Alex"      ✓     │      │
│   └────────────────────────────────┘      │
│                                            │
└───────────────────────────────────────────┘
```

---

## Loading Data (Reading Sticky Notes)

### Reading Different Types

```dart
// First, get access to SharedPreferences
final prefs = await SharedPreferences.getInstance();

// Read a String (returns null if not found)
String? userName = prefs.getString('user_name');
// userName = "Alex" (or null if never saved)

// Read an int (returns null if not found)
int? age = prefs.getInt('age');
// age = 25 (or null if never saved)

// Read a double
double? height = prefs.getDouble('height');
// height = 5.9 (or null if never saved)

// Read a bool
bool? isDarkMode = prefs.getBool('is_dark_mode');
// isDarkMode = true (or null if never saved)

// Read a list of strings
List<String>? fruits = prefs.getStringList('fruits');
// fruits = ['apple', 'banana', 'cherry'] (or null)
```

### What If the Data Doesn't Exist?

```dart
// If you never saved 'user_name', it returns null
String? userName = prefs.getString('user_name');

if (userName == null) {
  print("No name saved yet!");
} else {
  print("Welcome back, $userName!");
}

// OR use a default value:
String userName = prefs.getString('user_name') ?? 'Guest';
// If null, use 'Guest' instead
```

---

## Complete Example: Remembering User's Name

```dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GreetingApp extends StatefulWidget {
  const GreetingApp({super.key});

  @override
  State<GreetingApp> createState() => _GreetingAppState();
}

class _GreetingAppState extends State<GreetingApp> {
  String _userName = 'Guest';  // Default name
  final _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserName();  // Load saved name when app starts
  }

  // LOAD the saved name
  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Guest';
    });
  }

  // SAVE the name
  Future<void> _saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user_name', name);
    setState(() {
      _userName = name;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Greeting App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Show greeting
            Text(
              'Hello, $_userName!',
              style: const TextStyle(fontSize: 24),
            ),

            const SizedBox(height: 20),

            // Text field to enter name
            Padding(
              padding: const EdgeInsets.all(16),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  labelText: 'Enter your name',
                  border: OutlineInputBorder(),
                ),
              ),
            ),

            // Save button
            ElevatedButton(
              onPressed: () {
                if (_controller.text.isNotEmpty) {
                  _saveUserName(_controller.text);
                }
              },
              child: const Text('Save My Name'),
            ),
          ],
        ),
      ),
    );
  }
}
```

### What This Code Does

```
1. App opens
       │
       ▼
2. _loadUserName() runs
       │
       ▼
3. Checks: Is there a saved name?
       │
       ├── YES → Shows "Hello, Alex!"
       │
       └── NO → Shows "Hello, Guest!"

4. User types a new name and taps "Save"
       │
       ▼
5. _saveUserName() runs
       │
       ▼
6. Name is saved to SharedPreferences
       │
       ▼
7. Next time app opens, step 3 finds the name!
```

---

## Common Use Cases

### 1. Remember Dark Mode Setting

```dart
// Save dark mode preference
Future<void> saveDarkMode(bool isDark) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('is_dark_mode', isDark);
}

// Load dark mode preference
Future<bool> loadDarkMode() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('is_dark_mode') ?? false;  // Default: light mode
}
```

### 2. Remember If User Has Seen Onboarding

```dart
// Save that user has seen onboarding
Future<void> setOnboardingComplete() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool('onboarding_complete', true);
}

// Check if user has seen onboarding
Future<bool> hasSeenOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool('onboarding_complete') ?? false;
}

// Usage:
if (await hasSeenOnboarding()) {
  // Go to home screen
} else {
  // Show onboarding
}
```

### 3. Remember Login Token

```dart
// Save login token
Future<void> saveToken(String token) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

// Get login token
Future<String?> getToken() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getString('auth_token');
}

// Check if logged in
Future<bool> isLoggedIn() async {
  final token = await getToken();
  return token != null;
}
```

### 4. Remember User's Volume Setting

```dart
// Save volume (0-100)
Future<void> saveVolume(int volume) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setInt('volume', volume);
}

// Load volume (default 50)
Future<int> loadVolume() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getInt('volume') ?? 50;
}
```

---

## Removing Data

Sometimes you want to delete saved data:

```dart
final prefs = await SharedPreferences.getInstance();

// Remove one key
await prefs.remove('user_name');  // Removes just the name

// Remove EVERYTHING
await prefs.clear();  // Removes all saved data!
```

When to remove:
- User logs out → Remove `auth_token`
- User wants to reset settings → `clear()` everything

---

## Best Practices

### 1. Use Constants for Keys

```dart
// ❌ BAD: Typing the key each time
prefs.setString('user_name', 'Alex');
prefs.getString('user_name');  // Easy to mistype!

// ✅ GOOD: Use constants
class StorageKeys {
  static const String userName = 'user_name';
  static const String isDarkMode = 'is_dark_mode';
  static const String volume = 'volume';
}

prefs.setString(StorageKeys.userName, 'Alex');
prefs.getString(StorageKeys.userName);  // No typos!
```

### 2. Create a Helper Class

```dart
class LocalStorage {
  static late SharedPreferences _prefs;

  // Initialize once when app starts
  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // User name
  static String get userName => _prefs.getString('user_name') ?? 'Guest';
  static set userName(String value) => _prefs.setString('user_name', value);

  // Dark mode
  static bool get isDarkMode => _prefs.getBool('is_dark_mode') ?? false;
  static set isDarkMode(bool value) => _prefs.setBool('is_dark_mode', value);

  // Volume
  static int get volume => _prefs.getInt('volume') ?? 50;
  static set volume(int value) => _prefs.setInt('volume', value);
}

// Usage:
// In main():
await LocalStorage.init();

// Anywhere in app:
String name = LocalStorage.userName;
LocalStorage.isDarkMode = true;
```

### 3. Load Once, Use Everywhere

```dart
// ❌ BAD: Getting instance every time
Future<void> loadData() async {
  final prefs = await SharedPreferences.getInstance();  // Slow!
  // ...
}

// ✅ GOOD: Get instance once
late SharedPreferences prefs;

Future<void> init() async {
  prefs = await SharedPreferences.getInstance();  // Once!
}
// Then use 'prefs' everywhere
```

---

## Common Mistakes

### Mistake 1: Forgetting await

```dart
// ❌ WRONG: Forgetting await
prefs.setString('name', 'Alex');  // Might not save!

// ✅ CORRECT: Using await
await prefs.setString('name', 'Alex');  // Definitely saves!
```

### Mistake 2: Wrong Type

```dart
// ❌ WRONG: Saving as int, reading as String
await prefs.setInt('age', 25);
String? age = prefs.getString('age');  // Returns null!

// ✅ CORRECT: Same type for save and load
await prefs.setInt('age', 25);
int? age = prefs.getInt('age');  // Returns 25!
```

### Mistake 3: Not Handling Null

```dart
// ❌ DANGEROUS: Not checking null
String userName = prefs.getString('user_name')!;  // Crashes if null!

// ✅ SAFE: Handle null with ??
String userName = prefs.getString('user_name') ?? 'Guest';
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│            SHAREDPREFERENCES SUMMARY                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  WHAT: Simple key-value storage (like sticky notes)     │
│                                                          │
│  SAVES:                                                  │
│  • Strings (text)                                        │
│  • Integers (whole numbers)                              │
│  • Doubles (decimal numbers)                             │
│  • Booleans (true/false)                                 │
│  • List of strings                                       │
│                                                          │
│  METHODS:                                                │
│  • setString / getString                                 │
│  • setInt / getInt                                       │
│  • setDouble / getDouble                                 │
│  • setBool / getBool                                     │
│  • setStringList / getStringList                         │
│  • remove / clear                                        │
│                                                          │
│  REMEMBER:                                               │
│  • Always use await!                                     │
│  • Handle null values with ??                            │
│  • Use constants for keys                                │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1:** What type should you use to save "is sound enabled: true"?

<details>
<summary>Answer</summary>

`setBool` - because true/false is a boolean!
```dart
await prefs.setBool('sound_enabled', true);
```

</details>

**Q2:** What does this return if 'user_name' was never saved?

```dart
String? name = prefs.getString('user_name');
```

<details>
<summary>Answer</summary>

It returns `null`. That's why we use `??` to provide a default:
```dart
String name = prefs.getString('user_name') ?? 'Guest';
```

</details>

**Q3:** What's wrong with this code?

```dart
prefs.setString('name', 'Alex');
String name = prefs.getString('name')!;
```

<details>
<summary>Answer</summary>

Two problems:
1. Missing `await` before `setString` - the save might not complete!
2. Using `!` instead of `??` - dangerous if null!

Correct code:
```dart
await prefs.setString('name', 'Alex');
String name = prefs.getString('name') ?? 'Guest';
```

</details>

---

## Assignment

### Problem 1: Save the right type

Write the line to save the user's volume of `75` (a whole number) under the key `'volume'`.

### Problem 2: Load with a default

Write the line that loads `'volume'` as an `int`, defaulting to `50` if it was never saved.

### Problem 3: Fix the bugs

This code has two bugs. Name them and fix it.

```dart
prefs.setInt('age', 25);
String age = prefs.getString('age')!;
```

---

## Assignment Answers

### Problem 1: Save the right type

```dart
await prefs.setInt('volume', 75);
```

### Problem 2: Load with a default

```dart
int volume = prefs.getInt('volume') ?? 50;
```

### Problem 3: Fix the bugs

Bugs: (1) missing `await` on `setInt`, so the save may not finish; (2) reading an int with `getString` and forcing it with `!`, which returns null and crashes. Fix:

```dart
await prefs.setInt('age', 25);
int age = prefs.getInt('age') ?? 0;
```

---

**Next:** Let's learn SQLite for storing lots of organized data!

---

**Continue to:** `03-SQLiteDatabase.md`
