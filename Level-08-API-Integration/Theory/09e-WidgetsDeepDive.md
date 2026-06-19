# Widgets Deep Dive: Building Reusable UI Components

Widgets are the visual building blocks of your Flutter app. This doc explains how to create clean, reusable widgets that display data from your controllers.

---

## What is a Widget?

A **Widget** is a piece of UI. Everything you see on screen is a widget:
- Text
- Buttons
- Cards
- Lists
- Icons
- The entire screen

```
FLUTTER'S WIDGET TREE:

MaterialApp
    └── Scaffold
            ├── AppBar
            │       └── Text("Title")
            │
            └── Body
                    └── ListView
                            ├── UserCard
                            ├── UserCard
                            └── UserCard

Everything is a Widget!
```

---

## Screens vs Widgets

```
SCREENS                           WIDGETS
───────                           ───────
Full pages                        Pieces of pages
One per route                     Many per screen
Have Scaffold/AppBar              No Scaffold
Know about navigation             Don't know navigation
Use controllers                   Receive data as props
Live in screens/ folder           Live in widgets/ folder


EXAMPLE:

screens/users_screen.dart         widgets/user_card.dart
┌─────────────────────┐           ┌─────────────────────┐
│ Scaffold            │           │ Card                │
│   AppBar            │           │   ListTile          │
│   Body:             │           │     title: name     │
│     ListView        │           │     subtitle: email │
│       UserCard ─────┼───────────┼──► onTap: callback  │
│       UserCard      │           │                     │
│       UserCard      │           └─────────────────────┘
└─────────────────────┘

Screen USES widgets, widgets don't know about screens
```

---

## Widget Responsibilities

```
WHAT WIDGETS SHOULD DO:
───────────────────────
1. DISPLAY data passed to them
2. FORWARD user actions via callbacks
3. STYLE their content consistently
4. BE REUSABLE across multiple screens

WHAT WIDGETS SHOULD NOT DO:
───────────────────────────
1. NOT make HTTP calls
2. NOT manage app-wide state
3. NOT know about other screens
4. NOT access controllers directly (usually)

EXAMPLE:

// GOOD - Widget receives data and callbacks
class UserCard extends StatelessWidget {
  final User user;              // Data to display
  final VoidCallback? onTap;    // Action to forward

  Widget build() {
    return Card(
      child: ListTile(
        title: Text(user.name),
        onTap: onTap,
      ),
    );
  }
}

// BAD - Widget fetches its own data
class UserCard extends StatelessWidget {
  final int userId;

  Widget build() {
    // DON'T DO THIS!
    final user = await http.get('/users/$userId');
    return Card(...);
  }
}
```

---

## Basic Widget Patterns

### Pattern 1: Display Widget (Stateless)

Most common pattern. Just displays data.

```dart
// widgets/user_card.dart

import 'package:flutter/material.dart';

class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const UserCard({
    super.key,
    required this.user,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Theme.of(context).primaryColor,
          child: Text(
            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        title: Text(user.name),
        subtitle: Text(user.email),
        trailing: onDelete != null
            ? IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onDelete,
              )
            : const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
```

**Usage:**
```dart
// In your screen
ListView.builder(
  itemCount: users.length,
  itemBuilder: (context, index) {
    final user = users[index];
    return UserCard(
      user: user,
      onTap: () => _navigateToDetail(user),
      onDelete: () => _deleteUser(user.id),
    );
  },
)
```

---

### Pattern 2: Status Widget

Shows different states (loading, error, empty).

```dart
// widgets/loading_view.dart

class LoadingView extends StatelessWidget {
  final String? message;

  const LoadingView({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(message!),
          ],
        ],
      ),
    );
  }
}
```

```dart
// widgets/error_view.dart

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorView({
    super.key,
    required this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
```

```dart
// widgets/empty_view.dart

class EmptyView extends StatelessWidget {
  final String message;
  final IconData icon;
  final Widget? action;

  const EmptyView({
    super.key,
    required this.message,
    this.icon = Icons.inbox,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 64,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey,
                ),
          ),
          if (action != null) ...[
            const SizedBox(height: 24),
            action!,
          ],
        ],
      ),
    );
  }
}
```

**Usage:**
```dart
// In your screen
Widget _buildBody() {
  if (controller.isLoading) {
    return const LoadingView(message: 'Loading users...');
  }

  if (controller.hasError) {
    return ErrorView(
      message: controller.error!,
      onRetry: controller.loadUsers,
    );
  }

  if (controller.users.isEmpty) {
    return EmptyView(
      message: 'No users yet',
      icon: Icons.people_outline,
      action: ElevatedButton(
        onPressed: _addUser,
        child: const Text('Add User'),
      ),
    );
  }

  return ListView.builder(...);
}
```

---

### Pattern 3: Interactive Widget (Stateful)

Has local UI state (expanded, selected, etc).

