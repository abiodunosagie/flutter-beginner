# Level 19: Interview Questions And Answers

The six topics from the job advert, turned into the questions interviewers
actually ask, with answers you can say out loud.

Read the question, answer it aloud from memory, **then** open the answer. If
your version covers the same ground in your own words, you know it. Reciting a
paragraph you memorised sounds memorised; explaining the same idea in your own
words sounds like experience.

---

## 1. Widget Composition and Responsive UI

**Q: Why does Flutter favour composition over inheritance?**

<details>
<summary>Answer</summary>

Widgets are immutable configuration, not mutable UI objects, and the UI is a
tree. Combining small widgets by nesting keeps each one single purpose and
independently testable. Inheritance would push behaviour down a class
hierarchy, and the moment two variations meet you get a class explosion:
primary, danger, loading, wide, and then primary-wide-loading. With composition
those variations are parameters. Flutter proves the point itself: `Container`
is a composition of `Padding`, `ColoredBox`, and `Align` rather than a subclass
of any of them. In practice I only ever extend `StatelessWidget` or
`StatefulWidget`.

</details>

---

**Q: How do you keep a complex screen fast?**

<details>
<summary>Answer</summary>

Four habits. First, extract widget classes rather than `_build...` helper
methods, because a `const` widget is the same instance every build, so Flutter
skips the subtree entirely, while a method creates a new object each time.
Second, push `setState` as far down the tree as possible, so a counter does not
rebuild a 300 line page. Third, pass content in as a `child` so it survives a
parent's rebuild, which is exactly why `AnimatedBuilder` has a `child`
parameter. Fourth, use `ListView.builder` for anything long, and avoid
`shrinkWrap: true`, which measures every child. If it still feels slow I open
DevTools and look at the rebuild counts and the timeline rather than guessing.

</details>

---

**Q: `MediaQuery.of(context).size` or `MediaQuery.sizeOf(context)`?**

<details>
<summary>Answer</summary>

`sizeOf`. `MediaQuery.of` subscribes the widget to every media query change, so
it rebuilds when the keyboard opens or the text scale changes, even though it
only wanted the width. The focused accessors, `sizeOf`, `paddingOf`,
`viewInsetsOf`, `orientationOf`, `textScalerOf`, subscribe to one property.

And for layout inside a widget, I usually want `LayoutBuilder`'s
`constraints.maxWidth` instead, because that is the space the widget was
actually given. A card in a 320 pixel sidebar on a 1440 pixel desktop has 320
to work with, not 1440.

</details>

---

**Q: What is the difference between responsive and adaptive?**

<details>
<summary>Answer</summary>

Responsive is the same layout stretching: two columns becoming four, padding
16 becoming 32. Adaptive is a genuinely different layout or control for a
different context: a bottom navigation bar becoming a navigation rail, a
pushed detail page becoming a side by side split, a Material switch becoming a
Cupertino one on iOS.

Real apps use both. I decide by width using the Material window size classes,
600, 840, 1200, 1600, and I keep those numbers in one helper rather than
scattered as magic numbers. I also cap content width on desktop, because text
that stretches across a 27 inch monitor is unreadable.

</details>

---

## 2. Cubit, Bloc, and State Management

**Q: Cubit or Bloc?**

<details>
<summary>Answer</summary>

Cubit by default: it is the same architecture with less ceremony, plain methods
instead of event classes, and it tests identically.

I move to Bloc when I need what events give me: a record of what happened for
analytics or undo, or event transformers. Transformers are the real reason.
A search box needs `restartable()` so an old slow response cannot overwrite a
newer one, plus a debounce so I am not firing a request per keystroke. A submit
button needs `droppable()` so a double tap does not place two orders. An
offline edit queue needs `sequential()`. You cannot express any of that with a
plain method call.

</details>

---

**Q: How do you design bloc state?**

<details>
<summary>Answer</summary>

So that impossible states cannot be written. The beginner version has
`isLoading`, `hasError`, `errorMessage`, and a list, which is sixteen
combinations for about four real situations, and the UI ends up as a pile of
`if`s whose order silently changes behaviour.

I use sealed classes: `Loading`, `Loaded(products)`, `Failed(message)`. A
failure always carries a message, a success always carries data, and because
the type is sealed, `switch` is exhaustive, so adding a state later turns every
unhandled case into a compile error.

The exception is when data must survive a status change, like pull to refresh
or pagination, where I keep showing the old list while loading. There a single
state class with a status enum and `copyWith` is cleaner. Both are correct; I
say which I picked and why.

</details>

---

