# Building Composite Widgets: Small Bricks, Fast Screens

## The Big Idea In One Sentence

> Break a screen into small widget **classes** (not helper methods), mark everything you can as `const`, and Flutter will rebuild only the tiny part that actually changed.

---

## The Simple Explanation

A `build` method is a recipe that Flutter re-reads whenever something changes. If your whole screen is one giant recipe, Flutter re-reads the whole thing to change one word.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   ONE BIG BUILD METHOD                               │
│   ────────────────────                               │
│   Counter changes -> rebuild header, avatar, list,   │
│   footer, everything. 400 lines re-run.              │
│                                                      │
│   SMALL WIDGET CLASSES                               │
│   ────────────────────                               │
│   Counter changes -> rebuild CounterText only.       │
│   3 lines re-run. Everything else is untouched.      │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Rule 1: Extract Widgets, Not Methods

Beginners split a big build method into private methods. It looks tidy, but Flutter gains nothing.

### The method version (looks fine, performs badly)

```dart
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});
  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int likes = 0;

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text('My Profile', style: TextStyle(fontSize: 28)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),           // re-runs on EVERY setState
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

`_buildHeader()` is just a function call inside `build`. Every `setState` calls it again and creates a brand new `Padding` and `Text`.

### The widget version (Flutter can skip it)

```dart
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(24),
      child: Text('My Profile', style: TextStyle(fontSize: 28)),
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  int likes = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const ProfileHeader(),    // const: same object every time, skipped
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

Because `const ProfileHeader()` is a compile time constant, the *same instance* is used on every rebuild. Flutter compares old widget to new widget, sees they are identical, and does not rebuild that subtree at all.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   Flutter's rebuild check, simplified:               │
│                                                      │
│   if (identical(oldWidget, newWidget)) {             │
│     skip this whole subtree                          │
│   }                                                  │
│                                                      │
│   const constructors make identical() true.          │
│   Helper methods make a NEW object every time,       │
│   so identical() is always false.                    │
│                                                      │
└──────────────────────────────────────────────────────┘
```

**Use a helper method only when** the piece is tiny, used once, and depends on local variables you do not want to pass around. Everything reused, or everything inside a list, becomes a class.

---

## Rule 2: `const` Everywhere It Compiles

```dart
// Bad: new EdgeInsets object created on every build
padding: EdgeInsets.all(16),

// Good: created once, reused forever
padding: const EdgeInsets.all(16),
```

Turn on the lint so the analyzer nags you. In `analysis_options.yaml`:

```yaml
linter:
  rules:
    - prefer_const_constructors
    - prefer_const_literals_to_create_immutables
    - prefer_const_declarations
```

A constructor can be `const` only if every field is `final` and every argument is itself constant. That is why you write:

```dart
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, this.title = 'My Profile'});
  final String title;   // final, so the constructor can be const
  // ...
}
```

---

## Rule 3: Push State Down

The higher a `setState` lives, the more it rebuilds. Move the changing part into its own small stateful widget.

### Before: the whole page is stateful for one counter

```dart
class ShopPage extends StatefulWidget {   // whole page rebuilds
  // ... 300 lines of static content plus one counter
}
```

### After: only the counter is stateful

```dart
class ShopPage extends StatelessWidget {   // page never rebuilds
  const ShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        ExpensiveBanner(),
        ProductGrid(),
        CartCounter(),      // only this rebuilds
      ],
    );
  }
}

class CartCounter extends StatefulWidget {
  const CartCounter({super.key});
  @override
  State<CartCounter> createState() => _CartCounterState();
}

class _CartCounterState extends State<CartCounter> {
  int count = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$count'),
        IconButton(
          onPressed: () => setState(() => count++),
          icon: const Icon(Icons.add),
        ),
      ],
    );
  }
}
```

Same behaviour, a fraction of the work. This single habit fixes most "my Flutter app feels janky" complaints.

---

## Rule 4: Take `child` As A Parameter To Protect It

Sometimes a widget must rebuild (an animation, for example) but its content does not change. Accept the content as a parameter, and it survives the rebuild untouched.

```dart
class Pulse extends StatefulWidget {
  const Pulse({super.key, required this.child});

  final Widget child;   // built ONCE by the caller

  @override
  State<Pulse> createState() => _PulseState();
}

class _PulseState extends State<Pulse> with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 1),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _controller,
      child: widget.child,   // never rebuilt, just re-positioned
    );
  }
}
```

`AnimatedBuilder` and `TweenAnimationBuilder` both have a `child` parameter for exactly this reason.

---

## Rule 5: Keys, And When You Actually Need Them

Flutter matches old widgets to new widgets by **type and position**. That is usually enough. It breaks when you reorder or remove items in a list of stateful widgets.

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   List: [ TodoTile(A), TodoTile(B), TodoTile(C) ]    │
│   User deletes A.                                    │
│   New list: [ TodoTile(B), TodoTile(C) ]             │
│                                                      │
│   WITHOUT keys, Flutter matches by position:         │
│     slot 0 was A's State -> now shows B's data       │
│     B inherits A's checkbox, scroll, text field      │
│                                                      │
│   WITH ValueKey(todo.id), Flutter matches by id      │
│   and moves the right State with the right item.     │
│                                                      │
└──────────────────────────────────────────────────────┘
```

