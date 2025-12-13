// ===========================================
// Example 01: Basic Classes
// Classes, Objects, Properties, and Methods
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Creating Objects
  // -----------------------------------------

  print('=== Creating Objects ===\n');

  // Create a Person object
  var alice = Person('Alice', 25);
  var bob = Person('Bob', 30);

  print('Created: ${alice.name}, age ${alice.age}');
  print('Created: ${bob.name}, age ${bob.age}');

  // -----------------------------------------
  // PART 2: Calling Methods
  // -----------------------------------------

  print('\n=== Calling Methods ===\n');

  alice.introduce();
  bob.introduce();

  alice.haveBirthday();
  alice.introduce();

  // -----------------------------------------
  // PART 3: Modifying Properties
  // -----------------------------------------

  print('\n=== Modifying Properties ===\n');

  bob.name = 'Robert';
  bob.introduce();

  // -----------------------------------------
  // PART 4: Objects Are Independent
  // -----------------------------------------

  print('\n=== Independent Objects ===\n');

  var counter1 = Counter();
  var counter2 = Counter();

  counter1.increment();
  counter1.increment();
  counter1.increment();

  counter2.increment();

  print('Counter 1: ${counter1.value}');  // 3
  print('Counter 2: ${counter2.value}');  // 1

  // -----------------------------------------
  // PART 5: Object References
  // -----------------------------------------

  print('\n=== Object References ===\n');

  var original = Person('Charlie', 40);
  var reference = original;  // Same object!

  reference.age = 45;

  print('Original age: ${original.age}');    // 45
  print('Reference age: ${reference.age}');  // 45
  print('Same object: ${identical(original, reference)}');

  // -----------------------------------------
  // PART 6: Class with List Property
  // -----------------------------------------

  print('\n=== Student with Grades ===\n');

  var student = Student('Diana', 'S001');
  student.addGrade(85);
  student.addGrade(92);
  student.addGrade(78);
  student.addGrade(95);

  student.printReport();

  // -----------------------------------------
  // PART 7: Class with Methods Returning Values
  // -----------------------------------------

  print('\n=== Rectangle Calculations ===\n');

  var rect = Rectangle(5, 3);

  print('Width: ${rect.width}');
  print('Height: ${rect.height}');
  print('Area: ${rect.calculateArea()}');
  print('Perimeter: ${rect.calculatePerimeter()}');
  print('Is Square: ${rect.isSquare()}');

  rect.scale(2);
  print('After 2x scale:');
  print('  Width: ${rect.width}');
  print('  Height: ${rect.height}');
  print('  Area: ${rect.calculateArea()}');

  // -----------------------------------------
  // PART 8: Class with Computed Properties
  // -----------------------------------------

  print('\n=== Circle with Computed Properties ===\n');

  var circle = Circle(5);

  print('Radius: ${circle.radius}');
  print('Diameter: ${circle.diameter}');
  print('Area: ${circle.area.toStringAsFixed(2)}');
  print('Circumference: ${circle.circumference.toStringAsFixed(2)}');

  circle.radius = 10;
  print('\nAfter changing radius to 10:');
  print('Diameter: ${circle.diameter}');
  print('Area: ${circle.area.toStringAsFixed(2)}');

  // -----------------------------------------
  // PART 9: Bank Account Example
  // -----------------------------------------

  print('\n=== Bank Account ===\n');

  var account = BankAccount('Alice', '1234567890');
  account.printBalance();

  account.deposit(500);
  account.deposit(200);
  account.withdraw(100);
  account.withdraw(1000);  // Should fail

  account.printBalance();

  // -----------------------------------------
  // PART 10: Todo List Example
  // -----------------------------------------

  print('\n=== Todo List ===\n');

  var todos = TodoList('My Tasks');

  todos.add('Learn Dart');
  todos.add('Build Flutter app');
  todos.add('Write tests');

  todos.printAll();

  todos.complete(0);
  todos.complete(2);

  print('\nAfter completing tasks:');
  todos.printAll();

  print('\nStats: ${todos.completedCount}/${todos.totalCount} completed');
}

// ===========================================
// CLASS DEFINITIONS
// ===========================================

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('Hi, I\'m $name and I\'m $age years old.');
  }

  void haveBirthday() {
    age++;
    print('Happy birthday $name! Now $age years old.');
  }
}

class Counter {
  int value = 0;

  void increment() {
    value++;
  }

  void decrement() {
    value--;
  }

  void reset() {
    value = 0;
  }
}

class Student {
  String name;
  String id;
  List<int> grades = [];

  Student(this.name, this.id);

  void addGrade(int grade) {
    if (grade >= 0 && grade <= 100) {
      grades.add(grade);
    }
  }

  double getAverage() {
    if (grades.isEmpty) return 0;
    return grades.reduce((a, b) => a + b) / grades.length;
  }

  String getLetterGrade() {
    var avg = getAverage();
    if (avg >= 90) return 'A';
    if (avg >= 80) return 'B';
    if (avg >= 70) return 'C';
    if (avg >= 60) return 'D';
    return 'F';
  }

  void printReport() {
    print('Student: $name (ID: $id)');
    print('Grades: $grades');
    print('Average: ${getAverage().toStringAsFixed(1)}');
    print('Letter Grade: ${getLetterGrade()}');
  }
}

class Rectangle {
  double width;
  double height;

  Rectangle(this.width, this.height);

  double calculateArea() {
    return width * height;
  }

  double calculatePerimeter() {
    return 2 * (width + height);
  }

  bool isSquare() {
    return width == height;
  }

  void scale(double factor) {
    width *= factor;
    height *= factor;
  }
}

class Circle {
  double radius;

  Circle(this.radius);

  // Computed properties (getters)
  double get diameter => radius * 2;
  double get area => 3.14159 * radius * radius;
  double get circumference => 2 * 3.14159 * radius;
}

class BankAccount {
  String owner;
  String accountNumber;
  double _balance = 0;

  BankAccount(this.owner, this.accountNumber);

  double get balance => _balance;

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('Deposited \$${amount.toStringAsFixed(2)}');
    }
  }

  bool withdraw(double amount) {
    if (amount > 0 && amount <= _balance) {
      _balance -= amount;
      print('Withdrew \$${amount.toStringAsFixed(2)}');
      return true;
    } else {
      print('Withdrawal failed: Insufficient funds or invalid amount');
      return false;
    }
  }

  void printBalance() {
    print('Account $accountNumber ($owner): \$${_balance.toStringAsFixed(2)}');
  }
}

class TodoList {
  String name;
  List<Map<String, dynamic>> _items = [];

  TodoList(this.name);

  void add(String task) {
    _items.add({
      'task': task,
      'completed': false,
    });
  }

  void complete(int index) {
    if (index >= 0 && index < _items.length) {
      _items[index]['completed'] = true;
    }
  }

  void remove(int index) {
    if (index >= 0 && index < _items.length) {
      _items.removeAt(index);
    }
  }

  int get totalCount => _items.length;

  int get completedCount =>
      _items.where((item) => item['completed'] == true).length;

  void printAll() {
    print('$name:');
    for (int i = 0; i < _items.length; i++) {
      var item = _items[i];
      var status = item['completed'] ? '✓' : '○';
      print('  $i. [$status] ${item['task']}');
    }
  }
}

// ===========================================
// Try it yourself:
// 1. Add a method to transfer money between accounts
// 2. Create a Product class with name, price, and quantity
// 3. Add a due date feature to the TodoList
// ===========================================
