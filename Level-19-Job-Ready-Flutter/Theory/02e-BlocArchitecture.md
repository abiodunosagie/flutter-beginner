# Bloc Architecture: Layers, Repositories, and Errors

## The Big Idea In One Sentence

> A bloc must never know that HTTP exists: the **repository** owns data sources and turns their messy errors into clean results, the **bloc** owns decisions, and the **widget** owns pixels.

---

## The Three Layers

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   PRESENTATION      widgets, pages                   │
│   ────────────      knows: states and events         │
│        │            never knows: Dio, SQL, Firebase  │
│        ▼                                             │
│   BUSINESS LOGIC    blocs, cubits                    │
│   ──────────────    knows: repositories, models      │
│        │            never knows: widgets, BuildContext│
│        ▼                                             │
│   DATA              repositories, data sources       │
│   ────              knows: Dio, sqflite, prefs       │
│                     never knows: blocs or widgets    │
│                                                      │
│   Each arrow points ONE way. If you ever import a    │
│   widget file inside a bloc, a layer has leaked.     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Test for a leak in 5 seconds: open a bloc file and look at its imports. If you see `package:flutter/material.dart`, `dio`, or `sqflite`, something is in the wrong place. A bloc should only import `bloc`, its own models, and its repository.

---

## Folder Structure That Scales

Organise by **feature**, not by type. When you fix the cart, everything you need is in one folder.

```
lib/
├── main.dart
├── app/
│   ├── app.dart                  MaterialApp + global providers
│   └── router.dart
├── core/
│   ├── api/dio_client.dart
│   ├── error/failures.dart
│   └── widgets/                  buttons, cards used everywhere
└── features/
    ├── auth/
    │   ├── data/
    │   │   ├── auth_api.dart          talks to the network
    │   │   └── auth_repository.dart   the only door for the rest of the app
    │   ├── domain/
    │   │   └── user.dart              models
    │   └── presentation/
    │       ├── bloc/
    │       │   ├── auth_bloc.dart
    │       │   ├── auth_event.dart
    │       │   └── auth_state.dart
    │       └── view/
    │           ├── login_page.dart
    │           └── widgets/
    └── cart/
        └── (same shape)
```

The alternative ("all blocs here, all models there") looks tidy on day one and becomes unusable at 40 screens, because one change touches five distant folders.

---

## The Repository: The Most Important Class You Write

A repository does four things:

1. Hides **where** data comes from (network today, cache tomorrow)
2. Converts raw JSON into your models
3. Converts exceptions into meaningful failures
4. Decides caching and refresh policy

```dart
class ProductRepository {
  ProductRepository(this._api, this._cache);

  final ProductApi _api;      // Retrofit/Dio client
  final ProductCache _cache;  // local storage

  Future<List<Product>> getProducts({bool forceRefresh = false}) async {
    if (!forceRefresh) {
      final cached = await _cache.read();
      if (cached != null) return cached;
    }

    try {
      final products = await _api.fetchProducts();
      await _cache.write(products);
      return products;
    } on DioException catch (e) {
      throw _mapDioError(e);
    }
  }

  AppFailure _mapDioError(DioException e) {
    return switch (e.type) {
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout =>
        const AppFailure.timeout(),
      DioExceptionType.connectionError => const AppFailure.noConnection(),
      DioExceptionType.badResponse when e.response?.statusCode == 401 =>
        const AppFailure.unauthorised(),
      DioExceptionType.badResponse when e.response?.statusCode == 404 =>
        const AppFailure.notFound(),
      _ => const AppFailure.unknown(),
    };
  }
}
```

The bloc above it now handles four named failures instead of parsing HTTP status codes. That separation is what makes both sides testable.

---

## Errors: Exceptions or Result Objects

Two defensible approaches. Pick one per project and be consistent.

### Approach A: Throw typed failures, catch in the bloc

