# Adaptive Layouts: One Codebase, Every Screen

## The Big Idea In One Sentence

> **Responsive** means the same layout stretches; **adaptive** means you show a genuinely different layout (and sometimes different controls) when the screen or the platform changes.

---

## Responsive vs Adaptive

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   RESPONSIVE                                         │
│   ──────────                                         │
│   Same design, different measurements.               │
│   2 columns -> 4 columns. Padding 16 -> 32.          │
│                                                      │
│   ADAPTIVE                                           │
│   ────────                                           │
│   Different design for a different context.          │
│   Bottom nav bar -> side navigation rail.            │
│   Full screen detail page -> side by side panels.    │
│   Material switch -> Cupertino switch on iOS.        │
│                                                      │
│   Real apps use BOTH. Interviewers ask for the       │
│   difference by name.                                │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Pattern 1: Adaptive Navigation

The single most recognisable adaptive change. Material's own guidance:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   compact  (< 600)   NavigationBar at the bottom     │
│   medium   (600+)    NavigationRail, icons only      │
│   expanded (840+)    NavigationRail extended, or a   │
│                      permanent NavigationDrawer      │
│                                                      │
└──────────────────────────────────────────────────────┘
```

```dart
class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    super.key,
    required this.selectedIndex,
    required this.onSelected,
    required this.destinations,
    required this.body,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;
  final List<AdaptiveDestination> destinations;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;

    // Phone: bottom bar
    if (width < 600) {
      return Scaffold(
        body: body,
        bottomNavigationBar: NavigationBar(
          selectedIndex: selectedIndex,
          onDestinationSelected: onSelected,
          destinations: [
            for (final d in destinations)
              NavigationDestination(icon: Icon(d.icon), label: d.label),
          ],
        ),
      );
    }

    // Tablet and desktop: side rail, extended when there is room
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: width >= 840,
            selectedIndex: selectedIndex,
            onDestinationSelected: onSelected,
            destinations: [
              for (final d in destinations)
                NavigationRailDestination(
                  icon: Icon(d.icon),
                  label: Text(d.label),
                ),
            ],
          ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
    );
  }
}

class AdaptiveDestination {
  const AdaptiveDestination({required this.icon, required this.label});
  final IconData icon;
  final String label;
}
```

Notice the shell changes but `body` does not. The pages never know which navigation is on screen.

---

## Pattern 2: List and Detail (master detail)

On a phone, tapping a row pushes a new page. On a tablet, the detail appears beside the list and nothing is pushed.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   PHONE                    TABLET / DESKTOP          │
│   ┌──────────┐             ┌──────┬───────────────┐  │
│   │ Inbox    │             │Inbox │ Message       │  │
│   │ • mail 1 │  tap ->     │•mail1│ ───────────   │  │
│   │ • mail 2 │  new page   │ mail2│ Hi there,     │  │
│   │ • mail 3 │             │ mail3│ ...           │  │
│   └──────────┘             └──────┴───────────────┘  │
│                                                      │
│   Same data, same widgets, different arrangement.    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

```dart
class InboxPage extends StatefulWidget {
  const InboxPage({super.key, required this.messages});

  final List<Message> messages;

  @override
  State<InboxPage> createState() => _InboxPageState();
}

class _InboxPageState extends State<InboxPage> {
  Message? _selected;

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.sizeOf(context).width >= 840;

    final list = MessageList(
      messages: widget.messages,
      selected: isWide ? _selected : null,
      onTap: (message) {
        if (isWide) {
          setState(() => _selected = message);
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => MessageDetailPage(message: message)),
          );
        }
      },
    );

    if (!isWide) return Scaffold(body: list);

    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 360, child: list),
          const VerticalDivider(width: 1),
          Expanded(
            child: _selected == null
                ? const Center(child: Text('Select a message'))
                : MessageDetail(message: _selected!),
          ),
        ],
      ),
    );
  }
}
```

Two rules that make this work in production:

1. `MessageDetail` is a plain widget with no `Scaffold` of its own. `MessageDetailPage` is the thin phone wrapper that adds the `Scaffold` and `AppBar`. Never write the detail twice.
2. Keep the selection in state that survives a rotate, so turning a tablet does not lose the open message.

---

## Pattern 3: Adaptive Presentation

The same action can be a bottom sheet on a phone and a dialog on a desktop.

```dart
Future<T?> showAdaptiveSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
}) {
  final isWide = MediaQuery.sizeOf(context).width >= 600;

  if (isWide) {
    return showDialog<T>(
      context: context,
      builder: (context) => Dialog(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: builder(context),
        ),
      ),
    );
  }

  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    builder: builder,
  );
}
```

One call site, correct behaviour on both.

---

## Pattern 4: Platform Adaptive Controls

Some widgets ship two looks and pick by platform automatically.

```dart
Switch.adaptive(value: on, onChanged: onChanged)       // Cupertino on iOS/macOS
const CircularProgressIndicator.adaptive()
Slider.adaptive(value: v, onChanged: onChanged)
const AlertDialog.adaptive(title: Text('Delete?'))
showAdaptiveDialog(context: context, builder: ...)
Theme.of(context).platform                              // what platform am I on
```

The `Icon` for "back" and the page transition also follow the platform automatically when you use `MaterialApp` with `MaterialPageRoute`, because `PageTransitionsTheme` includes a Cupertino transition for iOS.

Do not go overboard. Most teams ship one Material design on all platforms and only adapt navigation, gestures, and a handful of controls. Ask in the interview: "does the team want a single Material look, or true per platform UI?" That question alone signals experience.

---

## Pattern 5: Input Differences

Phones have thumbs. Desktops have a mouse, a keyboard, and hover.

```dart
// Hover feedback (does nothing on touch devices, so it is safe everywhere)
MouseRegion(
  cursor: SystemMouseCursors.click,
  onEnter: (_) => setState(() => _hovered = true),
  onExit: (_) => setState(() => _hovered = false),
  child: card,
)

