// ===========================================
// Example 05: Real World OOP
// Combining all OOP concepts
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: E-Commerce System
  // -----------------------------------------

  print('=== E-Commerce System ===\n');

  // Create products
  var laptop = Product(
    id: 'P001',
    name: 'Laptop',
    price: 999.99,
    category: 'Electronics',
  );

  var mouse = Product(
    id: 'P002',
    name: 'Wireless Mouse',
    price: 29.99,
    category: 'Electronics',
  );

  var book = Product(
    id: 'P003',
    name: 'Dart Programming',
    price: 49.99,
    category: 'Books',
  );

  // Create user and cart
  var user = User(
    id: 'U001',
    name: 'Alice',
    email: 'alice@email.com',
  );

  var cart = ShoppingCart(user);

  cart.addItem(laptop, 1);
  cart.addItem(mouse, 2);
  cart.addItem(book, 1);

  cart.printCart();

  // Checkout
  var payment = CreditCardPayment('1234-5678-9012-3456', 'Alice');
  var order = cart.checkout(payment);

  if (order != null) {
    order.printOrder();
  }

  // -----------------------------------------
  // PART 2: Social Media System
  // -----------------------------------------

  print('\n=== Social Media System ===\n');

  var alice = SocialUser('alice', 'Alice Smith');
  var bob = SocialUser('bob', 'Bob Jones');
  var charlie = SocialUser('charlie', 'Charlie Brown');

  // Follow relationships
  alice.follow(bob);
  alice.follow(charlie);
  bob.follow(alice);

  // Create posts
  var post1 = alice.createPost('Hello, world!');
  var post2 = bob.createPost('Learning Dart today!');

  // Interactions
  bob.likePost(post1);
  charlie.likePost(post1);
  charlie.commentOnPost(post1, 'Welcome!');

  alice.likePost(post2);
  alice.commentOnPost(post2, 'Great choice!');

  // Display feeds
  print('Alice\'s profile:');
  alice.displayProfile();

  print('\nBob\'s profile:');
  bob.displayProfile();

  print('\nAlice\'s feed:');
  alice.displayFeed();

  // -----------------------------------------
  // PART 3: Game System with Mixins
  // -----------------------------------------

  print('\n=== Game System ===\n');

  var warrior = GameWarrior('Conan', 100, 25);
  var mage = GameMage('Gandalf', 60, 100);
  var dragon = Dragon('Smaug', 500, 50);

  print('Initial status:');
  warrior.displayStatus();
  mage.displayStatus();
  dragon.displayStatus();

  print('\nBattle sequence:');

  // Warrior attacks dragon
  warrior.attack(dragon);
  dragon.displayStatus();

  // Dragon breathes fire at warrior
  dragon.breatheFire(warrior);
  warrior.displayStatus();

  // Mage heals warrior
  mage.heal(warrior, 30);
  warrior.displayStatus();

  // Mage casts spell
  mage.castSpell(dragon, 'Fireball', 40);
  dragon.displayStatus();

  // -----------------------------------------
  // PART 4: File System Simulation
  // -----------------------------------------

  print('\n=== File System ===\n');

  var root = Directory('root');

  var documents = Directory('Documents');
  var pictures = Directory('Pictures');

  var resume = File('resume.pdf', 1024);
  var notes = File('notes.txt', 256);
  var photo1 = File('vacation.jpg', 2048);
  var photo2 = File('family.jpg', 1536);

  documents.add(resume);
  documents.add(notes);
  pictures.add(photo1);
  pictures.add(photo2);
  root.add(documents);
  root.add(pictures);

  print('File system structure:');
  root.display();

  print('\nTotal size: ${root.size} bytes');

  // -----------------------------------------
  // PART 5: Restaurant Order System
  // -----------------------------------------

  print('\n=== Restaurant Order System ===\n');

  var menu = [
    MenuItem('Burger', 9.99, 'Main'),
    MenuItem('Pizza', 12.99, 'Main'),
    MenuItem('Salad', 7.99, 'Starter'),
    MenuItem('Fries', 3.99, 'Side'),
    MenuItem('Soda', 1.99, 'Drink'),
    MenuItem('Ice Cream', 4.99, 'Dessert'),
  ];

  var restaurant = Restaurant('Tasty Bites', menu);

  // Create orders
  var order1 = restaurant.createOrder('Table 1');
  order1.addItem('Burger', 2);
  order1.addItem('Fries', 2);
  order1.addItem('Soda', 2);

  var order2 = restaurant.createOrder('Table 2');
  order2.addItem('Pizza', 1);
  order2.addItem('Salad', 1);
  order2.addItem('Ice Cream', 2);

  print('Orders:');
  order1.printBill();
  order2.printBill();

  // Process orders
  restaurant.processOrder(order1);
  restaurant.processOrder(order2);

  print('\nRestaurant summary:');
  restaurant.printSummary();

  // -----------------------------------------
  // PART 6: Event System with Observer Pattern
  // -----------------------------------------

  print('\n=== Event System ===\n');

  var eventManager = EventManager();

  var emailNotifier = EmailNotifier('admin@app.com');
  var smsNotifier = SmsNotifier('+1234567890');
  var logNotifier = LogNotifier();

  eventManager.subscribe('user.registered', emailNotifier);
  eventManager.subscribe('user.registered', logNotifier);
  eventManager.subscribe('order.placed', emailNotifier);
  eventManager.subscribe('order.placed', smsNotifier);
  eventManager.subscribe('order.placed', logNotifier);

  print('Triggering events:\n');

  eventManager.emit('user.registered', {
    'userId': 'U123',
    'email': 'newuser@email.com',
  });

  eventManager.emit('order.placed', {
    'orderId': 'ORD456',
    'amount': 99.99,
  });
}

