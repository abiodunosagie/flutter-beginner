# Level 5: Real-World Apps Using These Concepts

See how Flutter widgets build the interfaces of real applications!

---

## Widgets

### Everything is a Widget!

**Instagram Profile Screen**
```dart
Scaffold(
  appBar: AppBar(title: Text('@username')),
  body: Column(
    children: [
      // Profile header
      Row(
        children: [
          CircleAvatar(backgroundImage: NetworkImage(profileUrl)),
          Column(
            children: [
              Text('Posts'),
              Text('150'),
            ],
          ),
          Column(
            children: [
              Text('Followers'),
              Text('10.5K'),
            ],
          ),
          Column(
            children: [
              Text('Following'),
              Text('500'),
            ],
          ),
        ],
      ),
      // Bio
      Text('Flutter Developer | Coffee Lover'),
      // Grid of posts
      GridView.builder(...),
    ],
  ),
)
```

---

## Row & Column

### Layout Powers Everything!

**Twitter Post**
```dart
Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    // Header row
    Row(
      children: [
        CircleAvatar(backgroundImage: NetworkImage(user.avatar)),
        SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(user.name, style: TextStyle(fontWeight: FontWeight.bold)),
            Text('@${user.handle}', style: TextStyle(color: Colors.grey)),
          ],
        ),
        Spacer(),
        Icon(Icons.more_horiz),
      ],
    ),
    // Tweet content
    Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Text(tweet.content),
    ),
    // Action row
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Icon(Icons.chat_bubble_outline),
        Icon(Icons.repeat),
        Icon(Icons.favorite_border),
        Icon(Icons.share),
      ],
    ),
  ],
)
```

---

## StatefulWidget

### Interactive Apps!

**Like Button (Instagram)**
```dart
class LikeButton extends StatefulWidget {
  @override
  State<LikeButton> createState() => _LikeButtonState();
}

class _LikeButtonState extends State<LikeButton> {
  bool _isLiked = false;
  int _likeCount = 0;

  void _toggleLike() {
    setState(() {
      _isLiked = !_isLiked;
      _likeCount += _isLiked ? 1 : -1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleLike,
      child: Row(
        children: [
          Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.grey,
          ),
          Text('$_likeCount'),
        ],
      ),
    );
  }
}
```

**Shopping Cart Counter**
```dart
class CartButton extends StatefulWidget {
  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: Icon(Icons.remove),
          onPressed: () {
            if (_quantity > 1) {
              setState(() => _quantity--);
            }
          },
        ),
        Text('$_quantity'),
        IconButton(
          icon: Icon(Icons.add),
          onPressed: () => setState(() => _quantity++),
        ),
      ],
    );
  }
}
```

---

## ListView

### Scrolling Content!

**WhatsApp Chat List**
```dart
ListView.builder(
  itemCount: chats.length,
  itemBuilder: (context, index) {
    final chat = chats[index];
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(chat.contact.avatar),
      ),
      title: Text(chat.contact.name),
      subtitle: Text(
        chat.lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(chat.timestamp),
          if (chat.unreadCount > 0)
            CircleAvatar(
              radius: 10,
              child: Text('${chat.unreadCount}'),
            ),
        ],
      ),
      onTap: () => openChat(chat),
    );
  },
)
```

**Spotify Playlist**
```dart
ListView.separated(
  itemCount: songs.length,
  separatorBuilder: (_, __) => Divider(),
  itemBuilder: (context, index) {
    final song = songs[index];
    return ListTile(
      leading: Image.network(song.albumArt),
      title: Text(song.title),
      subtitle: Text(song.artist),
      trailing: PopupMenuButton(
        itemBuilder: (_) => [
          PopupMenuItem(child: Text('Add to Queue')),
          PopupMenuItem(child: Text('Add to Playlist')),
          PopupMenuItem(child: Text('Share')),
        ],
      ),
    );
  },
)
```

---

## TextField

### User Input!

**Login Screen**
```dart
Column(
  children: [
    TextField(
      controller: _emailController,
      decoration: InputDecoration(
        labelText: 'Email',
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    ),
    SizedBox(height: 16),
    TextField(
      controller: _passwordController,
      obscureText: true,
      decoration: InputDecoration(
        labelText: 'Password',
        prefixIcon: Icon(Icons.lock),
        border: OutlineInputBorder(),
      ),
    ),
    SizedBox(height: 24),
    ElevatedButton(
      onPressed: _login,
      child: Text('Sign In'),
    ),
  ],
)
```

**Search Bar (Amazon)**
```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Search products...',
    prefixIcon: Icon(Icons.search),
    suffixIcon: IconButton(
      icon: Icon(Icons.mic),
      onPressed: _startVoiceSearch,
    ),
    filled: true,
    fillColor: Colors.grey[200],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide.none,
    ),
  ),
  onChanged: (query) => _searchProducts(query),
)
```

---

## Real Apps Built with These Widgets

| Widget | Apps Using It |
|--------|--------------|
| **Row/Column** | Every app - Instagram, Twitter, Uber |
| **ListView** | WhatsApp chats, Spotify playlists, Email apps |
| **GridView** | Instagram photos, Netflix shows, Pinterest |
| **TextField** | Login screens, search bars, chat input |
| **StatefulWidget** | Like buttons, counters, toggles |

---

## Common UI Patterns

### Bottom Navigation (Instagram, TikTok)
```dart
Scaffold(
  body: pages[_currentIndex],
  bottomNavigationBar: BottomNavigationBar(
    currentIndex: _currentIndex,
    onTap: (index) => setState(() => _currentIndex = index),
    items: [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
      BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Search'),
      BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Create'),
      BottomNavigationBarItem(icon: Icon(Icons.favorite), label: 'Activity'),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
    ],
  ),
)
```

---

## Build It Yourself!

After this level, you could build:

1. **Profile Screen** - Row, Column, Images, Text
2. **Todo App** - ListView, TextField, Checkbox
3. **Counter App** - StatefulWidget, Buttons
4. **Contact List** - ListView, ListTile
5. **Simple Calculator** - Grid of buttons

---

**These widgets are the LEGO blocks of every Flutter app!**
