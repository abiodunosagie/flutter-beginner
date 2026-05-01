# Parameters: The Four Ways To Pass Data Into A Function

## Why This Topic Exists

A function with no inputs always does the same thing. That is rarely useful.

```dart
void greet() {
  print('Hello');
}
```

Most of the time, you want the function to do something **specific** based on the data you give it.

```dart
void greet(String name) {
  print('Hello, $name');
}
```

The `String name` part is a **parameter**. Parameters let one function handle many different cases.

Dart has four ways to declare parameters. They look different but all do the same job: feed data into a function. Learn them in order.

---

## A Quick Note On Vocabulary

This trips up beginners, so write it on the board:

- A **parameter** is the placeholder in the function definition.
- An **argument** is the actual value passed when calling.

```dart
void greet(String name) {       // 'name' is a parameter
  print('Hello, $name');
}

greet('Ada');                    // 'Ada' is an argument
```

You will often hear people use them interchangeably. That is fine in conversation. On a test or in code review, the distinction matters.

---

## The Four Kinds Of Parameters

| Style | Syntax | When to use |
|-------|--------|-------------|
| Required positional | `(String a, int b)` | 1-2 simple inputs, order is obvious |
| Optional positional | `(String a, [int? b])` | One or two extras that often default |
| Named (optional) | `({String? a, int? b})` | 3+ inputs, want clear call sites |
| Named (required) | `({required String a})` | Named, but you must supply it |

We will go through each in turn.

---

## 1. Required Positional Parameters

This is what you have already been writing. The values must be passed **in order**, and **all of them are required**.

```dart
void introduce(String name, int age) {
  print('I am $name, $age years old');
}

void main() {
  introduce('Ada', 25);     // works
  introduce(25, 'Ada');     // ERROR: types do not match
  introduce('Ada');         // ERROR: missing age
}
```

Use this when:
- The function has 1 or 2 parameters.
- The order is obvious from the name (`add(a, b)`).

When the parameters get to 3 or more, switch to named.

---

## 2. Optional Positional Parameters

If a parameter is optional, wrap it in **square brackets** `[ ]`. You also have to give it a default value or make it nullable.

```dart
void greet(String name, [String greeting = 'Hello']) {
  print('$greeting, $name');
}

void main() {
  greet('Ada');             // Hello, Ada
  greet('Ada', 'Welcome');  // Welcome, Ada
}
```

Two important rules:

1. Optional parameters must come **after** required ones.
2. You either give them a default value (`= 'Hello'`) or make the type nullable (`String?`).

```dart
// Default value
void f(String a, [int x = 0]) { }

// Nullable
void f(String a, [int? x]) { }
```

If you make it nullable without a default, you have to handle the `null` case yourself inside the function.

---

## 3. Named Parameters

Named parameters use **curly braces** `{ }`. When calling, you label each value with the parameter name.

```dart
void createUser({String? name, int? age, String? city}) {
  print('Name: $name, Age: $age, City: $city');
}

void main() {
  createUser(name: 'Ada', age: 25, city: 'Lagos');
  createUser(age: 30, name: 'Bola');     // order does not matter
  createUser(city: 'Lagos');             // can skip the rest
}
```

Two things change from positional:

1. You **label** each argument when calling.
2. The **order does not matter**.

By default, named parameters are **optional**. If you do not pass them, they are `null`. You can also give them defaults:

```dart
void greet({String name = 'Guest', String greeting = 'Hello'}) {
  print('$greeting, $name');
}

greet();                              // Hello, Guest
greet(name: 'Ada');                   // Hello, Ada
greet(greeting: 'Hi', name: 'Bola');  // Hi, Bola
```

Use named parameters when:
- The function has 3 or more parameters.
- The meaning of an argument is not obvious from its position.

Compare:

```dart
// Hard to read
showDialog('Are you sure?', true, false, 5);

// Easy to read
showDialog(
  message: 'Are you sure?',
  cancellable: true,
  destructive: false,
  delaySeconds: 5,
);
```

The second one needs no explanation.

---

## 4. Required Named Parameters

