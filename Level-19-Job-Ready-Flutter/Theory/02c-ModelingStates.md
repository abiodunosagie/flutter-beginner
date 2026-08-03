# Modeling States: The Part Everyone Gets Wrong

## The Big Idea In One Sentence

> Design your state so that **impossible combinations cannot be written down**, and the UI stops needing defensive `if` checks.

---

## The Problem: Boolean Soup

Here is the state class almost every beginner writes:

```dart
class ProductsState {
  final bool isLoading;
  final bool hasError;
  final String? errorMessage;
  final List<Product> products;
  final bool isEmpty;
}
```

Count the combinations: 2 x 2 x 2 x 2 = 16 possible states. How many are real? About four. The rest are nonsense that your code must still handle:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   isLoading: true, hasError: true                    │
│      -> loading AND failed at the same time?         │
│                                                      │
│   hasError: true, errorMessage: null                 │
│      -> failed with no reason to show?               │
│                                                      │
│   products: [3 items], isEmpty: true                 │
│      -> three products but also empty?               │
│                                                      │
│   Every one of these will happen in production,      │
│   because nothing stops you from writing it.         │
│                                                      │
└──────────────────────────────────────────────────────┘
```

And the UI becomes a pile of guesses:

```dart
if (state.isLoading) return const Spinner();
if (state.hasError) return Text(state.errorMessage ?? 'Unknown error');  // ?? is the smell
if (state.products.isEmpty) return const EmptyView();
return ProductList(state.products);
```

Change the order of those `if`s and the screen behaves differently. That is a design problem, not a coding problem.

---

## Style 1: Sealed Class Hierarchy (one class per situation)

```dart
sealed class ProductsState {
  const ProductsState();
}

final class ProductsInitial extends ProductsState {
  const ProductsInitial();
}

final class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

final class ProductsLoaded extends ProductsState {
  const ProductsLoaded(this.products);
  final List<Product> products;
}

final class ProductsFailed extends ProductsState {
  const ProductsFailed(this.message);
  final String message;
}
```

Now the impossible states are literally unwritable. `ProductsFailed` always has a message. `ProductsLoaded` always has a list. There is no "loading and failed".

The UI becomes exhaustive and order independent:

```dart
BlocBuilder<ProductsCubit, ProductsState>(
  builder: (context, state) => switch (state) {
    ProductsInitial() => const SizedBox.shrink(),
    ProductsLoading() => const Spinner(),
    ProductsLoaded(:final products) when products.isEmpty => const EmptyView(),
    ProductsLoaded(:final products) => ProductList(products),
    ProductsFailed(:final message) => ErrorView(message),
  },
)
```

Three Dart 3 features are doing the work here:

- `sealed` means the compiler knows the complete list of subclasses
- the `switch` **expression** returns a value, so it can sit directly in `builder`
- `ProductsLoaded(:final products)` destructures the field out in one step
- `when products.isEmpty` adds a guard clause

If a teammate adds `ProductsRefreshing` later, every `switch` in the codebase fails to compile until it is handled. That is the safety net you are buying.

---

## Style 2: One Class With A Status Enum

```dart
enum ProductsStatus { initial, loading, success, failure }

final class ProductsState extends Equatable {
  const ProductsState({
    this.status = ProductsStatus.initial,
    this.products = const [],
    this.errorMessage,
  });

  final ProductsStatus status;
  final List<Product> products;
  final String? errorMessage;

  bool get isEmpty => status == ProductsStatus.success && products.isEmpty;

  ProductsState copyWith({
    ProductsStatus? status,
    List<Product>? products,
    String? errorMessage,
  }) {
    return ProductsState(
      status: status ?? this.status,
      products: products ?? this.products,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, products, errorMessage];
}
```

This style wins when **data must survive a status change**. Pull to refresh is the classic case:

```dart
// Keep showing the old list while refreshing in the background
emit(state.copyWith(status: ProductsStatus.loading));   // products still there
```

With the sealed style you would have to invent `ProductsRefreshing(oldProducts)` to do the same thing, which is fine but wordier.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   SEALED CLASSES                                     │
│   • Impossible states impossible                     │
│   • Exhaustive switch, compiler enforced             │
│   • Best for: linear flows (load once and show)      │
│                                                      │
│   SINGLE CLASS + STATUS ENUM                         │
│   • Data survives status changes                     │
│   • copyWith is convenient                           │
│   • Best for: refresh, pagination, forms with        │
│     many fields changing independently               │
│                                                      │
│   Both are used at real companies. Say which you     │
│   picked and WHY, and any interviewer is satisfied.  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Equality Is Not Optional

Bloc skips an `emit` when the new state `==` the current state. Without value equality, **every** emit rebuilds; with wrong equality, some emits are silently dropped.

### Option A: Equatable

```dart
final class CartState extends Equatable {
  const CartState({this.items = const [], this.coupon});

  final List<CartItem> items;
  final String? coupon;

