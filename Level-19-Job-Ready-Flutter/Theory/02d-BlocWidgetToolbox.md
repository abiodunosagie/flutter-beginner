# The Bloc Widget Toolbox: Six Widgets, Clear Rules

## The Big Idea In One Sentence

> `BlocProvider` supplies, `BlocBuilder` draws, `BlocListener` reacts, `BlocSelector` narrows, `BlocConsumer` does both, and `context.read`/`watch`/`select` are the shortcuts.

---

## The Whole Toolbox At A Glance

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   BlocProvider     create and share a bloc/cubit     │
│   MultiBlocProvider  several at once, no nesting     │
│   BlocBuilder      rebuild UI when state changes     │
│   BlocSelector     rebuild only when ONE field       │
│                    changes                           │
│   BlocListener     run a side effect, build nothing  │
│   BlocConsumer     builder + listener in one widget  │
│   RepositoryProvider  share a repository (not a bloc)│
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## BlocProvider: Supply

```dart
BlocProvider(
  create: (context) => CartCubit(context.read<CartRepository>()),
  child: const ShopPage(),
)
```

Key behaviours worth knowing:

- **Lazy by default.** The cubit is not created until something reads it. Pass `lazy: false` when the cubit must start work immediately (an auth check on app start).
- **Auto close.** When the provider is removed from the tree, `close()` is called for you. Never call `close()` manually on a provided bloc.
- **Scope matters.** Provide at the narrowest level that works. A cart shared across the app goes above `MaterialApp`; a form cubit goes on the form page only.

```dart
// App wide: above MaterialApp so it survives all navigation
runApp(
  MultiRepositoryProvider(
    providers: [
      RepositoryProvider(create: (_) => AuthRepository()),
      RepositoryProvider(create: (_) => CartRepository()),
    ],
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (c) => AuthBloc(c.read<AuthRepository>()), lazy: false),
        BlocProvider(create: (c) => CartCubit(c.read<CartRepository>())),
      ],
      child: const MyApp(),
    ),
  ),
);
```

`RepositoryProvider` is the same idea for things that are not blocs. It has no `close()` behaviour, it just shares an object down the tree.

---

## BlocBuilder: Draw

```dart
BlocBuilder<CartCubit, CartState>(
  builder: (context, state) => Text('${state.items.length} items'),
)
```

### buildWhen: skip pointless rebuilds

```dart
BlocBuilder<CartCubit, CartState>(
  buildWhen: (previous, current) => previous.items.length != current.items.length,
  builder: (context, state) => Badge(count: state.items.length),
)
```

`buildWhen` receives the previous and current state and returns whether to rebuild. If it returns false, `builder` does not run. Use it when the state is big and this widget cares about one slice.

Warning: `buildWhen` runs on every state change, so keep the comparison cheap. Comparing two long lists item by item inside `buildWhen` costs more than the rebuild it saves.

---

## BlocSelector: Narrow

`BlocSelector` is `BlocBuilder` plus `buildWhen`, expressed as one function.

```dart
BlocSelector<CartCubit, CartState, int>(
  selector: (state) => state.items.length,
  builder: (context, count) => Badge(count: count),
)
```

The `builder` receives the **selected value**, not the whole state, and only rebuilds when that value changes. This is the cleanest way to say "this widget depends on exactly one number".

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   State changes 100 times.                           │
│   items.length changes 3 times.                      │
│                                                      │
│   BlocBuilder            -> 100 rebuilds             │
│   BlocBuilder+buildWhen  -> 3 rebuilds               │
│   BlocSelector           -> 3 rebuilds, less code    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## BlocListener: React

```dart
BlocListener<AuthBloc, AuthState>(
  listener: (context, state) {
    if (state is AuthLoggedOut) context.go('/login');
  },
  child: const HomeView(),
)
```

Rules:

- `listener` runs **once per state change**, never on a plain rebuild
- it builds nothing; the `child` passes straight through
- it is where snackbars, dialogs, navigation, haptics, and analytics live
- `listenWhen` filters the same way `buildWhen` does

Use `MultiBlocListener` when a screen reacts to several blocs:

```dart
MultiBlocListener(
  listeners: [
    BlocListener<AuthBloc, AuthState>(listener: _onAuth),
    BlocListener<ConnectivityCubit, bool>(listener: _onConnectivity),
  ],
  child: const HomeView(),
)
```

---

## BlocConsumer: Both

```dart
BlocConsumer<CheckoutBloc, CheckoutState>(
  listenWhen: (p, c) => c is CheckoutFailed,
  listener: (context, state) => showErrorSnack(context, state),
  buildWhen: (p, c) => c is! CheckoutFailed,
  builder: (context, state) => CheckoutForm(state: state),
)
```

Use it when the same state stream drives both a visual change and a side effect. If you only need one, use the dedicated widget; it reads better.

---

## context.read / watch / select

These come from `provider`, which `flutter_bloc` builds on.