**Q: A colleague says `BlocBuilder` is not updating. How do you debug it?**

<details>
<summary>Answer</summary>

Almost always one of three things.

One: the state was mutated instead of replaced. `state.items.add(x)` then
`emit(state)` passes an object identical to the current state, and bloc skips
identical states, so nothing rebuilds. The fix is to emit a new object.

Two: the state class has no value equality, or `Equatable`'s `props` is missing
the field that changed, so `==` returns true and the emit is skipped. That one
is nasty because it only breaks for that one field.

Three: `buildWhen` or a `BlocSelector` is filtering the change out.

I confirm which by setting a `BlocObserver` and printing every change, so I can
see whether the emit even happened.

</details>

---

**Q: Where do you put a snackbar or a navigation call?**

<details>
<summary>Answer</summary>

In `BlocListener`, never in `builder`. `builder` can run many times for the
same state, on a rotate, a theme change, or a parent rebuild, so a snackbar
there repeats. `listener` fires once per state change, which is what a side
effect needs. If a screen needs both, `BlocConsumer`.

</details>

---

**Q: Walk me through your app architecture.**

<details>
<summary>Answer</summary>

Three layers with one way dependencies. Widgets render state and add events.
Blocs hold decisions and depend on repository interfaces, never on Dio, Flutter,
or `BuildContext`. Repositories own the data sources, decide caching, and map
transport errors into a small sealed set of app failures that carry user
friendly messages.

Folders are feature first, so a feature contains its own data, domain, and
presentation. Dependencies are provided down the tree with `RepositoryProvider`
and `BlocProvider`, which means scoping and disposal are automatic and every
bloc can be constructed in a test with a fake repository.

The five second check for a layering problem is to open a bloc file and read
its imports. If `material.dart` or `dio` is in there, something leaked.

</details>

---

## 3. go_router

**Q: Why go_router instead of Navigator?**

<details>
<summary>Answer</summary>

Two reasons that cost real money to retrofit later: deep links and central
guards.

With go_router the URL is the state, so opening `/products/42/reviews` from a
notification builds the whole stack, and back walks up through the product and
the list. A single `Navigator.push` drops the user on one page with a back
button that closes the app.

The second is that one `redirect` function protects every private route,
instead of an auth check copied into thirty screens. On top of that you get
real browser URLs on web, and `StatefulShellRoute` for tabs that keep their own
history.

</details>

---

**Q: `go` or `push`?**

<details>
<summary>Answer</summary>

`go` replaces the stack so it matches the target location, so back follows the
path hierarchy. `push` adds one page on top of whatever is already there.

I use `go` for switching sections, for after login, and for anything where the
user should not be able to go back into the previous flow. I use `push` for
details layered on the current context and for anything that returns a value,
because `push` returns a `Future` that `context.pop(result)` completes.

</details>

---

**Q: How do you protect routes?**

<details>
<summary>Answer</summary>

A top level `redirect` that returns `null` to allow and a path to send
elsewhere, plus `refreshListenable` so it re-runs when auth changes rather than
only on navigation. Without `refreshListenable`, a token expiring while the
user reads a screen does nothing, because nothing navigated.

Two details I always include. First, an `unknown` auth status while the stored
session is being checked, so the app holds on the splash instead of flashing
the login screen. Second, I put the intended location in `?from=` and send the
user there after signing in, so a shared link still lands where it meant to.

When auth lives in a bloc I bridge its stream to a `Listenable` with a small
`GoRouterRefreshStream` class, because the router needs a `Listenable` and a
bloc exposes a `Stream`.

</details>

---

**Q: How would you build Instagram's bottom bar?**

<details>
<summary>Answer</summary>

`StatefulShellRoute.indexedStack` with one `StatefulShellBranch` per tab, so
each tab has its own `Navigator` and its own history. Scroll into the feed, open
a profile, switch to messages, come back, and you are still on that profile at
the same scroll position.

`onDestinationSelected` calls `navigationShell.goBranch(index, initialLocation:
index == navigationShell.currentIndex)`, which gives the "tap the active tab to
return to its root" behaviour users expect. Anything that must be full screen,
like a media viewer or login, goes outside the shell or gets
`parentNavigatorKey: rootNavigatorKey` so no bottom bar shows.

</details>

---

## 4. Platform Specific Code

**Q: How do you write code that differs per platform?**

<details>
<summary>Answer</summary>

I separate two questions. "What should this look like?" is answered by
`defaultTargetPlatform`, which is web safe and can be overridden in tests.
"What can this device do?" is answered by `Platform.isX`, always guarded by
`kIsWeb` first, because `Platform` comes from `dart:io` which does not exist on
web. The order matters: `kIsWeb` is a compile time constant, so the compiler
removes the rest of the expression on web.

