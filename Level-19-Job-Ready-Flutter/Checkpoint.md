# Level 19 Checkpoint

Answer from memory. Check yourself against the answers, then go back to the
lesson named beside anything you missed.

Score 40 or more out of 50 and you are ready to interview on this material.

---

## Part 1: Composition and Responsive UI (8 points)

1. Which two classes do you extend in everyday Flutter?
2. Why is a `const` widget class faster than a `_build...()` helper?
3. Name the three composition moves.
4. State the layout rule in one sentence.
5. What error does a `ListView` inside a `Column` throw, and what is the fix?
6. Why prefer `MediaQuery.sizeOf` over `MediaQuery.of(context).size`?
7. When do you use `LayoutBuilder` instead of `MediaQuery`?
8. Give the Material window size breakpoints.

<details>
<summary>Answers</summary>

1. `StatelessWidget` and `StatefulWidget`. (01a)
2. `const` gives the same instance every build, so Flutter's identity check
   passes and the subtree is skipped. A method returns a new object every time.
   (01b)
3. Wrap (takes a child), slots (named widget parameters), builder (hands data
   back to the caller). (01a)
4. Constraints go down, sizes go up, the parent sets the position. (01c)
5. "Vertical viewport was given unbounded height". Wrap the list in `Expanded`.
   (01c)
6. `MediaQuery.of` subscribes to every media query change, so the widget
   rebuilds when the keyboard opens. `sizeOf` subscribes to size only. (01c)
7. When you need the space **this widget** was given rather than the window,
   for example a card inside a sidebar. (01c)
8. 600, 840, 1200, 1600. (01c)

</details>

---

## Part 2: Cubit and Bloc (12 points)

9. Name the three parts of every Cubit.
10. Why does `state.items.add(x); emit(state);` not update the UI?
11. What line prevents "cannot emit after close"?
12. When do you use `BlocProvider.value` instead of `create`?
13. Give two reasons to choose Bloc over Cubit.
14. What does `restartable()` do, and where would you use it?
15. Which transformer stops a double tap placing two orders?
16. Why are sealed states better than `isLoading` plus `hasError`?
17. When is a single state class with a status enum the better choice?
18. What breaks if you forget a field in Equatable's `props`?
19. Where do snackbars and navigation belong, and why?
20. Name the three layers and what each must never import.

<details>
<summary>Answers</summary>

9. `extends Cubit<T>`, an initial state via `super(...)`, and methods that call
   `emit`. (02a)
10. It mutates the same object, so the new state is `==` to the old one and
    bloc skips the emit. (02a)
11. `if (isClosed) return;` after the `await`. (02a)
12. When sharing a cubit that already exists, for example passing it to a
    pushed route. `create` would build a second instance. (02a)
13. A record of what happened (analytics, undo, replay), and event
    transformers. (02a, 02b)
14. It cancels the in-flight handler when a new event arrives. Search as you
    type. (02b)
15. `droppable()`. (02b)
16. Impossible combinations cannot be written, and a `switch` over a sealed type
    is exhaustive, so a new state becomes a compile error rather than a bug.
    (02c)
17. When data must survive a status change: pull to refresh and pagination.
    (02c)
18. That field's changes are invisible: `==` returns true, the emit is skipped,
    and the UI never updates. (02c)
19. In `listener`, because `builder` can run several times for the same state.
    (02c, 02d)
20. Presentation (never imports dio or a database), business logic (never
    imports Flutter or `BuildContext`), data (never imports blocs or widgets).
    (02e)

</details>

---

## Part 3: go_router (8 points)

21. What is the difference between `go` and `push`?
22. Why must the router be built outside `build`?
23. What is wrong with a child path of `'/:id'`?
24. Which of path, query, and `extra` survives a deep link?
25. What does returning `null` from `redirect` mean?
26. Why do you need `refreshListenable`?
27. Why have an `unknown` auth status?
28. What does `StatefulShellRoute` give you that `ShellRoute` does not?

<details>
<summary>Answers</summary>

21. `go` rebuilds the stack to match the location; `push` layers one page on
    top and returns a `Future`. (03a)
22. Otherwise every rebuild creates a new router and resets navigation. (03a)
23. The leading slash makes it a top level route, so nesting and the deep link
    back stack break. (03a)
24. Path and query parameters survive. `extra` does not: it is null on a deep
    link, a web refresh, or after the process was killed. (03b)
25. Allow this navigation. (03d)
26. `redirect` only runs on navigation, so without it an expiring session does
    nothing until the user navigates. (03d)
27. So a cold start does not treat "not checked yet" as signed out and flash the
    login screen. (03d)
28. A separate `Navigator` and history per branch, so each tab keeps its stack
    and scroll position. (03c)

</details>

---

## Part 4: Platform Specific Code (7 points)