// ===========================================
// E-COMMERCE CLASSES
// ===========================================

class Product {
  final String id;
  final String name;
  final double price;
  final String category;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
  });
}

class User {
  final String id;
  final String name;
  final String email;

  User({required this.id, required this.name, required this.email});
}

class CartItem {
  final Product product;
  int quantity;

  CartItem(this.product, this.quantity);

  double get total => product.price * quantity;
}

class ShoppingCart {
  final User user;
  final List<CartItem> _items = [];
  double _discount = 0;

  ShoppingCart(this.user);

  void addItem(Product product, int quantity) {
    var existing = _items.where((i) => i.product.id == product.id);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    } else {
      _items.add(CartItem(product, quantity));
    }
    print('Added ${product.name} x$quantity to cart');
  }

  void removeItem(String productId) {
    _items.removeWhere((i) => i.product.id == productId);
  }

  double get subtotal => _items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal * (1 - _discount);

  void applyDiscount(double percent) {
    _discount = percent;
  }

  void printCart() {
    print('\nShopping Cart for ${user.name}:');
    print('-' * 40);
    for (var item in _items) {
      print('${item.product.name} x${item.quantity} @ \$${item.product.price} = \$${item.total.toStringAsFixed(2)}');
    }
    print('-' * 40);
    if (_discount > 0) {
      print('Subtotal: \$${subtotal.toStringAsFixed(2)}');
      print('Discount: ${(_discount * 100).toStringAsFixed(0)}%');
    }
    print('Total: \$${total.toStringAsFixed(2)}');
  }

  Order? checkout(PaymentProcessor payment) {
    if (_items.isEmpty) return null;

    if (payment.process(total)) {
      var order = Order(
        id: 'ORD${DateTime.now().millisecondsSinceEpoch}',
        user: user,
        items: List.from(_items),
        total: total,
      );
      _items.clear();
      return order;
    }
    return null;
  }
}

abstract class PaymentProcessor {
  bool process(double amount);
}

class CreditCardPayment extends PaymentProcessor {
  final String cardNumber;
  final String cardHolder;

  CreditCardPayment(this.cardNumber, this.cardHolder);

  @override
  bool process(double amount) {
    print('\nProcessing credit card payment of \$${amount.toStringAsFixed(2)}...');
    print('Card: **** **** **** ${cardNumber.substring(cardNumber.length - 4)}');
    print('Payment successful!\n');
    return true;
  }
}

class Order {
  final String id;
  final User user;
  final List<CartItem> items;
  final double total;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.user,
    required this.items,
    required this.total,
  }) : createdAt = DateTime.now();

  void printOrder() {
    print('Order Confirmation: $id');
    print('Customer: ${user.name} (${user.email})');
    print('Items: ${items.length}');
    print('Total: \$${total.toStringAsFixed(2)}');
  }
}

// ===========================================
// SOCIAL MEDIA CLASSES
// ===========================================

class SocialUser {
  final String username;
  final String displayName;
  final List<SocialUser> following = [];
  final List<SocialUser> followers = [];
  final List<Post> posts = [];

