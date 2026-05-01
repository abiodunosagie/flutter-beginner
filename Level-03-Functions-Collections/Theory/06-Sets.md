# Sets: Collections Of Unique Items

## Why This Topic Exists

A list lets you store many values, in order. Duplicates are allowed.

```dart
List<String> tags = ['flutter', 'dart', 'flutter', 'mobile'];
```

Sometimes you do not want duplicates. Think of:

- The IDs of products already in a cart.
- The tags on a blog post.
- The permissions a user has.

In each case, the same value should never appear twice. That is what a **Set** is for.

```dart
Set<String> tags = {'flutter', 'dart', 'mobile'};
```

A set automatically rejects duplicates. If you try to add a value that is already in the set, nothing happens.

---

## The Mental Model

A set is like a **bag**.

- You can put things in.
- You can take things out.
- You cannot tell what order things were added.
- You cannot have two of the same thing.

That is the mental shift from list to set: **no order, no duplicates**.

---

## Creating A Set

The shortest form, with values:

```dart
Set<int> ids = {1, 2, 3};
```

Notice the curly braces `{ }`. Dart uses curly braces for both Maps and Sets. The difference: a map has `key: value` pairs, a set has just values.

```dart
var s = {1, 2, 3};         // Set<int>
var m = {'a': 1, 'b': 2};  // Map<String, int>
```

An empty set:

```dart
Set<String> tags = {};        // ERROR: this is treated as a Map
Set<String> tags = <String>{};   // ok
var tags = <String>{};           // ok
```

The first one is a gotcha. An empty `{}` defaults to a Map, not a Set. Always include the type annotation when creating an empty set.

---

## The Big Rule: No Duplicates

```dart
Set<int> nums = {1, 2, 3};

nums.add(4);
nums.add(2);    // ignored, already in the set
nums.add(2);    // ignored, again

print(nums);    // {1, 2, 3, 4}
```

Adding a value that is already there is silently ignored. The set just stays as it was.

This is the entire reason to use a Set. If you want uniqueness, you do not have to check for duplicates yourself, the set does it for you.

---

## Adding And Removing

```dart
Set<String> tags = {'flutter', 'dart'};

tags.add('mobile');
tags.addAll({'web', 'backend'});

tags.remove('dart');

print(tags);    // {flutter, mobile, web, backend}
```

`add` is the most common. `addAll` lets you merge in another set or list.

---

## Checking If A Value Is Present

```dart
Set<int> nums = {1, 2, 3};

print(nums.contains(2));    // true
print(nums.contains(99));   // false
```

`contains` on a set is **fast**, much faster than `contains` on a list. If you have many lookups to do, use a set.

---

## Common Set Operations

Sets support classic mathematical operations:

```dart
Set<int> a = {1, 2, 3, 4};
Set<int> b = {3, 4, 5, 6};

print(a.union(b));         // {1, 2, 3, 4, 5, 6}    everything from both
print(a.intersection(b));  // {3, 4}                what they share
print(a.difference(b));    // {1, 2}                in a but not in b
```

These are useful for things like:
- "Tags that posts A and B have in common" (intersection).
- "All tags across both posts" (union).
- "Tags that A has and B does not" (difference).

---

## Looping Through A Set

Same syntax as lists:

```dart
Set<String> tags = {'flutter', 'dart', 'mobile'};

for (var tag in tags) {
  print(tag);
}
```

But remember: the order is **not guaranteed**. The set may print them in a different order than you added them. If order matters, use a List, not a Set.

---

## Converting Between List And Set

This is useful for removing duplicates from a list:

```dart
List<int> nums = [1, 2, 2, 3, 3, 3, 4];

Set<int> unique = nums.toSet();
print(unique);    // {1, 2, 3, 4}

// Convert back to a list if you need ordered output
List<int> uniqueList = unique.toList();
```

The chain `nums.toSet().toList()` is one of the most common ways to deduplicate a list.

---

## Why This Matters In Flutter

In Flutter you reach for a Set when you are tracking things like:

- The IDs of products that are favourited.
- The tags currently selected by a filter.
- The pages a user has already visited.

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

