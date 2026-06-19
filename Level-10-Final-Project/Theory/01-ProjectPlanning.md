# Project Planning: Before You Write Code

## The Big Idea In One Sentence

> Plan before you code: decide what the app does, list its features, sketch the screens, and plan the data, so building becomes following a recipe instead of guessing.

## The Simple Explanation

Imagine you want to bake a cake. Would you just throw random ingredients together and hope for the best?

**No!** You'd:
1. Decide what kind of cake
2. Get the recipe
3. Gather ingredients
4. Follow the steps

**Building an app is the same!**

```
Without Planning:              With Planning:
┌─────────────────┐           ┌─────────────────┐
│ Start coding    │           │ Think first     │
│      ↓          │           │      ↓          │
│ Get confused    │           │ Sketch screens  │
│      ↓          │           │      ↓          │
│ Start over      │           │ Plan features   │
│      ↓          │           │      ↓          │
│ Get confused    │           │ Start coding    │
│      ↓          │           │      ↓          │
│ Give up 😢      │           │ Finish faster!  │
│                 │           │      ↓          │
│                 │           │ Success! 🎉     │
└─────────────────┘           └─────────────────┘
```

---

## Step 1: Define Your App

Answer these questions first:

### What is it?
```
Example: A task manager app

"An app that helps users organize their daily tasks
with categories, due dates, and reminders."
```

### Who is it for?
```
Example:
- Busy professionals
- Students
- Anyone who needs to stay organized
```

### What problem does it solve?
```
Example:
- People forget tasks
- Hard to prioritize
- No central place for todos
```

---

## Step 2: List Your Features

### Start with Must-Have Features

```
MUST HAVE (Core Features):
┌─────────────────────────────────────────┐
│ ✓ Add tasks                             │
│ ✓ View task list                        │
│ ✓ Mark tasks complete                   │
│ ✓ Delete tasks                          │
│ ✓ Data saves when app closes            │
└─────────────────────────────────────────┘
```

### Then Nice-to-Have Features

```
NICE TO HAVE (Add Later):
┌─────────────────────────────────────────┐
│ ○ Categories/Tags                       │
│ ○ Due dates                             │
│ ○ Reminders/Notifications               │
│ ○ Search tasks                          │
│ ○ Dark mode                             │
│ ○ Sync across devices                   │
└─────────────────────────────────────────┘
```

### Priority Order

```
Build in this order:

HIGH PRIORITY (Build First)
├── 1. View tasks list
├── 2. Add new task
├── 3. Mark task complete
└── 4. Delete task

MEDIUM PRIORITY (Build Second)
├── 5. Edit task
├── 6. Categories
└── 7. Due dates

LOW PRIORITY (Build Last)
├── 8. Search
├── 9. Settings
└── 10. Theme options
```

---

## Step 3: Sketch Your Screens

You don't need fancy tools. Paper and pencil work great!

### Main Screens

```
┌─────────────────┐  ┌─────────────────┐  ┌─────────────────┐
│   SPLASH        │  │   HOME          │  │   ADD TASK      │
│                 │  │                 │  │                 │
│    [Logo]       │  │  [+ Add Task]   │  │  Title: ____    │
│                 │  │                 │  │                 │
│   Loading...    │  │  □ Buy milk     │  │  Category: __   │
│                 │  │  ✓ Call mom     │  │                 │
│                 │  │  □ Finish work  │  │  Due: ______    │
│                 │  │                 │  │                 │
│                 │  │  [Settings ⚙️]   │  │  [Save] [Cancel]│
└─────────────────┘  └─────────────────┘  └─────────────────┘
       ↓                    ↓                     ↓
    (2 sec)           Main Screen           Modal/Dialog
```

### Screen Flow (Navigation Map)

