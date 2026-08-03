# The Code Generation Workflow: build_runner Without Fear

## The Big Idea In One Sentence

> You write a small file with annotations, `build_runner` writes the boring code next to it in a `.g.dart` or `.freezed.dart` **part file**, and you never edit the generated file.

---

## Why Generate Code At All

Here is a model written by hand:

```dart
class User {
  final int id;
  final String name;
  final String email;
  final DateTime createdAt;

  User({required this.id, required this.name, required this.email, required this.createdAt});

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json['id'] as int,
        name: json['name'] as String,
        email: json['email_address'] as String,
        createdAt: DateTime.parse(json['created_at'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email_address': email,
        'created_at': createdAt.toIso8601String(),
      };

  User copyWith({int? id, String? name, String? email, DateTime? createdAt}) => User(
        id: id ?? this.id,
        name: name ?? this.name,
        email: email ?? this.email,
        createdAt: createdAt ?? this.createdAt,
      );

  @override
  bool operator ==(Object other) =>
      other is User &&
      other.id == id &&
      other.name == name &&
      other.email == email &&
      other.createdAt == createdAt;

  @override
  int get hashCode => Object.hash(id, name, email, createdAt);

  @override
  String toString() => 'User(id: $id, name: $name, email: $email, createdAt: $createdAt)';
}
```

Sixty lines for four fields. Add a fifth field and you must remember six places. Miss one and you get a silent bug: a `copyWith` that drops a value, or an `==` that says two different users are the same.

Generated, the same class is fifteen lines and cannot fall out of sync.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   WHAT YOU WRITE            WHAT IS GENERATED        │
│   ──────────────            ─────────────────        │
│   fields + annotations      fromJson, toJson         │
│                             copyWith                 │
│                             ==, hashCode             │
│                             toString                 │
│                             API client methods       │
│                             typed route classes      │
│                             mock classes             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## The Tools And Their Jobs

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   build_runner        the engine that runs           │
│                       generators (dev only)          │
│                                                      │
│   json_serializable   fromJson / toJson              │
│   freezed             immutable classes, copyWith,   │
│                       equality, unions               │
│   retrofit_generator  a typed HTTP client from an    │
│                       abstract class                 │
│   go_router_builder   typed route classes            │
│   mockito             mock classes for tests         │
│   pigeon              native bridge code (this one   │
│                       does NOT use build_runner)     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Every generator has two packages: the **annotation** package (a normal dependency, tiny, ships with your app) and the **generator** package (a dev dependency, never shipped).

```yaml
dependencies:
  json_annotation: ^4.9.0        # annotations, shipped
  freezed_annotation: ^3.1.0
  retrofit: ^4.9.2
  dio: ^5.11.0

dev_dependencies:
  build_runner: ^2.15.1          # engine, not shipped
  json_serializable: ^6.11.2
  freezed: ^3.2.3
  retrofit_generator: ^10.2.8
```

Putting a generator in `dependencies` bloats your app and is a common review comment. Putting an annotation package in `dev_dependencies` breaks the build.

---

## Part Files: The Bit That Confuses Everyone

```dart
// lib/models/user.dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';        // <- this line is mandatory

@JsonSerializable()
class User {
  // ...
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   part 'user.g.dart';                                │
│        └── file name must match EXACTLY              │
│            user.dart  ->  user.g.dart                │
│                                                      │
│   The generated file starts with:                    │
│      part of 'user.dart';                            │
│                                                      │
│   That makes the two files ONE library, which is     │
│   why generated code can use your private fields     │
│   and why the names start with _$ .                  │
│                                                      │
│   BEFORE you run build_runner, your editor shows     │
│   errors: "_$UserFromJson isn't defined" and         │
│   "Target of URI hasn't been generated".             │
│   That is EXPECTED. Run the generator.               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Which part file do you need?

| Annotation | part line |
|---|---|
| `@JsonSerializable()` | `part 'x.g.dart';` |
| `@freezed` without JSON | `part 'x.freezed.dart';` |
| `@freezed` with JSON | both `part 'x.freezed.dart';` and `part 'x.g.dart';` |
| `@RestApi()` | `part 'x.g.dart';` |
| `@TypedGoRoute` | `part 'x.g.dart';` |

---

## The Commands

```bash
# Generate once
dart run build_runner build

# Regenerate automatically while you work (best during development)
dart run build_runner watch

# Wipe generated outputs
dart run build_runner clean
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   VERIFIED ON build_runner 2.15                      │
│                                                      │
│   --delete-conflicting-outputs HAS BEEN REMOVED.     │
│   Passing it prints:                                 │
│     "These options have been removed and were        │
│      ignored: --delete-conflicting-outputs"          │
│                                                      │
│   Most tutorials and Stack Overflow answers still    │
│   tell you to use it. On current build_runner you    │
│   just run `dart run build_runner build`, and use    │
│   `clean` if outputs get into a bad state.           │
│                                                      │
│   Check what YOUR version supports:                  │
│     dart run build_runner build --help               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Use `watch` while developing so every save regenerates in under a second. Use `build` in CI.

---

## Should Generated Files Be Committed?

