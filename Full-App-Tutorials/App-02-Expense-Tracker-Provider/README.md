# App 02: Expense Tracker (Provider) — Complete Tutorial

> Track spending by category with totals and filters. Classic fintech-style junior/mid take-home shape.

**Time:** 10–14 hours  
**Minimum level:** 06–07  
**State:** Provider only (stay consistent)

---

## 1. What you are building

An app to:

- Log expenses (title, amount, category, date)  
- Filter by category  
- See **total** for the visible list  
- Edit / delete  
- Persist locally  

---

## 2. Features

- [ ] Add expense form with validation  
- [ ] List expenses (newest first)  
- [ ] Category filter chips (All + each category)  
- [ ] Total header updates with filter  
- [ ] Delete expense  
- [ ] Edit expense  
- [ ] Persist JSON  
- [ ] Empty + error-free validation messages  

**Stretch:** month selector, `fl_chart` bar chart, CSV export

---

## 3. Project setup

```bash
flutter create expense_tracker
cd expense_tracker
flutter pub add provider shared_preferences intl
```

---

## 4. Folders

```
lib/
  main.dart
  models/expense.dart
  data/expense_storage.dart
  providers/expense_provider.dart
  pages/home_page.dart
  pages/expense_form_page.dart
  widgets/expense_tile.dart
  widgets/category_filter.dart
  widgets/total_header.dart
```

---

## 5. Model

```dart
enum ExpenseCategory { food, transport, bills, fun, health, other }

extension ExpenseCategoryX on ExpenseCategory {
  String get label => name[0].toUpperCase() + name.substring(1);
}

class Expense {
  final String id;
  final String title;
  final double amount;
  final ExpenseCategory category;
  final DateTime date;

  const Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'amount': amount,
        'category': category.name,
        'date': date.toIso8601String(),
      };

  factory Expense.fromJson(Map<String, dynamic> j) => Expense(
        id: j['id'] as String,
        title: j['title'] as String,
        amount: (j['amount'] as num).toDouble(),
        category: ExpenseCategory.values.byName(j['category'] as String),
        date: DateTime.parse(j['date'] as String),
      );
}
```

---

## 6. Provider responsibilities

```dart
class ExpenseProvider extends ChangeNotifier {
  final _items = <Expense>[];
  ExpenseCategory? filter; // null = all

  List<Expense> get visible {
    final list = filter == null
        ? [..._items]
        : _items.where((e) => e.category == filter).toList();
    list.sort((a, b) => b.date.compareTo(a.date));
    return list;
  }

  double get total => visible.fold(0.0, (a, e) => a + e.amount);

  void setFilter(ExpenseCategory? c) {
    filter = c;
    notifyListeners();
  }

  Future<void> add(Expense e) async { _items.add(e); await _persist(); notifyListeners(); }
  Future<void> update(Expense e) async {
    final i = _items.indexWhere((x) => x.id == e.id);
    if (i >= 0) _items[i] = e;
    await _persist();
    notifyListeners();
  }
  Future<void> remove(String id) async {
    _items.removeWhere((e) => e.id == id);
    await _persist();
    notifyListeners();
  }

  // load/save like Habit app
}
```

---

## 7. Form validation rules

| Field | Rule |
|-------|------|
| Title | non-empty after trim |
| Amount | parseable double, `> 0` |
| Date | not in the future |
| Category | required (default food) |

Use `Form` + `GlobalKey<FormState>`.

---

## 8. Build order (do in order)

1. **Models + seed 5 fake expenses** (no persistence yet)  
   - *Done when:* list shows seed data  
2. **Provider + totals**  
   - *Done when:* total matches sum of list  
3. **Filter chips**  
   - *Done when:* filtering Food hides Transport  
4. **Add form page**  
   - *Done when:* invalid amount shows error text  
5. **Delete + edit**  
   - *Done when:* edit updates same id  
6. **Persistence**  
   - *Done when:* kill app keeps data  

---

## 9. UI layout

```
AppBar: Expenses
Body:
  TotalHeader (big currency)
  CategoryFilter (horizontal chips)
  ListView of ExpenseTile
FAB: add
```

Format money with:

```dart
NumberFormat.simpleCurrency().format(amount)
```

---

## 10. Test script

1. Add “Uber” $12 Transport  
2. Filter Transport → only Uber; total $12  
3. Filter All → full total  
4. Edit amount to 15 → total updates  
5. Kill app → data remains  

---

## 11. Common mistakes

- Storing amount as String forever (parse once, store double)  
- Sorting on every build without copy (mutate original list order accidentally)  
- Forgetting `notifyListeners` after filter change  

---

## 12. Portfolio blurb

> Expense tracker using Provider, category filters, validated forms, and local persistence — typical fintech list/detail patterns.

## Done when

All checkboxes pass and the test script works cold-start.