// Keyboard shortcuts
CallbackShortcuts(
  bindings: {
    const SingleActivator(LogicalKeyboardKey.keyN, control: true): _newItem,
    const SingleActivator(LogicalKeyboardKey.escape): _closePanel,
  },
  child: Focus(autofocus: true, child: body),
)

// Bigger tap targets on touch, tighter rows with a mouse
final rowHeight = switch (Theme.of(context).platform) {
  TargetPlatform.iOS || TargetPlatform.android => 56.0,
  _ => 40.0,
};
```

Minimum touch target is 48x48 logical pixels on Android and 44x44 on iOS. Interviewers like candidates who know the number.

---

## Orientation and Rotation

```dart
final isLandscape =
    MediaQuery.orientationOf(context) == Orientation.landscape;

// Lock orientation only when the content demands it (a video player, a game)
await SystemChrome.setPreferredOrientations([
  DeviceOrientation.portraitUp,
]);
```

Prefer width based decisions over orientation based ones. A phone in landscape and a small tablet in portrait can have the same width, and width is what your layout actually cares about.

---

## Testing Every Size Without A Device

```dart
testWidgets('shows a rail on wide screens', (tester) async {
  tester.view.physicalSize = const Size(1200, 800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const MyApp());

  expect(find.byType(NavigationRail), findsOneWidget);
  expect(find.byType(NavigationBar), findsNothing);
});
```

`addTearDown(tester.view.reset)` matters: without it the fake size leaks into the next test.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Responsive = same layout, new measurements       │
│   • Adaptive  = different layout or control          │
│   • Nav: bottom bar -> rail -> extended rail         │
│   • List/detail: push on phone, split on tablet      │
│   • Sheet on phone, dialog on desktop                │
│   • .adaptive constructors for platform controls     │
│   • Hover, cursors, and shortcuts for desktop        │
│   • Decide by WIDTH, not by orientation              │
│   • Test sizes with tester.view.physicalSize         │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Give a one line difference between responsive and adaptive.

<details>
<summary>Answer</summary>
Responsive stretches the same layout to a new size. Adaptive swaps in a different layout or control for a different context.
</details>

**Q2.** In a list/detail screen, why should the detail widget not contain its own `Scaffold`?

<details>
<summary>Answer</summary>
Because on a tablet it is embedded beside the list, where a second `Scaffold` would add an unwanted app bar and background layer. The phone wrapper page adds the `Scaffold`, so the detail widget can be reused in both layouts.
</details>

**Q3.** Why decide layout by width rather than orientation?

<details>
<summary>Answer</summary>
Because width is what the layout actually needs. A phone in landscape and a small tablet in portrait can present nearly the same width, and orientation alone would send them down different paths for no reason.
</details>

---

## Assignment

### Problem 1: Choose the navigation

Widths 420, 700, and 1100. Which navigation for each?

### Problem 2: The rotate bug

A tablet shows a selected message beside the list. The user rotates the device and the selection is lost. What went wrong?

### Problem 3: Adaptive control

Name three widgets that have an `.adaptive` constructor and say what they turn into on iOS.

### Problem 4: Test setup

Write the two lines that make a widget test run at 1200x800 and clean up afterwards.

---

## Assignment Answers

### Problem 1: Choose the navigation

- 420: `NavigationBar` at the bottom (compact)
- 700: `NavigationRail`, icons only (medium)
- 1100: `NavigationRail` with `extended: true`, or a permanent `NavigationDrawer` (expanded)

### Problem 2: The rotate bug

The selection lived in state that was rebuilt from scratch. Either the widget was re-created (a new key or a different branch of the tree), or the selection was stored in a `StatefulWidget` that gets replaced when the layout switches. Keep the selection above the layout switch, in state that both branches share (a state holder, a cubit, or the router URL).

### Problem 3: Adaptive control

`Switch.adaptive` becomes a `CupertinoSwitch`, `CircularProgressIndicator.adaptive` becomes a `CupertinoActivityIndicator`, `Slider.adaptive` becomes a `CupertinoSlider`. (`AlertDialog.adaptive` and `showAdaptiveDialog` behave the same way with `CupertinoAlertDialog`.)

### Problem 4: Test setup

```dart
tester.view.physicalSize = const Size(1200, 800);
addTearDown(tester.view.reset);
```

---

## Navigation

⬅️ **Previous:** [Responsive Foundations](01c-ResponsiveFoundations.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Cubit Deep Dive](02a-CubitDeepDive.md)
