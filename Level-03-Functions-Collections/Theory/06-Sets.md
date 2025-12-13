# Sets: Unique Collections

## What Is a Set?

A **Set** is a collection where every item is unique. Duplicates are automatically removed.

```dart
Set<int> numbers = {1, 2, 3, 3, 3};
print(numbers);  // {1, 2, 3} - only one 3!
```

Key characteristics:
- **No duplicates**: Each item appears only once
- **Unordered**: Items have no guaranteed order
- **Fast lookup**: Checking if item exists is very fast

---

## Creating Sets

### Empty Set

```dart
// ⚠️ This creates an empty MAP, not a Set!
// var wrong = {};

// ✅ Correct ways to create empty Set
var numbers = <int>{};
Set<String> names = {};
var items = Set<int>();
```

### Set with Initial Values

```dart
var numbers = {1, 2, 3, 4, 5};
Set<String> fruits = {'apple', 'banana', 'cherry'};
```

### From List (Remove Duplicates)

```dart
var list = [1, 2, 2, 3, 3, 3, 4, 4, 4, 4];
var set = list.toSet();
print(set);  // {1, 2, 3, 4}

// Or using Set.from()
var set2 = Set.from(list);
```

---

## Visual: Set vs List

```
List (allows duplicates):
┌───┬───┬───┬───┬───┬───┐
│ 1 │ 2 │ 2 │ 3 │ 3 │ 3 │
└───┴───┴───┴───┴───┴───┘

Set (only unique):
┌───┬───┬───┐
│ 1 │ 2 │ 3 │
└───┴───┴───┘
```

---

## Adding and Removing

### Adding Items

```dart
var numbers = <int>{};

// Add single item
numbers.add(1);
numbers.add(2);
numbers.add(2);  // Ignored! Already exists
print(numbers);  // {1, 2}

// Add multiple items
numbers.addAll([3, 4, 5, 5, 5]);
print(numbers);  // {1, 2, 3, 4, 5}
```

### Removing Items

```dart
var numbers = {1, 2, 3, 4, 5};

// Remove single item
numbers.remove(3);
print(numbers);  // {1, 2, 4, 5}

// Remove by condition
numbers.removeWhere((n) => n % 2 == 0);
print(numbers);  // {1, 5}

// Clear all
numbers.clear();
print(numbers);  // {}
```

---

## Set Properties

```dart
var numbers = {1, 2, 3, 4, 5};

print(numbers.length);     // 5
print(numbers.isEmpty);    // false
print(numbers.isNotEmpty); // true
print(numbers.first);      // 1 (no guaranteed order!)
print(numbers.last);       // 5 (no guaranteed order!)
```

---

## Checking Membership

```dart
var fruits = {'apple', 'banana', 'cherry'};

// Check if contains
print(fruits.contains('banana'));  // true
print(fruits.contains('grape'));   // false

// Check multiple
print(fruits.containsAll(['apple', 'banana']));  // true
print(fruits.containsAll(['apple', 'grape']));   // false
```

---

## Set Operations

Sets support mathematical set operations:

### Union (Combine)

```dart
var set1 = {1, 2, 3};
var set2 = {3, 4, 5};

var union = set1.union(set2);
print(union);  // {1, 2, 3, 4, 5}
```

```
Set1: {1, 2, 3}
Set2: {3, 4, 5}
Union: {1, 2, 3, 4, 5}  ← All items from both
```

### Intersection (Common)

```dart
var set1 = {1, 2, 3, 4};
var set2 = {3, 4, 5, 6};

var intersection = set1.intersection(set2);
print(intersection);  // {3, 4}
```

```
Set1: {1, 2, 3, 4}
Set2: {3, 4, 5, 6}
Intersection: {3, 4}  ← Only items in BOTH
```

### Difference (Unique to First)

```dart
var set1 = {1, 2, 3, 4};
var set2 = {3, 4, 5, 6};

var difference = set1.difference(set2);
print(difference);  // {1, 2}
```

```
Set1: {1, 2, 3, 4}
Set2: {3, 4, 5, 6}
Difference: {1, 2}  ← Items in Set1 but NOT in Set2
```

### Visual Summary

```
     Set1          Set2
   ┌─────┐      ┌─────┐
   │1 2  │      │  5 6│
   │  ┌──┼──────┼──┐  │
   │  │3 │      │ 4│  │
   │  └──┼──────┼──┘  │
   └─────┘      └─────┘

Union:        {1, 2, 3, 4, 5, 6}  (everything)
Intersection: {3, 4}              (overlap only)
Difference:   {1, 2}              (Set1 - Set2)
```

---

## Iterating Through Sets

### For-in Loop

```dart
var fruits = {'apple', 'banana', 'cherry'};

for (var fruit in fruits) {
  print(fruit);
}
```

### forEach Method

```dart
var numbers = {1, 2, 3, 4, 5};

numbers.forEach((n) => print(n * 2));
// 2, 4, 6, 8, 10
```

---

## Converting Sets

### Set to List

```dart
var set = {3, 1, 4, 1, 5};  // {3, 1, 4, 5}
var list = set.toList();
print(list);  // [3, 1, 4, 5]

// Sort the list
list.sort();
print(list);  // [1, 3, 4, 5]
```

### List to Set (Remove Duplicates)

```dart
var list = ['a', 'b', 'a', 'c', 'b', 'a'];
var set = list.toSet();
print(set);  // {a, b, c}
```

---

## When to Use Sets

