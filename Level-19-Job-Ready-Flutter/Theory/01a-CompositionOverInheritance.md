# Composition Over Inheritance: Building With Lego, Not Statues

## The Big Idea In One Sentence

> In Flutter you almost never make a new widget by extending an old one; you make it by **wrapping and combining** widgets you already have.

---

## The Simple Explanation

There are two ways to make something new.

**Way 1: Carve a statue.** You take a big block of marble and cut it into exactly one shape. If you want a slightly different statue, you start again with a new block.

**Way 2: Build with Lego.** You snap small bricks together. Want a different result? Swap a brick. Reuse the rest.

Inheritance is the statue. Composition is the Lego. Flutter chose Lego.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   INHERITANCE (statue)                               │
│   ────────────────────                               │
│   class FancyRedRoundedButton extends ElevatedButton │
│         extends ButtonStyleButton                    │
│         extends StatefulWidget                       │
│                                                      │
│   Want blue instead of red?                          │
│   -> new class. Want no rounding? -> new class.      │
│   You end up with 30 classes nobody can name.        │
│                                                      │
│   COMPOSITION (lego)                                 │
│   ──────────────────                                 │
│   Padding(                                           │
│     child: DecoratedBox(                             │
│       child: InkWell(                                │
│         child: Text('Buy'),                          │
│       ),                                             │
│     ),                                               │
│   )                                                  │
│                                                      │
│   Want blue instead of red? Change one brick.        │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Proof From Flutter Itself

Look at the widgets you already use. None of them inherit behaviour from each other. They wrap each other.

```dart
// This is what Container actually is: a stack of small widgets.
Container(
  padding: const EdgeInsets.all(16),
  color: Colors.blue,
  child: const Text('Hi'),
)

// Flutter builds it roughly like this:
ColoredBox(
  color: Colors.blue,
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: const Text('Hi'),
  ),
)
```

`Container` does not extend `Padding`. It **contains** a `Padding`. Every single widget you write should follow that same habit.

There are only two classes you ever extend in day to day Flutter:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   extend StatelessWidget   -> no internal state      │
│   extend StatefulWidget    -> has internal state     │
│                                                      │
│   That is the whole list. Everything else is a       │
│   child, not a parent.                               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Why Inheritance Breaks In UI

Imagine you build a `PrimaryButton` by extending `ElevatedButton`. Then the designer asks for:

1. A primary button with an icon on the left
2. A primary button that shows a spinner while saving
3. A primary button that is full width on phones
4. A destructive red version

With inheritance you get `PrimaryIconButton`, `PrimaryLoadingButton`, `PrimaryWideButton`, `DangerButton`, then `PrimaryWideLoadingButton` when two requirements meet. This is called the **class explosion**, and combinations multiply.

With composition you get **one** button that takes parameters and children:

```dart
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isDestructive = false,
    this.expand = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isDestructive;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final button = FilledButton(
      onPressed: isLoading ? null : onPressed,
      style: FilledButton.styleFrom(
        backgroundColor: isDestructive ? colors.error : colors.primary,
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

Four requirements, one class, zero subclasses. That is composition.

---

## The Three Composition Moves

Almost every reusable widget you will ever write uses one of these three moves.

### Move 1: Wrap (add behaviour around a child)

The widget takes a `child` and adds something to it.

```dart
class Card2 extends StatelessWidget {
  const Card2({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: child,
      ),
    );
  }
}

// Use it with anything. It does not care what the child is.
Card2(child: Text('Any content at all'))
Card2(child: Column(children: [Text('a'), Text('b')]))
```

### Move 2: Slots (named holes the caller fills)

Instead of one `child`, expose several named widget parameters. This is exactly what `Scaffold` does with `appBar`, `body`, and `floatingActionButton`.

```dart
class ListTileRow extends StatelessWidget {
  const ListTileRow({
    super.key,
    required this.leading,
    required this.title,
    this.trailing,
  });

  final Widget leading;
  final Widget title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        leading,
        const SizedBox(width: 12),
        Expanded(child: title),
        if (trailing != null) trailing!,
      ],
    );
  }
}
```

The caller decides what goes in each slot. Your widget only decides the arrangement.

### Move 3: Builders (hand data back to the caller)

When your widget knows something the caller needs (a size, a state, an index), give it back through a function.

```dart
class HoverArea extends StatefulWidget {
  const HoverArea({super.key, required this.builder});

  final Widget Function(BuildContext context, bool isHovered) builder;

  @override
  State<HoverArea> createState() => _HoverAreaState();
}

class _HoverAreaState extends State<HoverArea> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: widget.builder(context, _hovered),
    );
  }
}

