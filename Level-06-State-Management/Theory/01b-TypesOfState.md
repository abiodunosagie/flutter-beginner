# Two Types of State

## The Big Idea In One Sentence

> Some state belongs to **one widget** (local state, use `setState`), and some state is shared by **many widgets** (app state, which needs the tools in this level).

Now you know what state is. The next question is who needs it, because that decides how you manage it.

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

## Quick Quiz

**Q1.** What is the one question that decides local vs app state?

<details>
<summary>Answer</summary>
"Does only one widget need this?" Yes means local state (`setState`); no means app state (a state-management tool).
</details>

**Q2.** Which tool do you use for local state?

<details>
<summary>Answer</summary>
`setState`, the one you learned in Level 5.
</details>

**Q3.** Is "is the user logged in?" local or app state?

<details>
<summary>Answer</summary>
App state. Many screens need to know it (the header, the profile page, protected pages), so it should be shared.
</details>

---

## Assignment

These are about deciding, no coding needed.

### Problem 1: Local or app state?

For each, say **local** or **app** state, and why in a few words:

1. Whether a password field is showing its text.
2. The list of items in a shopping cart.
3. Whether a single FAQ panel is expanded.
4. The app's dark/light theme.
5. The current page of a photo carousel.

### Problem 2: A chat app

Name two pieces of **app state** (shared by many widgets) in a chat app, and one piece of **local state** (only one widget cares).

### Problem 3: Pick the tool

For each, say whether you would use `setState` or a state-management tool:

1. A "show more" toggle on one card.
2. The logged-in user, shown on five screens.

---

## Assignment Answers

### Problem 1: Local or app state?

1. Password showing -> **local** (only that field cares).
2. Cart items -> **app** (the cart icon, cart page, and checkout all need it).
3. One FAQ panel expanded -> **local** (only that panel cares).
4. Dark/light theme -> **app** (it affects the whole app).
5. Carousel page -> **local** (only that carousel cares).

The test is always: does more than one widget need it?

### Problem 2: A chat app

App state (shared): the list of messages, the current user, the unread count. Local state (one widget): the text being typed in the message box before it is sent. (Other reasonable answers are fine.)

### Problem 3: Pick the tool

1. A toggle on one card -> `setState` (local).
2. The logged-in user on five screens -> a state-management tool (app state).

---

**Next:** `01c-TheProblem.md`, which shows why `setState` alone is not enough for app state.

---

## Navigation

⬅️ **Previous:** [What is State?](01a-WhatIsState.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [The Problem with setState](01c-TheProblem.md)
