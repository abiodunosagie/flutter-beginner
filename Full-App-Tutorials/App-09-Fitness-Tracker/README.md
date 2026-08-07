# App 09: Fitness Tracker — Complete Tutorial

> Log workouts, review history, see weekly totals. Health-app pattern with local database.

**Time:** 12–18 hours  
**Minimum level:** 09  
**Storage:** `sqflite` or `hive` (pick one)

---

## 1. What you are building

- Add workout (type, duration minutes, date, optional notes)  
- Estimate calories with a simple formula  
- History list grouped by day  
- Dashboard: this week’s total minutes + calories  
- Optional simple chart  

---

## 2. Features

- [ ] Add / edit / delete workout  
- [ ] Types: run, walk, gym, cycle, yoga, other  
- [ ] Calories estimate  
- [ ] Persist across launches  
- [ ] Dashboard weekly summary  
- [ ] Empty states  
- [ ] Date picker  

---

## 3. Calories formula (transparent)

```dart
int estimateCalories(String type, int minutes) {
  const met = {
    'run': 9.8,
    'walk': 3.5,
    'gym': 6.0,
    'cycle': 7.5,
    'yoga': 3.0,
    'other': 4.0,
  };
  const weightKg = 70; // settings stretch
  final m = met[type] ?? 4.0;
  return (m * weightKg * (minutes / 60)).round();
}
```

Show formula in UI as “estimate”.

---

## 4. Folders

```
lib/
  models/workout.dart
  data/workout_db.dart
  providers/workout_provider.dart
  pages/dashboard_page.dart
  pages/history_page.dart
  pages/workout_form_page.dart
  widgets/week_summary_card.dart
```

---

## 5. Build order

1. Model + in-memory list UI  
2. Form validation (minutes > 0)  
3. Database layer + repository  
4. Dashboard aggregates (filter last 7 days)  
5. History  
6. Chart stretch (`fl_chart`)  

---

## 6. Test script

1. Add 30 min run → calories > 0  
2. Kill app → workout remains  
3. Dashboard week total includes it  
4. Delete → totals drop  

---

## 7. Common mistakes

- Storing DateTime as unparsable string  
- Aggregates in UI only (duplicate logic) — put in provider/domain  
- Not indexing date queries (fine for small data)

---

## 8. Portfolio blurb

> Fitness logger with local persistence, calorie estimates, and weekly summary dashboard.

## Done when

CRUD + weekly summary work after cold start.
