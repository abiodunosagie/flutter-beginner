// Exercise 1: Person Class (SOLUTION)

class Person {
  String _name;
  int _age;
  String _email;

  Person(this._name, this._age, this._email) {
    if (_age <= 0) {
      throw ArgumentError('Age must be greater than 0');
    }
  }

  // Getters
  String get name => _name;
  int get age => _age;
  String get email => _email;

  // Setters with validation
  set name(String value) {
    if (value.isEmpty) {
      throw ArgumentError('Name cannot be empty');
    }
    _name = value;
  }

  set age(int value) {
    if (value <= 0) {
      throw ArgumentError('Age must be greater than 0');
    }
    _age = value;
  }

  set email(String value) {
    if (!value.contains('@')) {
      throw ArgumentError('Invalid email address');
    }
    _email = value;
  }

  void introduce() {
    print('Hi! My name is $_name. I am $_age years old. Email me at $_email.');
  }
}

void main() {
  print('=== Person Class Demo ===\n');

  // Create Person instances
  Person person1 = Person('Alice', 25, 'alice@email.com');
  Person person2 = Person('Bob', 30, 'bob@email.com');

  // Call introduce method
  person1.introduce();
  person2.introduce();

  // Test getters
  print('\n${person1.name} is ${person1.age} years old');

  // Test setters
  person1.age = 26;
  print('\n${person1.name} had a birthday! Now ${person1.age} years old.');

  // Test validation
  try {
    person1.age = -5;
  } catch (e) {
    print('\nValidation error: $e');
  }

  try {
    person1.email = 'invalidemail';
  } catch (e) {
    print('Validation error: $e');
  }
}
