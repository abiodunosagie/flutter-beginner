# JSON Serialization In Depth

## The Big Idea In One Sentence

> `@JsonSerializable()` writes `fromJson` and `toJson` for you, and the handful of options on it (`fieldRename`, `explicitToJson`, `checked`, converters) are what separate a toy model from a production one.

---

## The Basic Model

```dart
// lib/models/user.dart
import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  const User({required this.id, required this.name, required this.email});

  final int id;
  final String name;
  final String email;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
```

```bash
dart run build_runner build
```

That is the whole loop: annotate, add the `part` line, add the two one-line members, generate.

---

## Renaming Fields

APIs rarely use Dart naming. Three levels of control:

```dart
// One field
@JsonKey(name: 'email_address')
final String email;

// The whole class
@JsonSerializable(fieldRename: FieldRename.snake)
class Account {
  final String firstName;    // reads and writes "first_name"
  final DateTime createdAt;  // reads and writes "created_at"
}

// The whole project, in build.yaml
targets:
  $default:
    builders:
      json_serializable:
        options:
          field_rename: snake
```

`FieldRename` also offers `kebab`, `pascal`, and `screamingSnake`.

---

## The Nested Object Trap (`explicitToJson`)

This is the most common production bug in json_serializable, and it is worth knowing exactly.

```dart
@JsonSerializable()          // explicitToJson defaults to FALSE
class Company {
  final String name;
  final Address address;     // another @JsonSerializable class
}
```

Generated:

```dart
Map<String, dynamic> _$CompanyToJson(Company instance) => <String, dynamic>{
  'name': instance.name,
  'address': instance.address,     // <- the Address OBJECT, not a Map
};
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   company.toJson()['address']  is an Address object  │
│   NOT a Map<String, dynamic>.                        │
│                                                      │
│   jsonEncode(company.toJson()) still works, because  │
│   dart:convert calls toJson() on unknown objects.    │
│                                                      │
│   But it BREAKS when something inspects the map:     │
│   • writing to Firestore or a NoSQL SDK              │
│   • comparing maps in a test                         │
│   • any code that does map['address']['city']        │
│                                                      │
│   FIX: @JsonSerializable(explicitToJson: true)       │
│   -> 'address': instance.address.toJson()            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Set `explicit_to_json: true` in `build.yaml` once and never think about it again.

---

## Nullable, Defaults, And Skipping

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class Account {
  const Account({
    required this.id,
    required this.firstName,
    this.nickname,
    this.tags = const [],
    this.secret = '',
  });

  final int id;
  final String firstName;

  // Key is "nick" in JSON, and omitted entirely when null
  @JsonKey(name: 'nick', includeIfNull: false)
  final String? nickname;

  // Missing in JSON -> uses the constructor default
  final List<String> tags;

  // Never read from JSON, never written to JSON
  @JsonKey(includeFromJson: false, includeToJson: false)
  final String secret;
}
```

- `includeIfNull: false` keeps nulls out of the payload, which many APIs require.
- A constructor default is used when the key is missing. `@JsonKey(defaultValue: ...)` also works, but the constructor default is cleaner.
- `includeFromJson: false, includeToJson: false` is the modern replacement for the old `ignore: true`.

---

## Enums

```dart
enum Role {
  @JsonValue('admin') admin,
  @JsonValue('member') member,
  @JsonValue('guest') guest,
}

class Account {
  // If the API sends a role you have never heard of, do not crash
  @JsonKey(unknownEnumValue: Role.guest)
  final Role role;
}
```

Without `unknownEnumValue`, a new value added by the backend crashes every client that has not been updated. With it, old clients degrade gracefully. Mentioning this in an interview signals that you have maintained an app in the field.

---

## Custom Converters

When a type does not map cleanly, write a converter once and reuse it everywhere.

```dart
class DateTimeEpochConverter implements JsonConverter<DateTime, int> {
  const DateTimeEpochConverter();

  @override
  DateTime fromJson(int json) => DateTime.fromMillisecondsSinceEpoch(json);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch;
}

class Account {
  @DateTimeEpochConverter()
  final DateTime createdAt;
}
```

Handy converters to have in a project:

```dart
// API sends "12.50" as a string but you want a double
class StringToDoubleConverter implements JsonConverter<double, String> {
  const StringToDoubleConverter();

  @override
  double fromJson(String json) => double.tryParse(json) ?? 0;

  @override
  String toJson(double object) => object.toString();
}

// API sends 1 / 0 instead of true / false
class IntToBoolConverter implements JsonConverter<bool, int> {
  const IntToBoolConverter();

  @override
  bool fromJson(int json) => json == 1;

  @override
  int toJson(bool object) => object ? 1 : 0;
}
```

Apply a converter to every model in the project by listing it in `@JsonSerializable(converters: [...])` or in `build.yaml`.

---

## Generic Wrappers

Most APIs wrap everything in an envelope:

```json
{ "data": { "id": 1, "name": "Ada" }, "message": "ok" }
```