The favourite logic is two lines. No "is it already in the list?" check needed. Set handles it.

---

## When To Use Each Collection

This is the most useful summary in Level 3:

| Need | Use |
|------|-----|
| Ordered items, duplicates ok | **List** |
| Lookup by name | **Map** |
| Unique items, order does not matter | **Set** |

If you cannot decide, default to List. It is the most flexible. Switch to Map when you need named lookup. Switch to Set when uniqueness is the point.

---

## Common Mistakes

### 1. Empty `{}` is a Map, not a Set

```dart
var s = {};          // Map<dynamic, dynamic>, not Set!
var s = <int>{};     // Set<int>
```

Always type-annotate when creating an empty set.

### 2. Expecting order

```dart
Set<int> s = {3, 1, 2};
print(s);     // could print {1, 2, 3} or {3, 1, 2}, depends
```

If order matters, use a list.

### 3. Trying to access by index

```dart
Set<int> s = {1, 2, 3};
print(s[0]);    // ERROR: sets do not support index access
```

Sets are unordered. There is no "first" or "second" item. Loop through with `for-in` if you need to visit each item.

---

## Recap In One Minute

- A `Set` holds unique values, in no particular order.
- Created with `{}` and a type annotation, or `<Type>{}` for empty.
- Adding a duplicate is silently ignored.
- Fast `contains`, useful for membership checks.
- Use `union`, `intersection`, `difference` for set math.
- Convert between list and set with `.toSet()` and `.toList()`.
- Use a Set when uniqueness matters. Otherwise use a List.

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
`Map<dynamic, dynamic>`. An empty `{}` is a Map by default. To make a Set, write `<int>{}` or `Set<int>{}`.
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

**Q4.** Which collection do you use for: "the unique tags on a blog post"?

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

### Problem 2: Deduplicate while preserving order

A set does not keep order, but sometimes you need both uniqueness and the original order. Write a function `List<T> dedupe<T>(List<T> items)` that returns a new list with duplicates removed, where the items appear in the same order they first appeared in the input.

Test on `[3, 1, 4, 1, 5, 9, 2, 6, 5, 3, 5]`. Expected: `[3, 1, 4, 5, 9, 2, 6]`.

Hint: walk the list once, use a Set to track what you have already seen.

### Problem 3: Set math in practice

You manage user permissions. Each user has a Set of permission strings.

```dart
Set<String> alice = {'read', 'write', 'comment'};
Set<String> bob = {'read', 'comment', 'admin'};
```

Write code (or short functions) that answers:

1. What permissions do they share?
2. What permissions does Alice have that Bob does not?
3. Combined, what is the full list of permissions across both?
4. Does either of them have the `'delete'` permission?

### Problem 4: Tag filter

You have a list of blog posts. Each post has a Set of tags. Write a function `List<int> filterByTags(List<Set<String>> posts, Set<String> required)` that returns the **indexes** of posts that contain **all** required tags.

```dart
List<Set<String>> posts = [
  {'flutter', 'mobile', 'beginner'},        // 0
  {'dart', 'mobile'},                       // 1
  {'flutter', 'advanced', 'state'},         // 2
  {'flutter', 'mobile', 'state', 'redux'},  // 3
];

filterByTags(posts, {'flutter', 'mobile'});
// Expected: [0, 3]
```

### Problem 5: Choose the right collection

For each scenario, decide whether to use a `List`, a `Map`, or a `Set`. Justify your choice in one sentence.

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

- `print(s)` shows `{2, 3, 4}`.
- `length` is 3.
- `contains(2)` is true.
- `contains(99)` is false.

The two `add` calls that targeted values already in the set were silently ignored. That is the entire point of a set.

Note: the printed order may vary depending on the Dart implementation. `{2, 3, 4}` is the most likely order, but `{4, 2, 3}` would also be valid for a Set. If order matters, you have chosen the wrong collection.

### Problem 2: Deduplicate while preserving order

