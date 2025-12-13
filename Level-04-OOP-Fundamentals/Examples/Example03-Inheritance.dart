// ===========================================
// Example 03: Inheritance
// Extending classes and using super
// ===========================================

void main() {
  // -----------------------------------------
  // PART 1: Basic Inheritance
  // -----------------------------------------

  print('=== Basic Inheritance ===\n');

  var dog = Dog('Buddy', 3, 'Labrador');
  var cat = Cat('Whiskers', 2, true);

  print('Dog:');
  dog.eat();      // Inherited from Animal
  dog.sleep();    // Inherited from Animal
  dog.bark();     // Own method

  print('\nCat:');
  cat.eat();      // Inherited
  cat.sleep();    // Inherited
  cat.meow();     // Own method
  cat.scratch();  // Own method

  // -----------------------------------------
  // PART 2: Calling Super Constructor
  // -----------------------------------------

  print('\n=== Super Constructor ===\n');

  var employee = Employee('Alice', 30, 'E001', 'Engineering');
  employee.introduce();

  // -----------------------------------------
  // PART 3: Method Overriding
  // -----------------------------------------

  print('\n=== Method Overriding ===\n');

  var animal = Animal('Generic', 1);
  var duck = DuckAnimal('Donald', 3);
  var lion = Lion('Simba', 5);

  animal.makeSound();  // Generic animal sound
  duck.makeSound();    // Overridden: Quack!
  lion.makeSound();    // Overridden: Roar!

  // -----------------------------------------
  // PART 4: Calling Super Method
  // -----------------------------------------

  print('\n=== Calling Super Method ===\n');

  var electricCar = ElectricCar('Tesla', 'Model 3', 2023, 300);
  electricCar.displayInfo();

  // -----------------------------------------
  // PART 5: Protected Members Pattern
  // -----------------------------------------

  print('\n=== Protected Members ===\n');

  var account = SavingsAccount('Alice', 1000);
  account.deposit(500);
  account.applyInterest();
  account.showBalance();

  // -----------------------------------------
  // PART 6: Inheritance Chain
  // -----------------------------------------

  print('\n=== Inheritance Chain ===\n');

  var smartphone = Smartphone('iPhone', 'Apple', true);
  smartphone.turnOn();
  smartphone.call('555-1234');
  smartphone.takePhoto();

  // Shows all capabilities from the chain
  print('\nSmartphone capabilities:');
  print('  Is electronic: true');
  print('  Is phone: true');
  print('  Has camera: ${smartphone.hasCamera}');

  // -----------------------------------------
  // PART 7: Shape Hierarchy
  // -----------------------------------------

  print('\n=== Shape Hierarchy ===\n');

  var rectangle = RectangleShape(5, 3);
  var circle = CircleShape(4);
  var square = Square(5);

  List<Shape> shapes = [rectangle, circle, square];

  for (var shape in shapes) {
    print('${shape.name}:');
    print('  Area: ${shape.area().toStringAsFixed(2)}');
    print('  Perimeter: ${shape.perimeter().toStringAsFixed(2)}');
  }

  // -----------------------------------------
  // PART 8: Employee Hierarchy
  // -----------------------------------------

  print('\n=== Employee Hierarchy ===\n');

  var manager = Manager('Bob', 80000, 'Engineering', 5);
  var developer = Developer('Charlie', 70000, ['Dart', 'Flutter', 'Python']);
  var intern = Intern('Diana', 30000, 'Iowa State', '2024-06-01');

  List<BaseEmployee> employees = [manager, developer, intern];

  for (var emp in employees) {
    emp.work();
  }

  print('\nPayroll:');
  for (var emp in employees) {
    print('  ${emp.name}: \$${emp.calculatePay().toStringAsFixed(2)}');
  }

  // -----------------------------------------
  // PART 9: Game Character Example
  // -----------------------------------------

  print('\n=== Game Characters ===\n');

  var warrior = Warrior('Conan', 100, 20);
  var mage = Mage('Gandalf', 60, 50);
  var archer = Archer('Legolas', 70, 15);

  print('Battle begins!\n');

  warrior.attack();
  warrior.specialAbility();

  mage.attack();
  mage.specialAbility();

  archer.attack();
  archer.specialAbility();

  // -----------------------------------------
  // PART 10: UI Widget Hierarchy
  // -----------------------------------------

  print('\n=== UI Widget Hierarchy ===\n');

  var button = Button('Submit', 100, 40, 'blue');
  var textField = TextField('Enter name', 200, 40, '');
  var checkbox = Checkbox('Remember me', 20, 20, false);

  List<Widget> widgets = [button, textField, checkbox];

  print('Rendering widgets:');
  for (var widget in widgets) {
    widget.render();
  }

  print('\nInteracting:');
  button.onClick();
  (textField as TextField).onInput('John Doe');
  (checkbox as Checkbox).toggle();

  print('\nRe-rendering:');
  for (var widget in widgets) {
    widget.render();
  }
}

