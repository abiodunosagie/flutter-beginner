# Level 05 PART 6c: List Widgets - Scrollable Lists and Grids

## For a 5-Year-Old

Imagine you have a toy chest with LOTS of toys:
- You can't see all toys at once (too many!)
- So you scroll through them (like scrolling on a phone)
- Sometimes toys are in a line (like a list)
- Sometimes toys are in a grid (like squares on a checkerboard)

Flutter's list widgets work the same way! They help you show MANY items that users can scroll through. Let's learn all about them!

---

## List Widget Types Overview

| Widget | What It Shows | Best For |
|--------|---------------|----------|
| **ListView** | Vertical scrolling list | Any scrollable content |
| **ListView.builder** | Lazy-loaded list | Long lists (100+ items) |
| **ListView.separated** | List with dividers | Lists with separators |
| **ListTile** | Standard list item | Contacts, settings, menus |
| **GridView** | Grid of items | Photos, products, icons |
| **GridView.builder** | Lazy-loaded grid | Large grids |
| **ReorderableListView** | Drag-to-reorder list | Todo lists, playlists |
| **SliverAppBar** | Collapsing header | Fancy scrolling effects |

---

## ListView - Basic Scrollable List

**Best for:** Simple lists with few items

### Basic ListView

```dart
ListView(
  children: [
    ListTile(
      leading: Icon(Icons.home),
      title: Text('Home'),
    ),
    ListTile(
      leading: Icon(Icons.search),
      title: Text('Search'),
    ),
    ListTile(
      leading: Icon(Icons.person),
      title: Text('Profile'),
    ),
  ],
)
```

### ListView with Padding

```dart
ListView(
  padding: EdgeInsets.all(16),
  children: [
    Card(
      child: ListTile(
        title: Text('Item 1'),
      ),
    ),
    SizedBox(height: 8),
    Card(
      child: ListTile(
        title: Text('Item 2'),
      ),
    ),
    SizedBox(height: 8),
    Card(
      child: ListTile(
        title: Text('Item 3'),
      ),
    ),
  ],
)
```

---

## ListView.builder - Efficient Long Lists

**Best for:** Lists with 100+ items (or unknown number)

### Basic ListView.builder

```dart
ListView.builder(
  itemCount: 100,
  itemBuilder: (context, index) {
    return ListTile(
      leading: CircleAvatar(
        child: Text('${index + 1}'),
      ),
      title: Text('Item ${index + 1}'),
      subtitle: Text('This is item number ${index + 1}'),
      trailing: Icon(Icons.chevron_right),
    );
  },
)
```

### Why Use .builder?

```dart
// BAD - Creates ALL widgets at once (slow for many items)
ListView(
  children: List.generate(1000, (index) {
    return ListTile(title: Text('Item $index'));
  }),
)

// GOOD - Creates widgets only when visible (fast!)
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) {
    return ListTile(title: Text('Item $index'));
  },
)
```

**Performance Tip:** `ListView.builder` only builds widgets that are visible on screen!

### ListView.builder with Data

```dart
class ContactsList extends StatelessWidget {
  final List<Map<String, String>> contacts = [
    {'name': 'Alice Johnson', 'phone': '555-1234'},
    {'name': 'Bob Smith', 'phone': '555-5678'},
    {'name': 'Charlie Brown', 'phone': '555-9012'},
    {'name': 'Diana Prince', 'phone': '555-3456'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: contacts.length,
      itemBuilder: (context, index) {
        final contact = contacts[index];
        return ListTile(
          leading: CircleAvatar(
            child: Text(contact['name']![0]), // First letter
          ),
          title: Text(contact['name']!),
          subtitle: Text(contact['phone']!),
          trailing: Icon(Icons.call),
          onTap: () {
            print('Call ${contact['name']}');
          },
        );
      },
    );
  }
}
```

---

## ListView.separated - List with Dividers

**Best for:** Lists that need visual separators

### Basic ListView.separated

```dart
ListView.separated(
  itemCount: 20,
  separatorBuilder: (context, index) {
    return Divider(); // Line between items
  },
  itemBuilder: (context, index) {
    return ListTile(
      title: Text('Item ${index + 1}'),
    );
  },
)
```

