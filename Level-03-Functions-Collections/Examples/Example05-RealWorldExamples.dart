// ===========================================
// Example 05: Real World Examples
// Combining functions and collections
// ===========================================

void main() {
  // -----------------------------------------
  // EXAMPLE 1: Todo List Manager
  // -----------------------------------------

  print('=== TODO LIST MANAGER ===\n');

  var todos = <Map<String, dynamic>>[];

  // Add todos
  todos.add(createTodo('Learn Dart'));
  todos.add(createTodo('Build Flutter app'));
  todos.add(createTodo('Write tests'));
  todos.add(createTodo('Deploy to store'));

  // Display all
  printTodos(todos);

  // Complete some tasks
  completeTodo(todos, 0);
  completeTodo(todos, 2);
  print('\nAfter completing tasks:');
  printTodos(todos);

  // Show stats
  printTodoStats(todos);

  // -----------------------------------------
  // EXAMPLE 2: Student Grade System
  // -----------------------------------------

  print('\n=== STUDENT GRADE SYSTEM ===\n');

  var students = [
    Student('Alice', [85, 90, 92, 88]),
    Student('Bob', [78, 82, 75, 80]),
    Student('Charlie', [95, 98, 92, 96]),
    Student('Diana', [67, 72, 69, 74]),
    Student('Eve', [88, 85, 90, 87]),
  ];

  // Print report
  printStudentReport(students);

  // Find honor roll (avg >= 85)
  print('\nHonor Roll:');
  var honorRoll = students.where((s) => s.average >= 85).toList();
  for (var s in honorRoll) {
    print('  ${s.name}: ${s.average.toStringAsFixed(1)}');
  }

  // -----------------------------------------
  // EXAMPLE 3: Shopping Cart
  // -----------------------------------------

  print('\n=== SHOPPING CART ===\n');

  var cart = ShoppingCart();

  cart.addItem('Apple', 1.50, 5);
  cart.addItem('Bread', 2.50, 2);
  cart.addItem('Milk', 3.00, 1);
  cart.addItem('Eggs', 4.00, 2);
  cart.addItem('Cheese', 5.50, 1);

  cart.printCart();

  // Apply discount
  cart.applyDiscount(0.10);  // 10% off
  print('\nAfter 10% discount:');
  cart.printCart();

  // Remove an item
  cart.removeItem('Bread');
  print('\nAfter removing Bread:');
  cart.printCart();

  // -----------------------------------------
  // EXAMPLE 4: Contact Manager
  // -----------------------------------------

  print('\n=== CONTACT MANAGER ===\n');

  var contacts = ContactManager();

  contacts.add(Contact('Alice', 'alice@email.com', '555-0101'));
  contacts.add(Contact('Bob', 'bob@email.com', '555-0102'));
  contacts.add(Contact('Charlie', 'charlie@email.com', '555-0103'));
  contacts.add(Contact('Alice Smith', 'alice.smith@email.com', '555-0104'));

  // List all
  contacts.printAll();

  // Search
  print('\nSearching for "Alice":');
  contacts.search('Alice').forEach((c) => print('  ${c.name}: ${c.phone}'));

  // Update
  contacts.update('Bob', phone: '555-9999');
  print('\nAfter updating Bob:');
  contacts.find('Bob')?.print();

  // -----------------------------------------
  // EXAMPLE 5: Word Statistics
  // -----------------------------------------

  print('\n=== WORD STATISTICS ===\n');

  var text = '''
  Flutter is Google's UI toolkit for building beautiful,
  natively compiled applications for mobile, web, and desktop
  from a single codebase. Flutter is used by developers
  around the world. Flutter is free and open source.
  ''';

  var stats = analyzeText(text);

  print('Text Analysis Results:');
  print('  Total words: ${stats['totalWords']}');
  print('  Unique words: ${stats['uniqueWords']}');
  print('  Average word length: ${stats['avgLength']}');
  print('\nTop 5 words:');
  for (var word in stats['topWords'] as List) {
    print('  ${word['word']}: ${word['count']} times');
  }

  // -----------------------------------------
  // EXAMPLE 6: Event Scheduler
  // -----------------------------------------

  print('\n=== EVENT SCHEDULER ===\n');

  var scheduler = EventScheduler();

  scheduler.addEvent(Event('Meeting', DateTime(2024, 1, 15, 10, 0)));
  scheduler.addEvent(Event('Lunch', DateTime(2024, 1, 15, 12, 30)));
  scheduler.addEvent(Event('Review', DateTime(2024, 1, 15, 14, 0)));
  scheduler.addEvent(Event('Workshop', DateTime(2024, 1, 16, 9, 0)));
  scheduler.addEvent(Event('Demo', DateTime(2024, 1, 16, 15, 0)));

  scheduler.printSchedule();

  // Get events for specific day
  print('\nEvents on Jan 15:');
  var jan15Events = scheduler.getEventsForDate(DateTime(2024, 1, 15));
  for (var e in jan15Events) {
    e.print();
  }

  // -----------------------------------------
  // EXAMPLE 7: Inventory System
  // -----------------------------------------

  print('\n=== INVENTORY SYSTEM ===\n');

  var inventory = Inventory();

  // Add products
  inventory.addProduct('Laptop', 999.99, 10);
  inventory.addProduct('Mouse', 29.99, 50);
  inventory.addProduct('Keyboard', 79.99, 30);
  inventory.addProduct('Monitor', 299.99, 15);

  inventory.printInventory();

  // Process orders
  inventory.sell('Laptop', 3);
  inventory.sell('Mouse', 10);

  print('\nAfter sales:');
  inventory.printInventory();

  // Restock
  inventory.restock('Laptop', 5);
  print('\nAfter restocking:');
  inventory.printInventory();

  // Low stock alert
  inventory.lowStockAlert(20);
}

