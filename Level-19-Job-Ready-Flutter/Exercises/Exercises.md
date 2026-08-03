# Level 19 Exercises: Job Ready Flutter

Work through the exercises for a PART after you finish that PART's theory.
Every exercise has a worked solution. Try it first, then open the solution.

Set up one project and use it for all six parts:

```bash
flutter create job_ready
cd job_ready
flutter pub add flutter_bloc equatable go_router dio retrofit json_annotation freezed_annotation
flutter pub add dev:build_runner dev:freezed dev:json_serializable dev:retrofit_generator dev:go_router_builder dev:bloc_test dev:mocktail dev:bloc_concurrency
```

Then add to `analysis_options.yaml`:

```yaml
analyzer:
  errors:
    invalid_annotation_target: ignore
```

---

## PART 1: Widget Composition and Responsive UI

### Exercise 1.1: Kill the class explosion

You inherit this code:

```dart
class PrimaryButton extends StatelessWidget { /* blue, filled */ }
class DangerButton extends StatelessWidget { /* red, filled */ }
class PrimaryLoadingButton extends StatelessWidget { /* blue + spinner */ }
class DangerLoadingButton extends StatelessWidget { /* red + spinner */ }
class PrimaryWideButton extends StatelessWidget { /* blue, full width */ }
```

Replace all five with one widget.

<details>
<summary>Solution</summary>

```dart
enum AppButtonTone { primary, danger }

class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.tone = AppButtonTone.primary,
    this.isLoading = false,
    this.expand = false,
    this.icon,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonTone tone;
  final bool isLoading;
  final bool expand;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor:
            tone == AppButtonTone.danger ? colors.error : colors.primary,
      ),
      child: isLoading
          ? const SizedBox(
              height: 18,
              width: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[
                  Icon(icon, size: 18),
                  const SizedBox(width: 8),
                ],
                Text(label),
              ],
            ),
    );

    return expand ? SizedBox(width: double.infinity, child: button) : button;
  }
}
```

Five classes became five parameters, and combinations that used to need a
sixth class (danger + loading + wide) now cost nothing.

</details>

---

### Exercise 1.2: Fix the rebuilds

```dart
class _FeedPageState extends State<FeedPage> {
  int likes = 0;

  Widget _buildHeader() => Padding(
        padding: EdgeInsets.all(24),
        child: Text('My Feed', style: TextStyle(fontSize: 28)),
      );

  Widget _buildFooter() => Padding(
        padding: EdgeInsets.all(16),
        child: Text('End of feed'),
      );

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        Expanded(child: ExpensiveFeedList()),
        Text('$likes likes'),
        ElevatedButton(
          onPressed: () => setState(() => likes++),
          child: Text('Like'),
        ),
        _buildFooter(),
      ],
    );
  }
}
```

List every change that reduces work per tap, then write the fixed version.

<details>
<summary>Solution</summary>

Changes:

1. Turn `_buildHeader` and `_buildFooter` into `const` widget classes so
   Flutter can skip them entirely.
2. Move the counter and its `setState` into a small stateful widget, so
   tapping Like does not rebuild the header, the list, or the footer.
3. `FeedPage` becomes stateless.
4. Add `const` to every constructor that allows it.

```dart
class FeedPage extends StatelessWidget {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        FeedHeader(),
        Expanded(child: ExpensiveFeedList()),
        LikeCounter(),
        FeedFooter(),
      ],
    );
  }
}

class FeedHeader extends StatelessWidget {
  const FeedHeader({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(24),
        child: Text('My Feed', style: TextStyle(fontSize: 28)),
      );
}

class FeedFooter extends StatelessWidget {
  const FeedFooter({super.key});

  @override
  Widget build(BuildContext context) => const Padding(
        padding: EdgeInsets.all(16),
        child: Text('End of feed'),
      );
}

class LikeCounter extends StatefulWidget {
  const LikeCounter({super.key});

  @override
  State<LikeCounter> createState() => _LikeCounterState();
}

class _LikeCounterState extends State<LikeCounter> {
  int likes = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('$likes likes'),
        ElevatedButton(
          onPressed: () => setState(() => likes++),
          child: const Text('Like'),
        ),
      ],
    );
  }
}
```

