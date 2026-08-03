# Level 19: Common Mistakes

Every error in this file was produced on purpose against Flutter 3.38.4 and
the package versions this level pins, so the messages are the real ones.

---

## Composition and Responsive UI

### 1. Splitting a build method into helper methods and expecting it to be faster

```dart
Widget _buildHeader() => const Padding(...);   // still rebuilds every time
```

**Why:** a method call creates a new object on every build, so Flutter's
identity check always fails. Only a `const` widget class can be skipped.

**Fix:** make it a `class Header extends StatelessWidget` with a `const`
constructor.

---

### 2. "Vertical viewport was given unbounded height"

```dart
Column(children: [Text('Title'), ListView(...)])
```

**Why:** a `Column` gives children unbounded height, and a `ListView` wants all
the height it can get, so it asks for infinity.

**Fix:** `Expanded(child: ListView(...))`, or `shrinkWrap: true` for a genuinely
short list, or move the whole screen to slivers.

---

### 3. "Incorrect use of ParentDataWidget"

**Why:** `Expanded` or `Flexible` is not a direct child of a `Row`, `Column`,
or `Flex`. A `Container` or `Stack` in between causes this.

**Fix:** move the `Expanded` so its parent is the flex widget.

---

### 4. Layout breaks for users with large fonts

**Why:** fixed `height:` values on anything containing text, plus disabling
text scaling.

**Fix:** let content grow (padding instead of fixed heights), and if you must
protect a tight layout, clamp with
`MediaQuery.textScalerOf(context).clamp(minScaleFactor: 1.0, maxScaleFactor: 1.4)`
rather than switching scaling off.

---

### 5. Deciding layout from `MediaQuery` when the widget is in a panel

**Why:** `MediaQuery.sizeOf` reports the window, not the space this widget was
given, so a card in a sidebar thinks it has 1440 pixels.

**Fix:** `LayoutBuilder` and `constraints.maxWidth`.

---

## Cubit and Bloc

### 6. The UI does not update after an emit

```dart
state.items.add(item);
emit(state);            // skipped: identical to the current state
```

**Fix:** emit a new object: `emit(CartState(items: [...state.items, item]))`.

---

### 7. Every emit rebuilds, even when nothing changed

**Why:** the state class has no value equality, so bloc compares by identity.

**Fix:** extend `Equatable` and list every field in `props`, or use Freezed.

---

### 8. One field changes and the UI ignores it

**Why:** that field is missing from `Equatable`'s `props`, so `==` says the
states are equal and the emit is skipped. This is the sneakiest bloc bug there
is.

**Fix:** when you add a field, add it to `props` in the same keystroke.

---

### 9. "Bad state: Cannot emit new states after calling close"

**Why:** an async operation finished after the user left the screen.

**Fix:** `if (isClosed) return;` immediately after every `await`, before the
`emit`.

---

### 10. "Error: This widget has been unmounted" / using `watch` in a callback

```dart
onPressed: () => context.watch<CartCubit>().clear(),   // throws
```

**Fix:** `read` inside callbacks, `watch` or `BlocBuilder` inside `build`.

---

### 11. "Could not find the correct Provider above this widget"

**Why:** you looked for the bloc using a `context` that is above the
`BlocProvider`, or you pushed a route, and routes are built by the `Navigator`
which lives above your page.

**Fix:** put the consumer in its own widget (or a `Builder`), and wrap pushed
routes in `BlocProvider.value(value: context.read<TheBloc>())`.

---

### 12. Snackbars appearing twice

**Why:** they are being shown from `builder`, which can run many times for the
same state.

**Fix:** move them to `BlocListener` / the `listener` of a `BlocConsumer`.

---

### 13. A search box firing a request per keystroke, with results arriving out of order

**Fix:** `transformer: restartable()` so older requests are cancelled, plus a
debounce transformer so requests only fire after a pause.

---

## go_router

### 14. The app randomly jumps back to the first screen

**Why:** the `GoRouter` is being constructed inside `build`, so every rebuild
creates a fresh router with fresh navigation state.

**Fix:** build the router once, outside `build`.

---

### 15. Nesting silently does not work

```dart
GoRoute(path: '/orders', routes: [GoRoute(path: '/:id')])   // wrong
```

**Why:** a leading slash makes the child a top level route.

**Fix:** `path: ':id'`.

---

### 16. "Too many redirects"

**Why:** a redirect rule that never returns `null`, usually sending signed out
users to `/login` without excluding `/login` itself.

**Fix:** exclude the destination from the rule that redirects to it.

---

### 17. The login screen flashes on every cold start

**Why:** the app treats "session not checked yet" as "signed out".

**Fix:** add an `unknown` auth status and hold on the splash route until the
check finishes.

---

### 18. Logging out does not kick the user off the private screen

**Why:** `redirect` only runs on navigation, and nothing navigated.

**Fix:** `refreshListenable`, so the router re-evaluates when auth changes.

---

### 19. The bottom bar appears on the login or media screen

**Fix:** declare that route outside the shell, or give it
`parentNavigatorKey: rootNavigatorKey`.

---

### 20. "Missing mixin clause `with $HomeRoute`"

**Why:** `go_router_builder` generates `$HomeRoute`, with a single dollar sign.
Freezed uses `_$`, and the two get confused.

