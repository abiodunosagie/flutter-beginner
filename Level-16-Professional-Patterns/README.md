# Level 16: Professional Patterns

## What You'll Learn

Writing code that scales! This is like learning to build a house that can easily add more rooms later without the whole thing falling down.

```
BEGINNER CODE vs PROFESSIONAL CODE:

BEGINNER:
┌─────────────────────────────────────┐
│  Everything in one big file         │
│  Hard to find things                │
│  Scary to change                    │
│  "It works, don't touch it!"        │
└─────────────────────────────────────┘

PROFESSIONAL:
┌─────────────────────────────────────┐
│  Organized in clear folders         │
│  Easy to find and understand        │
│  Safe to modify                     │
│  "I can add features easily!"       │
└─────────────────────────────────────┘
```

---

## Why Professional Patterns Matter

```
┌─────────────────────────────────────────────────────────────┐
│           THE BENEFITS OF GOOD ARCHITECTURE                  │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  MAINTAINABILITY                                             │
│  └── 6 months later, you can still understand your code    │
│                                                              │
│  TESTABILITY                                                 │
│  └── Easy to write tests for each piece                     │
│                                                              │
│  SCALABILITY                                                 │
│  └── Add new features without breaking old ones             │
│                                                              │
│  TEAMWORK                                                    │
│  └── Other developers can understand and contribute         │
│                                                              │
│  DEBUGGING                                                   │
│  └── When something breaks, you know where to look          │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Core Concepts in This Level

```
WHAT WE'LL COVER:

1. CLEAN ARCHITECTURE
   └── Separating concerns into layers

2. STATE MANAGEMENT PATTERNS
   └── Managing app data professionally

3. DEPENDENCY INJECTION
   └── Making code modular and testable

4. REPOSITORY PATTERN
   └── Abstracting data sources

5. ERROR HANDLING
   └── Graceful failure strategies

6. CODE ORGANIZATION
   └── Project structure best practices
```

---

## The Building Blocks

```
PROFESSIONAL APP STRUCTURE:

┌─────────────────────────────────────────────────────────────┐
│                                                              │
│                      PRESENTATION                            │
│    ┌────────────────────────────────────────────────────┐   │
│    │  Widgets, Screens, Controllers                     │   │
│    │  What users see and interact with                  │   │
│    └────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│                       DOMAIN                                 │
│    ┌────────────────────────────────────────────────────┐   │
│    │  Business Logic, Use Cases, Entities              │   │
│    │  The rules of your app                             │   │
│    └────────────────────────────────────────────────────┘   │
│                          │                                   │
│                          ▼                                   │
│                        DATA                                  │
│    ┌────────────────────────────────────────────────────┐   │
│    │  Repositories, APIs, Database                      │   │
│    │  Where data comes from                             │   │
│    └────────────────────────────────────────────────────┘   │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

---

## Topics in This Level

### Theory
1. **Clean Architecture** - Layered app structure
2. **State Management Deep Dive** - Provider, Riverpod, BLoC
3. **Dependency Injection** - GetIt and injectable
4. **Repository Pattern** - Abstracting data access
5. **Error Handling Strategies** - Result types and failures

### Examples
1. **Clean Architecture Project** - Full implementation
2. **Repository Pattern** - Data layer abstraction
3. **Dependency Injection Setup** - GetIt configuration

### Exercises
- Build a professionally structured app

---

## Pattern Overview

```
COMMON PATTERNS YOU'LL LEARN:

SINGLETON
└── One instance shared everywhere
    Example: Logger, Analytics

FACTORY
└── Creating objects based on conditions
    Example: Different API clients

REPOSITORY
└── Abstract interface to data
    Example: UserRepository (API or cache)

OBSERVER (BLoC/Provider)
└── React to state changes
    Example: Update UI when data changes

DEPENDENCY INJECTION
└── Pass dependencies instead of creating them
    Example: Pass repository to view model
```

---

## Before and After

```
BEFORE (Beginner):
──────────────────────────────────────
class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  User? user;

  @override
  void initState() {
    super.initState();
    // Directly calling API in widget 😱
    fetchUser();
  }

  Future<void> fetchUser() async {
    final response = await http.get(Uri.parse('api/user'));
    final data = jsonDecode(response.body);
    setState(() {
      user = User.fromJson(data);
    });
  }
  // ...
}

Problems:
❌ Business logic in UI
❌ Hard to test
❌ API details exposed
❌ Can't easily switch data source
──────────────────────────────────────

AFTER (Professional):
──────────────────────────────────────
// Presentation Layer
class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<UserController>(
      builder: (context, controller, child) {
        return controller.when(
          loading: () => LoadingWidget(),
          error: (e) => ErrorWidget(e),
          data: (user) => ProfileView(user: user),
        );
      },
    );
  }
}

// Domain Layer
class GetUserUseCase {
  final UserRepository repository;

  GetUserUseCase(this.repository);

  Future<User> execute() => repository.getCurrentUser();
}

// Data Layer
class UserRepositoryImpl implements UserRepository {
  final ApiClient api;
  final LocalCache cache;

  Future<User> getCurrentUser() async {
    try {
      return await api.getUser();
    } catch (e) {
      return await cache.getUser();
    }
  }
}

Benefits:
✅ Separation of concerns
✅ Easy to test each layer
✅ Can swap implementations
✅ Clear responsibilities
──────────────────────────────────────
```

---

## When to Use These Patterns

```
┌─────────────────────────────────────────────────────────────┐
│              WHEN TO USE PROFESSIONAL PATTERNS               │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│  SIMPLE APP (1-3 screens):                                   │
│  └── Keep it simple! Basic state management is fine.        │
│                                                              │
│  MEDIUM APP (4-10 screens):                                  │
│  └── Start organizing into folders                          │
│  └── Use Provider or Riverpod                               │
│  └── Consider repository pattern                            │
│                                                              │
│  LARGE APP (10+ screens):                                    │
│  └── Full clean architecture                                │
│  └── Dependency injection                                   │
│  └── Comprehensive testing                                  │
│                                                              │
│  TEAM PROJECT:                                               │
│  └── Always use patterns!                                   │
│  └── Documentation essential                                │
│  └── Code review standards                                  │
│                                                              │
└─────────────────────────────────────────────────────────────┘

RULE OF THUMB:
"Will this app be maintained for more than 6 months?"
If yes → Use professional patterns
```

---

## Quick Reference

```
PROJECT STRUCTURE:

lib/
├── core/                    # Shared utilities
│   ├── constants/
│   ├── errors/
│   ├── network/
│   └── utils/
│
├── features/                # Feature-based organization
│   ├── auth/
│   │   ├── data/           # Data layer
│   │   │   ├── models/
│   │   │   ├── repositories/
│   │   │   └── sources/
│   │   ├── domain/         # Domain layer
│   │   │   ├── entities/
│   │   │   ├── repositories/
│   │   │   └── usecases/
│   │   └── presentation/   # Presentation layer
│   │       ├── controllers/
│   │       ├── screens/
│   │       └── widgets/
│   │
│   └── home/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── injection_container.dart # Dependency injection setup
└── main.dart
```

---

## Level Prerequisites

```
BEFORE STARTING THIS LEVEL:

□ Comfortable with Dart and Flutter basics
□ Understand StatefulWidget and StatelessWidget
□ Have built at least one complete app
□ Familiar with async/await and Futures
□ Basic understanding of Provider or similar

IF NOT READY:
Review Levels 1-10 first!
```

---

**Let's build apps like a professional!**