```dart
sealed class AppFailure implements Exception {
  const AppFailure();
  const factory AppFailure.timeout() = TimeoutFailure;
  const factory AppFailure.noConnection() = NoConnectionFailure;
  const factory AppFailure.unauthorised() = UnauthorisedFailure;
  const factory AppFailure.notFound() = NotFoundFailure;
  const factory AppFailure.unknown() = UnknownFailure;
}

// in the bloc
try {
  final products = await _repository.getProducts();
  emit(ProductsLoaded(products));
} on AppFailure catch (failure) {
  emit(ProductsFailed(failure.userMessage));
}
```

Simple, idiomatic Dart, and stack traces stay intact. The risk is forgetting a `try`.

### Approach B: Return a Result and never throw

```dart
sealed class Result<T> {
  const Result();
}

final class Ok<T> extends Result<T> {
  const Ok(this.value);
  final T value;
}

final class Err<T> extends Result<T> {
  const Err(this.failure);
  final AppFailure failure;
}

// in the bloc: the compiler forces you to handle the failure
final result = await _repository.getProducts();
switch (result) {
  case Ok(:final value):
    emit(ProductsLoaded(value));
  case Err(:final failure):
    emit(ProductsFailed(failure.userMessage));
}
```

Nothing can be forgotten, because you cannot read the value without matching the failure case. The cost is more ceremony everywhere.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Throwing   : less code, familiar, easy to forget   │
│   Result type: impossible to forget, more typing     │
│                                                      │
│   Interview answer: "Both work. I use typed          │
│   exceptions with an app-wide error mapper for       │
│   smaller apps, and a Result type when the team      │
│   wants failure handling enforced by the compiler."  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Turn user facing messages into a getter on the failure so no string is written twice:

```dart
extension FailureMessage on AppFailure {
  String get userMessage => switch (this) {
        TimeoutFailure() => 'That took too long. Please try again.',
        NoConnectionFailure() => 'You appear to be offline.',
        UnauthorisedFailure() => 'Please sign in again.',
        NotFoundFailure() => 'We could not find that.',
        UnknownFailure() => 'Something went wrong.',
      };
}
```

Never show a raw `e.toString()` to a user. It leaks internals and reads like a crash.

---

## Dependency Injection Without A Framework

`flutter_bloc` ships its own DI, and for most apps it is enough.

```dart
void main() {
  final dio = buildDio();

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider(create: (_) => AuthRepository(AuthApi(dio))),
        RepositoryProvider(create: (_) => ProductRepository(ProductApi(dio), ProductCache())),
      ],
      child: const App(),
    ),
  );
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          lazy: false,
          create: (c) => AuthBloc(c.read<AuthRepository>())..add(const AuthSubscribed()),
        ),
      ],
      child: MaterialApp.router(routerConfig: router),
    );
  }
}
```

Advantages over a service locator: dependencies follow the widget tree, so scoping and disposal are automatic, and tests can override a provider by wrapping the widget under test.

If the team already uses `get_it` and `injectable`, that is fine too. The point in an interview is to explain **why** you inject at all: so the bloc can be handed a fake repository in tests.

---

## Keeping State Across Restarts

```yaml
dependencies:
  hydrated_bloc: ^11.0.0
  path_provider: ^2.1.6
```

```dart
// Set the storage up once, before runApp
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: HydratedStorageDirectory(
      (await getApplicationDocumentsDirectory()).path,
    ),
  );
  runApp(const App());
}

class ThemeCubit extends HydratedCubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.system);

  void set(ThemeMode mode) => emit(mode);

  @override
  ThemeMode? fromJson(Map<String, dynamic> json) =>
      ThemeMode.values[json['index'] as int];

  @override
  Map<String, dynamic>? toJson(ThemeMode state) => {'index': state.index};
}
```

Use it for preferences and small UI state. Do not use it as your database, and never persist tokens or personal data with it; those belong in secure storage.

> **Verified gotcha (Flutter 3.38.4, build_runner 2.15.1):** adding `path_provider` to a project that also uses `build_runner` can break code generation with "Failed to compile build script", because `path_provider_foundation` pulls in a package that uses Dart's native build hooks. If you hit that, check whether a newer Flutter or `build_runner` fixes it before rewriting your code, and keep `hydrated_bloc` out of a package that generates code if it does not.