29. Why does `if (Platform.isIOS)` crash on web, and what is the fix?
30. When do you use `defaultTargetPlatform` instead of `Platform.isX`?
31. Name the three answers a Kotlin method call handler can give.
32. What is the difference between `PlatformException` and
    `MissingPluginException`?
33. Which types cross a method channel?
34. What must `onCancel` do on an `EventChannel`?
35. Write the conditional import line for io and web implementations.

<details>
<summary>Answers</summary>

29. `Platform` comes from `dart:io`, which does not exist on web. Guard with
    `!kIsWeb &&` first, because `kIsWeb` is a compile time constant. (04a)
30. For appearance and behaviour: it is web safe and overridable in tests. (04a)
31. `result.success(value)`, `result.error(code, message, details)`,
    `result.notImplemented()`. (04b)
32. `PlatformException` means the native side ran and reported an error.
    `MissingPluginException` means nothing was listening. (04b)
33. null, bool, int, double, String, Uint8List, List, Map. Your own classes do
    not. (04b)
34. Stop the producer and release the resource, or the sensor keeps running.
    (04c)
35. `import 'x_stub.dart' if (dart.library.io) 'x_io.dart' if (dart.library.js_interop) 'x_web.dart';`
    (04d)

</details>

---

## Part 5: Freezed, Retrofit, JSON, Codegen (8 points)

36. Which packages go in `dependencies` and which in `dev_dependencies`?
37. Why does your file show errors before you run the generator?
38. What replaced `--delete-conflicting-outputs`?
39. What exactly goes wrong without `explicitToJson: true`?
40. How do you stop a new backend enum value from crashing old app versions?
41. What are the two Freezed 3 class forms?
42. What does the private constructor `const X._();` unlock?
43. Why import dio with `hide Headers`?

<details>
<summary>Answers</summary>

36. Annotations (`json_annotation`, `freezed_annotation`, `retrofit`) ship, so
    they are dependencies. Generators (`build_runner`, `freezed`,
    `json_serializable`, `retrofit_generator`) are dev dependencies. (05a)
37. It refers to a `.g.dart` part file and `_$...` functions that do not exist
    yet. (05a)
38. Nothing: it was removed in build_runner 2.15 and is ignored. Use
    `dart run build_runner build`, and `clean` when outputs conflict. (05a)
39. Nested models are put into the map as objects, not maps. `jsonEncode` still
    works, but anything that inspects the map breaks. (05b)
40. `@JsonKey(unknownEnumValue: SomeEnum.fallback)`. (05b)
41. `abstract class X with _$X` for a data class, `sealed class X with _$X` for
    a union. (05c)
42. Custom getters and methods on the Freezed class. (05c)
43. Both dio and retrofit export a class called `Headers`. (05d)

</details>

---

## Part 6: Testing (7 points)

44. What is the difference between a fake and a mock?
45. When must you avoid `pumpAndSettle`?
46. Why prefer `find.byKey` over `find.text`?
47. How do you assert that a button is disabled?
48. Does `blocTest`'s `expect:` include the initial state?
49. What does `seed:` do?
50. What three lines make a widget test run at 1400x900 without leaking?

<details>
<summary>Answers</summary>

44. A fake is a simplified working implementation; a mock returns canned
    answers and records calls so you can verify interactions. (06a)
45. When something animates forever, such as a progress indicator: it times
    out. Pump a specific duration instead. (06b)
46. Text changes with copy edits and translations; a key is stable. (06b)
47. Read the widget and check `onPressed` is null. (06b)
48. No. Only the states emitted after it. (06d)
49. Starts the bloc from a given state so you can test a mid-flow behaviour
    directly. (06d)
50. ```dart
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;   // without this the logical size is not 1400x900
    addTearDown(tester.view.reset);
    ```
    (06b)

</details>

---

## Practical Checkpoint

Reading is not the same as doing. You have finished this level when, from a
blank project, you can:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   □ Build a screen that works at 360 and 1440 wide   │
│     without a single hard coded pixel size for       │
│     layout                                           │
│                                                      │
│   □ Write a cubit with sealed states, a repository,  │
│     and both a happy path and a failure path         │
│                                                      │
│   □ Set up go_router with a shell, a guard, and a    │
│     deep link that lands correctly while signed out  │
│                                                      │
│   □ Add a method channel and read a value from       │
│     native code on Android or iOS                    │
│                                                      │
│   □ Generate a Freezed model with JSON and a         │
│     Retrofit client, from an empty file, without     │
│     looking anything up                              │
│                                                      │
│   □ Write four tests: a unit test, a bloc test, a    │
│     widget test, and a router guard test, and watch  │
│     each one fail when you break the code            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

The last box is the important one. Any test that cannot fail is not a test.

---

## Navigation

⬆️ **Back to:** [Level 19 README](README.md)
📋 **Interview prep:** [Interview Questions](InterviewQuestions.md)
⚠️ **Error reference:** [Common Mistakes](CommonMistakes.md)
