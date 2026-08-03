# Freezed Deep Dive: Immutable Data Without The Boilerplate

## The Big Idea In One Sentence

> `@freezed` turns a list of fields into a full immutable class with `copyWith`, `==`, `hashCode`, `toString`, and optional JSON, and it also gives you **unions**: one type with several named shapes.

---

## Setup

```yaml
dependencies:
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0        # only if you need JSON

dev_dependencies:
  build_runner: ^2.15.1
  freezed: ^3.2.3
  json_serializable: ^6.11.2     # only if you need JSON
```

One extra step almost every Freezed project needs, because `@JsonKey` and `@Default` sit on constructor parameters and the analyzer complains:

```yaml
# analysis_options.yaml
analyzer:
  errors:
    invalid_annotation_target: ignore
```

---

## A Freezed Data Class

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'person.freezed.dart';
part 'person.g.dart';

@freezed
abstract class Person with _$Person {
  const factory Person({
    required String firstName,
    required String lastName,
    required Address address,
    @Default(0) int age,
    @JsonKey(name: 'email_address') String? email,
  }) = _Person;

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);
}
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   FREEZED 3 SYNTAX (this is what changed)            │
│                                                      │
│   Data class:   abstract class X with _$X            │
│   Union:        sealed class X with _$X              │
│                                                      │
│   Freezed 2 tutorials show `class X with _$X`        │
│   with no `abstract`/`sealed`. On Freezed 3 that     │
│   fails to build. If you copy an old article and     │
│   get a mixin or constructor error, this is why.     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

You get, for free:

```dart
const person = Person(firstName: 'Ada', lastName: 'Lovelace', address: home);

person.copyWith(age: 36);              // a new object, everything else kept
person == otherPerson;                 // value equality, field by field
person.hashCode;                       // consistent with ==
person.toString();                     // Person(firstName: Ada, ...)
Person.fromJson(json);                 // if you added the factory
person.toJson();
```

Nested `copyWith` composes naturally:

```dart
final moved = person.copyWith(
  address: person.address.copyWith(city: 'Lagos'),
);
```

---

## Adding Your Own Methods And Getters

By default a Freezed class has no room for your code. Add a **private constructor** and it does:

```dart
@freezed
abstract class Person with _$Person {
  const Person._();          // <- this line unlocks custom members

  const factory Person({
    required String firstName,
    required String lastName,
    @Default(0) int age,
  }) = _Person;

  String get fullName => '$firstName $lastName';
  bool get isAdult => age >= 18;

  String greeting() => 'Hello, $firstName';
}
```

Forgetting `const Person._();` produces a confusing error about the getter not being defined. It is the single most common Freezed question online.

---

## Unions: One Type, Several Shapes

This is the feature that makes Freezed more than a code saver.

```dart
@freezed
sealed class AuthState with _$AuthState {
  const factory AuthState.unknown() = AuthUnknown;
  const factory AuthState.authenticated(Person user) = AuthAuthenticated;
  const factory AuthState.unauthenticated({String? reason}) = AuthUnauthenticated;
}
```

That is the entire definition of a state machine with three shapes, each carrying exactly the data it needs.

### Reading a union: Dart pattern matching (preferred)

```dart
String describe(AuthState state) => switch (state) {
      AuthUnknown() => 'checking...',
      AuthAuthenticated(:final user) => 'Hello ${user.firstName}',
      AuthUnauthenticated(:final reason) => reason ?? 'Signed out',
    };
```

Because the class is `sealed`, the compiler knows the complete list. Add a fourth case later and every `switch` that does not handle it fails to compile. That is the safety net.

### Reading a union: the generated callbacks

Freezed also generates `when`, `maybeWhen`, `map`, `maybeMap`, and their `OrNull` variants:

```dart
final label = state.when(
  unknown: () => 'checking...',
  authenticated: (user) => 'Hello ${user.firstName}',
  unauthenticated: (reason) => reason ?? 'Signed out',
);

final name = state.maybeWhen(
  authenticated: (user) => user.firstName,
  orElse: () => 'guest',
);
```

