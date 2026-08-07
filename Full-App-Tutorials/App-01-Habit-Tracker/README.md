# App 01: Habit Tracker — Complete Tutorial

> Build a daily habit app with streaks and local save. This is your first “I can ship a product” Flutter app after UI + state.

**Time:** 6–10 hours  
**Minimum level:** 05–06  
**State:** start with `setState`, then upgrade to **Provider** (recommended final form)

---

## 1. What you are building

A phone app where someone:

1. Adds habits (“Gym”, “Read 20 min”)  
2. Marks today done  
3. Sees a **streak** number  
4. Closes the app and **data is still there** next launch  

---

## 2. Features (must all pass)

- [ ] Add habit (name required)  
- [ ] List habits  
- [ ] Toggle “done today”  
- [ ] Show streak  
- [ ] Delete habit  
- [ ] Empty state when no habits  
- [ ] Persist with `shared_preferences` (JSON)  
- [ ] Reload on launch  

**Stretch (optional):** weekly heat map, notifications (Level 12)

---

## 3. Create the project

```bash
flutter create habit_tracker
cd habit_tracker
flutter pub add shared_preferences provider intl
```

---

## 4. Folder structure

```
lib/
  main.dart
  models/habit.dart
  data/habit_storage.dart
  providers/habit_provider.dart
  pages/home_page.dart
  widgets/habit_tile.dart
  widgets/add_habit_sheet.dart
```

---

## 5. Domain model

```dart
class Habit {
  final String id;
  final String name;
  final List<String> completedDays; // 'yyyy-MM-dd'

  Habit({required this.id, required this.name, List<String>? completedDays})
      : completedDays = completedDays ?? [];

  static String dayKey([DateTime? d]) {
    final x = d ?? DateTime.now();
    final m = x.month.toString().padLeft(2, '0');
    final day = x.day.toString().padLeft(2, '0');
    return '${x.year}-$m-$day';
  }

  bool get isDoneToday => completedDays.contains(dayKey());

  int get streak {
    // Count consecutive days ending today (or yesterday if not done today yet).
    var cursor = DateTime.now();
    if (!isDoneToday) {
      cursor = cursor.subtract(const Duration(days: 1));
    }
    var count = 0;
    while (completedDays.contains(dayKey(cursor))) {
      count++;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    return count;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'completedDays': completedDays,
      };

  factory Habit.fromJson(Map<String, dynamic> j) => Habit(
        id: j['id'] as String,
        name: j['name'] as String,
        completedDays: List<String>.from(j['completedDays'] as List? ?? []),
      );
}
```

---

## 6. Storage

```dart
class HabitStorage {
  static const _key = 'habits_v1';

  Future<List<Habit>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.isEmpty) return [];
    final list = jsonDecode(raw) as List;
    return list.map((e) => Habit.fromJson(Map<String, dynamic>.from(e as Map))).toList();
  }

  Future<void> save(List<Habit> habits) async {
    final prefs = await SharedPreferences.getInstance();
    final raw = jsonEncode(habits.map((h) => h.toJson()).toList());
    await prefs.setString(_key, raw);
  }
}
```

Remember: `import 'dart:convert';`

---

## 7. Provider

```dart
class HabitProvider extends ChangeNotifier {
  HabitProvider(this._storage);
  final HabitStorage _storage;
  final List<Habit> _habits = [];
  bool loading = true;

  List<Habit> get habits => List.unmodifiable(_habits);

  Future<void> init() async {
    loading = true;
    notifyListeners();
    _habits
      ..clear()
      ..addAll(await _storage.load());
    loading = false;
    notifyListeners();
  }

  Future<void> add(String name) async {
    final trimmed = name.trim();
    if (trimmed.isEmpty) return;
    _habits.add(Habit(id: DateTime.now().microsecondsSinceEpoch.toString(), name: trimmed));
    await _storage.save(_habits);
    notifyListeners();
  }

  Future<void> toggleToday(String id) async {
    final i = _habits.indexWhere((h) => h.id == id);
    if (i < 0) return;
    final h = _habits[i];
    final key = Habit.dayKey();
    final days = [...h.completedDays];
    if (days.contains(key)) {
      days.remove(key);
    } else {
      days.add(key);
    }
    _habits[i] = Habit(id: h.id, name: h.name, completedDays: days);
    await _storage.save(_habits);
    notifyListeners();
  }

  Future<void> delete(String id) async {
    _habits.removeWhere((h) => h.id == id);
    await _storage.save(_habits);
    notifyListeners();
  }
}
```

---

## 8. UI steps

### Step A — main

```dart
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => HabitProvider(HabitStorage())..init(),
      child: const MaterialApp(home: HomePage()),
    ),
  );
}
```

### Step B — HomePage

- `Consumer<HabitProvider>`  
- If `loading` → `CircularProgressIndicator`  
- If empty → `Text('No habits yet')` + button to add  
- Else `ListView` of tiles  
- FAB opens `AddHabitSheet`  

### Step C — HabitTile

- Title  
- Subtitle: `Streak: ${habit.streak}`  
- Trailing: Checkbox for `isDoneToday` → `toggleToday`  
- Swipe to delete or icon button  

### Step D — Add sheet

- `TextField` + Add button  
- Validate empty name  
- `Navigator.pop` after add  

---

## 9. Test script (do this)

1. Add “Water” and “Read”  
2. Mark Water done → streak becomes 1  
3. Kill app completely  
4. Relaunch → both habits still there; Water still done today  
5. Delete Read → gone after relaunch  

---

## 10. Common mistakes

| Mistake | Fix |
|---------|-----|
| Saving only in memory | Always call `storage.save` after changes |
| Streak wrong near midnight | Use date-only keys, not DateTime equality |
| Mutating list inside Habit without new instance | Replace habit object then notify |
| No loading flag | User sees empty flash on start |

---

## 11. Portfolio blurb

> Flutter habit tracker with Provider, streak logic, and SharedPreferences persistence. Demonstrates domain modeling and multi-widget state updates.

---

## Done when

All feature checkboxes are ticked **and** the test script passes without hot-restart tricks.