// ===========================================
// CLASS DEFINITIONS
// ===========================================

// --- Basic Inheritance ---

class Animal {
  String name;
  int age;

  Animal(this.name, this.age);

  void eat() {
    print('$name is eating');
  }

  void sleep() {
    print('$name is sleeping');
  }

  void makeSound() {
    print('$name makes a sound');
  }
}

class Dog extends Animal {
  String breed;

  Dog(String name, int age, this.breed) : super(name, age);

  void bark() {
    print('$name barks: Woof woof!');
  }
}

class Cat extends Animal {
  bool isIndoor;

  Cat(String name, int age, this.isIndoor) : super(name, age);

  void meow() {
    print('$name meows: Meow!');
  }

  void scratch() {
    print('$name scratches');
  }
}

class DuckAnimal extends Animal {
  DuckAnimal(String name, int age) : super(name, age);

  @override
  void makeSound() {
    print('$name says: Quack quack!');
  }
}

class Lion extends Animal {
  Lion(String name, int age) : super(name, age);

  @override
  void makeSound() {
    print('$name roars: ROAR!');
  }
}

// --- Super Constructor ---

class Person {
  String name;
  int age;

  Person(this.name, this.age);

  void introduce() {
    print('I am $name, $age years old');
  }
}

class Employee extends Person {
  String employeeId;
  String department;

  Employee(String name, int age, this.employeeId, this.department)
      : super(name, age);

  @override
  void introduce() {
    super.introduce();
    print('Employee ID: $employeeId, Department: $department');
  }
}

// --- Calling Super Method ---

class Vehicle {
  String brand;
  String model;
  int year;

  Vehicle(this.brand, this.model, this.year);

  void displayInfo() {
    print('$brand $model ($year)');
  }
}

class ElectricCar extends Vehicle {
  int range;

  ElectricCar(String brand, String model, int year, this.range)
      : super(brand, model, year);

  @override
  void displayInfo() {
    super.displayInfo();  // Call parent's method
    print('  Range: $range miles');
    print('  Type: Electric');
  }
}

// --- Protected Members Pattern ---

class BankAccount {
  String owner;
  double _balance;

  BankAccount(this.owner, this._balance);

  double get balance => _balance;

  void deposit(double amount) {
    if (amount > 0) {
      _balance += amount;
      print('Deposited \$${amount.toStringAsFixed(2)}');
    }
  }

  void showBalance() {
    print('Balance: \$${_balance.toStringAsFixed(2)}');
  }
}

class SavingsAccount extends BankAccount {
  double interestRate = 0.02;

  SavingsAccount(String owner, double initialBalance)
      : super(owner, initialBalance);

  void applyInterest() {
    var interest = _balance * interestRate;
    _balance += interest;
    print('Interest applied: \$${interest.toStringAsFixed(2)}');
  }
}

// --- Inheritance Chain ---

class Electronic {
  String name;
  bool isOn = false;

  Electronic(this.name);

  void turnOn() {
    isOn = true;
    print('$name is now ON');
  }

  void turnOff() {
    isOn = false;
    print('$name is now OFF');
  }
}

class Phone extends Electronic {
  String brand;

  Phone(String name, this.brand) : super(name);

  void call(String number) {
    if (isOn) {
      print('Calling $number...');
    } else {
      print('Turn on the phone first!');
    }
  }
}

class Smartphone extends Phone {
  bool hasCamera;

  Smartphone(String name, String brand, this.hasCamera) : super(name, brand);

  void takePhoto() {
    if (hasCamera && isOn) {
      print('Taking photo...');
    }
  }
}

