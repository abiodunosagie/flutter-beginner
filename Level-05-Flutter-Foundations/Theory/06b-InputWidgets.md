# Input Widgets: Letting The User Type And Choose

## The Big Idea In One Sentence

> Input widgets collect what the user types or picks: `TextField` for text, `Checkbox`/`Switch` for yes/no, `Slider` for a number, `Dropdown` for one choice from a list.

These all live inside stateful widgets, because the value changes as the user interacts.

---

## TextField: Typing Text

The most important input. At its simplest:

```dart
TextField(
  decoration: InputDecoration(
    labelText: 'Username',
    hintText: 'Type your username',
  ),
)
```

- `labelText` floats above the field as a label.
- `hintText` is the faint placeholder shown when the field is empty.

### Reading What The User Typed: A Controller

To get the text out, attach a `TextEditingController`. You create it, attach it, read `.text`, and (using what you learned in `04b`) dispose it.

```dart
import 'package:flutter/material.dart';

class NameInput extends StatefulWidget {
  const NameInput({super.key});

  @override
  State<NameInput> createState() => _NameInputState();
}

class _NameInputState extends State<NameInput> {
  final controller = TextEditingController();
  String saved = '';

  @override
  void dispose() {
    controller.dispose();   // clean up the controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Name'),
        ),
        ElevatedButton(
          onPressed: () {
            setState(() {
              saved = controller.text;   // read what was typed
            });
          },
          child: const Text('Save'),
        ),
        Text('You typed: $saved'),
      ],
    );
  }
}
```

`controller.text` gives the current text. We read it on the button tap and show it. Remember to `dispose` the controller, just like the timer in the lifecycle lesson.

### Reacting As The User Types: onChanged

If you want to react on every keystroke, use `onChanged` instead of (or as well as) a controller:

```dart
TextField(
  onChanged: (value) {
    print('Now typing: $value');
  },
)
```

`onChanged` gives you the current text every time it changes.

---

## Checkbox: A Yes/No Box

A `Checkbox` is ticked or not. Its `value` is a bool you keep in state, and `onChanged` gives you the new value.

```dart
class _AgreeState extends State<Agree> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: agreed,
      onChanged: (newValue) {
        setState(() {
          agreed = newValue ?? false;
        });
      },
    );
  }
}
```

The pattern is always the same: store a bool, show it as `value`, and update it in `onChanged` with `setState`. (`newValue` is nullable, so we use `?? false`.)

---

## Switch: A Toggle

A `Switch` is the on/off slider. It works exactly like a Checkbox: a bool `value` plus `onChanged`.

```dart
Switch(
  value: isOn,
  onChanged: (newValue) {
    setState(() {
      isOn = newValue;
    });
  },
)
```

Use a Switch for settings (on/off), a Checkbox for "tick to agree" style choices.

---

## Slider: Pick A Number

A `Slider` lets the user drag to choose a number between a `min` and a `max`. The `value` is a `double` in state.

```dart
class _VolumeState extends State<Volume> {
  double volume = 50;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Volume: ${volume.toInt()}'),
        Slider(
          value: volume,
          min: 0,
          max: 100,
          onChanged: (newValue) {
            setState(() {
              volume = newValue;
            });
          },
        ),
      ],
    );
  }
}
```

Dragging the slider calls `onChanged` with the new number, and `setState` updates the label.

---

## Dropdown: Pick One From A List

`DropdownButton` shows a menu of choices. You keep the selected value in state.

```dart
class _PickState extends State<Pick> {
  String fruit = 'Apple';

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: fruit,
      items: const [
        DropdownMenuItem(value: 'Apple', child: Text('Apple')),
        DropdownMenuItem(value: 'Banana', child: Text('Banana')),
        DropdownMenuItem(value: 'Cherry', child: Text('Cherry')),
      ],
      onChanged: (newValue) {
        setState(() {
          fruit = newValue!;
        });
      },
    );
  }
}
```

Each choice is a `DropdownMenuItem` with a `value` and what to show. Picking one calls `onChanged` with that value.

> When you have many fields together and want to **check** them (like "email must contain @"), Flutter has a `Form` with validation. That is its own topic in Level 9. For now, these basic inputs are what you need.

---

## The Pattern Behind All Of Them

Notice every input follows the same shape:

1. Keep the current value in state.
2. Show it as the widget's `value`.
3. Update it in `onChanged` with `setState`.

Learn that pattern once and every input widget feels familiar.

---

## The Top Mistakes Beginners Make

### Mistake 1: Not updating state in onChanged

```dart
Switch(value: isOn, onChanged: (v) { isOn = v; })   // BAD: no setState, the switch will not move
Switch(value: isOn, onChanged: (v) => setState(() => isOn = v))   // GOOD
```

### Mistake 2: Forgetting to dispose a controller

A `TextEditingController` should be disposed in `dispose`, like the timer in lesson 04b.

