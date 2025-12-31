# Code Generation

Learn how to use code generation tools to automatically create model classes!

---

## Why Code Generation?

### The Manual Problem

```
┌─────────────────────────────────────────────────────────────┐
│              WHY USE CODE GENERATION?                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  MANUAL APPROACH:                                           │
│  ✗ Write fromJson by hand (tedious)                         │
│  ✗ Write toJson by hand (error-prone)                       │
│  ✗ Write copyWith by hand (repetitive)                      │
│  ✗ Write == and hashCode by hand (forgettable)              │
│  ✗ Update everything when adding fields (painful)           │
│                                                             │
│  For a model with 10 fields:                                │
│  • ~100 lines of boilerplate code                           │
│  • High chance of typos                                     │
│  • Hard to maintain                                         │
│                                                             │
│  CODE GENERATION APPROACH:                                  │
│  ✓ Write minimal annotations                                │
│  ✓ Run build command                                        │
│  ✓ Code generated automatically                             │
│  ✓ Type-safe and tested                                     │
│  ✓ Easy to maintain                                         │
│                                                             │
│  For the same 10-field model:                               │
│  • ~10 lines you write                                      │
│  • ~100 lines generated for you                             │
│  • Zero typos                                               │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## json_serializable Package

### Setup

Add to `pubspec.yaml`:

```yaml
dependencies:
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
```

Then run:
```bash
flutter pub get
```

### Basic Usage

```dart
import 'package:json_annotation/json_annotation.dart';

// This is required for code generation
part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Generated code will provide these
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

### Generate Code

Run this command:
```bash
flutter pub run build_runner build
```

Or for continuous generation:
```bash
flutter pub run build_runner watch
```

This creates `user.g.dart` with:
```dart
// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

User _$UserFromJson(Map<String, dynamic> json) => User(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
    );

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
    };
```

---

## Handling Different JSON Keys