### Custom Separators

```dart
ListView.separated(
  itemCount: 10,
  separatorBuilder: (context, index) {
    // Different separator every 3 items
    if ((index + 1) % 3 == 0) {
      return Divider(
        thickness: 3,
        color: Colors.blue,
      );
    }
    return SizedBox(height: 8); // Small gap
  },
  itemBuilder: (context, index) {
    return Card(
      child: ListTile(
        title: Text('Item ${index + 1}'),
      ),
    );
  },
)
```

---

## ListTile - Standard List Item

**Best for:** Consistent list item layout

### All ListTile Options

```dart
ListTile(
  // Leading icon/avatar (left side)
  leading: CircleAvatar(
    backgroundImage: NetworkImage('https://example.com/avatar.jpg'),
  ),

  // Main title
  title: Text(
    'John Doe',
    style: TextStyle(fontWeight: FontWeight.bold),
  ),

  // Subtitle (smaller text below title)
  subtitle: Text('Software Developer'),

  // Trailing icon/widget (right side)
  trailing: Icon(Icons.chevron_right),

  // Make it tappable
  onTap: () {
    print('Tapped John Doe');
  },

  // Long press
  onLongPress: () {
    print('Long pressed');
  },

  // Dense layout (less padding)
  dense: true,

  // Selected state
  selected: true,

  // 3 lines max for subtitle
  isThreeLine: true,

  // Enable/disable
  enabled: true,
)
```

### Common ListTile Patterns

```dart
// Contact item
ListTile(
  leading: CircleAvatar(child: Text('A')),
  title: Text('Alice Johnson'),
  subtitle: Text('555-1234'),
  trailing: Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      IconButton(
        icon: Icon(Icons.call),
        onPressed: () {},
      ),
      IconButton(
        icon: Icon(Icons.message),
        onPressed: () {},
      ),
    ],
  ),
)

// Settings item
ListTile(
  leading: Icon(Icons.notifications),
  title: Text('Notifications'),
  trailing: Switch(
    value: true,
    onChanged: (value) {},
  ),
)

// Menu item with badge
ListTile(
  leading: Icon(Icons.inbox),
  title: Text('Inbox'),
  trailing: Container(
    padding: EdgeInsets.all(8),
    decoration: BoxDecoration(
      color: Colors.red,
      shape: BoxShape.circle,
    ),
    child: Text('5', style: TextStyle(color: Colors.white)),
  ),
)
```

---

## GridView - Grid Layout

**Best for:** Photos, products, icons

### GridView.count (Fixed Number of Columns)

```dart
GridView.count(
  crossAxisCount: 2, // 2 columns
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  padding: EdgeInsets.all(16),
  children: [
    Card(
      color: Colors.red,
      child: Center(child: Text('1')),
    ),
    Card(
      color: Colors.blue,
      child: Center(child: Text('2')),
    ),
    Card(
      color: Colors.green,
      child: Center(child: Text('3')),
    ),
    Card(
      color: Colors.orange,
      child: Center(child: Text('4')),
    ),
  ],
)
```

### GridView.builder (Efficient Large Grids)

```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 3, // 3 columns
    mainAxisSpacing: 8,
    crossAxisSpacing: 8,
    childAspectRatio: 1, // Square items (width/height)
  ),
  itemCount: 50,
  itemBuilder: (context, index) {
    return Card(
      child: Center(
        child: Text('${index + 1}'),
      ),
    );
  },
)
```

### GridView.extent (Fixed Item Width)

```dart
GridView.extent(
  maxCrossAxisExtent: 150, // Max 150px wide
  mainAxisSpacing: 10,
  crossAxisSpacing: 10,
  padding: EdgeInsets.all(16),
  children: List.generate(20, (index) {
    return Card(
      child: Center(child: Text('${index + 1}')),
    );
  }),
)
```

### Photo Grid Example

```dart
class PhotoGrid extends StatelessWidget {
  final List<String> imageUrls = [
    'https://picsum.photos/200/200?random=1',
    'https://picsum.photos/200/200?random=2',
    'https://picsum.photos/200/200?random=3',
    'https://picsum.photos/200/200?random=4',
    'https://picsum.photos/200/200?random=5',
    'https://picsum.photos/200/200?random=6',
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            print('Tapped image $index');
          },
          child: Card(
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              imageUrls[index],
              fit: BoxFit.cover,
            ),
          ),
        );
      },
    );
  }
}
```

