# Level 05 PART 6d: Card and Dialog Widgets - Material Design UI

## For a 5-Year-Old

Imagine you're making a popup book:
- **Cards** are like pages with raised edges that pop out
- **Dialogs** are like sticky notes that pop up when you open certain pages
- **Chips** are like small badges or stickers on the pages
- **Bottom sheets** slide up from the bottom like a drawer

Flutter gives you ALL these cool popup and card widgets! They make your app look professional and help organize information. Let's learn them all!

---

## Widget Types Overview

| Widget | What It Does | Best For |
|--------|--------------|----------|
| **Card** | Raised container with shadow | Grouping related info |
| **AlertDialog** | Popup with message and buttons | Confirmations, alerts |
| **SimpleDialog** | Choose from options | Selecting from a list |
| **BottomSheet** | Slides up from bottom | More options, settings |
| **Chip** | Compact element | Tags, filters |
| **Badge** | Small notification indicator | Unread counts |
| **Tooltip** | Hint on hover/long press | Helpful hints |

---

## Card - Material Design Card

**Best for:** Grouping related information with elevation

### Basic Card

```dart
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Text('This is a card'),
  ),
)
```

### Card with All Options

```dart
Card(
  // Elevation (shadow depth)
  elevation: 8,

  // Shadow color
  shadowColor: Colors.blue.withOpacity(0.5),

  // Shape
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
    side: BorderSide(color: Colors.blue, width: 2),
  ),

  // Margin
  margin: EdgeInsets.all(16),

  // Background color
  color: Colors.white,

  // Clip behavior
  clipBehavior: Clip.antiAlias,

  child: Column(
    children: [
      ListTile(
        leading: Icon(Icons.album),
        title: Text('Card Title'),
        subtitle: Text('Card subtitle'),
      ),
      Image.network('https://picsum.photos/400/200'),
      Padding(
        padding: EdgeInsets.all(16),
        child: Text('Card content goes here'),
      ),
    ],
  ),
)
```

### Common Card Patterns

```dart
// Product card
Card(
  clipBehavior: Clip.antiAlias,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Image.network(
        'https://picsum.photos/400/200',
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
      Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Product Name',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\$29.99',
              style: TextStyle(
                fontSize: 16,
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text('Product description goes here'),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {},
                  child: Text('DETAILS'),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('BUY'),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
)

// User profile card
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Row(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
        ),
        SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'John Doe',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('Software Developer'),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.location_on, size: 16),
                  SizedBox(width: 4),
                  Text('San Francisco, CA'),
                ],
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    ),
  ),
)

// Stats card
Card(
  color: Colors.blue,
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.trending_up, color: Colors.white),
            SizedBox(width: 8),
            Text(
              'Total Sales',
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          '\$12,345',
          style: TextStyle(
            color: Colors.white,
            fontSize: 32,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          '+12.5% from last month',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    ),
  ),
)
```

---

## AlertDialog - Standard Popup Dialog

**Best for:** Confirmations, alerts, simple inputs

### Basic AlertDialog

```dart
void _showBasicDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Dialog Title'),
        content: Text('This is the dialog message.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      );
    },
  );
}
```

### Confirmation Dialog

```dart
void _showConfirmDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('Are you sure you want to delete this item?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              // Delete item
              print('Item deleted');
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: Text('DELETE'),
          ),
        ],
      );
    },
  );
}
```

### Dialog with TextField

```dart
void _showInputDialog(BuildContext context) {
  final TextEditingController controller = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Enter Name'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Your name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              String name = controller.text;
              print('Name: $name');
              Navigator.pop(context);
            },
            child: Text('SUBMIT'),
          ),
        ],
      );
    },
  );
}
```

### Dialog with Custom Content

```dart
void _showCustomDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.orange),
            SizedBox(width: 8),
            Text('Warning'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'This action cannot be undone.',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('Please confirm that you want to proceed.'),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.all(12),
              color: Colors.orange.withOpacity(0.1),
              child: Row(
                children: [
                  Icon(Icons.info_outline, size: 20),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'All data will be permanently deleted.',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('CANCEL'),
          ),
          ElevatedButton(
            onPressed: () {
              // Proceed
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
            ),
            child: Text('PROCEED'),
          ),
        ],
      );
    },
  );
}
```