Now a tap rebuilds three lines instead of the whole page.

</details>

---

### Exercise 1.3: Build an adaptive list and detail screen

Build a screen that shows a list of 20 items. On a screen narrower than 840
tapping an item pushes a detail page; on a wider screen the detail shows
beside the list. The detail widget must be written once.

<details>
<summary>Solution</summary>

```dart
class InboxPage extends StatefulWidget {
  const InboxPage({super.key});

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  static const _items = <String>[
    'Welcome', 'Your receipt', 'Password changed', 'Weekly summary',
  ];

  String? _selected;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 840;

    final list = ListView.builder(
      itemCount: _items.length,
      itemBuilder: (context, i) => ListTile(
        key: ValueKey(_items[i]),
        title: Text(_items[i]),
        selected: isWide && _selected == _items[i],
        onTap: () {
          if (isWide) {
            setState(() => _selected = _items[i]);
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => Scaffold(
                  appBar: AppBar(title: Text(_items[i])),
                  body: MessageDetail(subject: _items[i]),
                ),
              ),
            );
          }
        },
      ),
    );

    if (!isWide) return Scaffold(appBar: AppBar(title: const Text('Inbox')), body: list);

    return Scaffold(
      appBar: AppBar(title: const Text('Inbox')),
      body: Row(
        children: [
          SizedBox(width: 320, child: list),
          const VerticalDivider(width: 1),
          Expanded(
            child: _selected == null
                ? const Center(child: Text('Select a message'))
                : MessageDetail(subject: _selected!),
          ),
        ],
      ),
    );
  }
}

// Written ONCE. No Scaffold inside, so it can be embedded or wrapped.
class MessageDetail extends StatelessWidget {
  const MessageDetail({super.key, required this.subject});

  final String subject;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(subject, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 12),
          const Text('Message body goes here.'),
        ],
      ),
    );
  }
}
```

</details>

---

## PART 2: Cubit and Bloc

### Exercise 2.1: Write a cubit with a failure path

Write a `WeatherCubit` with sealed states that loads a temperature for a city
and handles failure.

<details>
<summary>Solution</summary>

```dart
sealed class WeatherState {
  const WeatherState();
}

final class WeatherInitial extends WeatherState {
  const WeatherInitial();
}

final class WeatherLoading extends WeatherState {
  const WeatherLoading();
}

final class WeatherLoaded extends WeatherState {
  const WeatherLoaded({required this.city, required this.celsius});
  final String city;
  final double celsius;
}

final class WeatherFailed extends WeatherState {
  const WeatherFailed(this.message);
  final String message;
}

class WeatherCubit extends Cubit<WeatherState> {
  WeatherCubit(this._repository) : super(const WeatherInitial());

  final WeatherRepository _repository;

  Future<void> load(String city) async {
    emit(const WeatherLoading());
    try {
      final celsius = await _repository.temperatureFor(city);
      if (isClosed) return;
      emit(WeatherLoaded(city: city, celsius: celsius));
    } catch (_) {
      if (isClosed) return;
      emit(const WeatherFailed('Could not reach the weather service.'));
    }
  }
}
```

</details>

---

### Exercise 2.2: Find three bugs

```dart
class CartCubit extends Cubit<CartState> {
  CartCubit() : super(CartState(items: []));

  void add(Item item) {
    state.items.add(item);
    emit(state);
  }

  Future<void> checkout() async {
    emit(CartState(items: state.items, isSubmitting: true));
    await api.checkout(state.items);
    emit(CartState(items: []));
  }
}

class CartState {
  CartState({required this.items, this.isSubmitting = false});
  final List<Item> items;
  final bool isSubmitting;
}
```

<details>
<summary>Solution</summary>

**Bug 1: mutation.** `state.items.add(item)` changes the existing list, so the
new state is identical to the old one and bloc skips the emit. The UI never
updates.

```dart
void add(Item item) => emit(CartState(items: [...state.items, item]));
```

**Bug 2: no value equality.** `CartState` has no `==`, so bloc compares by
identity. Every emit rebuilds even when nothing changed. Add `Equatable` (or
use Freezed):

