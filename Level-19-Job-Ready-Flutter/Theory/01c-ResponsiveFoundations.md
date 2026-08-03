# Responsive Foundations: How Flutter Layout Really Works

## The Big Idea In One Sentence

> **Constraints go down, sizes go up, the parent sets the position**: once you can say that sentence out loud, every layout bug and every responsive layout becomes easy.

---

## The Simple Explanation

Imagine a parent handing a child a box and saying: "you may be anywhere from 100 to 300 pixels wide, and 0 to 500 tall. Pick a size." The child picks, tells the parent, and the parent decides where to put it.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   PARENT                                             │
│     │  1. sends CONSTRAINTS down                     │
│     │     (minWidth, maxWidth, minHeight, maxHeight) │
│     ▼                                                │
│   CHILD                                              │
│     │  2. picks its SIZE within those limits         │
│     │     and sends the size back up                 │
│     ▼                                                │
│   PARENT                                             │
│        3. decides the child's POSITION               │
│                                                      │
│   A child never knows where it is on screen.         │
│   A parent never knows how big its child wants       │
│   to be until it asks.                               │
│                                                      │
└──────────────────────────────────────────────────────┘
```

That is the whole layout engine. Everything else is a special case of it.

---

## Why Layout Errors Happen

### "Unbounded height" errors

A `Column` gives its children **unbounded** height (as much as they want). A `ListView` wants **all** the height it can get. Put one in the other and the `ListView` asks for infinity.

```dart
// Throws: "Vertical viewport was given unbounded height"
Column(
  children: [
    const Text('Title'),
    ListView(children: items),   // wants infinite height
  ],
)
```

Three correct fixes, depending on what you want:

```dart
// 1. The list should fill the remaining space (most common)
Column(
  children: [
    const Text('Title'),
    Expanded(child: ListView(children: items)),
  ],
)

// 2. The list is short and should be exactly as tall as its content
Column(
  children: [
    const Text('Title'),
    ListView(shrinkWrap: true, physics: const NeverScrollableScrollPhysics(), children: items),
  ],
)

// 3. The whole screen scrolls as one
CustomScrollView(
  slivers: [
    const SliverToBoxAdapter(child: Text('Title')),
    SliverList.builder(
      itemCount: items.length,
      itemBuilder: (context, i) => items[i],
    ),
  ],
)
```

### "Incorrect use of ParentDataWidget"

`Expanded` and `Flexible` only work directly inside `Row`, `Column`, or `Flex`. Putting one inside a `Container` or a `Stack` throws this error.

---

## Getting Screen Information: The Right Way

### `MediaQuery.sizeOf`, not `MediaQuery.of`

```dart
// Old habit: rebuilds when ANY media query value changes,
// including the keyboard opening, brightness, text scale, padding.
final width = MediaQuery.of(context).size.width;

// Correct: rebuilds only when the SIZE changes.
final width = MediaQuery.sizeOf(context).width;
```

Flutter provides one focused accessor per property. Use them:

```dart
final size        = MediaQuery.sizeOf(context);             // logical pixels
final padding     = MediaQuery.paddingOf(context);          // notch, status bar
final insets      = MediaQuery.viewInsetsOf(context);       // keyboard height
final orientation = MediaQuery.orientationOf(context);      // portrait/landscape
final textScaler  = MediaQuery.textScalerOf(context);       // user font size
final platformBr  = MediaQuery.platformBrightnessOf(context); // light/dark
```

This is a real interview question. The answer is: `MediaQuery.of(context)` subscribes your widget to **every** media query change, so your widget rebuilds when the keyboard opens even though you only wanted the width. The `xxxOf` accessors subscribe to one property only.

### Screen size vs available space

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   MediaQuery.sizeOf(context)                         │
│   -> the whole WINDOW                                │
│   -> right for: "is this a phone or a tablet?"       │
│                                                      │
│   LayoutBuilder constraints.maxWidth                 │
│   -> the space THIS widget was given                 │
│   -> right for: "how wide is my card, my column,     │
│      my panel?"                                      │
│                                                      │
│   A card in a 300px sidebar on a 1400px desktop      │
│   has maxWidth 300, but sizeOf says 1400.            │
│   Use the one that matches the question.             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

```dart
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 400) {
      return const _StackedCard();
    }
    return const _SideBySideCard();
  },
)
```

---

## Breakpoints You Can Defend

Material 3 window size classes are the numbers to quote in an interview:

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   width < 600     COMPACT   phone portrait           │
│   600 to 839      MEDIUM    phone landscape, small   │
│                             tablet, folded           │
│   840 to 1199     EXPANDED  tablet landscape         │
│   1200 to 1599    LARGE     desktop                  │
│   >= 1600         EXTRA     wide desktop             │
│                                                      │
└──────────────────────────────────────────────────────┘
```