```dart
// widgets/expandable_card.dart

class ExpandableCard extends StatefulWidget {
  final String title;
  final String content;
  final Widget? leading;

  const ExpandableCard({
    super.key,
    required this.title,
    required this.content,
    this.leading,
  });

  @override
  State<ExpandableCard> createState() => _ExpandableCardState();
}

class _ExpandableCardState extends State<ExpandableCard> {
  bool _isExpanded = false;  // LOCAL state only!

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            leading: widget.leading,
            title: Text(widget.title),
            trailing: Icon(
              _isExpanded ? Icons.expand_less : Icons.expand_more,
            ),
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
          ),
          if (_isExpanded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(widget.content),
            ),
        ],
      ),
    );
  }
}
```

**When to use StatefulWidget:**
```
USE STATEFUL WHEN:
──────────────────
- Animation states
- Text input (TextEditingController)
- Expanded/collapsed toggle
- Hover/focus states
- Local selection within the widget

USE STATELESS WHEN:
───────────────────
- Just displaying data
- All state comes from parent
- No local interaction state
```

---

### Pattern 4: Form Field Widget

Reusable input fields.

```dart
// widgets/app_text_field.dart

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final TextInputType keyboardType;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.controller,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      keyboardType: keyboardType,
      obscureText: obscureText,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
```

**Usage:**
```dart
AppTextField(
  label: 'Email',
  hint: 'Enter your email',
  prefixIcon: const Icon(Icons.email),
  keyboardType: TextInputType.emailAddress,
  validator: (value) {
    if (value == null || !value.contains('@')) {
      return 'Please enter a valid email';
    }
    return null;
  },
)
```

---

### Pattern 5: List Item Widget

For use in ListViews.

```dart
// widgets/post_list_item.dart

class PostListItem extends StatelessWidget {
  final Post post;
  final bool isSelected;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;

  const PostListItem({
    super.key,
    required this.post,
    this.isSelected = false,
    this.onTap,
    this.onLongPress,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: isSelected
          ? Theme.of(context).primaryColor.withOpacity(0.1)
          : null,
      child: ListTile(
        title: Text(
          post.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          post.body,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: Colors.green)
            : null,
        onTap: onTap,
        onLongPress: onLongPress,
      ),
    );
  }
}
```

---

## When to Extract a Widget

```
EXTRACT A WIDGET WHEN:
──────────────────────

1. CODE IS REPEATED
   Same UI appears in multiple places?
   → Extract to a widget

2. BUILD METHOD IS TOO LONG
   More than 50-100 lines?
   → Split into smaller widgets

3. LOGIC IS SELF-CONTAINED
   A section handles its own concerns?
   → Extract to a widget

4. TESTING IS NEEDED
   Need to test UI in isolation?
   → Extract to a widget

5. CONFIGURATION VARIES
   Same structure, different data?
   → Extract with parameters


DON'T EXTRACT WHEN:
───────────────────

1. Only used once AND simple
2. Would need too many parameters
3. Tightly coupled to parent logic
```

**Before (too long):**
```dart
class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: EdgeInsets.all(8),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.blue,
                child: Text(user.name[0]),
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => _edit(user),
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _delete(user),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
```

**After (extracted):**
```dart
// In screen
ListView.builder(
  itemBuilder: (context, index) {
    final user = users[index];
    return UserCard(
      user: user,
      onEdit: () => _edit(user),
      onDelete: () => _delete(user),
    );
  },
)

// In widgets/user_card.dart
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;

  // ... clean, reusable implementation
}
```

---

## Widget Props Best Practices

```dart
// GOOD: Required data, optional callbacks
class UserCard extends StatelessWidget {
  final User user;           // Required - can't display without it
  final VoidCallback? onTap; // Optional - not all uses need it

  const UserCard({
    super.key,
    required this.user,      // Forces caller to provide
    this.onTap,              // null means no action
  });
}

// GOOD: Sensible defaults
class LoadingView extends StatelessWidget {
  final String message;
  final Color color;

  const LoadingView({
    super.key,
    this.message = 'Loading...',  // Default value
    this.color = Colors.blue,
  });
}

// GOOD: Named callbacks describe what they do
class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;
  final VoidCallback? onAddToCart;
  final VoidCallback? onFavorite;

  // Clear what each callback does
}

// BAD: Too many required parameters
class BadWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final String imageUrl;
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final EdgeInsets padding;
  // ... 20 more required params

  // This is hard to use!
}

// BETTER: Group related props or use style objects
class BetterWidget extends StatelessWidget {
  final WidgetData data;      // Group data
  final WidgetStyle? style;   // Optional styling

  const BetterWidget({
    super.key,
    required this.data,
    this.style,
  });
}
```

---

## Connecting Widgets to Controllers

Widgets should receive data, not fetch it. The screen gets data from controller and passes to widgets.

```
DATA FLOW:

Controller ──► Screen ──► Widget
   (state)    (builds)   (displays)


// Controller has the data
class UsersController {
  List<User> users = [];
  bool isLoading = false;
}

// Screen reads controller, passes to widgets
class UsersScreen {
  Widget build() {
    return ListView(
      children: [
        for (var user in controller.users)
          UserCard(user: user)  // Widget just displays
      ],
    );
  }
}

// Widget displays what it's given
class UserCard {
  final User user;
  Widget build() => Text(user.name);
}
```