```dart
class CartState extends Equatable {
  const CartState({required this.items, this.isSubmitting = false});
  final List<Item> items;
  final bool isSubmitting;

  @override
  List<Object?> get props => [items, isSubmitting];
}
```

**Bug 3: unguarded async emit and no error handling.** If the user leaves the
screen while `api.checkout` is running, `emit` throws `StateError` on a closed
cubit, and a network failure crashes with no state change.

```dart
Future<void> checkout() async {
  emit(CartState(items: state.items, isSubmitting: true));
  try {
    await api.checkout(state.items);
    if (isClosed) return;
    emit(const CartState(items: []));
  } catch (_) {
    if (isClosed) return;
    emit(CartState(items: state.items));
  }
}
```

</details>

---

### Exercise 2.3: Choose and justify the transformer

For each feature, name the transformer and say why in one line:

1. A username availability check as the user types
2. A "Place order" button
3. A queue of offline note edits syncing when connectivity returns
4. Loading analytics for three independent dashboard cards

<details>
<summary>Solution</summary>

1. `restartable()` plus a debounce. Only the latest username matters, and
   debouncing stops a request per keystroke.
2. `droppable()`. While an order is being placed, further taps must be
   ignored, or the user is charged twice.
3. `sequential()`. Edits must apply in the order they were made.
4. `concurrent()` (the default). The three requests are independent and can
   run at the same time.

</details>

---

### Exercise 2.4: Convert boolean soup

```dart
class ProfileState {
  bool loading;
  bool hasError;
  String? error;
  User? user;
  bool isEditing;
  bool isSaving;
}
```

Redesign it. State your choice of style and why.

<details>
<summary>Solution</summary>

The screen has two independent axes: how the profile loaded, and what the user
is doing with it. A single sealed hierarchy would duplicate the editing flags
in several cases, so use a sealed load state and keep the edit mode as a
separate small state.

```dart
sealed class ProfileState {
  const ProfileState();
}

final class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

final class ProfileFailed extends ProfileState {
  const ProfileFailed(this.message);
  final String message;
}

final class ProfileReady extends ProfileState {
  const ProfileReady({
    required this.user,
    this.mode = ProfileMode.viewing,
  });

  final User user;
  final ProfileMode mode;

  ProfileReady copyWith({User? user, ProfileMode? mode}) =>
      ProfileReady(user: user ?? this.user, mode: mode ?? this.mode);
}

enum ProfileMode { viewing, editing, saving }
```

Now "saving with no user" and "error with no message" cannot be written, and
the editing flow still has room to grow.

</details>

---

## PART 3: go_router

### Exercise 3.1: Design the routes

Write the `GoRouter` for: a public home page, a public product list, a product
detail with an optional `tab` query parameter, a private orders list, and a
private order detail. Signed out users must be sent to `/login` and returned
afterwards.

<details>
<summary>Solution</summary>

```dart
final router = GoRouter(
  initialLocation: '/',
  refreshListenable: auth,
  redirect: (context, state) {
    const publicPrefixes = ['/', '/products', '/login'];
    final location = state.matchedLocation;
    final isPublic = publicPrefixes.any(
      (p) => p == '/' ? location == '/' : location.startsWith(p),
    );

    if (!auth.signedIn && !isPublic) {
      return '/login?from=${Uri.encodeComponent(state.uri.toString())}';
    }
    if (auth.signedIn && location == '/login') return '/';
    return null;
  },
  errorBuilder: (context, state) => NotFoundPage(uri: state.uri),
  routes: [
    GoRoute(path: '/', builder: (c, s) => const HomePage()),
    GoRoute(path: '/login', builder: (c, s) => const LoginPage()),
    GoRoute(
      path: '/products',
      builder: (c, s) => const ProductsPage(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (c, s) => ProductPage(
            id: s.pathParameters['id']!,
            tab: s.uri.queryParameters['tab'],
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/orders',
      builder: (c, s) => const OrdersPage(),
      routes: [
        GoRoute(
          path: ':id',
          builder: (c, s) => OrderPage(id: s.pathParameters['id']!),
        ),
      ],
    ),
  ],
);
```

Note the child paths have no leading slash, so `/products/42` nests correctly
and a deep link builds the full back stack.

