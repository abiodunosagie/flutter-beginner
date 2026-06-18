# Null Safety: Handling "Nothing"

## The Big Idea In One Sentence

> `null` means **"nothing is in the box,"** and Dart helps you avoid crashes by being careful with boxes that might be empty.

This is the last lesson of Level 1. Take it slowly, it is a new idea.

---

## A Picture To Hold In Your Head

Every box you have made so far had something inside it:

```
┌──────────┐        ┌──────────┐
│  'Ada'   │        │    25    │
└──────────┘        └──────────┘
   name                 age
```

`null` is a special value that means **the box is empty**. There is nothing inside.

```
┌──────────┐
│  (empty) │   <-  null
└──────────┘
```

Real life: your wallet with 50 naira inside is `50`. An empty wallet is `null` (not zero naira, just... empty).

---

## null Is Not The Same As 0 Or ''

This catches everyone, so read carefully:

- `0` is the number zero. The box has a number in it.
- `''` is an empty string. The box has text in it (text with no letters).
- `null` is **nothing at all**. The box is empty.

```dart
int count = 0;       // a box with the number 0
String text = '';    // a box with empty text
int? nothing = null; // a box with nothing
```

All three are different.

---

## Normal Boxes Cannot Be Empty

By default, a box **must** have something. This is Dart keeping you safe:

```dart
String name = 'Ada';   // GOOD: has a value
String name2 = null;   // BAD: a normal String box cannot be empty
String name3;          // BAD: you must put something in it
```

So a normal `String` box always holds a real string. You never have to worry about it being empty.

---

## The `?` Box: Allowed To Be Empty

Sometimes you genuinely do not have a value yet (maybe the user has not typed their phone number). For that, add a `?` to the type. This makes a box that **is allowed to be empty**:

```dart
String? phone;          // a maybe-empty box, starts as null
String? email = null;   // also fine, clearly empty
int? score;             // starts as null
```

Read the `?` as the word **"maybe"**:

- `String` means "a string, definitely."
- `String?` means "maybe a string, maybe nothing."

A `?` box that you do not fill starts out as `null`.

---

## The Problem With Maybe-Empty Boxes

If a box might be empty, using it directly is risky. What is the length of nothing? There is no answer, so the program would crash.

Dart protects you: it will **not let you** use a `?` box as if it is definitely full. You have to handle the "maybe empty" case. Here are the gentle tools for that.

---

## Tool 1: `??` Gives A Backup Value

`??` means **"use the left value, but if it is null, use the right one instead."** It is a backup plan.

```dart
void main() {
  String? nickname;   // empty (null)
  String shown = nickname ?? 'Guest';
  print(shown);       // Guest
}
```

`nickname` is null, so `??` uses the backup `'Guest'`. If `nickname` had a value, it would use that instead:

```dart
void main() {
  String? nickname = 'Boss';
  print(nickname ?? 'Guest');   // Boss  (not null, so the backup is ignored)
}
```

---

## Tool 2: `?.` Peeks Safely

Normally you use a dot to reach inside a value, like `name.length`. But if the box might be empty, a plain dot is risky. The **safe peek** `?.` handles it: if the box is empty, the whole thing just becomes null instead of crashing.

```dart
void main() {
  String? name = 'Ada';
  print(name?.length);   // 3   (name is not empty, so we get the length)

  String? empty;
  print(empty?.length);  // null (empty is null, so the result is null, no crash)
}
```

`?.` means "if there is something here, peek inside; if not, give me null."

You can pair it with `??` to provide a backup:

```dart
void main() {
  String? name;
  print(name?.length ?? 0);   // 0  (name is null -> length is null -> use 0)
}
```

---

## Tool 3: `??=` Fills The Box Only If It Is Empty

`??=` means **"put this value in, but only if the box is currently empty."**

```dart
void main() {
  String? title;        // empty

  title ??= 'Untitled'; // it was empty, so this fills it
  print(title);         // Untitled

  title ??= 'Something'; // not empty now, so this does nothing
  print(title);          // Untitled
}
```

The first `??=` fills the empty box. The second sees it is already full and leaves it alone.

---

## Tool 4: `!` Says "Trust Me, It Is Not Empty" (Careful!)

The `!` sign tells Dart "I promise this box is not empty." It is risky: if you are wrong, the program crashes.

```dart
void main() {
  String? name = 'Ada';
  print(name!.length);   // 3  (we know it is not empty, so this is fine)
}
```

But if the box really is empty, `!` crashes the program. Only use `!` when you are 100 percent sure. When in doubt, prefer `??` or the safe peek `?.`.

---

## A Quick Note On Yellow Hints

When you type these tiny practice lines into an editor or DartPad, you might see a small **yellow hint** saying a check "is not needed here." That happens because in these little examples Dart can already see the value and knows it is not empty.

In real apps, the value usually comes from somewhere Dart cannot see ahead of time, like something the user types into a form. That is exactly when `??`, `?.`, and `!` become essential. So learn them now. They run perfectly, and you will rely on them very soon. A yellow hint is just a suggestion, not an error.

---

## A Peek Ahead (Level 2)

There is one more way to handle a maybe-empty box: **check it first with `if`**.

```dart
String? name = 'Ada';

if (name != null) {
  print(name.length);   // safe: we checked it is not null
}
```

You will learn `if` properly in Level 2. For now, the tools `??`, `?.`, and `??=` are enough.

