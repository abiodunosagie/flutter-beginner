# The go_router Mental Model: The URL Is The State

## The Big Idea In One Sentence

> With `Navigator` you **command** the app ("push this screen"); with `go_router` you **declare** a URL and the router works out which screens should exist.

---

## The Simple Explanation

Think of a lift in a building.

**Navigator** is a lift with only "up one floor" and "down one floor" buttons. To reach floor 7 you press up seven times, and the lift remembers every floor you visited as a stack of cards.

**go_router** is a lift with a keypad. You type `7` and it goes there. If floor 7 is inside wing B, the lift knows wing B must be entered first, so it builds that path for you.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   IMPERATIVE (Navigator)                             │
│   Navigator.push(MaterialPageRoute(                  │
│     builder: (_) => ProductPage(id: 42),             │
│   ));                                                │
│   "Put this exact widget on top of the stack."       │
│                                                      │
│   DECLARATIVE (go_router)                            │
│   context.go('/products/42');                        │
│   "The app is now at /products/42."                  │
│   The router decides which pages exist to make       │
│   that true, including any parent pages.             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Why Teams Move To go_router

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   1. DEEP LINKS                                      │
│      A push notification or a link opens             │
│      myapp://products/42 and the app lands there     │
│      with a correct back stack.                      │
│                                                      │
│   2. WEB URLS                                        │
│      The browser address bar shows /products/42,     │
│      the back button works, refresh works,           │
│      users can bookmark and share.                   │
│                                                      │
│   3. GUARDS IN ONE PLACE                             │
│      One redirect function protects every private    │
│      route, instead of an auth check in 30 screens.  │
│                                                      │
│   4. NESTED SHELLS                                   │
│      A bottom bar that stays put while its tab       │
│      content changes, with a separate history        │
│      per tab.                                        │
│                                                      │
│   5. TYPE SAFETY (with go_router_builder)            │
│      No more string typos in route paths.            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

If an interviewer asks "why go_router", lead with deep linking and central guards. Those are the two that cost real money to retrofit later.

---

## Setup

```yaml
dependencies:
  go_router: ^17.3.0
```

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/settings',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router, NOT MaterialApp
    return MaterialApp.router(
      routerConfig: router,
      title: 'My App',
    );
  }
}
```

Three things must be right or nothing works:

1. `MaterialApp.router` with `routerConfig:` (not `home:` and not `routes:`)
2. The router is created **once**, outside `build`. Creating it inside `build` resets navigation on every rebuild, which shows up as "my app jumps back to the home screen randomly".
3. Every path starts with `/` at the top level. Child paths do **not** start with `/`.

---

## Paths Are A Tree

```dart
GoRoute(
  path: '/products',                       // /products
  builder: (context, state) => const ProductsPage(),
  routes: [
    GoRoute(
      path: ':id',                         // /products/42
      builder: (context, state) => ProductPage(id: state.pathParameters['id']!),
      routes: [
        GoRoute(
          path: 'reviews',                 // /products/42/reviews
          builder: (context, state) => ReviewsPage(id: state.pathParameters['id']!),
        ),
      ],
    ),
  ],
)
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Child path with a leading slash: '/id'  ✗          │
│   Child path without one:          ':id'  ✓          │
│                                                      │
│   A leading slash makes it a top level route,        │
│   which silently breaks nesting and the back stack.  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## go vs push: The Question Everyone Gets Wrong

```dart
context.go('/products/42');    // REPLACE the stack to match this location
context.push('/products/42');  // ADD a page on top of the current stack
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Stack: [ / , /cart ]                               │
│                                                      │
│   context.go('/products/42')                         │
│      -> [ /products , /products/42 ]                 │
│      The router REBUILDS the stack from the path.    │
│      Back goes to /products, not /cart.              │
│                                                      │
│   context.push('/products/42')                       │
│      -> [ / , /cart , /products/42 ]                 │
│      Back goes to /cart.                             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Which to use:

| Situation | Method |
|---|---|
| Switching main sections (tabs, drawer items) | `go` |
| After login, going to home | `go` |
| Opening a detail from a list | `push` (or `go` if the detail is a real child route) |
| Opening a modal-ish page that must return a value | `push`, because it returns a `Future` |
| After finishing a flow, returning to the root | `go` |

`push` returns a `Future` you can await:

```dart
final result = await context.push<bool>('/confirm');
if (result == true) {
  // the pushed page called context.pop(true)
}
```

Other movements:

```dart
context.pop();                  // go back one page
context.pop(result);            // go back and return a value
context.replace('/home');       // swap the current page, no new history entry
context.goNamed('product', pathParameters: {'id': '42'});
context.canPop();               // is there anything to pop?
```

---

## Named Routes: Stop Typing Strings

```dart
GoRoute(
  path: '/products/:id',
  name: 'product',
  builder: (context, state) => ProductPage(id: state.pathParameters['id']!),
)