</details>

---

### Exercise 3.2: Build a bottom bar that keeps its place

Build a three tab app with `StatefulShellRoute.indexedStack` where the first
tab has a detail route, and tapping the active tab returns it to its root.

<details>
<summary>Solution</summary>

```dart
final router = GoRouter(
  initialLocation: '/home',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          ScaffoldWithNav(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (c, s) => const HomeTab(),
              routes: [
                GoRoute(
                  path: 'item/:id',
                  builder: (c, s) => ItemPage(id: s.pathParameters['id']!),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/search', builder: (c, s) => const SearchTab())],
        ),
        StatefulShellBranch(
          routes: [GoRoute(path: '/me', builder: (c, s) => const MeTab())],
        ),
      ],
    ),
  ],
);

class ScaffoldWithNav extends StatelessWidget {
  const ScaffoldWithNav({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) => navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        ),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}
```

</details>

---

### Exercise 3.3: Typed routes

Convert `/orders/:id?print=true` into a `go_router_builder` typed route and
show the navigation call.

<details>
<summary>Solution</summary>

```dart
// lib/routing/routes.dart
part 'routes.g.dart';

@TypedGoRoute<OrdersRoute>(
  path: '/orders',
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<OrderRoute>(path: ':id'),
  ],
)
class OrdersRoute extends GoRouteData with $OrdersRoute {
  const OrdersRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) => const OrdersPage();
}

class OrderRoute extends GoRouteData with $OrderRoute {
  const OrderRoute({required this.id, this.print});

  final String id;      // matches :id in the path
  final bool? print;    // not in the path, so it becomes ?print=

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      OrderPage(id: id, printMode: print ?? false);
}

// Navigation, checked by the compiler:
const OrderRoute(id: '883', print: true).go(context);
```

Remember the mixin is `$OrderRoute` with one dollar sign, and only the root
route carries the `@TypedGoRoute` annotation.

</details>

---

## PART 4: Platform Specific Code

### Exercise 4.1: Make it web safe

```dart
String describeDevice() {
  if (Platform.isIOS) return 'iPhone';
  if (Platform.isAndroid) return 'Android';
  return 'Desktop';
}
```

<details>
<summary>Solution</summary>

```dart
String describeDevice() {
  if (kIsWeb) return 'Browser';

  return switch (defaultTargetPlatform) {
    TargetPlatform.iOS => 'iPhone',
    TargetPlatform.android => 'Android',
    TargetPlatform.macOS => 'Mac',
    TargetPlatform.windows => 'Windows',
    TargetPlatform.linux => 'Linux',
    TargetPlatform.fuchsia => 'Fuchsia',
  };
}
```

`kIsWeb` is checked first because it is a compile time constant, so on web the
compiler removes the rest and `dart:io` is never referenced. Using
`defaultTargetPlatform` also makes this testable with
`debugDefaultTargetPlatformOverride`.

</details>

---

### Exercise 4.2: Write the channel

Write the Dart side of a `com.example.app/clipboard` channel with
`copy(String text)` and `Future<String?> paste()`, handling both failure types.

<details>
<summary>Solution</summary>

```dart
class NativeClipboard {
  static const MethodChannel _channel =
      MethodChannel('com.example.app/clipboard');

  Future<bool> copy(String text) async {
    try {
      await _channel.invokeMethod<void>('copy', {'text': text});
      return true;
    } on PlatformException catch (e) {
      debugPrint('Copy failed: ${e.code} ${e.message}');
      return false;
    } on MissingPluginException {
      return false;   // no native side on this platform
    }
  }

  Future<String?> paste() async {
    try {
      return await _channel.invokeMethod<String>('paste');
    } on PlatformException catch (e) {
      debugPrint('Paste failed: ${e.code}');
      return null;
    } on MissingPluginException {
      return null;
    }
  }
}
```

</details>

---

### Exercise 4.3: Conditional imports

Write the three files that give you an `AppLogger` writing to a file on
mobile and to the browser console on web.

<details>
<summary>Solution</summary>

```dart
// app_logger.dart
import 'app_logger_stub.dart'
    if (dart.library.io) 'app_logger_io.dart'
    if (dart.library.js_interop) 'app_logger_web.dart';

abstract class AppLogger {
  void log(String message);

  factory AppLogger() => createLogger();
}
```