### Mistake 3: Using a controller in a StatelessWidget

Inputs that hold changing values need a StatefulWidget. A controller and `setState` cannot live in a StatelessWidget.

### Mistake 4: Ignoring the nullable in Checkbox onChanged

`Checkbox`'s `onChanged` gives a `bool?` (nullable). Use `?? false` or `value!`.

---

## One-Minute Recap

- `TextField` collects text. Use a `TextEditingController` to read `.text` (and dispose it), or `onChanged` to react live.
- `Checkbox` and `Switch` are yes/no: a bool `value` plus `onChanged` that calls `setState`.
- `Slider` picks a number (a `double`) between `min` and `max`.
- `DropdownButton` picks one value from a list of `DropdownMenuItem`s.
- Every input: keep the value in state, show it as `value`, update it in `onChanged`.

---

## Quick Quiz

**Q1.** How do you read what a user typed in a TextField?

<details>
<summary>Answer</summary>
Attach a `TextEditingController` and read `controller.text`. (Or use `onChanged` to get the value as they type.)
</details>

**Q2.** What three steps does every input widget follow?

<details>
<summary>Answer</summary>
Keep the value in state, show it as the widget's `value`, and update it in `onChanged` with `setState`.
</details>

**Q3.** Why must inputs live in a StatefulWidget?

<details>
<summary>Answer</summary>
Because their value changes, and `setState` (which updates the screen) only works in a StatefulWidget.
</details>

**Q4.** What should you do with a TextEditingController when the widget is removed?

<details>
<summary>Answer</summary>
Dispose it in `dispose` (`controller.dispose();`), like cleaning up a timer.
</details>

---

## Assignment

Paste into [dartpad.dev](https://dartpad.dev), wrapping in `Scaffold(body: Center(child: ...))`.

### Problem 1: Echo what is typed

Build a `StatefulWidget` with a `TextField` and a button. When tapped, show the text the user typed in a `Text` below. Use a controller and dispose it.

### Problem 2: A live greeting

Build a `TextField` that uses `onChanged` to show `'Hello, <typed text>'` updating as the user types.

### Problem 3: An agree checkbox

Build a `Checkbox` with a bool `agreed` (start false). Show `'Agreed: true'` or `'Agreed: false'` next to it, updating when ticked.

### Problem 4: A volume slider

Build a `Slider` from 0 to 100 with a starting value of 30. Show the current value (as a whole number) above it.

### Problem 5: Spot the bug

Why does this switch never move when tapped?

```dart
Switch(
  value: isOn,
  onChanged: (v) {
    isOn = v;
  },
)
```

---

## Assignment Answers

### Problem 1: Echo what is typed

```dart
import 'package:flutter/material.dart';

class Echo extends StatefulWidget {
  const Echo({super.key});

  @override
  State<Echo> createState() => _EchoState();
}

class _EchoState extends State<Echo> {
  final controller = TextEditingController();
  String shown = '';

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(controller: controller, decoration: const InputDecoration(labelText: 'Say something')),
        ElevatedButton(
          onPressed: () => setState(() => shown = controller.text),
          child: const Text('Show'),
        ),
        Text(shown),
      ],
    );
  }
}
```

The button reads `controller.text` into state and rebuilds, so the typed text appears below. The controller is disposed when the widget goes away.

### Problem 2: A live greeting

```dart
class _LiveState extends State<Live> {
  String name = '';

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          onChanged: (value) => setState(() => name = value),
        ),
        Text('Hello, $name'),
      ],
    );
  }
}
```

`onChanged` runs on every keystroke, updating `name` and rebuilding, so the greeting changes as you type.

### Problem 3: An agree checkbox

```dart
class _AgreeState extends State<Agree> {
  bool agreed = false;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: agreed,
          onChanged: (v) => setState(() => agreed = v ?? false),
        ),
        Text('Agreed: $agreed'),
      ],
    );
  }
}
```

The bool `agreed` is the `value`. Ticking it calls `onChanged`, which updates the state (handling the nullable with `?? false`).

### Problem 4: A volume slider

```dart
class _VolumeState extends State<Volume> {
  double volume = 30;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text('Volume: ${volume.toInt()}'),
        Slider(
          value: volume,
          min: 0,
          max: 100,
          onChanged: (v) => setState(() => volume = v),
        ),
      ],
    );
  }
}
```

The slider's `value` is the `double volume`. Dragging calls `onChanged`, and `setState` updates the label. `.toInt()` shows it as a whole number.

### Problem 5: Spot the bug

The `onChanged` changes `isOn` but never calls `setState`, so the screen does not rebuild and the switch stays where it was. Fix:

```dart
Switch(
  value: isOn,
  onChanged: (v) => setState(() => isOn = v),
)
```

Now the switch actually moves, because `setState` rebuilds it with the new value.

---

**Next:** `06c-ListWidgets.md`, where you show long scrollable lists with ListView.