**Full Example:**
```dart
// screens/users_screen.dart
class UsersScreen extends StatefulWidget {
  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  final controller = sl.usersController;

  @override
  void initState() {
    super.initState();
    controller.addListener(_rebuild);
    controller.loadUsers();
  }

  @override
  void dispose() {
    controller.removeListener(_rebuild);
    super.dispose();
  }

  void _rebuild() => setState(() {});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Users')),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // Use status widgets
    if (controller.isLoading) {
      return const LoadingView();
    }

    if (controller.hasError) {
      return ErrorView(
        message: controller.error!,
        onRetry: controller.loadUsers,
      );
    }

    if (controller.users.isEmpty) {
      return const EmptyView(message: 'No users found');
    }

    // Use data widgets
    return ListView.builder(
      itemCount: controller.users.length,
      itemBuilder: (context, index) {
        final user = controller.users[index];
        return UserCard(
          user: user,
          onTap: () => _navigateToDetail(user),
          onDelete: () => _confirmDelete(user),
        );
      },
    );
  }

  void _navigateToDetail(User user) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => UserDetailScreen(user: user),
      ),
    );
  }

  void _confirmDelete(User user) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete User?'),
        content: Text('Delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              controller.deleteUser(user.id);
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
```

---

## Common Widget Mistakes

```
MISTAKE 1: Widget makes HTTP calls
─────────────────────────────────
BAD:
class UserCard extends StatelessWidget {
  final int userId;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: http.get('/users/$userId'),  // NO!
      builder: ...
    );
  }
}

GOOD:
class UserCard extends StatelessWidget {
  final User user;  // Receive data, don't fetch

  @override
  Widget build(BuildContext context) {
    return Text(user.name);
  }
}


MISTAKE 2: Widget accesses global state
───────────────────────────────────────
BAD:
class UserCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = globalController.currentUser;  // NO!
    return Text(user.name);
  }
}

GOOD:
class UserCard extends StatelessWidget {
  final User user;  // Passed from parent

  @override
  Widget build(BuildContext context) {
    return Text(user.name);
  }
}


MISTAKE 3: Widget has too much logic
────────────────────────────────────
BAD:
class UserCard extends StatelessWidget {
  final User user;

  String get displayName {
    if (user.isPremium && user.subscriptionDate != null) {
      final days = DateTime.now().difference(user.subscriptionDate!).inDays;
      if (days > 365) {
        return '${user.name} (VIP)';
      } else if (days > 30) {
        return '${user.name} (Premium)';
      }
    }
    return user.name;
  }
  // ... lots of business logic
}

GOOD:
// Put logic in model or controller
class User {
  String get displayName => /* logic here */;
}

class UserCard extends StatelessWidget {
  final User user;

  @override
  Widget build(BuildContext context) {
    return Text(user.displayName);  // Use computed property
  }
}


MISTAKE 4: Widget navigates directly
────────────────────────────────────
BAD:
class UserCard extends StatelessWidget {
  final User user;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(  // Widget knows about navigation - NO!
          context,
          MaterialPageRoute(builder: (_) => UserDetail(user: user)),
        );
      },
      child: ...
    );
  }
}

GOOD:
class UserCard extends StatelessWidget {
  final User user;
  final VoidCallback? onTap;  // Let parent handle navigation

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,  // Just forward the tap
      child: ...
    );
  }
}
```

---

## Organizing Your Widgets Folder

```
widgets/
├── common/                    # Used everywhere
│   ├── loading_view.dart
│   ├── error_view.dart
│   ├── empty_view.dart
│   └── app_button.dart
│
├── forms/                     # Form-related widgets
│   ├── app_text_field.dart
│   ├── app_dropdown.dart
│   └── form_section.dart
│
├── cards/                     # Card widgets
│   ├── user_card.dart
│   ├── post_card.dart
│   └── product_card.dart
│
└── lists/                     # List item widgets
    ├── user_list_item.dart
    ├── post_list_item.dart
    └── selectable_list_item.dart
```

---

## Summary

```
WIDGETS SUMMARY:
────────────────

WHAT WIDGETS DO:
• Display data passed as props
• Forward user actions via callbacks
• Manage only LOCAL UI state (expanded, hover, etc)
• Provide reusable UI components

WHAT WIDGETS DON'T DO:
• Make HTTP calls
• Access global state
• Know about navigation
• Contain business logic

KEY PATTERNS:
1. Display Widget (Stateless) - most common
2. Status Widget (Loading/Error/Empty)
3. Interactive Widget (Stateful) - local state only
4. Form Field Widget
5. List Item Widget

BEST PRACTICES:
• Required data props, optional callbacks
• Clear callback names (onTap, onDelete)
• Sensible defaults for optional props
• Extract when code is repeated or too long
• Keep widgets focused on ONE thing

DATA FLOW:
Controller → Screen → Widget → Display
   (state)  (builds)  (props)   (UI)
```

---

## Navigation

Previous: [Controllers Deep Dive](09f-ControllersDeepDive.md)
Back to: [Learning Path](00-LearningPath.md)
Next: [Service Layer](09b-ServiceLayer.md)