```dart
ListView(
  children: [
    for (final todo in todos)
      TodoTile(key: ValueKey(todo.id), todo: todo),
  ],
)
```

Quick rules:

- `ValueKey(id)` for list items that can be reordered, added, or removed
- `ObjectKey(item)` when the item has no simple id
- `GlobalKey` only when you truly must reach a widget's state from far away, for example `GlobalKey<FormState>` to call `validate()`. `GlobalKey` is expensive; do not sprinkle it.
- No key at all for static layout widgets

---

## Rule 6: Lists Must Be Lazy

```dart
// Bad: builds all 5000 rows immediately, even off screen
ListView(children: items.map(ItemTile.new).toList())

// Good: builds only what is visible, plus a small buffer
ListView.builder(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(item: items[index]),
)

// Better for long lists with dividers
ListView.separated(
  itemCount: items.length,
  itemBuilder: (context, index) => ItemTile(item: items[index]),
  separatorBuilder: (context, index) => const Divider(height: 1),
)
```

If a list is inside a `Column`, wrap it in `Expanded`, and set `shrinkWrap: true` only if the list is genuinely short. `shrinkWrap: true` measures every child, which defeats laziness.

---

## A Screen Built The Right Way

```dart
class OrderPage extends StatelessWidget {
  const OrderPage({super.key, required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Order')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          OrderSummaryCard(order: order),
          const SizedBox(height: 16),
          const SectionTitle('Items'),
          for (final item in order.items)
            OrderItemTile(key: ValueKey(item.id), item: item),
          const SizedBox(height: 16),
          const SectionTitle('Delivery'),
          DeliveryCard(address: order.address),
        ],
      ),
      bottomNavigationBar: PayBar(total: order.total),
    );
  }
}
```

Every piece is its own class, so every piece can be reused, tested, and previewed alone. `const` is used wherever nothing varies. Keys are on the repeatable rows only.

---

## Summary

```
┌──────────────────────────────────────────────────────┐
│                                                      │
│   1. Extract widget CLASSES, not build methods       │
│   2. const on every constructor that allows it       │
│   3. Push setState down to the smallest widget       │
│   4. Accept `child` so it survives rebuilds          │
│   5. ValueKey on reorderable list items only         │
│   6. ListView.builder for anything long              │
│                                                      │
└──────────────────────────────────────────────────────┘
```

---

## Quick Quiz

**Q1.** Why is `const ProfileHeader()` faster than `_buildHeader()`?

<details>
<summary>Answer</summary>
`const` gives the same object instance on every build, so Flutter's `identical()` check passes and it skips rebuilding that subtree. A method call creates a new object every time, so nothing can be skipped.
</details>

**Q2.** Your page has 300 lines of static content and one counter. Where should `setState` live?

<details>
<summary>Answer</summary>
Inside a small stateful widget that contains only the counter. The page itself should be stateless so the static content never rebuilds.
</details>

**Q3.** When do you need a `ValueKey`?

<details>
<summary>Answer</summary>
When items in a list of stateful widgets can be added, removed, or reordered. Without a key, Flutter matches by position and the wrong state sticks to the wrong item.
</details>

---

## Assignment

### Problem 1: Method or class?

You have a `_buildAvatar()` helper used in three different screens. Method or widget class? Why?

### Problem 2: Fix the rebuild

```dart
Column(
  children: [
    Padding(
      padding: EdgeInsets.all(16),
      child: Text('Settings'),
    ),
    Switch(value: isOn, onChanged: (v) => setState(() => isOn = v)),
  ],
)
```

Name two changes that reduce rebuild work.

### Problem 3: Key or no key?

Which of these need keys: a static `AppBar`, rows of a reorderable todo list, a `Divider`, the tabs of a `TabBar`?

### Problem 4: Choose the list

You must render 8000 chat messages with a separator between each. Which widget, and what is the mistake to avoid?

---

## Assignment Answers

### Problem 1: Method or class?

A widget class. It is reused in three places, so making it a class means one definition, a `const` constructor, and independent rebuild skipping. Helper methods cannot be shared across files cleanly and cannot be `const`.

### Problem 2: Fix the rebuild

1. Add `const` to the `Padding` (and its `EdgeInsets` and `Text`), so that subtree is skipped on every rebuild.
2. Move the `Switch` and its `setState` into its own small stateful widget, so toggling it does not rebuild the whole column.

### Problem 3: Key or no key?

- Static `AppBar`: no key
- Reorderable todo rows: yes, `ValueKey(todo.id)`
- `Divider`: no key
- `TabBar` tabs: no key (they are not reordered at runtime)

### Problem 4: Choose the list

`ListView.separated` with `itemCount: 8000`. The mistake to avoid is `shrinkWrap: true` (or building the children eagerly with `.map().toList()`), because that measures and builds all 8000 rows at once and freezes the frame.

---

## Navigation

⬅️ **Previous:** [Composition Over Inheritance](01a-CompositionOverInheritance.md)
⬆️ **Back to:** [Learning Path](00-LearningPath.md)
➡️ **Next:** [Responsive Foundations](01c-ResponsiveFoundations.md)
