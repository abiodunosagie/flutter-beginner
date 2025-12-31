# Part 1: Understanding Variables

## What Is a Variable?

A **variable** is a container that holds a piece of information. Think of it as a labeled box where you store something.

```
┌─────────────┐
│    "Alex"   │  ← The value inside
├─────────────┤
│    name     │  ← The label (variable name)
└─────────────┘
```

In real life:
- A **name tag** holds your name
- A **wallet** holds your money
- A **phone contact** holds a phone number

In programming:
- A **variable** holds data (text, numbers, true/false, etc.)

---

## Creating Your First Variable

### The Basic Pattern

```dart
type name = value;
```

- **type** - What kind of data it holds
- **name** - What you call it
- **value** - What's inside

### Your First String Variable

```dart
String name = 'Alex';
```

Let's break this down:
- `String` = This variable holds text
- `name` = We're calling this variable "name"
- `=` = Assignment operator (puts value into variable)
- `'Alex'` = The actual text we're storing
- `;` = End of statement

### Try It!

```dart
void main() {
  String name = 'Alex';
  print(name);  // Output: Alex
}
```

---

## Changing Variable Values

Variables can change (that's why they're called "variables"):

```dart
void main() {
  String favoriteColor = 'blue';
  print(favoriteColor);  // Output: blue

  favoriteColor = 'red';
  print(favoriteColor);  // Output: red
}
```

---

## Practice Exercise

Create three String variables:
1. Your name
2. Your favorite food
3. Your city

Print all three.

---

**Next:** Learn about different types of data you can store!

**Continue to:** `02b-DataTypes.md`
