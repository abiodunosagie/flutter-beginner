// ===========================================
// Example 04: Polymorphism
// Same interface, different implementations
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Basic Polymorphism
  // -----------------------------------------

  print('=== Basic Polymorphism ===\n');

  // Different objects, same type
  Animal dog = Dog('Buddy');
  Animal cat = Cat('Whiskers');
  Animal cow = Cow('Bessie');

  // Same method call, different behavior!
  dog.speak();  // Woof!
  cat.speak();  // Meow!
  cow.speak();  // Moo!

  // -----------------------------------------
  // PART 2: Polymorphism with Collections
  // -----------------------------------------

  print('\n=== Polymorphism with Collections ===\n');

  List<Animal> animals = [
    Dog('Rex'),
    Cat('Mittens'),
    Cow('Daisy'),
    Dog('Max'),
    Cat('Felix'),
  ];

  print('Animal sounds:');
  for (var animal in animals) {
    animal.speak();  // Each animal speaks differently
  }

  // -----------------------------------------
  // PART 3: Polymorphic Functions
  // -----------------------------------------

  print('\n=== Polymorphic Functions ===\n');

  void feedAnimal(Animal animal) {
    print('Feeding ${animal.name}...');
    animal.speak();  // Polymorphic call
  }

  feedAnimal(Dog('Buddy'));
  feedAnimal(Cat('Whiskers'));

  // -----------------------------------------
  // PART 4: Shape Calculator
  // -----------------------------------------

  print('\n=== Shape Calculator ===\n');

  List<Shape> shapes = [
    Rectangle(5, 3),
    Circle(4),
    Triangle(6, 4),
    Rectangle(10, 2),
    Circle(2.5),
  ];

  double totalArea = 0;

  for (var shape in shapes) {
    var area = shape.area();
    totalArea += area;
    print('${shape.name}: area = ${area.toStringAsFixed(2)}');
  }

  print('Total area: ${totalArea.toStringAsFixed(2)}');

  // -----------------------------------------
  // PART 5: Payment Processing
  // -----------------------------------------

  print('\n=== Payment Processing ===\n');

  List<PaymentMethod> payments = [
    CreditCard('1234-5678-9012-3456', 'Alice'),
    PayPal('alice@email.com'),
    BankTransfer('ACC123456', 'BigBank'),
    Cash(),
  ];

  double amount = 99.99;

  for (var payment in payments) {
    print('Processing with ${payment.name}:');
    if (payment.processPayment(amount)) {
      print('  Success!\n');
    } else {
      print('  Failed!\n');
    }
  }

  // -----------------------------------------
  // PART 6: Type Checking with 'is'
  // -----------------------------------------

  print('=== Type Checking ===\n');

  void describeAnimal(Animal animal) {
    print('This is ${animal.name}, a ${animal.runtimeType}');

    if (animal is Dog) {
      print('  It can bark and fetch!');
      animal.fetch();  // Safe to call Dog-specific method
    } else if (animal is Cat) {
      print('  It can purr and climb!');
      animal.purr();
    } else if (animal is Cow) {
      print('  It gives milk!');
      animal.giveMilk();
    }
  }

  describeAnimal(Dog('Rex'));
  describeAnimal(Cat('Mittens'));
  describeAnimal(Cow('Bessie'));

  // -----------------------------------------
  // PART 7: Employee Payroll System
  // -----------------------------------------

  print('\n=== Employee Payroll ===\n');

  List<Employee> employees = [
    HourlyEmployee('Alice', 25.0, 40),
    SalariedEmployee('Bob', 60000),
    CommissionEmployee('Charlie', 30000, 15000, 0.1),
    HourlyEmployee('Diana', 30.0, 45),
  ];

  double totalPayroll = 0;

  print('Payroll Report:');
  print('-' * 50);

  for (var emp in employees) {
    var pay = emp.calculatePay();
    totalPayroll += pay;
    print('${emp.name.padRight(15)} ${emp.runtimeType.toString().padRight(20)} \$${pay.toStringAsFixed(2)}');
  }

  print('-' * 50);
  print('Total Payroll: \$${totalPayroll.toStringAsFixed(2)}');

  // -----------------------------------------
  // PART 8: Plugin System
  // -----------------------------------------

  print('\n=== Plugin System ===\n');

  List<Plugin> plugins = [
    LoggingPlugin(),
    CachePlugin(),
    SecurityPlugin(),
    AnalyticsPlugin(),
  ];

  print('Starting application with plugins...\n');

  // Initialize all
  for (var plugin in plugins) {
    plugin.initialize();
  }

  print('\nRunning application...\n');

  // Execute all
  for (var plugin in plugins) {
    plugin.execute();
  }

  print('\nShutting down...\n');

  // Shutdown in reverse
  for (var plugin in plugins.reversed) {
    plugin.shutdown();
  }

  // -----------------------------------------
  // PART 9: Notification System
  // -----------------------------------------

  print('\n=== Notification System ===\n');

  List<NotificationSender> senders = [
    EmailSender('notifications@app.com'),
    SmsSender('1-800-APP'),
    PushNotificationSender('app-id-123'),
  ];

  String message = 'Your order has been shipped!';
  String recipient = 'user@email.com';

  for (var sender in senders) {
    sender.send(message, recipient);
  }

  // -----------------------------------------
  // PART 10: Drawing Application
  // -----------------------------------------

  print('\n=== Drawing Application ===\n');

  List<Drawable> canvas = [
    Line(Point2D(0, 0), Point2D(10, 10)),
    RectangleDrawable(Point2D(5, 5), 20, 15),
    CircleDrawable(Point2D(30, 30), 10),
    TextDrawable(Point2D(50, 50), 'Hello World'),
    Line(Point2D(0, 50), Point2D(100, 50)),
  ];

  print('Drawing canvas:');
  for (var item in canvas) {
    item.draw();
  }

  print('\nMoving all items by (10, 10):');
  for (var item in canvas) {
    item.move(10, 10);
  }

  print('\nRe-drawing canvas:');
  for (var item in canvas) {
    item.draw();
  }
}