### Use Set When:
- You need unique items only
- You check membership frequently
- You do set operations (union, intersection)
- Order doesn't matter

### Use List When:
- Order matters
- You need duplicates
- You access by index

### Use Map When:
- You need key-value pairs
- You look up by identifier

---

## Practical Examples

### Example 1: Remove Duplicates

```dart
void main() {
  var emails = [
    'alice@email.com',
    'bob@email.com',
    'alice@email.com',  // duplicate
    'charlie@email.com',
    'bob@email.com',    // duplicate
  ];

  var uniqueEmails = emails.toSet().toList();
  print('Unique emails: ${uniqueEmails.length}');
  // Unique emails: 3
}
```

### Example 2: Find Common Friends

```dart
void main() {
  var aliceFriends = {'Bob', 'Charlie', 'Dave', 'Eve'};
  var bobFriends = {'Alice', 'Charlie', 'Frank', 'Eve'};

  // Friends in common
  var mutualFriends = aliceFriends.intersection(bobFriends);
  print('Mutual friends: $mutualFriends');
  // Mutual friends: {Charlie, Eve}

  // All friends combined
  var allFriends = aliceFriends.union(bobFriends);
  print('All friends: $allFriends');

  // Alice's friends that Bob doesn't have
  var uniqueToAlice = aliceFriends.difference(bobFriends);
  print('Only Alice\'s friends: $uniqueToAlice');
  // Only Alice's friends: {Bob, Dave}
}
```

### Example 3: Tag System

```dart
void main() {
  // Articles with tags
  var article1Tags = {'flutter', 'dart', 'mobile'};
  var article2Tags = {'flutter', 'web', 'responsive'};
  var article3Tags = {'dart', 'backend', 'server'};

  // All unique tags
  var allTags = article1Tags
      .union(article2Tags)
      .union(article3Tags);
  print('All tags: $allTags');

  // Articles about Flutter (check membership)
  if (article1Tags.contains('flutter')) {
    print('Article 1 is about Flutter');
  }

  // Tags common to article1 and article2
  var commonTags = article1Tags.intersection(article2Tags);
  print('Common tags: $commonTags');  // {flutter}
}
```

### Example 4: Permission System

```dart
void main() {
  var adminPermissions = {'read', 'write', 'delete', 'admin'};
  var userPermissions = {'read', 'write'};
  var guestPermissions = {'read'};

  // Check if user can write
  String role = 'user';
  Set<String> permissions;

  switch (role) {
    case 'admin':
      permissions = adminPermissions;
      break;
    case 'user':
      permissions = userPermissions;
      break;
    default:
      permissions = guestPermissions;
  }

  if (permissions.contains('write')) {
    print('User can write');
  }

  if (permissions.contains('delete')) {
    print('User can delete');
  } else {
    print('User cannot delete');
  }

  // What permissions does admin have that user doesn't?
  var adminOnly = adminPermissions.difference(userPermissions);
  print('Admin-only permissions: $adminOnly');
  // Admin-only permissions: {delete, admin}
}
```

### Example 5: Unique Visitors

```dart
void main() {
  // Visitors each day
  var mondayVisitors = {'user1', 'user2', 'user3'};
  var tuesdayVisitors = {'user2', 'user4', 'user5'};
  var wednesdayVisitors = {'user1', 'user3', 'user5', 'user6'};

  // Total unique visitors this week
  var weeklyVisitors = mondayVisitors
      .union(tuesdayVisitors)
      .union(wednesdayVisitors);
  print('Unique visitors this week: ${weeklyVisitors.length}');
  // Unique visitors this week: 6

  // Visitors who came every day
  var loyalVisitors = mondayVisitors
      .intersection(tuesdayVisitors)
      .intersection(wednesdayVisitors);
  print('Came every day: $loyalVisitors');
  // Came every day: {} (none came all three days)

  // Visitors who came Monday but not Tuesday
  var mondayOnly = mondayVisitors.difference(tuesdayVisitors);
  print('Only Monday: $mondayOnly');
  // Only Monday: {user1, user3}
}
```

---

## Summary

| Operation | Method | Example |
|-----------|--------|---------|
| Create | `{}` or `Set()` | `var s = {1, 2, 3}` |
| Add | `add()`, `addAll()` | `s.add(4)` |
| Remove | `remove()` | `s.remove(2)` |
| Check | `contains()` | `s.contains(1)` |
| Union | `union()` | `s1.union(s2)` |
| Intersection | `intersection()` | `s1.intersection(s2)` |
| Difference | `difference()` | `s1.difference(s2)` |
| Convert | `toList()`, `toSet()` | `list.toSet()` |

---

## Quick Quiz

**Q1:** What's the output?

```dart
var s = {1, 2, 2, 3, 3, 3};
print(s.length);
```

<details>
<summary>Answer</summary>

`3` - Sets only keep unique values: {1, 2, 3}

</details>

**Q2:** What's the result of `{1, 2, 3}.intersection({2, 3, 4})`?

<details>
<summary>Answer</summary>

`{2, 3}` - Only items in both sets.

</details>

**Q3:** How do you remove duplicates from a list?

<details>
<summary>Answer</summary>

```dart
var uniqueList = list.toSet().toList();
```

</details>

---

## Level 3 Complete!

You've learned:
- Functions: basics, parameters, return values
- Arrow functions and anonymous functions
- Lists: ordered collections
- Maps: key-value pairs
- Sets: unique collections

---

**Next Level:** Learn Object-Oriented Programming!

---

**Continue to:** `../../Level-04-OOP-Fundamentals/README.md`