Put them in one place, never scattered as magic numbers:

```dart
enum WindowSize { compact, medium, expanded, large, extraLarge }

WindowSize windowSizeOf(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) return WindowSize.compact;
  if (width < 840) return WindowSize.medium;
  if (width < 1200) return WindowSize.expanded;
  if (width < 1600) return WindowSize.large;
  return WindowSize.extraLarge;
}

// Usage reads like English, and there is one place to change a number.
final columns = switch (windowSizeOf(context)) {
  WindowSize.compact => 1,
  WindowSize.medium => 2,
  WindowSize.expanded => 3,
  WindowSize.large || WindowSize.extraLarge => 4,
};
```

---

## The Flex Widgets, Precisely

```dart
Row(
  children: [
    Expanded(flex: 2, child: Blue()),   // takes 2/3 of the free space
    Expanded(flex: 1, child: Green()),  // takes 1/3
  ],
)
```

- `Expanded` = `Flexible(fit: FlexFit.tight)`: **must** fill its share.
- `Flexible` (default `FlexFit.loose`): **may** use up to its share, but can be smaller.
- `Spacer` = an `Expanded` with an empty child, for pushing things apart.

```dart
Row(
  children: [
    const Text('Left'),
    const Spacer(),          // eats all free space
    const Text('Right'),
  ],
)
```

`mainAxisAlignment` distributes leftover space; `crossAxisAlignment` positions along the other axis. `mainAxisSize: MainAxisSize.min` makes the Row/Column hug its children instead of filling.

---

## Sizing Widgets Worth Knowing

```dart
// Fraction of the parent
FractionallySizedBox(widthFactor: 0.8, child: Card())

// Fixed shape at any size
AspectRatio(aspectRatio: 16 / 9, child: VideoPlayer())

// Shrink text or a widget to fit instead of overflowing
FittedBox(fit: BoxFit.scaleDown, child: Text('A very long title'))

// Wrap to the next line when there is no room (chips, tags)
Wrap(
  spacing: 8,
  runSpacing: 8,
  children: tags.map((t) => Chip(label: Text(t))).toList(),
)

// A grid whose column count follows the available width
GridView.extent(
  maxCrossAxisExtent: 220,   // each cell at most 220 wide
  children: products,
)

// Never smaller than X, never larger than Y
ConstrainedBox(
  constraints: const BoxConstraints(maxWidth: 640),
  child: const ArticleBody(),
)
```

`GridView.extent` and `SliverGridDelegateWithMaxCrossAxisExtent` are the lazy way to be responsive: you declare a cell width and the grid works out the column count for any screen, with no breakpoints at all.

---

## Text That Respects The User

A user who set their phone font to "huge" for accessibility reasons will break a layout you built with fixed heights.

```dart
// Never do this: it ignores the user's setting entirely
MediaQuery(
  data: MediaQuery.of(context).copyWith(textScaler: TextScaler.noScaling),
  child: child,
)

// If you must protect a tight layout, CLAMP instead of disabling
MediaQuery(
  data: MediaQuery.of(context).copyWith(
    textScaler: MediaQuery.textScalerOf(context).clamp(
      minScaleFactor: 1.0,
      maxScaleFactor: 1.4,
    ),
  ),
  child: child,
)
```

And build layouts that can grow: prefer `Padding` and `Wrap` over fixed `height:` values on anything containing text.

---

## Safe Areas and the Keyboard