I keep those checks in one small file and expose them named by capability:
`supportsBiometrics`, `supportsFileSystem`, not `isIOS`. The call sites then
read correctly the day desktop gains the capability.

For anything that imports `dart:io` or `dart:js_interop`, I use conditional
imports: one public file that imports a stub `if (dart.library.io)` the io
implementation `if (dart.library.js_interop)` the web implementation. That is
how one `TokenStore` writes to a file on mobile and localStorage on web.

</details>

---

**Q: Explain method channels.**

<details>
<summary>Answer</summary>

A named pipe between Dart and native. Dart calls `invokeMethod('name', args)`
on a `MethodChannel` with a reverse domain name, and the native side registers
a handler on a channel with the identical string. On Android that is in
`configureFlutterEngine` in `MainActivity.kt`, answering with
`result.success`, `result.error`, or `result.notImplemented`. On iOS it is in
`AppDelegate.swift` with `result(value)`, `result(FlutterError(...))`, or
`result(FlutterMethodNotImplemented)`.

Everything is asynchronous, and only primitives, `List`, `Map`, and `Uint8List`
cross, so your own classes have to become maps. Two failures to handle
separately: `PlatformException` means the native code ran and reported an
error, `MissingPluginException` means nothing was listening, which is what you
get on web or after a typo.

For a stream of values I use an `EventChannel` and make sure `onCancel`
actually stops the producer, otherwise the sensor keeps running and drains the
battery. Once there are more than a couple of methods or the data has
structure, I switch to Pigeon so both sides are generated from one definition
and a mismatch becomes a compile error.

</details>

---

**Q: What breaks when you add web support?**

<details>
<summary>Answer</summary>

`dart:io` first: `File`, `Directory`, `Platform`, `HttpClient`. Then method
channels, because there is no native side. Then any mobile only plugin, which
you can check on the plugin's pub.dev page. Then CORS, because the browser
blocks cross origin requests your mobile app made happily, and that is fixed on
the server with the right headers, never in Dart.

Beyond that, Flutter web paints a canvas rather than producing DOM elements, so
there is no CSS and search engines see very little. I would ship Flutter web for
an internal dashboard or a logged in app, not for a marketing site or a blog.

</details>

---

## 5. Freezed, Retrofit, JSON, and Code Generation

**Q: Why use code generation at all?**

<details>
<summary>Answer</summary>

Because the code it replaces is the code humans get wrong. A four field model
by hand needs `fromJson`, `toJson`, `copyWith`, `==`, `hashCode`, and
`toString`, and adding a fifth field means remembering six places. Missing one
gives a silent bug: a `copyWith` that drops a value, or an `==` that says two
different objects are equal, which in bloc means the UI silently stops
updating.

Generated, the same class is fifteen lines and cannot drift. The cost is a
build step, which is `dart run build_runner watch` while developing.

</details>

---

**Q: What does Freezed give you, and what changed in version 3?**

<details>
<summary>Answer</summary>

It generates the immutable class: `copyWith`, value equality, `toString`, and
optionally JSON. More importantly it gives unions: one sealed type with several
named shapes, which is the ideal way to model bloc state.

In Freezed 3 the syntax changed: a data class is `abstract class X with _$X` and
a union is `sealed class X with _$X`. Older tutorials show plain `class X with
_$X`, which no longer builds. To add your own getters you need the private
constructor `const X._();`, and that missing line is the most common confusing
error.

For reading a union I prefer Dart's `switch` pattern matching over the
generated `when`, because it is a language feature, it supports guards, and
being sealed makes it exhaustive. The generated callbacks still exist, so older
code keeps compiling.

</details>

---

**Q: What is the most common json_serializable bug you have hit?**

<details>
<summary>Answer</summary>

`explicitToJson`. It defaults to false, so a nested model field is put into the
map as the object itself rather than a nested map. `jsonEncode` still works,
because dart:convert calls `toJson` dynamically, so it looks fine until
something inspects the map: writing to a NoSQL SDK, comparing maps in a test,
or reading `map['address']['city']`. I set `explicit_to_json: true` in
`build.yaml` on every project.

The other one worth mentioning is enums. Without
`@JsonKey(unknownEnumValue: ...)`, the day the backend adds a new status, every
app version already on phones starts throwing. With it, old clients degrade
gracefully.

</details>

---

**Q: How do you structure an API layer with Retrofit?**