```dart
List<T> dedupe<T>(List<T> items) {
  Set<T> seen = {};
  List<T> result = [];

  for (T item in items) {
    if (!seen.contains(item)) {
      seen.add(item);
      result.add(item);
    }
  }

  return result;
}
```

How the algorithm works:

1. **Two collections, two purposes.** A Set tracks what we have already seen (fast lookup). A List builds the deduplicated output (preserves order).
2. **Walk the input once.** For each item, ask the set "have I seen this?". If no, record it in the set and append it to the result list. If yes, skip.

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

Final result: `[3, 1, 4, 5, 9, 2, 6]`. Correct.

You might wonder why we do not just use `items.toSet().toList()`. That works in some cases, but the order of elements in a Set is not guaranteed to match the original order. Using both a Set (for fast membership check) and a List (for order) is the right pattern when both properties matter.

### Problem 3: Set math in practice

```dart
Set<String> alice = {'read', 'write', 'comment'};
Set<String> bob = {'read', 'comment', 'admin'};

void main() {
  // 1. Shared permissions
  print(alice.intersection(bob));
  // {read, comment}

  // 2. Alice-only
  print(alice.difference(bob));
  // {write}

  // 3. Combined
  print(alice.union(bob));
  // {read, write, comment, admin}

  // 4. Either has delete?
  bool aliceHasDelete = alice.contains('delete');
  bool bobHasDelete = bob.contains('delete');
  print(aliceHasDelete || bobHasDelete);
  // false
}
```

How each operation maps to the question:

1. **Shared = intersection.** What is in both? `{read, comment}`.
2. **Alice-only = alice minus bob = difference.** What is in Alice but not Bob? `{write}`.
3. **Combined = union.** Everything from both, no duplicates.
4. **Either has X = OR of two contains.** A simple bool check on each, joined by `||`.

This is exactly why sets exist. These four operations would be tedious and error-prone to write yourself with lists. Sets give you the right tool with one method call.

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

How the algorithm works:

1. **Walk every post.** We need the index, so we use a classic for loop.
2. **For each post, check that every required tag is present.** Loop over the required tags. If any one is missing, set `hasAll = false` and break out of the inner loop.
3. **If we finished the inner loop without setting `hasAll` to false,** every required tag was present. Add the post index to the result.

Trace on the example with `required = {flutter, mobile}`:

| Post i | tags | flutter? | mobile? | hasAll | match |
|--------|------|----------|---------|--------|-------|
| 0 | {flutter, mobile, beginner} | yes | yes | true | yes |
| 1 | {dart, mobile} | no, break | --- | false | no |
| 2 | {flutter, advanced, state} | yes | no, break | false | no |
| 3 | {flutter, mobile, state, redux} | yes | yes | true | yes |

Result: `[0, 3]`. Correct.

A more idiomatic version using set operations:

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

`required.difference(posts[i])` gives "tags in required that are not in this post". If that set is empty, the post has every required tag. This expresses the same idea more compactly once you are comfortable with set math.

### Problem 5: Choose the right collection

| # | Scenario | Collection | Why |
|---|----------|------------|-----|
| 1 | Order of messages in a chat | List | Order matters, duplicates allowed (same text twice). |
| 2 | Unique words in a paragraph | Set | Uniqueness is the goal, order does not matter. |
| 3 | Phone number per person | Map | Lookup by name. Each person maps to one number. |
| 4 | History of visited pages, in order, with duplicates | List | Order matters, duplicates explicitly allowed. |
| 5 | Friends, ignoring duplicate adds | Set | Each friend should appear once, order rarely matters. |
| 6 | Grades in order across assignments | List | Order matters (assignment timeline), duplicates allowed (could score 80 twice). |
| 7 | Country code to country name | Map | Lookup by code. Each code maps to one name. |

The decision tree:

1. Need lookup by name? Map.
2. Need uniqueness? Set.
3. Otherwise? List.

When in doubt, default to List. It is the most flexible. You can always switch later.

---

**Done with Level 3 theory!**

Open the `Examples/` folder for runnable code, then `Exercises.md` to practise.

When you are ready, head to `../Level-04-OOP-Fundamentals/README.md` to start Object-Oriented Programming.
