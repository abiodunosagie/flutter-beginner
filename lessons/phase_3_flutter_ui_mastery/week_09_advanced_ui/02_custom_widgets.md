# Week 9, Day 3-4: Custom Widgets & Composition

## Why Custom Widgets?

**Problem:** Your code is getting messy and repetitive.

**Solution:** Extract reusable pieces into **custom widgets**.

**Benefits:**
- ✓ Cleaner code
- ✓ Reusability
- ✓ Easier testing
- ✓ Better organization
- ✓ Maintainability

**Real-world analogy:**
- **Without custom widgets** = Copy-pasting recipe steps for every meal
- **With custom widgets** = Creating reusable recipes you can reference

---

## When to Create Custom Widgets

### ✅ Create When:

1. **Repeated UI patterns**
   ```dart
   // Used 10 times in your app
   Container(
     padding: EdgeInsets.all(16),
     decoration: BoxDecoration(...),
     child: Text(...),
   )
   ```

2. **Complex widget trees**
   ```dart
   // build() method is 200+ lines
   // Break into smaller widgets!
   ```

3. **Logical separation**
   ```dart
   // Header, body, footer
   // Each should be its own widget
   ```

### ❌ Don't Create When:

1. **Used only once**
2. **Very simple (1-2 lines)**
3. **Tightly coupled to parent**

---

## Basic Custom Widget

### Before (Messy)

```dart
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // Product card 1
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.phone_android, size: 64),
                SizedBox(height: 8),
                Text('iPhone 15', style: TextStyle(fontSize: 20)),
                Text('\$999', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),

          SizedBox(height: 16),

          // Product card 2 - SAME CODE REPEATED!
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Icon(Icons.laptop, size: 64),
                SizedBox(height: 8),
                Text('MacBook Pro', style: TextStyle(fontSize: 20)),
                Text('\$1999', style: TextStyle(color: Colors.green)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
```

### After (Clean with Custom Widget)

```dart
class ProductCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String price;

  const ProductCard({
    Key? key,
    required this.icon,
    required this.name,
    required this.price,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, size: 64, color: Colors.blue),
          SizedBox(height: 8),
          Text(name, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          SizedBox(height: 4),
          Text(price, style: TextStyle(color: Colors.green, fontSize: 18)),
        ],
      ),
    );
  }
}

// Usage
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          ProductCard(
            icon: Icons.phone_android,
            name: 'iPhone 15',
            price: '\$999',
          ),
          SizedBox(height: 16),
          ProductCard(
            icon: Icons.laptop,
            name: 'MacBook Pro',
            price: '\$1999',
          ),
          SizedBox(height: 16),
          ProductCard(
            icon: Icons.watch,
            name: 'Apple Watch',
            price: '\$399',
          ),
        ],
      ),
    );
  }
}
```

**Benefits:**
- ✓ 50% less code
- ✓ Easy to update (change once, applies everywhere)
- ✓ Reusable
- ✓ Testable

---

## Widget Parameters

### Required Parameters

```dart
class UserAvatar extends StatelessWidget {
  final String name;
  final String imageUrl;

  const UserAvatar({
    Key? key,
    required this.name,      // MUST provide
    required this.imageUrl,  // MUST provide
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundImage: NetworkImage(imageUrl),
        ),
        SizedBox(height: 8),
        Text(name),
      ],
    );
  }
}

// Usage
UserAvatar(
  name: 'Alice',
  imageUrl: 'https://i.pravatar.cc/150',
)
```

### Optional Parameters

```dart
class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color? color;
  final IconData? icon;

  const CustomButton({
    Key? key,
    required this.text,
    this.onPressed,          // Optional
    this.color,              // Optional
    this.icon,               // Optional
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color ?? Colors.blue,  // Default to blue
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon),
            SizedBox(width: 8),
          ],
          Text(text),
        ],
      ),
    );
  }
}

// Usage
CustomButton(text: 'Click Me')
CustomButton(text: 'Save', color: Colors.green)
CustomButton(text: 'Delete', color: Colors.red, icon: Icons.delete)
```

### Default Values

```dart
class InfoCard extends StatelessWidget {
  final String title;
  final String description;
  final Color backgroundColor;
  final double borderRadius;

  const InfoCard({
    Key? key,
    required this.title,
    required this.description,
    this.backgroundColor = Colors.blue,  // Default
    this.borderRadius = 12.0,            // Default
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            description,
            style: TextStyle(color: Colors.white70),
          ),
        ],
      ),
    );
  }
}

// Usage
InfoCard(title: 'Info', description: 'Details')  // Uses defaults
InfoCard(
  title: 'Warning',
  description: 'Be careful',
  backgroundColor: Colors.orange,
  borderRadius: 20,
)
```