// Caller decides what "hovered" looks like.
HoverArea(
  builder: (context, isHovered) => Container(
    color: isHovered ? Colors.blue : Colors.grey,
    height: 60,
  ),
)
```

`LayoutBuilder`, `ListView.builder`, `FutureBuilder`, and `BlocBuilder` are all this same move.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   WRAP     -> takes one child, decorates it          │
│   SLOTS    -> takes several named widgets            │
│   BUILDER  -> gives information back to the caller   │
│                                                      │
│   If you can name which move you are using,          │
│   your widget API is probably good.                  │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## When Inheritance Is Actually Right

Composition is the rule, not a religion. Extending a class is right when you are building a **new kind of thing**, not a new look.

Good reasons to extend:

```dart
// A custom painter is a new kind of painting instruction.
class RingPainter extends CustomPainter { /* ... */ }

// A custom scroll behaviour is a new kind of behaviour.
class NoGlowBehavior extends ScrollBehavior { /* ... */ }

// A route is a new kind of transition.
class FadeRoute<T> extends PageRouteBuilder<T> { /* ... */ }
```

Bad reason to extend: "I want the same button but green."

---

## Interview Answer You Can Reuse

> **Q: Why does Flutter prefer composition over inheritance?**
>
> Flutter's UI is a tree, and widgets are immutable configuration objects, not mutable UI objects. Combining them by nesting keeps every widget small, single purpose, and independently testable. Inheritance would force behaviour to travel down a class hierarchy, which produces a class explosion the moment two variations meet. Composition lets variations be parameters instead of subclasses. Flutter's own widgets prove it: `Container` is a composition of `Padding`, `ColoredBox`, `Align`, and others rather than a subclass of any of them.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Extend only StatelessWidget or StatefulWidget    │
│   • Build new widgets by wrapping existing ones      │
│   • Variations become parameters, not subclasses     │
│   • Three moves: wrap, slots, builder                │
│   • Inheritance is for new KINDS of things           │
│     (painters, routes, behaviours), not new looks    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Which two classes do you normally extend in Flutter?

<details>
<summary>Answer</summary>
`StatelessWidget` and `StatefulWidget`. Everything else you compose by nesting.
</details>

**Q2.** A designer wants your button in a "loading" version and an "icon" version. What do you do?

<details>
<summary>Answer</summary>
Add `isLoading` and `icon` parameters to the one button widget. Do not create `LoadingButton` and `IconButton` subclasses, because the moment someone needs both you would need a third class.
</details>

**Q3.** What is the "builder" composition move for?

<details>
<summary>Answer</summary>
For when your widget knows something the caller needs (hover state, available width, list index, bloc state). You pass that value into a function the caller supplied, so the caller decides how it looks.
</details>

---

## Assignment

### Problem 1: Spot the smell

```dart
class RedCard extends BlueCard {
  @override
  Color get background => Colors.red;
}
```

What is wrong with this, and what would you write instead?

### Problem 2: Name the move

For each widget, say whether it uses wrap, slots, or builder:
`Padding`, `Scaffold`, `LayoutBuilder`, `Center`, `ListView.builder`, `AppBar`.

### Problem 3: Design an API

Design (just the constructor and fields, no build method) a reusable `EmptyState` widget that shows an illustration, a title, a message, and an optional action button.

### Problem 4: Convert to composition

You have `class BigTitleText extends Text` and `class BigRedTitleText extends BigTitleText`. Rewrite as one composed widget.

---

## Assignment Answers

### Problem 1: Spot the smell

It uses inheritance to change one visual value, so every new colour needs a new class, and `RedCard` is now locked to whatever `BlueCard` does forever. Instead use one `AppCard` with a `background` parameter:

```dart
class AppCard extends StatelessWidget {
  const AppCard({super.key, required this.child, this.background});
  final Widget child;
  final Color? background;
  // ...
}
```

### Problem 2: Name the move

- `Padding` -> wrap
- `Scaffold` -> slots (appBar, body, bottomNavigationBar, drawer)
- `LayoutBuilder` -> builder
- `Center` -> wrap
- `ListView.builder` -> builder
- `AppBar` -> slots (leading, title, actions)

### Problem 3: Design an API

```dart
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.illustration,
    this.action,
  });

  final String title;
  final String message;
  final Widget? illustration; // slot
  final Widget? action;       // slot
}
```

Using `Widget?` for the illustration and action (instead of `IconData` and `VoidCallback`) means the caller can put anything there, including an image, an animation, or two buttons in a `Row`.

### Problem 4: Convert to composition

```dart
class TitleText extends StatelessWidget {
  const TitleText(this.text, {super.key, this.color});

  final String text;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context)
          .textTheme
          .headlineSmall
          ?.copyWith(color: color, fontWeight: FontWeight.bold),
    );
  }
}

// Both old classes are now just arguments:
const TitleText('Hello');
const TitleText('Hello', color: Colors.red);
```

---

## Navigation

⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Building Composite Widgets](01b-BuildingCompositeWidgets.md)
