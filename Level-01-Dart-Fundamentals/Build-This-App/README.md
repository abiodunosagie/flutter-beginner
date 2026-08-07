# Build This App — CLI Personal Finance Day Log

## How to use this folder

1. Finish this level’s Theory + Examples + Exercises first.  
2. Create a new Dart file (DartPad or `dart create day_log`).  
3. Work the checklist in order.  
4. Only mark the level complete when **Definition of done** is true.

---

> **Level app project** for Dart fundamentals.

**Time:** 2–3 hours  
**Why it matters:** Variables, types, and input become real when you build a tiny tool.

## What you are building

A terminal program that asks for three expenses and prints a daily summary (total + average).

## Acceptance checklist

- [ ] Ask for expense 1, 2, 3 (name optional, amount required)  
- [ ] Reject non-numbers without crashing  
- [ ] Print total  
- [ ] Print average  
- [ ] Print a short “report” block that is easy to read  

## Steps

1. Create `main()` and print a welcome line.  
2. Write a function `double? readAmount(String label)` that loops until the user types a valid number.  
3. Call it three times; store amounts in variables or a `List<double>`.  
4. Compute `total` and `average`.  
5. Print:

```text
=== Day report ===
Total: 42.50
Average: 14.17
=================
```

### Starter sketch

```dart
import 'dart:io';

double readAmount(String label) {
  while (true) {
    stdout.write('$label: ');
    final raw = stdin.readLineSync();
    final value = double.tryParse(raw ?? '');
    if (value != null && value >= 0) return value;
    print('Please enter a valid number.');
  }
}

void main() {
  print('Daily expense log');
  final a = readAmount('Expense 1');
  final b = readAmount('Expense 2');
  final c = readAmount('Expense 3');
  final total = a + b + c;
  final avg = total / 3;
  print('=== Day report ===');
  print('Total: ${total.toStringAsFixed(2)}');
  print('Average: ${avg.toStringAsFixed(2)}');
}
```

## Definition of done

Program prints total and average after three valid inputs; invalid input asks again.

## After this

Level 02 Build-This-App (quiz game).