// ===========================================
// HELPER CLASSES AND FUNCTIONS
// ===========================================

// --- Todo List ---

Map<String, dynamic> createTodo(String task) {
  return {
    'task': task,
    'completed': false,
    'createdAt': DateTime.now(),
  };
}

void completeTodo(List<Map<String, dynamic>> todos, int index) {
  if (index >= 0 && index < todos.length) {
    todos[index]['completed'] = true;
  }
}

void printTodos(List<Map<String, dynamic>> todos) {
  for (int i = 0; i < todos.length; i++) {
    var todo = todos[i];
    var status = todo['completed'] ? '✓' : '○';
    print('$i. [$status] ${todo['task']}');
  }
}

void printTodoStats(List<Map<String, dynamic>> todos) {
  var completed = todos.where((t) => t['completed'] == true).length;
  print('\nStats: $completed/${todos.length} completed');
}

// --- Student Grades ---

class Student {
  String name;
  List<int> grades;

  Student(this.name, this.grades);

  double get average => grades.reduce((a, b) => a + b) / grades.length;

  String get letterGrade {
    var avg = average;
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return 'F';
  }
}

void printStudentReport(List<Student> students) {
  print('Student Report:');
  print('-' * 40);

  students.sort((a, b) => b.average.compareTo(a.average));

  for (var s in students) {
    print('${s.name.padRight(15)} '
        'Avg: ${s.average.toStringAsFixed(1).padLeft(5)} '
        'Grade: ${s.letterGrade}');
  }
}

// --- Shopping Cart ---

class ShoppingCart {
  List<Map<String, dynamic>> items = [];

  void addItem(String name, double price, int qty) {
    items.add({'name': name, 'price': price, 'qty': qty});
  }

  void removeItem(String name) {
    items.removeWhere((i) => i['name'] == name);
  }

  void applyDiscount(double percent) {
    for (var item in items) {
      item['price'] = (item['price'] as double) * (1 - percent);
    }
  }

  double get total {
    return items.fold(0.0, (sum, item) {
      return sum + (item['price'] as double) * (item['qty'] as int);
    });
  }

  void printCart() {
    print('Shopping Cart:');
    for (var item in items) {
      var subtotal = (item['price'] as double) * (item['qty'] as int);
      print('  ${item['name']}: ${item['qty']} x '
          '\$${(item['price'] as double).toStringAsFixed(2)} = '
          '\$${subtotal.toStringAsFixed(2)}');
    }
    print('  ${'=' * 30}');
    print('  Total: \$${total.toStringAsFixed(2)}');
  }
}

// --- Contact Manager ---

class Contact {
  String name;
  String email;
  String phone;

  Contact(this.name, this.email, this.phone);

  void print() {
    final p = print;  // Avoid conflict with method name
    p('  $name');
    p('    Email: $email');
    p('    Phone: $phone');
  }
}

class ContactManager {
  List<Contact> contacts = [];