```dart
// app_logger_stub.dart
import 'app_logger.dart';

AppLogger createLogger() => throw UnsupportedError('No logger for this platform');
```

```dart
// app_logger_io.dart
import 'dart:io';
import 'app_logger.dart';

AppLogger createLogger() => FileLogger();

class FileLogger implements AppLogger {
  @override
  void log(String message) {
    File('${Directory.systemTemp.path}/app.log')
        .writeAsStringSync('$message\n', mode: FileMode.append);
  }
}
```

```dart
// app_logger_web.dart
import 'package:web/web.dart' as web;
import 'app_logger.dart';

AppLogger createLogger() => ConsoleLogger();

class ConsoleLogger implements AppLogger {
  @override
  void log(String message) => web.console.log(message.toJS);
}
```

(`message.toJS` needs `import 'dart:js_interop';` in the web file.)

</details>

---

## PART 5: Freezed, Retrofit, JSON, Code Generation

### Exercise 5.1: Model the payload

Write the model for:

```json
{
  "order_id": "A-19",
  "placed_at": 1712345678,
  "status": "in_transit",
  "total": "49.99",
  "customer": { "id": "u1", "full_name": "Ada" },
  "items": [{ "sku": "S1", "qty": 2 }]
}
```

<details>
<summary>Solution</summary>

```dart
@freezed
abstract class Customer with _$Customer {
  const factory Customer({
    required String id,
    @JsonKey(name: 'full_name') required String fullName,
  }) = _Customer;

  factory Customer.fromJson(Map<String, dynamic> json) =>
      _$CustomerFromJson(json);
}

@freezed
abstract class OrderItem with _$OrderItem {
  const factory OrderItem({required String sku, required int qty}) = _OrderItem;

  factory OrderItem.fromJson(Map<String, dynamic> json) =>
      _$OrderItemFromJson(json);
}

enum OrderStatus {
  @JsonValue('pending') pending,
  @JsonValue('in_transit') inTransit,
  @JsonValue('delivered') delivered,
}

class EpochConverter implements JsonConverter<DateTime, int> {
  const EpochConverter();

  @override
  DateTime fromJson(int json) =>
      DateTime.fromMillisecondsSinceEpoch(json * 1000);

  @override
  int toJson(DateTime object) => object.millisecondsSinceEpoch ~/ 1000;
}

class StringToDoubleConverter implements JsonConverter<double, String> {
  const StringToDoubleConverter();

  @override
  double fromJson(String json) => double.tryParse(json) ?? 0;

  @override
  String toJson(double object) => object.toStringAsFixed(2);
}

@freezed
abstract class Order with _$Order {
  const factory Order({
    @JsonKey(name: 'order_id') required String orderId,
    @JsonKey(name: 'placed_at') @EpochConverter() required DateTime placedAt,
    @JsonKey(unknownEnumValue: OrderStatus.pending)
    required OrderStatus status,
    @StringToDoubleConverter() required double total,
    required Customer customer,
    @Default(<OrderItem>[]) List<OrderItem> items,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}
```

`unknownEnumValue` matters here: the backend will add a status one day, and
old app versions must not crash.

</details>

---

### Exercise 5.2: Fix the build

A teammate reports these errors. Give the cause and fix for each.

1. `Target of URI hasn't been generated: 'user.g.dart'`
2. `The name '_$UserFromJson' isn't defined`
3. `Missing mixin clause 'with $HomeRoute'`
4. `The name 'Headers' is defined in the libraries ...`
5. `The getter 'fullName' isn't defined for the class 'Person'`

<details>
<summary>Solution</summary>

1. `build_runner` has not run yet. Run `dart run build_runner build`.
2. Same cause, or the `part` filename does not match the file exactly
   (`user.dart` must declare `part 'user.g.dart';`).
3. `go_router_builder` generates `$HomeRoute`, not `_$HomeRoute`. Change the
   mixin name.
4. `dio` and `retrofit` both export `Headers`. Use
   `import 'package:dio/dio.dart' hide Headers;`.
