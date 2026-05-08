# Sets: A Bag Of Unique Items

## The Big Idea In One Sentence

> A **Set** is a bag of values where **every value is unique** (no duplicates) and the order does not matter.

That is it. The rest of this page just shows you how to make one and use it.

---

## Why Sets Exist

A list lets you store many values in order, and duplicates are allowed.

```dart
List<String> tags = ['flutter', 'dart', 'flutter', 'mobile'];
//                                        ^ duplicate is fine in a list
```

Sometimes you do **not** want duplicates. Think of:

- The IDs of products in a cart (each product appears once).
- The tags on a blog post (no repeats).
- The permissions a user has (you either have a permission or not).

In each case, the same value should never appear twice. That is exactly what a **Set** is for.

```dart
Set<String> tags = {'flutter', 'dart', 'mobile'};
```

If you try to add a value that is already in the set, **nothing happens**. The set just stays as it was.

---

## A Picture To Hold In Your Head

A set is like a **bag**.

- You can put things in.
- You can take things out.
- You cannot tell what order things were put in.
- You cannot have two of the same thing in the bag at once.

Two ideas to remember: **no order, no duplicates**.

---

## Making A Set

Quick way:

```dart
Set<int> ids = {1, 2, 3};
```

Notice the **curly braces** `{ }`. Dart uses curly braces for both maps and sets. The difference:

- A map has `key: value` pairs.
- A set has just values.

```dart
var s = {1, 2, 3};         // Set<int>
var m = {'a': 1, 'b': 2};  // Map<String, int>
```

An empty set is a gotcha. An empty `{}` is a **Map**, not a Set.

```dart
var bad = {};                  // this is a Map<dynamic, dynamic>!
var good = <String>{};         // this is a Set<String>
Set<String> alsoGood = {};     // explicit type also works
```

Always include the type when creating an empty set.

---

## The One Big Rule: No Duplicates

```dart
Set<int> nums = {1, 2, 3};

nums.add(4);
nums.add(2);   // ignored, already in the bag
nums.add(2);   // ignored again

print(nums);   // {1, 2, 3, 4}
```

Adding a value that is already there is silently ignored. The set stays the same.

This is the entire reason to use a set. If you want uniqueness, you do not have to write any "is this already here?" checks. The set takes care of it.

---

## Adding And Removing

```dart
Set<String> tags = {'flutter', 'dart'};

tags.add('mobile');
tags.addAll({'web', 'backend'});

tags.remove('dart');

print(tags);   // {flutter, mobile, web, backend}
```

`add` is the most common. `addAll` lets you merge in another set or a list.

---

## Checking If A Value Is In The Set

```dart
Set<int> nums = {1, 2, 3};

print(nums.contains(2));    // true
print(nums.contains(99));   // false
```

`contains` on a set is **fast**, much faster than `contains` on a big list. If you do many lookups, use a set.

---

## Set Math: Union, Intersection, Difference

Sets support classic math operations. These are very useful.

```dart
Set<int> a = {1, 2, 3, 4};
Set<int> b = {3, 4, 5, 6};

print(a.union(b));         // {1, 2, 3, 4, 5, 6}    everything from both
print(a.intersection(b));  // {3, 4}                what they share
print(a.difference(b));    // {1, 2}                in a but NOT in b
```

Real-world examples:

- "Tags shared by post A and post B" → intersection.
- "All tags from both posts combined" → union.
- "Tags in A that are not in B" → difference.

---

## Looping Through A Set

Same syntax as a list:

```dart
Set<String> tags = {'flutter', 'dart', 'mobile'};

for (var tag in tags) {
  print(tag);
}
```

But remember: **the order is not guaranteed**. The set may print in a different order than you added. If order matters, use a list, not a set.

---

## Removing Duplicates From A List

This is a super common trick. Convert a list to a set, then back to a list.