---

## ReorderableListView - Drag to Reorder

**Best for:** Todo lists, playlists, priority lists

### Basic ReorderableListView

```dart
class ReorderableExample extends StatefulWidget {
  @override
  State<ReorderableExample> createState() => _ReorderableExampleState();
}

class _ReorderableExampleState extends State<ReorderableExample> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3', 'Item 4', 'Item 5'];

  @override
  Widget build(BuildContext context) {
    return ReorderableListView(
      onReorder: (oldIndex, newIndex) {
        setState(() {
          if (newIndex > oldIndex) {
            newIndex -= 1;
          }
          final item = items.removeAt(oldIndex);
          items.insert(newIndex, item);
        });
      },
      children: [
        for (int index = 0; index < items.length; index++)
          ListTile(
            key: Key('$index'), // REQUIRED!
            leading: Icon(Icons.drag_handle),
            title: Text(items[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  items.removeAt(index);
                });
              },
            ),
          ),
      ],
    );
  }
}
```

---

## Pull to Refresh

**Best for:** Lists that can update (social feeds, emails)

### RefreshIndicator

```dart
class RefreshableList extends StatefulWidget {
  @override
  State<RefreshableList> createState() => _RefreshableListState();
}

class _RefreshableListState extends State<RefreshableList> {
  List<String> items = ['Item 1', 'Item 2', 'Item 3'];

  Future<void> _refreshData() async {
    // Simulate network request
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      // Add new items
      items.insert(0, 'New Item ${items.length + 1}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: _refreshData,
      child: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
          );
        },
      ),
    );
  }
}
```

---

## Pagination (Load More)

**Best for:** Very long lists (social media, search results)

### Infinite Scroll Example

```dart
class PaginatedList extends StatefulWidget {
  @override
  State<PaginatedList> createState() => _PaginatedListState();
}

class _PaginatedListState extends State<PaginatedList> {
  List<String> items = List.generate(20, (i) => 'Item ${i + 1}');
  bool isLoadingMore = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    if (isLoadingMore) return;

    setState(() {
      isLoadingMore = true;
    });

    // Simulate loading
    await Future.delayed(Duration(seconds: 2));

    setState(() {
      int currentLength = items.length;
      items.addAll(
        List.generate(20, (i) => 'Item ${currentLength + i + 1}'),
      );
      isLoadingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: items.length + (isLoadingMore ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == items.length) {
          return Center(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CircularProgressIndicator(),
            ),
          );
        }
        return ListTile(
          title: Text(items[index]),
        );
      },
    );
  }
}
```

---

## SliverAppBar - Collapsing Header

**Best for:** Fancy scrolling effects

### Basic Collapsing AppBar

```dart
Scaffold(
  body: CustomScrollView(
    slivers: [
      SliverAppBar(
        expandedHeight: 200,
        floating: false,
        pinned: true,
        flexibleSpace: FlexibleSpaceBar(
          title: Text('Collapsing Header'),
          background: Image.network(
            'https://picsum.photos/400/200',
            fit: BoxFit.cover,
          ),
        ),
      ),
      SliverList(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            return ListTile(
              title: Text('Item ${index + 1}'),
            );
          },
          childCount: 50,
        ),
      ),
    ],
  ),
)
```

### SliverAppBar Options

```dart
SliverAppBar(
  // Height when expanded
  expandedHeight: 200,

  // Stay visible when scrolling
  pinned: true,

  // Float on scroll up
  floating: true,

  // Snap to expanded/collapsed
  snap: false,

  // Background when expanded
  flexibleSpace: FlexibleSpaceBar(
    title: Text('Title'),
    background: Image.network('url', fit: BoxFit.cover),
    centerTitle: true,
  ),

  // Actions
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: () {}),
  ],
)
```

---

## Complete Example: Social Media Feed