```dart
@JsonSerializable(genericArgumentFactories: true)
class ApiResponse<T> {
  const ApiResponse({required this.data, required this.message});

  final T data;
  final String message;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);

  Map<String, dynamic> toJson(Object? Function(T value) toJsonT) =>
      _$ApiResponseToJson(this, toJsonT);
}

// Usage: you hand it the function that decodes T
final response = ApiResponse<User>.fromJson(
  json,
  (data) => User.fromJson(data as Map<String, dynamic>),
);

final list = ApiResponse<List<User>>.fromJson(
  json,
  (data) => (data as List)
      .map((e) => User.fromJson(e as Map<String, dynamic>))
      .toList(),
);
```

`genericArgumentFactories: true` is the flag that makes this possible. Without it the generator cannot know how to decode `T`.

---

## Better Errors With `checked: true`

```dart
@JsonSerializable(checked: true)
class Account { ... }
```

Without it, a wrong type produces a bare cast error somewhere deep in the generated file. With it, you get a `CheckedFromJsonException` naming the class and the key, for example "Account: key 'created_at' expected int". When an API changes shape at 2am, that message saves an hour.

---

## Decoding Lists

`json_serializable` generates code for one object. Lists are your job, and it is one line:

```dart
final users = (jsonDecode(body) as List)
    .map((e) => User.fromJson(e as Map<String, dynamic>))
    .toList();
```

If a response is large, decode off the UI thread:

```dart
final users = await compute(_parseUsers, body);

List<User> _parseUsers(String body) => (jsonDecode(body) as List)
    .map((e) => User.fromJson(e as Map<String, dynamic>))
    .toList();
```

`compute` runs the function in another isolate, so a 2 MB response does not drop frames. The function must be a top level or static function.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • fieldRename: snake kills most @JsonKey lines     │
│   • explicitToJson: true or nested objects stay      │
│     objects inside the map                           │
│   • includeIfNull: false to omit nulls               │
│   • @JsonValue for enum wire values,                 │
│     unknownEnumValue so new values do not crash      │
│   • JsonConverter for dates, money, 1/0 booleans     │
│   • genericArgumentFactories for {data, message}     │
│   • checked: true for readable parse errors          │
│   • compute() for big payloads                       │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What exactly goes wrong without `explicitToJson: true`?

<details>
<summary>Answer</summary>
Nested model fields are placed in the map as objects rather than maps. `jsonEncode` still works because dart:convert calls `toJson()` dynamically, but anything that reads the map directly (a NoSQL SDK, a test comparison, `map['a']['b']`) breaks.
</details>

**Q2.** The backend adds a new user role next week. How do you stop old app versions from crashing?

<details>
<summary>Answer</summary>
`@JsonKey(unknownEnumValue: Role.guest)` on the enum field, so unrecognised values fall back instead of throwing.
</details>

**Q3.** What does `genericArgumentFactories: true` solve?

<details>
<summary>Answer</summary>
It lets a generic class like `ApiResponse<T>` be generated, by requiring the caller to pass a function that decodes `T`. Without it the generator has no way to build a `T` from JSON.
</details>

---

## Assignment

### Problem 1: Annotate it

The API returns `{"user_id": 7, "full_name": "Ada", "is_active": 1, "joined": 1712345678}`. Write the model, using a converter for `is_active` and one for `joined`.

### Problem 2: Fix the payload

Your `toJson()` sends `"address": Instance of 'Address'` to a NoSQL database. What is the fix?

### Problem 3: Generic envelope

Write the `fromJson` call that decodes `{"data": [ ... products ... ], "message": "ok"}` into `ApiResponse<List<Product>>`.

### Problem 4: Big payload

A search returns 5 MB of JSON and the UI freezes for a second while parsing. What do you change?

---

## Assignment Answers

### Problem 1: Annotate it

```dart
@JsonSerializable(fieldRename: FieldRename.snake)
class Member {
  const Member({
    required this.userId,
    required this.fullName,
    required this.isActive,
    required this.joined,
  });

  final int userId;
  final String fullName;

  @IntToBoolConverter()
  final bool isActive;

  @JsonKey(name: 'joined')
  @DateTimeEpochConverter()
  final DateTime joined;

  factory Member.fromJson(Map<String, dynamic> json) => _$MemberFromJson(json);
  Map<String, dynamic> toJson() => _$MemberToJson(this);
}
```

### Problem 2: Fix the payload

Add `explicitToJson: true` to `@JsonSerializable()` on the parent class (or set `explicit_to_json: true` project wide in `build.yaml`) and regenerate, so the nested value becomes `instance.address.toJson()`.

### Problem 3: Generic envelope

```dart
final response = ApiResponse<List<Product>>.fromJson(
  json,
  (data) => (data as List)
      .map((e) => Product.fromJson(e as Map<String, dynamic>))
      .toList(),
);
```

### Problem 4: Big payload

Parse in another isolate with `compute(_parseResults, body)`, where `_parseResults` is a top level function that does the `jsonDecode` and mapping. The UI thread stays free and frames keep rendering.

---

## Navigation

⬅️ **Previous:** [The Code Generation Workflow](05a-CodeGenerationWorkflow.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Freezed Deep Dive](05c-FreezedDeepDive.md)
