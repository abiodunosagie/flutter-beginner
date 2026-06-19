# List Widgets: Showing Scrollable Lists

## The Big Idea In One Sentence

> `ListView` shows a scrollable column of items, `ListView.builder` does it efficiently for long or data-driven lists, and `ListTile` is the ready-made row for each item.

Most apps are lists: chats, contacts, products, settings. This is how you build them.

---

## For A 5-Year-Old

A `Column` shows a few things stacked up, but it cannot scroll. A `ListView` is like a Column that **scrolls** when there are too many things to fit. Perfect for long lists.

---

## ListView: A Scrolling Column

The simplest form takes a list of `children`, just like a Column, but it scrolls:

```dart
ListView(
  children: const [
    ListTile(title: Text('First')),
    ListTile(title: Text('Second')),
    ListTile(title: Text('Third')),
  ],
)
```

Use plain `ListView` when you have a small, fixed number of items.

---

## ListTile: The Standard Row

`ListTile` is a ready-made row, perfect for list items. It has handy slots:

```dart
ListTile(
  leading: const Icon(Icons.person),   // at the start
  title: const Text('Ada Bello'),      // the main text
  subtitle: const Text('Online'),      // smaller text under the title
  trailing: const Icon(Icons.chevron_right),  // at the end
  onTap: () {
    print('Tapped Ada');
  },
)
```

- `leading`: a widget at the left (often an icon or avatar).
- `title`: the main line.
- `subtitle`: a smaller second line.
- `trailing`: a widget at the right (often an arrow or icon).
- `onTap`: runs when the row is tapped.

You will use `ListTile` constantly inside lists.

---

## ListView.builder: For Long Or Data-Driven Lists

When you have many items, or a list that comes from data, use `ListView.builder`. Instead of writing every child by hand, you tell it **how many** items and **how to build one**.

```dart
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item ${index + 1}'));
  },
)
```

- `itemCount` is how many rows there are.
- `itemBuilder` is a function Flutter calls for each row, giving you the `index` (0, 1, 2, ...). You return the widget for that row.

Why `.builder`? It only builds the rows that are **on screen**, so it stays fast even with thousands of items. Plain `ListView` builds them all at once.

### Building From A List Of Data

The real use: turn a `List` (from Level 3) into rows.

```dart
class ContactsList extends StatelessWidget {
  const ContactsList({super.key});

  final List<String> names = const ['Ada', 'Bola', 'Chidi', 'Dapo'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: names.length,
      itemBuilder: (context, index) {
        final name = names[index];
        return ListTile(
          leading: CircleAvatar(child: Text(name[0])),  // first letter
          title: Text(name),
        );
      },
    );
  }
}
```

`itemCount` is `names.length`, and for each `index` we read `names[index]` and make a row for it. Add a name to the list and a new row appears automatically.

---

## ListView.separated: Lines Between Items

If you want a divider line between rows, `ListView.separated` adds one between each item:

```dart
ListView.separated(
  itemCount: 5,
  itemBuilder: (context, index) => ListTile(title: Text('Row $index')),
  separatorBuilder: (context, index) => const Divider(),
)
```

It is like `ListView.builder` with an extra `separatorBuilder` for the thing between rows.

---

## GridView: A Grid Instead Of A List

When you want a grid (like a photo gallery), use `GridView.count`. You tell it how many columns with `crossAxisCount`:

```dart
GridView.count(
  crossAxisCount: 2,   // two columns
  children: const [
    Card(child: Center(child: Text('A'))),
    Card(child: Center(child: Text('B'))),
    Card(child: Center(child: Text('C'))),
    Card(child: Center(child: Text('D'))),
  ],
)
```

`crossAxisCount: 2` makes two columns, and the items flow into the grid. (`Card` is a simple raised box; you meet it properly in `06d`.)

---

## The Top Mistakes Beginners Make

### Mistake 1: Putting a ListView straight inside a Column

```dart
Column(
  children: [
    const Text('Title'),
    ListView(children: const [...]),   // BAD: error, the ListView has no height limit
  ],
)
```

A `ListView` inside a `Column` does not know how tall to be, which causes an error. Wrap it in `Expanded` so it fills the leftover space (remember `Expanded` from 05b):

```dart
Column(
  children: [
    const Text('Title'),
    Expanded(child: ListView(children: const [...])),   // GOOD
  ],
)
```

### Mistake 2: Forgetting itemCount in .builder

`ListView.builder` needs `itemCount` so it knows how many rows to make.

### Mistake 3: Using plain ListView for a huge list

For long or data-driven lists, use `ListView.builder`. Plain `ListView` builds everything at once and can be slow.

### Mistake 4: Wrong index