`when` gives you the **fields**; `map` gives you the **objects**. Both still work in Freezed 3, so older code keeps compiling. New code should prefer `switch`, because pattern matching is a language feature, reads better with guards, and does not depend on the generator.

---

## Unions With JSON

```dart
@freezed
sealed class ApiEvent with _$ApiEvent {
  const factory ApiEvent.started(String url) = ApiStarted;
  const factory ApiEvent.finished(String url, int status) = ApiFinished;

  factory ApiEvent.fromJson(Map<String, dynamic> json) => _$ApiEventFromJson(json);
}
```

The generated `fromJson` switches on a discriminator key:

```dart
switch (json['runtimeType']) {
  case 'started':  return ApiStarted.fromJson(json);
  case 'finished': return ApiFinished.fromJson(json);
  default: throw CheckedFromJsonException(...);
}
```

So the JSON must carry `"runtimeType": "started"`. If your API uses a different key or different values, say so:

```dart
@Freezed(unionKey: 'type', unionValueCase: FreezedUnionCase.snake)
sealed class ApiEvent with _$ApiEvent {
  const factory ApiEvent.started(String url) = ApiStarted;

  @FreezedUnionValue('done')
  const factory ApiEvent.finished(String url, int status) = ApiFinished;

  factory ApiEvent.fromJson(Map<String, dynamic> json) => _$ApiEventFromJson(json);
}
```

Now the wire format is `{"type": "started", ...}` and `{"type": "done", ...}`.

---

## Freezed For Bloc States

This is the combination the job description is really asking for:

```dart
@freezed
sealed class ProductsState with _$ProductsState {
  const factory ProductsState.initial() = ProductsInitial;
  const factory ProductsState.loading() = ProductsLoading;
  const factory ProductsState.loaded({
    required List<Product> products,
    @Default(false) bool isRefreshing,
  }) = ProductsLoaded;
  const factory ProductsState.failed(String message) = ProductsFailed;
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._repo) : super(const ProductsState.initial());

  final ProductRepository _repo;

  Future<void> load() async {
    emit(const ProductsState.loading());
    try {
      emit(ProductsState.loaded(products: await _repo.getProducts()));
    } on AppFailure catch (f) {
      emit(ProductsState.failed(f.userMessage));
    }
  }

  Future<void> refresh() async {
    final current = state;
    if (current is! ProductsLoaded) return load();

    emit(current.copyWith(isRefreshing: true));      // keep showing the list
    final fresh = await _repo.getProducts(forceRefresh: true);
    emit(ProductsState.loaded(products: fresh));
  }
}
```

You get value equality (so bloc skips duplicate emits correctly), `copyWith` for the refresh case, exhaustive switches in the UI, and no hand written boilerplate. Explaining this paragraph well is worth a lot in an interview.

---

## Things That Trip People Up

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   1. "The getter isn't defined"                      │
│      -> missing const X._(); private constructor     │
│                                                      │
│   2. invalid_annotation_target warnings              │
│      -> add the analyzer ignore to                   │
│         analysis_options.yaml                        │
│                                                      │
│   3. copyWith cannot set a field to null             │
│      -> same limitation as any copyWith. Model       │
│         "no value" as a union case, or add an        │
│         explicit clear method                        │
│                                                      │
│   4. Lists are not deeply immutable                  │
│      -> const factory gives you a final field, but   │
│         List itself is mutable. Never call .add on   │
│         it; build a new list                         │
│                                                      │
│   5. Old tutorial syntax fails                       │
│      -> Freezed 3 needs abstract (data) or           │
│         sealed (union)                               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Freezed or Equatable?

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   EQUATABLE                                          │
│   + no code generation, instant                      │
│   + tiny                                             │
│   - you write copyWith by hand                       │
│   - forgetting a field in props is a silent bug      │
│                                                      │
│   FREEZED                                            │
│   + copyWith, ==, toString, JSON, unions, all free   │
│   + nothing to forget                                │
│   - a build step, slower cold builds                 │
│   - generated files in the repo or in CI             │
│                                                      │
│   Rule of thumb: Equatable for a small app or a      │
│   couple of state classes; Freezed once you have     │
│   models with JSON, or unions, or a team.            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Freezed 3: abstract class for data,              │
│     sealed class for unions, both `with _$X`         │
│   • @Default for defaults, @JsonKey for wire names   │
│   • const X._(); to add getters and methods          │
│   • switch pattern matching is the modern way to     │
│     read a union; when/map still exist                │
│   • Union JSON uses a runtimeType discriminator,     │
│     configurable with @Freezed(unionKey: ...)        │
│   • Perfect fit for bloc states                      │
│   • Equatable for small, Freezed for real            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What is the difference between `abstract class X with _$X` and `sealed class X with _$X` in Freezed 3?

