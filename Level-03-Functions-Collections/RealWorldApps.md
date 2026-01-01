# Level 3: Real-World Apps Using These Concepts

See how functions and collections organize data in real applications!

---

## Functions

### Reusable Code Powers Everything!

**Uber**
```dart
double calculateFare(double distance, double time) {
  double baseFare = 2.50;
  double distanceCharge = distance * 1.50;
  double timeCharge = time * 0.20;
  return baseFare + distanceCharge + timeCharge;
}
```

**Instagram**
```dart
String formatFollowerCount(int count) {
  if (count >= 1000000) {
    return '${(count / 1000000).toStringAsFixed(1)}M';
  } else if (count >= 1000) {
    return '${(count / 1000).toStringAsFixed(1)}K';
  }
  return count.toString();
}

// 1500000 → "1.5M"
// 25000 → "25K"
```

**Payment Apps**
```dart
bool validateCreditCard(String cardNumber) {
  return cardNumber.length == 16 &&
         cardNumber.startsWith('4');  // Visa check
}
```

---

## Lists

### Ordered Collections Everywhere!

**Spotify - Playlist**
```dart
List<Song> playlist = [
  Song('Bohemian Rhapsody'),
  Song('Hotel California'),
  Song('Stairway to Heaven'),
];

void shuffle() {
  playlist.shuffle();  // Randomize order
}

void addToPlaylist(Song song) {
  playlist.add(song);
}
```

**Shopping Cart**
```dart
List<CartItem> cart = [];

void addItem(Product product) {
  cart.add(CartItem(product: product, quantity: 1));
}

double getTotal() {
  double total = 0;
  for (var item in cart) {
    total += item.product.price * item.quantity;
  }
  return total;
}
```

**Twitter Timeline**
```dart
List<Tweet> timeline = [];

void loadMoreTweets() {
  List<Tweet> newTweets = fetchFromServer();
  timeline.addAll(newTweets);
}
```

---

## Maps

### Key-Value Pairs for Quick Lookup!

**User Profiles**
```dart
Map<String, dynamic> userProfile = {
  'name': 'John Doe',
  'email': 'john@example.com',
  'followers': 1500,
  'isVerified': true,
};

String getName() => userProfile['name'];
```

**Settings Storage**
```dart
Map<String, bool> appSettings = {
  'darkMode': true,
  'notifications': true,
  'autoPlay': false,
  'saveData': true,
};

void toggleDarkMode() {
  appSettings['darkMode'] = !appSettings['darkMode']!;
}
```

**Language Translation**
```dart
Map<String, String> translations = {
  'hello': 'Hola',
  'goodbye': 'Adiós',
  'thank you': 'Gracias',
};

String translate(String word) {
  return translations[word] ?? word;
}
```

---

## Sets

### Unique Items Only!

**Netflix - Watch History**
```dart
Set<String> watchedMovies = {'Inception', 'Avatar', 'Titanic'};

void markAsWatched(String movie) {
  watchedMovies.add(movie);  // Won't duplicate
}

bool hasWatched(String movie) {
  return watchedMovies.contains(movie);
}
```

**Social Media - Unique Tags**
```dart
Set<String> hashtags = {'#flutter', '#coding', '#flutter'};
// Only stores {'#flutter', '#coding'} - no duplicates!
```

**Friend Suggestions**
```dart
Set<String> myFriends = {'Alice', 'Bob', 'Charlie'};
Set<String> theirFriends = {'Charlie', 'David', 'Eve'};

Set<String> mutualFriends = myFriends.intersection(theirFriends);
// {'Charlie'}
```

---

## Real Apps Using These Patterns

| App | Functions/Collections Used |
|-----|---------------------------|
| **Amazon** | Lists for products, Maps for cart quantities |
| **Spotify** | Lists for playlists, Sets for liked songs |
| **Gmail** | Lists for emails, Maps for labels/folders |
| **Instagram** | Sets for followers, Maps for user profiles |
| **Uber** | Functions for fare calculation, Lists for trip history |

---

## Common Patterns You'll See

### Filter a List
```dart
// Instagram: Show only photos (not videos)
List<Post> photos = posts.where((p) => p.type == 'photo').toList();
```

### Transform a List
```dart
// Get just the names from contacts
List<String> names = contacts.map((c) => c.name).toList();
```

### Find in a List
```dart
// Find a specific product
Product? found = products.firstWhere(
  (p) => p.id == searchId,
  orElse: () => null,
);
```

---

## Build It Yourself!

After this level, you could build:

1. **Contact Manager** - Store contacts in a Map
2. **Todo List** - List with add/remove functions
3. **Word Counter** - Map for word frequencies
4. **Shopping List** - Set for unique items
5. **Simple Calculator** - Functions for each operation

---

**Functions organize your logic, collections organize your data!**