```dart
// Keeps content out of the notch, status bar, and home indicator
const SafeArea(child: MyBody())

// Bottom padding that grows when the keyboard opens
Padding(
  padding: EdgeInsets.only(
    bottom: MediaQuery.viewInsetsOf(context).bottom,
  ),
  child: const MessageComposer(),
)
```

`Scaffold` already handles the keyboard for its `body` when `resizeToAvoidBottomInset` is true (the default). You need `viewInsets` manually inside bottom sheets and dialogs.

---

## A Complete Responsive Page

```dart
class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key, required this.products});

  final List<Product> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth >= 840;

            final grid = GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate:
                  const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 240,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, i) =>
                  ProductCard(key: ValueKey(products[i].id), product: products[i]),
            );

            if (!isWide) return grid;

            // Wide screens: filters beside the grid, content centred and capped
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 260, child: FilterPanel()),
                const VerticalDivider(width: 1),
                Expanded(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: grid,
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
```

Notice what makes this professional: a max width so text never stretches across a 27 inch monitor, a grid that reflows by cell width, `SafeArea` for notches, and one `isWide` decision instead of ten scattered checks.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   • Constraints down, sizes up, parent positions     │
│   • MediaQuery.sizeOf for the window                 │
│   • LayoutBuilder for the space YOU were given       │
│   • Material breakpoints: 600 / 840 / 1200 / 1600    │
│   • Expanded = tight, Flexible = loose               │
│   • GridView.extent reflows with no breakpoints      │
│   • Clamp text scale, never disable it               │
│   • Cap max width on desktop                         │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Say the layout rule in one sentence.

<details>
<summary>Answer</summary>
Constraints go down, sizes go up, and the parent sets the position.
</details>

**Q2.** Why prefer `MediaQuery.sizeOf(context)` over `MediaQuery.of(context).size`?

<details>
<summary>Answer</summary>
`MediaQuery.of` subscribes the widget to every media query change, so it rebuilds when the keyboard opens or the text scale changes. `sizeOf` subscribes to the size only.
</details>

**Q3.** A card sits inside a 320px sidebar on a 1440px desktop. Which tool tells you the card has 320px to work with?

<details>
<summary>Answer</summary>
`LayoutBuilder`, through `constraints.maxWidth`. `MediaQuery.sizeOf` would report 1440, which is the window, not the card's space.
</details>

---

## Assignment

### Problem 1: Fix the crash

```dart
Column(
  children: [
    Text('Chats'),
    ListView.builder(itemCount: 50, itemBuilder: ...),
  ],
)
```

What error does this throw and what is the one word fix?

### Problem 2: Pick the accessor

Which accessor for each: keyboard height, notch padding, is the user in dark mode, window width.

### Problem 3: Column count

Write a function that returns 1, 2, 3, or 4 columns using the Material window size class breakpoints.

### Problem 4: Design decision

Your product grid must look right on a 360px phone and a 2560px monitor. Name two things you would do beyond changing the column count.

---

## Assignment Answers

### Problem 1: Fix the crash

"Vertical viewport was given unbounded height". Wrap the `ListView.builder` in `Expanded`, so it fills the leftover height instead of asking for infinity.

### Problem 2: Pick the accessor

- Keyboard height: `MediaQuery.viewInsetsOf(context).bottom`
- Notch padding: `MediaQuery.paddingOf(context)`
- Dark mode: `MediaQuery.platformBrightnessOf(context)` (or `Theme.of(context).brightness`)
- Window width: `MediaQuery.sizeOf(context).width`

### Problem 3: Column count

```dart
int columnsFor(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width;
  if (width < 600) return 1;
  if (width < 840) return 2;
  if (width < 1200) return 3;
  return 4;
}
```

### Problem 4: Design decision

Any two of: cap the content with `ConstrainedBox(maxWidth: ~1200)` and centre it so lines do not stretch; use `GridView.extent` / `maxCrossAxisExtent` so cell size stays comfortable at any width; increase padding and spacing on larger classes; switch navigation from a bottom bar to a `NavigationRail` or permanent drawer; clamp text scaling so huge accessibility fonts do not break cards.

---

## Navigation

⬅️ **Previous:** [Building Composite Widgets](01b-BuildingCompositeWidgets.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Adaptive Layouts](01d-AdaptiveLayouts.md)