### Field Renaming

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;

  // JSON has "user_name" but we want "userName"
  @JsonKey(name: 'user_name')
  final String userName;

  // JSON has "email_address" but we want "email"
  @JsonKey(name: 'email_address')
  final String email;

  User({
    required this.id,
    required this.userName,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

// JSON input:
// {
//   "id": 1,
//   "user_name": "john_doe",
//   "email_address": "john@example.com"
// }
//
// Dart object:
// User(id: 1, userName: 'john_doe', email: 'john@example.com')
```

---

## Handling Nullable and Default Values

### Nullable Fields

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;

  // Nullable fields
  final String? phone;
  final String? website;

  // Default value
  @JsonKey(defaultValue: false)
  final bool isActive;

  // Default value for lists
  @JsonKey(defaultValue: [])
  final List<String> tags;

  User({
    required this.id,
    required this.name,
    this.phone,
    this.website,
    required this.isActive,
    required this.tags,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

---

## Ignoring Fields

### Skip Serialization

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;
  final String email;

  // Don't include in JSON (neither fromJson nor toJson)
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String? password;

  // Computed property - only skip in fromJson
  @JsonKey(includeFromJson: false)
  String get displayName => '$name ($email)';

  User({
    required this.id,
    required this.name,
    required this.email,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

---

## Nested Objects

### With json_serializable

```dart
import 'package:json_annotation/json_annotation.dart';

part 'models.g.dart';

@JsonSerializable()
class Address {
  final String street;
  final String city;
  final String zipcode;

  Address({
    required this.street,
    required this.city,
    required this.zipcode,
  });

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
  Map<String, dynamic> toJson() => _$AddressToJson(this);
}

@JsonSerializable()
class User {
  final int id;
  final String name;

  // Nested object - automatically handled!
  final Address address;

  // Nullable nested object
  final Address? secondaryAddress;

  User({
    required this.id,
    required this.name,
    required this.address,
    this.secondaryAddress,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

---

## Custom Converters

### DateTime Converter

```dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  final int id;
  final String name;

  // Automatically converts ISO string to DateTime
  final DateTime createdAt;

  // Custom date format
  @JsonKey(
    fromJson: _dateFromTimestamp,
    toJson: _dateToTimestamp,
  )
  final DateTime? lastLogin;

  User({
    required this.id,
    required this.name,
    required this.createdAt,
    this.lastLogin,
  });

  // Custom converter functions
  static DateTime? _dateFromTimestamp(int? timestamp) {
    if (timestamp == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  }

  static int? _dateToTimestamp(DateTime? date) {
    return date?.millisecondsSinceEpoch ~/ 1000;
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

---

## API Response Wrapper

### Generic Response Model

```dart
import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final String? error;

  ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.error,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) =>
      _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

// Usage:
Future<List<User>> fetchUsers() async {
  final response = await http.get(Uri.parse('$baseUrl/users'));

  if (response.statusCode == 200) {
    final apiResponse = ApiResponse<List<User>>.fromJson(
      json.decode(response.body),
      (json) => (json as List).map((e) => User.fromJson(e)).toList(),
    );

    if (apiResponse.success && apiResponse.data != null) {
      return apiResponse.data!;
    }
    throw Exception(apiResponse.error);
  }
  throw Exception('Failed to load users');
}
```

---

## freezed Package (Advanced)

### What is freezed?

```
┌─────────────────────────────────────────────────────────────┐
│                   FREEZED PACKAGE                            │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  freezed generates:                                         │
│  ✓ fromJson / toJson (via json_serializable)                │
│  ✓ copyWith method                                          │
│  ✓ == and hashCode                                          │
│  ✓ toString                                                 │
│  ✓ Immutable classes                                        │
│  ✓ Union types (sealed classes)                             │
│                                                             │
│  Perfect for state management and complex models!           │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

### Setup freezed

Add to `pubspec.yaml`:

```yaml
dependencies:
  freezed_annotation: ^2.4.0
  json_annotation: ^4.8.0

dev_dependencies:
  build_runner: ^2.4.0
  freezed: ^2.4.0
  json_serializable: ^6.7.0
```

### Basic freezed Model

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    String? phone,
    @Default([]) List<String> tags,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

Generate code:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `user.freezed.dart` - copyWith, ==, hashCode, toString
- `user.g.dart` - fromJson, toJson

### Using freezed Models

```dart
void main() {
  final user = User(
    id: 1,
    name: 'John',
    email: 'john@example.com',
  );

  // copyWith (generated automatically!)
  final updatedUser = user.copyWith(name: 'Jane');

  // Equality (generated automatically!)
  print(user == updatedUser);  // false

  // toString (generated automatically!)
  print(user);  // User(id: 1, name: John, email: john@example.com...)

  // JSON serialization (generated automatically!)
  final json = user.toJson();
  final userFromJson = User.fromJson(json);
}
```

---

## freezed with Nested Objects

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
class Address with _$Address {
  const factory Address({
    required String street,
    required String city,
    required String zipcode,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

@freezed
class User with _$User {
  const factory User({
    required int id,
    required String name,
    required String email,
    Address? address,  // Nullable nested object
    @Default([]) List<String> tags,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
```

---

## Comparison: Manual vs json_serializable vs freezed

### Visual Comparison

```
┌─────────────────────────────────────────────────────────────┐
│           MANUAL vs GENERATORS COMPARISON                    │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  FEATURE          │ Manual │ json_ser │ freezed             │
│  ──────────────────────────────────────────────────────────│
│                                                             │
│  fromJson         │   ✓    │    ✓     │   ✓                 │
│  toJson           │   ✓    │    ✓     │   ✓                 │
│  copyWith         │ Manual │  Manual  │   ✓                 │
│  == / hashCode    │ Manual │  Manual  │   ✓                 │
│  toString         │ Manual │  Manual  │   ✓                 │
│  Immutability     │   ✓    │    ✓     │   ✓                 │
│  Union types      │   ✗    │    ✗     │   ✓                 │
│                                                             │
│  Code you write   │  100%  │   ~30%   │  ~10%               │
│  Boilerplate      │  High  │  Medium  │  Low                │
│  Type safety      │   ✓    │    ✓     │   ✓                 │
│  Null safety      │   ✓    │    ✓     │   ✓                 │
│                                                             │
│  WHEN TO USE:                                               │
│  • Manual: Simple models, learning                          │
│  • json_serializable: Standard models                       │
│  • freezed: Complex models, state management                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## Best Practices

### File Organization

```
lib/
├── models/
│   ├── user.dart
│   ├── user.g.dart          (generated)
│   ├── user.freezed.dart    (generated if using freezed)
│   ├── address.dart
│   ├── address.g.dart
│   └── models.dart          (barrel file)
├── services/
│   └── api_service.dart
└── main.dart
```

### Barrel File Pattern

```dart
// lib/models/models.dart
export 'user.dart';
export 'address.dart';
export 'post.dart';

// Now import all models with one line:
import 'package:myapp/models/models.dart';
```

### Build Commands Reference

```bash
# One-time build
flutter pub run build_runner build

# Delete conflicting outputs
flutter pub run build_runner build --delete-conflicting-outputs

# Watch for changes (continuous generation)
flutter pub run build_runner watch

# Clean generated files
flutter pub run build_runner clean
```

---

## Summary

```
┌─────────────────────────────────────────────────────────────┐
│            CODE GENERATION CHEAT SHEET                       │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  json_serializable SETUP:                                   │
│  ───────────────────────                                    │
│  dependencies:                                              │
│    json_annotation: ^4.8.0                                  │
│  dev_dependencies:                                          │
│    build_runner: ^2.4.0                                     │
│    json_serializable: ^6.7.0                                │
│                                                             │
│  BASIC USAGE:                                               │
│  ───────────                                                │
│  import 'package:json_annotation/json_annotation.dart';     │
│  part 'user.g.dart';                                        │
│                                                             │
│  @JsonSerializable()                                        │
│  class User {                                               │
│    final int id;                                            │
│    final String name;                                       │
│                                                             │
│    User({required this.id, required this.name});            │
│                                                             │
│    factory User.fromJson(Map<String, dynamic> json) =>      │
│        _$UserFromJson(json);                                │
│    Map<String, dynamic> toJson() => _$UserToJson(this);     │
│  }                                                          │
│                                                             │
│  GENERATE CODE:                                             │
│  flutter pub run build_runner build                         │
│                                                             │
│  freezed (ADVANCED):                                        │
│  ──────────────────                                         │
│  @freezed                                                   │
│  class User with _$User {                                   │
│    const factory User({                                     │
│      required int id,                                       │
│      required String name,                                  │
│    }) = _User;                                              │
│                                                             │
│    factory User.fromJson(Map<String, dynamic> json) =>      │
│        _$UserFromJson(json);                                │
│  }                                                          │
│                                                             │
│  BENEFITS:                                                  │
│  ✓ Less boilerplate                                         │
│  ✓ Fewer errors                                             │
│  ✓ Easier maintenance                                       │
│  ✓ Type-safe                                                │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

---

## Navigation

⬅️ **Previous:** [Serialization](08b-Serialization.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Repository Pattern](09a-RepositoryPattern.md)