---

## Callback Parameters

Pass functions to custom widgets:

```dart
class ConfirmDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const ConfirmDialog({
    Key? key,
    required this.title,
    required this.message,
    required this.onConfirm,
    this.onCancel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(message),
      actions: [
        if (onCancel != null)
          TextButton(
            onPressed: onCancel,
            child: Text('Cancel'),
          ),
        ElevatedButton(
          onPressed: onConfirm,
          child: Text('Confirm'),
        ),
      ],
    );
  }
}

// Usage
showDialog(
  context: context,
  builder: (context) => ConfirmDialog(
    title: 'Delete Item',
    message: 'Are you sure?',
    onConfirm: () {
      print('Deleted!');
      Navigator.pop(context);
    },
    onCancel: () {
      print('Cancelled');
      Navigator.pop(context);
    },
  ),
)
```

---

## Widget Composition

Build complex widgets from simpler ones:

### Example: Profile Header

```dart
// Simple widgets
class UserAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;

  const UserAvatar({
    Key? key,
    required this.imageUrl,
    this.size = 50,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundImage: NetworkImage(imageUrl),
    );
  }
}

class UserInfo extends StatelessWidget {
  final String name;
  final String bio;

  const UserInfo({
    Key? key,
    required this.name,
    required this.bio,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 4),
        Text(
          bio,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}

class FollowButton extends StatelessWidget {
  final VoidCallback onPressed;

  const FollowButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text('Follow'),
    );
  }
}

// Compose into complex widget
class ProfileHeader extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String bio;
  final VoidCallback onFollow;

  const ProfileHeader({
    Key? key,
    required this.imageUrl,
    required this.name,
    required this.bio,
    required this.onFollow,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          UserAvatar(imageUrl: imageUrl, size: 40),
          SizedBox(width: 16),
          Expanded(
            child: UserInfo(name: name, bio: bio),
          ),
          FollowButton(onPressed: onFollow),
        ],
      ),
    );
  }
}

// Usage
ProfileHeader(
  imageUrl: 'https://i.pravatar.cc/150',
  name: 'Alice Johnson',
  bio: 'Flutter Developer',
  onFollow: () {
    print('Followed!');
  },
)
```

**Benefits of composition:**
- ✓ Each widget has single responsibility
- ✓ Easy to test individually
- ✓ Reusable components
- ✓ Clear structure

---

## Builder Pattern

Create flexible widgets:

```dart
class CustomCard extends StatelessWidget {
  final Widget? header;
  final Widget? body;
  final Widget? footer;
  final EdgeInsets padding;

  const CustomCard({
    Key? key,
    this.header,
    this.body,
    this.footer,
    this.padding = const EdgeInsets.all(16),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (header != null) ...[
            header!,
            SizedBox(height: 12),
          ],
          if (body != null) body!,
          if (footer != null) ...[
            SizedBox(height: 12),
            footer!,
          ],
        ],
      ),
    );
  }
}

// Usage - Flexible!
CustomCard(
  header: Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
  body: Text('This is the body content'),
  footer: Row(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      TextButton(onPressed: () {}, child: Text('Cancel')),
      ElevatedButton(onPressed: () {}, child: Text('OK')),
    ],
  ),
)

CustomCard(
  body: Column(
    children: [
      Icon(Icons.check_circle, size: 64, color: Colors.green),
      SizedBox(height: 16),
      Text('Success!'),
    ],
  ),
)
```

---

## Real-World Example: Social Media Post

