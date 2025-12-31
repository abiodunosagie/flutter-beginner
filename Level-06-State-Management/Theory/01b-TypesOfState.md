# Part 2: Two Types of State

Now you know what state is! But here's the thing: there are **TWO types** of state in Flutter. Let's learn when to use each one.

---

## Type 1: Local State (Just for ONE Widget)

**Local state** is like a secret that only ONE person knows.

### Example: Password Visibility

Think about a password field where you can click an eye icon to show/hide the password:

```
[••••••••] 👁️  →  Click eye  →  [password] 👁️‍🗨️
```

**Who cares if the password is visible?**
- ✅ Only the password field itself
- ❌ NOT the rest of the app
- ❌ NOT other screens

This is **local state**!

```dart
class PasswordField extends StatefulWidget {
  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  // This state is LOCAL - only this widget cares!
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: !_isPasswordVisible,  // Hide or show password
      decoration: InputDecoration(
        suffixIcon: IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;  // Toggle!
            });
          },
        ),
      ),
    );
  }
}
```

### More Examples of Local State:

- Is a dropdown menu open or closed? ✅ Local state
- Current page in a photo carousel? ✅ Local state
- Is a panel expanded or collapsed? ✅ Local state
- Text you're typing (before saving)? ✅ Local state

**Use `setState` for local state!**

---

## Type 2: App State (Shared by MANY Widgets)

**App state** is like news that EVERYONE in your family needs to know.

### Example: Shopping Cart

Think about items in your shopping cart:

```
┌─────────────────────────────────┐
│         Shopping Cart           │
│         (3 items)               │  ← Cart icon shows count
└─────────────────────────────────┘
```

**Who needs to know about cart items?**
- ✅ The cart icon (shows number of items)
- ✅ The cart page (shows all items)
- ✅ The checkout page (shows total price)
- ✅ Product pages (to show if item is in cart)

MANY widgets need this information! This is **app state**!

```
          ┌─────────────┐
          │  Cart Items │ ← State lives here
          │   = 3       │
          └─────────────┘
               │
      ┌────────┼────────┐
      │        │        │
      ▼        ▼        ▼
   ┌─────┐  ┌─────┐  ┌──────┐
   │Home │  │Cart │  │Product│
   │Page │  │Page │  │ Page  │
   └─────┘  └─────┘  └──────┘

All these pages need to access the same cart!
```

### More Examples of App State:

- Is the user logged in? ✅ App state (many screens need this)
- User's profile info? ✅ App state (shown in many places)
- App theme (dark/light)? ✅ App state (affects everything)
- Notification count? ✅ App state (shown in multiple places)
- Favorites list? ✅ App state (multiple screens use it)

**Use state management (Provider/Riverpod/BLoC) for app state!**

---

## How to Decide: Local or App State?

Ask yourself ONE question:

### "Does only ONE widget need this?"

```
YES → Local State (use setState)
 NO → App State (use state management)
```

### Examples:

| State | Question | Answer | Type |
|-------|----------|--------|------|
| Password visible? | Does only the password field need this? | YES | Local (setState) |
| User logged in? | Does only one widget need this? | NO (many need it) | App (Provider) |
| Dropdown expanded? | Does only the dropdown need this? | YES | Local (setState) |
| Cart items? | Does only one widget need this? | NO (many need it) | App (Provider) |
| Current tab? | Does only the tab bar need this? | YES | Local (setState) |
| Dark mode on? | Does only one widget need this? | NO (whole app needs it) | App (Provider) |

---

## Visual Comparison

### Local State:
```
┌────────────────────────┐
│   Password Field       │
│                        │
│   State lives HERE     │
│   [••••••] 👁️          │
│                        │
│   Nobody else can      │
│   access this state!   │
└────────────────────────┘
```

### App State:
```
        ┌─────────────┐
        │ USER DATA   │ ← State lives in one place
        │ name: "Alex"│
        └─────────────┘
             │
    ┌────────┼────────┐
    │        │        │
    ▼        ▼        ▼
 ┌──────┐┌──────┐┌──────┐
 │Header││Profile││Settings│
 │      ││       ││        │
 │Hello,││Name:  ││Edit    │
 │Alex! ││Alex   ││Alex    │
 └──────┘└──────┘└──────┘

 All widgets can access the same state!
```

---

## Real App Example: Todo List

Let's see both types in action:

```dart
// APP STATE: The todo items
// (Many widgets need to access this)
List<Todo> allTodos = [
  Todo(title: "Buy milk"),
  Todo(title: "Walk dog"),
];

// LOCAL STATE: Is the add todo dialog showing?
// (Only one widget cares about this)
bool isDialogShowing = false;

// LOCAL STATE: Text being typed in the add dialog
// (Only the dialog cares about this)
String newTodoText = "";
```

---

## Summary Table

| Local State | App State |
|-------------|-----------|
| One widget only | Multiple widgets |
| Use `setState` | Use Provider/Riverpod/BLoC |
| Examples: expanded panels, current page | Examples: user data, cart, settings |
| Fast and simple | More setup, but powerful |
| Doesn't survive navigation | Survives across screens |

---

## Key Takeaways

1. **Local State** = Only one widget needs it (use `setState`)
2. **App State** = Many widgets need it (use state management)
3. Ask: "Does only ONE widget need this?" to decide which to use

---

**Next:** Learn why setState alone isn't enough for app state!

---

## Navigation

⬅️ **Previous:** [What is State?](01a-WhatIsState.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [The Problem with setState](01c-TheProblem.md)