5. The Freezed class is missing its private constructor. Add
   `const Person._();` before the factory.

</details>

---

### Exercise 5.3: Write the API client and repository

Declare a Retrofit client for `GET /orders?page=`, `GET /orders/{id}`, and
`POST /orders/{id}/cancel`, and a repository that maps errors.

<details>
<summary>Solution</summary>

```dart
@RestApi(baseUrl: 'https://api.example.com/v1')
abstract class OrderApi {
  factory OrderApi(Dio dio, {String baseUrl}) = _OrderApi;

  @GET('/orders')
  Future<List<Order>> getOrders({@Query('page') int page = 1});

  @GET('/orders/{id}')
  Future<Order> getOrder(@Path('id') String id);

  @POST('/orders/{id}/cancel')
  Future<Order> cancel(@Path('id') String id);
}

class OrderRepository {
  const OrderRepository(this._api);

  final OrderApi _api;

  Future<List<Order>> getOrders({int page = 1}) async {
    try {
      return await _api.getOrders(page: page);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<Order> cancel(String id) async {
    try {
      return await _api.cancel(id);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  AppFailure _map(DioException e) => switch (e.type) {
        DioExceptionType.connectionTimeout ||
        DioExceptionType.receiveTimeout ||
        DioExceptionType.sendTimeout => const AppFailure.timeout(),
        DioExceptionType.connectionError => const AppFailure.noConnection(),
        DioExceptionType.badResponse when e.response?.statusCode == 401 =>
          const AppFailure.unauthorised(),
        DioExceptionType.badResponse when e.response?.statusCode == 404 =>
          const AppFailure.notFound(),
        _ => const AppFailure.unknown(),
      };
}
```

</details>

---

## PART 6: Testing

### Exercise 6.1: Test the pure logic

`Discount.priceAfter(price, code)` gives 10 percent off for `SAVE10`, 50 naira
off for `FLAT50`, nothing for an unknown code, and throws for a negative price.
Write the tests.

<details>
<summary>Solution</summary>

```dart
void main() {
  group('Discount.priceAfter', () {
    test('SAVE10 takes ten percent off', () {
      expect(Discount.priceAfter(200, 'SAVE10'), closeTo(180, 0.001));
    });

    test('FLAT50 takes fifty off', () {
      expect(Discount.priceAfter(200, 'FLAT50'), closeTo(150, 0.001));
    });

    test('an unknown code changes nothing', () {
      expect(Discount.priceAfter(200, 'NOPE'), closeTo(200, 0.001));
    });

    test('never returns a negative price', () {
      expect(Discount.priceAfter(20, 'FLAT50'), 0);
    });

    test('throws on a negative price', () {
      expect(() => Discount.priceAfter(-1, 'SAVE10'), throwsArgumentError);
    });
  });
}
```

Note `closeTo` for doubles, and the extra edge case (a flat discount larger
than the price) that the description did not mention. Finding that case is the
point of the exercise.

</details>

---

### Exercise 6.2: Write the bloc tests

Write both `blocTest` cases for a `LoginCubit` that emits in progress then
succeeded or failed, plus one that verifies the repository was called.

<details>
<summary>Solution</summary>

```dart
class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository auth;

  setUp(() => auth = MockAuthRepository());

  blocTest<LoginCubit, LoginState>(
    'emits in progress then succeeded on valid credentials',
    setUp: () {
      when(() => auth.signIn(any(), any()))
          .thenAnswer((_) async => const User(id: '1', name: 'Ada'));
    },
    build: () => LoginCubit(auth),
    act: (cubit) => cubit.submit('ada@example.com', 'secret'),
    expect: () => [
      isA<LoginInProgress>(),
      isA<LoginSucceeded>().having((s) => s.user.name, 'user name', 'Ada'),
    ],
    verify: (_) => verify(() => auth.signIn('ada@example.com', 'secret')).called(1),
  );

  blocTest<LoginCubit, LoginState>(
    'emits in progress then failed on bad credentials',
    setUp: () {
      when(() => auth.signIn(any(), any()))
          .thenThrow(const AppFailure.unauthorised());
    },
    build: () => LoginCubit(auth),
    act: (cubit) => cubit.submit('ada@example.com', 'wrong'),
    expect: () => [isA<LoginInProgress>(), isA<LoginFailed>()],
  );
}
```