```dart
class Post {
  final String id;
  final String authorName;
  final String authorAvatar;
  final String content;
  final String? imageUrl;
  final int likes;
  final int comments;
  final DateTime timestamp;

  Post({
    required this.id,
    required this.authorName,
    required this.authorAvatar,
    required this.content,
    this.imageUrl,
    this.likes = 0,
    this.comments = 0,
    required this.timestamp,
  });
}

// Component widgets
class PostHeader extends StatelessWidget {
  final String authorName;
  final String authorAvatar;
  final DateTime timestamp;

  const PostHeader({
    Key? key,
    required this.authorName,
    required this.authorAvatar,
    required this.timestamp,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(authorAvatar),
          radius: 20,
        ),
        SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                authorName,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                _formatTime(timestamp),
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
        IconButton(
          icon: Icon(Icons.more_vert),
          onPressed: () {},
        ),
      ],
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

class PostContent extends StatelessWidget {
  final String content;
  final String? imageUrl;

  const PostContent({
    Key? key,
    required this.content,
    this.imageUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(content),
        if (imageUrl != null) ...[
          SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              imageUrl!,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ],
      ],
    );
  }
}

class PostActions extends StatelessWidget {
  final int likes;
  final int comments;
  final VoidCallback onLike;
  final VoidCallback onComment;
  final VoidCallback onShare;

  const PostActions({
    Key? key,
    required this.likes,
    required this.comments,
    required this.onLike,
    required this.onComment,
    required this.onShare,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _ActionButton(
          icon: Icons.favorite_border,
          label: '$likes',
          onPressed: onLike,
        ),
        _ActionButton(
          icon: Icons.comment_outlined,
          label: '$comments',
          onPressed: onComment,
        ),
        _ActionButton(
          icon: Icons.share_outlined,
          label: 'Share',
          onPressed: onShare,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  const _ActionButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(label),
    );
  }
}

// Main post widget - composition
class PostCard extends StatelessWidget {
  final Post post;

  const PostCard({Key? key, required this.post}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PostHeader(
              authorName: post.authorName,
              authorAvatar: post.authorAvatar,
              timestamp: post.timestamp,
            ),
            SizedBox(height: 12),
            PostContent(
              content: post.content,
              imageUrl: post.imageUrl,
            ),
            SizedBox(height: 12),
            PostActions(
              likes: post.likes,
              comments: post.comments,
              onLike: () => print('Liked!'),
              onComment: () => print('Comment!'),
              onShare: () => print('Shared!'),
            ),
          ],
        ),
      ),
    );
  }
}

// Usage
ListView(
  children: [
    PostCard(
      post: Post(
        id: '1',
        authorName: 'Alice Johnson',
        authorAvatar: 'https://i.pravatar.cc/150?img=1',
        content: 'Just finished building my first Flutter app!',
        imageUrl: 'https://picsum.photos/400/300',
        likes: 42,
        comments: 8,
        timestamp: DateTime.now().subtract(Duration(hours: 2)),
      ),
    ),
    PostCard(
      post: Post(
        id: '2',
        authorName: 'Bob Smith',
        authorAvatar: 'https://i.pravatar.cc/150?img=2',
        content: 'Learning Dart is fun!',
        likes: 15,
        comments: 3,
        timestamp: DateTime.now().subtract(Duration(hours: 5)),
      ),
    ),
  ],
)
```

---

## Best Practices

### 1. Single Responsibility

```dart
// BAD - Does too much
class UserCard extends StatelessWidget {
  // Fetches data, displays UI, handles navigation
}

// GOOD - Single purpose
class UserCard extends StatelessWidget {
  final User user;  // Receives data
  // Only displays UI
}
```

### 2. Const Constructors

```dart
// Good for performance
class MyWidget extends StatelessWidget {
  final String title;

  const MyWidget({Key? key, required this.title}) : super(key: key);
  //^^^^
}

// Usage
const MyWidget(title: 'Hello')  // Const instance
```

### 3. Extract Methods for Clarity

```dart
class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildHeader(),
        _buildStats(),
        _buildChart(),
        _buildRecentActivity(),
      ],
    );
  }

  Widget _buildHeader() {
    return Text('Dashboard');
  }

  Widget _buildStats() {
    return Row(/* stats */);
  }

  Widget _buildChart() {
    return Container(/* chart */);
  }

  Widget _buildRecentActivity() {
    return ListView(/* activity */);
  }
}
```

### 4. Use Meaningful Names

```dart
// BAD
class MyWidget extends StatelessWidget {}
class Container1 extends StatelessWidget {}

// GOOD
class ProductCard extends StatelessWidget {}
class UserAvatar extends StatelessWidget {}
class PriceLabel extends StatelessWidget {}
```

---

## Key Takeaways

1. **Extract** repeated UI into custom widgets
2. **Parameters** make widgets flexible
3. **Composition** builds complex from simple
4. **Single responsibility** per widget
5. **Const constructors** for performance
6. **Meaningful names** for clarity
7. **Small widgets** are easier to maintain

---

## What's Next?

Tomorrow: **Theming & Styling**
- Theme data
- Dark mode
- Custom themes
- Text styles
- Color schemes

You've mastered custom widgets! 🎨✨
