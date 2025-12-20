# Project A: Task Manager App

## Overview

Build a complete task management app where users can create, organize, and track their daily tasks.

```
┌─────────────────────────────────────────────────────────┐
│                    TASK MANAGER                          │
├─────────────────────────────────────────────────────────┤
│                                                          │
│  "Your personal productivity companion"                  │
│                                                          │
│  Features:                                               │
│  ├── Create and manage tasks                            │
│  ├── Organize with categories                           │
│  ├── Set due dates                                      │
│  ├── Track completion progress                          │
│  └── Persist data locally                               │
│                                                          │
└─────────────────────────────────────────────────────────┘
```

---

## Core Features (Required)

### 1. Task Management

```
MUST HAVE:
□ Create new tasks with title
□ View list of all tasks
□ Mark tasks as complete/incomplete
□ Delete tasks
□ Tasks persist when app restarts
```

### 2. Task Details

```
Each task should have:
├── Title (required)
├── Description (optional)
├── Created date (automatic)
├── Completion status
└── Category (optional)
```

### 3. Categories

```
MUST HAVE:
□ At least 3 default categories
   (e.g., Work, Personal, Shopping)
□ Tasks can be assigned to a category
□ Filter tasks by category
```

---

## Screens

### Screen 1: Home Screen

```
┌─────────────────────────────────────┐
│  [≡]  My Tasks            [+]      │
├─────────────────────────────────────┤
│                                     │
│  ┌─ All ─┬─ Work ─┬─ Personal ─┐   │
│  └───────┴────────┴────────────┘   │
│                                     │
│  Today's Tasks (3)                  │
│  ┌─────────────────────────────┐   │
│  │ □ Buy groceries             │   │
│  │   Personal • Due today      │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ □ Finish report             │   │
│  │   Work • Due tomorrow       │   │
│  └─────────────────────────────┘   │
│  ┌─────────────────────────────┐   │
│  │ ✓ Call dentist              │   │
│  │   Personal • Completed      │   │
│  └─────────────────────────────┘   │
│                                     │
│  Completed (1/3)                    │
│  ████████░░░░░░░░░░░░  33%         │
│                                     │
└─────────────────────────────────────┘
```

### Screen 2: Add/Edit Task

```
┌─────────────────────────────────────┐
│  [←]  New Task           [Save]    │
├─────────────────────────────────────┤
│                                     │
│  Title *                            │
│  ┌─────────────────────────────┐   │
│  │ Enter task title...         │   │
│  └─────────────────────────────┘   │
│                                     │
│  Description                        │
│  ┌─────────────────────────────┐   │
│  │ Add more details...         │   │
│  │                             │   │
│  └─────────────────────────────┘   │
│                                     │
│  Category                           │
│  ┌─ Work ─┐ ┌─ Personal ─┐         │
│  └────────┘ └────────────┘         │
│  ┌─ Shopping ─┐                    │
│  └────────────┘                    │
│                                     │
│  Due Date                           │
│  ┌─────────────────────────────┐   │
│  │ 📅 Select date...           │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

### Screen 3: Task Detail (Optional)

```
┌─────────────────────────────────────┐
│  [←]  Task Details    [🗑] [✏️]    │
├─────────────────────────────────────┤
│                                     │
│  Buy groceries                      │
│  ────────────────────────────────   │
│                                     │
│  📝 Description                     │
│  Get milk, eggs, bread, and        │
│  vegetables for the week.           │
│                                     │
│  📁 Category: Personal              │
│                                     │
│  📅 Due: Today                      │
│                                     │
│  📆 Created: Jan 15, 2024          │
│                                     │
│  ────────────────────────────────   │
│                                     │
│  ┌─────────────────────────────┐   │
│  │     Mark as Complete ✓      │   │
│  └─────────────────────────────┘   │
│                                     │
└─────────────────────────────────────┘
```

---

## Data Model

```dart
// models/task.dart
class Task {
  final String id;
  final String title;
  final String? description;
  final String? categoryId;
  final DateTime? dueDate;
  final bool isCompleted;
  final DateTime createdAt;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.categoryId,
    this.dueDate,
    this.isCompleted = false,
    required this.createdAt,
  });

  // Add toMap, fromMap, copyWith methods
}