// Call sites never repeat the path:
context.goNamed('product', pathParameters: {'id': product.id});
```

Rename `/products/:id` to `/catalogue/:id` later and every call site keeps working. Better still, use `go_router_builder` for compile time safety, which the next lesson covers.

---

## Where Does The Back Button Go?

On Android the system back button, on iOS the swipe, and on the web the browser back button all end up in the same place: the router. A location built by `go` has a back stack **derived from the path**, which is exactly why deep links behave correctly.

```
User taps a notification for /products/42/reviews
        │
        ▼
Router builds:  /products  ->  /products/42  ->  /products/42/reviews
        │
        ▼
Pressing back lands on the product page, then the list,
even though the user never visited them.
```

With plain `Navigator`, a deep link would drop the user on a page with an empty stack and a back button that closes the app. This one behaviour is why go_router exists.

---

## Debugging

```dart
final router = GoRouter(
  debugLogDiagnostics: true,   // prints every navigation and redirect
  routes: [...],
);
```

Turn it on the first time a route misbehaves. It prints the matched route, the full path, and every redirect, which usually shows the bug immediately (a missing leading slash, or a redirect loop).

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • go_router: declare a URL, the router builds it   │
│   • MaterialApp.router + routerConfig                │
│   • Build the router ONCE, outside build()           │
│   • Top level paths start with /, children do not    │
│   • go = replace the stack, push = add a page        │
│   • push returns a Future for a result               │
│   • Named routes stop path strings spreading         │
│   • debugLogDiagnostics: true when confused          │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** What is the practical difference between `context.go` and `context.push`?

<details>
<summary>Answer</summary>
`go` rebuilds the whole stack so it matches the target location, so back follows the path hierarchy. `push` adds one page on top of the existing stack, so back returns to whatever was there before.
</details>

**Q2.** Why must the `GoRouter` be created outside `build`?

<details>
<summary>Answer</summary>
Creating it inside `build` makes a new router (and a new navigation state) on every rebuild, which resets the app to its initial location at random moments.
</details>

**Q3.** A user opens a deep link to `/products/42/reviews`. Why does back work correctly with go_router but not with plain `Navigator.push`?

<details>
<summary>Answer</summary>
go_router derives the stack from the path, so it creates the parent pages too. A single `Navigator.push` puts one page on an empty stack, so back has nowhere to go.
</details>

---

## Assignment

### Problem 1: Fix the paths

```dart
GoRoute(
  path: '/orders',
  routes: [GoRoute(path: '/:id', builder: ...)],
)
```

What is wrong and what does it break?

### Problem 2: go or push

Pick one for each: tapping a bottom bar tab, opening a chat from a chat list, submitting a login form, closing a filter sheet that returns selected filters.

### Problem 3: Name it

Convert this to a named route and show both the route and the call site:

```dart
context.go('/users/${user.id}/settings');
```

### Problem 4: Explain the stack

Current stack is `[/, /search]`. What is the stack after `context.go('/products/9')` if `/products/:id` is a child of `/products`?

---

## Assignment Answers

### Problem 1: Fix the paths

The child path has a leading slash, so it is treated as a top level route `/:id` instead of `/orders/:id`. Nesting is lost, the parent page is not built, and the back stack from a deep link is wrong. Fix: `path: ':id'`.

### Problem 2: go or push

- Bottom bar tab: `go` (switching sections)
- Chat from a list: `push` (a detail on top), or `go` if chats are a real child route and you want path based back
- Login submit: `go('/home')`, so the user cannot go back into the login screen
- Filter sheet returning values: `push`, then `context.pop(filters)` to return them

### Problem 3: Name it

```dart
GoRoute(
  path: '/users/:userId/settings',
  name: 'userSettings',
  builder: (context, state) =>
      UserSettingsPage(userId: state.pathParameters['userId']!),
)

// call site
context.goNamed('userSettings', pathParameters: {'userId': user.id});
```

### Problem 4: Explain the stack

`[/products, /products/9]`. `go` discards the old stack and rebuilds it from the path, so `/search` is gone and the parent `/products` page is created underneath the detail.

---

## Navigation

⬅️ **Previous:** [Bloc Architecture](02e-BlocArchitecture.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Routes and Parameters](03b-RoutesAndParameters.md)