```
                    ┌───────────┐
                    │  Splash   │
                    └─────┬─────┘
                          │
                          ▼
                    ┌───────────┐
           ┌────────│   Home    │────────┐
           │        └───────────┘        │
           │              │              │
           ▼              ▼              ▼
     ┌───────────┐  ┌───────────┐  ┌───────────┐
     │ Add Task  │  │Task Detail│  │ Settings  │
     └───────────┘  └───────────┘  └───────────┘
                          │
                          ▼
                    ┌───────────┐
                    │ Edit Task │
                    └───────────┘
```

---

## Step 4: Plan Your Data

### What data do you need to store?

```dart
// Task Model
class Task {
  String id;
  String title;
  String? description;
  String category;
  DateTime? dueDate;
  bool isCompleted;
  DateTime createdAt;
}

// Category Model
class Category {
  String id;
  String name;
  Color color;
  IconData icon;
}

// Settings
class AppSettings {
  bool isDarkMode;
  bool showCompletedTasks;
  String sortOrder; // 'date', 'name', 'priority'
}
```

### Where will data be stored?

```
┌─────────────────────────────────────────────────────┐
│                   DATA STORAGE                       │
├─────────────────────────────────────────────────────┤
│                                                      │
│  SharedPreferences (Simple settings)                │
│  ├── isDarkMode: true/false                         │
│  ├── showCompleted: true/false                      │
│  └── sortOrder: "date"                              │
│                                                      │
│  SQLite Database (Complex data)                     │
│  ├── tasks table                                    │
│  │   ├── id, title, description                     │
│  │   ├── category_id, due_date                      │
│  │   └── is_completed, created_at                   │
│  │                                                   │
│  └── categories table                               │
│      ├── id, name                                   │
│      └── color, icon                                │
│                                                      │
└─────────────────────────────────────────────────────┘
```

---

## Step 5: Choose Your Tools

### State Management

Pick ONE:

| Tool | Best For | Difficulty |
|------|----------|------------|
| Provider | Small-medium apps | Easy |
| Riverpod | Medium-large apps | Medium |
| BLoC | Large apps, teams | Medium-Hard |

### Packages

```yaml
# Your pubspec.yaml

dependencies:
  flutter:
    sdk: flutter

  # State Management
  provider: ^6.1.1

  # Database
  sqflite: ^2.3.0
  path: ^1.8.3

  # Settings
  shared_preferences: ^2.2.2

  # UI Helpers
  intl: ^0.18.1  # For date formatting

  # Optional but nice
  uuid: ^4.2.1  # For generating IDs
```

---

## Step 6: Plan Your Folder Structure

```
lib/
│
├── main.dart              # App entry point
├── app.dart               # MaterialApp setup
│
├── config/
│   ├── routes.dart        # Navigation routes
│   ├── theme.dart         # App theme
│   └── constants.dart     # Magic values
│
├── models/
│   ├── task.dart
│   └── category.dart
│
├── services/
│   ├── database_service.dart
│   └── preferences_service.dart
│
├── providers/
│   ├── task_provider.dart
│   └── settings_provider.dart
│
├── screens/
│   ├── splash_screen.dart
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   ├── task/
│   │   ├── add_task_screen.dart
│   │   └── task_detail_screen.dart
│   └── settings/
│       └── settings_screen.dart
│
└── widgets/
    ├── task_tile.dart
    └── category_chip.dart
```

---

## Step 7: Create a Development Checklist

Break your project into small, completable tasks:

```
Week 1: Foundation
─────────────────────────────────────
□ Create Flutter project
□ Setup folder structure
□ Add dependencies
□ Create theme configuration
□ Create Task model
□ Setup SQLite database
□ Create DatabaseService

Week 1: Core Features
─────────────────────────────────────
□ Build Home Screen layout
□ Display tasks list
□ Add "Add Task" button
□ Build Add Task screen
□ Implement create task
□ Implement mark complete
□ Implement delete task

Week 2: Enhanced Features
─────────────────────────────────────
□ Add categories
□ Add due dates
□ Add task editing
□ Add search
□ Add settings screen
□ Implement dark mode

Week 2: Polish
─────────────────────────────────────
□ Add splash screen
□ Add loading states
□ Add empty states
□ Handle errors
□ Test everything
□ Fix bugs
```

