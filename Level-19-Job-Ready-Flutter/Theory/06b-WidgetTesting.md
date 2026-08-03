# Widget Testing: Driving The UI Without A Device

## The Big Idea In One Sentence

> `testWidgets` builds your widget in a fake screen, lets you tap and type, and lets you assert what is on screen, all in milliseconds with no emulator.

---

## Your First Widget Test

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('counter increments when the button is tapped', (tester) async {
    // 1. Build the widget
    await tester.pumpWidget(const MaterialApp(home: CounterPage()));

    // 2. Assert the starting state
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // 3. Interact
    await tester.tap(find.byIcon(Icons.add));

    // 4. Rebuild after the interaction
    await tester.pump();

    // 5. Assert the new state
    expect(find.text('1'), findsOneWidget);
  });
}
```

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   THE FOUR VERBS                                     │
│                                                      │
│   pumpWidget(widget)   build this widget tree        │
│   find.something       locate widgets                │
│   tester.tap/enterText interact                      │
│   pump / pumpAndSettle advance time and rebuild      │
│                                                      │
│   Every widget you want on screen must be under a    │
│   MaterialApp (or at least a Directionality), or     │
│   you get "No Directionality widget found".          │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## pump vs pumpAndSettle

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   await tester.pump()                                │
│      render ONE frame                                │
│                                                      │
│   await tester.pump(Duration(milliseconds: 300))     │
│      advance the clock, render one frame             │
│                                                      │
│   await tester.pumpAndSettle()                       │
│      keep pumping until no frames are scheduled      │
│      (all animations finished)                       │
│                                                      │
│   Use pump() after a setState or a tap.              │
│   Use pumpAndSettle() after navigation, a dialog,    │
│   a snackbar, or any animation.                      │
│                                                      │
│   pumpAndSettle TIMES OUT on an infinite animation:  │
│   a CircularProgressIndicator that never stops       │
│   makes it fail after 10 minutes of virtual time.    │
│   Use pump(Duration(...)) there instead.             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Finders

```dart
find.text('Submit');                 // exact text
find.textContaining('Sub');
find.byType(ElevatedButton);         // widget type
find.byIcon(Icons.delete);
find.byKey(const Key('email_field'));
find.byTooltip('Add item');
find.byWidgetPredicate((w) => w is Text && w.style?.fontSize == 24);

// Scope a search to a subtree: the "Delete" inside THIS card
find.descendant(
  of: find.byKey(const Key('order_42')),
  matching: find.text('Delete'),
);

find.ancestor(of: find.text('Delete'), matching: find.byType(Card));
```

Matchers for the result:

```dart
expect(finder, findsOneWidget);
expect(finder, findsNothing);
expect(finder, findsWidgets);        // one or more
expect(finder, findsNWidgets(3));
expect(finder, findsAtLeastNWidgets(2));
```

**Prefer keys for anything you will interact with.** `find.text('Delete')` breaks when the copy changes or is translated; `find.byKey(const Key('delete_button'))` does not.

---

## Interactions

```dart
await tester.tap(find.byKey(const Key('save')));
await tester.longPress(find.byType(ListTile).first);
await tester.doubleTap(find.byType(Image));

await tester.enterText(find.byKey(const Key('email')), 'ada@example.com');
await tester.testTextInput.receiveAction(TextInputAction.done);

await tester.drag(find.byType(ListView), const Offset(0, -300));  // scroll up
await tester.fling(find.byType(ListView), const Offset(0, -400), 1000);
await tester.scrollUntilVisible(find.text('Item 90'), 200);

// Access the actual widget instance to check its properties
final button = tester.widget<ElevatedButton>(find.byType(ElevatedButton));
expect(button.onPressed, isNull);      // proves the button is disabled
```

The last one matters: to assert "the button is disabled" you check `onPressed == null`, not the colour.

---

## Testing A Widget That Needs A Bloc

Real widgets have dependencies. Provide fakes at the test's root.

```dart
class MockCartCubit extends MockCubit<CartState> implements CartCubit {}