  SocialUser(this.username, this.displayName);

  void follow(SocialUser other) {
    if (!following.contains(other)) {
      following.add(other);
      other.followers.add(this);
      print('$displayName followed ${other.displayName}');
    }
  }

  Post createPost(String content) {
    var post = Post(this, content);
    posts.add(post);
    print('$displayName posted: "$content"');
    return post;
  }

  void likePost(Post post) {
    post.addLike(this);
    print('$displayName liked ${post.author.displayName}\'s post');
  }

  void commentOnPost(Post post, String text) {
    post.addComment(this, text);
    print('$displayName commented on ${post.author.displayName}\'s post');
  }

  void displayProfile() {
    print('  @$username ($displayName)');
    print('  Following: ${following.length} | Followers: ${followers.length}');
    print('  Posts: ${posts.length}');
  }

  void displayFeed() {
    var feedPosts = <Post>[];
    for (var user in following) {
      feedPosts.addAll(user.posts);
    }
    feedPosts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    for (var post in feedPosts.take(5)) {
      post.display();
    }
  }
}

class Post {
  final SocialUser author;
  final String content;
  final DateTime createdAt;
  final List<SocialUser> likes = [];
  final List<Comment> comments = [];

  Post(this.author, this.content) : createdAt = DateTime.now();

  void addLike(SocialUser user) {
    if (!likes.contains(user)) {
      likes.add(user);
    }
  }

  void addComment(SocialUser user, String text) {
    comments.add(Comment(user, text));
  }

  void display() {
    print('  @${author.username}: $content');
    print('    ${likes.length} likes, ${comments.length} comments\n');
  }
}

class Comment {
  final SocialUser author;
  final String text;
  final DateTime createdAt;

  Comment(this.author, this.text) : createdAt = DateTime.now();
}

// ===========================================
// GAME SYSTEM WITH MIXINS
// ===========================================

mixin Attackable {
  int get attackPower;

  void attack(GameCharacter target) {
    print('Attacking ${target.name} for $attackPower damage!');
    target.takeDamage(attackPower);
  }
}

mixin Healable {
  void heal(GameCharacter target, int amount) {
    print('Healing ${target.name} for $amount HP!');
    target.restoreHealth(amount);
  }
}

mixin Flammable {
  void breatheFire(GameCharacter target) {
    int damage = 35;
    print('Breathing fire at ${target.name} for $damage damage!');
    target.takeDamage(damage);
  }
}

abstract class GameCharacter {
  String name;
  int maxHealth;
  int currentHealth;

  GameCharacter(this.name, this.maxHealth) : currentHealth = maxHealth;

  void takeDamage(int amount) {
    currentHealth -= amount;
    if (currentHealth < 0) currentHealth = 0;
  }

  void restoreHealth(int amount) {
    currentHealth += amount;
    if (currentHealth > maxHealth) currentHealth = maxHealth;
  }

  void displayStatus() {
    print('$name: $currentHealth/$maxHealth HP');
  }
}

class GameWarrior extends GameCharacter with Attackable {
  @override
  int attackPower;

  GameWarrior(String name, int health, this.attackPower) : super(name, health);
}

class GameMage extends GameCharacter with Attackable, Healable {
  int mana;

  @override
  int attackPower = 10;

  GameMage(String name, int health, this.mana) : super(name, health);

  void castSpell(GameCharacter target, String spellName, int damage) {
    if (mana >= 20) {
      mana -= 20;
      print('Casting $spellName at ${target.name} for $damage damage!');
      target.takeDamage(damage);
    } else {
      print('Not enough mana!');
    }
  }
}

class Dragon extends GameCharacter with Attackable, Flammable {
  @override
  int attackPower;

  Dragon(String name, int health, this.attackPower) : super(name, health);
}

// ===========================================
// FILE SYSTEM CLASSES (Composite Pattern)
// ===========================================

abstract class FileSystemItem {
  String name;

  FileSystemItem(this.name);

  int get size;
  void display([String indent = '']);
}

class File extends FileSystemItem {
  @override
  int size;

  File(String name, this.size) : super(name);

  @override
  void display([String indent = '']) {
    print('$indent📄 $name ($size bytes)');
  }
}

class Directory extends FileSystemItem {
  final List<FileSystemItem> _children = [];

  Directory(String name) : super(name);

  void add(FileSystemItem item) {
    _children.add(item);
  }