---

## Common Planning Mistakes

### Mistake 1: Too Many Features at Start

```
❌ BAD: "I'll add login, social sharing, cloud sync,
         notifications, widgets, AI suggestions..."

✅ GOOD: "I'll start with add, view, complete, delete.
         Then add more features one at a time."
```

### Mistake 2: No Visual Planning

```
❌ BAD: Starting to code without sketching screens

✅ GOOD: Draw rough sketches of every screen first
```

### Mistake 3: Ignoring Data Planning

```
❌ BAD: "I'll figure out the database later"

✅ GOOD: Plan your data models before coding
```

### Mistake 4: Not Breaking Tasks Down

```
❌ BAD: "Task 1: Build the app"

✅ GOOD: "Task 1: Create Task model
         Task 2: Setup database
         Task 3: Build task list widget
         Task 4: Add create function
         ..."
```

---

## Planning Template

Copy this template for your project:

```markdown
# [App Name] Project Plan

## 1. App Overview
- **What**: [One sentence description]
- **Who**: [Target users]
- **Why**: [Problem it solves]

## 2. Core Features (Must Have)
1. [ ] Feature 1
2. [ ] Feature 2
3. [ ] Feature 3

## 3. Nice-to-Have Features
1. [ ] Feature A
2. [ ] Feature B

## 4. Screens
- Splash Screen
- Home Screen
- [List all screens]

## 5. Data Models
- Model 1: [fields]
- Model 2: [fields]

## 6. Technology Choices
- State Management: [Provider/Riverpod/BLoC]
- Database: [SQLite/Hive]
- Other packages: [list]

## 7. Development Phases
- Phase 1: [Description]
- Phase 2: [Description]
- Phase 3: [Description]
```

---

## Summary

```
┌─────────────────────────────────────────────────────────┐
│              PROJECT PLANNING SUMMARY                    │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  1. DEFINE - What is your app?                          │
│                                                          │
│  2. FEATURES - What will it do?                         │
│                                                          │
│  3. SKETCH - What will it look like?                    │
│                                                          │
│  4. DATA - What information will it store?              │
│                                                          │
│  5. TOOLS - What packages will you use?                 │
│                                                          │
│  6. STRUCTURE - How will code be organized?             │
│                                                          │
│  7. TASKS - What are the small steps?                   │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why plan before writing code?

<details>
<summary>Answer</summary>
So you build the right thing in the right order, instead of guessing, rewriting, and getting stuck. Planning saves time later.
</details>

**Q2.** What does "MVP" (must-have features) help you avoid?

<details>
<summary>Answer</summary>
Doing too much at once. You build the core that makes the app useful first, and add nice-to-haves later.
</details>

**Q3.** Why sketch screens and plan data models before coding?

<details>
<summary>Answer</summary>
So you know what screens you need and what each one shows/stores, which makes the code structure obvious.
</details>

---

## Assignment

Plan a simple "Habit Tracker" app.

### Problem 1: Must-have features

List 3 must-have features for a basic habit tracker.

### Problem 2: A data model

Sketch a `Habit` model: list 3 fields it should have.

### Problem 3: Screens

Name 2 screens this app needs.

---

## Assignment Answers

### Problem 1: Must-have features

Examples: add a habit, mark a habit done for today, see your list of habits (and maybe a streak count).

### Problem 2: A data model

```dart
class Habit {
  final String id;
  final String name;
  final bool doneToday; // (or a list of completed dates)
}
```

### Problem 3: Screens

Examples: a Home/list screen showing all habits, and an Add Habit screen. (A details/stats screen would be a nice-to-have.)

---

**Next:** `02-AppArchitecture.md` - Organizing your code

---

**Remember:**

> "Give me six hours to chop down a tree and I will spend
> the first four sharpening the axe." - Abraham Lincoln

Planning IS productive work. Don't skip it! 🎯
