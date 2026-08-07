# App 02: Expense Tracker (Provider) — Full Tutorial

> Employer classic: money list, categories, totals, filters.

**Min level:** 06–07 · **Time:** 10–14 hours · **State:** Provider  

---

## Product

- Add expense (title, amount, category, date)  
- Category chips filter  
- Total for period (today / week / month)  
- Delete + edit  
- Optional simple bar chart (`fl_chart`)

---

## Domain

```dart
enum ExpenseCategory { food, transport, bills, fun, health, other }

class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;
}
```

---

## Provider design

```dart
class ExpenseProvider extends ChangeNotifier {
  final _items = <Expense>[];
  ExpenseCategory? filter;
  DateRange range = DateRange.month;

  List<Expense> get visible => /* filter + range */;
  double get total => visible.fold(0, (a, e) => a + e.amount);

  void add(Expense e) { _items.add(e); notifyListeners(); }
  void remove(String id) { ... }
}
```

Screens: Home (list+total), AddExpense form, optional Stats.

---

## Implementation order

1. Models + fake seed data  
2. Provider wiring in `MultiProvider`  
3. List + total header  
4. Form with validation (`Form` + `GlobalKey`)  
5. Filters  
6. Persistence (shared_preferences JSON)  
7. Chart stretch  

---

## Validation rules

- Amount > 0  
- Title non-empty  
- Date not in future  

## Portfolio line

> Expense tracker with Provider, category filters, period totals, and form validation.
