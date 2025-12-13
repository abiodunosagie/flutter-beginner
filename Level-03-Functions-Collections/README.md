# Level 3: Functions & Collections

Welcome to Level 3! You'll learn to organize code with functions and work with data collections.

---

## What You'll Learn

### Functions
- Why functions matter
- Creating and calling functions
- Parameters and return values
- Optional and named parameters
- Arrow functions
- Anonymous functions

### Collections
- Lists (arrays)
- Maps (dictionaries)
- Sets (unique items)
- Iterating through collections
- Common operations

---

## Learning Path

### Theory (Read First)
1. `Theory/01-FunctionBasics.md` - What are functions?
2. `Theory/02-Parameters.md` - Passing data to functions
3. `Theory/03-ReturnValues.md` - Getting data back
4. `Theory/04-Lists.md` - Working with lists
5. `Theory/05-Maps.md` - Key-value pairs
6. `Theory/06-Sets.md` - Unique collections

### Examples (Study Second)
1. `Examples/Example01-BasicFunctions.dart`
2. `Examples/Example02-ParameterTypes.dart`
3. `Examples/Example03-ListOperations.dart`
4. `Examples/Example04-MapOperations.dart`
5. `Examples/Example05-RealWorldExamples.dart`

### Exercises (Practice Last)
- `Exercises/Exercises.md`

---

## Prerequisites

Complete Level 2 (Control Flow) first. You should know:
- If/else statements
- Switch statements
- For and while loops
- Break and continue

---

## Key Concepts Preview

### Functions

```dart
// Function declaration
int add(int a, int b) {
  return a + b;
}

// Function call
int result = add(5, 3);  // 8
```

### Lists

```dart
List<String> fruits = ['apple', 'banana', 'cherry'];
fruits.add('date');
print(fruits[0]);  // apple
```

### Maps

```dart
Map<String, int> ages = {
  'Alice': 25,
  'Bob': 30,
};
print(ages['Alice']);  // 25
```

### Sets

```dart
Set<int> numbers = {1, 2, 3, 3, 3};
print(numbers);  // {1, 2, 3} - duplicates removed!
```

---

## Learning Objectives

By the end of this level, you will:

1. ✅ Create functions with different parameter types
2. ✅ Return values from functions
3. ✅ Use arrow syntax for simple functions
4. ✅ Work with anonymous functions and closures
5. ✅ Create and manipulate Lists
6. ✅ Use Maps for key-value storage
7. ✅ Apply Sets for unique collections
8. ✅ Choose the right collection for each task

---

## Time Estimate

- Theory: 60-90 minutes
- Examples: 45-60 minutes
- Exercises: 60-90 minutes

**Total: 3-4 hours**

---

## Quick Tips

💡 **Function Tip**: If your function is one line, use arrow syntax: `int square(int n) => n * n;`

💡 **List Tip**: Use `for-in` loops to iterate: `for (var item in list)`

💡 **Map Tip**: Access values with `map['key']` or safely with `map['key'] ?? defaultValue`

💡 **Set Tip**: Use Sets when you need unique items and don't care about order

---

**Start Here:** `Theory/01-FunctionBasics.md`