```dart
List<int> nums = [1, 2, 2, 3, 3, 3, 4];

Set<int> unique = nums.toSet();
print(unique);   // {1, 2, 3, 4}

List<int> uniqueList = unique.toList();
```

The chain `nums.toSet().toList()` is the easiest way to deduplicate.

---

## Why This Matters In Flutter

In Flutter, you reach for a Set when you are tracking things like:

- The IDs of products that are favourited.
- The tags currently selected by a filter.
- The pages a user has visited.

Tiny preview, do not run yet:

```dart
Set<int> favouriteProductIds = {};

void toggleFavourite(int id) {
  if (favouriteProductIds.contains(id)) {
    favouriteProductIds.remove(id);
  } else {
    favouriteProductIds.add(id);
  }
}
```

Two lines. No "is this already a favourite?" check needed. The set handles uniqueness.

---

## When To Use Each Collection

This is the most useful summary in Level 3:

| Need | Use |
|------|-----|
| Ordered values, duplicates ok | **List** |
| Look up by name | **Map** |
| Unique values, order does not matter | **Set** |

If you cannot decide, default to **List**. It is the most flexible. Switch to a Map when you need named lookup. Switch to a Set when uniqueness is the point.

---

## The Top Mistakes Beginners Make

### Mistake 1: Empty `{}` is a Map, not a Set

```dart
var s = {};          // this is a Map!
var s = <int>{};     // this is a Set<int>
```

Always type-annotate when creating an empty set.

### Mistake 2: Expecting a specific order

```dart
Set<int> s = {3, 1, 2};
print(s);   // could print {1, 2, 3} or anything else
```

If order matters, use a list.

### Mistake 3: Trying to use an index

```dart
Set<int> s = {1, 2, 3};
print(s[0]);   // ERROR: sets do not support indexes
```

Sets are unordered. There is no "first" or "second" item. Use `for-in` if you need to visit every value.

---

## One-Minute Recap

- A `Set` holds unique values, in no particular order.
- Make one with `{}` and a type, or `<Type>{}` for an empty set.
- Adding a duplicate is silently ignored.
- Fast `contains` for membership checks.
- Use `union`, `intersection`, `difference` for set math.
- Convert with `.toSet()` and `.toList()`.
- Use a Set when uniqueness matters. Otherwise default to List.

---

## Quick Quiz

**Q1.** What does this print?

```dart
Set<int> s = {1, 2, 3};
s.add(2);
s.add(4);
print(s.length);
```

<details>
<summary>Answer</summary>
4. Adding 2 was ignored (already there). Adding 4 succeeded.
</details>

**Q2.** What is the type of this?

```dart
var x = {};
```

<details>
<summary>Answer</summary>
`Map<dynamic, dynamic>`. An empty `{}` is a Map by default. Use `<int>{}` or `Set<int>{}` for a Set.
</details>

**Q3.** Remove duplicates from `[1, 1, 2, 3, 3, 4]`.

<details>
<summary>Answer</summary>

```dart
var nums = [1, 1, 2, 3, 3, 4];
var unique = nums.toSet().toList();
print(unique);   // [1, 2, 3, 4]
```
</details>

**Q4.** Which collection do you use for "the unique tags on a blog post"?

<details>
<summary>Answer</summary>
A Set. Tags must be unique, and order rarely matters.
</details>

---

## Assignment

### Problem 1: Predict the output

What does this print?

```dart
void main() {
  Set<int> s = {1, 2, 3};
  s.add(2);
  s.add(4);
  s.remove(1);
  s.add(3);

  print(s);
  print(s.length);
  print(s.contains(2));
  print(s.contains(99));
}
```

### Problem 2: Deduplicate while keeping order

A set does not keep order, but sometimes you need both uniqueness **and** the original order. Write a function `List<int> dedupe(List<int> items)` that gives back a new list of integers with duplicates removed, keeping the order they first appeared.

Test on `[3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]`. Expected: `[3, 1, 4, 5, 9, 2, 6]`.