// ===========================================
// CLASS DEFINITIONS
// ===========================================

// --- Basic Polymorphism ---

class Animal {
  String name;
  Animal(this.name);

  void speak() {
    print('$name makes a sound');
  }
}

class Dog extends Animal {
  Dog(String name) : super(name);

  @override
  void speak() {
    print('$name says: Woof woof!');
  }

  void fetch() {
    print('$name fetches the ball!');
  }
}

class Cat extends Animal {
  Cat(String name) : super(name);

  @override
  void speak() {
    print('$name says: Meow!');
  }

  void purr() {
    print('$name is purring...');
  }
}

class Cow extends Animal {
  Cow(String name) : super(name);

  @override
  void speak() {
    print('$name says: Moo!');
  }

  void giveMilk() {
    print('$name gives milk!');
  }
}

// --- Shape Calculator ---

abstract class Shape {
  String get name;
  double area();
}

class Rectangle extends Shape {
  double width;
  double height;

  Rectangle(this.width, this.height);

  @override
  String get name => 'Rectangle(${width}x$height)';

  @override
  double area() => width * height;
}

class Circle extends Shape {
  double radius;

  Circle(this.radius);

  @override
  String get name => 'Circle(r=$radius)';

  @override
  double area() => 3.14159 * radius * radius;
}

class Triangle extends Shape {
  double base;
  double height;

  Triangle(this.base, this.height);

  @override
  String get name => 'Triangle(b=$base, h=$height)';

  @override
  double area() => 0.5 * base * height;
}

// --- Payment Processing ---

abstract class PaymentMethod {
  String get name;
  bool processPayment(double amount);
}

class CreditCard extends PaymentMethod {
  String cardNumber;
  String holderName;

  CreditCard(this.cardNumber, this.holderName);

  @override
  String get name => 'Credit Card (*${cardNumber.substring(cardNumber.length - 4)})';

  @override
  bool processPayment(double amount) {
    print('  Charging \$${amount.toStringAsFixed(2)} to card');
    return true;
  }
}

class PayPal extends PaymentMethod {
  String email;

  PayPal(this.email);

  @override
  String get name => 'PayPal ($email)';

  @override
  bool processPayment(double amount) {
    print('  Sending \$${amount.toStringAsFixed(2)} via PayPal');
    return true;
  }
}

class BankTransfer extends PaymentMethod {
  String accountNumber;
  String bankName;

  BankTransfer(this.accountNumber, this.bankName);

  @override
  String get name => 'Bank Transfer ($bankName)';

  @override
  bool processPayment(double amount) {
    print('  Transferring \$${amount.toStringAsFixed(2)} via $bankName');
    return true;
  }
}

class Cash extends PaymentMethod {
  @override
  String get name => 'Cash';

  @override
  bool processPayment(double amount) {
    print('  Received \$${amount.toStringAsFixed(2)} in cash');
    return true;
  }
}

// --- Employee Payroll ---

abstract class Employee {
  String name;
  Employee(this.name);

  double calculatePay();
}

class HourlyEmployee extends Employee {
  double hourlyRate;
  int hoursWorked;

  HourlyEmployee(String name, this.hourlyRate, this.hoursWorked) : super(name);