// models/category.dart
class Category {
  final String id;
  final String name;
  final Color color;
  final IconData icon;

  Category({
    required this.id,
    required this.name,
    required this.color,
    required this.icon,
  });
}
```

---

## Folder Structure

```
lib/
├── main.dart
├── app.dart
│
├── models/
│   ├── task.dart
│   └── category.dart
│
├── services/
│   └── database_service.dart
│
├── providers/
│   └── task_provider.dart
│
├── screens/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── widgets/
│   │       ├── task_list.dart
│   │       ├── category_tabs.dart
│   │       └── progress_bar.dart
│   ├── task/
│   │   ├── add_task_screen.dart
│   │   ├── edit_task_screen.dart
│   │   └── task_detail_screen.dart
│   └── splash_screen.dart
│
├── widgets/
│   ├── task_tile.dart
│   ├── category_chip.dart
│   └── empty_state.dart
│
└── config/
    ├── theme.dart
    └── routes.dart
```

---

## Implementation Steps

### Phase 1: Foundation

```
□ Create Flutter project
□ Set up folder structure
□ Add dependencies (sqflite, provider)
□ Create Task model with toMap/fromMap
□ Create Category model
□ Set up DatabaseService
□ Create tasks and categories tables
```

### Phase 2: Core Features

```
□ Create TaskProvider
□ Implement loadTasks()
□ Build HomeScreen with task list
□ Create TaskTile widget
□ Implement addTask()
□ Build AddTaskScreen
□ Implement toggleComplete()
□ Implement deleteTask()
```

### Phase 3: Categories

```
□ Add default categories
□ Create CategoryChip widget
□ Add category filter to HomeScreen
□ Allow category selection in AddTask
□ Filter tasks by category
```

### Phase 4: Polish

```
□ Add loading states
□ Add empty state for no tasks
□ Add error handling
□ Implement pull-to-refresh
□ Add delete confirmation
□ Add success/error snackbars
□ Create splash screen
□ Test all features
```

---

## Bonus Features (Optional)

```
NICE TO HAVE:
□ Due date with date picker
□ Priority levels (High, Medium, Low)
□ Search tasks
□ Sort tasks (by date, priority, name)
□ Task statistics screen
□ Dark mode toggle
□ Task reminders (local notifications)
□ Swipe to complete/delete
□ Animated task completion
□ Weekly/monthly view
```

---

## Packages to Use

```yaml
dependencies:
  flutter:
    sdk: flutter
  provider: ^6.1.1
  sqflite: ^2.3.0
  path: ^1.8.3
  intl: ^0.18.1  # For date formatting
  uuid: ^4.2.1   # For generating IDs

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^3.0.1
```

---

## Grading Criteria

```
BASIC (Pass) - 60%
□ Can add tasks
□ Can view tasks
□ Can mark complete
□ Can delete tasks
□ Data persists

GOOD (B Grade) - 75%
□ All basic features
□ Categories work
□ UI looks clean
□ Loading states
□ Empty states

EXCELLENT (A Grade) - 90%
□ All good features
□ Due dates work
□ Error handling
□ Smooth animations
□ Pull to refresh
□ Well organized code

OUTSTANDING (A+ Grade) - 100%
□ All excellent features
□ Bonus features
□ Unit tests
□ Widget tests
□ Exceptional polish
```

---

## Tips for Success

```
1. START SMALL
   Build the simplest version first.
   Add features one at a time.

2. TEST OFTEN
   After each feature, test it thoroughly.
   Don't wait until the end.

3. COMMIT REGULARLY
   Use git to save your progress.
   Commit after each feature works.

4. ASK FOR HELP
   If you're stuck for more than 30 minutes,
   ask a classmate or instructor.

5. HAVE FUN!
   This is YOUR app. Make it something
   you'd actually want to use!
```

---

Good luck! 🎯
