# App 09: Fitness Tracker — Full Tutorial

> Log workouts, history, weekly volume chart.

**Min level:** 09–14 · **Time:** 12–18 hours  

## Features
- Workout types (run, gym, yoga)  
- Duration + calories estimate  
- History list by date  
- Weekly totals chart  
- Local DB: `sqflite` or `hive`  

## Domain
```dart
class Workout {
  final String id;
  final String type;
  final int durationMinutes;
  final int calories;
  final DateTime date;
}
```

## Screens
Dashboard (this week), Add workout, History, Settings (units)

## Stretch
- Health-ish permissions mock  
- Animations on complete (L14)  
- Cloud backup (L11)

## Portfolio
> Fitness logger with local persistence and weekly analytics UI.
