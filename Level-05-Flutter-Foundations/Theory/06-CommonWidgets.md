# Common Widgets Reference Guide

This is your quick reference for the most commonly used Flutter widgets.

---

## Display Widgets

### Text

Display text with optional styling:

```dart
// Basic
Text('Hello, World!')

// With style
Text(
  'Styled Text',
  style: TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: Colors.blue,
    fontStyle: FontStyle.italic,
    letterSpacing: 2.0,
    decoration: TextDecoration.underline,
  ),
)

// Multi-line handling
Text(
  'This is a very long text that might need multiple lines',
  maxLines: 2,
  overflow: TextOverflow.ellipsis,  // ... at the end
  textAlign: TextAlign.center,
)

// Rich text (multiple styles)
RichText(
  text: TextSpan(
    text: 'Hello ',
    style: TextStyle(color: Colors.black),
    children: [
      TextSpan(
        text: 'World',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
    ],
  ),
)
```

### Icon

Display Material icons:

```dart
// Basic
Icon(Icons.favorite)

// With style
Icon(
  Icons.star,
  size: 48,
  color: Colors.amber,
)

// Common icons
Icons.home
Icons.search
Icons.menu
Icons.close
Icons.add
Icons.delete
Icons.edit
Icons.settings
Icons.person
Icons.email
Icons.phone
Icons.location_on
Icons.favorite
Icons.favorite_border
Icons.arrow_back
Icons.arrow_forward
Icons.check
Icons.error
Icons.warning
Icons.info
```

### Image

Display images from various sources:

```dart
// From assets (add to pubspec.yaml first)
Image.asset('assets/images/photo.png')

// From network
Image.network('https://example.com/image.jpg')

// With properties
Image.asset(
  'assets/logo.png',
  width: 200,
  height: 200,
  fit: BoxFit.cover,      // How to fit in box
)

// Fit options:
// BoxFit.contain - Fit inside, may have empty space
// BoxFit.cover   - Fill box, may crop
// BoxFit.fill    - Stretch to fill
// BoxFit.none    - No resizing
// BoxFit.scaleDown - Scale down only if needed

// With placeholder while loading
Image.network(
  'https://example.com/image.jpg',
  loadingBuilder: (context, child, progress) {
    if (progress == null) return child;
    return CircularProgressIndicator();
  },
  errorBuilder: (context, error, stackTrace) {
    return Icon(Icons.error);
  },
)
```

### CircleAvatar

Circular image/initial display:

```dart
// With image
CircleAvatar(
  radius: 30,
  backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
)

// With initial
CircleAvatar(
  radius: 30,
  backgroundColor: Colors.blue,
  child: Text('AB'),
)
```

---

## Layout Widgets

### Container

Versatile box widget:

```dart
Container(
  width: 200,
  height: 100,
  margin: EdgeInsets.all(10),
  padding: EdgeInsets.all(16),
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(10),
    border: Border.all(color: Colors.black, width: 2),
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.5),
        blurRadius: 5,
        offset: Offset(2, 2),
      ),
    ],
    gradient: LinearGradient(
      colors: [Colors.blue, Colors.purple],
    ),
  ),
  child: Text('Content'),
)
```

### Row

Horizontal layout:

```dart
Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: [
    Icon(Icons.star),
    Text('Rating'),
    Text('4.5'),
  ],
)
```

### Column

Vertical layout:

```dart
Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text('Title'),
    Text('Subtitle'),
    Text('Description'),
  ],
)
```

### Stack

Overlapping widgets:

```dart
Stack(
  children: [
    Image.asset('background.jpg'),
    Positioned(
      bottom: 10,
      right: 10,
      child: Text('Overlay'),
    ),
  ],
)
```

### SizedBox

Exact sizing and spacing:

```dart
// Fixed size
SizedBox(
  width: 100,
  height: 50,
  child: ElevatedButton(...),
)

// Spacing
Column(
  children: [
    Text('First'),
    SizedBox(height: 20),  // 20px gap
    Text('Second'),
  ],
)
```

### Padding

Add space around widget:

```dart
Padding(
  padding: EdgeInsets.all(16),
  child: Text('Padded text'),
)

// EdgeInsets options
EdgeInsets.all(16)
EdgeInsets.symmetric(horizontal: 20, vertical: 10)
EdgeInsets.only(left: 10, top: 20)
EdgeInsets.fromLTRB(10, 20, 10, 20)
```

### Center

Center child widget:

```dart
Center(
  child: Text('Centered'),
)
```

### Expanded

Fill available space:

```dart
Row(
  children: [
    Text('Label'),
    Expanded(
      child: TextField(),  // Takes remaining space
    ),
  ],
)
```

### Flexible

Optionally expand:

```dart
Row(
  children: [
    Flexible(
      flex: 2,
      child: Container(color: Colors.red),
    ),
    Flexible(
      flex: 1,
      child: Container(color: Colors.blue),
    ),
  ],
)
```

### Wrap

Flow to next line when full:

```dart
Wrap(
  spacing: 8,          // Horizontal gap
  runSpacing: 8,       // Vertical gap
  children: [
    Chip(label: Text('Flutter')),
    Chip(label: Text('Dart')),
    Chip(label: Text('Mobile')),
    Chip(label: Text('Development')),
  ],
)
```

---

## Button Widgets

### ElevatedButton

Raised button with shadow:

```dart
ElevatedButton(
  onPressed: () {
    print('Pressed!');
  },
  style: ElevatedButton.styleFrom(
    backgroundColor: Colors.blue,
    foregroundColor: Colors.white,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(8),
    ),
  ),
  child: Text('Click Me'),
)

// With icon
ElevatedButton.icon(
  onPressed: () {},
  icon: Icon(Icons.save),
  label: Text('Save'),
)

// Disabled
ElevatedButton(
  onPressed: null,  // null = disabled
  child: Text('Disabled'),
)
```

### TextButton

Flat text button:

```dart
TextButton(
  onPressed: () {},
  child: Text('Text Button'),
)
```

### OutlinedButton

Button with outline:

```dart
OutlinedButton(
  onPressed: () {},
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: Colors.blue),
  ),
  child: Text('Outlined'),
)
```

### IconButton

Button with just an icon:

```dart
IconButton(
  icon: Icon(Icons.favorite),
  color: Colors.red,
  iconSize: 30,
  onPressed: () {},
)
```

### FloatingActionButton

Floating circular button:

```dart
FloatingActionButton(
  onPressed: () {},
  child: Icon(Icons.add),
)

// Extended with label
FloatingActionButton.extended(
  onPressed: () {},
  icon: Icon(Icons.add),
  label: Text('Add Item'),
)
```

---

## Input Widgets

### TextField

Text input:

```dart
// Basic
TextField(
  decoration: InputDecoration(
    labelText: 'Username',
    hintText: 'Enter your username',
    prefixIcon: Icon(Icons.person),
    suffixIcon: Icon(Icons.clear),
    border: OutlineInputBorder(),
  ),
)

// With controller
final controller = TextEditingController();

TextField(
  controller: controller,
  onChanged: (value) {
    print('Text: $value');
  },
  onSubmitted: (value) {
    print('Submitted: $value');
  },
)

// Password
TextField(
  obscureText: true,
  decoration: InputDecoration(
    labelText: 'Password',
    prefixIcon: Icon(Icons.lock),
  ),
)

// Multi-line
TextField(
  maxLines: 5,
  decoration: InputDecoration(
    labelText: 'Description',
    alignLabelWithHint: true,
  ),
)
```

### Checkbox

Toggle checkbox:

```dart
// Stateful usage
bool isChecked = false;

Checkbox(
  value: isChecked,
  onChanged: (value) {
    setState(() {
      isChecked = value!;
    });
  },
)

// With label
CheckboxListTile(
  title: Text('Accept terms'),
  value: isChecked,
  onChanged: (value) {
    setState(() {
      isChecked = value!;
    });
  },
)
```

### Switch

Toggle switch:

```dart
bool isSwitched = false;

Switch(
  value: isSwitched,
  onChanged: (value) {
    setState(() {
      isSwitched = value;
    });
  },
)

// With label
SwitchListTile(
  title: Text('Enable notifications'),
  value: isSwitched,
  onChanged: (value) {
    setState(() {
      isSwitched = value;
    });
  },
)
```