```dart
import 'package:flutter/material.dart';

void main() => runApp(SocialFeedApp());

class SocialFeedApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SocialFeedPage(),
      theme: ThemeData(useMaterial3: true),
    );
  }
}

class Post {
  final String username;
  final String content;
  final String timeAgo;
  final int likes;
  final int comments;

  Post({
    required this.username,
    required this.content,
    required this.timeAgo,
    required this.likes,
    required this.comments,
  });
}

class SocialFeedPage extends StatefulWidget {
  @override
  State<SocialFeedPage> createState() => _SocialFeedPageState();
}

class _SocialFeedPageState extends State<SocialFeedPage> {
  List<Post> posts = [
    Post(
      username: 'Alice',
      content: 'Just finished learning Flutter! 🚀',
      timeAgo: '2h ago',
      likes: 24,
      comments: 5,
    ),
    Post(
      username: 'Bob',
      content: 'Beautiful sunset today! 🌅',
      timeAgo: '4h ago',
      likes: 156,
      comments: 12,
    ),
    Post(
      username: 'Charlie',
      content: 'New blog post about mobile development',
      timeAgo: '6h ago',
      likes: 89,
      comments: 23,
    ),
  ];

  Future<void> _refreshFeed() async {
    await Future.delayed(Duration(seconds: 2));
    setState(() {
      posts.insert(
        0,
        Post(
          username: 'New User',
          content: 'This is a new post!',
          timeAgo: 'Just now',
          likes: 0,
          comments: 0,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Social Feed'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.more_vert),
            onPressed: () {},
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refreshFeed,
        child: ListView.separated(
          itemCount: posts.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            final post = posts[index];
            return _buildPostCard(post);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Create new post
        },
        child: Icon(Icons.add),
      ),
    );
  }

  Widget _buildPostCard(Post post) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info
          Row(
            children: [
              CircleAvatar(
                child: Text(post.username[0]),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      post.username,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      post.timeAgo,
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
          ),

          SizedBox(height: 12),

          // Content
          Text(post.content),

          SizedBox(height: 12),

          // Actions
          Row(
            children: [
              TextButton.icon(
                icon: Icon(Icons.favorite_border),
                label: Text('${post.likes}'),
                onPressed: () {},
              ),
              SizedBox(width: 8),
              TextButton.icon(
                icon: Icon(Icons.comment_outlined),
                label: Text('${post.comments}'),
                onPressed: () {},
              ),
              SizedBox(width: 8),
              TextButton.icon(
                icon: Icon(Icons.share_outlined),
                label: Text('Share'),
                onPressed: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
```

---

## Performance Tips

### 1. Use .builder for Long Lists

```dart
// BAD - Creates all 1000 widgets immediately
ListView(
  children: List.generate(1000, (i) => ListTile(...)),
)

// GOOD - Creates only visible widgets
ListView.builder(
  itemCount: 1000,
  itemBuilder: (context, index) => ListTile(...),
)
```

### 2. Add Keys to List Items

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return ListTile(
      key: ValueKey(items[index].id), // Helps Flutter optimize
      title: Text(items[index].name),
    );
  },
)
```

### 3. Use const Widgets When Possible

```dart
ListView.builder(
  itemBuilder: (context, index) {
    return const ListTile( // const = better performance
      leading: Icon(Icons.person),
      title: Text('Static Text'),
    );
  },
)
```

### 4. Dispose Controllers

```dart
class MyList extends StatefulWidget {
  @override
  State<MyList> createState() => _MyListState();
}

class _MyListState extends State<MyList> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose(); // Clean up!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(controller: _controller);
  }
}
```

---

## Summary

You now know:
- **ListView** for simple scrollable lists
- **ListView.builder** for efficient long lists
- **ListView.separated** for lists with dividers
- **ListTile** for standard list items
- **GridView** for grid layouts
- **ReorderableListView** for drag-to-reorder
- **RefreshIndicator** for pull-to-refresh
- **Pagination** for infinite scroll
- **SliverAppBar** for collapsing headers
- Performance optimization tips

**Key Takeaways:**
- Always use **.builder** for lists with 50+ items
- Use **const** widgets when possible
- Dispose of controllers in dispose()
- Add keys to list items for better performance
- Use **RefreshIndicator** for pullable lists

---

**Next:** Learn about Card and Dialog Widgets

**Continue to:** `06d-CardDialogWidgets.md`