Hint: walk the list once. Use a Set to track what you have already seen.

### Problem 3: Set math in practice

You manage user permissions. Each user has a Set of permission strings.

```dart
Set<String> alice = {'read', 'write', 'comment'};
Set<String> bob = {'read', 'comment', 'admin'};
```

Write code that answers:

1. What permissions do they share?
2. What permissions does Alice have that Bob does not?
3. Combined, what is the full list of permissions across both?
4. Does either of them have the `'delete'` permission?

### Problem 4: Tag filter

You have a list of blog posts. Each post has a Set of tags. Write a function `List<int> filterByTags(List<Set<String>> posts, Set<String> required)` that gives back the **indexes** of posts that contain **all** required tags.

```dart
List<Set<String>> posts = [
  {'flutter', 'mobile', 'beginner'},        // 0
  {'dart', 'mobile'},                        // 1
  {'flutter', 'advanced', 'state'},          // 2
  {'flutter', 'mobile', 'state', 'redux'},   // 3
];

filterByTags(posts, {'flutter', 'mobile'});
// Expected: [0, 3]
```

### Problem 5: Choose the right collection

For each scenario, decide whether to use a `List`, a `Map`, or a `Set`. Justify in one sentence.

1. The order in which messages were received in a chat.
2. The unique words in a paragraph of text.
3. The phone number for each person in a contact book.
4. The history of pages a user has visited (in order, with duplicates allowed).
5. The friends of a user, where adding the same friend twice should be ignored.
6. The grades a student has earned across all assignments, in order.
7. The mapping from a country code to its country name.

---

## Assignment Answers

### Problem 1: Predict the output

```
{2, 3, 4}
3
true
false
```

Trace:

| Step | Action | Set after |
|------|--------|-----------|
| Start | --- | {1, 2, 3} |
| 1 | s.add(2) | {1, 2, 3} (ignored, already in) |
| 2 | s.add(4) | {1, 2, 3, 4} |
| 3 | s.remove(1) | {2, 3, 4} |
| 4 | s.add(3) | {2, 3, 4} (ignored, already in) |

Then:

- `print(s)` → `{2, 3, 4}`.
- `length` is 3.
- `contains(2)` is true.
- `contains(99)` is false.

The two `add` calls that targeted values already in the set were silently ignored. That is the whole point of a Set.

Note: the printed order may vary. `{4, 2, 3}` would also be a valid output. If order matters, you have chosen the wrong collection.

### Problem 2: Deduplicate while keeping order

```dart
List<int> dedupe(List<int> items) {
  Set<int> seen = {};
  List<int> result = [];

  for (int item in items) {
    if (!seen.contains(item)) {
      seen.add(item);
      result.add(item);
    }
  }

  return result;
}
```

How it works:

1. **Two collections, two purposes.** A Set tracks what we have already seen (fast lookup). A List builds the answer in original order.
2. **Walk the input once.** For each item, ask the set "have I seen this?". If no, record in the set and add to the result. If yes, skip.

Trace on `[3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]`:

| item | seen has it? | action | result after |
|------|--------------|--------|--------------|
| 3 | no | add | [3] |
| 1 | no | add | [3, 1] |
| 4 | no | add | [3, 1, 4] |
| 1 | yes | skip | [3, 1, 4] |
| 5 | no | add | [3, 1, 4, 5] |
| 9 | no | add | [3, 1, 4, 5, 9] |
| 2 | no | add | [3, 1, 4, 5, 9, 2] |
| 6 | no | add | [3, 1, 4, 5, 9, 2, 6] |
| 5 | yes | skip | [3, 1, 4, 5, 9, 2, 6] |
| 3 | yes | skip | [3, 1, 4, 5, 9, 2, 6] |
| 5 | yes | skip | [3, 1, 4, 5, 9, 2, 6] |

Final result: `[3, 1, 4, 5, 9, 2, 6]`.