---

## The Top Mistakes Beginners Make

### Mistake 1: Thinking null is the same as 0 or ''

```dart
int? a = null;   // empty
int b = 0;       // the number zero (not empty)
```

They are different. `null` is nothing; `0` is a real number.

### Mistake 2: Trying to put null in a normal box

```dart
String name = null;    // BAD: normal boxes cannot be empty
String? name = null;   // GOOD: the ? box can be empty
```

### Mistake 3: Using `!` when you are not sure

```dart
String? name;          // empty!
print(name!.length);   // CRASH: you promised it was not empty, but it was
print(name?.length ?? 0); // SAFE: gives 0 instead of crashing
```

### Mistake 4: Forgetting the `?` on the type

```dart
String phone;          // BAD if you want it to start empty
String? phone;         // GOOD: now it is allowed to be empty (null)
```

---

## One-Minute Recap

- `null` means an empty box, nothing inside. It is not `0` and not `''`.
- Normal boxes (no `?`) must always have a value.
- A `?` box (like `String?`) is allowed to be empty, and starts as `null`.
- `??` gives a backup value when something is null.
- `?.` peeks safely: it gives null instead of crashing.
- `??=` fills a box only if it is currently empty.
- `!` says "trust me, not empty," and crashes if you are wrong. Use it rarely.

---

## Quick Quiz

**Q1.** What does `null` mean?

<details>
<summary>Answer</summary>
Nothing is in the box. It is empty. (Different from `0` or `''`, which hold real values.)
</details>

**Q2.** Why does `String name = null;` fail, but `String? name = null;` work?

<details>
<summary>Answer</summary>
A normal `String` box must always have a value. Adding `?` makes it a "maybe" box that is allowed to be empty (null).
</details>

**Q3.** What does `nickname ?? 'Guest'` give if `nickname` is null?

<details>
<summary>Answer</summary>
`'Guest'`. The `??` uses the backup value when the left side is null.
</details>

**Q4.** What does `name?.length` give if `name` is null?

<details>
<summary>Answer</summary>
`null`. The safe peek `?.` gives null instead of crashing.
</details>

---

## Assignment

Try each in [dartpad.dev](https://dartpad.dev) before checking the answers.

### Problem 1: Legal or not?

For each line, say whether it is allowed or causes an error, and why.

```dart
String a = null;        // 1
String? b = null;       // 2
int c = null;           // 3
int? d;                 // 4
String e = '';          // 5
```

### Problem 2: Backup values

```dart
void main() {
  String? a = 'Ada';
  String? b;

  print(a ?? 'Guest');
  print(b ?? 'Guest');
}
```

What are the two lines it prints?

### Problem 3: Safe peek

```dart
void main() {
  String? name = 'Bola';
  String? empty;

  print(name?.length);
  print(empty?.length);
  print(empty?.length ?? 0);
}
```

Predict all three lines.

### Problem 4: Fill if empty

```dart
void main() {
  String? theme;

  theme ??= 'light';
  print(theme);

  theme ??= 'dark';
  print(theme);
}
```

What does it print, and why does the second `??=` not change anything?

### Problem 5: Pick the type

For each, write `String` or `String?` and one short reason:

1. A user's full name, required when they sign up.
2. A user's middle name, which many people do not have.
3. A greeting message you always set yourself.
4. A phone number the user has not typed yet.

---

## Assignment Answers

### Problem 1: Legal or not?

```dart
String a = null;     // 1. ERROR: a normal String box cannot be empty
String? b = null;    // 2. OK: the ? box is allowed to be empty
int c = null;        // 3. ERROR: a normal int box cannot be empty
int? d;              // 4. OK: a ? box, starts as null
String e = '';       // 5. OK: empty text is a real value, not null
```

Remember: empty text `''` is not the same as `null`. Line 5 has a real (if empty) string inside.

### Problem 2: Backup values

```
Ada
Guest
```

`a` is `'Ada'` (not null), so `a ?? 'Guest'` gives `'Ada'`. `b` is null, so `b ?? 'Guest'` falls back to `'Guest'`.

### Problem 3: Safe peek

```
4
null
0
```

- `name?.length`: `name` is `'Bola'` (4 letters), so we get `4`.
- `empty?.length`: `empty` is null, so the safe peek gives `null`.
- `empty?.length ?? 0`: the peek gives null, then `?? 0` falls back to `0`.

### Problem 4: Fill if empty

```
light
light
```

The first `theme ??= 'light'` fills the empty box, so it becomes `'light'`. The second `theme ??= 'dark'` sees that `theme` is already full, so it does nothing. `??=` only fills when the box is empty.

### Problem 5: Pick the type

| Value | Type | Why |
|-------|------|-----|
| Full name (required) | `String` | it must always be there |
| Middle name (often missing) | `String?` | many people have none, so it can be empty |
| A greeting you always set | `String` | you always give it a value |
| Phone not typed yet | `String?` | it can be empty until they type it |

The question to ask: could this be missing or unknown? If yes, use `?`. If it is always there, use a normal type.

---

**You finished Level 1!** You now know variables, types, strings, numbers, booleans, operators, and null safety.

**Next:** open the Level 1 `Examples` and `Exercises` folders to practice, then move on to `../../Level-02-Control-Flow/Theory/00-LearningPath.md` to learn how programs make decisions.