---

## SimpleDialog - Choose from Options

**Best for:** Selecting from a list of options

### Basic SimpleDialog

```dart
void _showSimpleDialog(BuildContext context) async {
  final String? result = await showDialog<String>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text('Choose an option'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'option1');
            },
            child: Text('Option 1'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'option2');
            },
            child: Text('Option 2'),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'option3');
            },
            child: Text('Option 3'),
          ),
        ],
      );
    },
  );

  if (result != null) {
    print('Selected: $result');
  }
}
```

### SimpleDialog with Icons

```dart
void _showAccountDialog(BuildContext context) async {
  final String? result = await showDialog<String>(
    context: context,
    builder: (context) {
      return SimpleDialog(
        title: Text('Select account'),
        children: [
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'personal');
            },
            child: Row(
              children: [
                CircleAvatar(child: Icon(Icons.person)),
                SizedBox(width: 16),
                Text('Personal Account'),
              ],
            ),
          ),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'work');
            },
            child: Row(
              children: [
                CircleAvatar(child: Icon(Icons.business)),
                SizedBox(width: 16),
                Text('Work Account'),
              ],
            ),
          ),
          Divider(),
          SimpleDialogOption(
            onPressed: () {
              Navigator.pop(context, 'add');
            },
            child: Row(
              children: [
                CircleAvatar(child: Icon(Icons.add)),
                SizedBox(width: 16),
                Text('Add Account'),
              ],
            ),
          ),
        ],
      );
    },
  );

  if (result != null) {
    print('Selected: $result');
  }
}
```

---

## BottomSheet - Slide Up Panel

**Best for:** More options, filters, settings

### Modal BottomSheet (Dark Background)

```dart
void _showBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Icons.share),
              title: Text('Share'),
              onTap: () {
                Navigator.pop(context);
                print('Share');
              },
            ),
            ListTile(
              leading: Icon(Icons.link),
              title: Text('Copy Link'),
              onTap: () {
                Navigator.pop(context);
                print('Copy link');
              },
            ),
            ListTile(
              leading: Icon(Icons.download),
              title: Text('Download'),
              onTap: () {
                Navigator.pop(context);
                print('Download');
              },
            ),
          ],
        ),
      );
    },
  );
}
```

### Rounded BottomSheet

```dart
void _showRoundedBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        top: Radius.circular(20),
      ),
    ),
    builder: (context) {
      return Container(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 16),
            Text(
              'More Options',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Colors.red),
              title: Text('Delete', style: TextStyle(color: Colors.red)),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      );
    },
  );
}
```

### Full Screen BottomSheet

```dart
void _showFullBottomSheet(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow custom height
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.9, // 90% of screen
        minChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (context, scrollController) {
          return Container(
            padding: EdgeInsets.all(16),
            child: ListView.builder(
              controller: scrollController,
              itemCount: 50,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text('Item ${index + 1}'),
                );
              },
            ),
          );
        },
      );
    },
  );
}
```

---

## Chip - Compact Elements

**Best for:** Tags, filters, selections

### Basic Chip

```dart
Chip(
  label: Text('Flutter'),
  avatar: CircleAvatar(
    child: Text('F'),
  ),
)
```

### Chip with Delete

```dart
Chip(
  label: Text('Removable Tag'),
  deleteIcon: Icon(Icons.close),
  onDeleted: () {
    print('Chip deleted');
  },
)
```

### ActionChip (Tappable)

```dart
ActionChip(
  label: Text('Action'),
  avatar: Icon(Icons.star),
  onPressed: () {
    print('Action chip pressed');
  },
)
```

### FilterChip (Selectable)