`itemBuilder`'s `index` starts at 0. The first item is `names[0]`, not `names[1]`.

---

## One-Minute Recap

- `ListView` is a scrolling column of `children` (good for a few items).
- `ListTile` is the ready-made row: `leading`, `title`, `subtitle`, `trailing`, `onTap`.
- `ListView.builder` (with `itemCount` and `itemBuilder`) is efficient for long or data-driven lists; it builds only visible rows.
- `ListView.separated` adds a divider between rows.
- `GridView.count(crossAxisCount: n, ...)` makes an n-column grid.
- A `ListView` inside a `Column` needs `Expanded` to give it a height.

---

## Quick Quiz

**Q1.** When should you use `ListView.builder` instead of plain `ListView`?

<details>
<summary>Answer</summary>
For long lists or lists built from data. It only builds the rows that are on screen, so it stays fast.
</details>

**Q2.** What does `itemBuilder` give you, and what must it return?

<details>
<summary>Answer</summary>
It gives you the `index` of the row (starting at 0), and you return the widget for that row.
</details>

**Q3.** What are the four content slots of a ListTile?

<details>
<summary>Answer</summary>
`leading`, `title`, `subtitle`, and `trailing` (plus `onTap` for taps).
</details>

**Q4.** Why does a ListView inside a Column cause an error, and how do you fix it?

<details>
<summary>Answer</summary>
The ListView has no height limit inside a Column. Wrap it in `Expanded` so it fills the leftover space.
</details>

---

## Assignment

Paste into [dartpad.dev](https://dartpad.dev). Use a full Scaffold so the list has room: `Scaffold(body: YOUR_LIST)`.

### Problem 1: A simple list

Build a `ListView` with three `ListTile`s titled `'Home'`, `'Settings'`, and `'About'`, each with a matching leading icon.

### Problem 2: A list from data

Given `List<String> fruits = ['Apple', 'Banana', 'Cherry'];`, build a `ListView.builder` that shows one `ListTile` per fruit (the fruit as the title).

### Problem 3: A tappable contact row

Build a `ListTile` with a person icon as `leading`, `'Ada'` as the title, `'Online'` as the subtitle, a call icon as `trailing`, and an `onTap` that prints `'Calling Ada'`.

### Problem 4: A 2-column grid

Build a `GridView.count` with 2 columns and four coloured `Container`s.

### Problem 5: Spot the bug

Why does this throw an error, and how do you fix it?

```dart
Column(
  children: [
    const Text('My list'),
    ListView(
      children: const [ListTile(title: Text('A')), ListTile(title: Text('B'))],
    ),
  ],
)
```

---

## Assignment Answers

### Problem 1: A simple list

```dart
ListView(
  children: const [
    ListTile(leading: Icon(Icons.home), title: Text('Home')),
    ListTile(leading: Icon(Icons.settings), title: Text('Settings')),
    ListTile(leading: Icon(Icons.info), title: Text('About')),
  ],
)
```

Each row is a `ListTile` with a `leading` icon and a `title`.

### Problem 2: A list from data

```dart
class FruitList extends StatelessWidget {
  const FruitList({super.key});

  final List<String> fruits = const ['Apple', 'Banana', 'Cherry'];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: fruits.length,
      itemBuilder: (context, index) {
        return ListTile(title: Text(fruits[index]));
      },
    );
  }
}
```

`itemCount` is the list length, and `itemBuilder` makes a row for each `index` using `fruits[index]`.

### Problem 3: A tappable contact row

```dart
ListTile(
  leading: const Icon(Icons.person),
  title: const Text('Ada'),
  subtitle: const Text('Online'),
  trailing: const Icon(Icons.call),
  onTap: () => print('Calling Ada'),
)
```

Each slot fills a part of the row, and `onTap` runs when the row is tapped.

### Problem 4: A 2-column grid

```dart
GridView.count(
  crossAxisCount: 2,
  children: [
    Container(color: Colors.red),
    Container(color: Colors.green),
    Container(color: Colors.blue),
    Container(color: Colors.amber),
  ],
)
```

`crossAxisCount: 2` makes two columns, and the four containers fill the grid.

### Problem 5: Spot the bug

A `ListView` inside a `Column` has no height limit, which causes an error. Wrap the ListView in `Expanded` so it takes the leftover height:

```dart
Column(
  children: [
    const Text('My list'),
    Expanded(
      child: ListView(
        children: const [ListTile(title: Text('A')), ListTile(title: Text('B'))],
      ),
    ),
  ],
)
```

Now the ListView fills the space below the title and scrolls if needed.

---

**Next:** `06d-CardDialogWidgets.md`, the last widget lesson, covering cards, dialogs, and snackbars.