</details>

---

### Exercise 6.3: Write the widget test

A `SearchPage` shows "Start typing" initially, a spinner while loading, results
when loaded, and "Nothing found" when empty. Write the four widget tests using
a mocked cubit.

<details>
<summary>Solution</summary>

```dart
class MockSearchCubit extends MockCubit<SearchState> implements SearchCubit {}

void main() {
  late MockSearchCubit cubit;

  setUp(() => cubit = MockSearchCubit());

  Widget buildSubject() => MaterialApp(
        home: BlocProvider<SearchCubit>.value(
          value: cubit,
          child: const SearchPage(),
        ),
      );

  testWidgets('shows the hint before any search', (tester) async {
    when(() => cubit.state).thenReturn(const SearchState());
    await tester.pumpWidget(buildSubject());
    expect(find.text('Start typing'), findsOneWidget);
  });

  testWidgets('shows a spinner while loading', (tester) async {
    when(() => cubit.state)
        .thenReturn(const SearchState(status: SearchStatus.loading));
    await tester.pumpWidget(buildSubject());
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('shows one tile per result', (tester) async {
    when(() => cubit.state).thenReturn(const SearchState(
      status: SearchStatus.success,
      query: 'shoe',
      results: ['Running shoes', 'Canvas shoes'],
    ));
    await tester.pumpWidget(buildSubject());
    expect(find.byType(ListTile), findsNWidgets(2));
  });

  testWidgets('shows the empty message when nothing matched', (tester) async {
    when(() => cubit.state).thenReturn(const SearchState(
      status: SearchStatus.success,
      query: 'zzz',
      results: [],
    ));
    await tester.pumpWidget(buildSubject());
    expect(find.textContaining('Nothing'), findsOneWidget);
  });
}
```

Mocking the cubit means each screen state is tested directly, with no need to
drive the whole flow to reach it.

</details>

---

### Exercise 6.4: Test the guard

Write the widget test proving that a signed out user is redirected to `/login`
and that signing in moves them on.

<details>
<summary>Solution</summary>

```dart
testWidgets('signed out users are redirected, then released after sign in',
    (tester) async {
  final auth = AuthNotifier();
  final router = buildRouter(auth);

  await tester.pumpWidget(MaterialApp.router(routerConfig: router));
  await tester.pumpAndSettle();

  expect(find.byType(LoginPage), findsOneWidget);

  auth.setSignedIn(true);     // refreshListenable re-runs the redirect
  await tester.pumpAndSettle();

  expect(find.byType(ProfilePage), findsOneWidget);
});
```

Building the router from a function that takes the auth object is what makes
this testable. If the router is a global built from a singleton, it is not.

</details>

---

## Final Challenge: Ship One Feature Properly

Build a "Saved articles" feature end to end, using everything in this level:

1. A Freezed `Article` model with JSON and a Retrofit endpoint
2. A repository that maps `DioException` to a sealed `AppFailure`
3. A cubit with sealed states: initial, loading, loaded, empty, failed
4. A responsive screen: list on phones, list and detail on tablets
5. A go_router route `/saved` and `/saved/:id`, behind an auth guard
6. Tests: two cubit tests, two widget tests, one router test

<details>
<summary>Solution: the checklist to grade yourself against</summary>

You are done when all of these are true:

- `flutter analyze` reports no issues
- `dart run build_runner build` succeeds and no generated file is edited by hand
- No bloc imports `package:flutter/material.dart` or `dio`
- No widget catches a `DioException`
- Every state class carries exactly the data that state needs, and nothing else
- The detail widget is written once and used in both layouts
- `/saved/9` opened as a deep link while signed out lands on login and returns
  to `/saved/9` afterwards
- `flutter test` passes, and each test fails for the right reason when you
  deliberately break the code it covers

That last point is the real test of a test: break the code on purpose and
confirm the suite goes red. A test that passes no matter what is worse than
no test at all.

</details>

---

## Navigation

⬆️ **Back to:** [Level 19 README](../README.md)
📖 **Theory:** [Learning Path](../Theory/00-LearningPath.md)
