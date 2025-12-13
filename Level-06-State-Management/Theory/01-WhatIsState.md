# What Is State? Understanding the Foundation

Before we learn Provider, Riverpod, or BLoC, we need to understand what "state" actually means. This is the most important concept to grasp!

---

## State: The Simple Explanation

Imagine you have a light switch in your room.

```
OFF                    ON
 ○                     ●
 │                     │
 Switch down           Switch up
```

The **state** of your light is either "ON" or "OFF". That's it!

In programming, **state** is simply **data that can change over time**.

---

## State in Flutter

Think about a shopping app:

```
┌─────────────────────────────────┐
│        Shopping Cart            │
│                                 │
│  🍎 Apple        $1.00    [x]  │
│  🍌 Banana       $0.50    [x]  │
│  🍊 Orange       $0.75    [x]  │
│                                 │
│  Total: $2.25                   │
│                                 │
│  Items in cart: 3               │
└─────────────────────────────────┘
```

What can change here?
- ✅ Items in the cart (can add/remove)
- ✅ Total price (changes when items change)
- ✅ Number of items (changes when items change)

All of these are **state**!

---

## Types of State

### 1. Ephemeral State (Local/UI State)

This is state that belongs to **ONE widget only**.

Think of it like a secret that only one person knows.

```dart
// Example: Is the password visible or hidden?
class PasswordField extends StatefulWidget {
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _isPasswordVisible = false;  // Only this widget cares!

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !_isPasswordVisible,
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
            });
          },
        ),
      ),
    );
  }
}
```

**Use setState for ephemeral state!** It's perfect for:
- Is a panel expanded or collapsed?
- Current page in a PageView
- Current tab selection
- Text field value while typing

### 2. App State (Shared State)

This is state that **multiple widgets need to access**.

Think of it like news that everyone in your family needs to know.

```
┌─────────────────────────────────────────┐
│                App State                │
│                                         │
│   • User logged in? (many screens need) │
│   • Shopping cart (shown in header)     │
│   • Theme (dark/light for whole app)    │
│   • Notifications (badge count)         │
│                                         │
└─────────────────────────────────────────┘
         │           │           │
         ▼           ▼           ▼
    ┌────────┐  ┌────────┐  ┌────────┐
    │ Home   │  │ Cart   │  │Profile │
    │ Screen │  │ Screen │  │ Screen │
    └────────┘  └────────┘  └────────┘

All these screens need to know the same information!
```

**Use state management (Provider/Riverpod/BLoC) for app state!**

---

## The Problem with Just Using setState

Let's say you have a counter that needs to be shown on 3 different screens:

### The Wrong Way (Prop Drilling)

```dart
// Main app has the counter
class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int counter = 0;  // State lives here

  void incrementCounter() {
    setState(() {
      counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(
        counter: counter,                    // Pass down
        onIncrement: incrementCounter,       // Pass down
      ),
    );
  }
}

// Home page receives and passes down
class HomePage extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;

  const HomePage({
    required this.counter,
    required this.onIncrement,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          HeaderWidget(counter: counter),           // Pass to header
          ContentWidget(                            // Pass to content
            counter: counter,
            onIncrement: onIncrement,
          ),
          FooterWidget(counter: counter),           // Pass to footer
        ],
      ),
    );
  }
}

// Each widget receives data it might not even use!
class ContentWidget extends StatelessWidget {
  final int counter;
  final VoidCallback onIncrement;
  // ... has to pass these to its children too!
}
```

### Problems with This Approach:

```
1. TOO MUCH PASSING
   ─────────────────
   Data passes through widgets that don't even use it!

   App → HomePage → ContentWidget → ButtonSection → ActualButton
         (doesn't    (doesn't         (doesn't       (finally
          use it)     use it)          use it)        uses it!)


2. MESSY CODE
   ──────────
   Every widget has extra parameters.
   Changing the state structure requires changing MANY files.


3. REBUILDING EVERYTHING
   ─────────────────────
   When counter changes, the ENTIRE tree rebuilds!
   Even widgets that don't show the counter!

   ┌──────────────────────┐
   │  Parent (rebuilds)   │
   │  ┌────────────────┐  │
   │  │Child (rebuilds)│  │
   │  │ ┌────────────┐ │  │
   │  │ │  (rebuilds)│ │  │
   │  │ └────────────┘ │  │
   │  └────────────────┘  │
   └──────────────────────┘

   Very inefficient!
```

---

## The Solution: State Management

State management tools solve these problems:

```
┌────────────────────────────────────────────┐
│                                            │
│         STATE MANAGEMENT                   │
│         ┌──────────────┐                   │
│         │   counter    │ ◄── Single place  │
│         │   = 5        │     for data      │
│         └──────────────┘                   │
│                │                           │
│      Direct access! No passing!            │
│         ┌──────┼──────┐                    │
│         │      │      │                    │
│         ▼      ▼      ▼                    │
│      ┌─────┐┌─────┐┌─────┐                 │
│      │Head ││Body ││Foot │                 │
│      │ er  ││     ││ er  │                 │
│      └─────┘└─────┘└─────┘                 │
│                                            │
│  Only widgets that USE the data rebuild!   │
│                                            │
└────────────────────────────────────────────┘
```

### Benefits:

1. **No Prop Drilling** - Widgets get data directly
2. **Clean Code** - Less parameters, clearer structure
3. **Efficient Rebuilds** - Only affected widgets rebuild
4. **Easy Testing** - State is separate from UI
5. **Scalability** - Works for large apps

---

## Real-World Example: Online Store

Let's see how state flows in a real app:

```
┌──────────────────────────────────────────────────┐
│                 ONLINE STORE APP                 │
├──────────────────────────────────────────────────┤
│                                                  │
│  APP STATE (shared by many screens):             │
│  ┌────────────────────────────────────────────┐  │
│  │ • currentUser: User(name: "John", id: 1)   │  │
│  │ • cartItems: [Shoe, Shirt, Hat]            │  │
│  │ • cartTotal: $150.00                       │  │
│  │ • wishlist: [Watch, Bag]                   │  │
│  │ • isDarkMode: false                        │  │
│  └────────────────────────────────────────────┘  │
│                                                  │
│  UI STATE (local to each screen):                │
│  ┌─────────────┐ ┌─────────────┐ ┌────────────┐  │
│  │ Home Screen │ │Product Page │ │ Cart Page  │  │
│  │             │ │             │ │            │  │
│  │ • search    │ │ • selected  │ │ • editing  │  │
│  │   query     │ │   size      │ │   item     │  │
│  │ • current   │ │ • selected  │ │ • showing  │  │
│  │   filter    │ │   color     │ │   promo    │  │
│  │ • scroll    │ │ • zoomed    │ │   code     │  │
│  │   position  │ │   image     │ │   input    │  │
│  └─────────────┘ └─────────────┘ └────────────┘  │
│                                                  │
└──────────────────────────────────────────────────┘
```

### Which state management for what?

| State | Type | Solution |
|-------|------|----------|
| Current user | App state | Provider/Riverpod/BLoC |
| Cart items | App state | Provider/Riverpod/BLoC |
| Search query | UI state | setState |
| Selected size | UI state | setState |
| Scroll position | UI state | ScrollController |

---

## State Flow: How Changes Happen

```
1. USER DOES SOMETHING
   ────────────────────
   User taps "Add to Cart"
          │
          ▼

2. ACTION/EVENT IS SENT
   ────────────────────
   "Hey, add this item to cart!"
          │
          ▼

3. STATE IS UPDATED
   ────────────────────
   cartItems: [..., newItem]
   cartTotal: calculateNew()
          │
          ▼

4. UI IS NOTIFIED
   ────────────────────
   "State changed! Rebuild!"
          │
          ▼

5. WIDGETS REBUILD
   ────────────────────
   Cart icon shows "4"
   Cart page shows new item
```

This flow is the same for Provider, Riverpod, and BLoC!

---

## Thinking in State

Before building any feature, ask yourself:

### Question 1: What data can change?

```
Feature: User Profile Screen

Data that changes:
✓ User name (can be edited)
✓ Profile picture (can be changed)
✓ Bio (can be updated)
✓ Is editing mode on?

Data that doesn't change:
✗ User ID (fixed)
✗ Account creation date (fixed)
```

### Question 2: Who needs this data?

```
User name:
├── Profile screen (shows it)
├── Settings screen (shows it)
├── Comment widget (shows it)
└── Navigation drawer (shows it)

→ Multiple widgets = App State (use state management)


Is editing mode on:
└── Profile screen only

→ One widget = UI State (use setState)
```

### Question 3: When does it change?

```
Cart total:
├── When item added
├── When item removed
├── When quantity changed
└── When promo applied

→ Define these as EVENTS or ACTIONS
```

---

## Summary: The State Checklist

Before writing code, answer these:

| Question | Answer | Use |
|----------|--------|-----|
| Does only ONE widget use this? | Yes | setState |
| Do MULTIPLE widgets need this? | Yes | State management |
| Does it need to survive navigation? | Yes | State management |
| Is it just animation/UI feedback? | Yes | setState or controller |
| Is it user data, settings, cart? | Yes | State management |

---

## What's Next?

Now that you understand state, we'll learn three ways to manage it:

1. **Provider** (Next) - The simplest approach
2. **Riverpod** - More powerful, type-safe
3. **BLoC** - Event-driven, great for complex apps

Each has its strengths. Learn all three to pick the right tool!

---

## Quick Quiz

**Q1:** What is "state" in programming?

<details>
<summary>Answer</summary>

State is data that can change over time. It's any information your app needs to remember and potentially update, like user preferences, cart items, or whether a panel is expanded.

</details>

**Q2:** What's the difference between UI state and App state?

<details>
<summary>Answer</summary>

- **UI state (Ephemeral)**: Data only one widget cares about. Use setState.
- **App state (Shared)**: Data multiple widgets need. Use state management.

Example: "Is password visible?" is UI state. "User logged in?" is app state.

</details>

**Q3:** What is "prop drilling" and why is it bad?

<details>
<summary>Answer</summary>

Prop drilling is passing data through many widgets just to get it to a widget deep in the tree. It's bad because:
1. Creates messy code with lots of parameters
2. Widgets get data they don't even use
3. Hard to maintain and refactor
4. Causes unnecessary rebuilds

</details>

---

**Next:** Learn Provider, the simplest state management solution.

---

**Continue to:** `02-ProviderBasics.md`