Both choices are defensible, and an interviewer may ask:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   COMMIT THEM                                        │
│   + a fresh clone builds with no extra step          │
│   + CI is faster                                     │
│   + code review shows what changed                   │
│   - noisy diffs, and merge conflicts in .g.dart      │
│                                                      │
│   GITIGNORE THEM                                     │
│   + clean diffs, no conflicts                        │
│   - every clone and every CI run must generate       │
│   - a stale generator version breaks the build       │
│                                                      │
│   Common practice: gitignore for apps (CI            │
│   generates), commit for published packages          │
│   (so users need no build step).                     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

```gitignore
# If you choose to ignore them
*.g.dart
*.freezed.dart
*.mocks.dart
```

---

## Troubleshooting, In Order

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   1. "Target of URI hasn't been generated"           │
│      -> you have not run build_runner yet            │
│                                                      │
│   2. "_$XFromJson isn't defined"                     │
│      -> same cause, or the part filename is wrong    │
│                                                      │
│   3. Nothing is generated for my class               │
│      -> the annotation is missing, the file is       │
│         outside lib/, or the part line is absent     │
│                                                      │
│   4. "Conflicting outputs"                           │
│      -> dart run build_runner clean, then build      │
│                                                      │
│   5. "Failed to compile build script"                │
│      -> a dependency is incompatible with your       │
│         build_runner/analyzer version. Check         │
│         `flutter pub outdated`, and try removing     │
│         the package you added last                   │
│                                                      │
│   6. Generation is very slow                         │
│      -> use `watch`, and keep generated code in      │
│         lib/ only; build_runner scans everything     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## build.yaml: Configuring Generators

Optional, but useful when a setting should apply to every file instead of every annotation.

```yaml
# build.yaml at the project root
targets:
  $default:
    builders:
      json_serializable:
        options:
          # Every model uses snake_case JSON keys, so stop writing @JsonKey
          field_rename: snake
          # Fail loudly instead of silently producing nulls
          checked: true
          create_to_json: true
          include_if_null: false
```

`field_rename: snake` alone removes most `@JsonKey(name: ...)` annotations from a codebase whose API uses `snake_case`.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Annotations in dependencies, generators in dev   │
│   • part 'x.g.dart'; must match the file name        │
│   • Errors BEFORE generating are expected            │
│   • dart run build_runner build / watch / clean      │
│   • --delete-conflicting-outputs is removed in 2.15  │
│   • Commit generated files for packages, ignore      │
│     them for apps (either is defensible)             │
│   • build.yaml sets project wide options like        │
│     field_rename: snake                              │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why does `user.dart` show red errors before you run the generator?

<details>
<summary>Answer</summary>
It references `user.g.dart` and functions like `_$UserFromJson` that do not exist yet. Running `dart run build_runner build` creates them, and the errors disappear.
</details>

**Q2.** Which packages go in `dependencies` and which in `dev_dependencies`?

<details>
<summary>Answer</summary>
Annotation packages (`json_annotation`, `freezed_annotation`, `retrofit`) are real dependencies because your shipped code refers to them. Generators (`build_runner`, `json_serializable`, `freezed`, `retrofit_generator`) are dev dependencies because they only run at build time.
</details>

**Q3.** What is the current way to fix conflicting outputs?

<details>
<summary>Answer</summary>
`dart run build_runner clean` and then build again. The old `--delete-conflicting-outputs` flag was removed in build_runner 2.15 and is now ignored with a warning.
</details>

---

## Assignment

### Problem 1: Fix the pubspec

```yaml
dependencies:
  freezed: ^3.2.3
  build_runner: ^2.15.1
dev_dependencies:
  freezed_annotation: ^3.1.0
```

What is wrong?

### Problem 2: Write the part lines

You have `lib/models/order.dart` with a `@freezed` class that also needs JSON. Write the exact `part` lines.

### Problem 3: Diagnose

A teammate says "I added `@JsonSerializable()` but nothing generated". List three things to check.

### Problem 4: Configure

Your API returns `created_at`, `updated_at`, `first_name`. How do you avoid writing `@JsonKey` on every field?

---

## Assignment Answers

### Problem 1: Fix the pubspec

They are swapped. `freezed` and `build_runner` are generators and belong in `dev_dependencies`; `freezed_annotation` is used by shipped code and belongs in `dependencies`.

### Problem 2: Write the part lines

```dart
part 'order.freezed.dart';
part 'order.g.dart';
```

Freezed generates the class machinery, and json_serializable generates the JSON functions that Freezed's `fromJson` factory calls.

### Problem 3: Diagnose

1. Is there a `part 'x.g.dart';` line with the exact matching file name?
2. Is the file inside `lib/`? build_runner does not generate for files outside the package's source directories.
3. Did they actually run `dart run build_runner build` (or is `watch` running), and did the run report an error?

### Problem 4: Configure

Add a `build.yaml` with `field_rename: snake` under `json_serializable` options, so every Dart field name is converted to snake_case automatically.

---

## Navigation

⬅️ **Previous:** [Flutter On The Web](04d-FlutterOnWeb.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [JSON Serialization In Depth](05b-JsonSerializable.md)
