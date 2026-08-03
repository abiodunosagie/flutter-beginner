# Routes and Parameters: Passing Data Without Typos

## The Big Idea In One Sentence

> Put **identity** in the path, **options** in the query string, and only put objects in `extra` when they cannot be looked up again.

---

## The Three Ways To Pass Data

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   /products/42?tab=reviews  (extra: cachedProduct)   │
│             ▲       ▲                  ▲             │
│             │       │                  │             │
│        PATH PARAM   │              EXTRA OBJECT      │
│        who am I?    │              a real Dart object│
│                QUERY PARAM                           │
│                how should I look?                    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

| Kind | Survives a deep link | Survives a refresh on web | Use for |
|---|---|---|---|
| Path parameter | Yes | Yes | ids, slugs, anything identifying the page |
| Query parameter | Yes | Yes | tab, sort, filter, page number, search text |
| `extra` | No | No | a fully loaded object you already have, as an optimisation |

---

## Path Parameters

```dart
GoRoute(
  path: '/products/:id',
  builder: (context, state) {
    final id = state.pathParameters['id']!;
    return ProductPage(id: id);
  },
)

context.go('/products/42');
```

Multiple parameters are fine:

```dart
GoRoute(
  path: '/teams/:teamId/members/:memberId',
  builder: (context, state) => MemberPage(
    teamId: state.pathParameters['teamId']!,
    memberId: state.pathParameters['memberId']!,
  ),
)
```

Everything arrives as a `String`. Parse defensively, because a deep link can contain anything:

```dart
builder: (context, state) {
  final id = int.tryParse(state.pathParameters['id'] ?? '');
  if (id == null) return const NotFoundPage();
  return ProductPage(id: id);
},
```

Also remember to encode values that may contain slashes or spaces:

```dart
context.go('/search/${Uri.encodeComponent(query)}');
```

---

## Query Parameters

```dart
GoRoute(
  path: '/products',
  builder: (context, state) {
    final sort = state.uri.queryParameters['sort'] ?? 'popular';
    final page = int.tryParse(state.uri.queryParameters['page'] ?? '') ?? 1;
    final tags = state.uri.queryParametersAll['tag'] ?? const [];
    return ProductsPage(sort: sort, page: page, tags: tags);
  },
)

context.go('/products?sort=price&page=2&tag=new&tag=sale');
```

Note `state.uri.queryParameters`, not `state.queryParameters`. `queryParametersAll` returns a `List<String>` per key, which is how you support repeated keys like multiple tags.

Query parameters are the right home for **screen options**, and putting them there gives you three things for free: the back button restores the previous filter, the web URL is shareable, and the state survives a hot restart.

---

## The `extra` Parameter

```dart
context.push('/products/42', extra: product);

GoRoute(
  path: '/products/:id',
  builder: (context, state) {
    final cached = state.extra as Product?;    // may be null
    final id = state.pathParameters['id']!;
    return ProductPage(id: id, initial: cached);
  },
)
```

`extra` holds a real Dart object, so there is no serialisation and no size limit. But it is **not part of the URL**, which means:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   extra is LOST when:                                │
│   • the app is opened from a deep link               │
│   • the browser is refreshed on web                  │
│   • the app is restored after being killed           │
│                                                      │
│   So NEVER require it. Always design the page to     │
│   work from the path alone, and treat extra as       │
│   "here is the data early, to skip the spinner".     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

That pattern (`initial: cached` plus a fetch by id) is exactly how production apps get instant detail pages without breaking deep links.

---

## Typed Routes: No More Strings

`go_router_builder` generates route classes so paths, parameters, and types are checked by the compiler.

```yaml
dependencies:
  go_router: ^17.3.0

dev_dependencies:
  build_runner: ^2.15.1
  go_router_builder: ^4.4.0
```

```dart
// lib/routing/routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

part 'routes.g.dart';

@TypedGoRoute<HomeRoute>(
  path: '/',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<ProductRoute>(path: 'products/:id'),
  ],
)
class HomeRoute extends GoRouteData with $HomeRoute {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const HomePage();
}

class ProductRoute extends GoRouteData with $ProductRoute {
  const ProductRoute({required this.id, this.tab});

  final String id;        // path parameter, matched by name
  final String? tab;      // query parameter, because it is not in the path

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ProductPage(id: id, tab: tab);
}
```

Generate:

```bash
dart run build_runner build
```

Then wire the generated `$appRoutes` list into the router and navigate with objects:

```dart
final router = GoRouter(routes: $appRoutes);

// Compile time checked. Misspell a field and the build fails.
const ProductRoute(id: '42', tab: 'reviews').go(context);
const ProductRoute(id: '42').push(context);
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   IMPORTANT DETAIL PEOPLE GET WRONG                  │
│                                                      │
│   The mixin is  $ProductRoute  (one dollar sign),    │
│   not _$ProductRoute. Using the wrong one gives:     │
│   "Missing mixin clause `with $ProductRoute`".       │
│                                                      │
│   Only the ROOT route of a tree carries the          │
│   @TypedGoRoute annotation; children are listed      │
│   inside its `routes:` argument.                     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Constructor fields map automatically: a field whose name matches a `:segment` becomes a path parameter, and every other field becomes a query parameter. Supported types include `String`, `int`, `double`, `bool`, `DateTime`, enums, and their nullable and `Iterable` forms.

For `extra`, use `$extra`:

```dart
class ProductRoute extends GoRouteData with $ProductRoute {
  const ProductRoute({required this.id, this.$extra});
  final String id;
  final Product? $extra;
}
```

Worth saying in an interview: typed routes remove an entire class of production bug, the mistyped path string that only fails at runtime on one screen nobody tested.

---

## Returning Data From A Route

```dart
// Page A
final chosen = await context.push<DateTime>('/date-picker');
if (chosen != null) setState(() => _date = chosen);

// Page B
ElevatedButton(
  onPressed: () => context.pop(_selectedDate),
  child: const Text('Confirm'),
)
```

Only `push` returns a value. `go` does not, because it rebuilds the stack rather than layering a page on top.

---

## Custom Transitions

```dart
GoRoute(
  path: '/details',
  pageBuilder: (context, state) => CustomTransitionPage(
    key: state.pageKey,
    child: const DetailsPage(),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  ),
)
```

Use `pageBuilder` instead of `builder` when you need control over the page: a custom transition, `fullscreenDialog: true`, or a `NoTransitionPage` for tab switches. Always pass `key: state.pageKey` so the framework can tell pages apart.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Path = identity, query = options, extra = cache  │
│   • state.pathParameters / state.uri.queryParameters │
│   • Everything from a URL is a String: parse safely  │
│   • extra dies on deep links and web refresh         │
│   • go_router_builder gives compile time routes      │
│   • The generated mixin is $Route, not _$Route       │
│   • push returns a Future, go does not               │
│   • pageBuilder + CustomTransitionPage for animation │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Where should a product id live, and where should a "sort by price" option live?

<details>
<summary>Answer</summary>
The id goes in the path (`/products/42`) because it identifies the page. The sort goes in the query string (`?sort=price`) because it is an option, and that keeps it shareable and restorable.
</details>

**Q2.** Why must a page never depend on `extra`?

<details>
<summary>Answer</summary>
`extra` is not part of the URL, so it is null when the page is opened from a deep link, a web refresh, or after the process was killed. Design the page to load from the path, and use `extra` only to skip the loading spinner.
</details>

**Q3.** What does the error "Missing mixin clause `with $ProductRoute`" mean?

<details>
<summary>Answer</summary>
The route class used the wrong generated mixin name. `go_router_builder` generates `$ProductRoute` with a single dollar sign, not `_$ProductRoute`.
</details>

---

## Assignment

### Problem 1: Design the URL

Design the route for a page that shows order number 883 for user "ada", filtered to unpaid items, sorted newest first.

### Problem 2: Parse safely

Write the `builder` for `/invoices/:id` that shows a not found page if the id is not a positive integer.

### Problem 3: Typed route

Write a typed route class for `/search` that takes a required `query` string and an optional `page` int.

### Problem 4: Find the bug

```dart
context.push('/checkout', extra: cart);
// checkout page:
final cart = state.extra! as Cart;
```

What breaks and when?

---

## Assignment Answers

### Problem 1: Design the URL

```
/users/ada/orders/883?status=unpaid&sort=newest
```

Identity (`ada`, `883`) in the path; the filter and sort as query parameters so the view is shareable and the back button restores the previous filter.

### Problem 2: Parse safely

```dart
GoRoute(
  path: '/invoices/:id',
  builder: (context, state) {
    final id = int.tryParse(state.pathParameters['id'] ?? '');
    if (id == null || id <= 0) return const NotFoundPage();
    return InvoicePage(id: id);
  },
)
```

### Problem 3: Typed route

```dart
class SearchRoute extends GoRouteData with $SearchRoute {
  const SearchRoute({required this.query, this.page});

  final String query;
  final int? page;

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      SearchPage(query: query, page: page ?? 1);
}
```

Registered with `TypedGoRoute<SearchRoute>(path: '/search')`. Both fields become query parameters, since neither appears as a `:segment` in the path.

### Problem 4: Find the bug

`state.extra!` crashes with a null check error whenever `extra` is missing: a deep link to `/checkout`, a browser refresh, or an app restored after being killed. Read it as nullable and fall back to loading the cart from the repository.

---

## Navigation

⬅️ **Previous:** [The go_router Mental Model](03a-GoRouterMentalModel.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Shell Routes and Persistent Navigation](03c-ShellRoutes.md)
