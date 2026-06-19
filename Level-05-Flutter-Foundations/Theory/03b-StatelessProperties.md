# StatelessWidget Properties: Making Widgets Reusable

## The Big Idea In One Sentence

> Properties are values you pass **into** a widget, so the same widget can show different data.

In the last lesson your widgets had fixed content. Now you make them flexible.

---

## A Name Tag Maker

Imagine a name tag maker. You feed it a name, and it prints a tag:

```
give it 'Ada'  -> [ Hello, Ada! ]
give it 'Bola' -> [ Hello, Bola! ]
```

Same maker, different name. A widget with a property works exactly like that:

```dart
class NameTag extends StatelessWidget {
  final String name;                         // the property

  const NameTag({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');
  }
}

// Using it
NameTag(name: 'Ada')    // Hello, Ada!
NameTag(name: 'Bola')   // Hello, Bola!
```

This is the same `this.name` constructor idea from Level 4, now inside a widget.

---

## The Three Steps To Add A Property

```dart
class Greeting extends StatelessWidget {
  final String name;                            // 1. declare it (always final)

  const Greeting({super.key, required this.name}); // 2. add it to the constructor

  @override
  Widget build(BuildContext context) {
    return Text('Hello, $name!');               // 3. use it in build
  }
}
```

1. **Declare** the property as a `final` field.
2. **Add** it to the constructor with `this.name`.
3. **Use** it inside `build`.

That is the whole pattern. Every reusable widget follows it.

---

## Properties Must Be `final`

Every property in a StatelessWidget must be `final`. This is because a StatelessWidget never changes after it is built (remember: printed photo, not video). `final` enforces that.

```dart
class Good extends StatelessWidget {
  final String name;   // GOOD
  // ...
}

class Bad extends StatelessWidget {
  String name;         // BAD: not final, will not compile
  // ...
}
```

To show a different name, you do not change the widget. You build a new one with a different value.

---

## Required vs Optional Properties

You learned these in the Level 4 Constructors lesson; here they are inside widgets.

### Required (must be given)

```dart
class UserCard extends StatelessWidget {
  final String name;
  final int age;

  const UserCard({super.key, required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        Text('Age: $age'),
      ],
    );
  }
}

UserCard(name: 'Ada', age: 12)   // GOOD
UserCard(name: 'Ada')            // ERROR: age is required
```

### Optional (can be skipped)

Use a default value, or make it nullable with `?`.

```dart
class StyledText extends StatelessWidget {
  final String text;
  final double fontSize;        // optional, has a default

  const StyledText({
    super.key,
    required this.text,
    this.fontSize = 16,         // default if not given
  });

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: fontSize));
  }
}

StyledText(text: 'Hello')                  // size 16 (default)
StyledText(text: 'Hello', fontSize: 24)    // size 24
```

### Optional and possibly missing (nullable)

```dart
class ProfileCard extends StatelessWidget {
  final String name;
  final String? bio;            // optional, may be null

  const ProfileCard({super.key, required this.name, this.bio});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(name),
        if (bio != null) Text(bio!),   // only show the bio if there is one
      ],
    );
  }
}

ProfileCard(name: 'Ada')                       // no bio shown
ProfileCard(name: 'Bola', bio: 'Loves Dart')   // bio shown
```

> The `if (bio != null) Text(bio!)` inside `children` is a handy Flutter trick: you can put an `if` right in a list of children to include a widget only sometimes. The `!` says "I checked, it is not null here."

---

## Properties Can Be Any Type

```dart
class DataCard extends StatelessWidget {
  final String label;
  final int count;
  final double price;
  final bool isActive;
  final Color color;

  const DataCard({
    super.key,
    required this.label,
    required this.count,
    required this.price,
    required this.isActive,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(label),
        Text('Count: $count'),
        Text('Price: $price'),
        Text(isActive ? 'Active' : 'Off'),
        Container(width: 40, height: 40, color: color),
      ],
    );
  }
}
```

Any type you learned in Dart can be a property: `String`, `int`, `double`, `bool`, even a `Color`.

---

## Building Bigger Widgets From Properties

Now the payoff: combine the basic widgets, driven by properties, into a reusable card.

```dart
class ContactCard extends StatelessWidget {
  final String name;
  final String role;
  final IconData icon;

  const ContactCard({
    super.key,
    required this.name,
    required this.role,
    this.icon = Icons.person,    // default icon
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text(role, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ],
      ),
    );
  }
}

// Use it many times with different data:
ContactCard(name: 'Ada', role: 'Student')
ContactCard(name: 'Bola', role: 'Teacher', icon: Icons.school)
```

Write the card once, use it everywhere with different names, roles, and icons. That is the power of properties.

---

## A Note On `const`

You can put `const` before a widget when **all** its values are fixed (known as you type):

```dart
const NameTag(name: 'Ada')   // fixed text, const is fine
```

But not when a value comes from a variable that is decided while the app runs:

```dart
String who = 'Ada';
NameTag(name: who)           // who is a variable, so no const here
```

`const` makes the app a little faster. Use it when you can, and do not worry when you cannot.

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting `final`

```dart
String name;          // BAD: widget properties must be final
final String name;    // GOOD
```