```dart
class FilterChipExample extends StatefulWidget {
  @override
  State<FilterChipExample> createState() => _FilterChipExampleState();
}

class _FilterChipExampleState extends State<FilterChipExample> {
  bool isSelected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text('Filter'),
      selected: isSelected,
      onSelected: (bool selected) {
        setState(() {
          isSelected = selected;
        });
      },
      selectedColor: Colors.blue,
    );
  }
}
```

### ChoiceChip (Pick One)

```dart
class ChoiceChipExample extends StatefulWidget {
  @override
  State<ChoiceChipExample> createState() => _ChoiceChipExampleState();
}

class _ChoiceChipExampleState extends State<ChoiceChipExample> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: List.generate(4, (index) {
        return ChoiceChip(
          label: Text('Option ${index + 1}'),
          selected: selectedIndex == index,
          onSelected: (selected) {
            setState(() {
              selectedIndex = index;
            });
          },
        );
      }),
    );
  }
}
```

### InputChip (With Avatar and Delete)

```dart
InputChip(
  avatar: CircleAvatar(
    backgroundImage: NetworkImage('https://i.pravatar.cc/150'),
  ),
  label: Text('John Doe'),
  deleteIcon: Icon(Icons.close),
  onDeleted: () {
    print('Deleted');
  },
  onPressed: () {
    print('Pressed');
  },
)
```

---

## Badge - Notification Indicator

**Best for:** Unread counts, notifications (Material 3)

### Basic Badge

```dart
Badge(
  child: Icon(Icons.notifications),
)
```

### Badge with Count

```dart
Badge(
  label: Text('5'),
  child: Icon(Icons.mail),
)
```

### Badge on IconButton

```dart
IconButton(
  icon: Badge(
    label: Text('12'),
    backgroundColor: Colors.red,
    textColor: Colors.white,
    child: Icon(Icons.shopping_cart),
  ),
  onPressed: () {},
)
```

### Badge on BottomNavigationBar

```dart
BottomNavigationBar(
  items: [
    BottomNavigationBarItem(
      icon: Icon(Icons.home),
      label: 'Home',
    ),
    BottomNavigationBarItem(
      icon: Badge(
        label: Text('3'),
        child: Icon(Icons.message),
      ),
      label: 'Messages',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.person),
      label: 'Profile',
    ),
  ],
)
```

---

## Tooltip - Helpful Hints

**Best for:** Showing hints on hover/long press

### Basic Tooltip

```dart
Tooltip(
  message: 'This is a tooltip',
  child: IconButton(
    icon: Icon(Icons.help),
    onPressed: () {},
  ),
)
```

### Custom Tooltip

```dart
Tooltip(
  message: 'Add new item',
  decoration: BoxDecoration(
    color: Colors.blue,
    borderRadius: BorderRadius.circular(8),
  ),
  textStyle: TextStyle(color: Colors.white),
  padding: EdgeInsets.all(12),
  waitDuration: Duration(seconds: 1), // Delay before showing
  child: IconButton(
    icon: Icon(Icons.add),
    onPressed: () {},
  ),
)
```

---

## Divider - Visual Separator

### Horizontal Divider

```dart
Column(
  children: [
    Text('Section 1'),
    Divider(), // Line
    Text('Section 2'),
    Divider(
      thickness: 2,
      color: Colors.blue,
      indent: 16,
      endIndent: 16,
    ),
    Text('Section 3'),
  ],
)
```

### Vertical Divider

```dart
Row(
  children: [
    Text('Left'),
    VerticalDivider(),
    Text('Right'),
  ],
)
```

---

## Complete Example: E-Commerce Product Screen

