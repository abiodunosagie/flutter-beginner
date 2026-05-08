# Parameters: How To Feed Data Into A Function

## The Big Idea In One Sentence

> A **parameter** is a slot on a function where you plug in a value when you call it.

That is it. The rest of this page just shows you the four ways to make those slots.

---

## A Picture To Hold In Your Head

Think of a coffee shop order.

You walk up and say:

> "I want a **large** **latte** with **oat milk**."

Three pieces of info. Each one fills a slot:

| Slot | Your value |
|------|------------|
| Size | large |
| Drink | latte |
| Milk | oat |

The barista's recipe (the function) has those three slots built in. You fill them in when you order.

A function works the exact same way. The recipe has slots. You fill them in when you call the function.

---

## Two Words That Sound Almost The Same

This trips up beginners. Read it twice:

- A **parameter** is the slot in the function definition.
- An **argument** is the value you plug in when you call.

```dart
void greet(String name) {       // 'name' is a PARAMETER (the slot)
  print('Hello, $name');
}

greet('Ada');                    // 'Ada' is an ARGUMENT (the value)
```

People often use the words interchangeably. That is fine in everyday talk. Just remember:

- Slot = parameter (the empty space).
- Value = argument (what you plug in).

---

## Dart Has Four Ways To Make Slots

These four styles look different but they all do the same job: feed data into the function.

| Style | Looks like | Use when... |
|-------|-----------|-------------|
| 1. Required positional | `(int a, int b)` | 1 or 2 simple inputs, order is obvious |
| 2. Optional positional | `(int a, [int b = 0])` | A bonus input that has a sensible default |
| 3. Named optional | `({int? a, int? b})` | 3 or more inputs, you want clear call sites |
| 4. Named required | `({required int a})` | Same as named, but the caller MUST supply it |

We will go through each style, slowly.

---

## Style 1: Required Positional (You Already Know This)

This is what you have already been writing. The slots come in a fixed **order**. The caller must fill **all** of them.

```dart
void introduce(String name, int age) {
  print('I am $name, $age years old');
}

void main() {
  introduce('Ada', 25);   // GOOD
  introduce('Ada');       // ERROR: missing age
  introduce(25, 'Ada');   // ERROR: types are wrong
}
```

Use this style when:
- The function has 1 or 2 inputs.
- The order is obvious from the name. Like `add(a, b)`.

When you reach 3 or more inputs, switch to named (style 3).

---

## Style 2: Optional Positional

Sometimes a slot has a sensible default. You want the caller to be able to skip it.

To make a slot optional, wrap it in **square brackets** `[ ]` and give it a default value.

```dart
void greet(String name, [String greeting = 'Hello']) {
  print('$greeting, $name');
}

void main() {
  greet('Ada');              // Hello, Ada       (used the default)
  greet('Ada', 'Welcome');   // Welcome, Ada     (overrode the default)
}
```

Two rules:

1. **Optional slots come AFTER required ones.** You cannot put `[String greeting]` before `String name`.
2. **Each optional slot needs a default OR a `?` to mean "could be null".**

```dart
void f(String a, [int x = 0]) { }     // GOOD: default
void f(String a, [int? x]) { }        // GOOD: nullable
void f(String a, [int x]) { }         // ERROR: needs default or `?`
```

In real code, this style is rare. You will mostly use style 3 (named) instead. But it is good to recognise.

---

## Style 3: Named Parameters

Named slots are the most useful style for beginners.

The big idea: instead of passing values in order, the caller **labels** each value.

```dart
void createUser({String? name, int? age, String? city}) {
  print('Name: $name, Age: $age, City: $city');
}

void main() {
  createUser(name: 'Ada', age: 25, city: 'Lagos');
  createUser(age: 30, name: 'Bola');         // order does not matter!
  createUser(city: 'Lagos');                  // can skip the rest
}
```

Two big differences from positional:

1. The slots are wrapped in **curly braces** `{ }`.
2. The caller **labels** each value with the slot name and a colon, like `name: 'Ada'`.

By default, named slots are **optional**. If the caller skips one, it is `null`. You can also give them defaults:

```dart
void greet({String name = 'Guest', String greeting = 'Hello'}) {
  print('$greeting, $name');
}

greet();                              // Hello, Guest
greet(name: 'Ada');                   // Hello, Ada
greet(greeting: 'Hi', name: 'Bola');  // Hi, Bola
```

### Why named is better when you have many inputs

Compare these two function calls:

```dart
// Hard to read: what is true? what is false? what is 5?
showDialog('Are you sure?', true, false, 5);

// Easy to read: each value tells you what it is for
showDialog(
  message: 'Are you sure?',
  cancellable: true,
  destructive: false,
  delaySeconds: 5,
);
```

The second one needs no explanation. The labels are right there. This is why named parameters are the standard in Flutter.

---

## Style 4: Named Required

Named slots are optional by default. If you need a named slot **and** you want to force the caller to supply it, add the word `required`.

```dart
void createAccount({
  required String email,
  required String password,
  String? phone,                  // optional
  bool agreed = false,            // optional with default
}) {
  print('Account: $email');
}

void main() {
  createAccount(email: 'a@b.com', password: '123');   // GOOD
  createAccount(email: 'a@b.com');                    // ERROR: missing password
}
```

This is the style **Flutter uses everywhere**. Get used to it now. When you start writing widgets, your `email` and `password` slots will use `required`. Slots with sensible defaults will not.

---

## Side By Side: All Four Styles

Same idea, four different ways to write it.

```dart
// 1. Required positional
void f1(String name, int age) { }
f1('Ada', 25);

// 2. Optional positional
void f2(String name, [int age = 0]) { }
f2('Ada');
f2('Ada', 25);

// 3. Named optional
void f3({String? name, int? age}) { }
f3();
f3(name: 'Ada');
f3(name: 'Ada', age: 25);

// 4. Named required
void f4({required String name, required int age}) { }
f4(name: 'Ada', age: 25);
```

Pick the style that makes the **call site** easiest to read. Most of the time, that is style 3 or 4.

---

## How To Pick A Style (Quick Rules)

Read these top to bottom. Use the first match.

1. **Three or more inputs?** → use named (style 3 or 4).
2. **One or two inputs and the order is obvious?** → use required positional (style 1).
3. **Need a sensible default for one extra slot?** → use optional positional (style 2) or named with default (style 3).

When in doubt, pick named. Named call sites are easier to read and harder to mess up.

---

## Default Values

You can give defaults to optional positional slots **and** named slots.

```dart
void f([int x = 10]) { }       // optional positional, default 10
void f({int x = 10}) { }       // named, default 10
```

If the caller does not supply a value, the default kicks in.

You **cannot** give a default to a `required` slot. Required means the caller must always pass something.

---

## Why This Matters In Flutter

Open any Flutter widget and you will see named parameters everywhere:

```dart
Padding(
  padding: EdgeInsets.all(16),
  child: Text(
    'Hello',
    style: TextStyle(fontSize: 24),
    textAlign: TextAlign.center,
  ),
)
```

Look at the labels: `padding:`, `child:`, `style:`, `textAlign:`. Every value is labelled. That is the named-parameter style we just learned.

Why does Flutter do this? Because widgets often have 5 to 15 slots. Without labels, the call site would be unreadable.

When you build your own widgets in Level 5, you will use:
- `required` named for things the widget cannot work without.
- Named with default for things that have a sensible fallback.

---

## The Top Mistakes Beginners Make

### Mistake 1: Forgetting the label on a named call

```dart
void show({required String message}) { }

show('Hi');               // ERROR: needs the label
show(message: 'Hi');      // GOOD
```

If the function uses `{ }`, you must label your values when calling.

### Mistake 2: Putting required after optional in positional

```dart
void f([int? a], int b) { }    // ERROR: cannot have required after optional
void f(int b, [int? a]) { }    // GOOD
```

Required slots come first. Optional come after.

### Mistake 3: Optional positional with no default and no `?`

