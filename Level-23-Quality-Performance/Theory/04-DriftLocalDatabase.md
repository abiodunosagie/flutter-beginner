# Drift (modern local SQLite)

Drift = type-safe SQL over sqflite.

## When to use

- Complex queries, joins, migrations  
- Beyond simple key-value  

## Shape

```dart
// Conceptual tables + generated code
@DriftDatabase(tables: [Todos])
class AppDatabase extends _$AppDatabase { ... }
```

## vs Hive / shared_preferences

| Tool | Best for |
|------|----------|
| shared_preferences | Flags, tiny prefs |
| Hive | Simple objects, fast |
| sqflite raw | Full control SQL |
| Drift | Typed SQL + migrations |

## Practice

Migrate Habit Tracker storage to Drift tables (title, completedDays as child table or JSON column).