  void remove(FileSystemItem item) {
    _children.remove(item);
  }

  @override
  int get size => _children.fold(0, (sum, item) => sum + item.size);

  @override
  void display([String indent = '']) {
    print('$indent📁 $name/');
    for (var child in _children) {
      child.display('$indent  ');
    }
  }
}

// ===========================================
// RESTAURANT ORDER SYSTEM
// ===========================================

class MenuItem {
  final String name;
  final double price;
  final String category;

  MenuItem(this.name, this.price, this.category);
}

class OrderItem {
  final MenuItem menuItem;
  int quantity;

  OrderItem(this.menuItem, this.quantity);

  double get total => menuItem.price * quantity;
}

class RestaurantOrder {
  final String id;
  final String tableName;
  final List<OrderItem> items = [];
  final DateTime createdAt;
  String status = 'pending';

  RestaurantOrder(this.id, this.tableName) : createdAt = DateTime.now();

  void addItem(String itemName, int quantity) {
    var existing = items.where((i) => i.menuItem.name == itemName);
    if (existing.isNotEmpty) {
      existing.first.quantity += quantity;
    }
  }

  double get total => items.fold(0, (sum, item) => sum + item.total);

  void printBill() {
    print('\n--- $tableName ($id) ---');
    for (var item in items) {
      print('${item.menuItem.name} x${item.quantity}: \$${item.total.toStringAsFixed(2)}');
    }
    print('Total: \$${total.toStringAsFixed(2)}');
    print('Status: $status');
  }
}

class Restaurant {
  final String name;
  final List<MenuItem> menu;
  final List<RestaurantOrder> orders = [];
  double totalRevenue = 0;

  Restaurant(this.name, this.menu);

  RestaurantOrder createOrder(String tableName) {
    var order = RestaurantOrder(
      'ORD${orders.length + 1}',
      tableName,
    );

    // Helper to add items
    order.addItem = (String itemName, int qty) {
      var menuItem = menu.firstWhere(
            (m) => m.name == itemName,
        orElse: () => throw Exception('Item not found'),
      );
      order.items.add(OrderItem(menuItem, qty));
    };

    orders.add(order);
    return order;
  }

  void processOrder(RestaurantOrder order) {
    order.status = 'completed';
    totalRevenue += order.total;
    print('Order ${order.id} completed!');
  }

  void printSummary() {
    print('$name Summary:');
    print('Total orders: ${orders.length}');
    print('Completed: ${orders.where((o) => o.status == 'completed').length}');
    print('Revenue: \$${totalRevenue.toStringAsFixed(2)}');
  }
}

// Helper extension
extension OrderExtension on RestaurantOrder {
  set addItem(void Function(String, int) fn) {}
}

// ===========================================
// EVENT SYSTEM (Observer Pattern)
// ===========================================

abstract class EventListener {
  void onEvent(String eventType, Map<String, dynamic> data);
}

class EventManager {
  final Map<String, List<EventListener>> _listeners = {};

  void subscribe(String eventType, EventListener listener) {
    _listeners.putIfAbsent(eventType, () => []);
    _listeners[eventType]!.add(listener);
  }

  void unsubscribe(String eventType, EventListener listener) {
    _listeners[eventType]?.remove(listener);
  }

  void emit(String eventType, Map<String, dynamic> data) {
    print('Event: $eventType');
    for (var listener in _listeners[eventType] ?? []) {
      listener.onEvent(eventType, data);
    }
    print('');
  }
}

class EmailNotifier extends EventListener {
  final String adminEmail;

  EmailNotifier(this.adminEmail);

  @override
  void onEvent(String eventType, Map<String, dynamic> data) {
    print('  [Email] Sending notification to $adminEmail');
    print('    Event: $eventType, Data: $data');
  }
}

class SmsNotifier extends EventListener {
  final String phoneNumber;

  SmsNotifier(this.phoneNumber);

  @override
  void onEvent(String eventType, Map<String, dynamic> data) {
    print('  [SMS] Sending to $phoneNumber');
    print('    Event: $eventType');
  }
}

class LogNotifier extends EventListener {
  @override
  void onEvent(String eventType, Map<String, dynamic> data) {
    print('  [Log] $eventType: $data');
  }
}

// ===========================================
// Try it yourself:
// 1. Add a Wishlist feature to e-commerce
// 2. Add a ReShare feature to social media
// 3. Add inventory system to restaurant
// ===========================================
