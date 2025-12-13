// ===========================================
// Example 02: Constructors
// Different ways to create objects
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Basic Constructor
  // -----------------------------------------

  print('=== Basic Constructor ===\n');

  var person = Person('Alice', 25);
  print('Name: ${person.name}, Age: ${person.age}');

  // -----------------------------------------
  // PART 2: Named Constructors
  // -----------------------------------------

  print('\n=== Named Constructors ===\n');

  var p1 = Point(3, 4);
  var p2 = Point.origin();
  var p3 = Point.onXAxis(5);
  var p4 = Point.onYAxis(7);
  var p5 = Point.fromPoint(p1);

  print('p1: $p1');
  print('p2 (origin): $p2');
  print('p3 (x-axis): $p3');
  print('p4 (y-axis): $p4');
  print('p5 (copy): $p5');

  // -----------------------------------------
  // PART 3: Named Parameters
  // -----------------------------------------

  print('\n=== Named Parameters ===\n');

  var user1 = User(
    name: 'Alice',
    email: 'alice@email.com',
  );

  var user2 = User(
    name: 'Bob',
    email: 'bob@email.com',
    age: 30,
    isActive: false,
  );

  user1.printInfo();
  user2.printInfo();

  // -----------------------------------------
  // PART 4: Initializer List
  // -----------------------------------------

  print('\n=== Initializer List ===\n');

  var rect = Rectangle(5, 3);
  print('Rectangle 5x3:');
  print('  Area: ${rect.area}');
  print('  Perimeter: ${rect.perimeter}');
  print('  Diagonal: ${rect.diagonal.toStringAsFixed(2)}');

  // -----------------------------------------
  // PART 5: Factory Constructor
  // -----------------------------------------

  print('\n=== Factory Constructor ===\n');

  // Logger is a singleton - always same instance
  var logger1 = Logger();
  var logger2 = Logger();

  print('Same logger: ${identical(logger1, logger2)}');

  logger1.log('First message');
  logger2.log('Second message');

  // -----------------------------------------
  // PART 6: Factory with Caching
  // -----------------------------------------

  print('\n=== Factory with Caching ===\n');

  var red1 = Color(255, 0, 0);
  var red2 = Color(255, 0, 0);
  var red3 = Color.red();

  print('red1: $red1');
  print('red2: $red2');
  print('red3: $red3');

  print('red1 == red2: ${identical(red1, red2)}');  // true (cached)
  print('red1 == red3: ${identical(red1, red3)}');  // true (cached)

  var blue = Color.blue();
  print('blue: $blue');

  // -----------------------------------------
  // PART 7: Const Constructor
  // -----------------------------------------

  print('\n=== Const Constructor ===\n');

  const vec1 = Vector(1, 2);
  const vec2 = Vector(1, 2);
  const vec3 = Vector(3, 4);

  print('vec1: $vec1');
  print('vec2: $vec2');
  print('vec3: $vec3');

  print('vec1 == vec2: ${identical(vec1, vec2)}');  // true (compile-time const)
  print('vec1 == vec3: ${identical(vec1, vec3)}');  // false

  // Non-const
  var vec4 = Vector(1, 2);
  print('vec1 == vec4: ${identical(vec1, vec4)}');  // false (not const)

  // -----------------------------------------
  // PART 8: Private Constructor
  // -----------------------------------------

  print('\n=== Private Constructor (Singleton) ===\n');

  var db1 = Database.instance;
  var db2 = Database.instance;

  print('Same database: ${identical(db1, db2)}');

  db1.connect();
  db2.query('SELECT * FROM users');

  // -----------------------------------------
  // PART 9: Redirecting Constructors
  // -----------------------------------------

  print('\n=== Redirecting Constructors ===\n');

  var r1 = Rect(0, 0, 10, 10);
  var r2 = Rect.square(5);
  var r3 = Rect.fromSize(20, 15);

  r1.print();
  r2.print();
  r3.print();

  // -----------------------------------------
  // PART 10: Constructor with Validation
  // -----------------------------------------

  print('\n=== Constructor with Validation ===\n');

  try {
    var email1 = Email('alice@email.com');
    print('Valid email: ${email1.address}');

    var email2 = Email('invalid-email');  // Will throw
    print('This won\'t print');
  } catch (e) {
    print('Error: $e');
  }

  // -----------------------------------------
  // PART 11: fromJson / toJson Pattern
  // -----------------------------------------

  print('\n=== fromJson / toJson ===\n');

  // Simulate JSON from API
  var json = {
    'id': '123',
    'name': 'Laptop',
    'price': 999.99,
    'inStock': true,
  };

  var product = Product.fromJson(json);
  print('Product: ${product.name} (\$${product.price})');
  print('In stock: ${product.inStock}');

  // Convert back to JSON
  var outputJson = product.toJson();
  print('As JSON: $outputJson');

  // -----------------------------------------
  // PART 12: copyWith Pattern
  // -----------------------------------------

  print('\n=== copyWith Pattern ===\n');

  var settings = Settings(
    theme: 'dark',
    fontSize: 14,
    notifications: true,
  );

  print('Original: $settings');

  var newSettings = settings.copyWith(fontSize: 18);
  print('With larger font: $newSettings');

  var lightSettings = settings.copyWith(theme: 'light', notifications: false);
  print('Light mode, no notifications: $lightSettings');
}