<details>
<summary>Answer</summary>
`abstract` is for a single shape data class. `sealed` is for a union with several named constructors, and being sealed is what makes `switch` exhaustive.
</details>

**Q2.** Your Freezed class will not compile because a getter "isn't defined". What is missing?

<details>
<summary>Answer</summary>
The private constructor `const X._();`. Without it, Freezed does not allow custom getters or methods on the class.
</details>

**Q3.** Why is a Freezed union a good fit for bloc state?

<details>
<summary>Answer</summary>
Each state carries exactly the data it needs, impossible combinations cannot be written, the generated `==` makes bloc's duplicate-state skipping work correctly, and `switch` on a sealed type forces the UI to handle every case.
</details>

---

## Assignment

### Problem 1: Write the model

Write a Freezed `Product` with `id`, `title`, `price`, a `tags` list defaulting to empty, JSON support, and a getter `isFree`.

### Problem 2: Write the union

Model the result of a payment as a Freezed union: pending, succeeded with a receipt id, failed with a code and message.

### Problem 3: Read it two ways

Show how to convert your payment union into a user facing string, once with `switch` and once with `when`.

### Problem 4: Fix the JSON

Your API sends `{"type": "card_declined", ...}` but Freezed looks for `runtimeType`. Fix it.

---

## Assignment Answers

### Problem 1: Write the model

```dart
@freezed
abstract class Product with _$Product {
  const Product._();

  const factory Product({
    required String id,
    required String title,
    required double price,
    @Default(<String>[]) List<String> tags,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);

  bool get isFree => price == 0;
}
```

### Problem 2: Write the union

```dart
@freezed
sealed class PaymentResult with _$PaymentResult {
  const factory PaymentResult.pending() = PaymentPending;
  const factory PaymentResult.succeeded(String receiptId) = PaymentSucceeded;
  const factory PaymentResult.failed({
    required String code,
    required String message,
  }) = PaymentFailed;
}
```

### Problem 3: Read it two ways

```dart
// Pattern matching
String label(PaymentResult r) => switch (r) {
      PaymentPending() => 'Processing...',
      PaymentSucceeded(:final receiptId) => 'Paid. Receipt $receiptId',
      PaymentFailed(:final message) => message,
    };

// Generated callbacks
String label2(PaymentResult r) => r.when(
      pending: () => 'Processing...',
      succeeded: (receiptId) => 'Paid. Receipt $receiptId',
      failed: (code, message) => message,
    );
```

### Problem 4: Fix the JSON

```dart
@Freezed(unionKey: 'type')
sealed class PaymentResult with _$PaymentResult {
  @FreezedUnionValue('card_declined')
  const factory PaymentResult.declined(String message) = PaymentDeclined;
  // ...
  factory PaymentResult.fromJson(Map<String, dynamic> json) =>
      _$PaymentResultFromJson(json);
}
```

---

## Navigation

⬅️ **Previous:** [JSON Serialization In Depth](05b-JsonSerializable.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Retrofit API Clients](05d-Retrofit.md)