  @override
  List<Object?> get props => [items, coupon];   // list every field
}
```

The single most common Equatable bug: **forgetting to add a new field to `props`**. The field changes, `props` does not, `==` returns true, the UI never updates, and you spend an hour blaming `BlocBuilder`. When you add a field, add it to `props` in the same keystroke.

### Option B: Freezed (generates equality, copyWith, and toString)

```dart
@freezed
abstract class CartState with _$CartState {
  const factory CartState({
    @Default([]) List<CartItem> items,
    String? coupon,
  }) = _CartState;
}
```

Nothing to forget, because the generator writes `==`, `hashCode`, `copyWith`, and `toString` from the fields themselves. Part 5 of this level covers Freezed properly.

---

## The copyWith Null Trap

This bites everyone once:

```dart
ProductsState copyWith({String? errorMessage}) {
  return ProductsState(errorMessage: errorMessage ?? this.errorMessage);
}

// Now try to CLEAR the error:
state.copyWith(errorMessage: null);   // does nothing at all
```

Because `null` means "not provided", you cannot use `copyWith` to set a field back to `null`. Three ways out:

```dart
// 1. A dedicated method (simplest, most readable)
ProductsState clearError() => ProductsState(status: status, products: products);

// 2. A sentinel wrapper
ProductsState copyWith({Object? errorMessage = _sentinel}) {
  return ProductsState(
    errorMessage: identical(errorMessage, _sentinel)
        ? this.errorMessage
        : errorMessage as String?,
  );
}

// 3. Use sealed states, where "no error" is simply a different class
```

Freezed's generated `copyWith` has the same limitation, and it is a favourite interview question because it proves you have actually shipped with these tools.

---

## Naming That Reads Well

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   EVENTS: past tense, what the USER did              │
│   LoginSubmitted, CartItemRemoved, PageScrolled      │
│   not: DoLogin, RemoveItem, SetLoading               │
│                                                      │
│   STATES: a situation, not an action                 │
│   LoginInProgress, CartUpdated, ProfileLoaded        │
│   not: Loading (of what?), Error (whose?)            │
│                                                      │
│   Prefix with the feature so imports stay clear:     │
│   SearchLoading, not Loading                         │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Where To Put Side Effects

A snackbar is not a state. Neither is a navigation push. States describe what the screen **looks like**; one off actions belong in a listener.

```dart
BlocConsumer<CheckoutBloc, CheckoutState>(
  listenWhen: (previous, current) => current is CheckoutSucceeded,
  listener: (context, state) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed')),
    );
    context.go('/orders');
  },
  builder: (context, state) => switch (state) {
    CheckoutIdle() => const CheckoutForm(),
    CheckoutSubmitting() => const Spinner(),
    CheckoutSucceeded() => const CheckoutForm(),
    CheckoutFailed(:final message) => ErrorView(message),
  },
)
```

Why it matters: `builder` can run many times (a rotate, a theme change, a parent rebuild). If you show the snackbar in `builder`, the user sees it again every time. `listener` runs **once per state change**, which is exactly what a side effect needs.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Boolean soup allows impossible states            │
│   • sealed classes = impossible states impossible    │
│   • status enum = data survives status changes       │
│   • Equatable props must list EVERY field            │
│   • copyWith cannot set a field back to null         │
│   • Events past tense, states describe a situation   │
│   • Snackbars and navigation live in listener,       │
│     never in builder                                 │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why is `isLoading` plus `hasError` plus `errorMessage` a bad state design?

<details>
<summary>Answer</summary>
It allows combinations that make no sense (loading and failed at once, failed with no message), so the UI needs defensive checks and the order of those checks silently changes behaviour.
</details>

**Q2.** When is the status enum style better than sealed classes?

<details>
<summary>Answer</summary>
When data must survive a status change: pull to refresh and pagination, where you keep showing the old list while a new page loads. Also for forms where many independent fields change.
</details>

**Q3.** Why can't `copyWith(errorMessage: null)` clear a field?

<details>
<summary>Answer</summary>
Because `null` is indistinguishable from "argument not provided", and the `?? this.errorMessage` fallback keeps the old value. You need a dedicated method, a sentinel value, or sealed states.
</details>

---

## Assignment

### Problem 1: Redesign the state

```dart
class LoginState {
  bool isLoading;
  bool isSuccess;
  bool isFailure;
  String? error;
  User? user;
}
```

Rewrite it as sealed classes.

### Problem 2: Pick the style

Choose sealed or status enum for each, one line why: an article reader page, an infinite scrolling feed, a multi step signup form, a splash screen deciding logged in or out.

### Problem 3: Find the equality bug

```dart
class ProfileState extends Equatable {
  const ProfileState({required this.name, required this.avatarUrl});
  final String name;
  final String avatarUrl;

  @override
  List<Object?> get props => [name];
}
```

What breaks?

### Problem 4: Builder or listener

Where does each belong: showing a spinner, navigating after checkout, disabling a button, showing an error snackbar, painting the product grid.

---

## Assignment Answers

### Problem 1: Redesign the state

```dart
sealed class LoginState {
  const LoginState();
}

final class LoginIdle extends LoginState {
  const LoginIdle();
}

final class LoginInProgress extends LoginState {
  const LoginInProgress();
}

final class LoginSucceeded extends LoginState {
  const LoginSucceeded(this.user);
  final User user;
}

final class LoginFailed extends LoginState {
  const LoginFailed(this.message);
  final String message;
}
```

Now a success always carries a user, a failure always carries a message, and no state can be two things at once.

### Problem 2: Pick the style

- Article reader: sealed. Load once and show, a clean linear flow.
- Infinite feed: status enum. You must keep existing items while loading the next page.
- Multi step signup form: status enum. Many field values change independently and must persist.
- Splash deciding auth: sealed. Exactly three outcomes: unknown, authenticated, unauthenticated.

### Problem 3: Find the equality bug

`avatarUrl` is missing from `props`. If only the avatar changes, `==` returns true, bloc skips the emit, and the new avatar never appears. Fix: `props => [name, avatarUrl]`.

### Problem 4: Builder or listener

- Spinner: builder
- Navigate after checkout: listener
- Disable a button: builder
- Error snackbar: listener
- Product grid: builder

---

## Navigation

⬅️ **Previous:** [Bloc Deep Dive](02b-BlocDeepDive.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [The Bloc Widget Toolbox](02d-BlocWidgetToolbox.md)