// --- Shape Hierarchy ---

abstract class Shape {
  String get name;
  double area();
  double perimeter();
}

class RectangleShape extends Shape {
  double width;
  double height;

  RectangleShape(this.width, this.height);

  @override
  String get name => 'Rectangle (${width}x$height)';

  @override
  double area() => width * height;

  @override
  double perimeter() => 2 * (width + height);
}

class CircleShape extends Shape {
  double radius;

  CircleShape(this.radius);

  @override
  String get name => 'Circle (r=$radius)';

  @override
  double area() => 3.14159 * radius * radius;

  @override
  double perimeter() => 2 * 3.14159 * radius;
}

class Square extends RectangleShape {
  Square(double side) : super(side, side);

  @override
  String get name => 'Square (${width}x$height)';
}

// --- Employee Hierarchy ---

abstract class BaseEmployee {
  String name;
  double baseSalary;

  BaseEmployee(this.name, this.baseSalary);

  void work();
  double calculatePay();
}

class Manager extends BaseEmployee {
  String department;
  int teamSize;

  Manager(String name, double salary, this.department, this.teamSize)
      : super(name, salary);

  @override
  void work() {
    print('$name is managing $teamSize people in $department');
  }

  @override
  double calculatePay() => baseSalary + (teamSize * 500);  // Bonus per team member
}

class Developer extends BaseEmployee {
  List<String> skills;

  Developer(String name, double salary, this.skills) : super(name, salary);

  @override
  void work() {
    print('$name is coding with ${skills.join(", ")}');
  }

  @override
  double calculatePay() => baseSalary + (skills.length * 200);  // Skill bonus
}

class Intern extends BaseEmployee {
  String school;
  String endDate;

  Intern(String name, double salary, this.school, this.endDate)
      : super(name, salary);

  @override
  void work() {
    print('$name (intern from $school) is learning');
  }

  @override
  double calculatePay() => baseSalary * 0.5;  // Interns get half pay
}

// --- Game Characters ---

abstract class Character {
  String name;
  int health;
  int attackPower;

  Character(this.name, this.health, this.attackPower);

  void attack() {
    print('$name attacks for $attackPower damage!');
  }

  void specialAbility();
}

class Warrior extends Character {
  Warrior(String name, int health, int attack) : super(name, health, attack);

  @override
  void specialAbility() {
    print('$name uses Shield Bash! Stuns enemy!');
  }
}

class Mage extends Character {
  int mana;

  Mage(String name, int health, this.mana) : super(name, health, 10);

  @override
  void specialAbility() {
    print('$name casts Fireball! Deals ${mana * 2} magic damage!');
  }
}

class Archer extends Character {
  Archer(String name, int health, int attack) : super(name, health, attack);

  @override
  void specialAbility() {
    print('$name uses Multi-Shot! Hits 3 targets!');
  }
}

// --- UI Widget Hierarchy ---

abstract class Widget {
  double width;
  double height;

  Widget(this.width, this.height);

  void render();
}

class Button extends Widget {
  String label;
  String color;

  Button(this.label, double width, double height, this.color)
      : super(width, height);

  @override
  void render() {
    print('  [Button: "$label" (${width}x$height, $color)]');
  }

  void onClick() {
    print('  Button "$label" clicked!');
  }
}

class TextField extends Widget {
  String placeholder;
  String value;

  TextField(this.placeholder, double width, double height, this.value)
      : super(width, height);

  @override
  void render() {
    var display = value.isEmpty ? placeholder : value;
    print('  [TextField: "$display" (${width}x$height)]');
  }

  void onInput(String text) {
    value = text;
    print('  TextField updated: "$value"');
  }
}

class Checkbox extends Widget {
  String label;
  bool isChecked;

  Checkbox(this.label, double width, double height, this.isChecked)
      : super(width, height);

  @override
  void render() {
    var check = isChecked ? '✓' : '○';
    print('  [Checkbox: [$check] $label]');
  }

  void toggle() {
    isChecked = !isChecked;
    print('  Checkbox "$label" is now ${isChecked ? "checked" : "unchecked"}');
  }
}

// ===========================================
// Try it yourself:
// 1. Add a Healer character class
// 2. Create a RadioButton widget
// 3. Add a ContractEmployee class
// ===========================================