Named parameters are optional by default. If you want them named **and** required, add the `required` keyword:

```dart
void createAccount({
  required String email,
  required String password,
  String? phone,                 // optional
  bool agreed = false,           // optional with default
}) {
  print('Account: $email');
}

void main() {
  createAccount(email: 'a@b.com', password: '123');           // ok
  createAccount(email: 'a@b.com');                            // ERROR
}
```

This is the form Flutter uses everywhere. Get used to it now.

---

## Side By Side: Same Function In All Four Styles

```dart
// Required positional
void f1(String name, int age) { }
f1('Ada', 25);

// Optional positional
void f2(String name, [int age = 0]) { }
f2('Ada');
f2('Ada', 25);

// Named (optional)
void f3({String? name, int? age}) { }
f3();
f3(name: 'Ada');
f3(name: 'Ada', age: 25);

// Named (required)
void f4({required String name, required int age}) { }
f4(name: 'Ada', age: 25);
```

Pick the style that makes the call site easiest to read.

---

## Default Values Recap

You can give default values to optional positional **and** named parameters:

```dart
void f([int x = 10]) { }            // optional positional default
void f({int x = 10}) { }            // named default
```

The default is used when the caller does not supply a value.

You **cannot** put a default on a required parameter. If something is required, the caller must always pass it.

---

## Why This Matters In Flutter

Open any Flutter widget. You will see named parameters everywhere:

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

Notice how every argument is labelled (`padding:`, `child:`, `style:`, `textAlign:`). That is exactly the named-parameter syntax we just learned. Flutter chose this style because widgets often have 5-15 parameters, and labelled arguments are the only readable way to pass them all.

When you build your own widgets in Level 5, you will use `required` named parameters for the things the widget cannot work without, and optional named for the rest.

---

## Common Mistakes

### 1. Forgetting the parameter label on a named call

```dart
void show({required String message}) { }

show('Hi');               // ERROR
show(message: 'Hi');      // ok
```

### 2. Putting required after optional

```dart
void f([int? a], int b) { }    // ERROR: required after optional
void f(int b, [int? a]) { }    // ok
```

### 3. Missing a default or nullable mark

```dart
void f([int x]) { }            // ERROR: needs default or `int?`
void f([int x = 0]) { }        // ok
void f([int? x]) { }           // ok
```

### 4. Mixing positional and named when both work

If you switch to named in one place, switch everywhere in that function. Mixing the two styles makes the function hard to call.

---

## Recap In One Minute

- Required positional: pass in order, all required.
- Optional positional: square brackets, default or nullable.
- Named optional: curly braces, label when calling, defaults to null.
- Named required: curly braces with the `required` keyword.
- Use named for any function with 3 or more parameters. It is what Flutter uses.

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
A named parameter without a default and without `?` is a compile error. Either make it `String? name` or add `required String name` or give it a default like `String name = 'Guest'`.
</details>

**Q2.** Which call works?
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

**Q3.** Convert this to use required named parameters:
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

This function is hard to call because the arguments are all the same type. Convert it to use **required named parameters**, then show how the call site changes.

```dart
void createOrder(String productName, int quantity, double price, bool express) {
  // ...
}

void main() {
  createOrder('Shirt', 2, 19.99, true);
}
```

### Problem 2: Add smart defaults

Take this function and decide:
- Which parameters should be required.
- Which should be optional with a default.
- Which should be optional and nullable.

Justify each decision in your answer.

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

Without running, what does this print?

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

### Problem 4: Refactor to better parameter style

This function has 6 positional parameters. That is a sign you should use named parameters. Refactor it to use named parameters with appropriate defaults and `required` markers. Then write three example calls that show the named version is more readable than the positional one.

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

This function declaration has multiple problems. List them and rewrite the function in the cleanest way you can.

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

How the conversion was done:

1. **Wrap all parameters in `{ }`** to make them named.
2. **Add `required`** to each, because the original function expected all four values to be supplied.
3. **At the call site, label every argument** with its parameter name.

Why this is better:

The original call `createOrder('Shirt', 2, 19.99, true)` requires the reader to remember the order. Is `true` the express flag, or some other boolean? With named parameters, the call literally says `express: true`. No memory required.

The refactor is most valuable when the function has many parameters of the same type, like our case where two are bool-related and the others are mixed. Named parameters make order mistakes impossible.

### Problem 2: Add smart defaults

```dart
void registerUser({
  required String email,
  required String password,
  String? phoneNumber,
  String country = 'NG',
  bool subscribeNewsletter = false,
}) { }
```

Justification for each decision:

1. **`email` and `password` are required.** A user cannot register without them. There is no sensible default. Making them required forces the caller to supply them, and the compiler will catch any missing argument.
2. **`phoneNumber` is optional and nullable.** Some users will not give a phone number. There is no good default value (an empty string would be misleading). Nullable is exactly the right shape: "may have a phone, may not".
3. **`country` has a default of `'NG'`.** In a Nigerian-focused app, most users will be from Nigeria. A default avoids forcing every caller to spell it out. Callers from other countries override it.
4. **`subscribeNewsletter` defaults to `false`.** This is the **safe** default. If we accidentally subscribed users by default, we would be spamming people. Privacy-respecting defaults matter.

The principle: ask yourself "what should happen if the caller does not specify this?". If there is a good answer (a sensible default), give it one. If "we cannot proceed without this", make it required. If "may not exist at all", make it nullable.

### Problem 3: Predict the output

Output:

```
Guest, age 0, city: unknown
Ada, age 0, city: unknown
Bola, age 25, city: unknown
Chidi, age 30, city: Lagos
```

How each call resolves:

1. `show()`: no arguments. All defaults kick in. `name = 'Guest'`, `age = 0`, `city = null`. The `city ?? 'unknown'` handles the null and prints `'unknown'`.
2. `show(name: 'Ada')`: only `name` overridden. `age` stays at 0, `city` stays at null.
3. `show(age: 25, name: 'Bola')`: `name` and `age` overridden. The order of arguments at the call site does not matter for named parameters. `city` is still null.
4. `show(city: 'Lagos', name: 'Chidi', age: 30)`: all three are overridden. Notice we pass them in a different order than they were declared. That is allowed because they are named.

This problem cements three things: named parameters can be skipped, can be passed in any order, and play well with defaults.

### Problem 4: Refactor to better parameter style

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
  body: 'The production server is unresponsive',
  isUrgent: true,
);
```

Compare with the equivalent positional version:

```dart
sendEmail('ada@example.com', 'no-reply@example.com', 'Welcome', 'Thanks', false, false);
```

The named version is self-documenting. You can see at a glance what each argument means. The positional version requires you to remember the order and the meaning of each `false` and `true`.

Design choices:

- **`to`, `subject`, `body` are required.** No email makes sense without them.
- **`from` has a default sender.** Most emails go from the same address. Override only when needed (e.g. marketing).
- **`isHtml` and `isUrgent` default to false.** These are flags. Most emails are plain text and not urgent.

### Problem 5: Spot the design issues

The function declaration has three problems:

```dart
void f([String? a], int b, {required String c, int d = 0, String? e}) { }
```

1. **Optional positional `[String? a]` comes before required positional `int b`.** This is a syntax error. Optional positional parameters must come after all required positional parameters.

2. **Mixing optional positional `[ ]` with named `{ }`** in the same function is allowed in theory but very confusing. Pick one style.

3. **The function has too many parameters with no clear meaning.** Names like `a`, `b`, `c` say nothing.

A clean rewrite, assuming we want to keep the same general shape:

```dart
void f({
  required int b,
  required String c,
  String? a,
  int d = 0,
  String? e,
}) { }
```

Now:
- All parameters are named.
- `b` and `c` are required because they had no defaults before.
- `a` and `e` are optional and nullable.
- `d` keeps its default of 0.
- The order is conventional: required first, then optional.

Of course in real code you would also rename `a, b, c, d, e` to descriptive names. The exercise here is about parameter shape, not naming, but in practice both matter.

---

**Next:** `03-ReturnValues.md` to focus on what comes back out of a function.