  void add(Contact contact) {
    contacts.add(contact);
  }

  void remove(String name) {
    contacts.removeWhere((c) => c.name == name);
  }

  Contact? find(String name) {
    try {
      return contacts.firstWhere((c) => c.name == name);
    } catch (e) {
      return null;
    }
  }

  List<Contact> search(String query) {
    return contacts.where((c) =>
    c.name.toLowerCase().contains(query.toLowerCase()) ||
        c.email.toLowerCase().contains(query.toLowerCase())
    ).toList();
  }

  void update(String name, {String? email, String? phone}) {
    var contact = find(name);
    if (contact != null) {
      if (email != null) contact.email = email;
      if (phone != null) contact.phone = phone;
    }
  }

  void printAll() {
    print('Contacts (${contacts.length}):');
    for (var c in contacts) {
      print('  ${c.name}: ${c.phone}');
    }
  }
}

// --- Word Statistics ---

Map<String, dynamic> analyzeText(String text) {
  // Clean and split
  var words = text.toLowerCase()
      .replaceAll(RegExp(r'[^\w\s]'), '')
      .split(RegExp(r'\s+'))
      .where((w) => w.isNotEmpty)
      .toList();

  // Count frequency
  var frequency = <String, int>{};
  for (var word in words) {
    frequency[word] = (frequency[word] ?? 0) + 1;
  }

  // Sort by frequency
  var sorted = frequency.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  // Calculate average length
  var totalLength = words.fold(0, (sum, w) => sum + w.length);
  var avgLength = (totalLength / words.length).toStringAsFixed(1);

  return {
    'totalWords': words.length,
    'uniqueWords': frequency.length,
    'avgLength': avgLength,
    'topWords': sorted.take(5).map((e) => {
      'word': e.key,
      'count': e.value,
    }).toList(),
  };
}

// --- Event Scheduler ---

class Event {
  String title;
  DateTime dateTime;

  Event(this.title, this.dateTime);

  void print() {
    final p = print;
    var time = '${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
    p('  $time - $title');
  }
}

class EventScheduler {
  List<Event> events = [];

  void addEvent(Event event) {
    events.add(event);
    events.sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Event> getEventsForDate(DateTime date) {
    return events.where((e) =>
    e.dateTime.year == date.year &&
        e.dateTime.month == date.month &&
        e.dateTime.day == date.day
    ).toList();
  }

  void printSchedule() {
    print('Upcoming Events:');
    for (var e in events) {
      var date = '${e.dateTime.month}/${e.dateTime.day}';
      var time = '${e.dateTime.hour}:${e.dateTime.minute.toString().padLeft(2, '0')}';
      print('  $date $time - ${e.title}');
    }
  }
}

// --- Inventory System ---

class Inventory {
  Map<String, Map<String, dynamic>> products = {};

  void addProduct(String name, double price, int stock) {
    products[name] = {'price': price, 'stock': stock};
  }

  void sell(String name, int qty) {
    if (products.containsKey(name)) {
      var current = products[name]!['stock'] as int;
      if (current >= qty) {
        products[name]!['stock'] = current - qty;
        print('Sold $qty $name');
      } else {
        print('Not enough $name in stock (have $current, need $qty)');
      }
    }
  }

  void restock(String name, int qty) {
    if (products.containsKey(name)) {
      products[name]!['stock'] = (products[name]!['stock'] as int) + qty;
      print('Restocked $qty $name');
    }
  }

  void lowStockAlert(int threshold) {
    var lowStock = products.entries
        .where((e) => (e.value['stock'] as int) < threshold)
        .toList();

    if (lowStock.isNotEmpty) {
      print('\nLow Stock Alert (< $threshold):');
      for (var e in lowStock) {
        print('  ${e.key}: ${e.value['stock']} remaining');
      }
    }
  }

  void printInventory() {
    print('Inventory:');
    var totalValue = 0.0;
    products.forEach((name, data) {
      var value = (data['price'] as double) * (data['stock'] as int);
      totalValue += value;
      print('  $name: ${data['stock']} @ \$${data['price']} = \$${value.toStringAsFixed(2)}');
    });
    print('  Total Value: \$${totalValue.toStringAsFixed(2)}');
  }
}

// ===========================================
// Try it yourself:
// 1. Add a due date feature to the todo list
// 2. Add a highest/lowest grade finder to student report
// 3. Add a wishlist feature to the shopping cart
// ===========================================