```dart
// read: get it once, do NOT subscribe. For callbacks.
onPressed: () => context.read<CartCubit>().clear(),

// watch: subscribe, rebuild this widget on every state change. For build.
final state = context.watch<CartCubit>().state;

// select: subscribe to one derived value only. For build.
final count = context.select((CartCubit c) => c.state.items.length);
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   THE RULE THAT PREVENTS 90% OF BLOC BUGS            │
│                                                      │
│   read   -> inside callbacks (onPressed, onTap,      │
│             initState, listener bodies)              │
│   watch  -> inside build only                        │
│   select -> inside build only, for one value         │
│                                                      │
│   watch inside onPressed throws at runtime.          │
│   read inside build gives a UI that never updates.   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

`context.watch` rebuilds the **whole widget** that called it. `BlocBuilder` rebuilds only its own subtree. On a large page, prefer `BlocBuilder` placed low in the tree.

---

## The "Provider not found" Error

You will hit this. The message is long but it always means one thing: **you looked for a bloc above where it was provided.**

```dart
// BROKEN: `context` here is above the BlocProvider
@override
Widget build(BuildContext context) {
  return BlocProvider(
    create: (_) => CartCubit(),
    child: Text('${context.read<CartCubit>().state.items.length}'),  // throws
  );
}
```

The `context` passed to `build` belongs to the parent, and the provider is created inside it. Two fixes:

```dart
// Fix 1: a Builder gives you a context BELOW the provider
BlocProvider(
  create: (_) => CartCubit(),
  child: Builder(
    builder: (context) => Text('${context.watch<CartCubit>().state.items.length}'),
  ),
)

// Fix 2 (better): the child is its own widget, so its context is below
BlocProvider(
  create: (_) => CartCubit(),
  child: const CartBadge(),
)
```

The same error appears when you push a route: routes are built by the `Navigator`, which lives **above** your page. That is exactly why `BlocProvider.value` exists.

```dart
Navigator.of(context).push(
  MaterialPageRoute(
    builder: (_) => BlocProvider.value(
      value: context.read<CartCubit>(),
      child: const CheckoutPage(),
    ),
  ),
);
```

---

## A Complete Screen Using The Toolbox

```dart
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          // one number, so BlocSelector
          BlocSelector<CartCubit, CartState, int>(
            selector: (state) => state.items.length,
            builder: (context, count) => Center(child: Text('$count')),
          ),
        ],
      ),
      body: BlocConsumer<CartCubit, CartState>(
        listenWhen: (p, c) => c.error != null && p.error != c.error,
        listener: (context, state) => ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(state.error!))),
        buildWhen: (p, c) => p.items != c.items,
        builder: (context, state) {
          if (state.items.isEmpty) return const EmptyCart();
          return ListView.builder(
            itemCount: state.items.length,
            itemBuilder: (context, i) => CartTile(
              key: ValueKey(state.items[i].id),
              item: state.items[i],
              // read: this is a callback
              onRemove: () =>
                  context.read<CartCubit>().remove(state.items[i].id),
            ),
          );
        },
      ),
      bottomNavigationBar: const CheckoutBar(),
    );
  }
}
```

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Provide at the narrowest scope that works        │
│   • BlocProvider auto closes; .value does not        │
│   • BlocBuilder draws, buildWhen filters             │
│   • BlocSelector for one derived value               │
│   • BlocListener for snackbars, navigation, dialogs  │
│   • read in callbacks, watch/select in build         │
│   • "Provider not found" = wrong context level       │
│   • Push routes with BlocProvider.value              │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What is the practical difference between `BlocBuilder` and `context.watch`?

<details>
<summary>Answer</summary>
`context.watch` rebuilds the entire widget whose `build` called it. `BlocBuilder` rebuilds only its own `builder` subtree, so it can be placed low in the tree to keep rebuilds small.
</details>

**Q2.** Why should a snackbar never be shown from `builder`?

<details>
<summary>Answer</summary>
`builder` can run many times for the same state (rotation, theme change, parent rebuild), so the snackbar would repeat. `listener` fires once per state change.
</details>

**Q3.** You push a new route and get "Could not find the correct Provider". Why, and what fixes it?

<details>
<summary>Answer</summary>
The route is built by the `Navigator`, which sits above your page in the tree, so the bloc is not in scope there. Wrap the pushed page in `BlocProvider.value(value: context.read<TheBloc>())`.
</details>

---

## Assignment

### Problem 1: Pick the widget

For each, name the best widget: a badge showing an unread count, redirecting to login when the session expires, a form that both shows validation errors and pops on success, a page that rebuilds on any state change.

### Problem 2: Fix the crash

```dart
ElevatedButton(
  onPressed: () => context.watch<CartCubit>().clear(),
  child: const Text('Clear'),
)
```

### Problem 3: Reduce rebuilds

A `CartState` has 12 fields. Your app bar shows only the total price. Write the widget that rebuilds only when the price changes.

### Problem 4: Scope it

Where do you provide each: an auth bloc, a cubit for one signup form, a theme cubit, a cubit for a bottom sheet?

---

## Assignment Answers

### Problem 1: Pick the widget

- Unread count badge: `BlocSelector`
- Redirect on session expiry: `BlocListener`
- Form with errors and a pop on success: `BlocConsumer`
- Page rebuilding on any state change: `BlocBuilder`

### Problem 2: Fix the crash

`watch` cannot be called inside a callback. Use `read`:

```dart
onPressed: () => context.read<CartCubit>().clear(),
```

### Problem 3: Reduce rebuilds

```dart
BlocSelector<CartCubit, CartState, double>(
  selector: (state) => state.totalPrice,
  builder: (context, total) => Text('\$${total.toStringAsFixed(2)}'),
)
```

### Problem 4: Scope it

- Auth bloc: above `MaterialApp`, with `lazy: false` so it checks the session at startup
- Signup form cubit: on the signup page only, so it is disposed when the page closes
- Theme cubit: above `MaterialApp`, because `MaterialApp` itself reads the theme
- Bottom sheet cubit: created inside the sheet's builder, or passed in with `BlocProvider.value` if the sheet edits existing state

---

## Navigation

⬅️ **Previous:** [Modeling States](02c-ModelingStates.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Bloc Architecture](02e-BlocArchitecture.md)