### Radio

Radio button selection:

```dart
String selectedOption = 'option1';

Column(
  children: [
    RadioListTile<String>(
      title: Text('Option 1'),
      value: 'option1',
      groupValue: selectedOption,
      onChanged: (value) {
        setState(() {
          selectedOption = value!;
        });
      },
    ),
    RadioListTile<String>(
      title: Text('Option 2'),
      value: 'option2',
      groupValue: selectedOption,
      onChanged: (value) {
        setState(() {
          selectedOption = value!;
        });
      },
    ),
  ],
)
```

### Slider

Value slider:

```dart
double sliderValue = 50;

Slider(
  value: sliderValue,
  min: 0,
  max: 100,
  divisions: 10,
  label: sliderValue.round().toString(),
  onChanged: (value) {
    setState(() {
      sliderValue = value;
    });
  },
)
```

### DropdownButton

Dropdown selection:

```dart
String selectedValue = 'Apple';

DropdownButton<String>(
  value: selectedValue,
  items: ['Apple', 'Banana', 'Orange'].map((fruit) {
    return DropdownMenuItem(
      value: fruit,
      child: Text(fruit),
    );
  }).toList(),
  onChanged: (value) {
    setState(() {
      selectedValue = value!;
    });
  },
)
```

---

## List Widgets

### ListView

Scrollable list:

```dart
// Simple list
ListView(
  children: [
    ListTile(title: Text('Item 1')),
    ListTile(title: Text('Item 2')),
    ListTile(title: Text('Item 3')),
  ],
)

// Builder (for long lists)
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item $index'),
    );
  },
)

// Separated (with dividers)
ListView.separated(
  itemCount: 10,
  separatorBuilder: (context, index) => Divider(),
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item $index'));
  },
)
```

### ListTile

Standard list item:

```dart
ListTile(
  leading: CircleAvatar(child: Text('A')),
  title: Text('Title'),
  subtitle: Text('Subtitle'),
  trailing: Icon(Icons.chevron_right),
  onTap: () {},
)
```

### GridView

Grid of items:

```dart
GridView.count(
  crossAxisCount: 2,
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  padding: EdgeInsets.all(10),
  children: [
    Card(child: Center(child: Text('1'))),
    Card(child: Center(child: Text('2'))),
    Card(child: Center(child: Text('3'))),
    Card(child: Center(child: Text('4'))),
  ],
)

// Builder for dynamic content
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3,
    mainAxisSpacing: 10,
    crossAxisSpacing: 10,
  ),
  itemCount: 20,
  itemBuilder: (context, index) {
    return Card(child: Center(child: Text('$index')));
  },
)
```

---

## Card and Container Widgets

### Card

Material design card:

```dart
Card(
  elevation: 4,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(10),
  ),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Card Title'),
        Text('Card content goes here'),
      ],
    ),
  ),
)
```

### Chip

Compact element:

```dart
Chip(
  avatar: CircleAvatar(child: Text('A')),
  label: Text('Chip'),
  deleteIcon: Icon(Icons.close),
  onDeleted: () {},
)

// Action chip
ActionChip(
  label: Text('Action'),
  onPressed: () {},
)

// Filter chip
FilterChip(
  label: Text('Filter'),
  selected: true,
  onSelected: (selected) {},
)
```

---

## Navigation Widgets

### Scaffold

Basic app structure:

```dart
Scaffold(
  appBar: AppBar(
    title: Text('My App'),
    actions: [
      IconButton(icon: Icon(Icons.search), onPressed: () {}),
    ],
  ),
  body: Center(
    child: Text('Content'),
  ),
  floatingActionButton: FloatingActionButton(
    onPressed: () {},
    child: Icon(Icons.add),
  ),
  bottomNavigationBar: BottomNavigationBar(
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
    ],
  ),
  drawer: Drawer(
    child: ListView(
      children: [
        DrawerHeader(child: Text('Menu')),
        ListTile(title: Text('Item 1')),
      ],
    ),
  ),
)
```

### AppBar

Top app bar:

```dart
AppBar(
  leading: IconButton(
    icon: Icon(Icons.menu),
    onPressed: () {},
  ),
  title: Text('Title'),
  centerTitle: true,
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
    IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
  ],
  backgroundColor: Colors.blue,
  elevation: 4,
)
```

### BottomNavigationBar

Bottom navigation:

```dart
int selectedIndex = 0;

BottomNavigationBar(
  currentIndex: selectedIndex,
  onTap: (index) {
    setState(() {
      selectedIndex = index;
    });
  },
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.search),
      label: 'Search',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
)
```

### TabBar

Tabbed navigation:

```dart
DefaultTabController(
  length: 3,
  child: Scaffold(
    appBar: AppBar(
      bottom: TabBar(
        tabs: [
          Tab(text: 'Tab 1'),
          Tab(text: 'Tab 2'),
          Tab(text: 'Tab 3'),
        ],
      ),
    ),
    body: TabBarView(
      children: [
        Center(child: Text('Content 1')),
        Center(child: Text('Content 2')),
        Center(child: Text('Content 3')),
      ],
    ),
  ),
)
```

---

## Dialog and Feedback Widgets

### AlertDialog

Show dialog:

```dart
showDialog(
  context: context,
  builder: (context) {
    return AlertDialog(
      title: Text('Title'),
      content: Text('This is the message'),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            // Do something
            Navigator.pop(context);
          },
          child: Text('OK'),
        ),
      ],
    );
  },
);
```

### SnackBar

Show temporary message:

```dart
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text('Message'),
    action: SnackBarAction(
      label: 'Undo',
      onPressed: () {},
    ),
    duration: Duration(seconds: 3),
  ),
);
```

### CircularProgressIndicator

Loading spinner:

```dart
// Indeterminate (spinning)
CircularProgressIndicator()

// Determinate (shows progress)
CircularProgressIndicator(
  value: 0.7,  // 70% complete
)

// With color
CircularProgressIndicator(
  color: Colors.blue,
  strokeWidth: 3,
)
```

### LinearProgressIndicator

Progress bar:

```dart
// Indeterminate
LinearProgressIndicator()

// Determinate
LinearProgressIndicator(
  value: 0.5,  // 50% complete
)
```

---

## Gesture Widgets

### GestureDetector

Detect gestures:

```dart
GestureDetector(
  onTap: () => print('Tapped'),
  onDoubleTap: () => print('Double tapped'),
  onLongPress: () => print('Long pressed'),
  onPanUpdate: (details) => print('Dragging'),
  child: Container(
    color: Colors.blue,
    width: 100,
    height: 100,
  ),
)
```

### InkWell

Tap with ripple effect:

```dart
InkWell(
  onTap: () => print('Tapped'),
  splashColor: Colors.blue.withOpacity(0.3),
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('Tap me'),
  ),
)
```

---

## Utility Widgets

### Visibility

Show/hide widget:

```dart
Visibility(
  visible: isVisible,  // true/false
  child: Text('I might be hidden'),
)
```

### Opacity

Make widget transparent:

```dart
Opacity(
  opacity: 0.5,  // 0.0 to 1.0
  child: Text('50% visible'),
)
```

### IgnorePointer

Disable touch:

```dart
IgnorePointer(
  ignoring: true,
  child: ElevatedButton(...),  // Can't be tapped
)
```

### SafeArea

Avoid system UI:

```dart
SafeArea(
  child: Column(
    children: [/* content */],
  ),
)
```

---

## Summary Table

| Category | Widgets |
|----------|---------|
| Display | Text, Icon, Image, CircleAvatar |
| Layout | Container, Row, Column, Stack, SizedBox, Padding |
| Buttons | ElevatedButton, TextButton, IconButton, FAB |
| Input | TextField, Checkbox, Switch, Slider, Dropdown |
| Lists | ListView, ListTile, GridView |
| Cards | Card, Chip |
| Navigation | Scaffold, AppBar, BottomNavigationBar, Drawer |
| Feedback | AlertDialog, SnackBar, Progress indicators |
| Gesture | GestureDetector, InkWell |

---

**Next:** Practice with example apps!

---

**Continue to:** `../Examples/Example01-HelloFlutter.dart`