  @override
  double calculatePay() {
    var regularHours = hoursWorked <= 40 ? hoursWorked : 40;
    var overtimeHours = hoursWorked > 40 ? hoursWorked - 40 : 0;
    return (regularHours * hourlyRate) + (overtimeHours * hourlyRate * 1.5);
  }
}

class SalariedEmployee extends Employee {
  double annualSalary;

  SalariedEmployee(String name, this.annualSalary) : super(name);

  @override
  double calculatePay() => annualSalary / 12;  // Monthly pay
}

class CommissionEmployee extends Employee {
  double baseSalary;
  double sales;
  double commissionRate;

  CommissionEmployee(String name, this.baseSalary, this.sales, this.commissionRate)
      : super(name);

  @override
  double calculatePay() => baseSalary / 12 + (sales * commissionRate);
}

// --- Plugin System ---

abstract class Plugin {
  String get name;
  void initialize();
  void execute();
  void shutdown();
}

class LoggingPlugin extends Plugin {
  @override
  String get name => 'Logging';

  @override
  void initialize() => print('[$name] Initializing logger...');

  @override
  void execute() => print('[$name] Logging application events...');

  @override
  void shutdown() => print('[$name] Closing log files...');
}

class CachePlugin extends Plugin {
  @override
  String get name => 'Cache';

  @override
  void initialize() => print('[$name] Setting up cache...');

  @override
  void execute() => print('[$name] Caching data...');

  @override
  void shutdown() => print('[$name] Clearing cache...');
}

class SecurityPlugin extends Plugin {
  @override
  String get name => 'Security';

  @override
  void initialize() => print('[$name] Loading security rules...');

  @override
  void execute() => print('[$name] Monitoring for threats...');

  @override
  void shutdown() => print('[$name] Security scan complete.');
}

class AnalyticsPlugin extends Plugin {
  @override
  String get name => 'Analytics';

  @override
  void initialize() => print('[$name] Connecting to analytics...');

  @override
  void execute() => print('[$name] Sending analytics data...');

  @override
  void shutdown() => print('[$name] Flushing analytics queue...');
}

// --- Notification System ---

abstract class NotificationSender {
  void send(String message, String recipient);
}

class EmailSender extends NotificationSender {
  String fromAddress;

  EmailSender(this.fromAddress);

  @override
  void send(String message, String recipient) {
    print('Sending EMAIL to $recipient');
    print('  From: $fromAddress');
    print('  Message: $message\n');
  }
}

class SmsSender extends NotificationSender {
  String fromNumber;

  SmsSender(this.fromNumber);

  @override
  void send(String message, String recipient) {
    print('Sending SMS');
    print('  From: $fromNumber');
    print('  Message: $message\n');
  }
}

class PushNotificationSender extends NotificationSender {
  String appId;

  PushNotificationSender(this.appId);

  @override
  void send(String message, String recipient) {
    print('Sending PUSH NOTIFICATION');
    print('  App: $appId');
    print('  Message: $message\n');
  }
}

// --- Drawing Application ---

class Point2D {
  double x;
  double y;

  Point2D(this.x, this.y);

  @override
  String toString() => '($x, $y)';
}

abstract class Drawable {
  void draw();
  void move(double dx, double dy);
}

class Line extends Drawable {
  Point2D start;
  Point2D end;

  Line(this.start, this.end);

  @override
  void draw() {
    print('  Line from $start to $end');
  }

  @override
  void move(double dx, double dy) {
    start.x += dx; start.y += dy;
    end.x += dx; end.y += dy;
  }
}

class RectangleDrawable extends Drawable {
  Point2D position;
  double width;
  double height;

  RectangleDrawable(this.position, this.width, this.height);

  @override
  void draw() {
    print('  Rectangle at $position, size: ${width}x$height');
  }

  @override
  void move(double dx, double dy) {
    position.x += dx;
    position.y += dy;
  }
}

class CircleDrawable extends Drawable {
  Point2D center;
  double radius;

  CircleDrawable(this.center, this.radius);

  @override
  void draw() {
    print('  Circle at $center, radius: $radius');
  }

  @override
  void move(double dx, double dy) {
    center.x += dx;
    center.y += dy;
  }
}

class TextDrawable extends Drawable {
  Point2D position;
  String text;

  TextDrawable(this.position, this.text);

  @override
  void draw() {
    print('  Text "$text" at $position');
  }

  @override
  void move(double dx, double dy) {
    position.x += dx;
    position.y += dy;
  }
}

// ===========================================
// Try it yourself:
// 1. Add a Polygon shape class
// 2. Add a CryptoPayment class
// 3. Add an ImageDrawable class
// ===========================================