```dart
import 'package:flutter/material.dart';

void main() => runApp(ProductScreenApp());

class ProductScreenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ProductScreen(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class ProductScreen extends StatefulWidget {
  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  int selectedSize = 0;
  int quantity = 1;

  void _showSizeGuide() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Size Guide'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(title: Text('S - Small (34-36)')),
              ListTile(title: Text('M - Medium (38-40)')),
              ListTile(title: Text('L - Large (42-44)')),
              ListTile(title: Text('XL - Extra Large (46-48)')),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  void _addToCart() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 48),
              SizedBox(height: 16),
              Text(
                'Added to Cart!',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('$quantity item(s) added to your cart'),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('CONTINUE SHOPPING'),
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        // Go to cart
                      },
                      child: Text('VIEW CART'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product Details'),
        actions: [
          IconButton(
            icon: Badge(
              label: Text('3'),
              child: Icon(Icons.shopping_cart),
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product image
            Image.network(
              'https://picsum.photos/400/400',
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and price
                  Text(
                    'Premium Cotton T-Shirt',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '\$29.99',
                        style: TextStyle(
                          fontSize: 20,
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8),
                      Chip(
                        label: Text('20% OFF'),
                        backgroundColor: Colors.red,
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Divider(),

                  // Size selection
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Size', style: TextStyle(fontSize: 16)),
                      TextButton(
                        onPressed: _showSizeGuide,
                        child: Text('Size Guide'),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ['S', 'M', 'L', 'XL'].asMap().entries.map((entry) {
                      return ChoiceChip(
                        label: Text(entry.value),
                        selected: selectedSize == entry.key,
                        onSelected: (selected) {
                          setState(() {
                            selectedSize = entry.key;
                          });
                        },
                      );
                    }).toList(),
                  ),

                  SizedBox(height: 16),
                  Divider(),

                  // Quantity
                  Text('Quantity', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.remove_circle_outline),
                        onPressed: quantity > 1
                            ? () {
                                setState(() => quantity--);
                              }
                            : null,
                      ),
                      Text('$quantity', style: TextStyle(fontSize: 18)),
                      IconButton(
                        icon: Icon(Icons.add_circle_outline),
                        onPressed: () {
                          setState(() => quantity++);
                        },
                      ),
                    ],
                  ),

                  SizedBox(height: 16),
                  Divider(),

                  // Description
                  Text('Description', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 8),
                  Text(
                    'High-quality cotton t-shirt perfect for everyday wear. '
                    'Soft, comfortable, and durable fabric. Machine washable.',
                  ),

                  SizedBox(height: 24),

                  // Add to cart button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _addToCart,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.all(16),
                      ),
                      child: Text('ADD TO CART', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## Best Practices

### 1. Use Cards for Grouping

```dart
// Group related info in cards
Card(
  child: Padding(
    padding: EdgeInsets.all(16),
    child: Column(
      children: [
        Text('Related Information'),
        // More content
      ],
    ),
  ),
)
```

### 2. Confirm Destructive Actions

```dart
// Always confirm delete/destructive actions
void _confirmDelete() {
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text('Confirm Delete'),
        content: Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text('CANCEL')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              // Delete
              Navigator.pop(context);
            },
            child: Text('DELETE'),
          ),
        ],
      );
    },
  );
}
```

### 3. Use BottomSheet for Mobile Options

```dart
// On mobile, BottomSheet is better than Dialog for lists
showModalBottomSheet(
  context: context,
  builder: (context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(title: Text('Option 1'), onTap: () {}),
        ListTile(title: Text('Option 2'), onTap: () {}),
        ListTile(title: Text('Option 3'), onTap: () {}),
      ],
    );
  },
)
```

### 4. Add Tooltips to Icons

```dart
Tooltip(
  message: 'Settings',
  child: IconButton(
    icon: Icon(Icons.settings),
    onPressed: () {},
  ),
)
```

---

## Summary

You now know:
- **Card** for grouping information with elevation
- **AlertDialog** for confirmations and alerts
- **SimpleDialog** for choosing from options
- **BottomSheet** for mobile-friendly option panels
- **Chips** for tags, filters, and selections
- **Badge** for notification indicators
- **Tooltip** for helpful hints
- **Divider** for visual separation

**Key Takeaways:**
- Use **Card** to group related info
- Always confirm destructive actions with **AlertDialog**
- Use **BottomSheet** on mobile for long option lists
- Add **Tooltips** to icons for better UX
- Use **Chips** for tags and filters

---

**Next:** Learn about Navigation Widgets

**Continue to:** `06e-NavigationWidgets.md`