```dart
void f([int x]) { }            // ERROR: needs default or `?`
void f([int x = 0]) { }        // GOOD: has default
void f([int? x]) { }           // GOOD: nullable
```

Optional slots must either have a default value or accept null.

### Mistake 4: Mixing styles when you do not need to

If you start using named parameters, use them for everything in that function. Mixing positional and named in the same function makes the call site hard to write and read.

---

## One-Minute Recap

- A **parameter** is a slot in a function. An **argument** is what you plug into it.
- Four styles:
  1. Required positional `(int a, int b)`. Fixed order, all required.
  2. Optional positional `[int b = 0]`. Square brackets. Default or nullable.
  3. Named optional `{int? a}`. Curly braces. Labelled at call site.
  4. Named required `{required int a}`. Same as 3 but caller must supply.
- For 3+ inputs, use named. It is what Flutter uses.

---

## Quick Quiz

**Q1.** What is wrong here?

```dart
void greet({String name}) {
  print('Hello, $name');
}
```

<details>
<summary>Answer</summary>
A named slot needs one of three things: a default value, a `?` to mean nullable, or the `required` keyword. This one has none. Fix it as `{required String name}` or `{String? name}` or `{String name = 'Guest'}`.
</details>

**Q2.** Which calls work?

```dart
void f(String a, [int b = 0, String? c]) { }

// 1. f('hi');
// 2. f('hi', 5);
// 3. f('hi', 5, 'x');
// 4. f();
```

<details>
<summary>Answer</summary>
1, 2, and 3 all work. Call 4 fails because `a` is required.
</details>

**Q3.** Convert this to required named parameters:

```dart
void register(String email, String password, int age) { }
```

<details>
<summary>Answer</summary>

```dart
void register({
  required String email,
  required String password,
  required int age,
}) { }
```
</details>

---

## Assignment

### Problem 1: Convert to named parameters

This function is hard to call because the values are easy to mix up. Convert it to use **required named parameters**, then show how the call site changes.

```dart
void createOrder(String productName, int quantity, double price, bool express) {
  // ...
}

void main() {
  createOrder('Shirt', 2, 19.99, true);
}
```

### Problem 2: Pick smart defaults

For each slot below, decide:
- Should it be **required**?
- Should it be **optional with a default**?
- Should it be **optional and nullable**?

Justify each choice.

```dart
void registerUser(
  String email,
  String password,
  String? phoneNumber,
  String country,
  bool subscribeNewsletter,
) { }
```

The function should be callable in at least these ways:

```dart
registerUser(email: 'a@b.com', password: 'pass1234');
registerUser(email: 'a@b.com', password: 'pass1234', country: 'NG');
registerUser(
  email: 'a@b.com',
  password: 'pass1234',
  country: 'NG',
  subscribeNewsletter: true,
  phoneNumber: '0801',
);
```

### Problem 3: Predict the output

Without running it, what does this print?

```dart
void show({String name = 'Guest', int age = 0, String? city}) {
  print('$name, age $age, city: ${city ?? 'unknown'}');
}

void main() {
  show();
  show(name: 'Ada');
  show(age: 25, name: 'Bola');
  show(city: 'Lagos', name: 'Chidi', age: 30);
}
```

### Problem 4: Refactor for readability

This function has 6 positional slots. That is a sign you should switch to named. Refactor it. Pick which slots should be `required` and which should have defaults. Then write three example calls.

```dart
void sendEmail(
  String to,
  String from,
  String subject,
  String body,
  bool isHtml,
  bool isUrgent,
) { }
```

### Problem 5: Spot the design issues

This declaration has multiple problems. List them and rewrite the function in the cleanest way you can.

```dart
void f([String? a], int b, {required String c, int d = 0, String? e}) { }
```

---

## Assignment Answers

### Problem 1: Convert to named parameters

```dart
void createOrder({
  required String productName,
  required int quantity,
  required double price,
  required bool express,
}) {
  // ...
}

void main() {
  createOrder(
    productName: 'Shirt',
    quantity: 2,
    price: 19.99,
    express: true,
  );
}
```

How we did it:

1. **Wrap all the slots in `{ }`** to make them named.
2. **Add `required`** to each, since the original function expected all four.
3. **At the call site, label every value** with its slot name.

Why this is better:

The original call `createOrder('Shirt', 2, 19.99, true)` makes the reader guess. Is `true` the express flag? Or something else? With names, the call literally reads `express: true`. No guessing.

### Problem 2: Pick smart defaults

```dart
void registerUser({
  required String email,
  required String password,
  String? phoneNumber,
  String country = 'NG',
  bool subscribeNewsletter = false,
}) { }
```

Why each choice:

1. **`email` and `password` are required.** A user cannot register without them. There is no good default.
2. **`phoneNumber` is optional and nullable.** Some users will not give one. There is no good default value (an empty string would lie). Nullable says: "may have a phone, may not."
3. **`country` defaults to `'NG'`.** In a Nigerian-focused app, most users are from Nigeria. The default saves typing. Other users override it.
4. **`subscribeNewsletter` defaults to `false`.** This is the **safe** default. Subscribing users by default would be spamming them.

The rule: ask "what should happen if the caller does not say?". If you have a good answer, use a default. If you cannot proceed without it, mark it `required`. If it might just not exist, make it nullable.

### Problem 3: Predict the output

Output:

```
Guest, age 0, city: unknown
Ada, age 0, city: unknown
Bola, age 25, city: unknown
Chidi, age 30, city: Lagos
```

Walk through each call:

1. `show()`: nothing supplied. All defaults kick in. `name = 'Guest'`, `age = 0`, `city = null`. The `city ?? 'unknown'` handles the null.
2. `show(name: 'Ada')`: only name overridden. The rest stay at their defaults.
3. `show(age: 25, name: 'Bola')`: name and age overridden. Notice the order is different from the declaration. That is fine for named.
4. `show(city: 'Lagos', name: 'Chidi', age: 30)`: all three overridden, in any order we like.

This shows three things: named slots can be skipped, can be passed in any order, and play nicely with defaults.

### Problem 4: Refactor for readability

```dart
void sendEmail({
  required String to,
  required String subject,
  required String body,
  String from = 'no-reply@example.com',
  bool isHtml = false,
  bool isUrgent = false,
}) { }
```

Three example calls:

```dart
// Minimal
sendEmail(
  to: 'ada@example.com',
  subject: 'Welcome',
  body: 'Thanks for signing up',
);

// Marketing email
sendEmail(
  to: 'bola@example.com',
  from: 'newsletter@example.com',
  subject: 'New products',
  body: '<h1>See our latest</h1>',
  isHtml: true,
);

// Urgent alert
sendEmail(
  to: 'admin@example.com',
  subject: 'Server down',
  body: 'Production is unresponsive',
  isUrgent: true,
);
```

Compare with the positional version:

```dart
sendEmail('ada@example.com', 'no-reply@example.com', 'Welcome', 'Thanks', false, false);
```

The named version explains itself. The positional version is a guessing game.

Design choices:

- `to`, `subject`, `body` are required. No email makes sense without them.
- `from` has a default sender, since most emails come from the same address.
- `isHtml` and `isUrgent` default to `false`. Most emails are plain text and not urgent.

### Problem 5: Spot the design issues

The declaration has three problems:

```dart
void f([String? a], int b, {required String c, int d = 0, String? e}) { }
```

1. **Optional positional `[String? a]` comes BEFORE the required positional `int b`.** Optional must come after required. Syntax error.
2. **Mixing `[ ]` and `{ }` in the same function** is allowed but very confusing. Pick one style.
3. **The names `a, b, c, d, e` say nothing.** Use real names.

A clean rewrite (keeping the same general shape):

```dart
void f({
  required int b,
  required String c,
  String? a,
  int d = 0,
  String? e,
}) { }
```

Now everything is named. Required slots come first. Optional with defaults come next. Optional nullable come last.

In real code you would also rename `a, b, c` to descriptive names. The exercise here is about parameter shape, not naming, but in practice both matter.

---

**Next:** `03-ReturnValues.md` to focus on what comes back **out** of a function.
