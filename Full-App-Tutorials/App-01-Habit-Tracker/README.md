# App 01: Habit Tracker (Full Tutorial)

> Daily habits with streaks — first portfolio app after Flutter UI + basic state.

**Min level:** 05–06 · **Time:** 6–10 hours · **State:** `setState` first, then upgrade to Provider

---

## Product

- Create habit (name, icon color)  
- Check off today  
- Streak count  
- List + empty state  
- Local persistence (shared_preferences or hive)

---

## Architecture

```
lib/
  main.dart
  models/habit.dart
  data/habit_repository.dart
  features/home/home_page.dart
  features/habits/add_habit_sheet.dart
  features/habits/habit_tile.dart
  app_state.dart  # or Provider
```

---

## Model

```dart
class Habit {
  final String id;
  final String name;
  final int colorValue;
  final List<String> completedDays; // yyyy-MM-dd
  final DateTime createdAt;

  int get streak {
    // count consecutive days ending today or yesterday
    // implement carefully with DateTime dates only
    return _computeStreak(completedDays);
  }

  bool get isDoneToday {
    final key = _dayKey(DateTime.now());
    return completedDays.contains(key);
  }
}
```

---

## Features checklist

1. [ ] Add habit form validation  
2. [ ] Toggle complete for today  
3. [ ] Persist JSON list  
4. [ ] Reload on launch  
5. [ ] Delete habit  
6. [ ] Streak display  
7. [ ] Upgrade: `ChangeNotifier` + Provider so add sheet updates list  

---

## UI map

- AppBar title “Habits”  
- ListView of cards: name, streak flame, checkbox  
- FAB → modal bottom sheet  
- Empty: illustration + CTA  

---

## Stretch

- Weekly heatmap  
- Notifications (level 12)  
- Firebase sync (level 11)  

## Portfolio line

> Flutter habit tracker with local persistence, streak logic, and clean feature folders.