---

## The Architecture Answer For Friday

> **Q: Walk me through your app architecture.**
>
> "Three layers. Widgets only render state and add events. Blocs hold the decisions and depend on repository interfaces, never on Dio or Flutter. Repositories own the data sources, do the caching policy, and map transport errors into a small sealed set of app failures with user friendly messages. Everything is organised by feature, so a feature folder has data, domain, and presentation inside it. Dependencies are provided down the widget tree with `RepositoryProvider` and `BlocProvider`, which means every bloc can be constructed in a test with a fake repository, and no bloc ever touches `BuildContext`."

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Widgets -> blocs -> repositories -> data sources │
│   • Never import Flutter or Dio inside a bloc        │
│   • Organise by feature, not by type                 │
│   • Repository maps transport errors to failures     │
│   • Sealed failures carry the user message           │
│   • Inject with RepositoryProvider/BlocProvider      │
│   • hydrated_bloc for preferences, not for secrets   │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** How do you tell in 5 seconds that a bloc has a layering problem?

<details>
<summary>Answer</summary>
Look at its imports. `package:flutter/material.dart`, `dio`, or a database package inside a bloc file means data or UI concerns have leaked into the logic layer.
</details>

**Q2.** Why map `DioException` to your own failure type in the repository?

<details>
<summary>Answer</summary>
So the bloc handles a small, named set of outcomes instead of HTTP status codes, so the whole app can be moved to a different HTTP client without touching any bloc, and so user messages live in one place.
</details>

**Q3.** Why inject repositories instead of constructing them inside a bloc?

<details>
<summary>Answer</summary>
So a test can construct the bloc with a fake repository and run without a network, and so one repository instance (with its cache) is shared rather than duplicated per bloc.
</details>

---

## Assignment

### Problem 1: Spot the leak

```dart
class CartBloc extends Bloc<CartEvent, CartState> {
  final dio = Dio();
  Future<void> _onLoad(...) async {
    final res = await dio.get('/cart');
    ...
  }
}
```

Name two problems.

### Problem 2: Map the errors

Your API returns 401, 403, 422, and 500. Map each to a sensible sealed failure and a user message.

### Problem 3: Structure it

Sketch the folder structure for a "notifications" feature with a list screen, a settings screen, an API, and a bloc.

### Problem 4: Choose the error style

Your team has junior developers who often forget `try`/`catch`. Which error approach do you propose and why?

---

## Assignment Answers

### Problem 1: Spot the leak

1. The bloc constructs and owns `Dio`, so the data layer has leaked into the logic layer, and the bloc cannot be tested without a network.
2. There is no error mapping, so raw `DioException`s reach the UI, and the HTTP client cannot be swapped or configured centrally (interceptors, base URL, auth headers).

Fix: inject a `CartRepository`, and let it own the client and error mapping.

### Problem 2: Map the errors

- 401 -> `UnauthorisedFailure`: "Please sign in again."
- 403 -> `ForbiddenFailure`: "You do not have access to this."
- 422 -> `ValidationFailure(fieldErrors)`: show the messages next to the fields.
- 500 -> `ServerFailure`: "Our server had a problem. Please try again shortly."

### Problem 3: Structure it

```
features/notifications/
├── data/
│   ├── notifications_api.dart
│   └── notifications_repository.dart
├── domain/
│   └── notification.dart
└── presentation/
    ├── bloc/
    │   ├── notifications_bloc.dart
    │   ├── notifications_event.dart
    │   └── notifications_state.dart
    └── view/
        ├── notifications_page.dart
        ├── notification_settings_page.dart
        └── widgets/notification_tile.dart
```

### Problem 4: Choose the error style

A `Result` type. Because the value cannot be read without matching the failure case, forgetting to handle an error becomes a compile error rather than a crash in production. The cost is slightly more code at every call site, which is a good trade when the team is still building the habit.

---

## Navigation

⬅️ **Previous:** [The Bloc Widget Toolbox](02d-BlocWidgetToolbox.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [The go_router Mental Model](03a-GoRouterMentalModel.md)