// ===========================================
// CLASS DEFINITIONS
// ===========================================

class Person {
  String name;
  int age;

  Person(this.name, this.age);
}

class Point {
  double x;
  double y;

  // Default constructor
  Point(this.x, this.y);

  // Named constructors
  Point.origin() : x = 0, y = 0;

  Point.onXAxis(double x) : x = x, y = 0;

  Point.onYAxis(double y) : x = 0, y = y;

  Point.fromPoint(Point other) : x = other.x, y = other.y;

  @override
  String toString() => 'Point($x, $y)';
}

class User {
  String name;
  String email;
  int? age;
  bool isActive;

  User({
    required this.name,
    required this.email,
    this.age,
    this.isActive = true,
  });

  void printInfo() {
    print('User: $name');
    print('  Email: $email');
    print('  Age: ${age ?? 'Not specified'}');
    print('  Active: $isActive');
  }
}

class Rectangle {
  double width;
  double height;
  double area;
  double perimeter;
  double diagonal;

  Rectangle(this.width, this.height)
      : area = width * height,
        perimeter = 2 * (width + height),
        diagonal = _calculateDiagonal(width, height);

  static double _calculateDiagonal(double w, double h) {
    return (w * w + h * h);  // Simplified for example
  }
}

class Logger {
  static final Logger _instance = Logger._internal();

  factory Logger() => _instance;

  Logger._internal();

  void log(String message) {
    print('[LOG] $message');
  }
}

class Color {
  final int red;
  final int green;
  final int blue;

  static final Map<String, Color> _cache = {};

  factory Color(int r, int g, int b) {
    var key = '$r,$g,$b';
    return _cache.putIfAbsent(key, () => Color._internal(r, g, b));
  }

  Color._internal(this.red, this.green, this.blue);

  factory Color.red() => Color(255, 0, 0);
  factory Color.green() => Color(0, 255, 0);
  factory Color.blue() => Color(0, 0, 255);

  @override
  String toString() => 'Color($red, $green, $blue)';
}

class Vector {
  final double x;
  final double y;

  const Vector(this.x, this.y);

  @override
  String toString() => 'Vector($x, $y)';
}

class Database {
  static final Database _instance = Database._internal();

  static Database get instance => _instance;

  Database._internal();

  void connect() {
    print('Database connected');
  }

  void query(String sql) {
    print('Executing: $sql');
  }
}

class Rect {
  double x, y, width, height;

  Rect(this.x, this.y, this.width, this.height);

  Rect.square(double size) : this(0, 0, size, size);

  Rect.fromSize(double width, double height) : this(0, 0, width, height);

  void print() {
    final p = print;  // Avoid shadowing
    p('Rect at ($x, $y), size: ${width}x$height');
  }
}

class Email {
  final String address;

  Email(this.address) {
    if (!address.contains('@')) {
      throw ArgumentError('Invalid email address: $address');
    }
  }
}

class Product {
  final String id;
  final String name;
  final double price;
  final bool inStock;

  Product({
    required this.id,
    required this.name,
    required this.price,
    this.inStock = true,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'] as String,
        name = json['name'] as String,
        price = (json['price'] as num).toDouble(),
        inStock = json['inStock'] as bool? ?? true;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'inStock': inStock,
  };
}

class Settings {
  final String theme;
  final int fontSize;
  final bool notifications;

  Settings({
    required this.theme,
    required this.fontSize,
    required this.notifications,
  });

  Settings copyWith({
    String? theme,
    int? fontSize,
    bool? notifications,
  }) {
    return Settings(
      theme: theme ?? this.theme,
      fontSize: fontSize ?? this.fontSize,
      notifications: notifications ?? this.notifications,
    );
  }

  @override
  String toString() =>
      'Settings(theme: $theme, fontSize: $fontSize, notifications: $notifications)';
}

// ===========================================
// Try it yourself:
// 1. Create a Car class with named constructor Car.electric()
// 2. Implement a singleton ConfigManager class
// 3. Create a DateTime wrapper with fromString constructor
// ===========================================