void main() {
  late MockCartCubit cubit;

  setUp(() {
    cubit = MockCartCubit();
  });

  Widget buildSubject() {
    return MaterialApp(
      home: BlocProvider<CartCubit>.value(
        value: cubit,
        child: const CartPage(),
      ),
    );
  }

  testWidgets('shows the empty view when the cart is empty', (tester) async {
    when(() => cubit.state).thenReturn(const CartState(items: []));

    await tester.pumpWidget(buildSubject());

    expect(find.byType(EmptyCart), findsOneWidget);
  });

  testWidgets('renders one tile per item', (tester) async {
    when(() => cubit.state).thenReturn(CartState(items: [itemA, itemB]));

    await tester.pumpWidget(buildSubject());

    expect(find.byType(CartTile), findsNWidgets(2));
  });

  testWidgets('tapping remove calls the cubit', (tester) async {
    when(() => cubit.state).thenReturn(CartState(items: [itemA]));
    when(() => cubit.remove(any())).thenAnswer((_) async {});

    await tester.pumpWidget(buildSubject());
    await tester.tap(find.byKey(const Key('remove_${1}')));

    verify(() => cubit.remove(itemA.id)).called(1);
  });
}
```

`MockCubit` comes from `bloc_test` and already fakes the stream, so you only stub `state`. The `buildSubject()` helper is a habit worth copying: one place to change when the widget gains a new dependency.

---

## Golden Tests: Screenshots As Assertions

```dart
testWidgets('empty cart matches the golden', (tester) async {
  await tester.pumpWidget(buildSubject());

  await expectLater(
    find.byType(CartPage),
    matchesGoldenFile('goldens/cart_empty.png'),
  );
});
```

```bash
flutter test --update-goldens      # create or refresh the images
flutter test                       # fail if the pixels changed
```

Golden tests catch visual regressions nothing else catches (a padding change, a wrong colour, a broken layout at a given size). Two warnings from real projects:

1. Goldens differ between machines because of font rendering, so run them in one environment (usually CI only) or use `golden_toolkit` style helpers to load a fixed font.
2. Never blindly run `--update-goldens` when a test fails. Look at the diff image first, or you will "fix" the test by accepting the bug.

---

## Testing Responsive Behaviour

```dart
testWidgets('uses a rail on wide screens', (tester) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const MaterialApp(home: HomeShell()));

  expect(find.byType(NavigationRail), findsOneWidget);
  expect(find.byType(NavigationBar), findsNothing);
});
```

Without `addTearDown(tester.view.reset)`, the fake size leaks into every later test in the file.

---

## Common Failures And Their Meaning

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   "No Directionality widget found"                   │
│      -> wrap in MaterialApp (or Directionality)      │
│                                                      │
│   "A RenderFlex overflowed by 42 pixels"             │
│      -> the test surface is 800x600 by default;      │
│         your layout genuinely overflows there        │
│                                                      │
│   "pumpAndSettle timed out"                          │
│      -> an animation never ends (a spinner). Use     │
│         pump(Duration(...)) instead                  │
│                                                      │
│   "Found 0 widgets with text 'Save'"                 │
│      -> not built yet (missing pump), off screen     │
│         (scroll first), or the text differs          │
│                                                      │
│   "Timer is still pending"                           │
│      -> a Timer or subscription was not cancelled    │
│         in dispose. That is a real leak your test    │
│         just caught                                  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

That last one is worth saying out loud in an interview: widget tests catch undisposed controllers and timers, which is a category of bug users experience as a slow, leaky app.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • testWidgets + tester.pumpWidget to build         │
│   • pump for one frame, pumpAndSettle for animations │
│   • Find by Key for anything interactive             │
│   • Provide fake blocs at the root of the subject    │
│   • Check onPressed == null to prove "disabled"      │
│   • Goldens for visual regressions, reviewed by eye  │
│   • tester.view.physicalSize for responsive tests    │
│   • Test failures often reveal real leaks            │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** When must you use `pump(Duration(...))` instead of `pumpAndSettle()`?

<details>
<summary>Answer</summary>
When something animates forever, such as a `CircularProgressIndicator`. `pumpAndSettle` waits for all animations to finish, so it times out.
</details>

**Q2.** Why prefer `find.byKey` over `find.text`?

<details>
<summary>Answer</summary>
Text changes with copy edits and localisation, which breaks the test for no real reason. A key is stable and expresses intent.
</details>

**Q3.** How do you assert that a button is disabled?

<details>
<summary>Answer</summary>
Read the widget instance and check its callback: `tester.widget<ElevatedButton>(finder).onPressed` should be `null`.
</details>

---

## Assignment

### Problem 1: Write the test

A login form's submit button is disabled until both fields are filled. Write the widget test.

### Problem 2: Fix the finder

`expect(find.text('Item 90'), findsOneWidget)` fails on a long list. Why, and what do you add?

### Problem 3: Provide the dependency

Your `ProfilePage` reads a `ProfileCubit`. Write the `buildSubject()` helper.

### Problem 4: Golden discipline

A golden test fails after a colleague changes the theme. What do you do, in order?

---

## Assignment Answers

### Problem 1: Write the test

```dart
testWidgets('submit is enabled only when both fields are filled', (tester) async {
  await tester.pumpWidget(const MaterialApp(home: LoginPage()));

  ElevatedButton submit() =>
      tester.widget<ElevatedButton>(find.byKey(const Key('submit')));

  expect(submit().onPressed, isNull);

  await tester.enterText(find.byKey(const Key('email')), 'a@b.com');
  await tester.pump();
  expect(submit().onPressed, isNull);

  await tester.enterText(find.byKey(const Key('password')), 'secret123');
  await tester.pump();
  expect(submit().onPressed, isNotNull);
});
```

### Problem 2: Fix the finder

The widget is not built because it is off screen and the list is lazy. Scroll to it first:

```dart
await tester.scrollUntilVisible(find.text('Item 90'), 200);
```

### Problem 3: Provide the dependency

```dart
Widget buildSubject() => MaterialApp(
      home: BlocProvider<ProfileCubit>.value(
        value: cubit,
        child: const ProfilePage(),
      ),
    );
```

### Problem 4: Golden discipline

1. Open the generated failure images (the diff, the master, and the test output) and look at what changed.
2. Decide whether the change was intended.
3. If intended, run `flutter test --update-goldens` and commit the new images with the theme change so the diff is reviewable.
4. If not intended, fix the code, not the golden.

---

## Navigation

⬅️ **Previous:** [Unit Testing](06a-UnitTesting.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Integration Testing](06c-IntegrationTesting.md)