**Fix:** `class HomeRoute extends GoRouteData with $HomeRoute`.

---

### 21. A pushed page crashes on a deep link

```dart
final cart = state.extra! as Cart;   // null on a deep link or web refresh
```

**Fix:** read `extra` as nullable and load from the path when it is missing.

---

## Platform Specific Code

### 22. "Unsupported operation: Platform._operatingSystem" on web

```dart
if (Platform.isIOS) { ... }
```

**Fix:** `if (!kIsWeb && Platform.isIOS)`. The order matters, because `kIsWeb`
is a compile time constant that lets the compiler drop the rest.

---

### 23. `MissingPluginException` after editing native code

**Why:** hot reload and hot restart do not rebuild the native side.

**Fix:** stop the app and run it again. If it persists, check the channel name
string on both sides character by character.

---

### 24. Random crashes when answering a method call

**Why:** on Android, `result.success(...)` was called from a background thread.

**Fix:** wrap it in `runOnUiThread { ... }`.

---

### 25. The GPS or sensor keeps running after the user leaves

**Why:** the `EventChannel`'s `onCancel` does not actually stop the producer,
or the Dart side never cancelled its subscription.

**Fix:** cancel the subscription in `dispose`/`close`, and make `onCancel`
invalidate the timer or remove the listener.

---

### 26. The API works on Android and is blocked in the browser

**Why:** CORS.

**Fix:** on the server, with the right `Access-Control-Allow-Origin` headers.
Nothing in Dart can bypass it, and disabling browser security is a debugging
hack, not a fix.

---

### 27. A deployed web app 404s when you refresh a deep page

**Fix:** `usePathUrlStrategy()` plus a host rewrite of all unknown paths to
`/index.html`.

---

## Code Generation

### 28. "Target of URI hasn't been generated" / "_$XFromJson isn't defined"

**Why:** you have not run the generator yet, or the `part` filename does not
match the source file exactly.

**Fix:** `dart run build_runner build`, and check `part 'user.g.dart';` against
`user.dart`.

---

### 29. Following a tutorial that says `--delete-conflicting-outputs`

**Verified:** on build_runner 2.15 that flag is removed and produces
"These options have been removed and were ignored".

**Fix:** `dart run build_runner build`, and `dart run build_runner clean` first
if outputs are in a bad state.

---

### 30. Freezed code from an older article will not build

**Why:** Freezed 3 requires `abstract class X with _$X` for data classes and
`sealed class X with _$X` for unions.

---

### 31. "The getter 'fullName' isn't defined for the class 'Person'"

**Why:** the Freezed class is missing its private constructor.

**Fix:** add `const Person._();` above the factory.

---

### 32. `invalid_annotation_target` warnings on `@Default` and `@JsonKey`

**Fix:** add to `analysis_options.yaml`:

```yaml
analyzer:
  errors:
    invalid_annotation_target: ignore
```

---

### 33. Nested objects serialise as `Instance of 'Address'`

**Why:** `explicitToJson` defaults to false.

**Fix:** `@JsonSerializable(explicitToJson: true)`, or `explicit_to_json: true`
in `build.yaml`.

---

### 34. The app crashes the day the backend adds an enum value

**Fix:** `@JsonKey(unknownEnumValue: Role.guest)`.

---

### 35. "The name 'Headers' is defined in the libraries dio and retrofit"

**Fix:** `import 'package:dio/dio.dart' hide Headers;`

---

### 36. Generators in the wrong dependency section

**Why:** `freezed`, `json_serializable`, `retrofit_generator`, and
`build_runner` are dev dependencies. Only the annotation packages ship.

---

## Testing

### 37. A test passes but nothing is actually asserted

**Why:** a missing `await` or `async`, so the future had not completed.

---

### 38. "Passes alone, fails in the suite"

**Why:** shared mutable state between tests, or a leaked override
(`tester.view.physicalSize`, `debugDefaultTargetPlatformOverride`, a mock
channel handler).

**Fix:** create objects in `setUp`, and always pair an override with
`addTearDown`.

---

### 39. "pumpAndSettle timed out"

**Why:** something animates forever, usually a progress indicator.

**Fix:** `await tester.pump(const Duration(milliseconds: 300));` instead.

---

### 40. "No Directionality widget found"

**Fix:** wrap the widget under test in `MaterialApp` (or at least
`Directionality`).

---

### 41. "Found 0 widgets with text 'Item 90'"

**Why:** the list is lazy and that row was never built.

**Fix:** `await tester.scrollUntilVisible(find.text('Item 90'), 200);`

---

### 42. A `blocTest` fails and the diff includes the initial state

**Why:** `expect:` lists only the states emitted **after** the initial one.

---

### 43. "A Timer is still pending" at the end of a widget test

**Why:** a real leak: a timer, animation controller, or subscription was not
disposed. The test caught a bug.

**Fix:** dispose it, do not silence the test.

---

### 44. Golden tests fail on CI but pass locally

**Why:** font rendering differs between machines.

**Fix:** run goldens in one environment, and never run `--update-goldens`
without looking at the diff image first.

---

## Navigation

⬆️ **Back to:** [Level 19 README](README.md)
📋 **Also read:** [Interview Questions](InterviewQuestions.md)
✅ **Then:** [Checkpoint](Checkpoint.md)