### Mistake 2: Forgetting `required`

```dart
const Greeting({super.key, this.name});            // BAD if name is non-nullable
const Greeting({super.key, required this.name});   // GOOD
```

### Mistake 3: Using a nullable property without checking

```dart
Text(bio)      // BAD if bio is String? (might be null)
if (bio != null) Text(bio!)   // GOOD: check first
```

### Mistake 4: Trying to change a property after building

```dart
final tag = NameTag(name: 'Ada');
tag.name = 'Bola';            // BAD: properties are final
final tag2 = NameTag(name: 'Bola');   // GOOD: build a new one
```

---

## One-Minute Recap

- A **property** is a value you pass into a widget so it can show different data.
- Three steps: declare a `final` field, add it to the constructor with `this.x`, use it in `build`.
- All widget properties must be `final`.
- `required` means it must be given. A default value or a `?` makes it optional.
- Properties can be any type, and you build reusable cards by combining widgets driven by properties.

---

## Quick Quiz

**Q1.** Why must widget properties be `final`?

<details>
<summary>Answer</summary>
Because a StatelessWidget never changes after it is built. `final` makes sure the values cannot be changed. To show different data, you build a new widget.
</details>

**Q2.** How do you make a property optional?

<details>
<summary>Answer</summary>
Give it a default value (like `this.fontSize = 16`) or make it nullable with `?` and leave off `required`.
</details>

**Q3.** What is wrong with `Greeting(name: 'Ada')` if the constructor is `const Greeting({super.key, required this.name});` and you wrote `const Greeting(name: who)` where `who` is a variable?

<details>
<summary>Answer</summary>
You cannot use `const` when a value comes from a variable decided at runtime. Drop the `const`: `Greeting(name: who)`.
</details>

**Q4.** How do you show a nullable `String? bio` only when it exists?

<details>
<summary>Answer</summary>

```dart
if (bio != null) Text(bio!)
```
Check it is not null first, then use `!` to use it.
</details>

---

## Assignment

Use [dartpad.dev](https://dartpad.dev) with this shell:

```dart
import 'package:flutter/material.dart';
void main() => runApp(MaterialApp(home: Scaffold(body: Center(child: YOUR_WIDGET))));
```

### Problem 1: A greeting with a name

Write a `Greeting` widget with a required `String name`. Its `build` returns `Text('Hi, <name>!')`. Show it for `'Ada'`.

### Problem 2: A reusable user card

Write a `UserCard` widget with a required `String name` and a required `int age`. Its `build` returns a `Column` with the name and `'Age: <age>'`. Use it twice with different people.

### Problem 3: A default size

Write a `Label` widget with a required `String text` and an optional `double size` that defaults to 16. Show the text at that size. Use it once with the default and once with size 30.

### Problem 4: An optional subtitle

Write a `Headline` widget with a required `String title` and an optional `String? subtitle`. Its `build` returns a `Column` that always shows the title, and shows the subtitle only if it was given.

### Problem 5: Spot the bugs

This widget has two mistakes. Find and fix them.

```dart
class Tag extends StatelessWidget {
  String label;

  const Tag({super.key, this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}
```

---

## Assignment Answers

### Problem 1: A greeting with a name

```dart
class Greeting extends StatelessWidget {
  final String name;
  const Greeting({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Text('Hi, $name!');
  }
}

// Greeting(name: 'Ada')  ->  Hi, Ada!
```

The `name` is a `final` property, filled in by the constructor and used in `build`.

### Problem 2: A reusable user card

```dart
class UserCard extends StatelessWidget {
  final String name;
  final int age;
  const UserCard({super.key, required this.name, required this.age});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(name),
        Text('Age: $age'),
      ],
    );
  }
}

// UserCard(name: 'Ada', age: 12)
// UserCard(name: 'Bola', age: 30)
```

One widget, used twice with different data. That is reuse.

### Problem 3: A default size

```dart
class Label extends StatelessWidget {
  final String text;
  final double size;
  const Label({super.key, required this.text, this.size = 16});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: TextStyle(fontSize: size));
  }
}

// Label(text: 'Small')              -> size 16 (default)
// Label(text: 'Big', size: 30)      -> size 30
```

`size` has a default of 16, so it is optional. Pass it only when you want a different size.

### Problem 4: An optional subtitle

```dart
class Headline extends StatelessWidget {
  final String title;
  final String? subtitle;
  const Headline({super.key, required this.title, this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        if (subtitle != null) Text(subtitle!),
      ],
    );
  }
}

// Headline(title: 'News')                          -> just the title
// Headline(title: 'News', subtitle: 'Today')       -> title and subtitle
```

The `if (subtitle != null) Text(subtitle!)` includes the subtitle widget only when a subtitle was given.

### Problem 5: Spot the bugs

The two mistakes:

1. `String label;` is not `final`. Widget properties must be `final`.
2. `this.label` with no `required` (and `label` is non-nullable), so the compiler complains it might not be set.

Fixed:

```dart
class Tag extends StatelessWidget {
  final String label;

  const Tag({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}
```

Now `label` is `final` and `required`, so it is always provided and never changes.

---

**Next:** `03c-StatelessContext.md`, where you use BuildContext to reach the theme and screen size.