<details>
<summary>Answer</summary>

Retrofit describes the shape of the API: an abstract class with `@RestApi` and
one annotated method per endpoint, so the whole surface is readable in one file
and the generator writes the Dio calls and the JSON decoding.

Dio owns policy: base URL per environment, timeouts, logging, and an
interceptor that attaches the auth token and refreshes it on a 401. Auth
belongs there, not as a `@Header` parameter on forty methods.

Above that, the repository is the only place that knows `DioException` exists.
It maps timeouts, connection errors, 401 and 404 into a small sealed set of app
failures with user facing messages, so no widget ever shows a raw error. And
because the API is an abstract class, tests mock it in one line.

One practical gotcha: dio and retrofit both export `Headers`, so you import dio
with `hide Headers`.

</details>

---

## 6. Testing

**Q: How do you test a Flutter app?**

<details>
<summary>Answer</summary>

Three layers, weighted like a pyramid.

Unit tests for pure logic and for repositories, where I mock the API client and
assert that each transport error maps to the right domain failure.

`bloc_test` for every cubit and bloc, always a happy path and a failure path.
`seed` lets me start mid flow instead of replaying five actions, and
`isA<T>().having(...)` lets me assert on one field when the state contains
something unpredictable like a generated id.

Widget tests for screens, with the bloc mocked so I can render each state
directly, plus golden tests for anything visually delicate.

Then a handful of integration tests on a device for the flows that lose money
if they break, running against a fake backend so CI is deterministic. Unit and
widget tests run on every push; integration tests run nightly on an emulator.

</details>

---

**Q: What do you not test?**

<details>
<summary>Answer</summary>

The framework, generated code, and one line getters. Coverage is a signal, not
a target: I would rather have seventy percent that covers pricing, auth, and
error handling than a hundred percent full of assertions that cannot fail.

The rule I actually enforce is that every bug becomes a failing test before it
becomes a fix, so the same bug cannot come back.

</details>

---

**Q: What is the difference between `pump` and `pumpAndSettle`?**

<details>
<summary>Answer</summary>

`pump` renders one frame. `pumpAndSettle` keeps pumping until no more frames
are scheduled, so it waits for animations to finish. I use `pump` after a
`setState` or a tap, and `pumpAndSettle` after navigation, a dialog, or a
snackbar.

The trap is that `pumpAndSettle` times out on an animation that never ends,
like a `CircularProgressIndicator`, so around a loading state I pump a specific
duration instead.

</details>

---

**Q: How do you test something that depends on the screen size or the platform?**

<details>
<summary>Answer</summary>

For size, set `tester.view.physicalSize` and `devicePixelRatio`, and register
`addTearDown(tester.view.reset)` so the fake size does not leak into later
tests. For platform, set `debugDefaultTargetPlatformOverride` and reset it in a
tear down. That is how both branches of an adaptive UI get tested on one
machine.

For platform channels I install a mock handler with
`TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler`,
and clear it in `tearDown`. That means native integrations are still covered in
CI with no device attached.

</details>

---

## Questions To Ask Them

Interviews go both ways, and good questions make you memorable.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • What state management is the codebase on, and    │
│     is it consistent across features?                │
│                                                      │
│   • Do you generate code (Freezed, Retrofit), and    │
│     are generated files committed or built in CI?    │
│                                                      │
│   • What does your test suite look like today, and   │
│     what runs on every pull request?                 │
│                                                      │
│   • Do you ship web and desktop, or mobile only?     │
│                                                      │
│   • How much native code does the team maintain,     │
│     and is it channels or Pigeon?                    │
│                                                      │
│   • How do you handle releases: CI/CD, staged        │
│     rollouts, feature flags?                         │
│                                                      │
│   • What would my first month look like?             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## The Day Before

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   1. Re-read CommonMistakes.md. Interviewers love    │
│      asking "what went wrong and how did you fix     │
│      it", and those are real answers.                │
│                                                      │
│   2. Say four answers aloud: architecture, Cubit vs  │
│      Bloc, go vs push, how you test. Aloud, not      │
│      in your head.                                   │
│                                                      │
│   3. Open one of your own projects and be ready to   │
│      point at a bloc, a repository, and a test.      │
│                                                      │
│   4. If you do not know something, say so, then say  │
│      how you would find out. That answer scores      │
│      better than a confident wrong one.              │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Navigation

⬆️ **Back to:** [Level 19 README](README.md)
📖 **Theory:** [Learning Path](Theory/00-LearningPath.md)
⚠️ **Also read:** [Common Mistakes](CommonMistakes.md)