You might wonder why we do not just use `items.toSet().toList()`. That works in some cases, but the order in a Set is not guaranteed to match the original. Using both a Set (for fast checks) and a List (for order) is the right pattern when both properties matter.

### Problem 3: Set math in practice

```dart
Set<String> alice = {'read', 'write', 'comment'};
Set<String> bob = {'read', 'comment', 'admin'};

void main() {
  // 1. Shared
  print(alice.intersection(bob));   // {read, comment}

  // 2. Alice-only
  print(alice.difference(bob));     // {write}

  // 3. Combined
  print(alice.union(bob));          // {read, write, comment, admin}

  // 4. Either has delete?
  bool aliceHasDelete = alice.contains('delete');
  bool bobHasDelete = bob.contains('delete');
  print(aliceHasDelete || bobHasDelete);   // false
}
```

How each operation maps to the question:

1. **Shared = intersection.** What is in both?
2. **Alice-only = difference.** What is in alice but not bob?
3. **Combined = union.** Everything from both, no duplicates.
4. **Either has X = OR of two `contains` calls.**

This is exactly why sets exist. These four operations would be tedious to write yourself with lists. Sets give you the right tool with one method call.

### Problem 4: Tag filter

```dart
List<int> filterByTags(List<Set<String>> posts, Set<String> required) {
  List<int> matching = [];

  for (int i = 0; i < posts.length; i++) {
    bool hasAll = true;
    for (String tag in required) {
      if (!posts[i].contains(tag)) {
        hasAll = false;
        break;
      }
    }
    if (hasAll) matching.add(i);
  }

  return matching;
}
```

How it works:

1. **Walk every post.** We need the index, so we use a classic for loop.
2. **For each post, check that every required tag is there.** Loop over the required tags. If any one is missing, set `hasAll = false` and break out of the inner loop.
3. **If we made it through without missing one,** every required tag is present. Add the index to the result.

Trace with `required = {flutter, mobile}`:

| Post i | tags | flutter? | mobile? | hasAll | match |
|--------|------|----------|---------|--------|-------|
| 0 | {flutter, mobile, beginner} | yes | yes | true | yes |
| 1 | {dart, mobile} | no, break | --- | false | no |
| 2 | {flutter, advanced, state} | yes | no, break | false | no |
| 3 | {flutter, mobile, state, redux} | yes | yes | true | yes |

Result: `[0, 3]`.

A more compact version using `difference`:

```dart
List<int> filterByTags(List<Set<String>> posts, Set<String> required) {
  List<int> matching = [];
  for (int i = 0; i < posts.length; i++) {
    if (required.difference(posts[i]).isEmpty) {
      matching.add(i);
    }
  }
  return matching;
}
```

`required.difference(posts[i])` gives "tags in required that are not in this post." If that set is empty, every required tag is present.

### Problem 5: Choose the right collection

| # | Scenario | Collection | Why |
|---|----------|------------|-----|
| 1 | Order of chat messages | List | Order matters, duplicates allowed. |
| 2 | Unique words in a paragraph | Set | Uniqueness is the goal, order does not matter. |
| 3 | Phone number per person | Map | Lookup by name. Each person maps to one number. |
| 4 | Visited pages, in order, with duplicates | List | Order matters, duplicates explicitly allowed. |
| 5 | Friends, ignoring duplicates | Set | Each friend should appear once. |
| 6 | Grades in order across assignments | List | Order matters. Could score 80 twice. |
| 7 | Country code to country name | Map | Lookup by code. |

The decision tree:

1. Need lookup by name? **Map**.
2. Need uniqueness? **Set**.
3. Otherwise? **List**.

When in doubt, default to List. You can switch later.

---

**Done with Level 3 theory!**

Open the `Examples/` folder for runnable code, then `Exercises.md` to practise.

When you are ready, head to `../Level-04-OOP-Fundamentals/README.md` to start Object-Oriented Programming.
